<%-- 
    Document   : ajax_ticket_flow_management_load_tickets_by_filters
    Created on : Feb 11, 2022, 1:59:37 AM
    Author     : JOY
--%>

<%@page import="com.it.db.TmTickets"%>
<%@page import="com.it.db.TmTicketsHasUmUser"%>
<%@page import="com.it.db.QmSubCategories"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.QmQueueHasUser"%>
<%@page import="com.it.db.QmCategories"%>
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
            int pid = Integer.parseInt(request.getParameter("interfaceId"));
            int quId = Integer.parseInt(request.getParameter("quIdToNewTicket"));
            int catId = Integer.parseInt(request.getParameter("catForTicket"));
            int subCatId = Integer.parseInt(request.getParameter("subForTicket"));
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");


%> 

<table id="data-table-default" class="table table-striped table-bordered align-middle table-sm">
    <thead>
        <tr>
            <th width="1%">TID</th>
            <th class="text-nowrap">Ticket Title</th>
            <th class="text-nowrap">Category</th>
            <th class="text-nowrap">Location</th>
            <th class="text-nowrap">Status</th>
            <th  data-orderable="false">Assigned</th>
            <th class="text-nowrap">Action</th>
        </tr>
    </thead>
    <tbody>
        <%//            List<Object[]> loadTicketsByUserANdQueue2 = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsByUserIdAndQueueIdByDateRange(ses, logedUser.getId(), quId, catId, subCatId,startDate,endDate);
//            if (!loadTicketsByUserANdQueue2.isEmpty()) {
//                for (Object[] data2 : loadTicketsByUserANdQueue2) {
//                    TmTickets ticketsByque = (TmTickets) ses.load(TmTickets.class, (Integer) data2[0]);
            List<TmTickets> loadTicketsByFilters = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsByQueueOrCatOrSubCatAndDateRange(ses, quId, catId, subCatId, startDate, endDate);
            if (!loadTicketsByFilters.isEmpty()) {
                for (TmTickets ticketsByque : loadTicketsByFilters) {

        %>
        <tr >
            <td width="1%" class="fw-bold text-white"><%=ticketsByque.getTid()%></td>
            <td><%=ticketsByque.getTicketName()%></td>
            <td>
                <%
                    if (ticketsByque.getQmCategories() != null) {
                        out.write(ticketsByque.getQmCategories().getCategoryName());
                    } else {
                        out.write("--");
                    }
                %>
            </td>
            <td>
                <%
                    if (ticketsByque.getLmLocations() != null) {
                        out.write(ticketsByque.getLmLocations().getLocationName() );
                    } else {
                        out.write("--");
                    }
                %>
            </td>
            <td>
                <%
                    if (ticketsByque.getStatus() == STATIC_DATA_MODEL.TICKETPENDING) {
                %>
                <span class="text-warning">Pending</span>
                <%} else if (ticketsByque.getStatus() == STATIC_DATA_MODEL.TICKETACTIVE) {%>
                <span class="text-success">Active</span>
                <%} else if (ticketsByque.getStatus() == STATIC_DATA_MODEL.TICKETCOMPLETED) {%>
                <span class="text-info">Completed</span>
                <%} else if (ticketsByque.getStatus() == STATIC_DATA_MODEL.TICKETCONFIRMED) {%>
                <span class="text-inverse">Confirmed</span>
                <%} else if (ticketsByque.getStatus() == STATIC_DATA_MODEL.TICKETARCHIVE) {%>
                <span class="text-danger">Archive</span>
                <%}%>
            </td>
            <td >
                <div class="avatars">
                    <%
                        List<TmTicketsHasUmUser> loadUsersByTicket = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, ticketsByque.getId());
                        if (!loadUsersByTicket.isEmpty()) {
                            for (TmTicketsHasUmUser ticketUsrs : loadUsersByTicket) {
                    %>
                    <span class="avatar">
                        <img src="${pageContext.request.contextPath}/ImageServlet/<%=ticketUsrs.getUmUser().getRemark1()%>" class=" rounded-pill" title="<%=ticketUsrs.getUmUser().getFirstName()%>&nbsp;<%=ticketUsrs.getUmUser().getLastName()%>" />
                    </span>
                    <%}
                        }%>
                </div>
            </td>
            <td><a class="btn btn-white btn-xs" onclick="confirmationTicket(<%=ticketsByque.getId()%>,<%=quId%>)">view</a></td>
        </tr>
        <%}
            }%>
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
