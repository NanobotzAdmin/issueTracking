<%-- 
    Document   : ajax_user_management_reset_password
    Created on : Feb 11, 2022, 12:59:36 AM
    Author     : JOY
--%>

<%@page import="com.ring.db.SmSessionActivity"%>
<%@page import="com.ring.db.LmLocationHistory"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.db.LmLocations"%>
<%@page import="com.ring.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Transaction"%>
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
//        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {

            UmUser selectedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getParameter("selectUsr")));
            if (selectedUser != null) {
%> 
<!--start location activity-->
<div class="row">
    <div class="col-sm-12">
        <h1 class="page-header"> Reset Password</h1>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <label>New Password</label>
                        <input type="text" id="newPassword" required="">
                        <br>
                        <label>Confirm Password</label>
                        <input type="text" id="confirmNewPassword" required="">
                        <div id="USRPSSRSTDIV">
                        <button type="button" class="btn btn-success btn-sm d-block" style="width: 100%" onclick="resetPassword(<%=selectedUser.getId()%>)">Password Reset</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--end location activity-->

<script>
//   function for reset user password
    function resetPassword(userId) {

        var newpassword = $("#newPassword").val();
        var confirmNewpassword = $("#confirmNewPassword").val();

        if (newpassword !== confirmNewpassword) {
            swal("", "Password Not Mached", "warning");
        } else {

            $.ajax({
                url: "userManagement_resetUserPassword",
                type: "POST",
                data: "confirmNewpassword=" + confirmNewpassword + "&userId=" + userId,
                beforeSend: function (xhr) {
                    $('#USRPSSRSTDIV').empty();
                    $('#USRPSSRSTDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        location.reload();
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#USRPSSRSTDIV').empty();
                    $('#USRPSSRSTDIV').html("<button type='button' class='btn btn-success btn-sm d-block' style='width: 100%' onclick='resetPassword('"+userId+"')'>Password Reset</button>");
                },
                error: function (error) {
                }
            });
        }
    }





</script>


<%}%>

<%        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            logedUser = null;
            ses.clear();
            ses.close();
            System.gc();
        }
    }
%>
