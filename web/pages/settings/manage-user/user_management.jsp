<%-- 
    Document   : user_management
    Created on : Nov 24, 2021, 1:39:34 AM
    Author     : JOY
--%>

<%@page import="com.it.configurationModel.EMAIL_MODEL"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.UmUserHasInterfaceComponent"%>
<%@page import="com.it.db.PmInterfaceComponent"%>
<%@page import="java.util.List"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") != null) {
        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Logger logger = Logger.getLogger(this.getClass().getName());
        Transaction tr = ses.beginTransaction();
        tr.commit();
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        String gg = (request.getParameter("pageUrl"));
        int pid = Integer.parseInt(request.getParameter("interface"));
        String content_prefix = "../../";
        try {
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

        <h1 class="page-header">User Management</h1>
        <%
            List<PmInterfaceComponent> getComponentByIterfaceId = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, pid);
            boolean userManagementMain = false;

            if (!getComponentByIterfaceId.isEmpty()) {
                for (PmInterfaceComponent cmpt : getComponentByIterfaceId) {
                    UmUserHasInterfaceComponent getUserHasComponentByUserAndComponentId = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, logedUser.getId(), cmpt.getId());
                    if (getUserHasComponentByUserAndComponentId != null) {
                        if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("USERMAINCOMPONENT")) {
                            userManagementMain = true;
                        }

                    }
                }
            }
        %>
        <%
            if (userManagementMain) {
        %>  


        <div class="form-group row">
            <h4 class="col-sm-9"></h4>
            <div class="col-sm-3">
                <button type="button" class="btn btn-outline-success" style="width: 100%"  onclick="newUserDetails('<%=pid%>', '<%=gg%>')">Create User</button>
                <!--<button type="button" class="btn btn-outline-success" style="width: 100%" id="allMailBTN" onclick="()">Send Mail To All</button>-->
            </div>
        </div>
        <br>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <table id="data-table-default" class="table table-striped table-bordered align-middle">
                            <thead>
                                <tr>
                                    <th width="1%">EID</th>
                                    <th>Name</th>
                                    <th class="text-nowrap">Locations</th>
                                    <th class="text-nowrap">Queues</th>
                                    <th class="text-nowrap">Designation</th>
                                    <th class="text-nowrap">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<UmUser> loadAllUsers = new com.it.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                    if (!loadAllUsers.isEmpty()) {
                                        for (UmUser elem : loadAllUsers) {
                                %>
                                <tr class="odd gradeX">
                                    <td><%=elem.getId()%></td>
                                    <td><%=elem.getFirstName()%> <%=elem.getLastName()%></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <button class="btn btn-outline-info btn-xs" onclick="loadUserProfile(<%=elem.getId()%>)">View</button>
                                        <button class="btn btn-outline-success btn-xs" id="mlBTN<%=elem.getId()%>" onclick="sendMail(<%=elem.getId()%>)">Send Email</button>
                                    </td>
                                </tr>
                                <%}
                                    }%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>




        <!--        start create new user
                <h1 class="page-header">Create New User</h1>
                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <div class="card">
                            <div class="card-body">
                                <h4 style="text-align: center">~~Personal Details~~</h4><br>
                                <div class="form-group mb-3">
                                    <label>First Name</label>
                                    <input type="text" class="form-control" id="fName" name="fName">
                                </div>
                                <div class="form-group mb-3">
                                    <label>Last Name</label>
                                    <input type="text" class="form-control" id="lName" name="lName">
                                </div>
                                <div class="row mb-3">
                                    <div class="form-group col-md-6">
                                        <label>NIC or Passport</label>
                                        <input type="text" class="form-control" id="nic" name="nic">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>Date of Birth</label>
                                        <input type="text" class="form-control" id="datepicker-autoClose"/>
                                    </div>
                                </div>
                                <div class="form-group mb-3">
                                    <label>Mobile</label>
                                    <input type="text" class="form-control" id="mobile" name="mobile">
                                </div>
                                <div class="form-group mb-3">
                                    <label>E-mail</label>
                                    <input type="email" class="form-control" id="email" name="email">
                                </div>
                                <div class="row mb-3">
                                    <div class="form-group col-md-6">
                                        <label>Gender</label>
                                        <select class="form-control" id="gender" name="gender">
                                            <option></option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>Marital Status</label>
                                        <select class="form-control" id="maritalStatus" name="maritalStatus">
                                            <option></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3">
                                    <label>User Role</label>
                                    <select class="default-select2 form-control" id="designation" name="designation">
                                        <option>Select One</option>
                                    </select>
                                </div>
                                <div class="form-group mb-3">
                                    <label>Locations</label>
                                    <ul id="jquery-tagIt-warning" class="tagitLocation warning tagit">
                                        <li>tag 1</li>
                                        <li>tag 2</li>
                                    </ul>
                                </div>
                                <div class="form-group mb-3">
                                    <label>Employee ID</label>
                                    <input type="text" class="form-control" id="empId" name="empId">
                                </div>
                                <hr>
                                <h4 style="text-align: center">~~Login Details~~</h4><br>
                                <div class="form-group mb-3">
                                    <label>Username</label>
                                    <input type="text" class="form-control" id="uname" name="uname">
                                </div>
                                <div class="form-group mb-3">
                                    <label>Password</label>
                                    <input type="password" class="form-control" id="pass" name="pass">
                                </div>
                                <div class="form-group mb-3">
                                    <label>Confirm Password</label>
                                    <input type="password" class="form-control" id="Cpass" name="Cpass">
                                </div>
        
                                <div class="form-group row mb-3">
                                    <label class="col-sm-8"></label>
                                    <div class="col-sm-2">
                                        <button type="button" class="btn btn-info" style="width: 100%">Profile</button>
                                    </div>
                                    <div class="col-sm-2">
                                        <button type="button" class="btn btn-success" style="width: 100%">Save</button>
                                    </div>
                                </div>
        
                            </div>
                        </div>
                    </div>
                </div>
                end create new user-->



        <!--start user activity-->
        <!--        <h1 class="page-header">User Activity</h1>
        
                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <div class="card">
                            <div class="card-body">
                                <table class="table table-striped table-bordered align-middle table-sm" style="width: 100%">
                                    <thead>
                                        <tr>
                                            <th width="1%">Timestamp</th>
                                            <th class="text-nowrap">Activity Feature</th>
                                            <th class="text-nowrap">Activity Description</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="odd gradeX">
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>-->
        <!--end user activity-->


        <script type="text/javascript">
            $(document).ready(function () {

                $(".default-select2").select2();

                $('#data-table-default').DataTable({
                    responsive: true
                });

//                $("#datepicker-autoClose").datepicker({
//                    todayHighlight: true,
//                    autoclose: true,
//                   format: "yyyy/mm/dd"
//                });
//
//                $(".tagitLocation").tagit({
//                    availableTags: ["maharagama", "navala medicore", "townhall", "grandpass", "avissawella", "kandy CC", "head office"]
//                });
            });

            //    function for load add new User details
            function newUserDetails(pId, gg) {
                $.ajax({
                    url: "pages/settings/manage-user/ajax_user_management_create_new_user_details.jsp",
                    type: "POST",
                    data: "interfaceId=" + pId + "&pageUrl=" + gg,
                    beforeSend: function (xhr) {
                    },
                    complete: function () {
                    },
                    success: function (data) {
                        $('#right_content_div').html(data);
                    }
                });
            }
            //    function for load ViewUser details
            function loadUserProfile(id) {
                $.ajax({
                    url: "pages/settings/manage-user/ajax_user_management_view_user_details.jsp",
                    type: "POST",
                    data: "interfaceId=" + <%=pid%> + "&id=" + id,
                    beforeSend: function (xhr) {
                    },
                    complete: function () {
                    },
                    success: function (data) {
                        $('#right_content_div').html(data);
                    }
                });
            }
            function sendMail(id) {
                $.ajax({
                    url: "userManagement_sendMail",
                    type: "POST",
                    data: "id=" + id,
                    beforeSend: function (xhr) {
                        $('#mlBTN' + id).empty();
                        $('#mlBTN' + id).html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
                    },
                    success: function (data) {
                        var resultValue = JSON.parse(data);
                        if (resultValue.result === "0") {
                            $('#mlBTN' + id).empty();
                            $('#mlBTN' + id).html("<button type='button' class='btn btn-outline-success btn-xs' id='mlBTN'"+id+"' onclick='sendMail('"+id+"')'>Send Email</button>");
                            swal("", resultValue.displayMessage, "error");
                        } else if (resultValue.result === "2") {
                            swal("", resultValue.displayMessage, "error");
                            setTimeout(function () {
                                window.location.href = "../../../index.jsp";
                            }, 2000);
                        } else if (resultValue.result === "1") {
                            loadPage('<%=gg%>',<%=pid%>)
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
            }
//            function sendMailToAllUsers() {
//                $.ajax({
//                    url: "userManagement_sendMailsToAllUsers",
//                    type: "POST",
//                    beforeSend: function (xhr) {
//                        $('#allMailBTN').empty();
//                        $('#allMailBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
//                    },
//                    success: function (data) {
//                        var resultValue = JSON.parse(data);
//                        if (resultValue.result === "0") {
//                            $('#allMailBTN').empty();
//                            $('#allMailBTN').html("<button type='button' class='btn btn-outline-success' style='width: 100%'  onclick='sendMailToAllUsers()'>Send Mail To All</button>");
//                            swal("", resultValue.displayMessage, "error");
//                        } else if (resultValue.result === "2") {
//                            swal("", resultValue.displayMessage, "error");
//                            setTimeout(function () {
//                                window.location.href = "../../../index.jsp";
//                            }, 2000);
//                        } else if (resultValue.result === "1") {
//                            loadPage('<%=gg%>',<%=pid%>)
//                            swal({
//                                title: "Done",
//                                text: resultValue.displayMessage,
//                                timer: 1000,
//                                showConfirmButton: false
//                            });
//                        }
//
//                    },
//                    error: function (error) {
//                    }
//                });
//            }
            //    function for load ViewUser details
            function loadUserProfileUpdateView(id) {
                $.ajax({
                    url: "pages/settings/manage-user/ajax_user_management_edit_profile_details.jsp",
                    type: "POST",
                    data: "interfaceId=" + <%=pid%> + "&id=" + id,
                    beforeSend: function (xhr) {
                    },
                    complete: function () {
                    },
                    success: function (data) {
                        $('#right_content_div').html(data);
                    }
                });
            }

        </script>





    </body>
</html>
<%} else {
        response.sendRedirect("home.jsp");
    }%>


<%        } catch (Exception e) {
        logger.error(logedUser.getId() + " - " + logedUser.getFirstName() + " : " + e.toString());
    } finally {
        logger = null;
        logedUser = null;
        ses.clear();
        ses.close();
        System.gc();
    }

%>




<%} else {
        response.sendRedirect("index.jsp");

    }%>