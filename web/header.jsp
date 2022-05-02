<%-- 
    Document   : header
    Created on : Nov 23, 2021, 1:10:21 PM
    Author     : dinuka
--%>

<%@page import="com.ring.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Transaction"%>
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
        try {
%>
<!-- BEGIN #header -->
<div id="header" class="app-header">
    <!-- BEGIN navbar-header -->
    <div class="navbar-header">
        <a href="home.jsp" class="navbar-brand"><img src="assets/img/logo/white-logo.png" class="img-fluid"> Ticket Management</a>
        <button type="button" class="navbar-mobile-toggler" data-toggle="app-sidebar-mobile">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
    </div>
    <!-- END navbar-header -->
    <!-- BEGIN header-nav -->
    <div class="navbar-nav">
        <div class="navbar-item navbar-form">
            <form action="" method="POST" name="search">
                <div class="form-group">
                    <input class="form-control" type="text"  id="ticketKetToType" name="ticketKetToType" />
                    <button type="button" class="btn btn-search" onclick="viewTicketFromHeaderSearch()"><i class="fa fa-search"></i></button>
                </div>
            </form>
        </div>
<!--        <div class="navbar-item dropdown">
            <a href="#" data-bs-toggle="dropdown" class="navbar-link dropdown-toggle icon">
                <i class="fa fa-bell"></i>
                <span class="badge">0</span>
            </a>
            <div class="dropdown-menu media-list dropdown-menu-end">
                <div class="dropdown-header">NOTIFICATIONS (0)</div>
                <div class="text-center w-300px py-3 text-inverse">
                    No notification found
                </div>
            </div>
        </div>-->
        <div class="navbar-item navbar-user dropdown">
            <a href="#" class="navbar-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown">
<!--                <div class="image image-icon bg-gray-800 text-gray-600">
                    <i class="fa fa-user"></i>
                </div>-->
                    <span class="avatar"><img src="${pageContext.request.contextPath}/ImageServlet/<%=logedUser.getRemark1()%>" /></span>
                    <b class="caret"></b>
                
            </a>
            <div class="dropdown-menu dropdown-menu-end me-1">
                <a class="dropdown-item" onclick="logedUserProfileUpdateView(<%=logedUser.getId()%>)">Edit Profile</a>
                <!--<a href="javascript:;" class="dropdown-item">Setting</a>-->
                <div class="dropdown-divider"></div>
                <a href="userManagement_userLogout" class="dropdown-item">Log Out</a>
            </div>
        </div>
    </div>
    <!-- END header-nav -->
</div>
<!-- END #header -->
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