<%-- 
    Document   : privilage_management
    Created on : Nov 23, 2021, 7:21:20 PM
    Author     : buddh
--%>

<%@page import="com.ring.db.PmInterfaceTopic"%>
<%@page import="com.ring.db.PmUserRole"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.UmUserHasInterfaceComponent"%>
<%@page import="com.ring.db.PmInterfaceComponent"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") != null) {
        Session ses = com.ring.connection.Connection.getSessionFactory().openSession();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        String gg = (request.getParameter("pageUrl"));
        int pid = Integer.parseInt(request.getParameter("interface"));
        String content_prefix = "../../";
        try {
%>
<!-- BEGIN page-header -->
<h1 class="page-header">User Permissions</h1>
<!-- END page-header -->
<br>
<%
    List<PmInterfaceComponent> getComponentByIterfaceId = new com.ring.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, pid);
    boolean privilegeManagementMain = false;
    boolean privilegeManagementUserRole = false;
    boolean privilegeManagementUser = false;

    if (!getComponentByIterfaceId.isEmpty()) {
        for (PmInterfaceComponent cmpt : getComponentByIterfaceId) {
            UmUserHasInterfaceComponent getUserHasComponentByUserAndComponentId = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, logedUser.getId(), cmpt.getId());
            if (getUserHasComponentByUserAndComponentId != null) {
                if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("USERPERMISSIONMAINCOMPONENT")) {
                    privilegeManagementMain = true;
                }
                if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("PRIVILEGEMANAGEMENTUSERROLE")) {
                    privilegeManagementUserRole = true;
                }
                if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("PRIVILEGEMANAGEMENTUSER")) {
                    privilegeManagementUser = true;
                }
            }
        }
    }
%>

<%
    if (privilegeManagementMain) {
%>       
<div class="panel panel-inverse">
    <div class="panel-body">
        <div class="card">
            <div class="card-body">
                <ul class="nav nav-tabs">
                    <li class="nav-item">
                        <a href="#default-tab-1" onclick="cleareDivData()" data-bs-toggle="tab" class="nav-link active">
                            <span class="d-sm-none">Tab 1</span>
                            <span class="d-sm-block d-none">User Role Has Permission</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#default-tab-2" onclick="cleareDivData()" data-bs-toggle="tab" class="nav-link">
                            <span class="d-sm-none">Tab 2</span>
                            <span class="d-sm-block d-none">User Has Permission</span>
                        </a>
                    </li>

                </ul>

                <div class="tab-content bg-white-transparent-2 p-3">
                    <!-- BEGIN tab-pane 1 -->
                    <div class="tab-pane fade active show" id="default-tab-1">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="mb-3">
                                    <label class="form-label">Select User-Role</label>
                                    <select class="default-select2 form-control" style="color: #000" id="userRole" name="userRole" onchange="changeTopics()">
                                        <option selected="" disabled=""  value="0">-- Select User Role --</option>  
                                        <% // $$                                                              
                                            List<PmUserRole> loadAllUserRole = new com.ring.privilegeManagementModel.PMS_PM_User_Role().getAllActiveUserRoles(ses, STATIC_DATA_MODEL.PMACTIVE);
                                            if (!loadAllUserRole.isEmpty()) {
                                                for (PmUserRole allUserRoles : loadAllUserRole) {
                                        %>
                                        <option value="<%=allUserRoles.getId()%>"><%=allUserRoles.getUserRoleName()%></option>
                                        <%}
                                            }%>
                                    </select>
                                </div>

                            </div>
                            <div class="col-sm-6">
                                <div class="mb-3">
                                    <label class="form-label">Select Interface Topic</label>
                                    <select class="default-select2 form-control" style="color: #000" id="interfaceTopic" name="interfaceTopic" onchange="loadInterfaceByInterfaceTopic(this.value, 'H')">
                                        <option selected="" disabled="" value="0">-- Select Interface Topic --</option>  
                                        <% //$$
                                            List<PmInterfaceTopic> loadAllinterfaceTopics = new com.ring.privilegeManagementModel.PMS_PM_Interface_Topic().getAllActiveInterfaceTopics(ses, STATIC_DATA_MODEL.PMACTIVE);
                                            if (!loadAllinterfaceTopics.isEmpty()) {
                                                for (PmInterfaceTopic allInterfaceTopics : loadAllinterfaceTopics) {
                                        %>
                                        <option  value="<%=allInterfaceTopics.getId()%>"><%=allInterfaceTopics.getTopicName()%></option>
                                        <%}
                                            }%>
                                    </select>
                                </div>

                            </div>
                        </div>
                        <br>
                        <div class="row" id="loadInterfacesDiv">

                            <!--                            <h5>Interface</h5><hr>
                            
                                                        <div class="row">
                                                            <label class="form-label col-form-label col-md-8" style="font-size: 15px">Add All Interface</label>
                                                                                            <div class="col-sm-2">
                                                                                                <div class="form-check form-switch mb-2">
                                                                                                    <input type="checkbox" class="'switchery-default1" checked /> &nbsp; &nbsp;
                                                                                                </div>
                                                                                            </div>
                                                            <div class="form-check form-switch">
                                                                <input class="form-check-input" type="checkbox" id="flexSwitchCheckChecked" checked="">
                                                                <label class="form-check-label" for="flexSwitchCheckChecked">Checked switch checkbox input</label>
                                                            </div>
                                                        </div>
                            
                                                        <div class="row">
                                                            <label class="form-label col-form-label col-md-9" style="font-size: 14px">User Management Home</label>
                            
                                                            <div class="col-sm-2">
                                                                <button type="button" class="btn btn-outline-info btn-sm">View</button>
                                                            </div>
                                                        </div>-->
                        </div>
                    </div>
                    <!-- END tab-pane -->

                    <!-- BEGIN tab-pane 2 -->
                    <div class="tab-pane fade" id="default-tab-2">
                        <div class="row">
                            <div class="col-sm-4">
                                <div class="mb-3">
                                    <label class="form-label">Select User-Role</label>
                                    <select class="default-select2 form-control" style="color: #000" id="userRoleForUser" name="userRoleForUser" onchange="loadUsersbyRoleIdForUsers()">
                                        <option selected="" disabled="" value="0">-- Select User Role --</option>  
                                        <% // $$                                                              
                                            List<PmUserRole> loadAllUserRoleForUser = new com.ring.privilegeManagementModel.PMS_PM_User_Role().getAllActiveUserRoles(ses, STATIC_DATA_MODEL.PMACTIVE);
                                            if (!loadAllUserRoleForUser.isEmpty()) {
                                                for (PmUserRole allUserRolesUser : loadAllUserRoleForUser) {
                                        %>
                                        <option value="<%=allUserRolesUser.getId()%>"><%=allUserRolesUser.getUserRoleName()%></option>
                                        <%}
                                            }%>
                                    </select>
                                </div>

                            </div>
                            <div class="col-sm-4">
                                <div class="mb-3"  id="loadUsersToPrivilegeDiv" >
                                    <label class="form-label">Select User</label>
                                    <select class="default-select2 form-control" id="loadUsersForPrivilage" name="loadUsersForPrivilage" style="width: 100%;color: #000" onchange="changeTopics2()">
                                        <option value="0">-- Select User --</option>
                                    </select>
                                </div>

                            </div>
                            <div class="col-sm-4">
                                <div class="mb-3">
                                    <label class="form-label">Select Interface Topic</label>
                                    <select class="default-select2 form-control" style="color: #000" id="interfaceTopicForUser" name="interfaceTopicForUser" onchange="loadInterfaceByInterfaceTopicForUser(this.value,'H')">
                                        <option selected="" value="0">-- Select Interface Topic --</option>  
                                        <% //$$
                                            List<PmInterfaceTopic> loadAllinterfaceTopicsForUser = new com.ring.privilegeManagementModel.PMS_PM_Interface_Topic().getAllActiveInterfaceTopics(ses, STATIC_DATA_MODEL.PMACTIVE);
                                            if (!loadAllinterfaceTopicsForUser.isEmpty()) {
                                                for (PmInterfaceTopic allInterfaceTopicsUser : loadAllinterfaceTopicsForUser) {
                                        %>
                                        <option  value="<%=allInterfaceTopicsUser.getId()%>"><%=allInterfaceTopicsUser.getTopicName()%></option>
                                        <%}
                                                            }%>
                                    </select>
                                </div>

                            </div>
                        </div>

                        <br>
                        <div class="row" id="loadInterfacesForUserDiv">
                            <!--                            <h5>Interface</h5><hr>
                            
                                                        <div class="row mb-15px">
                                                            <label class="form-label col-form-label col-md-9" style="font-size: 14px">User Management Home</label>
                                                            <div class="col-sm-2">
                                                                <button type="button" class="btn btn-outline-info btn-sm">View</button>
                                                            </div>
                                                        </div>-->
                        </div>


                    </div>
                    <!-- END tab-pane -->
                </div>

            </div>
        </div>
    </div>
</div>
<script type="text/javascript">

    function cleareDivData() {
        document.getElementById('loadInterfacesDiv').innerHTML = "";
        document.getElementById('loadInterfacesForUserDiv').innerHTML = "";
        document.getElementById('right_content_div').innerHTML = "";
        $('#userRole').prop('selectedIndex', 0);
        $('#interfaceTopic').prop('selectedIndex', 0);
        $('#userRoleForUser').prop('selectedIndex', 0);
        $('#loadUsersForPrivilage').prop('selectedIndex', 0);
        $('#interfaceTopicForUser').prop('selectedIndex', 0);
    }
    function changeTopics() {
        document.getElementById('loadInterfacesDiv').innerHTML = "";
        document.getElementById('right_content_div').innerHTML = "";
        $('#interfaceTopic').prop('selectedIndex', 0);
    }
    //function for load interfaces by topic to user role has privilage part
    function loadInterfaceByInterfaceTopic(interfaceTopicId, val) {
//        alert(val);
        var userRoleId = $('#userRole option:selected').val();
        if (userRoleId === "0") {
//            alert("Select User Role");
            swal("", "Select User Role", "warning");
        } else {
            $.ajax({
                url: "pages/settings/manage-privilege/ajax_privilege_management_userRoleHasComponent_load_interfaceByTopicId.jsp",
                type: "POST",
                data: "interfaceTopicId=" + interfaceTopicId + "&userRoleId=" + userRoleId,
                beforeSend: function (xhr) {
                },
                complete: function () {
                },
                success: function (data) {
                    if (val === "H") {
                        document.getElementById('right_content_div').innerHTML = "";
                    }
                    $('#loadInterfacesDiv').html(data);
                }
            });
        }
    }
    //    function for load component bny interface id
    function viewAllComponent(interfaceId, topicId) {
        var userRoleId = $('#userRole option:selected').val();
        $(".btn-danger").each(function () {
            $(this).removeClass();
            $(this).addClass("btn btn-info btn-sm");
        });
        $('#intbtn' + interfaceId).addClass('btn-danger');
        $.ajax({
            url: "pages/settings/manage-privilege/ajax_privilage_management_userRoleHasComponent_load_componentByInterface.jsp",
            type: "POST",
            data: "interfaceId=" + interfaceId + "&userRoleId=" + userRoleId + "&topicId=" + topicId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
       //function for load Users by user role to user has privilage part
        function loadUsersbyRoleIdForUsers() {
            var userRoleForUser = $('#userRoleForUser option:selected').val();
            if (userRoleForUser === "0") {
                swal("", "Select User Role", "warning");
            } else {
                $.ajax({
                    url: "pages/settings/manage-privilege/ajax_privilege_management_userHasComponent_load_usersByUserRoleId.jsp",
                    type: "POST",
                    data: "userRoleId=" + userRoleForUser,
                    beforeSend: function (xhr) {
                    },
                    complete: function () {
                    },
                    success: function (data) {
//                        document.getElementById('loadComponentDiv').innerHTML = "";
                        $('#loadUsersToPrivilegeDiv').html(data);
                    }
                });
            }
        }
        function changeTopics2() {
        document.getElementById('loadInterfacesForUserDiv').innerHTML = "";
        document.getElementById('right_content_div').innerHTML = "";
        $('#interfaceTopicForUser').prop('selectedIndex', 0);
    }
       //function for load Interfaces By Interface Topic Id For User Privilege 
        function loadInterfaceByInterfaceTopicForUser(topicId,val) {
            var userRoleForUser = $('#userRoleForUser option:selected').val();
            var loadUsersForPrivilage = $('#loadUsersForPrivilage option:selected').val();
            if (loadUsersForPrivilage === "0") {
                swal("", "Select User", "warning");
            } else {
                $.ajax({
                    url: "pages/settings/manage-privilege/ajax_privilege_management_userHasComponent_load_interfaceByTopicId.jsp",
                    type: "POST",
                    data: "userRoleId=" + userRoleForUser + "&loadUsersForPrivilage=" + loadUsersForPrivilage + "&topicId=" + topicId,
                    beforeSend: function (xhr) {
                    },
                    complete: function () {
                    },
                    success: function (data) {
                         if (val === "H") {
                        document.getElementById('right_content_div').innerHTML = "";
                    }
                        $('#loadInterfacesForUserDiv').html(data);
                    }
                });
            }
        }
        //    function for load component by interface id For User
        function viewAllComponentUser(interfaceId, topicId) {
            var loadUsersForPrivilage = $('#loadUsersForPrivilage option:selected').val();
            $(".btn-danger").each(function () {
                $(this).removeClass();
                $(this).addClass("btn btn-info btn-sm");
            });
            $('#intbtnUser' + interfaceId).addClass('btn-danger');
            $.ajax({
                url: "pages/settings/manage-privilege/ajax_privilage_management_userHasComponent_load_componentByInterfaceId.jsp",
                type: "POST",
                data: "interfaceId=" + interfaceId + "&loadUsersForPrivilage=" + loadUsersForPrivilage + "&topicId=" + topicId,
                beforeSend: function (xhr) {
                },
                complete: function () {
                },
                success: function (data) {
                    $('#right_content_div').html(data);
                }
            });
        }
</script>






<%} else {
        response.sendRedirect("home.jsp");
    }%>


<%        } catch (Exception e) {
        logger.error(logedUser.getId() + " - " + logedUser.getFirstName() + " : " + e.toString());
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



