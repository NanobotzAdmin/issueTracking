<%-- 
    Document   : ajax_privilege_management_userHasComponent_load_interfaceByTopicId
    Created on : Nov 26, 2021, 6:46:12 AM
    Author     : JOY
--%>

<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.db.PmInterfaceComponent"%>
<%@page import="com.ring.db.PmUserRoleHasInterfaceComponent"%>
<%@page import="com.ring.db.UmUser"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.PmInterface"%>
<%@page import="com.ring.db.UmUserHasInterfaceComponent"%>
<%@page import="com.ring.db.PmUserRole"%>
<%@page import="com.ring.db.PmInterfaceTopic"%>
<%@page import="java.util.List"%>
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
        //Get active user object
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {

            PmInterfaceTopic selectedInterfaceTopicUser = (PmInterfaceTopic) ses.load(PmInterfaceTopic.class, Integer.parseInt(request.getParameter("topicId")));

            PmUserRole selectedUserRoleForUser = (PmUserRole) ses.load(PmUserRole.class, Integer.parseInt(request.getParameter("userRoleId")));
            
            UmUser selectedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getParameter("loadUsersForPrivilage")));
//            check user has interface component by interface topic
            List<UmUserHasInterfaceComponent> getUserInterfaceTopicHasComponent = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdTopicId(ses, selectedUser.getId(), selectedInterfaceTopicUser.getId());

            if (!getUserInterfaceTopicHasComponent.isEmpty()) {

%>

<label class="col-sm-9">Remove All Interfaces</label>
<div id="ALLINTERFACEUSERDIV" class="col-sm-3">
    <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" checked="checked" id="cbu96" onclick="addAllInterfacesToUser('<%=selectedUser.getId()%>', '<%=selectedInterfaceTopicUser.getId()%>', 'S')">
        <label class="form-check-label" for="cbu96"></label>
    </div>
</div>
<%} else {%>
<label class="col-sm-9">Add All Interfaces</label> 
<div id="ALLINTERFACEUSERDIV" class="col-sm-3">
    <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" id="cbu96" onclick="addAllInterfacesToUser('<%=selectedUser.getId()%>', '<%=selectedInterfaceTopicUser.getId()%>', 'N')">
        <label class="form-check-label" for="cbu96"></label>
    </div>
</div>
        
        
<%}%>
<br>
        <br>
<%
//        get interface by toipic
    List<PmInterface> getInterfacesByTopicId = new com.ring.privilegeManagementModel.PMS_PM_Interface().getAllInterfacesByTopic(ses, STATIC_DATA_MODEL.PMACTIVE, selectedInterfaceTopicUser.getId());
    if (!getInterfacesByTopicId.isEmpty()) {
        for (PmInterface allInterfacesUs : getInterfacesByTopicId) {
%>

<div class="col-sm-9"style="border-bottom: #ccc; border-bottom-style: ridge">
    <%
//        check user has interface component by interface
        List<UmUserHasInterfaceComponent> getUserInterfaceHasComponent = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserAndInterfaceId(ses, selectedUser.getId(), allInterfacesUs.getId());
        if (!getUserInterfaceHasComponent.isEmpty()) {
    %>
    <label class=" control-label"style="margin-top: 10px; color: #fff"><%=allInterfacesUs.getInterfaceName()%></label>
    <%} else {%>
    <label class=" control-label"style="margin-top: 10px;"><%=allInterfacesUs.getInterfaceName()%></label>
    <%}%>
</div>
<div class="col-sm-3">
    <button type="button" class="btn  btn-info btn-sm"  id="intbtnUser<%=allInterfacesUs.getId()%>" onclick="viewAllComponentUser(<%=allInterfacesUs.getId()%>,<%=selectedInterfaceTopicUser.getId()%>, this)">View</button>
</div>
<%}}%>
<script type="text/javascript">
    function addAllInterfacesToUser(user, interfaceTopic, status) {
        $.ajax({
            url: "privilageManagement_addOrDeleteUserHasAllComponentOneClick",
            type: "POST",
            data: "user=" + user + "&interfaceTopic=" + interfaceTopic + "&status=" + status,
            beforeSend: function (xhr) {
                $('#ALLINTERFACEUSERDIV').empty();
                $('#ALLINTERFACEUSERDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    loadInterfaceByInterfaceTopicForUser(<%=selectedInterfaceTopicUser.getId()%>,'H');
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
                $('#ALLINTERFACEUSERDIV').empty();
                if (status === "N") {
                    $('#ALLINTERFACEUSERDIV').html("<div class='form-check form-switch'><input class='form-check-input' type='checkbox' id='cbu96' onclick='addAllInterfacesToUser('<%=selectedUser.getId()%>', '<%=selectedInterfaceTopicUser.getId()%>', 'N')'><label class='form-check-label' for='cbu96'></label></div>");
                } else {
                    $('#ALLINTERFACEUSERDIV').html("<div class='form-check form-switch'><input class='form-check-input' type='checkbox' checked='checked' id='cbu96' onclick='addAllInterfacesToUser('<%=selectedUser.getId()%>', '<%=selectedInterfaceTopicUser.getId()%>', 'S')'><label class='form-check-label' for='cbu96'></label></div>");
                }
            },
            error: function (error) {
            }
        });
    }


</script>

<%        } catch (Exception e) {
            logger.error(logedUser.getId() + " - " + logedUser.getFirstName()+ " : " + e.toString());
        } finally {
            logedUser = null;
            logger = null;
            ses.clear();
            ses.close();
            System.gc();
        }
    }
%>
