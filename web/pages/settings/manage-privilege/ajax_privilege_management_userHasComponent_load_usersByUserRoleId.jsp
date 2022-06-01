<%-- 
    Document   : ajax_privilege_management_userHasComponent_load_usersByUserRoleId
    Created on : Nov 26, 2021, 6:40:16 AM
    Author     : JOY
--%>

<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="java.util.List"%>
<%@page import="com.it.db.PmUserRole"%>
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
        //Get active user object
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {
            PmUserRole selectedUserRole = (PmUserRole) ses.load(PmUserRole.class, Integer.parseInt(request.getParameter("userRoleId")));
            if (selectedUserRole != null) {
%>
<label class="form-label">Select User</label>
<select class="default-select2 form-control" id="loadUsersForPrivilage" name="loadUsersForPrivilage" style="width: 100%;color: #000" onchange="changeTopics2()">
    <option value="0">-- Select User --</option>
    <%        List<UmUser> loadUsersByUserRole = new com.it.userManagementModel.UMS_UM_User().searchUsersByStatusAndUserRole(ses, selectedUserRole.getId(), STATIC_DATA_MODEL.PMALL);
        if (!loadUsersByUserRole.isEmpty()) {
            for (UmUser elem : loadUsersByUserRole) {
    %>
    <option value="<%=elem.getId()%>"><%=elem.getFirstName()%></option>
    <%}
        }%>
</select>
<%    }%>
<%        } catch (Exception e) {
            logger.error(logedUser.getId() + " - " + logedUser.getFirstName()+ " : " + e.toString());
        } finally {
            logedUser = null;
            logger = null;
            ses.clear();
            ses.close();
            System.gc();
        }
    }
%>
