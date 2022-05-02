<%-- 
    Document   : ajax_queues_management_manage_category_details
    Created on : Dec 17, 2021, 8:24:44 AM
    Author     : JOY
--%>

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
            QmCategories selectedCategory = (QmCategories) ses.load(QmCategories.class, Integer.parseInt(request.getParameter("categoryId")));
             if (selectedCategory != null) {
%>           
    <div class="row">
            <div class="col-sm-12">
                <h1 class="page-header"> Category Details</h1>
                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="form-group mb-3">
                                    <label>Category Name</label>
                                    <input type="text" class="form-control" id="categoryNameU" value="<%=selectedCategory.getCategoryName()%>">
                                    <input type="hidden" class="form-control" id="categoryIdU" value="<%=selectedCategory.getId()%>">
                                </div>
                                <div class="form-group mb-3">
                                    <label>Short Description</label>
                                    <input type="text" class="form-control" id="categoryDescriptionU" value="<%=selectedCategory.getDescription()%>" >
                                </div>
                                <div class="form-group mb-3">
                                    <label>Queue</label>
                                    <select class="default-select2 form-control" style="color: #fff" id="queueToAddCategoryU">
                                        <option selected="" value="<%=selectedCategory.getQmQueue().getId()%>"  style="color: #000"><%=selectedCategory.getQmQueue().getQueueName()%></option>
                                        <%
                                            List<QmQueue> loadQueueToAddCategoryU = new com.ring.queueManagementModel.QMS_QM_Queue().getAllQueuesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                            if(!loadQueueToAddCategoryU.isEmpty()){
                                                for (QmQueue elemQUU : loadQueueToAddCategoryU) {
                                                    if(selectedCategory.getQmQueue().getId() != elemQUU.getId()){
                                        %>
                                        <option value="<%=elemQUU.getId()%>" style="color: #000"><%=elemQUU.getQueueName()%></option> 
                                        <%}}}%>
                                    </select>
                                </div>
                                <div class="mb-3">
                            <label class="form-label" onclick="myFunctionCU()"><span class="fa fa-plus"></span>&nbsp;&nbsp;Assign User</label><br>
                            <div id="myDIVCU" style="display: none">
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <label class="form-label">Select User</label>
                                        <select class="form-control" style="color: #fff" id="userToCategoryU">
                                            <option selected="" value="0" style="color: #000">-- Select User --</option>
                                            <%
                                                List<UmUser> loadUsersToCatagory = new com.ring.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                                if (!loadUsersToCatagory.isEmpty()) {
                                                    for (UmUser elemC : loadUsersToCatagory) {
                                            %>
                                            <option value="<%=elemC.getId()%>" style="color: #000"><%=elemC.getFirstName()%> <%=elemC.getLastName()%></option> 
                                            <%}
                                                }%>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label class="form-label"></label><br>
                                        <button type="button" class="btn btn-success" onclick="addUserDetailsToTableCU()">Add</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                                <div class="form-group mb-3">
                                    <label>Assigned Users</label>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped" id="addUserToCategoryU">
                                            <thead>
                                                <tr>
                                                    <th>EID</th>
                                                    <th>Name</th>
                                                    <th>Designation</th>
                                                    <th></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                            List<QmCategoriesHasUser> loadCategoryHasUsers = new com.ring.queueManagementModel.QMS_QM_Categories_Has_User().getAllUsersByCategoryId(ses, selectedCategory.getId());
                                            if(!loadCategoryHasUsers.isEmpty()){
                                                for (QmCategoriesHasUser userByCategoryU : loadCategoryHasUsers) {
                                        %>
                                                <tr>
                                                    <td><%=userByCategoryU.getUmUser().getId()%></td>
                                                    <td><%=userByCategoryU.getUmUser().getFirstName()%> <%=userByCategoryU.getUmUser().getLastName()%></td>
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
                                    <div class="col-md-3" id="UPDCATBTNDIV">
                                        <button type="button" class="btn btn-green btn-sm" style="width: 100%"  onclick="updateCategory()">Save Changes</button>
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
    function myFunctionCU() {
        var x = document.getElementById("myDIVCU");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    }
    //    function for add users to queue table
    function addUserDetailsToTableCU() {
        if ($('#userToCategoryU option:selected').val() === "0") {
            swal("", "Select User", "warning");
        } else {
            var courseTable = document.getElementById("addUserToCategoryU");
            var rowCount = courseTable.rows.length;
            var duplicateData = true;
            for (var r = 1; r < rowCount; r++) {
                var userId = document.getElementById("addUserToCategoryU").rows[r].cells[0].innerText;
                if (userId === $('#userToCategoryU option:selected').val()) {
                    duplicateData = false;
                }
            }
//                UmUser uu =(UmUser)ses.load(UmUser.class, oo);
//                desig = uu.getPmUserRole().getUserRoleName();
            if (duplicateData) {
                var row = courseTable.insertRow(1);
                $('#addUserToCategoryU > tbody:last').append(row);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(1);
                var cell3 = row.insertCell(2);
                var cell4 = row.insertCell(3);
                cell1.innerHTML = $('#userToCategoryU option:selected').val();
                cell2.innerHTML = $('#userToCategoryU option:selected').text();
                cell3.innerHTML = "";
                cell4.innerHTML = "<button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>";
            } else {
                swal("Stop", "Detail Already added ...!!!!!!", "warning");
            }
        }
    }
     //    function for update Category
    function updateCategory() {
        var categoryIdU = $("#categoryIdU").val();
        var categoryNameU = $("#categoryNameU").val();
        var categoryDescriptionU = $("#categoryDescriptionU").val();
        var queueToAddCategoryU = $("#queueToAddCategoryU option:selected").val();
        if (categoryNameU === "") {
            swal("", "Enter Category Name", "warning");
        } else if (categoryDescriptionU === "") {
            swal("", "Enter Category Description", "warning");
        } else if (queueToAddCategoryU === "0") {
            swal("", "Select Queue", "warning");
        } else {
            var tb1 = document.getElementById('addUserToCategoryU');
            var rowCount = tb1.rows.length;
            var ac = {AC: []};
            var newRows = 0;
            var go = 0;
            for (var t = 1; t < rowCount; t++) {
                var userId = document.getElementById("addUserToCategoryU").rows[t].cells[0].innerText;
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
                url: "queueManagement_updateCategory",
                type: "POST",
                data: "categoryNameU=" + categoryNameU + "&categoryDescriptionU=" + categoryDescriptionU +"&usersDetails=" + usersDetails + "&categoryIdU=" + categoryIdU + "&queueToAddCategoryU=" + queueToAddCategoryU,
                beforeSend: function (xhr) {
                    $('#UPDCATBTNDIV').empty();
                    $('#UPDCATBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                       loadCategoryDetailsToManage(<%=selectedCategory.getId()%>,<%=pid%>,'<%=gg%>');
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#UPDCATBTNDIV').empty();
                    $('#UPDCATBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='updateCategory()'>Save Changes</button>");
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
