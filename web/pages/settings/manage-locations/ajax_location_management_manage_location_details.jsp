<%-- 
    Document   : ajax_location_management_manage_location_details
    Created on : Dec 4, 2021, 3:55:03 AM
    Author     : JOY
--%>

<%@page import="com.ring.db.LmLocationsHasUmUser"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.LmLocations"%>
<%@page import="com.ring.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Transaction"%>
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
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        String gg = (request.getParameter("pageUrl"));
        int pid = Integer.parseInt(request.getParameter("interfaceId"));
        try {

            LmLocations selectedLocation = (LmLocations) ses.load(LmLocations.class, Integer.parseInt(request.getParameter("locationId")));
            if (selectedLocation != null) {
%>  
<!--start location details-->
<div class="row">
    <div class="col-sm-12">
        <h1 class="page-header"> Locations Details</h1>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">Location Name</label>
                            <input class="form-control" type="hidden" id="locationIdU" value="<%=selectedLocation.getId()%>" />
                            <input class="form-control" type="text" id="locationNameU" value="<%=selectedLocation.getLocationName()%>" placeholder="Location Name"  />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Address</label>
                            <input class="form-control" type="text" id="addressU" value="<%=selectedLocation.getLocationAddress()%>" placeholder="Location Address" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mobile</label>
                            <input class="form-control" type="text" id="mobileU" value="<%=selectedLocation.getMobileNumber()%>" placeholder="Location Manager Mobile Number" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Land Phone</label>
                            <input class="form-control" type="text" id="landnumberU" value="<%=selectedLocation.getLandPhoneNumber()%>" placeholder="Location Land Line Number" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Branch Manager</label>
                            <select class="form-control" style="color: #fff" id="branchManagerU">
                                <option selected="" value="<%=selectedLocation.getUmUser().getId()%>" style="color: #000"><%=selectedLocation.getUmUser().getFirstName()%> <%=selectedLocation.getUmUser().getLastName()%></option>
                                <%
                                    List<UmUser> loadBranchManagersU = new com.ring.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                    if (!loadBranchManagersU.isEmpty()) {
                                        for (UmUser elemU : loadBranchManagersU) {
                                %>
                                <option value="<%=elemU.getId()%>" style="color: #000"><%=elemU.getFirstName()%> <%=elemU.getLastName()%></option> 
                                <%}
                                    }%>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" onclick="myFunction2()"><span class="fa fa-plus"></span>&nbsp;&nbsp;Assign User</label><br>
                            <div id="myDIV2" style="display: none">
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <label class="form-label">Select User</label>
                                        <select class="form-control" style="color: #fff" id="userToBranchU">
                                            <option selected="" value="0" style="color: #000">-- Select User --</option>
                                            <%
                                                List<UmUser> loadUsersToBranchU = new com.ring.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                                if (!loadUsersToBranchU.isEmpty()) {
                                                    for (UmUser elem2U : loadUsersToBranchU) {
                                            %>
                                            <option value="<%=elem2U.getId()%>" style="color: #000"><%=elem2U.getFirstName()%> <%=elem2U.getLastName()%></option> 
                                            <%}
                                                }%>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label class="form-label"></label><br>
                                        <button type="button" class="btn btn-success" onclick="addUserDetailsToTableU()">Add</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Assign Users</label>
                            <div class="table-responsive">
                                <table class="table table-bordered table-striped" id="addUsersToBranchU">
                                    <thead>
                                        <tr>
                                            <td>EID</td>
                                            <td>Name</td>
                                            <td>Designation</td>
                                            <td></td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<LmLocationsHasUmUser> loadLocationHasUsers = new com.ring.locationManagementModel.LMS_LM_Locations_Has_Um_User().getAllUsersByLocationId(ses, selectedLocation.getId());
                                            if (!loadLocationHasUsers.isEmpty()) {
                                                for (LmLocationsHasUmUser userByLocation : loadLocationHasUsers) {
                                        %>
                                        <tr>
                                            <td><%=userByLocation.getUmUser().getId()%></td>
                                            <td><%=userByLocation.getUmUser().getFirstName()%> <%=userByLocation.getUmUser().getLastName()%></td>
                                            <td></td>
                                            <td><button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button></td>
                                        </tr>
                                        <%}
                                            }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>


                        <div class="row mb-3">
                            <label class="form-label col-form-label col-md-9"></label>
                            <div class="col-md-3" id="UPDLCTBTNDIV">
                                <button type="button" class="btn btn-green" style="width: 100%" onclick="updateLocation()">Save Changes</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--end location details-->
<%}%>
<script>
    function myFunction2() {
        var x = document.getElementById("myDIV2");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    }
//    function for add users to branch table
    function addUserDetailsToTableU() {
        if ($('#userToBranchU option:selected').val() === "0") {
            swal("", "Select User", "warning");
        } else {
            var courseTable = document.getElementById("addUsersToBranchU");
            var rowCount = courseTable.rows.length;
            var duplicateData = true;
            for (var r = 1; r < rowCount; r++) {
                var userId = document.getElementById("addUsersToBranchU").rows[r].cells[0].innerText;
                if (userId === $('#userToBranchU option:selected').val()) {
                    duplicateData = false;
                }
            }
//                UmUser uu =(UmUser)ses.load(UmUser.class, oo);
//                desig = uu.getPmUserRole().getUserRoleName();
            if (duplicateData) {
                var row = courseTable.insertRow(1);
                $('#addUsersToBranchU > tbody:last').append(row);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(1);
                var cell3 = row.insertCell(2);
                var cell4 = row.insertCell(3);
                cell1.innerHTML = $('#userToBranchU option:selected').val();
                cell2.innerHTML = $('#userToBranchU option:selected').text();
                cell3.innerHTML = "";
                cell4.innerHTML = "<button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>";
            } else {
                swal("Stop", "Detail Already added ...!!!!!!", "warning");
            }
        }
    }
//    function for add new location
    function updateLocation() {
        var locationIdU = $("#locationIdU").val();
        var locationNameU = $("#locationNameU").val();
        var addressU = $("#addressU").val();
        var mobileU = $("#mobileU").val();
        var landnumberU = $("#landnumberU").val();
        var branchManagerU = $("#branchManagerU option:selected").val();
        if (locationNameU === "") {
            swal("", "Enter Location Name", "warning");
        } else if (addressU === "") {
            swal("", "Enter address", "warning");
        } else if (mobileU === "") {
            swal("", "Enter mobile Number", "warning");
        } else if (landnumberU === "") {
            swal("", "Enter Land Number", "warning");
        } else if (branchManagerU === "0") {
            swal("", "Select Branch Manager", "warning");
        } else {
            var tb1 = document.getElementById('addUsersToBranchU');
            var rowCount = tb1.rows.length;
            var ac = {AC: []};
            var newRows = 0;
            var go = 0;
            for (var t = 1; t < rowCount; t++) {
                var userId = document.getElementById("addUsersToBranchU").rows[t].cells[0].innerText;
                if (userId === "" || userId === "0") {
                } else {
                    go++;
                    ac.AC.push({"userId": userId});
                    newRows++;
                }
            }
            var usersDetails = JSON.stringify(ac);
//            alert(usersDetails);
            $.ajax({
                url: "locationManagement_updateLocation",
                type: "POST",
                data: "locationNameU=" + locationNameU + "&addressU=" + addressU + "&mobileU=" + mobileU + "&landnumberU=" + landnumberU + "&branchManagerU=" + branchManagerU + "&usersDetails=" + usersDetails + "&locationIdU=" + locationIdU,
                beforeSend: function (xhr) {
                    $('#UPDLCTBTNDIV').empty();
                    $('#UPDLCTBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        loadLocationDetailsToManage(<%=selectedLocation.getId()%>);
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#UPDLCTBTNDIV').empty();
                    $('#UPDLCTBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='updateLocation()'>Save Changes</button>");
                },
                error: function (error) {
                }
            });
        }
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
