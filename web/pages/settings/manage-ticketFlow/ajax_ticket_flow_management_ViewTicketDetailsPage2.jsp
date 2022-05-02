<%-- 
    Document   : ajax_ticket_flow_management_ViewTicketDetailsPage2
    Created on : Feb 11, 2022, 3:35:50 AM
    Author     : JOY
--%>

<%@page import="com.ring.db.TmReplyMedia"%>
<%@page import="com.ring.db.TmTicketMedia"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.db.QmSubCategoriesHasUser"%>
<%@page import="com.ring.db.QmCategoriesHasUser"%>
<%@page import="com.ring.db.TmTicketsHasUmUser"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.QmQueueHasUser"%>
<%@page import="com.ring.db.TmTicketReply"%>
<%@page import="java.util.List"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="com.ring.db.TmTickets"%>
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
            String ticketKey = request.getParameter("ticketKey");

            TmTickets selectedTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets().getTicketByKey(ses, ticketKey);

            if (selectedTicket == null) {
%> 
<h1>No Ticket Found</h1>
<%} else {%>

<div class="row">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-sm-6">
                <h1 class="page-header"> View Ticket  &nbsp;&nbsp; <small style="font-size: 15px"> <%=selectedTicket.getTid()%> </small> &nbsp;&nbsp;
                    <div class="avatars">
                        <span class="avatar">
                            <%
//                                get ticker created usr
                                UmUser createdUser = (UmUser) ses.load(UmUser.class, selectedTicket.getCreatedBy());
                            %>
                            <img src="${pageContext.request.contextPath}/ImageServlet/<%=createdUser.getRemark1()%>" class=" rounded-pill" />
                        </span>
                    </div> 
                </h1>
            </div>
            <div class="col-sm-1"></div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label>Assigned to</label>
            </div>
            <div class="col-sm-6">

                <div class="avatars">
                    <%
                        List<TmTicketsHasUmUser> loadUsersByTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
                        if (!loadUsersByTicket.isEmpty()) {
                            for (TmTicketsHasUmUser ticketUsrs : loadUsersByTicket) {
                    %>
                    <span class="avatar">
                        <img src="${pageContext.request.contextPath}/ImageServlet/<%=ticketUsrs.getUmUser().getRemark1()%>" class=" rounded-pill" title="<%=ticketUsrs.getUmUser().getFirstName()%>&nbsp;<%=ticketUsrs.getUmUser().getLastName()%>" />
                    </span>>
                    <%}
                        }%>
                </div> 
            </div>
            <div class="col-sm-4">
                <label><b>Total Expenses</b> &nbsp;&nbsp;&nbsp; <%=selectedTicket.getTotalExpence()%> Rs</label>
            </div>
        </div>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <h4><%=selectedTicket.getTicketName()%> <small><%=selectedTicket.getCreatedAt()%></small></h4>
                <label>
                    <%
                        String ticketLocation = "";
                        if (selectedTicket.getLmLocations() != null) {
                            ticketLocation = " | " + selectedTicket.getLmLocations().getLocationName();
                        }
                    %>
                    Ticket Description<%=ticketLocation%>
                </label><br><br>
                <div class="row">
                    <div class="col p-2">
                        <lable>
                            <%=selectedTicket.getTicketDescription()%>
                        </lable>
                    </div>
                    <%

                        List<TmTicketMedia> getTicketMediaByTicket = new com.ring.ticketManagementModel.TMS_TM_Ticket_Media().getTicketMediaByTicketd(ses, selectedTicket.getId());
                        if (!getTicketMediaByTicket.isEmpty()) {
                            for (TmTicketMedia ticketMedi : getTicketMediaByTicket) {
                                String filename = ticketMedi.getMediaPath();
                                String extensionRemoved = filename.split("\\.")[1];
                                if (extensionRemoved.equalsIgnoreCase("png") || extensionRemoved.equalsIgnoreCase("GIF") || extensionRemoved.equalsIgnoreCase("JPEG") || extensionRemoved.equalsIgnoreCase("TIFF") || extensionRemoved.equalsIgnoreCase("JPG")) {
                    %>
                    <div class="p-1">
                        <a href="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>" data-lightbox="image-<%=ticketMedi.getId()%>" data-title="My caption">
                            <img class="img-thumbnail" style="min-width: 40px;max-width: 100px;" src="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>"/>
                        </a>
                    </div>
                    <%} else if (extensionRemoved.equalsIgnoreCase("mp4")) {%>
                    <div class="p-1">
                        <!--                                                            <video width="400" controls>
                                                                                        <source src="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>" type="video/mp4">
                                                                                    </video>-->
                        <a href="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>" download>Download Video</a>
                                                                                                                                                <!--<object width="230" height="280" data="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>" type="application/pdf" ></object>-->
                    </div>
                    <%} else if (extensionRemoved.equalsIgnoreCase("pdf")) {%>
                    <div class="p-1">
                        <a href="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>" target="_blank">View PDF</a>
                    </div>
                    <%}%>
                    <%}
                        }%>
                    <!--                    <div class="col">
                                            <img class="img-fluid" src="https://m.majorgeeks.com/index.php?ct=content&action=file&id=480"/>    
                                        </div>
                                        <div class="col"> <button class="btn btn-info">Download</button></div>-->
                </div>

            </div>
        </div>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="row">
                    <div class="col">
                        <!--BEGIN Chat for ticket-->
                        <ul class=" mb-4 me-4">
                            <%                                List<TmTicketReply> loadTicketReplyByTicketId = new com.ring.ticketManagementModel.TMS_TM_Ticket_Reply().getTicketReplyByTicketId(ses, selectedTicket.getId());
                                if (!loadTicketReplyByTicketId.isEmpty()) {
                                    for (TmTicketReply ticketReply : loadTicketReplyByTicketId) {
                                        UmUser replyUser = (UmUser) ses.load(UmUser.class, ticketReply.getCreatedBy());
//                                        String replyMsg = ticketReply.getReplyDescription();
//                                        String repFinalMsg = Jsoup.clean(replyMsg, new Whitelist());

                            %>
                            <li style="list-style-type: none;">
                                <div class="row p-1 glass-effect" >
                                    <div class="col-1 col-xs-3 pe-1 "><img src="${pageContext.request.contextPath}/ImageServlet/<%=replyUser.getRemark1()%>" alt="" class="rounded-3 img-fluid" />
                                        <%
                                            if (replyUser.getPmUserRole() != null) {
                                        %>
                                        <span class="badge fw-bold fs-10px rounded-2 bg-info"><%=replyUser.getPmUserRole().getUserRoleName()%></span></div>
                                        <%}%>
                                    <div class="col-10 col-xs-9">
                                        <div class="post-user" style="font-size: smaller;"><a href="#"><%=replyUser.getFirstName()%> <%=replyUser.getLastName()%></a> <small>SAYS</small>  <label><%=ticketReply.getCreatedAt()%> </label></div>
                                        <div class="post-content" style="color: white;font-weight: 400;"> 
                                            <label><%=ticketReply.getReplyDescription()%></label>
                                            <%
                                                List<TmReplyMedia> getReplyMediaByReply = new com.ring.ticketManagementModel.TMS_TM_Reply_Media().getReplyMediaByReplyId(ses, ticketReply.getId());
                                                if (!getReplyMediaByReply.isEmpty()) {
                                                    for (TmReplyMedia replyMedi : getReplyMediaByReply) {
                                                        String replyMediaPath = replyMedi.getMediaPath();
                                                        String extensionRemovedReplyMedi = replyMediaPath.split("\\.")[1];
                                                        if (extensionRemovedReplyMedi.equalsIgnoreCase("png") || extensionRemovedReplyMedi.equalsIgnoreCase("GIF") || extensionRemovedReplyMedi.equalsIgnoreCase("JPEG") || extensionRemovedReplyMedi.equalsIgnoreCase("TIFF") || extensionRemovedReplyMedi.equalsIgnoreCase("JPG")) {
                                            %>
                                            <div class="p-1">
                                                <a href="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>" data-lightbox="image-<%=replyMedi.getId()%>" data-title="My caption">
                                                    <img class="img-thumbnail" style="min-width: 40px;max-width: 100px;" src="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>"/>
                                                </a>
                                            </div>
                                            <%} else if (extensionRemovedReplyMedi.equalsIgnoreCase("mp4")) {%>
                                            <div class="p-1">
                                                <!--                                                            <video width="400" controls>
                                                                                                                <source src="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>" type="video/mp4">
                                                                                                            </video>-->
                                                <a href="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>" download>Download Video</a>
                                                                                                                                                                        <!--<object width="230" height="280" data="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>" type="application/pdf" ></object>-->
                                            </div>
                                            <%} else if (extensionRemovedReplyMedi.equalsIgnoreCase("pdf")) {%>
                                            <div class="p-1">
                                                <a href="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>" target="_blank">View PDF</a>
                                            </div>
                                            <%}%>
                                            <%}
                                                }%>
                                        </div>

                                    </div>
                                </div>
                            </li>
                            <br>
                            <%}
                                }%>
                            <!--                            <li style="list-style-type: none;" class="mt-2">
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
                                                        </li>-->
                            <!--                            <li style="list-style-type: none;"class="mt-2">
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
                                                        </li>-->
                        </ul>
                        <!--END Chat for ticket-->
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <!--BEGIN Chat Reply form-->

                        <div class="card">
                            <div class="card-body">

                                <div class="form-group mb-3">
                                    <label style="color: #fff">Assigned Users</label>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped" id="addUserToTicketC">
                                            <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>Name</th>
                                                    <th>Designation</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    List<TmTicketsHasUmUser> loadTicketHasUSer = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
                                                    if (!loadTicketHasUSer.isEmpty()) {
                                                        for (TmTicketsHasUmUser elemTHU : loadTicketHasUSer) {
                                                %>
                                                <tr>
                                                    <td><%=elemTHU.getUmUser().getId()%></td>
                                                    <td><%=elemTHU.getUmUser().getFirstName()%> <%=elemTHU.getUmUser().getLastName()%></td>
                                                    <td></td>

                                                </tr>
                                                <%}
                                                    }%>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <!--END Chat Reply form-->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(".default-select2").select2();

</script>

<%}%>

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