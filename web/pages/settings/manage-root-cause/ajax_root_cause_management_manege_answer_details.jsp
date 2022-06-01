<%-- 
    Document   : ajax_root_cause_management_manege_answer_details
    Created on : Dec 31, 2021, 7:07:54 AM
    Author     : JOY
--%>

<%@page import="com.it.db.RcasAnswers"%>
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
             RcasAnswers selectedRCA= (RcasAnswers) ses.load(RcasAnswers.class, Integer.parseInt(request.getParameter("id")));
             if (selectedRCA != null) {
%>           
    <!--start Add Answer--> 
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header">Update Answer</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div>
                                        <label class="form-label col-form-label">Type The Answer Here</label>
                                        <input type="hidden" class="form-control" id="answerIdU" value="<%=selectedRCA.getId()%>">
                                        <input type="text" class="form-control" id="answerU" value="<%=selectedRCA.getAnswer()%>">
                                    </div>
                                    <br>
                                     <div class="row mb-3">
                                        <label class="form-label col-form-label col-md-9"></label>
                                        <div class="col-md-3" id="UPDRCABTNDIV">
                                            <button type="button" class="btn btn-green" style="width: 100%" onclick="updateAnswer()">Save Changes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end Add Answer--> 
            <%}%>
<script>
   //    function for update new Root Cause Answer
    function updateAnswer() {
        var answerU = $("#answerU").val();
        var answerIdU = $("#answerIdU").val();
        if (answerU === "") {
            swal("", "Enter Answer", "warning");
        } else {
            $.ajax({
                url: "rootCauseManagement_updateRootCauseAnswer",
                type: "POST",
                data: "answerU=" + answerU + "&answerIdU=" +answerIdU,
                beforeSend: function (xhr) {
                    $('#UPDRCABTNDIV').empty();
                    $('#UPDRCABTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        loadRootCsueAnswerDetailsToManage(<%=selectedRCA.getId()%>);
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#UPDRCABTNDIV').empty();
                    $('#UPDRCABTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='updateAnswer()'>Save Changes</button>");
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