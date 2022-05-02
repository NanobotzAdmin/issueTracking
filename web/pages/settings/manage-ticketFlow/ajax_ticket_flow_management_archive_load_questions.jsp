<%-- 
    Document   : ajax_ticket_flow_management_archive_load_questions
    Created on : Jan 7, 2022, 1:30:38 AM
    Author     : JOY
--%>

<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.RcasAnswers"%>
<%@page import="com.ring.db.QmQueueHasQuestion"%>
<%@page import="com.ring.db.RcasQuestion"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.db.TmTickets"%>
<%@page import="com.ring.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") == null) {
        response.sendRedirect("index.jsp");
    } else {
        Session ses = com.ring.connection.Connection.getSessionFactory().openSession();
        Transaction tr = ses.beginTransaction();
        tr.commit();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {
            int queId = Integer.parseInt(request.getParameter("queueId"));
//            System.out.println("que id = " + queId);
            TmTickets selectedTicket = (TmTickets) ses.load(TmTickets.class, Integer.parseInt(request.getParameter("ticketId")));
//            System.out.println("selected Ticket = " + selectedTicket.getId());
            if (selectedTicket != null) {
%> 

<%
    List<QmQueueHasQuestion> loadQuestionByQueue = new com.ring.rootCauseManagementModel.RCMS_QM_Queue_Has_Question().getAllQueueByQueueId(ses, queId);
//    System.out.println("li size = " + loadQuestionByQueue.size());
%>
<input type="hidden" disabled="" id="liSize" value="<%=loadQuestionByQueue.size()%>">

<%
    if (!loadQuestionByQueue.isEmpty()) {
        for (QmQueueHasQuestion questinsByqueue : loadQuestionByQueue) {
%>
<div class="form-group mb-3">
    <label><%=questinsByqueue.getRcasQuestion().getQuestionName()%></label>
    <input type="hidden" disabled="" id="question<%=questinsByqueue.getRcasQuestion().getId()%>" value="<%=questinsByqueue.getRcasQuestion().getId()%>">
    <select class="default-select2 form-control" style="color: #000;border: 1px #000 solid" id="answerForQuestion<%=questinsByqueue.getRcasQuestion().getId()%>" onchange="addQandAToMap('<%=questinsByqueue.getRcasQuestion().getId()%>', this.value)">
        <option value="0" selected="" disabled="">-- Select One --</option>
        <%
            List<RcasAnswers> loadAllAnswers = new com.ring.rootCauseManagementModel.RCMS_Rcas_Answers().getAllAnswersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
            if (!loadAllAnswers.isEmpty()) {
                for (RcasAnswers answ : loadAllAnswers) {
        %>
        <option value="<%=answ.getId()%>"><%=answ.getAnswer()%></option>
        <%}
            }%>
    </select>
</div>
<%}
    }%>
    <div class="form-group mb-3" hidden="">
    <!--<label>Assigned Users</label>-->
    <div class="table-responsive">
        <table class="table table-bordered table-striped" id="addQusetionAndAnswerToTable">
            <thead>
                <tr>
                    <th>Question Id</th>
                    <th>Answer Id</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>
<div id="ARCHBTN">
    <input type="button"  class="btn btn-success" onclick="finalArchive(<%=queId%>,<%=selectedTicket.getId()%>)" value="Archive" >
</div>

<script type="text/javascript">

    $(document).ready(function () {
        $(".default-select2").select2();
    });

    function addQandAToMap(questionId, answerId) {
        var courseTable = document.getElementById("addQusetionAndAnswerToTable");
        var rowCount = courseTable.rows.length;
        var duplicateData = true;
        for (var r = 1; r < rowCount; r++) {
            var questiont = document.getElementById("addQusetionAndAnswerToTable").rows[r].cells[0].innerText;
//                alert("tabel question =|"+questiont+"|");
            var answer = document.getElementById("addQusetionAndAnswerToTable").rows[r].cells[1].innerText;
//                alert("tabel answer =|"+answer+"|");
            if (questionId === questiont || answer === answerId) {
//                    alert("false");
                duplicateData = false;
            }
        }
        if (duplicateData) {
            var row = courseTable.insertRow(1);
            $('#addQusetionAndAnswerToTable > tbody:last').append(row);
            var cell1 = row.insertCell(0);
            var cell2 = row.insertCell(1);
            cell1.innerHTML = questionId;
            cell2.innerHTML = answerId;
        }
    }

    function finalArchive(quId,ticketId) {
        var qCount  = $("#liSize").val();
        var ac = {AC: []};
        var tb1 = document.getElementById('addQusetionAndAnswerToTable');
        var rowCount = tb1.rows.length;
        var newRows = 0;
        var go = 0;
        for (var t = 1; t < rowCount; t++) {
            var questionIdFinal = document.getElementById("addQusetionAndAnswerToTable").rows[t].cells[0].innerText;
            var answerIdFinal = document.getElementById("addQusetionAndAnswerToTable").rows[t].cells[1].innerText;
            if (questionIdFinal === "" || questionIdFinal === "0" || answerIdFinal === "" || answerIdFinal === "0" ) {
            } else {
                go++;
                ac.AC.push({"questionIdFinal": questionIdFinal,"answerIdFinal":answerIdFinal});
                newRows++;
            }
        }

        var questionDetails = JSON.stringify(ac);
//        alert(questionDetails);
//        alert("go = "+go);
//        alert("q Co = " + qCount);
        if(go == qCount){
             $.ajax({
            url: "ticketManagement_archiveTicket",
            type: "POST",
            data: "questionDetails=" + questionDetails + "&ticketId=" + ticketId + "&quId=" + quId,
            beforeSend: function (xhr) {
            },
            success: function (data) {
                var resultValue = JSON.parse(data);
                if (resultValue.result === "0") {
                    swal("", resultValue.displayMessage, "error");
                } else if (resultValue.result === "2") {
                    swal("", resultValue.displayMessage, "error");
                    setTimeout(function () {
                        window.location.href = "../../../index.jsp";
                    }, 2000);
                } else if (resultValue.result === "1") {
                     confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
            },
            error: function (error) {
            }
        });
        }else{
             swal("", "Answer the All Questions", "warning");
        }

    }



</script>

<%}%>

<%        } catch (Exception e) {
            logger.error(logedUser.getId() + " - " + logedUser.getFirstName() + " : " + e.toString());
        } finally {
            logedUser = null;
            logger = null;
            ses.clear();
            ses.close();
            System.gc();
        }
    }
%>
