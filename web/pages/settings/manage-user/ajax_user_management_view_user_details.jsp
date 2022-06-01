<%-- 
    Document   : ajax_user_management_view_user_details
    Created on : Jan 3, 2022, 9:50:14 PM
    Author     : JOY
--%>

<%@page import="org.hibernate.Transaction"%>
<%@page import="com.it.db.QmQueueHasUser"%>
<%@page import="com.it.db.TmTickets"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="java.util.List"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
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

            UmUser selectedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getParameter("id")));
            if (selectedUser != null) {
%> 
<!--start user profile-->
<h1 class="page-header">User Profile</h1>
<div class="panel panel-inverse">
    <div class="panel-body">
        <div class="card">
            <div class="card-body">
                <div class="row">
                    <div class="col-sm-4 p-4">
                        <img src="${pageContext.request.contextPath}/ImageServlet/<%=selectedUser.getRemark1()%>" class="squreImg" style="min-width: 80px; max-width: 100%;min-height: 80px;">  <br>
                        <label>System Admin</label>
                    </div>
                    <div class="col-sm-8 p-5">

                        <div class="row">
                            <div class="col">Name</div>
                            <div class="col"><%=selectedUser.getFirstName()%> <%=selectedUser.getLastName()%></div>
                        </div>
                        <div class="row">
                            <div class="col">NIC</div>
                            <div class="col"><%=selectedUser.getNicOrPassport()%></div>
                        </div>
                        <div class="row">
                            <div class="col">Employee ID</div>
                            <div class="col"><%=selectedUser.getRemark2()%></div>
                        </div>
                        <div class="row">
                            <div class="col">Mobile</div>
                            <div class="col"><%=selectedUser.getMobileNumber()%></div>
                        </div>
                        <div class="row">
                            <div class="col">eMail</div>
                            <div class="col"><%=selectedUser.getEmailAddress()%></div>
                        </div>
                        <div class="row">
                            <div class="col">Date of Birth</div>
                            <div class="col"><%=selectedUser.getDateOfBirth()%></div>
                        </div>
                        <div class="row">
                            <div class="col">Gender</div>
                            <div class="col">
                                <%
                                     if(selectedUser.getGender() != null){
                                    if (selectedUser.getGender() == 1) {
                                        out.write("Male");
                                    } else {
                                        out.write("Female");
                                    }
                                     }else{
                                          out.write("--");
                                     }
                                %>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col">
                               Martial Status
                            </div>
                            <div class="col"><%=selectedUser.getMaritialStatus()%></div>
                        </div>

                    </div>
                </div>
                <br>
                <div class="accordion" id="accordion">
                    <div class="accordion-item border-0">
                        <div class="accordion-header" id="headingOne">
                            <button class="accordion-button bg-gray-600 text-white px-3 py-10px pointer-cursor" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
                                <%
//                                            get user assigned active tickets
                                    List<Object[]> loadUserAssignedActiveTickets = new com.it.ticketManagementModel.TMS_TM_Tickets().getUserAssignedActiveTicket(ses, selectedUser.getId(), STATIC_DATA_MODEL.TICKETACTIVE);
                                %>
                                Active Assigned Tickets &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="badge bg-primary"><%=loadUserAssignedActiveTickets.size()%></span>
                            </button>
                        </div>
                        <div id="collapseOne" class="accordion-collapse collapse " data-bs-parent="#accordion">
                            <div class="accordion-body bg-gray-400 text-white">
                                <table style="width: 70%">
                                    <tbody>
                                        <%
                                            if (!loadUserAssignedActiveTickets.isEmpty()) {
                                                for (Object[] list1 : loadUserAssignedActiveTickets) {
                                                    TmTickets ticketsByque = (TmTickets) ses.load(TmTickets.class, (Integer) list1[0]);
                                        %>
                                        <tr>
                                            <td><%=ticketsByque.getTid()%></td>
                                            <td><%=ticketsByque.getQmQueue().getQueueName()%></td>
                                            <td><a class="btn btn-white btn-xs" onclick="viewTicketDetails(<%=ticketsByque.getId()%>)">view</a></td>
                                        </tr>
                                        <%}
                                            }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item border-0">
                        <div class="accordion-header" id="headingTwo">
                            <button class="accordion-button bg-gray-600 text-white px-3 py-10px pointer-cursor" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo">
                                <%
                                    List<TmTickets> loadUserCreatedActiveTickets = new com.it.ticketManagementModel.TMS_TM_Tickets().getUserCreatedActiveTickets(ses, selectedUser.getId(), STATIC_DATA_MODEL.TICKETACTIVE);
                                %>
                                Active Created Tickets &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="badge bg-success"><%=loadUserCreatedActiveTickets.size()%></span>
                            </button>
                        </div>
                        <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#accordion">
                            <div class="accordion-body bg-gray-400 text-white">
                                <table style="width: 70%">
                                    <tbody>
                                        <%
                                            if (!loadUserCreatedActiveTickets.isEmpty()) {
                                                for (TmTickets list2 : loadUserCreatedActiveTickets) {
                                        %>
                                        <tr>
                                            <td><%=list2.getTid()%></td>
                                            <td><%=list2.getQmQueue().getQueueName()%></td>
                                            <td><a class="btn btn-white btn-xs" onclick="viewTicketDetails(<%=list2.getId()%>)">view</a></td>
                                        </tr>
                                        <%}
                                            }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item border-0">
                        <div class="accordion-header" id="headingThree">
                            <button class="accordion-button bg-gray-600 text-white px-3 py-10px pointer-cursor" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree">
                                <%
//                                            get user assigned complete tickets
                                    List<Object[]> loadUserAssignedCompleteTickets = new com.it.ticketManagementModel.TMS_TM_Tickets().getUserAssignedCompleteTicket(ses, selectedUser.getId(), STATIC_DATA_MODEL.TICKETCOMPLETED, STATIC_DATA_MODEL.TICKETCONFIRMED);
                                %>
                                Completed Assigned Tickets &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="badge bg-warning"><%=loadUserAssignedCompleteTickets.size()%></span>
                            </button>
                        </div>
                        <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="#accordion">
                            <div class="accordion-body bg-gray-400 text-white">
                                <table style="width: 70%">
                                    <tbody>
                                        <%
                                            if (!loadUserAssignedCompleteTickets.isEmpty()) {
                                                for (Object[] list3 : loadUserAssignedCompleteTickets) {
                                                    TmTickets ticketsByque2 = (TmTickets) ses.load(TmTickets.class, (Integer) list3[0]);
                                        %>
                                        <tr>
                                            <td><%=ticketsByque2.getTid()%></td>
                                            <td><%=ticketsByque2.getQmQueue().getQueueName()%></td>
                                            <td><a class="btn btn-white btn-xs" onclick="viewTicketDetails(<%=ticketsByque2.getId()%>)">view</a></td>
                                        </tr>
                                        <%}
                                            }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item border-0">
                        <div class="accordion-header" id="headingFour">
                            <button class="accordion-button bg-gray-600 text-white px-3 py-10px pointer-cursor" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour">
                                <%
                                    List<TmTickets> loadUserCreatedCompleteTickets = new com.it.ticketManagementModel.TMS_TM_Tickets().getUserCreatedCompleteTickets(ses, selectedUser.getId(), STATIC_DATA_MODEL.TICKETCOMPLETED, STATIC_DATA_MODEL.TICKETCONFIRMED);
                                %>
                                Completed Created Tickets &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="badge bg-danger"><%=loadUserCreatedCompleteTickets.size()%></span>
                            </button>
                        </div>
                        <div id="collapseFour" class="accordion-collapse collapse" data-bs-parent="#accordion">
                            <div class="accordion-body bg-gray-400 text-white">
                                <table style="width: 70%">
                                    <tbody>
                                        <%
                                            if (!loadUserCreatedCompleteTickets.isEmpty()) {
                                                for (TmTickets list4 : loadUserCreatedCompleteTickets) {
                                        %>
                                        <tr>
                                            <td><%=list4.getTid()%></td>
                                            <td><%=list4.getQmQueue().getQueueName()%></td>
                                            <td><a class="btn btn-white btn-xs" onclick="viewTicketDetails(<%=list4.getId()%>)">view</a></td>
                                        </tr>
                                        <%}
                                            }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item border-0">
                        <div class="accordion-header" id="headingFive">
                            <button class="accordion-button bg-gray-600 text-white px-3 py-10px pointer-cursor" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFive">
                                <%
                                    List<QmQueueHasUser> loadUserAssignedQueues = new com.it.queueManagementModel.QMS_QM_Queue_Has_User().getQueuesByUserId(ses, selectedUser.getId());
                                %>
                                Assigned Queues &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="badge bg-purple"><%=loadUserAssignedQueues.size()%></span>
                            </button>
                        </div>
                        <div id="collapseFive" class="accordion-collapse collapse" data-bs-parent="#accordion">
                            <div class="accordion-body bg-gray-400 text-white">
                                <!--                                <table style="width: 70%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>#BD2325</td>
                                                                            <td>IT < Software Engineer < HR</td>
                                                                            <td>View Ticket</td>
                                                                        </tr>
                                                                    </tbody> 
                                                                </table>-->
                            </div>
                        </div>
                    </div>
                </div>
                <br>

                <div class="form-group mb-1" id="ACTVDIV">
                    <button type="button" class="btn btn-white btn-sm d-block" style="width: 100%" onclick="loadSelecctedUserActivityView(<%=selectedUser.getId()%>)">View Activity</button>
                </div>
                <div class="form-group mb-1" id="PWDRSTDIV">
                    <button type="button" class="btn btn-success btn-sm d-block" style="width: 100%" onclick="loadPasswordResetPage(<%=selectedUser.getId()%>)">Password Reset</button>
                </div>
                <div class="form-group">
                    <button type="button" class="btn btn-danger btn-sm d-block" style="width: 100%">Disable Account</button>
                </div>
                <div class="form-group">
                    <button type="button" class="btn btn-warning btn-sm d-block" style="width: 100%" onclick="loadUserProfileUpdateView(<%=selectedUser.getId()%>)">Update</button>
                </div>
            </div>
        </div>
    </div>
</div>
<!--end user profile-->
<!--end create new user-->
<script type="text/javascript">
    function viewTicketDetails(ticketId) {
        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_ViewTicketDetailsPage.jsp",
            type: "POST",
            data: "ticketId=" + ticketId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    function loadSelecctedUserActivityView(userId) {
        $.ajax({
            url: "pages/settings/manage-user/ajax_user_management_view_selected_user_activity.jsp",
            type: "POST",
            data: "selectUsr=" + userId,
            beforeSend: function (xhr) {
                $('#ACTVDIV').empty();
                $('#ACTVDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
            },
            complete: function () {
            },
            success: function (data) {
                setTimeout(function () {
                    $('#right_content_div').html(data);
                    $('#ACTVDIV').empty();
                    $('#ACTVDIV').html("<button type='button' class='btn btn-white btn-sm d-block' style='width: 100%' onclick='loadSelecctedUserActivityView('" + userId + "')'>View Activity</button>");
                }, 4000);
            }
        });
    }
    function loadPasswordResetPage(userId) {
        $.ajax({
            url: "pages/settings/manage-user/ajax_user_management_reset_password.jsp",
            type: "POST",
            data: "selectUsr=" + userId,
            beforeSend: function (xhr) {
                $('#PWDRSTDIV').empty();
                $('#PWDRSTDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
            },
            complete: function () {
            },
            success: function (data) {
                setTimeout(function () {
                    $('#right_content_div').html(data);
                    $('#PWDRSTDIV').empty();
                    $('#PWDRSTDIV').html("<button type='button' class='btn btn-success btn-sm d-block' style='width: 100%' onclick='loadPasswordResetPage('" + userId + "')'>Password Reset</button>");
                }, 1000);
            }
        });
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