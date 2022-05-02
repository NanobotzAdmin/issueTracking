<%-- 
    Document   : ajax_ticket_report_load_tickets_by_filters
    Created on : Apr 5, 2022, 12:39:03 AM
    Author     : JOY
--%>

<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.db.TmTickets"%>
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
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {
            int pid = Integer.parseInt(request.getParameter("interfaceId"));
            byte status = Byte.parseByte(request.getParameter("status"));
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            


%> 
<table id="data-table-default" class="table table-striped table-bordered align-middle table-sm">
    <thead>
        <tr>
            <th width="1%">#</th>
            <th width="1%">TID</th>
            <th class="text-nowrap">Ticket Title</th>
            <th class="text-nowrap">Queue</th>
            <th class="text-nowrap">Category</th>
            <th class="text-nowrap">Sub Category</th>
            <th class="text-nowrap">Location</th>
            <th class="text-nowrap">Status</th>
            <th  data-orderable="false">Created Date</th>
            <th class="text-nowrap">Created by</th>
        </tr>
    </thead>
    <tbody>
        <%
            int hh=0;
 //                    TmTickets ticketsByque = (TmTickets) ses.load(TmTickets.class, (Integer) data2[0]);
            List<TmTickets> loadTicketsByFilters = new com.ring.ticketManagementModel.TMS_TM_Tickets().getTicketsByStatusAndDateRange(ses, status,startDate, endDate);
            if (!loadTicketsByFilters.isEmpty()) {
                for (TmTickets ticketsByque : loadTicketsByFilters) {
                    hh++;
        %>
        <tr>
            <td><%=hh%></td>
            <td><%=ticketsByque.getTid()%></td>
            <td><%=ticketsByque.getTicketName()%></td>
            <td>
                <%
                    if (ticketsByque.getQmQueue()!= null) {
                        out.write(ticketsByque.getQmQueue().getQueueName());
                    } else {
                        out.write("--");
                    }
                    %>
            </td>
            <td>
                <%
                    if (ticketsByque.getQmCategories()!= null) {
                        out.write(ticketsByque.getQmCategories().getCategoryName());
                    } else {
                        out.write("--");
                    }
                    %>
            </td>
            <td>
                <%
                    if (ticketsByque.getQmSubCategories()!= null) {
                        out.write(ticketsByque.getQmSubCategories().getSubCategoryName());
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
            <td><%=ticketsByque.getCreatedAt()%></td>
            <td>
                <%
                    UmUser ticketCreatedUser = (UmUser)ses.load(UmUser.class, ticketsByque.getCreatedBy());
                    if(ticketCreatedUser != null){
                        out.write(ticketCreatedUser.getFirstName() + " " + ticketCreatedUser.getLastName() );
                    }else{
                        out.write("--");
                    }
                %>
            </td>
        </tr>
        <%}}%>
</tbody>
</table>


<script>
        $('#data-table-default').DataTable({
            responsive: true,
            "pageLength": 50,
            
       
        dom: 'Bfrtip',
        buttons: [
            'copy', 'csv', 'excel', 'pdf', 'print'
        ]
    


        });
        
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
