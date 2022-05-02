<%-- 
    Document   : ajax_ticket_flow_management_new_ticket_details_load_users_by_location_id
    Created on : Mar 25, 2022, 3:55:59 PM
    Author     : JOY
--%>

<%@page import="com.ring.db.LmLocationsHasUmUser"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.db.QmSubCategories"%>
<%@page import="java.util.List"%>
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
            int locationId = Integer.parseInt(request.getParameter("locationId"));
%>
<table class="table table-bordered table-striped" id="addUserToTicket">
    <thead>
        <tr>
            <th hidden="">Id</th>
            <th>Name</th>
            <th>Designation</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td hidden=""><%=logedUser.getId()%></td>
            <td><%=logedUser.getFirstName()%> <%=logedUser.getLastName()%></td>
            <td></td>
            <td></td>
        </tr>
        <%
            List<LmLocationsHasUmUser> loadUsersByLocation = new com.ring.locationManagementModel.LMS_LM_Locations_Has_Um_User().getAllUsersByLocationId(ses, locationId);
            if(!loadUsersByLocation.isEmpty()){
                for (LmLocationsHasUmUser usersL : loadUsersByLocation) {
                    if(logedUser.getId() != usersL.getUmUser().getId()){
        %>
        <tr>
            <td hidden=""><%=usersL.getUmUser().getId()%></td>
            <td><%=usersL.getUmUser().getFirstName()%> <%=usersL.getUmUser().getLastName()%></td>
            <td></td>
            <td><button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button></td>
        </tr>
        <%}}}%>
    </tbody>
</table>
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
