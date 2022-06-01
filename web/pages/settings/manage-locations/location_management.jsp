<%-- 
    Document   : location_management
    Created on : Nov 24, 2021, 1:40:20 AM
    Author     : JOY
--%>

<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.LmLocations"%>
<%@page import="com.it.db.UmUserHasInterfaceComponent"%>
<%@page import="com.it.db.PmInterfaceComponent"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") != null) {
        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        String gg = (request.getParameter("pageUrl"));
        int pid = Integer.parseInt(request.getParameter("interface"));
        String content_prefix = "../../";
        try {
%>
<h1 class="page-header">Locations</h1>
<%
    List<PmInterfaceComponent> getComponentByIterfaceId = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, pid);
    boolean locationManagementMain = false;

    if (!getComponentByIterfaceId.isEmpty()) {
        for (PmInterfaceComponent cmpt : getComponentByIterfaceId) {
            UmUserHasInterfaceComponent getUserHasComponentByUserAndComponentId = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, logedUser.getId(), cmpt.getId());
            if (getUserHasComponentByUserAndComponentId != null) {
                if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("LOCATIONMAINCOMPONENT")) {
                    locationManagementMain = true;
                }

            }
        }
    }
%>
<%
    if (locationManagementMain) {
%>    
<div class="container-fluid">
    <div class="row">
        <div class="col-sm-12">
            <button type="button" class="btn btn-outline-success" onclick="newLocationDetails('<%=pid%>', '<%=gg%>')">Create New Location</button><br><br>
            <div class="panel panel-inverse">
                <div class="panel-body">
                    <div class="card">
                        <div class="card-body">
                            <%
                                List<LmLocations> loadActiveLocations = new com.it.locationManagementModel.LMS_LM_Locations().getAllLocationsByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                if (!loadActiveLocations.isEmpty()) {
                                    for (LmLocations locations : loadActiveLocations) {
                            %>

                            <div class="row mb-3">
                                <label class="form-label col-form-label col-md-6"><%=locations.getLocationName()%></label>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-outline-info" onclick="loadLocationDetailsToManage(<%=locations.getId()%>,'<%=pid%>', '<%=gg%>')">Manage</button>
                                    <button type="button" class="btn btn-outline-white"  onclick="loadLocationHistoryDetails(<%=locations.getId()%>)">View Activity</button>
                                </div>
                                
                            </div>
<!--                                <div class="row mb-3">
                                    <label class="form-label col-form-label col-md-6"></label>
                                    <div class="col-md-6">
                                        <button type="button" class="btn btn-outline-white" style="width: 100%">View Activity</button>
                                    </div>
                                </div>-->
                            <%}
                                }%>
                            <!--                            <div class="row mb-3">
                                                            <label class="form-label col-form-label col-md-6">Mathara Town Branch</label>
                                                            <div class="col-md-6">
                                                                <button type="button" class="btn btn-outline-info">Manage</button>
                                                            </div>
                                                        </div>-->
                            <!--<div class="row mb-3">
                                <label class="form-label col-form-label col-md-6">Highlevel Road Medicare</label>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-outline-info">Manage</button>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="form-label col-form-label col-md-6">Nawinna Branch</label>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-outline-info">Manage</button>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="form-label col-form-label col-md-6">Head Office Townhall</label>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-outline-info">Manage</button>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="form-label col-form-label col-md-6">IT Division</label>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-outline-info">Manage</button>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="form-label col-form-label col-md-6">HR Division</label>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-outline-info">Manage</button>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="form-label col-form-label col-md-6">Planing Division</label>
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-outline-info">Manage</button>
                                </div>
                            </div>-->
                        </div>
                    </div>
                </div>
            </div>

            <!--            <div class="row mb-3">
                            <label class="form-label col-form-label col-md-9"></label>
                            <div class="col-md-3">
                                <button type="button" class="btn btn-outline-white" style="width: 100%">View Activity</button>
                            </div>
                        </div>-->


            <!--start  new location details--> 

            <!--            <div class="row">
                            <div class="col-sm-12">
                                <h1 class="page-header">New Locations Details</h1>
                                <div class="panel panel-inverse">
                                    <div class="panel-body">
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <label class="form-label">Location Name</label>
                                                    <input class="form-control" type="text" placeholder="Location Name" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Address</label>
                                                    <input class="form-control" type="text" placeholder="Location Address" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Mobile</label>
                                                    <input class="form-control" type="text" placeholder="Location Manager Mobile Number" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Land Phone</label>
                                                    <input class="form-control" type="text" placeholder="Location Land Line Number" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Branch Manager</label>
                                                    <select class="form-control" style="color: #000">
                                                        <option>Select Branch Manager</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Status</label>
                                                    <select class="form-control" style="color: #000">
                                                        <option>Active</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Assign Users</label>
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered table-striped">
                                                            <thead>
                                                                <tr>
                                                                    <td>EID</td>
                                                                    <td>Name</td>
                                                                    <td>Designation</td>
                                                                     <td></td>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr>
                                                                    <td></td>
                                                                    <td></td>
                                                                    <td></td>
                                                                    <td><button type="button" class="btn btn-danger"><span class="fa fa-plus"></span></button></td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label" onclick="myFunction()"><span class="fa fa-plus"></span>&nbsp;&nbsp;Assign User</label><br>
                                                    <div id="myDIV" style="display: none">
                                                        <div class="row">
                                                            <div class="form-group col-md-6">
                                                                <label class="form-label">Select User</label>
                                                                <select class="form-control">
                                                                    <option></option>
                                                                </select>
                                                            </div>
                                                            <div class="form-group col-md-6">
                                                                <label class="form-label"></label><br>
                                                                <button type="button" class="btn btn-success">Add</button>
                                                            </div>
                                                        </div>
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
                        </div>-->

            <!--end  new location details--> 


            <!--start location details-->
            <!--            <div class="row">
                            <div class="col-sm-12">
                                 <h1 class="page-header"> Locations Details</h1>
                                <div class="panel panel-inverse">
                                    <div class="panel-body">
                                        <div class="card">
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <label class="form-label">Location Name</label>
                                                    <input class="form-control" type="text" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Address</label>
                                                    <input class="form-control" type="text" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Mobile</label>
                                                    <input class="form-control" type="text" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Land Phone</label>
                                                    <input class="form-control" type="text" />
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Branch Manager</label>
                                                    <select class="form-control" style="color: #000">
                                                        <option>Select Branch Manager</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Status</label>
                                                    <select class="form-control" style="color: #000">
                                                        <option>Active</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Assign Users</label>
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered table-striped">
                                                            <thead>
                                                                <tr>
                                                                    <td>EID</td>
                                                                    <td>Name</td>
                                                                    <td>Designation</td>
                                                                     <td></td>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr>
                                                                    <td></td>
                                                                    <td></td>
                                                                    <td></td>
                                                                    <td><button type="button" class="btn btn-danger"><span class="fa fa-plus"></span></button></td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label" onclick="myFunction2()"><span class="fa fa-plus"></span>&nbsp;&nbsp;Assign User</label><br>
                                                    <div id="myDIV2" style="display: none">
                                                        <div class="row">
                                                            <div class="form-group col-md-6">
                                                                <label class="form-label">Select User</label>
                                                                <select class="form-control">
                                                                    <option></option>
                                                                </select>
                                                            </div>
                                                            <div class="form-group col-md-6">
                                                                <label class="form-label"></label><br>
                                                                <button type="button" class="btn btn-success">Add</button>
                                                            </div>
                                                        </div>
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
                        </div>-->
            <!--end location details-->

<!--            start location activity
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header"> Locations Activity</h1>
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
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            end location activity-->




        </div>
    </div>
</div>



<script>
    function myFunction2() {
        var x = document.getElementById("myDIV2");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    }
    //    function for load add new location details
    function newLocationDetails(pId, gg) {
        $.ajax({
            url: "pages/settings/manage-locations/ajax_location_management_create_new_location_details.jsp",
            type: "POST",
            data:  "interfaceId=" + pId + "&pageUrl=" + gg,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for load location details to update
    function loadLocationDetailsToManage(locationId,pId, gg) {
        $.ajax({
            url: "pages/settings/manage-locations/ajax_location_management_manage_location_details.jsp",
            type: "POST",
            data: "interfaceId=" + pId +"&pageUrl=" + gg + "&locationId=" + locationId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for load location history details 
    function loadLocationHistoryDetails(locationId) {
        $.ajax({
            url: "pages/settings/manage-locations/ajax_location_management_load_location_history_details.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&locationId=" + locationId,
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