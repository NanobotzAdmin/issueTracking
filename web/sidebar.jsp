<%-- 
    Document   : sidebar
    Created on : Nov 23, 2021, 1:10:52 PM
    Author     : dinuka
--%>

<%@page import="com.it.db.TmTickets"%>
<%@page import="com.it.db.QmSubCategories"%>
<%@page import="com.it.db.QmCategories"%>
<%@page import="com.it.db.QmQueue"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
<%@page import="com.it.db.UmUserHasInterfaceComponent"%>
<%@page import="com.it.db.PmInterface"%>
<%@page import="java.util.List"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.PmInterfaceTopic"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") != null) {

        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {
%>
<div id="sidebar" class="app-sidebar">
    <!-- BEGIN scrollbar -->
    <div class="app-sidebar-content overflow-auto" data-scrollbar="true" data-height="100%" style="height:100%;" >
        <!-- BEGIN menu -->
        <div class="menu">
            <div class="menu-search mb-n3">
                <input type="text" class="form-control" placeholder="Sidebar menu filter..." data-sidebar-search="true">
            </div>

            <div class="menu-header">Queue List</div>

            <%
                List<QmQueue> loadAllActiveQueuesToSideBar = new com.it.queueManagementModel.QMS_QM_Queue().getAllQueuesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                if (!loadAllActiveQueuesToSideBar.isEmpty()) {
                    for (QmQueue queueSB : loadAllActiveQueuesToSideBar) {
                        List<TmTickets> getTicketsByQueueId = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsByQueueIdAndStatus(ses, queueSB.getId(),STATIC_DATA_MODEL.TICKETACTIVE);
                        String bgImagePath = "assets/img/login-gb/login-bg-10.jpg";
                        if (queueSB.getBackgroundImage() != null) {
                            bgImagePath = "";
                        }
            %>
            <div class="menu-item has-sub ">
                <a href="javascript:;" class="menu-link">
                    <div class="menu-icon">
                        <%
                            if(queueSB.getQueueIcon() != null){
                        %>
                        <i class="<%=queueSB.getQueueIcon()%>"></i>
                        <%}else{%>
                        <i class="fa fa-th-large"></i>
                        <%}%>
                    </div>
                    <%
                        if (queueSB.getBackgroundImage() != null) {
                    %>
                    <div class="menu-text" style="color: <%=queueSB.getQueueColor()%>"><div onclick="loadTicketPage('pages/settings/manage-ticketFlow/ticketFlow_management.jsp', 7,<%=queueSB.getId()%>, 0, 0, '${pageContext.request.contextPath}/ImageServlet/<%=queueSB.getBackgroundImage()%>')"><%=queueSB.getQueueName()%><span class="badge bg-light text-dark">  <%=getTicketsByQueueId.size()%>  </span></div></div>
                    <%} else {%>
                    <div class="menu-text" style="color: <%=queueSB.getQueueColor()%>"><div onclick="loadTicketPage('pages/settings/manage-ticketFlow/ticketFlow_management.jsp', 7,<%=queueSB.getId()%>, 0, 0, 'assets/img/login-bg/login-bg-10.jpg')"><%=queueSB.getQueueName()%><span class="badge bg-light text-dark">  <%=getTicketsByQueueId.size()%>  </span></div></div>
                    <%}%>
                    <div class="menu-caret"></div>
                </a>
                <div class="menu-submenu">
                    <%
                        List<QmCategories> loadCategoryByQueueIdToSB = new com.it.queueManagementModel.QMS_QM_Categories().getCategoryByQueueId(ses, queueSB.getId());
                        if (!loadCategoryByQueueIdToSB.isEmpty()) {
                            for (QmCategories categorySB : loadCategoryByQueueIdToSB) {
                                List<TmTickets> getTicketsByCategoryId = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsByCategoryIdAndStatus(ses, categorySB.getId(),STATIC_DATA_MODEL.TICKETACTIVE);
                    %>
                    <div class="menu-item has-sub">
                        <a href="javascript:;" class="menu-link">
                            <%
                                if (queueSB.getBackgroundImage() != null) {
                            %>
                            <div class="menu-text"><div onclick="loadTicketPage('pages/settings/manage-ticketFlow/ticketFlow_management.jsp', 7,<%=queueSB.getId()%>,<%=categorySB.getId()%>, 0, '${pageContext.request.contextPath}/ImageServlet/<%=queueSB.getBackgroundImage()%>')"><%=categorySB.getCategoryName()%><span class="badge bg-default">  <%=getTicketsByCategoryId.size()%>  </span></div></div>
                            <%} else {%>
                            <div class="menu-text"><div onclick="loadTicketPage('pages/settings/manage-ticketFlow/ticketFlow_management.jsp', 7,<%=queueSB.getId()%>,<%=categorySB.getId()%>, 0, 'assets/img/login-bg/login-bg-10.jpg')"><%=categorySB.getCategoryName()%><span class="badge bg-default">  <%=getTicketsByCategoryId.size()%>  </span></div></div>
                            <%}%>
                            <div class="menu-caret"></div>
                        </a>
                        <div class="menu-submenu">
                            <%
                                List<QmSubCategories> loadSubCategoryByCategoryIdSB = new com.it.queueManagementModel.QMS_QM_Sub_Categories().getSubCategoryBYCategoryId(ses, categorySB.getId());
                                if (!loadSubCategoryByCategoryIdSB.isEmpty()) {
                                    for (QmSubCategories subCategorySB : loadSubCategoryByCategoryIdSB) {
                                        List<TmTickets> getTicketsBySubCategory = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsBySubCategoryIdAndStatus(ses, subCategorySB.getId(),STATIC_DATA_MODEL.TICKETACTIVE);
                            %>
                            <div class="menu-item">
                                <a href="javascript:;" class="menu-link">
                                    <%
                                if (queueSB.getBackgroundImage() != null) {
                            %>
                                    <div class="menu-text"><div onclick="loadTicketPage('pages/settings/manage-ticketFlow/ticketFlow_management.jsp', 7,<%=queueSB.getId()%>,<%=categorySB.getId()%>,<%=subCategorySB.getId()%>, '${pageContext.request.contextPath}/ImageServlet/<%=queueSB.getBackgroundImage()%>')"><%=subCategorySB.getSubCategoryName()%><span class="badge bg-yellow text-dark">  <%=getTicketsBySubCategory.size()%>  </span></div> </div>
                                <%}else{%>
                                    <div class="menu-text"><div onclick="loadTicketPage('pages/settings/manage-ticketFlow/ticketFlow_management.jsp', 7,<%=queueSB.getId()%>,<%=categorySB.getId()%>,<%=subCategorySB.getId()%>, 'assets/img/login-bg/login-bg-10.jpg')"><%=subCategorySB.getSubCategoryName()%><span class="badge bg-yellow text-dark">  <%=getTicketsBySubCategory.size()%>  </span></div> </div>
                                <%}%>
                                </a>
                            </div>
                            <%}
                               }%>
                        </div>
                    </div>
                    <%}
                        }%>
                    <!--                    <div class="menu-item has-sub">
                                            <a href="javascript:;" class="menu-link">
                                                <div class="menu-text">Hardware <span class="badge bg-default"> 0 </span></div>
                                                <div class="menu-caret"></div>
                                            </a>
                                            <div class="menu-submenu">
                                                <div class="menu-item has-sub"><a href="javascript:;" class="menu-link"><div class="menu-text">Computers <span class="badge bg-yellow text-dark"> 0 </span></div></a></div>
                                                <div class="menu-item"><a href="javascript:;" class="menu-link"><div class="menu-text">Accessories <span class="badge bg-yellow text-dark"> 0 </span></div></a></div>
                                                <div class="menu-item"><a href="javascript:;" class="menu-link"><div class="menu-text">CCTV <span class="badge bg-yellow text-dark"> 0 </span></div></a></div>
                                            </div>
                                        </div>-->
                </div>
            </div>
            <%}
                }%>
            <!--            <div class="menu-item has-sub">
                            <a href="javascript:;" class="menu-link">
                                <div class="menu-icon">
                                    <i class="fa fa-th-large"></i>
                                </div>
                                <div class="menu-text">Finance <span class="badge bg-light text-dark"> 3 </span></div>
                                <div class="menu-caret"></div>
                            </a>
                            <div class="menu-submenu">
                                <div class="menu-item has-sub">
                                    <a href="javascript:;" class="menu-link">
                                        <div class="menu-text">Expense Reports <span class="badge bg-default"> 1 </span></div>
                                        <div class="menu-caret"></div>
                                    </a>
                                    <div class="menu-submenu">
                                        <div class="menu-item"><a href="javascript:;" class="menu-link"><div class="menu-text">Branch Issues <span class="badge bg-yellow text-dark"> 2 </span></div></a></div>
                                        <div class="menu-item"><a href="javascript:;" class="menu-link"><div class="menu-text">Cluster Issues <span class="badge bg-yellow text-dark"> 0 </span></div></a></div>
                                        <div class="menu-item"><a href="javascript:;" class="menu-link"><div class="menu-text">Personal <span class="badge bg-yellow text-dark"> 0 </span></div></a></div>
                                    </div>
                                </div>
                                <div class="menu-item has-sub">
                                    <a href="javascript:;" class="menu-link">
                                        <div class="menu-text">Maintenance <span class="badge bg-default"> 0 </span></div>
                                        <div class="menu-caret"></div>
                                    </a>
                                    <div class="menu-submenu">
                                        <div class="menu-item has-sub"><a href="javascript:;" class="menu-link"><div class="menu-text">Branch <span class="badge bg-yellow text-dark"> 0 </span></div></a></div>
                                        <div class="menu-item"><a href="javascript:;" class="menu-link"><div class="menu-text">Cluster <span class="badge bg-yellow text-dark"> 0 </span></div></a></div>
                                        <div class="menu-item"><a href="javascript:;" class="menu-link"><div class="menu-text">Person <span class="badge bg-yellow text-dark"> 0 </span></div></a></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="menu-item">
                            <a href="index.html" class="menu-link">
                                <div class="menu-icon">
                                    <i class="fa fa-th-large"></i>
                                </div>
                                <div class="menu-text">Administration <span class="badge bg-light text-dark"> 0 </span></div>
                            </a>
                        </div>
                        <div class="menu-item">
                            <a href="index.html" class="menu-link">
                                <div class="menu-icon">
                                    <i class="fa fa-th-large"></i>
                                </div>
                                <div class="menu-text">Marketing <span class="badge bg-light text-dark"> 0 </span></div>
                            </a>
                        </div>
                        <div class="menu-item">
                            <a href="index.html" class="menu-link">
                                <div class="menu-icon">
                                    <i class="fa fa-th-large"></i>
                                </div>
                                <div class="menu-text">Digital Marketing <span class="badge bg-light text-dark"> 0 </span></div>
                            </a>
                        </div>
                        <div class="menu-item">
                            <a href="index.html" class="menu-link">
                                <div class="menu-icon">
                                    <i class="fa fa-th-large"></i>
                                </div>
                                <div class="menu-text">HR <span class="badge bg-light text-dark"> 0 </span></div>
                            </a>
                        </div>
                        <div class="menu-item">
                            <a href="index.html" class="menu-link">
                                <div class="menu-icon">
                                    <i class="fa fa-th-large"></i>
                                </div>
                                <div class="menu-text">Petty Cash <span class="badge bg-light text-dark "> 0 </span></div>
                            </a>
                        </div>
                        <div class="menu-item">
                            <a href="index.html" class="menu-link">
                                <div class="menu-icon">
                                    <i class="fa fa-th-large"></i>
                                </div>
                                <div class="menu-text">Repair <span class="badge bg-light text-dark"> 0 </span></div>
                            </a>
                        </div>
                        <div class="menu-item">
                            <a href="index.html" class="menu-link">
                                <div class="menu-icon">
                                    <i class="fa fa-th-large"></i>
                                </div>
                                <div class="menu-text">MIS <span class="badge bg-light text-dark"> 0 </span></div>
                            </a>
                        </div>
                        <div class="menu-item">
                            <a href="index.html" class="menu-link">
                                <div class="menu-icon">
                                    <i class="fa fa-th-large"></i>
                                </div>
                                <div class="menu-text">Feedback <span class="badge bg-light text-dark"> 0 </span></div>
                            </a>
                        </div>-->


            <%
//                                        get all active interface topicks
                List<PmInterfaceTopic> loadAllInterfaceTopics = new com.it.privilegeManagementModel.PMS_PM_Interface_Topic().getAllActiveInterfaceTopics(ses, STATIC_DATA_MODEL.PMACTIVE);

//                                          get all active interfaces
                List<PmInterface> loadAllInterface = new com.it.privilegeManagementModel.PMS_PM_Interface().getAllActiveInterfaces(ses, STATIC_DATA_MODEL.PMACTIVE);

//                                         get all user has interfce components
                List<UmUserHasInterfaceComponent> loadUserHasInterfaceComponent = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserId(ses, logedUser.getId());
//                System.out.println("size = " + loadUserHasInterfaceComponent.size());
                String encryptPid = "";

                for (PmInterfaceTopic allGroups : loadAllInterfaceTopics) {
//                    System.out.println(allGroups.getTopicName() + " " + allGroups.getId());
                    boolean box3 = false;
                    for (UmUserHasInterfaceComponent userHasCompo3 : loadUserHasInterfaceComponent) {
//                        System.out.println("comp = " + userHasCompo3.getPmInterfaceComponent().getComponentName() + " " + userHasCompo3.getPmInterfaceComponent().getComponentId() + " topic Id = "+ userHasCompo3.getPmInterfaceComponent().getPmInterface().getPmInterfaceTopic().getId() );
                        if (allGroups.getId() == userHasCompo3.getPmInterfaceComponent().getPmInterface().getPmInterfaceTopic().getId()) {
                            box3 = true;
//                            System.out.println("true");
                        }
                    }

                    if (box3) {
//                        System.out.println("topic ");
%>

            <div class="menu-item has-sub active mt-5">
                <a class="menu-link">
                    <div class="menu-icon">
                        <i class="<%=allGroups.getMenuIcon()%>"></i>
                    </div>
                    <div class="menu-text"><%=allGroups.getTopicName()%></div>
                    <div class="menu-caret"></div>
                </a>
                <div class="menu-submenu">
                    <%

                        for (PmInterface allInterface : loadAllInterface) {

                            boolean box2 = false;
                            if(allInterface.getId() != 7){
                            for (UmUserHasInterfaceComponent userHasComponent : loadUserHasInterfaceComponent) {
                                if (allInterface.getId() == userHasComponent.getPmInterfaceComponent().getPmInterface().getId() && allGroups.getId() == userHasComponent.getPmInterfaceComponent().getPmInterface().getPmInterfaceTopic().getId()) {
                                    box2 = true;
                                }

                            }

                            if (box2) {
    //                                System.out.println("interface = " +allInterface.getId() );
    //                                System.out.println("interface name = " +allInterface.getInterfaceName());
    //                                encryptPid = ENCRYPT_MODEL.urlEncrypt(STATIC_DATA_MODEL.EKEY, STATIC_DATA_MODEL.KEYVECTOR, allInterface.getId() + "");
    //                                System.out.println("enc = " + encryptPid);
%>  

                    <div class="menu-item" style="cursor: pointer;">
                        <a onclick="loadPage('<%=allInterface.getPath()%>',<%=allInterface.getId()%>)" class="menu-link">
                            <div class="menu-text"><%=allInterface.getInterfaceName()%> </div>

                        </a>

                    </div>



                    <%}
                    }}%>
                </div>
            </div>

            <%}
                }%>



            <!-- BEGIN minify-button -->
            <div class="menu-item d-flex">
                <a href="javascript:;" class="app-sidebar-minify-btn ms-auto" data-toggle="app-sidebar-minify"><i class="fa fa-angle-double-left"></i></a>
            </div>
            <!-- END minify-button -->

        </div>
        <!-- END menu -->
    </div>
    <!-- END scrollbar -->
</div>
<div class="app-sidebar-bg"></div>
<div class="app-sidebar-mobile-backdrop"><a href="#" data-dismiss="app-sidebar-mobile" class="stretched-link"></a></div>

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