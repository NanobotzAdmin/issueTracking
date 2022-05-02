<%-- 
    Document   : publicTicketView
    Created on : Jan 27, 2022, 12:27:50 PM
    Author     : buddh
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.db.SmSessionActivity"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.TmTickets"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%
            String key = request.getParameter("ticketid");
            System.out.println("key = " + key);

        %>
        <meta charset="utf-8" />
        <title>Track My Issue</title>
        <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />

        <!-- ================== BEGIN core-css ================== -->
        <link href="assets/css/vendor.min.css" rel="stylesheet" />
        <link href="assets/css/transparent/app.min.css" rel="stylesheet" />
        <!-- ================== END core-css ================== -->

        <!-- ================== BEGIN page-css ================== -->
        <link href="assets/plugins/countdown/jquery.countdown.css" rel="stylesheet" />
        <link href="assets/css/sweetalert/sweetalert.css" rel="stylesheet" />
        <!-- ================== END page-css ================== -->
    </head>
    <body class='pace-top'>
        <!-- BEGIN page-cover -->
        <div class="app-cover"></div>
        <!-- END page-cover -->

        <!-- BEGIN #loader -->
        <div id="loader" class="app-loader">
            <span class="spinner"></span>
        </div>
        <!-- END #loader -->

        <!-- BEGIN #app -->
        <div id="app" class="app">
            <!-- BEGIN coming-soon -->
            <div class="coming-soon">
                <!-- BEGIN coming-soon-header -->
                <div class="coming-soon-header">
                    <div class="bg-cover"></div>
                    <div class="brand">
                        <span class="logo"></span><b> Track My Tickets</b>
                    </div><br>
                    <div class="desc">
                        <h3>Track and Trace</h3>
                    </div>
                    <!--				<div class="timer">
                                                            <div id="timer"></div>
                                                    </div>-->
                </div>
                <!-- END coming-soon-header -->
                <!-- BEGIN coming-soon-content -->
                <div class="coming-soon-content">
                    <div class="desc">
                        <h2>Enter your tracking number</h2>
                    </div>

                    <div class="input-group input-group-lg mx-auto mb-2">
                        <!--<span class="input-group-text border-0"><i class="fa fa-envelope"></i></span>-->
                        <input type="text" class="form-control fs-13px border-0 shadow-none" placeholder="" id="ticketNumber"  value="<%=key%>"/>
                        <button type="button" class="btn fs-13px btn-primary" onclick="trackTiket()">Track Ticket</button>
                    </div>
                    <br>
                    <!--<button type="button" class="btn btn-gray btn-sm" id="trackTicketButtonDiv" onclick="trackTiket()">Track</button>-->
                    <br><br>
                    <div class="row">
                        <div class="col-sm-3"></div>
                        <div class="col-sm-6">
                            <div class="timeline" id="loadTimelineDiv">
                                <%   
                                    Session ses = com.ring.connection.Connection.getSessionFactory().openSession();
                                    TmTickets selectedTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets().getTicketByKey(ses, key);
                                    if (selectedTicket == null) {
                                %>
                                <h1>Ticket Not Found</h1>

                                <%} else {
                                    List<SmSessionActivity> ticketActivityList = new com.ring.userManagementModel.UMS_UM_Session_Activity().searchActivitiesByTicketIdToTimeLine(ses, selectedTicket.getId(), STATIC_DATA_MODEL.TICKETMANAGEMENT, STATIC_DATA_MODEL.TICKETREPLYMANAGEMENT);
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
                                        }
                                    }
                                %>
                            </div>
                        </div>
                        <div class="col-sm-3"></div>
                    </div>
                    <p>
                        Please insert the tracking number provided to you by the Vision Care branch<br> if you haven't received the ticket ID,please contact your Vision Care Branch <br>
                        and request for the Ticket Tracking ID.<br>
                        for further assistance please send us an email on <br>
                        help@visioncare.lk
                    </p>

                </div>

                <!-- END coming-soon-content -->
            </div>
            <!-- END coming-soon -->

            <!-- BEGIN scroll-top-btn -->
            <a href="javascript:;" class="btn btn-icon btn-circle btn-success btn-scroll-to-top" data-toggle="scroll-to-top"><i class="fa fa-angle-up"></i></a>
            <!-- END scroll-top-btn -->
        </div>
        <!-- END #app -->


        <script>
            //    function for login                   
            function trackTiket() {
                var ticketNumber = $('#ticketNumber').val();
                if (ticketNumber === "") {
                    swal("", "Enter Ticket Id", "warning");
                } else {
                    jQuery.ajax({
                        url: "ticketsTimeLine.jsp",
                        type: "POST",
                        data: "ticketNumber=" + ticketNumber,
                        beforeSend: function () {},
                        complete: function () {},
                        success: function (data) {
                            $('#loadTimelineDiv').html(data);

                        }
                    });
                }
            }


        </script>

        <!-- ================== BEGIN core-js ================== -->
        <script src="assets/js/vendor.min.js"></script>
        <script src="assets/js/app.min.js"></script>
        <script src="assets/js/theme/transparent.min.js"></script>
        <!-- ================== END core-js ================== -->

        <!-- ================== BEGIN page-js ================== -->
        <script src="assets/plugins/countdown/jquery.plugin.min.js"></script>
        <script src="assets/plugins/countdown/jquery.countdown.min.js"></script>
        <script src="assets/js/demo/coming-soon.demo.js"></script>
        <script src="assets/js/sweetalert/sweetalert.min.js"></script>
        <!-- ================== END page-js ================== -->
    </body>
</html>