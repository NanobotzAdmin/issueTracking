<%-- 
    Document   : ajax_privilage_management_userRoleHasComponent_load_componentByInterface
    Created on : Nov 26, 2021, 12:56:32 AM
    Author     : JOY
--%>

<%@page import="com.it.db.UmUserHasInterfaceComponent"%>
<%@page import="com.it.db.PmInterfaceComponent"%>
<%@page import="java.util.List"%>
<%@page import="com.it.db.PmInterfaceTopic"%>
<%@page import="com.it.db.PmInterface"%>
<%@page import="com.it.db.PmUserRole"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Transaction"%>
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
%>
<!-- BEGIN page-header -->  
<h1 class="page-header">Components</h1>
<br>
<!-- END page-header -->
<!-- BEGIN panel -->
<div class="panel panel-inverse" style="height: 100%">
    <div class="panel-body">
        <div class="row">
            <div class="col">
                <!--BEGIN Chat Reply form-->
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                        <% //                        ^^    
                            int intfId = Integer.parseInt(request.getParameter("interfaceId"));
                            PmUserRole selectedUserRole = (PmUserRole) ses.load(PmUserRole.class, Integer.parseInt(request.getParameter("userRoleId")));
                            PmInterface selectedInterface = (PmInterface) ses.load(PmInterface.class, intfId);
                            PmInterfaceTopic selectedInterfaceTopic = (PmInterfaceTopic) ses.load(PmInterfaceTopic.class, Integer.parseInt(request.getParameter("topicId")));
//            get interface component by interface id
                            List<PmInterfaceComponent> compoByInterface = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, selectedInterface.getId());
                            if (!compoByInterface.isEmpty()) {
                                for (PmInterfaceComponent userRoleHasCompo : compoByInterface) {
//                    get user has interface component by user role and interface component
                                    List<UmUserHasInterfaceComponent> getUserRoleUsersHasInterfaceComponent = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserRoleAndComponentId(ses, selectedUserRole.getId(), userRoleHasCompo.getId());
                                    if (!getUserRoleUsersHasInterfaceComponent.isEmpty()) {

                        %>
                        <label class="col-sm-9 control-label"><%=userRoleHasCompo.getComponentName()%></label>
                        <div id="UROLLADDCOMPONENTDIV<%=userRoleHasCompo.getId()%>" class="col-sm-3">    
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" checked="checked" id="cb3<%=userRoleHasCompo.getId()%>" onclick="addCompornent('<%=selectedUserRole.getId()%>', '<%=userRoleHasCompo.getId()%>', 'S')">
                                <label class="form-check-label" for="cb3<%=userRoleHasCompo.getId()%>"></label>
                            </div>
                            </div>
                            <%} else {%>
                            <label class="col-sm-9 control-label"><%=userRoleHasCompo.getComponentName()%></label>
                            <div id="UROLLADDCOMPONENTDIV<%=userRoleHasCompo.getId()%>" class="col-sm-3">  
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="cb3<%=userRoleHasCompo.getId()%>" onclick="addCompornent('<%=selectedUserRole.getId()%>', '<%=userRoleHasCompo.getId()%>', 'N')">
                                    <label class="form-check-label" for="cb3<%=userRoleHasCompo.getId()%>"></label>
                                </div>
                            </div>
                            <%}
                                    }
                                }%>
                    </div>
                        </div>
                    </div>
                    <!--END Chat Reply form-->
                </div>
            </div>
        </div>
    </div>
    <!-- END panel -->
    <script type="text/javascript">
        //    function for add or remove component to user role users
        function addCompornent(userRole, component, status) {
            $.ajax({
                url: "privilageManagement_addOrDeleteUserRoleHasComponent",
                type: "POST",
                data: "userRoleId=" + userRole + "&component=" + component + "&status=" + status,
                beforeSend: function (xhr) {
                    $('#UROLLADDCOMPONENTDIV' + component).empty();
                    $('#UROLLADDCOMPONENTDIV' + component).html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
                },
                success: function (data) {
                    var resultValue = JSON.parse(data);
                    if (resultValue.result === "0") {
                        swal("", resultValue.displayMessage, "error");
                    } else if (resultValue.result === "2") {
                        swal("", resultValue.displayMessage, "error");
                        setTimeout(function () {
                            window.location.href = "";
                        }, 2000);
                    } else if (resultValue.result === "1") {
                        loadInterfaceByInterfaceTopic(<%=selectedInterfaceTopic.getId()%>, 'B');
                        viewAllComponent(<%=selectedInterface.getId()%>,<%=selectedInterfaceTopic.getId()%>);
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#UROLLADDCOMPONENTDIV' + component).empty();
                    if (status === "N") {
                        $('#UROLLADDCOMPONENTDIV' + component).html("<div class='form-check form-switch'><input class='form-check-input' type='checkbox' id='cb3'" + component + "' onclick='addCompornent('<%=selectedUserRole.getId()%>',  '" + component + "', 'N')'><label class='form-check-label' for='cb3'" + component + "'></label></div>");
                    } else {
                        $('#UROLLADDCOMPONENTDIV' + component).html("<div class='form-check form-switch'><input class='form-check-input' type='checkbox' checked='checked' id='cb3'" + component + "' onclick='addCompornent('<%=selectedUserRole.getId()%>',  '" + component + "', 'S')'><label class='form-check-label' for='cb3'" + component + "'></label></div>");
                    }
                },
                error: function (error) {
                }
            });

        }


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