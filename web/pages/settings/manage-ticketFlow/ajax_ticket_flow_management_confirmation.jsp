<%-- 
    Document   : ajax_ticket_flow_management_confirmation
    Created on : Jan 5, 2022, 8:32:51 PM
    Author     : buddh
--%>

<%@page import="com.it.configurationModel.NumberFortmaing"%>
<%@page import="com.it.db.TmReplyMedia"%>
<%@page import="com.it.db.TmTicketMedia"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.it.db.QmSubCategoriesHasUser"%>
<%@page import="com.it.db.QmCategoriesHasUser"%>
<%@page import="com.it.db.TmTicketsHasUmUser"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.QmQueueHasUser"%>
<%@page import="com.it.db.TmTicketReply"%>
<%@page import="java.util.List"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="com.it.db.TmTickets"%>
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
            int queId = Integer.parseInt(request.getParameter("queId"));
            TmTickets selectedTicket = (TmTickets) ses.load(TmTickets.class, Integer.parseInt(request.getParameter("ticketId")));
            if (selectedTicket != null) {
%> 
<div class="row">
    <div class="col-sm-12">
        <div class="row" style="height:150px;"><!--top row with details start-->
            <div class="col d-flex flex-column align-items-start">
                <div class="d-flex flex-row">
                    <div class="d-flex me-2">
                        <span class="page-header" style="font-size: 24px"> View Ticket  &nbsp;&nbsp; <small style="font-size: 15px"> <%=selectedTicket.getTid()%> </small> 

                        </span>
                    </div>

                    <%
                        TmTicketsHasUmUser checkLogedUserInTicket = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getUsersByTicketIdAndUserId(ses, selectedTicket.getId(), logedUser.getId());

                    %>
                    <div class="d-flex flex-wrap">
                        <%--
                        <%                            QmQueueHasUser checkLogedUserInQueue = new com.it.queueManagementModel.QMS_QM_Queue_Has_User().getUsersByQueueId(ses, selectedTicket.getQmQueue().getId(), logedUser.getId());
                            QmCategoriesHasUser checkLogedUserInCategory = null;
                            QmSubCategoriesHasUser checkLogedUserInSubCategory = null;
                            if (selectedTicket.getQmCategories() != null) {
                                checkLogedUserInCategory = new com.it.queueManagementModel.QMS_QM_Categories_Has_User().getUsersByCategoryId(ses, selectedTicket.getQmCategories().getId(), logedUser.getId());
                            }
                            if (selectedTicket.getQmSubCategories() != null) {
                                checkLogedUserInSubCategory = new com.it.queueManagementModel.QMS_QM_Sub_Categories_Has_User().getUsersBySubCategoryId(ses, selectedTicket.getQmSubCategories().getId(), logedUser.getId());
                            }
                            if ((checkLogedUserInQueue != null || checkLogedUserInCategory != null || checkLogedUserInSubCategory != null) && (selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETPENDING || selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETACTIVE)) {
                        %>
                        <div id="FERDIV"><button type="button" class="btn btn-gray btn-sm" onclick="forwardTicketLoad(<%=selectedTicket.getId()%>,<%=queId%>)"><i class="fa fa-arrow-right"></i></button></div>
                                <%}%>
                        --%>
                        <!--<button type="button" class="btn btn-default btn-sm"><i class="fa fa-trash"></i></button>-->


                        <%
                            if (checkLogedUserInTicket != null && selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETACTIVE) {
                        %>
                        <div id="STRTBTN"><button type="button" class="btn btn-info btn-sm" onclick="startTicket()">Start</button></div>
                        <%}%>
                        <%
                            if (checkLogedUserInTicket != null && selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETSTARTED) {
                        %>
                        <div id="CMPLTBTN"><button type="button" class="btn btn-info btn-sm" onclick="completeTicket()">Complete</button></div>
                        <%}%>
                        <%
                            if ((selectedTicket.getCreatedBy() == logedUser.getId()) && (selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETCOMPLETED)) {
                        %>
                        <div class="d-flex flex-row">
                            <div id="COFRMBTN"><button type="button" class="btn btn-info btn-sm" onclick="confirmTicket()">Confirm</button></div>
                            <div id="RJTBTN"><button type="button" class="btn btn-danger btn-sm" onclick="rejectTicket()">Reject</button></div>
                        </div>
                        <%}%>
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <div class=" border-0 d-flex flex-wrap align-items-end flex-fill" style="margin-top: 18px;
                             ">

                            <div class="p-2 bg-white-transparent-2 me-2" style="height: 61px;">


                                <small>Assigned to</small>
                                <div class="d-flex align-items-centermb-1">
                                    <div class="avatars">
                                        <%
                                            List<TmTicketsHasUmUser> loadUsersByTicket = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
                                            if (!loadUsersByTicket.isEmpty()) {
                                                for (TmTicketsHasUmUser ticketUsrs : loadUsersByTicket) {
                                        %>
                                        <span class="avatar" style="width:24px;height:24px;">
                                            <img style="width: 24px;height: 24px;" src="${pageContext.request.contextPath}/ImageServlet/<%=ticketUsrs.getUmUser().getRemark1()%>" class=" rounded-pill" title="<%=ticketUsrs.getUmUser().getFirstName()%>&nbsp;<%=ticketUsrs.getUmUser().getLastName()%>" />
                                        </span>
                                        <%}
                                            }%>
                                    </div> 
                                </div>


                            </div>
<%--
                            <div class="p-2 bg-white-transparent-2  me-2 " style="height: 61px;">
                                <%
                                    String ticketLocation = "";
                                    if (selectedTicket.getLmLocations() != null) {
                                        ticketLocation = selectedTicket.getLmLocations().getLocationName();
                                    }
                                %>
                                <small>Location</small><br>
                                <div class="d-flex align-items-centermb-1">
                                    <h5 class="m-0"><%=ticketLocation%></h5>
                                </div>

                            </div>

                            <div class="p-2 bg-white-transparent-2 ms-auto " style="height: 61px;">
                                <small>Total Expenses</small>
                                <div class="d-flex align-items-centermb-1">
                                    <h5 class="m-0"> Rs <%=NumberFortmaing.currencyFormat(selectedTicket.getTotalExpence())%></h5>
                                </div>
                            </div><!--was cardbody-->

                        </div><!--was card-->
--%>
                    </div>

                </div>
            </div>
        </div>
    </div><!--top row with details-->

    <div class="row ">
        <div class="col">
            <div class="panel panel-inverse " id="chatContent" data-scrollbar="true" style="height:65vh" data-heght="65vh" >
                <div class="panel-body">
                    <div class="row">
                        <div class="col">


                            <div class="panel panel-inverse mb-2" >
                                <div class="panel-body" >
                                    <%
                                        //                                get ticker created usr
                                        UmUser createdUser = (UmUser) ses.load(UmUser.class, selectedTicket.getCreatedBy());
                                    %>
                                    <!--                                    <div class="row">
                                                                            <div class="col">
                                                                              
                                    
                                    
                                    
                                                                                <label style="font-weight: bold;">
                                    
                                                                                </label>
                                    
                                                                                <label>
                                                                                    Location: 
                                                                                </label>
                                                                                <label>
                                                                                    Description:
                                                                                </label><br>
                                    
                                                                                <lable>
                                    
                                                                                </lable>
                                                                            </div>
                                    
                                                                            <div class="col">
                                    
                                                                                                    <div class="col">
                                                                                                        <img class="img-fluid" src="https://m.majorgeeks.com/index.php?ct=content&action=file&id=480"/>    
                                                                                                    </div>
                                                                                                    <div class="col"> <button class="btn btn-info">Download</button></div>
                                    
                                                                            </div>
                                                                        </div> row end-->


                                    <div class="row">
                                        <div class="col">
                                            <div class="d-flex flex-column">
                                                <span style="font-weight: bolder"><b>Ticket Name: &nbsp;</b><%=selectedTicket.getTicketName()%></span>
                                                <span >
                                                    <nav aria-label="breadcrumb" >
                                                        <ol class="breadcrumb">
                                                            <li class="breadcrumb-item"><%=selectedTicket.getQmQueue().getQueueName()%></li>
                                                                <%
                                                                    if (selectedTicket.getQmCategories() != null) {
                                                                %>
                                                            <li class="breadcrumb-item" aria-current="page"><%=selectedTicket.getQmCategories().getCategoryName()%></li>
                                                                <%
                                                                    }
                                                                    if (selectedTicket.getQmSubCategories() != null) {
                                                                %>
                                                            <li class="breadcrumb-item active" aria-current="page"><%=selectedTicket.getQmSubCategories().getSubCategoryName()%></li>
                                                                <%
                                                                    }
                                                                %>
                                                        </ol>
                                                    </nav>
                                                </span>
                                            </div>
                                            <div class="d-flex">
                                                <a class="w-60px" href="#">
                                                    <img style="width: 60px;height:60px;" src="${pageContext.request.contextPath}/ImageServlet/<%=createdUser.getRemark1()%>" title="<%=createdUser.getFirstName()%>&nbsp;<%=createdUser.getLastName()%>" class="rounded-3" />
                                                </a>
                                                <div class="ps-3 flex-1">
                                                    <span class="mb-1" style="font-size: large;"><%=createdUser.getFirstName()%>&nbsp;<%=createdUser.getLastName()%></a> <small>SAYS </small>  <small><%=selectedTicket.getCreatedAt()%></small>
                                                        <%
                                                            if (createdUser.getPmUserRole() != null) {
                                                        %>
                                                        <span class="badge fw-bold fs-10px rounded-2 bg-info ms-1"><%=createdUser.getPmUserRole().getUserRoleName()%></span>
                                                        <%}%>
                                                    </span>
                                                    <div class=" flex-row">

                                                        <span><%=selectedTicket.getTicketDescription()%> 
                                                            <%if (selectedTicket.getUmCustomer() != null) {%>
                                                            attached to Customer <b><%=selectedTicket.getUmCustomer().getCustomerName()%></b> 
                                                            Customer Contact Number <b><%=selectedTicket.getUmCustomer().getMobileNumber()%></b> 

                                                            <%}%>
                                                        </span>
                                                    </div>
                                                    <div class="d-flex flex-wrap flex-row m-1">
                                                        <%

                                                            List<TmTicketMedia> getTicketMediaByTicket = new com.it.ticketManagementModel.TMS_TM_Ticket_Media().getTicketMediaByTicketd(ses, selectedTicket.getId());
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
                                                        <%} else if (extensionRemoved.equalsIgnoreCase("mp4") || extensionRemoved.equalsIgnoreCase("mp3")) {%>
                                                        <div class="p-1">
                                                            <!--                                                            <video width="400" controls>
                                                                                                                            <source src="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>" type="video/mp4">
                                                                                                                        </video>-->
                                                            <a href="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>" download>Download</a>
                                                                                                                                                                                    <!--<object width="230" height="280" data="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>" type="application/pdf" ></object>-->
                                                        </div>
                                                        <%} else if (extensionRemoved.equalsIgnoreCase("pdf") || extensionRemoved.equalsIgnoreCase("doc") || extensionRemoved.equalsIgnoreCase("docx") || extensionRemoved.equalsIgnoreCase("csv") || extensionRemoved.equalsIgnoreCase("xls") || extensionRemoved.equalsIgnoreCase("xlsx")) {%>
                                                        <div class="p-1">
                                                            <a href="${pageContext.request.contextPath}/ImageServlet/<%=ticketMedi.getMediaPath()%>" target="_blank">View Document</a>
                                                        </div>
                                                        <%}%>
                                                        <%}
                                                            }%>
                                                    </div>

                                                </div>
                                            </div>  
                                        </div>
                                    </div><!-- created ticket description -->

                                </div>
                            </div>

                        </div>
                    </div><!--row2-->
                    <div class="row">
                        <div class="col">
                            <!--BEGIN Chat for ticket-->

                            <%
                                List<TmTicketReply> loadTicketReplyByTicketId = new com.it.ticketManagementModel.TMS_TM_Ticket_Reply().getTicketReplyByTicketId(ses, selectedTicket.getId());
                                if (!loadTicketReplyByTicketId.isEmpty()) {
                                    for (TmTicketReply ticketReply : loadTicketReplyByTicketId) {
                                        UmUser replyUser = (UmUser) ses.load(UmUser.class, ticketReply.getCreatedBy());
                                        //                                        String replyMsg = ticketReply.getReplyDescription();
                                        //                                        String repFinalMsg = Jsoup.clean(replyMsg, new Whitelist());

                            %>
                            <div class="d-flex">
                                <a class="w-60px" href="#">
                                    <img style="width: 60px;height: 60px;" src="${pageContext.request.contextPath}/ImageServlet/<%=replyUser.getRemark1()%>" alt="" class="rounded-3"  style="min-width: 30px;max-width: 50px" title="<%=replyUser.getFirstName()%>&nbsp;<%=replyUser.getLastName()%>" />
                                </a>
                                <div class="ps-3 flex-1">
                                    <h5 class="mb-1"><%=replyUser.getFirstName()%> <%=replyUser.getLastName()%></a> <small>SAYS</small>  <small><%=ticketReply.getCreatedAt()%> </small>
                                        <%
                                            if (replyUser.getPmUserRole() != null) {
                                        %>
                                        <span class="badge fw-bold fs-10px rounded-2 bg-info ms-1"><%=replyUser.getPmUserRole().getUserRoleName()%></span>
                                        <%}%>
                                    </h5>
                                    <div class=" flex-row">
                                        <span><%=ticketReply.getReplyDescription()%>
                                            <%--
                                            <%
                                                if (ticketReply.getReplyExpence() != null) {
                                            %>
                                            <span class="badge fw-bold fs-10px rounded-2 bg-danger ms-1">Expense added <%=NumberFortmaing.currencyFormat(ticketReply.getReplyExpence())%> Rs</span>
                                            <%}%>
                                            --%>
                                        </span>
                                    </div>
                                    <div class="d-flex flex-wrap flex-row m-1">
                                        <%
                                            List<TmReplyMedia> getReplyMediaByReply = new com.it.ticketManagementModel.TMS_TM_Reply_Media().getReplyMediaByReplyId(ses, ticketReply.getId());
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
                                        <%} else if (extensionRemovedReplyMedi.equalsIgnoreCase("mp4") || extensionRemovedReplyMedi.equalsIgnoreCase("mp3")) {%>
                                        <div class="p-1">
                                            <!--                                                            <video width="400" controls>
                                                                                                            <source src="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>" type="video/mp4">
                                                                                                        </video>-->
                                            <a href="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>" download>Download</a>
                                                                                                                                                                    <!--<object width="230" height="280" data="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>" type="application/pdf" ></object>-->
                                        </div>
                                        <%} else if (extensionRemovedReplyMedi.equalsIgnoreCase("pdf") || extensionRemovedReplyMedi.equalsIgnoreCase("doc") || extensionRemovedReplyMedi.equalsIgnoreCase("docx") || extensionRemovedReplyMedi.equalsIgnoreCase("csv") || extensionRemovedReplyMedi.equalsIgnoreCase("xls") || extensionRemovedReplyMedi.equalsIgnoreCase("xlsx")) {%>
                                        <div class="p-1">
                                            <a href="${pageContext.request.contextPath}/ImageServlet/<%=replyMedi.getMediaPath()%>" target="_blank">View Document</a>
                                        </div>
                                        <%}%>
                                        <%}
                                            }%>
                                    </div>

                                </div>
                            </div>   
                            <hr class="bg-gray-200" />    

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

                            <!--END Chat for ticket-->
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <!--BEGIN Chat Reply form-->
                            <%--
                            <%
                                //                                check log user is in selected queu
                                QmQueueHasUser checkLogedUserInQueueTC = new com.it.queueManagementModel.QMS_QM_Queue_Has_User().getUsersByQueueId(ses, queId, logedUser.getId());
                                if (checkLogedUserInQueueTC != null) {
                            %>
                            <input type="hidden" id="checkUserInQueueTC" value="1">
                            <%} else {%>
                            <input type="hidden" id="checkUserInQueueTC" value="0">
                            <%}%>
                            --%>
                            <div class="card">
                                <div class="card-body">
                                    <%
                                        if ((selectedTicket.getCreatedBy() == logedUser.getId())) {
                                    %>
                                    <div class="row mb-3">
                                        <div class="form-group col-md-6">
                                            <label style="color: #fff">Add User to Ticket</label>
                                            <select class="form-control default-select2" style="color: #fff" id="userToTicketC">
                                                <option selected="" value="0" style="color: #000">-- Select User --</option>
                                                <%
                                                    List<UmUser> loadUsersToTicketC = new com.it.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                                    if (!loadUsersToTicketC.isEmpty()) {
                                                        for (UmUser elemTC : loadUsersToTicketC) {

                                                %>
                                                <option value="<%=elemTC.getId()%>" style="color: #000"><%=elemTC.getFirstName()%> <%=elemTC.getLastName()%></option> 
                                                <%}
                                                    }%>
                                            </select>
                                        </div>
                                        <div class="form-group col-md-6" id="ADDUSRTOTCKBTN">
                                            <label></label><br>
                                            <%
                                                if (selectedTicket.getCreatedBy() == logedUser.getId()) {
                                            %>
                                            <button type="button" class="btn btn-green" onclick="addUserToTicketC()">Add</button>
                                            <%}%>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label style="color: #fff">Assigned Users</label>
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped" id="addUserToTicketC">
                                                <thead>
                                                    <tr>
                                                        <th>#</th>
                                                        <th>Name</th>
                                                        <th>Designation</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        List<TmTicketsHasUmUser> loadTicketHasUSer = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
                                                        if (!loadTicketHasUSer.isEmpty()) {
                                                            for (TmTicketsHasUmUser elemTHU : loadTicketHasUSer) {
                                                    %>
                                                    <tr>
                                                        <td><%=elemTHU.getUmUser().getId()%></td>
                                                        <td><%=elemTHU.getUmUser().getFirstName()%> <%=elemTHU.getUmUser().getLastName()%></td>
                                                        <td></td>
                                                        <td>
                                                            <%--
                                                            <%
                                                                if (checkLogedUserInQueueTC != null) {
                                                                    if (elemTHU.getUmUser().getId() != selectedTicket.getCreatedBy()) {
                                                            %>
                                                            <button onclick="removeUserFromTicket(<%=elemTHU.getUmUser().getId()%>,<%=elemTHU.getTmTickets().getId()%>)" type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>
                                                            <%}
                                                                }%>
                                                            --%>
                                                        </td>
                                                    </tr>
                                                    <%}
                                                        }%>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <%}%>
                                    <%
                                        if ((checkLogedUserInTicket != null) || selectedTicket.getCreatedBy() == logedUser.getId()) {
                                    %>
                                    <form method="POST" enctype="multipart/form-data" id="fileUploadForm">
                                        <div class="row mb-3">
                                            <div class="col">
                                                <label for="replyText" class="form-label" style="color: #fff">Type your Reply</label>
                                                <textarea class="summernote" name="ticketReplyDetails" id="ticketReplyDetails"></textarea>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <!--                                    <a class="btn glass-effect col-sm-2"  onclick="displayDiv()"><span class="fa fa-paperclip"></span> Attach File</a>
                                                                                <div class="col-sm-4"></div>-->
                                            <div class="col-xs-12 col-xxl-4 mb-1 ">
                                                <input type="file" class="form-control" id="ticketReplyFiles" name="ticketReplyFiles" multiple="multiple">
                                                <input type="hidden" id="ticketToReply" name="ticketToReply" value="<%=selectedTicket.getId()%>">
                                            </div>
<!--                                            <label class="col-xs-12 col-sm-3 col-xxl-2 mb-1 mt-1" style="color: #fff;text-align: right"><span class="fa fa-dollar-sign"></span> Expenses</label>
                                            <div class="col-xs-12 col-sm-6 col-xxl-3 mb-1"> <input type="number" class=" form-control" min="0" id="expenses" name="expenses" value="0"></div>-->
                                               
                                            <div class="col-xs-12 col-sm-12 col-xxl-3 float-end" id="ADDRPLBTN"><button type="button" class="col-sm-2 btn btn-primary float-end" style="width: 100%" onclick="addReply()">Send Reply</button></div>
                                           
                                            <!--<button class="btn btn-success float-end">Send</button>-->
                                        </div>
                                    </form>
                                    <!--                                <div class="row mb-3" id="dropzoneDiv" style="display:none;">
                                                                        <div class="col">
                                                                            <div id="dropzone">
                                                                                <form action="/upload" class="dropzone needsclick dz-clickable" id="imageAttachZone">
                                                                                    <div class="dz-message needsclick">
                                                                                        Drop files <b>here</b> or <b>click</b> to upload.<br>
                                                                                        <span class="dz-note needsclick">
                                                                                            (This is just a demo dropzone. Selected files are <strong>not</strong> actually uploaded.)
                                                                                        </span>
                                                                                    </div>
                                                                                </form>
                                                                            </div>
                                                                        </div>
                                                                    </div>-->
                                    <%}%>
                                </div>
                            </div>
                            <!--END Chat Reply form-->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div><!--row 3-->




</div>
</div>



<script type="text/javascript">

    //    var b = document.querySelector("#chatContent");
    //
    //    b.setAttribute("data-scrollbar", "true");
    //    b.setAttribute("data-height", "40vh");
    //    b.setAttribute("data-init", "true");
    //    b.setAttribute("style", "height:40vh;");







    $(".default-select2").select2();
    $(".summernote").summernote({
        height: "150",
        color: "#000000",
        toolbar: [
            // [groupName, [list of button]]
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['fontsize', ['fontsize']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']]
        ]
    });


    //    dropzone uploader
    //    function displayDiv() {
    //        var x = document.getElementById("dropzoneDiv");
    //        if (x.style.display === "none") {
    //            x.style.display = "block";
    //            Dropzone.discover();
    //        } else {
    //            x.style.display = "none";
    //        }
    //    }
    //
    //    Dropzone.options.imageAttachZone = {// camelized version of the `id`
    //        paramName: "file", // The name that will be used to transfer the file
    //        maxFilesize: 2, // MB
    //        accept: function (file, done) {
    //            if (file.name == "justinbieber.jpg") {
    //                done("Naha, you don't.");
    //            } else {
    //                done();
    //            }
    //        }
    //    };




    //    function for add users to ticket 
    function addUserToTicketC() {
        var user = $('#userToTicketC option:selected').val();

        if (user === "0") {
            swal("", "Select User", "warning");
        } else {
            $.ajax({
                url: "ticketManagement_addUserToTicket",
                type: "POST",
                data: "user=" + user + "&ticketId=" + <%=selectedTicket.getId()%>,
                beforeSend: function (xhr) {
                    $('#ADDUSRTOTCKBTN').empty();
                    $('#ADDUSRTOTCKBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#ADDUSRTOTCKBTN').empty();
                    $('#ADDUSRTOTCKBTN').html("<label></label><br><button type='button' class='btn btn-green' onclick='addUserToTicketC()'>Add</button>");
                },
                error: function (error) {
                }
            });
        }
    }
    //    function for remove users from ticket 
    function removeUserFromTicket(userId, ticketId) {
        $.ajax({
            url: "ticketManagement_removeUserFromTicket",
            type: "POST",
            data: "userId=" + userId + "&ticketId=" + ticketId,
            beforeSend: function (xhr) {
                //                $('#ADDUSRTOTCKBTN').empty();
                //                $('#ADDUSRTOTCKBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
                //                $('#ADDUSRTOTCKBTN').empty();
                //                $('#ADDUSRTOTCKBTN').html("<button type='button' class='btn btn-green' onclick='addUserToTicketC()'>Add</button>");
            },
            error: function (error) {
            }
        });
    }

    //    function for add new Reply
    function addReply() {
        var ticketReplyD = $('#ticketReplyDetails').summernote('code');
//        var expenses = $('#expenses').val();
        //    alert(ticketReplyD);
            event.preventDefault();
            // Get form
            var form = $('#fileUploadForm')[0];
            // Create an FormData object 
            var data = new FormData(form);
            // If you want to add an extra field for the FormData
            var encodedReply = encodeURIComponent(ticketReplyD);
            //            alert(encodedString);
            // If you want to add an extra field for the FormData
            data.append("encodedReply", encodedReply);

            // disabled the submit button
            //        $("#btnSubmit").prop("disabled", true);
            $.ajax({
                type: "POST",
                enctype: 'multipart/form-data',
                url: "ticketManagement_addReply",
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                beforeSend: function (xhr) {
                    $('#ADDRPLBTN').empty();
                    $('#ADDRPLBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#ADDRPLBTN').empty();
                    $('#ADDRPLBTN').html("<button type='button' class='col-sm-2 btn btn-primary float-end' style='width: 100%' onclick='addReply()'>Send Reply</button>");
                },
                error: function (e) {
                    $("#result").text(e.responseText);
                    console.log("ERROR : ", e);
                    $("#btnSubmit").prop("disabled", false);
                }
            });
        

        //        var checkTicketAssignedToUser = $("#checkTicketAssignedToUser").val();
        //        var rep = "";
        //        var expenses = "0";
        //        if (checkTicketAssignedToUser === "1") {
        //            var replyDetails = $('.summernote').summernote('code');
        //            var encodedString = encodeURI(replyDetails);
        //            rep = encodedString;
        //            expenses = $("#expenses").val();
        //        }
        ////        alert(expenses);
        //
        //        $.ajax({
        //            url: "ticketManagement_addReply",
        //            type: "POST",
        //            data: "ticketId=" + <%=selectedTicket.getId()%> + "&reply=" + rep + "&expenses=" + expenses,
        //            beforeSend: function (xhr) {
        //                $('#ADDRPLBTN').empty();
        //                $('#ADDRPLBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
        //            },
        //            success: function (data) {
        //                var resultValue = JSON.parse(data);
        //                if (resultValue.result === "0") {
        //                    swal("", resultValue.displayMessage, "error");
        //                } else if (resultValue.result === "2") {
        //                    swal("", resultValue.displayMessage, "error");
        //                    setTimeout(function () {
        //                        window.location.href = "../../../index.jsp";
        //                    }, 2000);
        //                } else if (resultValue.result === "1") {
        //                    confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
        //                    swal({
        //                        title: "Done",
        //                        text: resultValue.displayMessage,
        //                        timer: 1000,
        //                        showConfirmButton: false
        //                    });
        //                }
        //                $('#ADDRPLBTN').empty();
        //                $('#ADDRPLBTN').html("<button type='button' class='col-sm-2 btn btn-primary float-end' style='width: 100%' onclick='addReply()'>Send Reply</button>");
        //            },
        //            error: function (error) {
        //            }
        //        });

    }
    function forwardTicketLoad(ticketId, queuId) {
        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_forward_ticket.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&ticketId=" + ticketId + "&queuId=" + queuId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for start Ticket
    function startTicket() {
        $.ajax({
            url: "ticketManagement_startTicket",
            type: "POST",
            data: "ticketId=" + <%=selectedTicket.getId()%>,
            beforeSend: function (xhr) {
                $('#STRTBTN').empty();
                $('#STRTBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
                $('#STRTBTN').empty();
                $('#STRTBTN').html("<button type='button' class='btn btn-info btn-sm' onclick='startTicket()'>Start</button>");
            },
            error: function (error) {
            }
        });
    }
    //    function for complete Ticket
    function completeTicket() {
        $.ajax({
            url: "ticketManagement_completeTicket",
            type: "POST",
            data: "ticketId=" + <%=selectedTicket.getId()%>,
            beforeSend: function (xhr) {
                $('#CMPLTBTN').empty();
                $('#CMPLTBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
                $('#CMPLTBTN').empty();
                $('#CMPLTBTN').html("<button type='button' class='btn btn-info btn-sm' onclick='completeTicket()'>Complete</button>");
            },
            error: function (error) {
            }
        });

    }
    //    function for confirm Ticket 
    function confirmTicket() {
        $.ajax({
            url: "ticketManagement_confirmTicket",
            type: "POST",
            data: "ticketId=" + <%=selectedTicket.getId()%>,
            beforeSend: function (xhr) {
                $('#COFRMBTN').empty();
                $('#COFRMBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
                $('#COFRMBTN').empty();
                $('#COFRMBTN').html("<button type='button' class='btn btn-info btn-sm' onclick='confirmTicket()'>Confirm</button>");
            },
            error: function (error) {
            }
        });

    }
    //    function for reject Ticket 
    function rejectTicket() {
        $.ajax({
            url: "ticketManagement_rejectTicket",
            type: "POST",
            data: "ticketId=" + <%=selectedTicket.getId()%>,
            beforeSend: function (xhr) {
                $('#RJTBTN').empty();
                $('#RJTBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
                $('#RJTBTN').empty();
                $('#RJTBTN').html("<button type='button' class='btn btn-danger btn-sm' onclick='rejectTicket()'>Reject</button>");
            },
            error: function (error) {
            }
        });

    }
    function loadArchivedeDetails(ticketId, queueId) {
        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_archive_load_questions.jsp",
            type: "POST",
            data: "ticketId=" + ticketId + "&queueId=" + queueId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });

    }

    try {
        psChat = new PerfectScrollbar('#chatContent');
        $psChat.update();
    } catch (err) {
        console.log("scroll didnt work");
    }



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
