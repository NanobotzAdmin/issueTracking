<%-- 
    Document   : ticketFlow_management
    Created on : Dec 7, 2021, 6:22:23 PM
    Author     : buddh
--%>

<%@page import="com.ring.configurationModel.Decemal_Format"%>
<%@page import="com.ring.configurationModel.NumberFortmaing"%>
<%@page import="com.ring.configurationModel.CASH_WORD_CONVERTER"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.ring.db.TmTicketsHasUmUser"%>
<%@page import="com.ring.db.QmSubCategories"%>
<%@page import="com.ring.db.QmQueue"%>
<%@page import="com.ring.configurationModel.DATE_TIME_MODEL"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.TmTickets"%>
<%@page import="com.ring.db.QmCategories"%>
<%@page import="com.ring.db.UmUserHasInterfaceComponent"%>
<%@page import="com.ring.db.PmInterfaceComponent"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.ring.db.UmUser"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") != null) {
        Session ses = com.ring.connection.Connection.getSessionFactory().openSession();
        Transaction tr = ses.beginTransaction();
        tr.commit();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        String gg = (request.getParameter("pageUrl"));
//        String BGI = (request.getParameter("imagePath"));
        int pid = Integer.parseInt(request.getParameter("interface"));
        int quId = Integer.parseInt(request.getParameter("quId"));
        int catId = Integer.parseInt(request.getParameter("cataId"));
        int subCatId = Integer.parseInt(request.getParameter("subCatId"));
//        System.out.println("quid = " + quId);

        QmQueue selectedQ = (QmQueue) ses.load(QmQueue.class, quId);
        QmCategories selectedCat = null;
        QmSubCategories selectedSubCat = null;

        if (catId > 0) {
            selectedCat = (QmCategories) ses.load(QmCategories.class, catId);
        }
        if (subCatId > 0) {
            selectedSubCat = (QmSubCategories) ses.load(QmSubCategories.class, subCatId);
        }

        String content_prefix = "../../";
        try {
%>


<div class="row">

    <div class="col" id="middle_content_div">
        <%
            List<PmInterfaceComponent> getComponentByIterfaceId = new com.ring.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, pid);
            boolean ajax_new_ticket_detailsManagementMain = false;

            if (!getComponentByIterfaceId.isEmpty()) {
                for (PmInterfaceComponent cmpt : getComponentByIterfaceId) {
                    UmUserHasInterfaceComponent getUserHasComponentByUserAndComponentId = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, logedUser.getId(), cmpt.getId());
                    if (getUserHasComponentByUserAndComponentId != null) {
                        if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("TICKETFLOWMAINCOMPONENT")) {
                            ajax_new_ticket_detailsManagementMain = true;
                        }

                    }
                }
            }
        %>
        <%
            if (ajax_new_ticket_detailsManagementMain) {
        %>
        <!--<div w3-include-html="pages/settings/manage-privilage/privilage_management.jsp"></div>-->
        <%--<%@include file="pages/settings/manage-privilage/privilage_management.jsp" %>--%>
        <%--<%@include file="pages/settings/manage-user/user_homepage.jsp" %>--%>


        <div name="kpiWrapper" id="kpiWrapper"><!--kpi wrapper start-->

            <div class="row">
                <div class="col">
                    <!-- BEGIN page-header -->
                    <%
                        QmQueue selectMainQueue = (QmQueue) ses.load(QmQueue.class, quId);
                    %>
                    <h1 class="page-header"><%=selectMainQueue.getQueueName()%></h1>

                    <!-- END page-header -->

                </div>
                <div class="col">
                    <!--BEGIN page title & breadcrumbs-->
                    <ol class="breadcrumb float-xl-end">
                        <li class="breadcrumb-item"><a href="javascript:;"><%=selectedQ.getQueueName()%></a></li>
                        <li class="breadcrumb-item"><a href="javascript:;"><%if (selectedCat != null) {
                                out.write(selectedCat.getCategoryName());
                            }%></a></li>
                        <li class="breadcrumb-item"><a href="javascript:;"><%if (selectedSubCat != null) {
                                out.write(selectedSubCat.getSubCategoryName());
                            }%></a></li>
                    </ol>
                    <!-- END breadcrumb -->
                </div>                
            </div>
            <div class="row">
                <div class="col">
                    <small>  <%=selectMainQueue.getDescription()%></small>
                </div>
            </div>


            <!--END page title & breadcrumbs-->


            <!-- BEGIN KPI row -->
            <div class="row">
                <!-- BEGIN col-3 -->
                <div class="col-sm-4 col-xs-12">
                    <div class="widget widget-stats bg-gradient-cyan-blue p-1 m-1">
                        <div class="stats-icon stats-icon-lg"><i class="fa fa-globe fa-fw"></i></div>
                            <%
                                List<Object[]> loadTicketsByUserANdQueue = new com.ring.ticketManagementModel.TMS_TM_Tickets().getTicketsByUserIdAndQueueId(ses, logedUser.getId(), quId, catId, subCatId);
                                //                                    System.out.println("li size = " + loadTicketsByUserANdCurrentMonth1.size());
%>
                        <div class="stats-content">
                            <h5>Tickets Created </h5>
                            <div class="badge bg-info"><%=loadTicketsByUserANdQueue.size()%></div>
                            <div class="stats-progress progress mb-1 mt-1">
                                <div class="progress-bar" style="width: 70.1%;"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END col-3 -->
                <!-- BEGIN col-3 -->
                <div class="col-sm-4 col-xs-12">
                    <div class="widget widget-stats bg-gradient-indigo p-1 m-1">
                        <div class="stats-icon stats-icon-lg"><i class="fa fa-dollar-sign fa-fw"></i></div>
                            <%
                                double totTicketsExpenses = 0.00;
                                //                            List<Object[]> loadTicketsByUserANdCurrentMonth2 = new com.ring.ticketManagementModel.TMS_TM_Tickets().getTicketsByUserIdAndCurrentMonth(ses, logedUser.getId());
                                for (Object[] expensesCal : loadTicketsByUserANdQueue) {
                                    TmTickets ticketsByUser = (TmTickets) ses.load(TmTickets.class, (Integer) expensesCal[0]);
                                    totTicketsExpenses += ticketsByUser.getTotalExpence();
                                }
                                //                                double kk = new com.ring.ticketManagementModel.TMS_TM_Tickets().getTicketTotalExpenceByUserIdAndQueueId(ses, logedUser.getId(), quId, catId, subCatId);
                                //                                  DecimalFormat df = new DecimalFormat("000,000,000.00");             
                                //                                  String ll = df.format(kk);                  
                                //                                  Double pp = Double.parseDouble(ll);
                                //                                  System.out.println("pp = " + pp);
                                //                                  String convert Tot = CASH_WORD_CONVERTER.
                                //                                 System.out.format("%10.2f", kk);
                                Double last2DecimalTot = Decemal_Format.RoundTo2Decimals(totTicketsExpenses);
                                String finalTotalExpence = NumberFortmaing.currencyFormat(last2DecimalTot);
                                //                                  System.out.println("finalTotalExpence = " + finalTotalExpence);                      
                            %>
                        <div class="stats-content">
                            <h5>Expenses </h5>
                            <div class="badge bg-purple">Rs <%=finalTotalExpence%></div>
                            <div class="stats-progress progress mb-1 mt-1">
                                <div class="progress-bar" style="width: 40.5%;"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END col-3 -->
                <!-- BEGIN col-3 -->
                <!--            <div class="col-xl-3 col-md-6">
                                <div class="widget widget-stats bg-gradient-orange-red">
                                    <div class="stats-icon stats-icon-lg"><i class="fa fa-archive fa-fw"></i></div>
                                    <div class="stats-content">
                                        <h5>Completion <mark>55</mark></h5>
                                        <div class="stats-progress progress mb-1">
                                            <div class="progress-bar" style="width: 76.3%;"></div>
                                        </div>
                
                                    </div>
                                </div>
                            </div>-->
                <!-- END col-3 -->
                <!-- BEGIN col-3 -->
                <div class="col-sm-4 col-xs-12">
                    <div class="widget widget-stats bg-gradient-green p-1 m-1">
                        <div class="stats-icon stats-icon-lg"><i class="fa fa-clock fa-fw"></i></div>
                            <%
                                List<Object[]> loadCompleteTicketsByUserAndQueueId = new com.ring.ticketManagementModel.TMS_TM_Tickets().getCompleteTicketsByUserIdAndQueueId(ses, logedUser.getId(), quId, catId, subCatId, STATIC_DATA_MODEL.TICKETCONFIRMED, STATIC_DATA_MODEL.TICKETCOMPLETED, STATIC_DATA_MODEL.TICKETARCHIVE);
                                //                                                System.out.println("size 2 = " + loadCompleteTicketsByUserAndCurrentMonth.size());
                                long queueTimeDiff = 0;
                                String convertQueueTime = "";
                                if (!loadCompleteTicketsByUserAndQueueId.isEmpty()) {
                                    for (Object[] data1 : loadCompleteTicketsByUserAndQueueId) {
                                        TmTickets ticketsByUser = (TmTickets) ses.load(TmTickets.class, (Integer) data1[0]);
                                        if (ticketsByUser.getTimeToComplete() != null) {
                                            queueTimeDiff += ticketsByUser.getTimeToComplete();
                                        } else {
                                            queueTimeDiff += ticketsByUser.getConfirmedBy();
                                        }
                                    }

                                    Long finalQueueTime = queueTimeDiff / loadCompleteTicketsByUserAndQueueId.size();

                                    //                                                System.out.println("final queue = " + finalQueueTime);
                                    convertQueueTime = DATE_TIME_MODEL.getTimeDiff(finalQueueTime);
                                }
                            %>
                        <div class="stats-content">
                            <h5>Queue Time </h5>
                            <div class="badge bg-green"><%=convertQueueTime%></div>
                            <div class="stats-progress progress mb-1 mt-1">
                                <div class="progress-bar" style="width: 54.9%;"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END col-3 -->
            </div><!-- END kpi row -->
        </div><!--kpi wrapper end-->



        <div  id="TicketsTable" style="height: 65vh;" data-scrollbar="true"><!-- table scroll wrapper start-->
            <div class="row"><!--filter row start-->
                <div class="col">
                    <div class="row">
                        <div class="col">
                            <div class="panel panel-inverse m-1 p-1">
                                <div class="panel-body p-0 pb-1 ps-1">
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

                                        <div class="col-sm-2 col-xxl-1" id="TKTBYFLTERDIV">
                                            &nbsp;<br>
                                            <button type="button" class="btn btn-sm btn-outline-success" onclick="loadTicketsByFilter()">Search</button>
                                        </div>
                                        <div class="col-sm-3 col-xxl-2">
                                            &nbsp;<br>
                                            <button type="button" class="btn btn-sm btn-yellow" onclick="newTicketDetails()">Create Ticket</button>
                                        </div>
                                        <!--                        <div class="col-sm-2">
                                                                    <button type="button" class="btn btn-outline-white">My Tickets</button>
                                                                </div>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!--        <div class="row">
                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <label>Category</label>
                                        <select class="default-select2 form-control" id="loadCategoryByQueueId" onchange="loadSubCategoryByCategory(this.value)">
                                            <option value="0" selected="">-- Select One --</option>
                    <%
                        List<QmCategories> loadCategoryForTickets = new com.ring.queueManagementModel.QMS_QM_Categories().getCategoryByQueueId(ses, quId);
                        if (!loadCategoryForTickets.isEmpty()) {
                            for (QmCategories catByQueue : loadCategoryForTickets) {
                    %>
                    <option value="<%=catByQueue.getId()%>"><%=catByQueue.getCategoryName()%></option>
                    <%}
                        }%>
                </select>
            </div>
            </div>
            <div class="col-sm-4">
            <div class="form-group" id="LoadSubCategoryDiv">
                <label>Sub-Category</label>
                <select class="default-select2 form-control" id="loadSubCategoryByCategoryId">
                    <option value="0" selected="">-- Select One --</option>
                </select>
            </div>
            </div>
            <div class="col-sm-4">
            <div class="form-group">
                <label>Date Range</label>
                <div class="input-group" id="default-daterange">
                    <input type="text" name="default-daterange" class="form-control" value="" placeholder="click to select the date range" />
                    <div class="input-group-text"><i class="fa fa-calendar"></i></div>
                </div>
            </div>
            </div>
            </div>-->
                </div>
            </div><!-- filter row end-->


            <!--BEGIN Middle Table row-->
            <div class="row">
                <div class="col">
                    <!--BEGIN middle pannel-->
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <!-- BEGIN Datatable-->
                            <div class="table-responsive" id="loadTicketsByFiltersDiv">
                                <table id="data-table-default" class="table table-striped table-bordered align-middle table-sm" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th width="1%">#</th>
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
                                        <%
                                            //                                        List<Object[]> loadTicketsByUserANdQueue2 = new com.ring.ticketManagementModel.TMS_TM_Tickets().getTicketsByUserIdAndQueueId(ses, logedUser.getId(), quId, catId, subCatId);
                                            //                                        if (!loadTicketsByUserANdQueue2.isEmpty()) {
                                            //                                            for (Object[] data2 : loadTicketsByUserANdQueue2) {
                                            //                                                TmTickets ticketsByque = (TmTickets) ses.load(TmTickets.class, (Integer) data2[0]);
                                            int tfm = 0;
                                            List<TmTickets> loadAllTickets = new com.ring.ticketManagementModel.TMS_TM_Tickets().getTicketsByQueueOrCatOrSubCat(ses, quId, catId, subCatId);
                                            if (!loadAllTickets.isEmpty()) {
                                                for (TmTickets ticketsByque : loadAllTickets) {
                                                    tfm++;
                                        %>
                                        <tr >
                                            <td width="1%" class="fw-bold text-white"><%=tfm%></td>
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
                                                        out.write(ticketsByque.getLmLocations().getLocationName());
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
                                                        List<TmTicketsHasUmUser> loadUsersByTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, ticketsByque.getId());
                                                        if (!loadUsersByTicket.isEmpty()) {
                                                            for (TmTicketsHasUmUser ticketUsrs : loadUsersByTicket) {
                                                    %>
                                                    <span class="avatar" style="width:24px;height:24px;">
                                                        <img style="width:24px;height:24px;" src="${pageContext.request.contextPath}/ImageServlet/<%=ticketUsrs.getUmUser().getRemark1()%>" class=" rounded-pill" title="<%=ticketUsrs.getUmUser().getFirstName()%>&nbsp;<%=ticketUsrs.getUmUser().getLastName()%>" />
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
                            </div>
                            <br>

                            <!-- END Datatable-->
                        </div>
                    </div>
                    <!--END middle pannel-->
                </div>
            </div>
            <!--END Middle Table row-->


        </div><!-- table scroll wrapper end-->

    </div>
</div>


<div class="container-fluid">
    <div class="row">



        <!--start new ticket--> 
        <!--        <div class="row">
                    <div class="col-sm-12">
                        <h1 class="page-header"> New Ticket  &nbsp;&nbsp; <small style="font-size: 15px"> #HW423 </small> &nbsp;&nbsp;
                            <div class="avatars">
                                <span class="avatar">
                                    <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                </span>
                            </div>
                        </h1>
                        <div class="panel panel-inverse">
                            <div class="panel-body">
                                <div class="card">
                                    <div class="card-body">
                                        <label>Assigned to </label>
                                        <div class="avatars">
                                            <span class="avatar">
                                                <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                            </span>
                                        </div>
                                        <br><br>
                                        <div class="form-group mb-3">
                                            <label>Ticket Title</label>
                                            <input type="text" class="form-control">
                                        </div>
                                        <div class="form-group mb-3">
                                            <label>Category</label>
                                            <select class="default-select2 form-control">
                                                <option>Select One</option>
                                            </select>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label>Sub-Category</label>
                                            <select class="default-select2 form-control">
                                                <option>Select One</option>
                                            </select>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="form-group col-md-6">
                                                <label>Add User to Ticket</label>
                                                <select class="default-select2 form-control" style="color: #000">
                                                    <option>Select One</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label></label><br>
                                                <button type="button" class="btn btn-green">Add</button>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3">
                                            <div class="avatars">
                                                <span class="avatar">
                                                    <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                                </span>
                                            </div> &nbsp;&nbsp;
                                            <label style="font-size: 14px">Ticket Details</label>
                                            <textarea class="summernote" name="content" style="color: #000"></textarea>
                                        </div>
        
        
                                        <div class="row mb-3">
                                            <div class="col-md-4">
                                                <input type="file" class="form-control">
                                            </div>
                                            <label class="form-label col-form-label col-md-5"></label>
                                            <div class="col-md-3">
                                                <button type="button" class="btn btn-green" style="width: 100%">Create Ticket</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>-->
        <!--end new ticket-->


        <!--start view ticket ticket-->
        <!--        <div class="row">
                    <div class="col-sm-12">
                        <div class="row">
                            <div class="col-sm-5">
                                <h1 class="page-header"> View Ticket  &nbsp;&nbsp; <small style="font-size: 15px"> #HW423 </small> &nbsp;&nbsp;
                                    <div class="avatars">
                                        <span class="avatar">
                                            <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                        </span>
                                    </div> 
                                </h1>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-6">
                                <button type="button" class="btn btn-default btn-sm"><i class="fa fa-trash"></i></button>
                                <button type="button" class="btn btn-gray btn-sm"><i class="fa fa-arrow-right"></i></button>
                                <button type="button" class="btn btn-info btn-sm">Confirm Complete</button>
                                <a href="#archiveTicket" class="btn btn-primary btn-sm" data-bs-toggle="modal">Archive Ticket</a>
                            </div>
                        </div>
        
                        <div class="row">
                            <div class="col-sm-2">
                                <label>Assigned to</label>
                            </div>
                            <div class="col-sm-6">
                                <div class="avatars">
                                    <span class="avatar">
                                        <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                    </span>
                                    <span class="avatar">
                                        <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                    </span>
                                    <span class="avatar">
                                        <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                    </span>
                                    <span class="avatar">
                                        <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                    </span>
                                </div> 
                            </div>
                            <div class="col-sm-4">
                                <label><b>Total Expenses</b> &nbsp;&nbsp;&nbsp; 325,000 Rs</label>
                            </div>
                        </div>
        
                        <div class="panel panel-inverse">
                            <div class="panel-body">
                                <h4>Ticket Name</h4>
                                <label>
                                    Ticket Description
                                </label><br><br>
                                <div class="row">
                                    <div class="col">
                                        <img class="img-fluid" src="https://m.majorgeeks.com/index.php?ct=content&action=file&id=480"/>    
                                    </div>
                                    <div class="col"> <button class="btn btn-info">Download</button></div>
                                </div>
        
                            </div>
                        </div>
        
                        <div class="panel panel-inverse">
        
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col">
                                        <ul class=" mb-4 me-4">
                                            <li style="list-style-type: none;">
                                                <div class="row p-2 glass-effect" style="border:3px solid gray;">
                                                    <div class="col-1 pe-1 "><img src="assets/img/user/user-1.jpg" alt="" class="rounded-3 img-fluid" />
                                                        <span class="badge fw-bold fs-10px rounded-2 bg-red">Staff</span></div>
                                                    <div class="col-10">
                                                        <div class="post-user"><a href="#">Randima Gamage</a> <small>SAYS</small></div>
                                                        <div class="post-content">
                                                            Hi All, <br/>
                                                            My computer keeps prompting to activate windows and its disrupting my work.
                                                            please fix this issue for me
                                                            <br />
                                                            Thank you in Advance!<br/>
                                                        </div>
                                                        <div class="post-time">12/11/2021 12:23PM </div>
                                                    </div>
                                                </div>
                                            </li>
                                            <li style="list-style-type: none;" class="mt-2">
                                                <div class="row p-2 glass-effect" style="border:3px solid gray;">
                                                    <div class="col-1 pe-1 "><img src="assets/img/user/user-2.jpg" alt="" class="rounded-3 img-fluid" />
                                                        <span class="badge fw-bold fs-10px rounded-2 bg-red">Admin</span></div>
                                                    <div class="col-10">
                                                        <div class="post-user"><a href="#">Saman Perera</a> <small>SAYS</small></div>
                                                        <div class="post-content">
                                                            Hi Randima, <br/>
                                                            Could you send us a image of the issue?
                                                        </div>
                                                        <div class="post-time">12/11/2021 2:16PM</div>
                                                    </div>
                                                </div>
                                            </li>
                                            <li style="list-style-type: none;"class="mt-2">
                                                <div class="row p-2 glass-effect" style="border:3px solid gray;">
                                                    <div class="col-1 pe-1 "><img src="assets/img/user/user-1.jpg" alt="" class="rounded-3 img-fluid" />
                                                        <span class="badge fw-bold fs-10px rounded-2 bg-red">Staff</span></div>
                                                    <div class="col-10">
                                                        <div class="post-user"><a href="#">Randima Gamage</a> <small>SAYS</small></div>
                                                        <div class="post-content">
                                                            Hi, <br/>
                                                            I have attached the image here.
                                                            <div class="row">
                                                                <div class="col">
                                                                    <img class="img-fluid" src="https://m.majorgeeks.com/index.php?ct=content&action=file&id=680"/>    
                                                                </div>
                                                                <div class="col"> <button class="btn btn-info">Download</button></div>
                                                            </div>
        
                                                        </div>
                                                        <div class="post-time">12/11/2021 12:23PM </div>
                                                    </div>
                                                </div>
                                            </li>
        
        
                                        </ul>
                                   </div>
                                </div>
                                <div class="row">
                                    <div class="col">
                                       <div class="card">
                                            <div class="card-body">
                                                 <div class="row mb-3">
                                            <div class="form-group col-md-6">
                                                <label>Add User to Ticket</label>
                                                <select class="default-select2 form-control" style="color: #000">
                                                    <option>Select One</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label></label><br>
                                                <button type="button" class="btn btn-green">Add</button>
                                            </div>
                                        </div>
                                                <div class="mb-3">
                                                    <label for="replyText" class="form-label">Type your Reply</label>
                                                    <textarea class="summernote" name="content" style="color: #000"></textarea>
                                                </div>
                                                <div class="row mb-3">
                                                    <a href="#modal-attach" class="btn glass-effect col-sm-2" data-bs-toggle="modal"><span class="fa fa-paperclip"></span> Attach File</a>
                                                    <div class="col-sm-4"></div>
                                                    <label class="col-sm-2"><span class="fa fa-dollar-sign"></span> Expenses</label>
                                                    <div class="col-sm-2"> <input type="text" class=" form-control" placeholder="0.00"></div>
                                                    <div class="col-sm-2"><button type="button" class="col-sm-2 btn btn-primary float-end" style="width: 100%">Send Reply</button></div>
                                           
                                                </div>
                                            </div>
                                        </div>
                                     
                                    </div>
                                </div>
                            </div>
                        </div>
        
        
                        
                    </div>
                </div>-->
        <!--end view tickets-->

        <!--start forward ticket -->
        <!--        <div class="row">
                    <div class="col-sm-12">
                        <div class="row">
                            <div class="col-sm-6">
                                <h1 class="page-header"> Forward Ticket  &nbsp;&nbsp; <small style="font-size: 15px"> #HW423 </small> &nbsp;&nbsp;
                                    <div class="avatars">
                                        <span class="avatar">
                                            <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                        </span>
                                    </div> 
                                </h1>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-5">
                                <button type="button" class="btn btn-default btn-sm"><i class="fa fa-trash"></i></button>
                                <button type="button" class="btn btn-gray btn-sm"><i class="fa fa-arrow-right"></i></button>
                                <button type="button" class="btn btn-info btn-sm">Mark Complete</button>
                            </div>
                        </div>
        
                        <div class="row">
                            <div class="col-sm-2">
                                <label>Assigned to</label>
                            </div>
                            <div class="col-sm-6">
                                <div class="avatars">
                                    <span class="avatar">
                                        <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                    </span>
                                    <span class="avatar">
                                        <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                    </span>
                                    <span class="avatar">
                                        <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                    </span>
                                    <span class="avatar">
                                        <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                    </span>
                                </div> 
                            </div>
                            <div class="col-sm-4">
                                <label><b>Total Expenses</b> &nbsp;&nbsp;&nbsp; 325,000 Rs</label>
                            </div>
                        </div>
        
                        <div class="panel panel-inverse">
                            <div class="panel-body">
                                <h4>Ticket Name</h4>
                                <label>
                                    Ticket Description
                                </label><br><br>
                                <div class="row">
                                    <div class="col">
                                        <img class="img-fluid" src="https://m.majorgeeks.com/index.php?ct=content&action=file&id=480"/>    
                                    </div>
                                    <div class="col"> <button class="btn btn-info">Download</button></div>
                                </div>
        
                            </div>
                        </div>
        
        
                        <div class="panel panel-inverse">
                            <div class="panel-body">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="form-group mb-3">
                                            <label>Queue</label>
                                            <select class="default-select2 form-control" style="color: #000">
                                                <option>Select One</option>
                                            </select>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label>Category</label>
                                            <select class="default-select2 form-control" style="color: #000">
                                                <option>Select One</option>
                                            </select>
                                        </div>
                                        <div class="form-group mb-3">
                                            <label>Sub-Category</label>
                                            <select class="default-select2 form-control" style="color: #000">
                                                <option>Select One</option>
                                            </select>
                                        </div>
        
                                        <div class="row mb-3">
                                            <div class="form-group col-md-6">
                                                <label>Add User to Ticket</label>
                                                <select class="default-select2 form-control" style="color: #000">
                                                    <option>Select One</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label></label><br>
                                                <button type="button" class="btn btn-green">Add</button>
                                            </div>
                                        </div>
        
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped table-sm">
                                                <thead>
                                                    <tr>
                                                        <th>EID</th>
                                                        <th>Name</th>
                                                        <th>Designation</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td><button type="button" class="btn btn-danger btn-xs"><i class="fa fa-times"></i></button></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
        
        
                                        <div class="row mb-3">
                                            <label class="form-label col-form-label col-md-9"></label>
                                            <div class="col-md-3">
                                                <button type="button" class="btn btn-primary" style="width: 100%">Save Changes</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>-->
        <!--end forward                                                                          ticket -->





    </div>
</div>






<script>

    $(".default-select2").select2();

    $('#data-table-default').DataTable({
        responsive: true,
        "pageLength": 100

//         includeHTML();
//            var options = {
//                dom: '<"dataTables_wrapper dt-bootstrap"<"row"<"col-xl-7 d-block d-sm-flex d-xl-block justify-content-center"<"d-block d-lg-inline-flex me-0 me-md-3"l><"d-block d-lg-inline-flex"B>><"col-xl-5 d-flex d-xl-block justify-content-center"fr>>t<"row"<"col-md-5"i><"col-md-7"p>>>',
//                buttons: [
//                    {extend: 'copy', className: 'btn-sm'},
//                    {extend: 'csv', className: 'btn-sm'},
//                    {extend: 'excel', className: 'btn-sm'},
//                    {extend: 'pdf', className: 'btn-sm'},
//                    {extend: 'print', className: 'btn-sm'}
//                ],
//                responsive: true,
//                colReorder: true,
//                keys: true,
//                rowReorder: true,
//                select: true
//            };
//            if ($(window).width() <= 767) {
//                options.rowReorder = false;
//                options.colReorder = false;
//            }


    });
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

    $(".summernote").summernote({
        height: "150",
        color: "#000000"
    });
//create new ticket 
    function newTicketDetails() {
//        alert('dfjkhdfjh');
        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_new_ticket_details.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&quIdToNewTicket=" + <%=quId%> + "&catForTicket=" + <%=catId%> + "&subForTicket=" + <%=subCatId%>,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
//    load ticketas by filters
    function loadTicketsByFilter() {
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();

        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_load_tickets_by_filters.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&quIdToNewTicket=" + <%=quId%> + "&catForTicket=" + <%=catId%> + "&subForTicket=" + <%=subCatId%> + "&startDate=" + startDate + "&endDate=" + endDate,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#loadTicketsByFiltersDiv').html(data);
            }
        });
    }
    function loadSubCategoryByCategory(catId) {
        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_load_sub_category_by_category_id.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&catId=" + catId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#LoadSubCategoryDiv').html(data);
            }
        });
    }

//    function confirmationTicket(ticketId, qieId) {
//        $.ajax({
//            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_confirmation.jsp",
//            type: "POST",
//            data: "interfaceId=" +  + "&ticketId=" + ticketId + "&queId=" + qieId,
//            beforeSend: function (xhr) {
//            },
//            complete: function () {
//            },
//            success: function (data) {
//                $('#right_content_div').html(data);
//            }
//        });
//    }

//    function forwardTicketLoad(ticketId, queuId) {
//        $.ajax({
//            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_forward_ticket.jsp",
//            type: "POST",
//            data: "interfaceId=" + + "&ticketId=" + ticketId + "&queuId=" + queuId,
//            beforeSend: function (xhr) {
//            },
//            complete: function () {
//            },
//            success: function (data) {
//                $('#right_content_div').html(data);
//            }
//        });
//    }

//    function categoryByQueueTF(queueId) {
//        $.ajax({
//            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_forward_ticket_load_category_by_queue_id.jsp",
//            type: "POST",
//            data: "interfaceId=" +  + "&queueId=" + queueId,
//            beforeSend: function (xhr) {
//            },
//            complete: function () {
//            },
//            success: function (data) {
//                $('#categoryTFDiv').html(data);
//            }
//        });
//    }
//    function SubCategoryByCategoryTF(categoryId) {
//        $.ajax({
//            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_forward_ticket_load_subcategory_by_category_id.jsp",
//            type: "POST",
//            data: "interfaceId=" +  + "&categoryId=" + categoryId,
//            beforeSend: function (xhr) {
//            },
//            complete: function () {
//            },
//            success: function (data) {
//                $('#subCategoryTFDiv').html(data);
//            }
//        });
//    }


    try {
        psTickets = new PerfectScrollbar('#TicketsTable');
        $psTickets.update();
    } catch (err) {
        console.log("scroll didnt work");
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