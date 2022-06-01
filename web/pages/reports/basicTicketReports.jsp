
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.hibernate.Session"%>
<%@page import="com.it.db.UmUserHasInterfaceComponent"%>
<%@page import="com.it.db.PmInterfaceComponent"%>
<%@page import="com.it.db.PmInterfaceComponent"%>
<%@page import="java.util.List"%>
<%
    if (request.getSession().getAttribute("nowLoginUser") != null) {
        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Transaction tr = ses.beginTransaction();
        tr.commit();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        String gg = (request.getParameter("pageUrl"));
//        String BGI = (request.getParameter("imagePath"));
        int pid = Integer.parseInt(request.getParameter("interface"));
        String content_prefix = "../../";
        try {
%>

<%
    List<PmInterfaceComponent> getComponentByIterfaceId = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, pid);
    boolean ticketsReportMain = false;
    if (!getComponentByIterfaceId.isEmpty()) {
        for (PmInterfaceComponent cmpt : getComponentByIterfaceId) {
            UmUserHasInterfaceComponent getUserHasComponentByUserAndComponentId = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, logedUser.getId(), cmpt.getId());
            if (getUserHasComponentByUserAndComponentId != null) {
                if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("TICKETREPORTMAINCOMPONENT")) {
                    ticketsReportMain = true;
                }
            }
        }
    }
%>
<%
    if (ticketsReportMain) {
%>
<div class="row">
    <h2>Basic Ticket Report</h2>
</div>
<div class="row">
    <div class=" col-xxl-3 col-sm-3">
        <div class="form-group" id="data_1">
            <div class="input-group date">
                <span class="input-group-addon">from<input type="text" class="form-control form-control-sm" id="startDate" ></span>
            </div>
        </div>
    </div>
    <div class="col-xxl-3 col-sm-3">
        <div class="form-group" id="data_1">
            <div class="input-group date">
                <span class="input-group-addon">to<input type="text" class="form-control form-control-sm" id="endDate" ></span>
            </div>
        </div>
    </div>
    <div class="col-xxl-3 col-sm-3">
        <small class="form-label">Status</small>
        <select class="form-control form-control-sm" style="color: #fff" id="status">
            <option selected="" value="0" style="color: #000">-- Select Status --</option>
            <option value="1" style="color: #000">Pending</option> 
            <option value="2" style="color: #000">Active</option> 
            <option value="3" style="color: #000">Complete</option> 
            <option value="4" style="color: #000">Confirm</option> 
            <option value="5" style="color: #000">Archive</option> 
        </select>
    </div>
    <div class="col-sm-2 col-xxl-1">
        &nbsp;<br>
        <button type="button" class="btn btn-sm btn-outline-success" onclick="loadTicketsByFilters()">Search</button>
    </div>
</div>
<div class="row">
    <div class="col mt-4">
        <div class="table-responsive" id="loadTicketsByFiltersDiv2">
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
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                </tbody>
            </table>
        </div>
    </div>
    <script>
       
        var mem = $('#data_1 .input-group.date').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            calendarWeeks: true,
            autoclose: true,
            format: "yyyy-mm-dd"
        });
        $("#default-daterange").daterangepicker({
            opens: "right",
            format: "MM/DD/YYYY",
            separator: " to ",
            startDate: moment().subtract("days", 29),
            endDate: moment(),
            minDate: "01/01/2021",
            maxDate: "12/31/2021",
        }, function (start, end) {
            $("#default-daterange input").val(start.format("MMMM D, YYYY") + " - " + end.format("MMMM D, YYYY"));
        });
    </script> 

    <script type="text/javascript">
        //    load ticketas by filters
        function loadTicketsByFilters() {
            var startDate = $("#startDate").val();
            var endDate = $("#endDate").val();
            var status = $("#status option:selected").val();

            $.ajax({
                url: "pages/reports/ajax_ticket_report_load_tickets_by_filters.jsp",
                type: "POST",
                data: "interfaceId=" + <%=pid%> + "&startDate=" + startDate + "&endDate=" + endDate + "&status=" + status,
                beforeSend: function (xhr) {
                },
                complete: function () {
                },
                success: function (data) {
                    $('#loadTicketsByFiltersDiv2').html(data);
                }
            });
        }
    </script>


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