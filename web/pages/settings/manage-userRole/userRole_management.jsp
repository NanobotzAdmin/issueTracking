<%@page import="com.ring.db.UmUserHasInterfaceComponent"%>
<%@page import="com.ring.db.PmInterfaceComponent"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
s<%-- 
    Document   : userRole_management
    Created on : Dec 1, 2021, 3:50:30 PM
    Author     : buddh
--%>

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
<h1 class="page-header">User Roles</h1><br>
<%
    List<PmInterfaceComponent> getComponentByIterfaceId = new com.ring.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, pid);
    boolean userRoleMain = false;

    if (!getComponentByIterfaceId.isEmpty()) {
        for (PmInterfaceComponent cmpt : getComponentByIterfaceId) {
            UmUserHasInterfaceComponent getUserHasComponentByUserAndComponentId = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, logedUser.getId(), cmpt.getId());
            if (getUserHasComponentByUserAndComponentId != null) {
                if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("USERROLESETTINGSMAINCOMPONENT")) {
                    userRoleMain = true;
                }

            }
        }
    }
%>
<%
    if (userRoleMain) {
%> 
<div class="container-fluid">
    <div class="row">
        <div class="col-sm-12">
            <div class="form-group row">
                <h4 class="col-sm-9">Current User Role List</h4>
                <div class="col-sm-3">
                    <button type="button" class="btn btn-outline-success" style="width: 100%">Create New Role</button>
                </div>
            </div><br>
            <div class="panel panel-inverse">
                <div class="panel-body">
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table id="data-table-default" class="table table-striped table-bordered align-middle">
                                    <thead>
                                        <tr>
                                            <th>User Role</th>
                                            <th>Description</th>
                                            <th>Members</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="odd gradeX">
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <button class="btn btn-outline-warning btn-sm">Manage</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <label class="form-label col-form-label col-md-9"></label>
                <div class="col-md-3">
                    <button type="button" class="btn btn-outline-white" style="width: 100%">View Activity</button>
                </div>
            </div>

            <!--start user role details--> 
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header"> User Role Details</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label>User Role Name</label>
                                        <input type="text" class="form-control">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Short Description</label>
                                        <input type="text" class="form-control">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Status</label>
                                        <select class="form-control">
                                            <option></option>
                                        </select>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Assigned Users</label>
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>EID</th>
                                                        <th>Name</th>
                                                        <th>Designation</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td><button type="button" class="btn btn-danger"><span class="fa fa-times"></span></button></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="form-group col-md-6">
                                            <label>Select User</label>
                                            <select class="form-control" style="color: #000">
                                                <option></option>
                                            </select>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label></label><br>
                                            <button type="button" class="btn btn-green">Add</button>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <label class="form-label col-form-label col-md-9"></label>
                                        <div class="col-md-3">
                                            <button type="button" class="btn btn-green" style="width: 100%">Save Changes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end user role details--> 

            <!--start queue activity--> 
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header"> Queue Activity</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Timestamp</th>
                                                    <th>Activity Description</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end queue activity--> 

        </div>
    </div>
</div>



<script>

    $('#data-table-default').DataTable({
        responsive: true
    });

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