<%-- 
    Document   : ajax_root_cause_management_manege_question_details
    Created on : Dec 31, 2021, 5:44:06 AM
    Author     : JOY
--%>

<%@page import="com.it.db.QmQueueHasQuestion"%>
<%@page import="com.it.db.RcasQuestion"%>
<%@page import="com.it.db.QmQueueHasUser"%>
<%@page import="com.it.db.QmQueue"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="java.util.List"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") == null) {
        response.sendRedirect("index.jsp");
    } else {
        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Transaction tr = ses.beginTransaction();
        tr.commit();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {
            RcasQuestion selectedRCQ = (RcasQuestion) ses.load(RcasQuestion.class, Integer.parseInt(request.getParameter("id")));
             if (selectedRCQ != null) {
%>           
    <!--start queue details-->
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header"> Manage Questions</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label>Type the Question Here</label>
                                        <input type="hidden" class="form-control" id="rcasQuestionIdU" name="rcasQuestionIdU" value="<%=selectedRCQ.getId()%>">
                                        <input type="text" class="form-control" id="rcasQuestionU" name="rcasQuestionU" value="<%=selectedRCQ.getQuestionName()%>">
                                    </div>
                                   
                                    <div class="row mb-3">
                                        <div class="form-group col-md-6">
                                            <label>Attach Queue</label>
                                            <select class="form-control" style="color: #fff" id="queueToRCU">
                                            <option selected="" value="0" style="color: #000">-- Select Queue --</option>
                                            <%
                                                List<QmQueue> loadQueueToRCU = new com.it.queueManagementModel.QMS_QM_Queue().getAllQueuesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                                if (!loadQueueToRCU.isEmpty()) {
                                                    for (QmQueue elemQRCU : loadQueueToRCU) {
                                            %>
                                            <option value="<%=elemQRCU.getId()%>" style="color: #000"><%=elemQRCU.getQueueName()%></option> 
                                            <%}
                                                }%>
                                        </select>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label></label><br>
                                            <button type="button" class="btn btn-green" onclick="addQueueDetailsToTableRCU()">Add</button>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group mb-3">
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped" id="addQueueTORCU">
                                                <thead>
                                                    <tr>
                                                        <th>#</th>
                                                        <th>Queue</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                     <%
                                            List<QmQueueHasQuestion> loadQuestionHasQueues = new com.it.rootCauseManagementModel.RCMS_QM_Queue_Has_Question().getAllRCQHasQueueByRCQId(ses, selectedRCQ.getId());
                                            if(!loadQuestionHasQueues.isEmpty()){
                                                for (QmQueueHasQuestion queuesByRCQ : loadQuestionHasQueues) {
                                                   
                                                
                                        %>  
                                        <tr>
                                            <td><%=queuesByRCQ.getQmQueue().getId()%></td>
                                            <td><%=queuesByRCQ.getQmQueue().getQueueName()%></td>
                                            <td><button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button></td>
                                        </tr>
                                        <%}}%>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    

                                    <div class="row mb-3">
                                        <label class="form-label col-form-label col-md-6"></label>
<!--                                        <div class="col-md-3">
                                            <button type="button" class="btn btn-danger" style="width: 100%">Remove</button>
                                        </div>-->
                                        <div class="col-md-3" id="UPDRCQBTNDIV">
                                            <button type="button" class="btn btn-green" style="width: 100%" onclick="updateRootCause()">Save Changes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end queue details-->
            <%}%>
<script>
    //    function for add queue to RC table
    function addQueueDetailsToTableRCU() {
         if ($('#queueToRCU option:selected').val() === "0") {
            swal("", "Select Queue", "warning");
        } else {
            var courseTable = document.getElementById("addQueueTORCU");
            var rowCount = courseTable.rows.length;
            var duplicateData = true;
            for (var r = 1; r < rowCount; r++) {
                var userId = document.getElementById("addQueueTORCU").rows[r].cells[0].innerText;
                if (userId === $('#queueToRCU option:selected').val()) {
                    duplicateData = false;
                }
            }
            if (duplicateData) {
                var row = courseTable.insertRow(1);
                $('#addQueueTORCU > tbody:last').append(row);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(1);
                var cell3 = row.insertCell(2);
//                var cell4 = row.insertCell(3);
                cell1.innerHTML = $('#queueToRCU option:selected').val();
                cell2.innerHTML = $('#queueToRCU option:selected').text();
//                cell3.innerHTML = "";
                cell3.innerHTML = "<button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>";
            } else {
                swal("Stop", "Detail Already added ...!!!!!!", "warning");
            }
        }
    }
    //    function for update Root Cause
    function updateRootCause() {
        var rcasQuestionU = $("#rcasQuestionU").val();
        var rcasQuestionIdU = $("#rcasQuestionIdU").val();
        if (rcasQuestionU === "") {
            swal("", "Enter Question Name", "warning");
        } else {
            var tb1 = document.getElementById('addQueueTORCU');
            var rowCount = tb1.rows.length;
            var ac = {AC: []};
            var newRows = 0;
            var go = 0;
            for (var t = 1; t < rowCount; t++) {
                var userId = document.getElementById("addQueueTORCU").rows[t].cells[0].innerText;
                if (userId === "" || userId === "0") {
                } else {
                    go++;
                    ac.AC.push({"queueId": userId});
                    newRows++;
                }
            }
            var queueDetails = JSON.stringify(ac);
//            alert(queueDetails);
            $.ajax({
                url: "rootCauseManagement_updateRootCauseQuestion",
                type: "POST",
                data: "rcasQuestionU=" + rcasQuestionU + "&queueDetails=" + queueDetails + "&rcasQuestionIdU=" + rcasQuestionIdU,
                beforeSend: function (xhr) {
                    $('#UPDRCQBTNDIV').empty();
                    $('#UPDRCQBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                       loadRootCsueQuestionDetailsToManage(<%=selectedRCQ.getId()%>);
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#UPDRCQBTNDIV').empty();
                    $('#UPDRCQBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='updateRootCause()'>Save Changes</button>");
                },
                error: function (error) {
                }
            });
        }
    }

</script>


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
