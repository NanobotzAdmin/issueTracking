<%-- 
    Document   : home
    Created on : Nov 23, 2021, 1:13:55 PM
    Author     : dinuka
--%>

<%@page import="com.it.db.LmLocations"%>
<%@page import="com.it.configurationModel.NumberFortmaing"%>
<%@page import="com.it.configurationModel.Decemal_Format"%>
<%@page import="com.it.db.TmTicketsHasUmUser"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.it.configurationModel.DATE_TIME_MODEL"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.it.db.QmSubCategories"%>
<%@page import="com.it.db.QmQueue"%>
<%@page import="com.it.db.QmCategories"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.TmTickets"%>
<%@page import="java.util.List"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") != null) {

        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Transaction tr = ses.beginTransaction();
        tr.commit();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {
%>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8" />
        <title>Nanobotz | Issues Tracking</title>
        <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />

        <!--favicon start-->
        <link rel="apple-touch-icon" sizes="57x57" href="assets/img/favicon/apple-icon-57x57.png">
        <link rel="apple-touch-icon" sizes="60x60" href="assets/img/favicon/apple-icon-60x60.png">
        <link rel="apple-touch-icon" sizes="72x72" href="assets/img/favicon/apple-icon-72x72.png">
        <link rel="apple-touch-icon" sizes="76x76" href="assets/img/favicon/apple-icon-76x76.png">
        <link rel="apple-touch-icon" sizes="114x114" href="assets/img/favicon/apple-icon-114x114.png">
        <link rel="apple-touch-icon" sizes="120x120" href="assets/img/favicon/apple-icon-120x120.png">
        <link rel="apple-touch-icon" sizes="144x144" href="assets/img/favicon/apple-icon-144x144.png">
        <link rel="apple-touch-icon" sizes="152x152" href="assets/img/favicon/apple-icon-152x152.png">
        <link rel="apple-touch-icon" sizes="180x180" href="assets/img/favicon/apple-icon-180x180.png">
        <link rel="icon" type="image/png" sizes="192x192"  href="assets/img/favicon/android-icon-192x192.png">
        <link rel="icon" type="image/png" sizes="32x32" href="assets/img/favicon/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="96x96" href="assets/img/favicon/favicon-96x96.png">
        <link rel="icon" type="image/png" sizes="16x16" href="assets/img/favicon/favicon-16x16.png">
        <link rel="manifest" href="assets/img/favicon/manifest.json">
        <meta name="msapplication-TileColor" content="#ffffff">
        <meta name="msapplication-TileImage" content="assets/img/favicon/ms-icon-144x144.png">
        <meta name="theme-color" content="#ffffff">
        <!--favicon end-->

        <%@include file="cssLinks.jsp" %>


        <%@include file="cssScripts.jsp" %>
        <!--         ================== BEGIN core-css ================== 
                <link href="assets/css/vendor.min.css" rel="stylesheet" />
                <link href="assets/css/transparent/app.min.css" rel="stylesheet" />
                 ================== END core-css ================== 
        
                ================== BEGIN Page Required Plugin CSS ============== 
                 required files 
                <link href="assets/plugins/datatables.net-bs4/css/dataTables.bootstrap4.min.css" rel="stylesheet" />
                <link href="assets/plugins/datatables.net-responsive-bs4/css/responsive.bootstrap4.min.css" rel="stylesheet" />
                <link href="assets/plugins/datatables.net-buttons-bs4/css/buttons.bootstrap4.min.css" rel="stylesheet" />
                <link href="assets/plugins/datatables.net-colreorder-bs4/css/colReorder.bootstrap4.min.css" rel="stylesheet" />
                <link href="assets/plugins/datatables.net-keytable-bs4/css/keyTable.bootstrap4.min.css" rel="stylesheet" />
                <link href="assets/plugins/datatables.net-rowreorder-bs4/css/rowReorder.bootstrap4.min.css" rel="stylesheet" />
                <link href="assets/plugins/datatables.net-select-bs4/css/select.bootstrap4.min.css" rel="stylesheet" />
        
                <script src="assets/plugins/datatables.net/js/jquery.dataTables.min.js"></script>
                <script src="assets/plugins/datatables.net-bs4/js/dataTables.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-responsive/js/dataTables.responsive.min.js"></script>
                <script src="assets/plugins/datatables.net-responsive-bs4/js/responsive.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-colreorder/js/dataTables.colReorder.min.js"></script>
                <script src="assets/plugins/datatables.net-colreorder-bs4/js/colReorder.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-keytable/js/dataTables.keyTable.min.js"></script>
                <script src="assets/plugins/datatables.net-keytable-bs4/js/keyTable.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-rowreorder/js/dataTables.rowReorder.min.js"></script>
                <script src="assets/plugins/datatables.net-rowreorder-bs4/js/rowReorder.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-select/js/dataTables.select.min.js"></script>
                <script src="assets/plugins/datatables.net-select-bs4/js/select.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons-bs4/js/buttons.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/buttons.colVis.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/buttons.flash.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/buttons.html5.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/buttons.print.min.js"></script>
                <script src="assets/plugins/pdfmake/build/pdfmake.min.js"></script>
                <script src="assets/plugins/pdfmake/build/vfs_fonts.js"></script>
                <script src="assets/plugins/jszip/dist/jszip.min.js"></script>
        
                select2 
                <link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet" />
                switch
                <link href="assets/plugins/switchery/dist/switchery.min.css" rel="stylesheet" />
                multifile uploader
                <link href="assets/plugins/blueimp-gallery/css/blueimp-gallery.min.css" rel="stylesheet" />
                <link href="assets/plugins/blueimp-file-upload/css/jquery.fileupload.css" rel="stylesheet" />
                <link href="assets/plugins/blueimp-file-upload/css/jquery.fileupload-ui.css" rel="stylesheet" />
        
                END Multifile uploader
                ================== END Page Required Plugin CSS ================ -->

        <!--=========== BEGIN Custom CSS================-->
        <style>
            .avatars {
                display: inline-flex;
                flex-direction: row-reverse;

            }

            .avatar {
                position: relative;
                border: 1px solid #fff;
                border-radius: 50%;
                overflow: hidden;
                width:21px;
            }

            .avatar:not(:last-child) {
                margin-left: -10px;
            }

            .avatar img {
                width: 100%;
                display: block;
            }
            .app-cover{

                background-image: url('assets/img/login-bg/login-bg-10.jpg');

            }
            .glass-effect{
                background: rgba( 255, 255, 255, 0.25 );
                box-shadow: 0 8px 32px 0 rgba( 31, 38, 135, 0.37 );
                backdrop-filter: blur( 3.5px );
                -webkit-backdrop-filter: blur( 3.5px );
                border-radius: 10px;
                border: 1px solid rgba( 255, 255, 255, 0.18 );
            }
            .glass-effect:hover{
                /* From https://css.glass */
                background: rgba(255, 255, 255, 0.4);
                border-radius: 16px;
                box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
                backdrop-filter: blur(5px);
                -webkit-backdrop-filter: blur(5px);
                border: 1px solid rgba(255, 255, 255, 0.48);
                color: #fff;
            }
            .custom-select option{
                color: #000;
            }

            .note-editor.note-frame{
                color: #000000;
            } /*summernote font color to black*/



            .containerScroll {
                position: relative;
                width: 100%;
                height: 85vh;

            }

            .hideDiv{
                display:none
            }

            .modal-content{
                background-color: #333333;
                color: #fff;
            }


            .squreImg{
                object-fit: cover;
            }



            #kpiWrapper{
                height: 150px;
            }
            #kpiWrapperHome{
                height: 150px;
            }

            /* On screens that are 600px wide or less, the background color is olive */
            @media screen and (max-width: 600px) {
                #kpiWrapper{
                    height: 300px;
                }
                #kpiWrapperHome{
                    height: 300px;
                }
                #myTicketScroll{
                    height: 500px;
                }
                #TicketsTable{
                    height: 500px;
                }
            }

        </style>
        <!--=========== END Custom CSS================-->


        <script>
            function includeHTML() {
                var z, i, elmnt, file, xhttp;
                /*loop through a collection of all HTML elements:*/
                z = document.getElementsByTagName("*");
                for (i = 0; i < z.length; i++) {
                    elmnt = z[i];
                    /*search for elements with a certain atrribute:*/
                    file = elmnt.getAttribute("w3-include-html");
                    if (file) {
                        /*make an HTTP request using the attribute value as the file name:*/
                        xhttp = new XMLHttpRequest();
                        xhttp.onreadystatechange = function () {
                            if (this.readyState == 4) {
                                if (this.status == 200) {
                                    elmnt.innerHTML = this.responseText;
                                }
                                if (this.status == 404) {
                                    elmnt.innerHTML = "Page not found.";
                                }
                                /*remove the attribute, and call this function once more:*/
                                elmnt.removeAttribute("w3-include-html");
                                includeHTML();
                            }
                        }
                        xhttp.open("GET", file, true);
                        xhttp.send();
                        /*exit the function:*/
                        return;
                    }
                }
            }
            ;
        </script>
    </head>
    <body>
        <!-- BEGIN page-cover -->
        <div class="app-cover" id="app-cover"></div>
        <!-- END page-cover -->

        <!-- BEGIN #loader -->
        <div id="loader" class="app-loader">
            <span class="spinner"></span>
        </div>
        <!-- END #loader -->
        <!-- BEGIN #app -->
        <div id="app" class="app app-header-fixed app-sidebar-fixed ">
            <!-- BEGIN #header -->
            <div w3-include-html="header.jsp"></div> 
            <!-- END #header -->
            <!-- BEGIN #sidebar -->
            <div w3-include-html="sidebar.jsp"></div> 
            <!-- END #sidebar -->

            <!-- BEGIN #content -->
            <div id="content" class="app-content">

                <div class="container-fluid">
                    <div class="row">
                        <!-- BEGIN middle content load-->

                        <div class="col-xs-12 col-sm-6" id="middle_content_div">

                            <div id="kpiWrapperHome"><!--KPI row wrapper start-->
                                <div class="row"><!-- middle top header details row-->
                                    <div class="col">
                                        <!--<div w3-include-html="pages/settings/manage-privilage/privilage_management.jsp"></div>-->
                                        <%--<%@include file="pages/settings/manage-privilage/privilage_management.jsp" %>--%>
                                        <%--<%@include file="pages/settings/manage-user/user_homepage.jsp" %>--%>


                                        <!-- BEGIN page-header -->
                                        <!--<h1 class="page-header">IT Queue <small>All technology related issues are directed here</small></h1>-->
                                        <h1 class="page-header">All Issues<br></h1>
                                        <!-- END page-header -->

                                        <!--END page title & breadcrumbs-->


                                        <!-- BEGIN KPI row -->
                                    </div>

                                    <div class="col">
                                        <!--BEGIN page title & breadcrumbs-->
                                        <ol class="breadcrumb float-xl-end">
                                            <li class="breadcrumb-item"><a href="javascript:;">Home</a></li>
                                            <li class="breadcrumb-item"><a href="javascript:;">Technical</a></li>
                                            <li class="breadcrumb-item active">Issues List</li>
                                        </ol>
                                        <!-- END breadcrumb -->
                                    </div>
                                </div><!-- middle top header details row-->
                                <div class="row">
                                    <div class="col">
                                        <small>All Issues</small>
                                    </div>
                                </div>



                                <div class="row">
                                    <!-- BEGIN col-3 -->
                                    <%
                                        List<TmTickets> loadAllTickets2 = new com.it.ticketManagementModel.TMS_TM_Tickets().getAllTicketsByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                        //                                    System.out.println("li size = " + loadTicketsByUserANdCurrentMonth1.size());
                                    %>
                                    <div class="col-xl-3 col-sm-4 col-xs-12">
                                        <div class="widget widget-stats bg-gradient-cyan-blue p-1">
                                            <div class="stats-icon stats-icon-lg"><i class="fa fa-globe fa-fw"></i></div>
                                            <div class="stats-content">
                                                <h5>Issues Created </h5>
                                                <div class="badge bg-info"><%=loadAllTickets2.size()%></div>
                                                <div class="stats-progress progress mb-1 mt-1">
                                                    <div class="progress-bar" style="width: 70.1%;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- END col-3 -->
                                    <!-- BEGIN col-3 -->
                                    <%--
                                    <div class="col-xl-4 col-sm-4 col-xs-12">
                                        <div class="widget widget-stats bg-gradient-indigo p-1">
                                            <div class="stats-icon stats-icon-lg"><i class="fa fa-dollar-sign fa-fw"></i></div>
                                            <div class="stats-content">
                                                <%
                                                    double totTicketsExpenses = 0.00;
                                                    List<Object[]> loadTicketsByUserANdCurrentMonth2 = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsByUserIdAndCurrentMonth(ses, logedUser.getId());
                                                    for (Object[] expenses : loadTicketsByUserANdCurrentMonth2) {
                                                        TmTickets ticketsByUser = (TmTickets) ses.load(TmTickets.class, (Integer) expenses[0]);
                                                        totTicketsExpenses += ticketsByUser.getTotalExpence();
                                                    }
                                                    Double last2DecimalTot = Decemal_Format.RoundTo2Decimals(totTicketsExpenses);
                                                    String finalTotalExpence = NumberFortmaing.currencyFormat(last2DecimalTot);

                                                %>
                                                <h5>Expenses </h5>
                                                <div class="badge bg-purple">Rs.<%=finalTotalExpence%></div>
                                                <div class="stats-progress progress mb-1 mt-1">
                                                    <div class="progress-bar" style="width: 40.5%;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    --%>
                                    <!-- END col-3 -->
                                    <!-- BEGIN col-3 -->
                                    <!--                                                                    <div class="col-xl-3 col-md-6">
                                                                                                            <div class="widget widget-stats bg-gradient-orange-red">
                                                                                                                <div class="stats-icon stats-icon-lg"><i class="fa fa-archive fa-fw"></i></div>
                                                                                                                <div class="stats-content">
                                    <%
                                        //                                                List<Object[]> loadCompleteTicketsByUserAndCurrentMonth = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsByUserIdAndCurrentMonthAndStatus(ses, logedUser.getId(), STATIC_DATA_MODEL.TICKETCONFIRMED,STATIC_DATA_MODEL.TICKETCOMPLETED);
                                        //                                    System.out.println("size 2 = " + loadCompleteTicketsByUserAndCurrentMonth.size() );
                                    %>
                                                                                <h5>Completion <mark></mark></h5>
                                                                                <div class="stats-progress progress mb-1">
                                                                                    <div class="progress-bar" style="width: 76.3%;"></div>
                                                                                </div>
                                    
                                                                            </div>
                                                                        </div>
                                                                    </div>-->
                                    <!-- END col-3 -->
                                    <!-- BEGIN col-3 -->
                                    <div class="col-xl-5 col-sm-4 col-xs-12">
                                        <div class="widget widget-stats bg-gradient-green p-1">
                                            <div class="stats-icon stats-icon-lg"><i class="fa fa-clock fa-fw"></i></div>
                                            <div class="stats-content">
                                                <%
                                                    List<TmTickets> loadCompleteTicketsToHome = new com.it.ticketManagementModel.TMS_TM_Tickets().getAllTicketsToHomePage(ses, STATIC_DATA_MODEL.TICKETCOMPLETED, STATIC_DATA_MODEL.TICKETCONFIRMED);
                                                    long queueTimeDiff = 0;
                                                    String convertQueueTime = "";
                                                    if (!loadCompleteTicketsToHome.isEmpty()) {
                                                        for (TmTickets ticketsToHome : loadCompleteTicketsToHome) {
                                                            if (ticketsToHome.getTimeToComplete() != null) {
                                                                queueTimeDiff += ticketsToHome.getTimeToComplete();
                                                            } else {
                                                                queueTimeDiff += ticketsToHome.getConfirmedBy();
                                                            }
                                                        }
                                                        Long finalQueueTime = queueTimeDiff / loadCompleteTicketsToHome.size();
                                                        convertQueueTime = DATE_TIME_MODEL.getTimeDiff(finalQueueTime);
                                                    }
                                                %>

                                                <h5>Queue Time </h5>
                                                <div class="badge bg-green mb-1"><%=convertQueueTime%></div>
                                                <div class="stats-progress progress mb-1 mt-1">
                                                    <div class="progress-bar" style="width: 54.9%;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- END col-3 -->
                                </div>
                                <!-- END kpi row -->
                            </div><!--KPI wrapper end-->


                            <!--BEGIN Middle Table row-->
                            <div class="row" id="myTicketScroll" data-scrollbar="true" data-height="65vh">
                                <div class="col">
                                    <!--BEGIN middle pannel-->
                                    <div class="panel panel-inverse">
                                        <div class="panel-body">
                                            <!-- BEGIN Datatable-->
                                            <div class="table-responsive">
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
//                                                            List<Object[]> loadTicketsByUserANdCurrentMonth3 = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsByUserIdAndCurrentMonth(ses, logedUser.getId());
//                                                            System.out.println("si = " + loadTicketsByUserANdCurrentMonth3.size());
//                                                            if (!loadTicketsByUserANdCurrentMonth3.isEmpty()) {
//                                                                for (Object[] data : loadTicketsByUserANdCurrentMonth3) {
//                                                                    TmTickets ticketsByUser = (TmTickets) ses.load(TmTickets.class, (Integer) data[0]);
                                                            int tfmM = 0;
                                                            List<TmTickets> loadAllTickets = new com.it.ticketManagementModel.TMS_TM_Tickets().getAllTicketsByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                                            if (!loadAllTickets.isEmpty()) {
                                                                for (TmTickets ticketsByUser : loadAllTickets) {
                                                                    tfmM++;
                                                        %>
                                                        <tr >
                                                            <td width="1%" class="fw-bold text-white"><%=tfmM%></td>
                                                            <td width="1%" class="fw-bold text-white"><%=ticketsByUser.getTid()%></td>
                                                            <td><%=ticketsByUser.getTicketName()%></td>
                                                            <td>
                                                                <%
                                                                    if (ticketsByUser.getQmCategories() != null) {
                                                                        out.write(ticketsByUser.getQmCategories().getCategoryName());
                                                                    } else {
                                                                        out.write("--");
                                                                    }
                                                                %>
                                                            </td>
                                                            <td>
                                                                <%
                                                                    if (ticketsByUser.getLmLocations() != null) {
                                                                        out.write(ticketsByUser.getLmLocations().getLocationName());
                                                                    } else {
                                                                        out.write("--");
                                                                    }
                                                                %>
                                                            </td>
                                                            <td>
                                                                <%
                                                                    if (ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETPENDING) {
                                                                %>
                                                                <span class="text-warning">Pending</span>
                                                                <%} else if (ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETACTIVE) {%>
                                                                <span class="text-success">Active</span>
                                                                <%} else if (ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETCOMPLETED) {%>
                                                                <span class="text-info">Completed</span>
                                                                <%} else if (ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETCONFIRMED) {%>
                                                                <span class="text-inverse">Confirmed</span>
                                                                <%} else if (ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETSTARTED) {%>
                                                                <span class="text-danger">Started</span>
                                                                <%}%>
                                                            </td>
                                                            <td >
                                                                <div class="avatars">
                                                                    <%
                                                                        List<TmTicketsHasUmUser> loadUsersByTicket = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, ticketsByUser.getId());
                                                                        if (!loadUsersByTicket.isEmpty()) {
                                                                            for (TmTicketsHasUmUser ticketUsrs : loadUsersByTicket) {
                                                                    %>
                                                                    <span class="avatar" style="width:24px;height:24px;">
                                                                        <img src="${pageContext.request.contextPath}/ImageServlet/<%=ticketUsrs.getUmUser().getRemark1()%>" style="width: 24px;height: 24px;" class="squreImg rounded-pill" title="<%=ticketUsrs.getUmUser().getFirstName()%>&nbsp;<%=ticketUsrs.getUmUser().getLastName()%>" />
                                                                    </span>
                                                                    <%}
                                                                        }%>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <a class="btn btn-white btn-xs" onclick="confirmationTicket(<%=ticketsByUser.getId()%>,<%=ticketsByUser.getQmQueue().getId()%>)">view</a>
                                                            </td>
                                                        </tr>
                                                        <%}
                                                            }%>

                                                    </tbody>
                                                </table>
                                            </div>
                                            <!-- END Datatable-->
                                        </div>
                                    </div>
                                    <!--END middle pannel-->
                                </div>
                            </div>
                            <!--END Middle Table row-->
                        </div>
                        <!-- END Middle Content load-->

                        <!-- BEGIN Right Content Load-->
                        <div class="col-xs-12 col-sm-6">
                            <div id="right_content_div">
                            </div>
                            <%--<%@include file="pages/settings/manage-privilage/privilage_management_2.jsp" %>--%>
                            <%--<%@include file="pages/settings/manage-user/user_create_2.jsp" %>--%>
                            <!-- BEGIN page-header -->  
                            <!--<h2>#T523 <small>assigned to Isuru, Hasantha & 2 Others</small></h2>-->
                            <!-- END page-header -->

                            <!-- BEGIN panel -->

                            <!-- END panel -->
                        </div>
                        <!--END Right Content Load-->

                    </div>
                </div>

            </div>
            <!-- END #content -->
            <!--BEGIN Chat Reply Modals -->

            <!--             #modal-createCustomer  -->      
            <div class="modal fade" id="modal-createCustomer">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title">Create New Customer</h4>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-sm-12">


                                    <div class="form-group mb-3">
                                        <label>Customer Name</label>
                                        <input type="text" class="form-control modalFormInput" id="fullName" placeholder="Full Name of Customer">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Address</label>
                                        <input type="text" class="form-control" id="address" placeholder="Current Address of Customer">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Branch</label>
                                        <select class="form-control" style="color: #000" id="loadBranches">
                                            <option value="0" selected="">-- Select Branch --</option>

                                            <%
                                                List<LmLocations> loadActiveLocations = new com.it.locationManagementModel.LMS_LM_Locations().getAllLocationsByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                                if (!loadActiveLocations.isEmpty()) {
                                                    for (LmLocations locations : loadActiveLocations) {
                                            %>

                                            <option value="<%=locations.getId()%>"><%=locations.getLocationName()%></option>
                                            <%}
                                                }%>

                                        </select>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="form-group col-md-6">
                                            <label>Mobile</label>
                                            <input type="text" class="form-control" id="mobile" placeholder="Current Mobile Number">
                                        </div>
                                        <div class="form-group col-md-3" id="SNDOTPDIV">
                                            <label></label><br>
                                            <div id="SNDOTPBTN">
                                                <button type="button" class="btn btn-primary" onclick="sendOTP2()">Send OTP</button>
                                            </div>
                                        </div>
                                        <div class="form-group col-md-4" id="RESNDOTPDIV" style="display: none">
                                            <label></label><br>
                                            <button type="button" class="btn btn-default" onclick="sendOTP2()">Resend</button>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="form-group col-md-6">
                                            <label>Enter OTP</label>
                                            <input type="number" class="form-control" id="otpCode" placeholder="OTP the Customer Received">
                                            <input type="hidden" id="isverify" value="0" disabled=""> 
                                        </div>
                                        <div class="form-group col-md-6" id="OTPVRFDIV" style="display: none" >
                                            <label></label><br>
                                            <div id="VROTPBTN">
                                                <button type="button" class="btn btn-outline-success" onclick="verifyOTP2()">Verify</button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>E-mail</label>
                                        <input type="email" class="form-control" id="email" placeholder="Current Email Address">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>NIC</label>
                                        <input type="text" class="form-control" id="nic" placeholder="Current NIC Number">
                                    </div>

                                    <div class="row mb-3">
                                        <label class="form-label col-form-label col-md-6"></label>
                                        <!--                            <div class="col-md-3">
                                                                        <button type="button" class="btn btn-outline-white" style="width: 100%" >View Activity</button>-->
                                    </div>
                                    <div class="col-md-3" id="ADDCUSTBTNDIV">
                                        <button type="button" class="btn btn-green" style="width: 100%" onclick="addNewCustomer2()">Save</button>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <a href="javascript:;" class="btn btn-white" data-bs-dismiss="modal" id="CLSCUSBTN2">Close</a>
                            <!--<a href="javascript:;" class="btn btn-success">Save</a>-->
                        </div>
                    </div>
                </div>
            </div>




            <!-- #modal-attach -->
            <div class="modal fade" id="modal-attach">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title">Upload Files</h4>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
                        </div>
                        <div class="modal-body">
                            <form id="fileupload" action="assets/global/plugins/jquery-file-upload/server/php/" method="POST" enctype="multipart/form-data">
                                <div class="row fileupload-buttonbar">
                                    <div class="col-xl-7">
                                        <span class="btn btn-primary fileinput-button me-1">
                                            <i class="fa fa-fw fa-plus"></i>
                                            <span>Add files...</span>
                                            <input type="file" name="files[]" multiple>
                                        </span>
                                        <button type="submit" class="btn btn-primary start me-1">
                                            <i class="fa fa-fw fa-upload"></i>
                                            <span>Start upload</span>
                                        </button>
                                        <button type="reset" class="btn btn-dark cancel me-1">
                                            <i class="fa fa-fw fa-ban"></i>
                                            <span>Cancel upload</span>
                                        </button>
                                        <button type="button" class="btn btn-dark delete me-1">
                                            <i class="fa fa-fw fa-trash"></i>
                                            <span>Delete</span>
                                        </button>
                                        <!-- The global file processing state -->
                                        <span class="fileupload-process"></span>
                                    </div>
                                    <!-- The global progress state -->
                                    <div class="col-xl-5 fileupload-progress fade d-none d-xl-block">
                                        <!-- The global progress bar -->
                                        <div class="progress progress-striped active">
                                            <div class="progress-bar progress-bar-success" style="width:0%;"></div>
                                        </div>
                                        <!-- The extended global progress state -->
                                        <div class="progress-extended"> </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col">
                                        <div class="table-responsive">
                                            <table class="table table-panel text-nowrap mb-0">
                                                <thead>
                                                    <tr>
                                                        <th width="10%">PREVIEW</th>
                                                        <th>FILE INFO</th>
                                                        <th>UPLOAD PROGRESS</th>
                                                        <th width="1%"></th>
                                                    </tr>
                                                </thead>
                                                <tbody class="files">
                                                    <tr data-id="empty">
                                                        <td colspan="4" class="text-center text-gray-500 py-30px">
                                                            <div class="mb-10px"><i class="fa fa-file fa-3x"></i></div>
                                                            <div class="fw-bold">No file selected</div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
            <!--End #modal-attach-->
            <!-- #modal-expense -->
            <div class="modal fade" id="modal-expense">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title">Add Expense Detail</h4>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
                        </div>
                        <div class="modal-body">
                            ...
                        </div>
                        <div class="modal-footer">
                            <a href="javascript:;" class="btn btn-white" data-bs-dismiss="modal">Close</a>
                            <a href="javascript:;" class="btn btn-success">Save</a>
                        </div>
                    </div>
                </div>
            </div>
            <!--End #modal-expense-->

            <!--start archive ticket modal-->
            <div class="modal fade" id="archiveTicket">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="form-group mb-3">
                                <label>What may be the reason for this ticket?</label> 
                                <select class="default-select2 form-control" style="color: #000;border: 1px #000 solid">
                                    <option>Select One</option>
                                </select>
                            </div>
                            <div class="form-group mb-3">
                                <label>Is that the only posible reason? If not answer here</label> 
                                <select class="default-select2 form-control" style="color: #000;border: 1px #000 solid">
                                    <option>Select One</option>
                                </select>
                            </div>
                            <div class="form-group mb-3">
                                <label>If you think there might be another possible course.Please type here</label> 
                                <select class="default-select2 form-control" style="color: #000;border: 1px #000 solid">
                                    <option>Select One</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <a href="javascript:;" class="btn btn-white" data-bs-dismiss="modal">Close</a>
                            <a href="javascript:;" class="btn btn-success">Archive</a>
                        </div>
                    </div>
                </div>
            </div>
            <!--end archive ticket modal-->


            <!--END Chat Reply Modals -->

            <!-- BEGIN scroll to top btn -->
            <a href="javascript:;" class="btn btn-icon btn-circle btn-success btn-scroll-to-top" data-toggle="scroll-to-top"><i class="fa fa-angle-up"></i></a>
            <!-- END scroll to top btn -->
        </div>
        <!-- END #app -->

        <!--         ================== BEGIN core-js ================== 
                <script src="assets/js/vendor.min.js"></script>
                <script src="assets/js/app.min.js"></script>
                <script src="assets/js/theme/transparent.min.js"></script>
                 ================== END core-js ================== 
        
                 ================== BEGIN page-js ================== 
                <script src="assets/plugins/datatables.net/js/jquery.dataTables.min.js"></script>
                <script src="assets/plugins/datatables.net-bs4/js/dataTables.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-responsive/js/dataTables.responsive.min.js"></script>
                <script src="assets/plugins/datatables.net-responsive-bs4/js/responsive.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-colreorder/js/dataTables.colReorder.min.js"></script>
                <script src="assets/plugins/datatables.net-colreorder-bs4/js/colReorder.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-keytable/js/dataTables.keyTable.min.js"></script>
                <script src="assets/plugins/datatables.net-keytable-bs4/js/keyTable.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-rowreorder/js/dataTables.rowReorder.min.js"></script>
                <script src="assets/plugins/datatables.net-rowreorder-bs4/js/rowReorder.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-select/js/dataTables.select.min.js"></script>
                <script src="assets/plugins/datatables.net-select-bs4/js/select.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons-bs4/js/buttons.bootstrap4.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/buttons.colVis.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/buttons.flash.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/buttons.html5.min.js"></script>
                <script src="assets/plugins/datatables.net-buttons/js/buttons.print.min.js"></script>
                <script src="assets/plugins/pdfmake/build/pdfmake.min.js"></script>
                <script src="assets/plugins/pdfmake/build/vfs_fonts.js"></script>
                <script src="assets/plugins/jszip/dist/jszip.min.js"></script>
                <script src="assets/js/demo/table-manage-combine.demo.js"></script>
                <script src="assets/plugins/@highlightjs/cdn-assets/highlight.min.js"></script>
                <script src="assets/js/demo/render.highlight.js"></script>
                 ================== END page-js ================== 
        
                select2
                <script src="assets/plugins/select2/dist/js/select2.min.js"></script>
        
                switch
                <script src="assets/plugins/switchery/dist/switchery.min.js"></script>
        
                multifile uploader
        
        
                <script src="assets/plugins/blueimp-file-upload/js/vendor/jquery.ui.widget.js"></script>
                <script src="assets/plugins/blueimp-tmpl/js/tmpl.js"></script>
                <script src="assets/plugins/blueimp-load-image/js/load-image.all.min.js"></script>
                <script src="assets/plugins/blueimp-canvas-to-blob/js/canvas-to-blob.js"></script>
                <script src="assets/plugins/blueimp-gallery/js/jquery.blueimp-gallery.min.js"></script>
                <script src="assets/plugins/blueimp-file-upload/js/jquery.iframe-transport.js"></script>
                <script src="assets/plugins/blueimp-file-upload/js/jquery.fileupload.js"></script>
                <script src="assets/plugins/blueimp-file-upload/js/jquery.fileupload-process.js"></script>
                <script src="assets/plugins/blueimp-file-upload/js/jquery.fileupload-image.js"></script>
                <script src="assets/plugins/blueimp-file-upload/js/jquery.fileupload-audio.js"></script>
                <script src="assets/plugins/blueimp-file-upload/js/jquery.fileupload-video.js"></script>
                <script src="assets/plugins/blueimp-file-upload/js/jquery.fileupload-validate.js"></script>
                <script src="assets/plugins/blueimp-file-upload/js/jquery.fileupload-ui.js"></script>
                <script src="assets/js/demo/form-multiple-upload.demo.js"></script>
                END Multifile uploader-->

        <!--ADD PERFECT SCROLLBAR TO CONTAINER-->
        <script>


            try {
                var ps = new PerfectScrollbar('#myTicketScroll');

                $('#myTicketScroll').addEventListener('ps-y-reach-end', function () {
                    addEntries();
                    ps.update();
                });
            } catch (err) {
                console.log("middle content scrollbar didnt load on first attempt");
            }



        </script>


        <script>


            includeHTML();
//            
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
//            $('#data-table-combine').DataTable(options);


            $('#data-table-default').DataTable({
                responsive: true,
                "pageLength": 100
            });

        </script>




        <script>
            $(".default-select2").select2();
        </script>

        <!--        <script>
                    var elm = document.getElementById('switchery-default');
                    var switchery = new Switchery(elm, {
                        color: '#00acac'
                    });
                    var elm = document.getElementById('switchery-default1');
                    var switchery = new Switchery(elm, {
                        color: '#00acac'
                    });
                    var elm = document.getElementById('switchery-default2');
                    var switchery = new Switchery(elm, {
                        color: '#00acac'
                    });
                    var elm = document.getElementById('switchery-default3');
                    var switchery = new Switchery(elm, {
                        color: '#00acac'
                    });
                    var elm = document.getElementById('switchery-default4');
                    var switchery = new Switchery(elm, {
                        color: '#00acac'
                    });
                    var elm = document.getElementById('switchery-default5');
                    var switchery = new Switchery(elm, {
                        color: '#00acac'
                    });
        
                </script>-->


        <!-- The template to display files available for upload -->
        <script id="template-upload" type="text/x-tmpl">
            {% for (var i=0, file; file=o.files[i]; i++) { %}
            <tr class="template-upload fade show">
            <td>
            <span class="preview"></span>
            </td>
            <td>
            <div class="bg-light rounded p-3 mb-2">
            <dl class="mb-0">
            <dt class="text-inverse">File Name:</dt>
            <dd class="name">{%=file.name%}</dd>
            <hr />
            <dt class="text-inverse mt-10px">File Size:</dt>
            <dd class="size mb-0">Processing...</dd>
            </dl>
            </div>
            <strong class="error text-danger h-auto d-block text-left"></strong>
            </td>
            <td>
            <dl>
            <dt class="text-inverse mt-3px">Progress:</dt>
            <dd class="mt-5px">
            <div class="progress progress-sm progress-striped active rounded-pill"><div class="progress-bar progress-bar-primary" style="width:0%; min-width: 40px;">0%</div></div>
            </dd>
            </dl>
            </td>
            <td nowrap>
            {% if (!i && !o.options.autoUpload) { %}
            <button class="btn btn-primary start w-100px pe-20px mb-2 d-block" disabled>
            <i class="fa fa-upload fa-fw text-light"></i>
            <span>Start</span>
            </button>
            {% } %}
            {% if (!i) { %}
            <button class="btn btn-danger c                 ancel w-100px pe-20px d-block">
            <               i class="fa fa-tr        ash fa-f        w text-light "        ></i>
            <sp        an>Cancel</span>
            </button>            
            {% } %}
            </        td>
            </tr>
            {%     } %}
        </script>

        <!-- The template to display files available for download -->
        <script id="template-download" type="text/x-tmpl">
            {% for (var i=0, file; file=o.files[i]; i++) { %}
            <tr class="template-download fade show">
            <td width="1%">
            <span     class="preview">
            {% if (file.thumbna            ilUrl) { %}
            <a href="{%=f            ile.url%}" title="{%=file.name%}" download="{%=file.name%}" data-gallery><img src="{%=file.thumbnailUrl%}" class="rounded"></a>
            {% } els            e { %}
            <d            iv class="bg-light text-center fs-20px" style="width: 80px; height: 80px; line-height: 80px; border-radius: 6px;">
            <i class="fa fa-file-image fa-lg text-light"></i>
            </d            iv>
            {% } %}
            </spa    n>
            </        td>
            <td>
            <div class="bg-l            ight p-3 mb-2">
            <dl class="mb-0">
            <dt class=                "text-inverse">File Name:                    </dt>
            <dd clas                    s="name">
            {% if (file.url) { %}
            <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%                    }" {%=file.thumbnailUrl                    ?'data-gallery':''%}>{%=file.name%}</                    a>
            {% } e                lse { %}
            <span>{%=file.name%}</span>
            {% } %}
            </dd>
            <hr />
            <            dt class="text-light mt-10px">            File Size:</dt            >
            <dd class="size mb-0">{%=o.formatFileSize(file.size)%}</dd>
            </dl>
            {% if (fil    e.error) { %}
            <hr />
            <div><span         class="badge bg-danger me-1">ERROR</span> {%=file.error%}</div>
            {% } %}
            </div>
            </td>
            <td></td>
            <td>
            {% if (file.deleteUrl) { %}
            <button class="btn btn-danger delete w-100p            x mb-2 pe-20px" data-type="{%=file.deleteType%}" data-url="{%=file.delete            Url%}"{% if (file.deleteWit        hCredentials) {         %} data-xhr-fields='{"withCredentials":true}'{% } %}>
            <i         class="fa fa-trash f        loat-start fa-fw text-inverse mt-2px"></i>
            <span>Delete<            /span>
            </button>
            <input type="checkbox" name="delete" v            alue="1" class="toggle">
            {% } else         { %}
            <button class="btn btn-danger cancel w-100px me-3px pe-20px">
            <i class="fa fa-trash float-start fa-fw text-light mt-2px"></i>
            <span>Cancel</span>
            </button>
            {% } %}
            </td>
            </tr>
            {% } %}
        </script>

        <!-- script -->
        <script>
            $('#fileupload').fileupload({
                autoUpload: false,
                disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator.userAgent),
                maxFileSize: 5000000,
                acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
            });

            $('#fileupload').bind('fileuploadadd', function (e, data) {
            });

            $('#fileupload').bind('fileuploadfail', function (e, data) {
            });
        </script>

        <script type="text/javascript">
//            function changeBackground(path){
////                alert(document.getElementById('app-cover').style.backgroundImage);
//                document.getElementById('app-cover').style.backgroundImage="url(${pageContext.request.contextPath}/ImageServlet/'"+path+"')";
//            }

            function loadPage(pageUrl, id) {
                jQuery.ajax({
                    url: pageUrl,
                    type: "POST",
                    data: "pageUrl=" + pageUrl + "&interface=" + id,
                    beforeSend: function () {
//                            loadWatingDialog();
                    },
                    success: function (data) {
                        document.getElementById('right_content_div').innerHTML = "";
                        $('#middle_content_div').html(data);
                    }
                });
            }
            function loadTicketPage(pageUrl, id, quId, catId, subCatId, imagePath) {
//                alert(imagePath);
                document.getElementById('app-cover').style.backgroundImage = "url('" + imagePath + "')";
//                document.body.style.backgroundImage = "url('"+imagePath+"')";
                jQuery.ajax({
                    url: pageUrl,
                    type: "POST",
                    data: "pageUrl=" + pageUrl + "&interface=" + id + "&quId=" + quId + "&cataId=" + catId + "&subCatId=" + subCatId,
                    beforeSend: function () {
//                            loadWatingDialog();
                    },
                    success: function (data) {
                        document.getElementById('right_content_div').innerHTML = "";
                        $('#middle_content_div').html(data);
                    }
                });
            }
            function confirmationTicket(ticketId, qieId) {
                var pid = 7;
                $.ajax({
                    url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_confirmation.jsp",
                    type: "POST",
                    data: "interfaceId=" + pid + "&ticketId=" + ticketId + "&queId=" + qieId,
                    beforeSend: function (xhr) {
                    },
                    complete: function () {
                    },
                    success: function (data) {
                        $('#right_content_div').html(data);
                    }
                });
            }

            //    function for load loged ViewUser details
            function logedUserProfileUpdateView(id) {
                $.ajax({
                    url: "pages/settings/manage-user/ajax_user_management_edit_profile_details.jsp",
                    type: "POST",
                    data: "id=" + id,
                    beforeSend: function (xhr) {
                    },
                    complete: function () {
                    },
                    success: function (data) {
                        $('#right_content_div').html(data);
                    }
                });
            }
            function viewTicketFromHeaderSearch() {
                var ticketKey = $('#ticketKetToType').val();
                $.ajax({
                    url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_ViewTicketDetailsPage2.jsp",
                    type: "POST",
                    data: "ticketKey=" + ticketKey,
                    beforeSend: function (xhr) {
                    },
                    complete: function () {
                    },
                    success: function (data) {
                        $('#right_content_div').html(data);
                    }
                });
            }
            //      function for verify otp
            function verifyOTP2() {
                var typedOtp = $("#otpCode").val();
                if (typedOtp === "") {
                    swal("", "Enter OTP Code", "warning");
                } else {
                    $.ajax({
                        url: "customerManagement_verifyOTP",
                        type: "POST",
                        data: "typedOtp=" + typedOtp,
                        beforeSend: function (xhr) {
                            $('#VROTPBTN').empty();
                            $('#VROTPBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
                        },
                        success: function (data) {
                            var resultValue = JSON.parse(data);
                            if (resultValue.result === "0") {
                                swal("", resultValue.displayMessage, "error");
                            } else if (resultValue.result === "2") {
                                swal("", resultValue.displayMessage, "error");
                                setTimeout(function () {
                                    window.location.href = "../../../index.jsp";
                                }, 2000);
                            } else if (resultValue.result === "1") {
                                $("#isverify").val(1);
                                document.getElementById("SNDOTPDIV").style.display = "none";
                                document.getElementById("RESNDOTPDIV").style.display = "none";
                                document.getElementById("OTPVRFDIV").style.display = "none";
                                swal({
                                    title: "Done",
                                    text: resultValue.displayMessage,
                                    timer: 1000,
                                    showConfirmButton: false
                                });
                            }
                            $('#VROTPBTN').empty();
                            $('#VROTPBTN').html("<button type='button' class='btn btn-outline-success' onclick='verifyOTP2()'>verify</button>");
                        },
                        error: function (error) {
                        }
                    });
                }
            }
            //    function for add new Customer
            function addNewCustomer2() {
                var fullName = $("#fullName").val();
                var address = $("#address").val();
                var loadBranches = $("#loadBranches option:selected").val();
                var mobile = $("#mobile").val();
                var otpCode = $("#otpCode").val();
                var isverify = $("#isverify").val();
                var email = $("#email").val();
                var nic = $("#nic").val();
                if (fullName === "") {
                    swal("", "Enter Full Name", "warning");
                } else if (address === "") {
                    swal("", "Enter Address", "warning");
                } else if (nic === "") {
                    swal("", "Enter NIC", "warning");
                } else if (mobile === "") {
                    swal("", "Enter Mobile Number", "warning");
                } else if (otpCode === "") {
                    swal("", "Enter OTP Code", "warning");
                } else if (email === "") {
                    swal("", "Enter Email", "warning");
                } else if (nic === "") {
                    swal("", "Enter NIC", "warning");
                } else if (isverify === "0") {
                    swal("", "Verify Mobile Number", "warning");
                } else {
                    $.ajax({
                        url: "customerManagement_addCustomer",
                        type: "POST",
                        data: "fullName=" + fullName + "&address=" + address + "&loadBranches=" + loadBranches + "&mobile=" + mobile + "&otpCode=" + otpCode + "&isverify=" + isverify + "&email=" + email
                                + "&nic=" + nic + "&mode=" + "B",
                        beforeSend: function (xhr) {
                            $('#ADDCUSTBTNDIV').empty();
                            $('#ADDCUSTBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
                        },
                        success: function (data) {
                            var resultValue = JSON.parse(data);
                            if (resultValue.result === "0") {
                                swal("", resultValue.displayMessage, "error");
                            } else if (resultValue.result === "2") {
                                swal("", resultValue.displayMessage, "error");
                                setTimeout(function () {
                                    window.location.href = "../../../index.jsp";
                                }, 2000);
                            } else if (resultValue.result === "1") {
                                var message = resultValue.displayMessage;
                                var splitMessage = message.split("|");
                                var crid = splitMessage[1];
                                var crName = splitMessage[2];
                                var resultMessage = splitMessage[0];
//                                            location.reload();
                                var newCust = document.getElementById("customerForTicket");
                                var option1;
                                option1 = document.createElement("option");
                                option1.value = crid;
                                option1.text = crName;
                                newCust.add(option1);
                                swal({
                                    title: "Done",
                                    text: resultMessage,
                                    timer: 1000,
                                    showConfirmButton: false
                                });
                                $("#CLSCUSBTN2").trigger("click");
                            }
                            $('#ADDCUSTBTNDIV').empty();
                            $('#ADDCUSTBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addNewCustomer2()'>Save</button>");
                        },
                        error: function (error) {
                        }
                    });
                }
            }

        </script>

        <script>
            window.onload = function () {
                inactivityTime();
            }

            var inactivityTime = function () {
                var time;
                window.onload = resetTimer;
                // DOM Events
                document.onmousemove = resetTimer;
                document.onkeydown = resetTimer;

                document.onload = resetTimer;
                document.onmousemove = resetTimer;
                document.onmousedown = resetTimer; // touchscreen presses
                document.ontouchstart = resetTimer;
                document.onclick = resetTimer;     // touchpad clicks
                document.onkeydown = resetTimer;   // onkeypress is deprectaed
                document.addEventListener('scroll', resetTimer, true); // improved; see comments

                function logout() {
                    swal("You are now logged out.");
                    location.href = "userManagement_userLogout";
                }

                function resetTimer() {
                    clearTimeout(time);
                    time = setTimeout(logout, 600000);
                    // 1000 milliseconds = 1 second
                }
            };
        </script>

        <!--minify side bar on low res desktop screens-->
        <script>
            var sidebarContainer = document.getElementById("app");


            function myFunction(x) {
                if (x.matches) { // If media query matches

                    sidebarContainer.classList.add("app-sidebar-minified");
                } else {

                    sidebarContainer.classList.remove("app-sidebar-minified");
                }
            }

            var x = window.matchMedia("(max-width: 1280px)")
            myFunction(x) // Call listener function at run time
            x.addListener(myFunction) // Attach listener function on state changes
        </script>
        <!--minify side bar on low res desktop screens end-->

        <!-- Global site tag (gtag.js) - Google Analytics -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=G-GY65SCH36V"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());

            gtag('config', 'G-GY65SCH36V');
        </script>



    </body>
</html>

<%        } catch (Exception e) {
//        logger.error(logedUser.getId() + " - " + logedUser.getFirstName() + " : " + e.toString());
        e.printStackTrace();
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
