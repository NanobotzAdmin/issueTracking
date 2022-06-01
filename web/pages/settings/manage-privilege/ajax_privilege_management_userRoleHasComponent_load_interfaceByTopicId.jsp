<%-- 
    Document   : ajax_privilege_management_userRoleHasComponent_load_interfaceByTopicId
    Created on : Nov 26, 2021, 12:39:57 AM
    Author     : JOY
--%>

<%@page import="org.hibernate.Transaction"%>
<%@page import="com.it.db.PmInterfaceComponent"%>
<%@page import="com.it.db.PmUserRoleHasInterfaceComponent"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.PmInterface"%>
<%@page import="com.it.db.UmUserHasInterfaceComponent"%>
<%@page import="com.it.db.PmUserRole"%>
<%@page import="com.it.db.PmInterfaceTopic"%>
<%@page import="java.util.List"%>
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
        //Get active user object
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {

            PmInterfaceTopic selectedInterfaceTopic = (PmInterfaceTopic) ses.load(PmInterfaceTopic.class, Integer.parseInt(request.getParameter("interfaceTopicId")));

            PmUserRole selectedUserRole001 = (PmUserRole) ses.load(PmUserRole.class, Integer.parseInt(request.getParameter("userRoleId")));

            List<UmUserHasInterfaceComponent> getInterfaceTopicHasComponent = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserRoleAndTopicId(ses, selectedUserRole001.getId(), selectedInterfaceTopic.getId());

            if (!getInterfaceTopicHasComponent.isEmpty()) {

%>
<label class="col-sm-9">Remove All Interfaces</label>
<div id="ALLINTERFACEUROLEDIV" class="col-sm-3">
    <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" checked="checked" id="cb96" onclick="addAllInterfaces('<%=selectedUserRole001.getId()%>', '<%=selectedInterfaceTopic.getId()%>', 'S')">
        <label class="form-check-label" for="cb96"></label>
    </div>
</div>
<%} else {%>
<label class="col-sm-9">Add All Interfaces</label> 
<div id="ALLINTERFACEUROLEDIV" class="col-sm-3">
    <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" id="cb96" onclick="addAllInterfaces('<%=selectedUserRole001.getId()%>', '<%=selectedInterfaceTopic.getId()%>', 'N')">
        <label class="form-check-label" for="cb96"></label>
    </div>
</div>
<%}%>
<br>
<br>
<%
//        get interface by toipic
    List<PmInterface> getInterfacesByTopicId = new com.it.privilegeManagementModel.PMS_PM_Interface().getAllInterfacesByTopic(ses, STATIC_DATA_MODEL.PMACTIVE, selectedInterfaceTopic.getId());
    if (!getInterfacesByTopicId.isEmpty()) {
        for (PmInterface allInterfaces : getInterfacesByTopicId) {
%>

<div class="col-sm-9"style="border-bottom: #cccccc; border-bottom-style: ridge">
    <%
        int selectedUserRoleHasUsersSize = 0;
        int interfaceHasComponentSize = 0;
        int howmanyUsersAssigComponentSize = 0;
        List<UmUser> loadSelectedUserRoleUsers = new com.it.userManagementModel.UMS_UM_User().searchUsersByStatusAndUserRole(ses, selectedUserRole001.getId(), STATIC_DATA_MODEL.ACTIVE);
        selectedUserRoleHasUsersSize = loadSelectedUserRoleUsers.size();
        List<PmInterfaceComponent> loadComponentBYinterfaceid = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, allInterfaces.getId());
        interfaceHasComponentSize = loadComponentBYinterfaceid.size();
        if (!loadComponentBYinterfaceid.isEmpty()) {
            for (PmInterfaceComponent elem : loadComponentBYinterfaceid) {
                List<UmUserHasInterfaceComponent> checkUserHasComponent = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserRoleAndComponentId(ses, selectedUserRole001.getId(), elem.getId());
                howmanyUsersAssigComponentSize += checkUserHasComponent.size();
            }
        }
//                        System.out.println("selectedUserRoleHasUsersSize = " + selectedUserRoleHasUsersSize);
//                        System.out.println("interfaceHasComponentSize = " + interfaceHasComponentSize);
//                        System.out.println("howmanyUsersAssigComponentSize = " + howmanyUsersAssigComponentSize);
        int calMethod = selectedUserRoleHasUsersSize * interfaceHasComponentSize;
        List<UmUserHasInterfaceComponent> getInterfaceTopicHasComponent2 = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserRoleAndInterfaceId(ses, selectedUserRole001.getId(), allInterfaces.getId());
        if (!getInterfaceTopicHasComponent2.isEmpty()) {
//                    int hh = getInterfaceTopicHasComponent2.size();
//                    List<UmUser> loadUsersByUserRole = new com.hrm.userManagementModel.UMS_UM_User().searchUsersByStatusAndUserRole(ses, selectedUserRole001.getId(), STATIC_DATA_MODEL.PMACTIVE);
//                    int kk = loadUsersByUserRole.size();
//        System.out.println("hh = " + hh);
//        System.out.println("kk = " + kk);
            if (calMethod == howmanyUsersAssigComponentSize) {
    %>
    <label class=" control-label"style="margin-top: 10px;"><%=allInterfaces.getInterfaceName()%></label>
    <%} else {%>
    <label class=" control-label text-danger"style="margin-top: 10px; "><%=allInterfaces.getInterfaceName()%></label>
    <%}%>

    <%} else {%>
    <%//check u role has component by interface
        List<PmUserRoleHasInterfaceComponent> checkUserRoleHasCompo = new com.it.privilegeManagementModel.PMS_PM_User_Role_Has_Interface_Component().getAllUserRoleHasInterfaceComponentByUserRoleAndInterfaceId(ses, selectedUserRole001.getId(), allInterfaces.getId());
        if (!checkUserRoleHasCompo.isEmpty()) {
    %>
    <label class=" control-label text-warning"style="margin-top: 10px;"><%=allInterfaces.getInterfaceName()%></label>
    <div id="UROLHASINTERFACEDELETEDIV">
        <button type="button" class="btn btn-w-m btn-warning" onclick="deleteURoleHasInterface('<%=allInterfaces.getId()%>', '<%=selectedUserRole001.getId()%>')">Delete User Role Has Interface</button>
    </div>
    <%} else {%>
    <label class=" control-label" style="margin-top: 10px;"><%=allInterfaces.getInterfaceName()%></label>
    <%}
        }%>
</div>
<div class="col-sm-3">
    <button type="button" class="btn  btn-info btn-sm"  id="intbtn<%=allInterfaces.getId()%>" onclick="viewAllComponent(<%=allInterfaces.getId()%>,<%=selectedInterfaceTopic.getId()%>, this)">View</button>
</div>
<%}%>
<script type="text/javascript">
    function addAllInterfaces(userRole, interfaceTopic, status) {
        $.ajax({
            url: "privilageManagement_addOrDeleteUserRoleHasAllComponentOneClick",
            type: "POST",
            data: "userRoleId=" + userRole + "&interfaceTopic=" + interfaceTopic + "&status=" + status,
            beforeSend: function (xhr) {
                $('#ALLINTERFACEUROLEDIV').empty();
                $('#ALLINTERFACEUROLEDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
//                    setTimeout(function () {
                    loadInterfaceByInterfaceTopic(<%=selectedInterfaceTopic.getId()%>,'H');
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
                $('#ALLINTERFACEUROLEDIV').empty();
                if (status === "N") {
                    $('#ALLINTERFACEUROLEDIV').html("<div class='form-check form-switch'><input class='form-check-input' type='checkbox' id='cb96' onclick='addAllInterfaces('<%=selectedUserRole001.getId()%>', '<%=selectedInterfaceTopic.getId()%>', 'N')'><label class='form-check-label' for='cb96'></label></div>");
                } else {
                     $('#ALLINTERFACEUROLEDIV').html("<div class='form-check form-switch'><input class='form-check-input' type='checkbox' id='cb96' onclick='addAllInterfaces('<%=selectedUserRole001.getId()%>', '<%=selectedInterfaceTopic.getId()%>', 'S')'><label class='form-check-label' for='cb96'></label></div>");               
                }
            },
            error: function (error) {
            }
        });
    }
//function for delete user role assigned interface components
    function deleteURoleHasInterface(interfaceId, userRoleId) {
        $.ajax({
            url: "privilageManagement_DeleteUserRoleHasInterface",
            type: "POST",
            data: "userRoleId=" + userRoleId + "&interfaceId=" + interfaceId,
            beforeSend: function (xhr) {
                $('#UROLHASINTERFACEDELETEDIV').empty();
                $('#UROLHASINTERFACEDELETEDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
            },
            success: function (data) {
                var resultValue = JSON.parse(data);
                if (resultValue.result === "0") {
                    Swal.fire(resultValue.displayMessage, '', 'error')
                } else if (resultValue.result === "2") {
                    Swal.fire(resultValue.displayMessage, '', 'error')
                    setTimeout(function () {
                        window.location.href = "";
                    }, 2000);
                } else if (resultValue.result === "1") {
                    loadInterfaceByInterfaceTopic(<%=selectedInterfaceTopic.getId()%>);
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
                $('#UROLHASINTERFACEDELETEDIV').empty();
                $('#UROLHASINTERFACEDELETEDIV').html("<button type='button' class='btn btn-w-m btn-warning' onclick='deleteURoleHasInterface('" + interfaceId + "', '<%=selectedUserRole001.getId()%>')'>Delete User Role Has Interface</button>");
            },
            error: function (error) {
            }
        });
    }
</script>




<%
    }%>
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
