<%-- 
    Document   : ticketsTimeLine
    Created on : Feb 1, 2022, 1:57:08 PM
    Author     : buddh
--%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.it.db.SmSessionActivity"%>
<%@page import="java.util.List"%>
<%@page import="com.it.userManagementModel.UMS_UM_Session_Activity"%>
<%@page import="com.it.db.TmTickets"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Session ses = com.it.connection.Connection.getSessionFactory().openSession();
    String ticketNumber = request.getParameter("ticketNumber");
    TmTickets selectedTicket = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketByKey(ses, ticketNumber);
    if(selectedTicket == null){
        %>
        <h1>Ticket Not Found</h1>
        
    <%}else{
    List<SmSessionActivity> ticketActivityList = new com.it.userManagementModel.UMS_UM_Session_Activity().searchActivitiesByTicketIdToTimeLine(ses, selectedTicket.getId(), STATIC_DATA_MODEL.TICKETMANAGEMENT, STATIC_DATA_MODEL.TICKETREPLYMANAGEMENT);
    if (!ticketActivityList.isEmpty()) {
        for (SmSessionActivity ticketActivity : ticketActivityList) {
%>
<!-- BEGIN timeline-item -->
<div class="timeline-item">
    <!-- BEGIN timeline-time -->
    <div class="timeline-time">
        <%;
            SimpleDateFormat date = new SimpleDateFormat("dd-MM-YYYY");
            SimpleDateFormat time = new SimpleDateFormat("HH:mm:ss");
            String activityDate = date.format(ticketActivity.getCreatedAt());
            String activityTime = time.format(ticketActivity.getCreatedAt());
            String today = date.format(new Date());
            if (activityDate.equals(today)) {
                activityDate = "Today";
            }
        %>
        <span class="date"><%=activityDate%></span>
        <span class="time"><%=activityTime%></span>
    </div>
    <!-- END timeline-time -->
    <!-- BEGIN timeline-icon -->
    <div class="timeline-icon">
        <a href="javascript:;">&nbsp;</a>
    </div>
    <!-- END timeline-icon -->
    <!-- BEGIN timeline-content -->
    <div class="timeline-content">
        <!-- BEGIN timeline-body -->
        <div class="timeline-body">
            <!-- timeline-post -->
            <div class="mb-3">
                <div class="mb-2">
                    <%=ticketActivity.getDescription()%>
                </div>
            </div>
        </div>
        <!-- END timeline-body -->
    </div>
    <!-- END timeline-content -->
</div>
<%}
    }}
%>
<!-- END timeline-item -->
