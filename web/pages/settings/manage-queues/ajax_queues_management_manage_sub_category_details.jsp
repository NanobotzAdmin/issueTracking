<%-- 
    Document   : ajax_queues_management_manage_sub_category_details
    Created on : Dec 17, 2021, 9:06:14 AM
    Author     : JOY
--%>

<%@page import="com.ring.db.QmSubCategoriesHasUser"%>
<%@page import="com.ring.db.QmSubCategories"%>
<%@page import="com.ring.db.QmCategoriesHasUser"%>
<%@page import="com.ring.db.QmCategories"%>
<%@page import="com.ring.db.QmQueueHasUser"%>
<%@page import="com.ring.db.QmQueue"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="java.util.List"%>
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
            QmSubCategories selectedSubCategory = (QmSubCategories) ses.load(QmSubCategories.class, Integer.parseInt(request.getParameter("subCategoryId")));
             if (selectedSubCategory != null) {
%>           
    <div class="row">
            <div class="col-sm-12">
                <h1 class="page-header">Sub Category Details</h1>
                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="form-group mb-3">
                                    <label>Sub Category Name</label>
                                    <input type="text" class="form-control" id="subCategoryNameU" value="<%=selectedSubCategory.getSubCategoryName()%>">
                                    <input type="hidden" class="form-control" id="subCategoryIdU" value="<%=selectedSubCategory.getId()%>">
                                </div>
                                <div class="form-group mb-3">
                                    <label>Short Description</label>
                                    <input type="text" class="form-control" id="subCategoryDescriptionU"  value="<%=selectedSubCategory.getDescription()%>">
                                </div>
                                <div class="form-group mb-3">
                                    <label>Category</label>
                                    <select class="default-select2 form-control" style="color: #fff" id="categoryToAddSubCategoryU" >
                                        <option  selected="" value="<%=selectedSubCategory.getQmCategories().getId()%>" style="color: #000"><%=selectedSubCategory.getQmCategories().getCategoryName()%></option>
                                        <%
                                            List<QmCategories> loadCategoryToAddSubCategoryU = new com.ring.queueManagementModel.QMS_QM_Categories().getAllCategoriesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                            if(!loadCategoryToAddSubCategoryU.isEmpty()){
                                                for (QmCategories elemSUBCU : loadCategoryToAddSubCategoryU) {
                                                    if(elemSUBCU.getId() != selectedSubCategory.getQmCategories().getId()){
                                        %>
                                           <option value="<%=elemSUBCU.getId()%>" style="color: #000"><%=elemSUBCU.getCategoryName()%></option> 
                                           <%}}}%>
                                    </select>
                                </div>
                                <div class="mb-3">
                            <label class="form-label" onclick="myFunctionSCU()"><span class="fa fa-plus"></span>&nbsp;&nbsp;Assign User</label><br>
                            <div id="myDIVSCU" style="display: none">
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <label class="form-label">Select User</label>
                                        <select class="form-control" style="color: #fff" id="userToSubCategoryU">
                                            <option selected="" value="0" style="color: #000">-- Select User --</option>
                                            <%
                                                List<UmUser> loadUsersToSubCatagory = new com.ring.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                                if (!loadUsersToSubCatagory.isEmpty()) {
                                                    for (UmUser elemSC : loadUsersToSubCatagory) {
                                            %>
                                            <option value="<%=elemSC.getId()%>" style="color: #000"><%=elemSC.getFirstName()%> <%=elemSC.getLastName()%></option> 
                                            <%}
                                                }%>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label class="form-label"></label><br>
                                        <button type="button" class="btn btn-success" onclick="addUserDetailsToTableSCU()">Add</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                                <div class="form-group mb-3">
                                    <label>Assigned Users</label>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped" id="addUserToSubCategoryU">
                                            <thead>
                                                <tr>
                                                    <th>EID</th>
                                                    <th>Name</th>
                                                    <th>Designation</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                  <%
                                            List<QmSubCategoriesHasUser> loadSubCategoryHasUsers = new com.ring.queueManagementModel.QMS_QM_Sub_Categories_Has_User().getAllUsersBySubCategoryId(ses, selectedSubCategory.getId());
                                            if(!loadSubCategoryHasUsers.isEmpty()){
                                                for (QmSubCategoriesHasUser userBySubCategoryU : loadSubCategoryHasUsers) {
                                        %>
                                                <tr>
                                                    <td><%=userBySubCategoryU.getUmUser().getId()%></td>
                                                    <td><%=userBySubCategoryU.getUmUser().getFirstName()%> <%=userBySubCategoryU.getUmUser().getLastName()%></td>
                                                    <td></td>
                                                    <td><button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button></td>
                                                </tr>
                                                <%}}%>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>


                                <div class="row mb-3">
                                    <label class="form-label col-form-label col-md-9"></label>
                                    <div class="col-md-3" id="UPDSUBCATBTNDIV">
                                        <button type="button" class="btn btn-green btn-sm" style="width: 100%" onclick="updateSubCategory()">Save Changes</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
            <%}%>
<script>
    function myFunctionSCU() {
        var x = document.getElementById("myDIVSCU");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    }
    //    function for add users to queue table
    function addUserDetailsToTableSCU() {
        if ($('#userToSubCategoryU option:selected').val() === "0") {
            swal("", "Select User", "warning");
        } else {
            var courseTable = document.getElementById("addUserToSubCategoryU");
            var rowCount = courseTable.rows.length;
            var duplicateData = true;
            for (var r = 1; r < rowCount; r++) {
                var userId = document.getElementById("addUserToSubCategoryU").rows[r].cells[0].innerText;
                if (userId === $('#userToSubCategoryU option:selected').val()) {
                    duplicateData = false;
                }
            }
//                UmUser uu =(UmUser)ses.load(UmUser.class, oo);
//                desig = uu.getPmUserRole().getUserRoleName();
            if (duplicateData) {
                var row = courseTable.insertRow(1);
                $('#addUserToSubCategoryU > tbody:last').append(row);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(1);
                var cell3 = row.insertCell(2);
                var cell4 = row.insertCell(3);
                cell1.innerHTML = $('#userToSubCategoryU option:selected').val();
                cell2.innerHTML = $('#userToSubCategoryU option:selected').text();
                cell3.innerHTML = "";
                cell4.innerHTML = "<button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>";
            } else {
                swal("Stop", "Detail Already added ...!!!!!!", "warning");
            }
        }
    }
    
     //    function for update Sub Category
    function updateSubCategory() {
        var subCategoryIdU = $("#subCategoryIdU").val();
        var subCategoryNameU = $("#subCategoryNameU").val();
        var subCategoryDescriptionU = $("#subCategoryDescriptionU").val();
        var categoryToAddSubCategoryU = $("#categoryToAddSubCategoryU option:selected").val();
        if (subCategoryNameU === "") {
            swal("", "Enter Sub Category Name", "warning");
        } else if (subCategoryDescriptionU === "") {
            swal("", "Enter Sub Category Description", "warning");
        } else if (categoryToAddSubCategoryU === "0") {
            swal("", "Select Category", "warning");
        } else {
            var tb1 = document.getElementById('addUserToSubCategoryU');
            var rowCount = tb1.rows.length;
            var ac = {AC: []};
            var newRows = 0;
            var go = 0;
            for (var t = 1; t < rowCount; t++) {
                var userId = document.getElementById("addUserToSubCategoryU").rows[t].cells[0].innerText;
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
                url: "queueManagement_updateSubCategory",
                type: "POST",
                data: "subCategoryNameU=" + subCategoryNameU + "&subCategoryDescriptionU=" + subCategoryDescriptionU +"&usersDetails=" + usersDetails + "&subCategoryIdU=" + subCategoryIdU + "&categoryToAddSubCategoryU=" + categoryToAddSubCategoryU,
                beforeSend: function (xhr) {
                    $('#UPDSUBCATBTNDIV').empty();
                    $('#UPDSUBCATBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                       loadSubCategoryDetailsToManage(<%=selectedSubCategory.getId()%>,<%=pid%>,'<%=gg%>');
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#UPDSUBCATBTNDIV').empty();
                    $('#UPDSUBCATBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='updateSubCategory()'>Save Changes</button>");
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
