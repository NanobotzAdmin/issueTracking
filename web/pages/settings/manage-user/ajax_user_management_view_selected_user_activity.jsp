<%-- 
    Document   : ajax_user_management_view_selected_user_activity
    Created on : Feb 11, 2022, 12:24:10 AM
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

            UmUser selectedUserActivity = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getParameter("selectUsr")));
            if (selectedUserActivity != null) {
%> 
<!--start location activity-->
<div class="row">
    <div class="col-sm-12">
        <h1 class="page-header"> User Activities</h1>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <table id="activityTable" class="table table-striped table-bordered align-middle">
                            <thead>
                                <tr>
                                    <th>Timestamp</th>
                                    <th>Activity Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<SmSessionActivity> loadSelectedUserActivities = new com.ring.userManagementModel.UMS_UM_Session_Activity().searchActivitiesByUser(ses, selectedUserActivity.getId());
                                    if (!loadSelectedUserActivities.isEmpty()) {
                                        for (SmSessionActivity userActivity : loadSelectedUserActivities) {
                                %>
                                <tr>
                                    <td><%=userActivity.getCreatedAt()%></td>
                                    <td><%=userActivity.getDescription()%></td>
                                </tr>
                                <%}
                                        }%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--end location activity-->

<script>
    $(document).ready(function () {

        $(".default-select2").select2();

//        $('#activityTable').DataTable({
//            responsive: true
//        });
    });
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
