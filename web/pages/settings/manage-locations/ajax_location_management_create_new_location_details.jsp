<%-- 
    Document   : ajax_location_management_create_new_location_details
    Created on : Dec 3, 2021, 12:52:57 PM
    Author     : JOY
--%>

<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="java.util.List"%>
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
        String gg = (request.getParameter("pageUrl"));
        int pid = Integer.parseInt(request.getParameter("interfaceId"));
        try {
//            int oo=0;
//            String desig = "";
%>           
<!--start  new location details--> 

<div class="row">
    <div class="col-sm-12">
        <h1 class="page-header">New Locations Details</h1>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">Location Name</label>
                            <input class="form-control" type="text" id="locationName" placeholder="Location Name" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Address</label>
                            <input class="form-control" type="text" id="address" placeholder="Location Address" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mobile</label>
                            <input class="form-control" type="text" id="mobile" placeholder="Location Manager Mobile Number" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Land Phone</label>
                            <input class="form-control" type="text" id="landnumber" placeholder="Location Land Line Number" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Branch Manager</label>
                            <select class="form-control" style="color: #fff" id="branchManager">
                                <option selected="" value="0" style="color: #000">-- Select Branch Manager --</option>
                                <%
                                    List<UmUser> loadBranchManagers = new com.it.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                    if (!loadBranchManagers.isEmpty()) {
                                        for (UmUser elem : loadBranchManagers) {
                                %>
                                <option value="<%=elem.getId()%>" style="color: #000"><%=elem.getFirstName()%> <%=elem.getLastName()%></option> 
                                <%}
                                    }%>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Assign Users</label>
                            <div class="table-responsive">
                                <table class="table table-bordered table-striped" id="addUsersToBranch">
                                    <thead>
                                        <tr>
                                            <td>EID</td>
                                            <td>Name</td>
                                            <td>Designation</td>
                                            <td></td>
                                        </tr>
                                    </thead>
                                    <tbody>

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
                                        <select class="form-control" style="color: #fff" id="userToBranch">
                                            <option selected="" value="0" style="color: #000">-- Select User --</option>
                                            <%
                                                List<UmUser> loadUsersToBranch = new com.it.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                                if (!loadUsersToBranch.isEmpty()) {
                                                    for (UmUser elem2 : loadBranchManagers) {
                                            %>
                                            <option value="<%=elem2.getId()%>" style="color: #000"><%=elem2.getFirstName()%> <%=elem2.getLastName()%></option> 
                                            <%}
                                                }%>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label class="form-label"></label><br>
                                        <button type="button" class="btn btn-success" onclick="addUserDetailsToTable()">Add</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <label class="form-label col-form-label col-md-9"></label>
                            <div class="col-md-3" id="ADDLCTBTNDIV">
                                <button type="button" class="btn btn-green" style="width: 100%" onclick="addLocation()">Save Changes</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--end  new location details--> 
<script>
    function myFunction() {
        var x = document.getElementById("myDIV");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    }
//    function for add users to branch table
    function addUserDetailsToTable() {
        if ($('#userToBranch option:selected').val() === "0") {
            swal("", "Select User", "warning");
        } else {
            var courseTable = document.getElementById("addUsersToBranch");
            var rowCount = courseTable.rows.length;
            var duplicateData = true;
            for (var r = 1; r < rowCount; r++) {
                var userId = document.getElementById("addUsersToBranch").rows[r].cells[0].innerText;
                if (userId === $('#userToBranch option:selected').val()) {
                    duplicateData = false;
                }
            }
//                UmUser uu =(UmUser)ses.load(UmUser.class, oo);
//                desig = uu.getPmUserRole().getUserRoleName();
            if (duplicateData) {
                var row = courseTable.insertRow(1);
                $('#addUsersToBranch > tbody:last').append(row);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(1);
                var cell3 = row.insertCell(2);
                var cell4 = row.insertCell(3);
                cell1.innerHTML = $('#userToBranch option:selected').val();
                cell2.innerHTML = $('#userToBranch option:selected').text();
                cell3.innerHTML = "";
                cell4.innerHTML = "<button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>";
            } else {
                swal("Stop", "Detail Already added ...!!!!!!", "warning");
            }
        }
    }
//    function for add new location
    function addLocation() {

        var locationName = $("#locationName").val();
        var address = $("#address").val();
        var mobile = $("#mobile").val();
        var landnumber = $("#landnumber").val();
        var branchManager = $("#branchManager option:selected").val();
        if (locationName === "") {
            swal("", "Enter Location Name", "warning");
        } else if (address === "") {
            swal("", "Enter address", "warning");
        } else if (mobile === "") {
            swal("", "Enter mobile Number", "warning");
        } else if (landnumber === "") {
            swal("", "Enter Land Number", "warning");
        } else if (branchManager === "0") {
            swal("", "Select Branch Manager", "warning");
        } else {
            var tb1 = document.getElementById('addUsersToBranch');
            var rowCount = tb1.rows.length;
            var ac = {AC: []};
            var newRows = 0;
            var go = 0;
            for (var t = 1; t < rowCount; t++) {
                var userId = document.getElementById("addUsersToBranch").rows[t].cells[0].innerText;
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
                url: "locationManagement_addLocation",
                type: "POST",
                data: "locationName=" + locationName + "&address=" + address + "&mobile=" + mobile + "&landnumber=" + landnumber + "&branchManager=" + branchManager + "&usersDetails=" + usersDetails,
                beforeSend: function (xhr) {
                    $('#ADDLCTBTNDIV').empty();
                    $('#ADDLCTBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                          loadPage('<%=gg%>',<%=pid%>)
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#ADDLCTBTNDIV').empty();
                    $('#ADDLCTBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addLocation()'>Save Changes</button>");
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
