<%-- 
    Document   : ajax_privilage_management_userHasComponent_load_componentByInterfaceId
    Created on : Nov 26, 2021, 7:00:04 AM
    Author     : JOY
--%>

<%@page import="org.hibernate.Transaction"%>
<%@page import="com.it.db.UmUserHasInterfaceComponent"%>
<%@page import="com.it.db.PmInterfaceComponent"%>
<%@page import="com.it.db.PmInterfaceTopic"%>
<%@page import="com.it.db.PmInterface"%>
<%@page import="com.it.db.PmUserRole"%>
<%@page import="com.it.db.UmUser"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="java.util.List"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
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
                        <%
                            PmInterfaceTopic selectedInterfaceTopicForUser = (PmInterfaceTopic) ses.load(PmInterfaceTopic.class, Integer.parseInt(request.getParameter("topicId")));
                            PmInterface selectedInterfaceForUser = (PmInterface) ses.load(PmInterface.class, Integer.parseInt(request.getParameter("interfaceId")));
                            UmUser selectedUserForUserPrivilege = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getParameter("loadUsersForPrivilage")));
                            //            get interface component by interface id
                            List<PmInterfaceComponent> compoByInterface = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, selectedInterfaceForUser.getId());
                            if (!compoByInterface.isEmpty()) {
                                for (PmInterfaceComponent userHasCompo : compoByInterface) {
                                    //                    get user has interface component by user id and Component Id
                                    UmUserHasInterfaceComponent getUserHasInterfaceComponentByComponentId = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, selectedUserForUserPrivilege.getId(), userHasCompo.getId());
                                    if (getUserHasInterfaceComponentByComponentId != null) {

                        %>
                        <label class="col-sm-9 control-label"><%=userHasCompo.getComponentName()%></label>
                        <div id="USERADDCOMPONENTDIV<%=userHasCompo.getId()%>" class="col-sm-3">    
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" checked="checked" id="cbu3<%=userHasCompo.getId()%>" onclick="addCompornentForUser('<%=selectedUserForUserPrivilege.getId()%>', '<%=userHasCompo.getId()%>', 'S')">
                                <label class="form-check-label" for="cbu3<%=userHasCompo.getId()%>"></label>
                            </div>
                        </div>
                        <%} else {%>
                        <label class="col-sm-9 control-label"><%=userHasCompo.getComponentName()%></label>
                        <div id="USERADDCOMPONENTDIV<%=userHasCompo.getId()%>" class="col-sm-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="cbu3<%=userHasCompo.getId()%>" onclick="addCompornentForUser('<%=selectedUserForUserPrivilege.getId()%>', '<%=userHasCompo.getId()%>', 'N')">
                                <label class="form-check-label" for="cbu3<%=userHasCompo.getId()%>"></label>
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
    function addCompornentForUser(user, component, status) {
        $.ajax({
            url: "privilageManagement_addOrDeleteUserHasComponent",
            type: "POST",
            data: "user=" + user + "&component=" + component + "&status=" + status,
            beforeSend: function (xhr) {
                $('#USERADDCOMPONENTDIV' + component).empty();
                $('#USERADDCOMPONENTDIV' + component).html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    loadInterfaceByInterfaceTopicForUser(<%=selectedInterfaceTopicForUser.getId()%>,'B');
                    viewAllComponentUser(<%=selectedInterfaceForUser.getId()%>, <%=selectedInterfaceTopicForUser.getId()%>)
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
                $('#USERADDCOMPONENTDIV' + component).empty();
                if (status === "N") {
                    $('#USERADDCOMPONENTDIV' + component).html("<div class='form-check form-switch'><input class='form-check-input' type='checkbox' id='cbu3'" + component + "' onclick='addCompornentForUser('<%=selectedUserForUserPrivilege.getId()%>', '" + component + "', 'N')'><label class='form-check-label' for='cbu3'" + component + "'></label></div>");
                } else {
                    $('#USERADDCOMPONENTDIV' + component).html("<div class='form-check form-switch'><input class='form-check-input' type='checkbox' checked='checked' id='cbu3'" + component + "' onclick='addCompornentForUser('<%=selectedUserForUserPrivilege.getId()%>', '" + component + "', 'S')'><label class='form-check-label' for='cbu3'" + component + "'></label></div>");
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
