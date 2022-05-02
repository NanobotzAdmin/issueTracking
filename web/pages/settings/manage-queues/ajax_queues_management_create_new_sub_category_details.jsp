<%-- 
    Document   : ajax_queues_management_create_new_sub_category_details
    Created on : Dec 17, 2021, 8:43:45 AM
    Author     : JOY
--%>

<%@page import="com.ring.db.QmCategories"%>
<%@page import="com.ring.db.QmSubCategories"%>
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
                                    <input type="text" class="form-control" id="subCategoryName">
                                </div>
                                <div class="form-group mb-3">
                                    <label>Short Description</label>
                                    <input type="text" class="form-control" id="subCategoryDescription">
                                </div>
                                 <div class="form-group mb-3">
                                    <label>Category</label>
                                    <select class="default-select2 form-control" style="color: #fff" id="categoryToAddSubCategory" >
                                        <option  selected="" value="0" style="color: #000">-- Select Category --</option>
                                        <%
                                            List<QmCategories> loadCategoryToAddSubCategory = new com.ring.queueManagementModel.QMS_QM_Categories().getAllCategoriesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                            if(!loadCategoryToAddSubCategory.isEmpty()){
                                                for (QmCategories elemSUBC : loadCategoryToAddSubCategory) {
                                        %>
                                           <option value="<%=elemSUBC.getId()%>" style="color: #000"><%=elemSUBC.getCategoryName()%></option> 
                                           <%}}%>
                                    </select>
                                </div>
                                <div class="mb-3">
                            <label class="form-label" onclick="myFunctionSC()"><span class="fa fa-plus"></span>&nbsp;&nbsp;Assign User</label><br>
                            <div id="myDIVSC" style="display: none">
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <label class="form-label">Select User</label>
                                        <select class="default-select2 form-control" style="color: #fff" id="userToSubCategory">
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
                                        <button type="button" class="btn btn-success" onclick="addUserDetailsToTableSC()">Add</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                                <div class="form-group mb-3">
                                    <label>Assigned Users</label>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped" id="addUserToSubCategory">
                                            <thead>
                                                <tr>
                                                    <th>EID</th>
                                                    <th>Name</th>
                                                    <th>Designation</th>
                                                    <th></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                               
                                            </tbody>
                                        </table>
                                    </div>
                                </div>


                                <div class="row mb-3">
                                    <label class="form-label col-form-label col-md-9"></label>
                                    <div class="col-md-3" id="ADDSUBCTGBTNDIV">
                                        <button type="button" class="btn btn-green btn-sm" style="width: 100%" onclick="addSubCategory()">Save Changes</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

<script>
    
    $(".default-select2").select2();
    
    function myFunctionSC() {
        var x = document.getElementById("myDIVSC");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    }
//    function for add users to sub Catagory table
    function addUserDetailsToTableSC() {
        if ($('#userToSubCategory option:selected').val() === "0") {
            swal("", "Select User", "warning");
        } else {
            var courseTable = document.getElementById("addUserToSubCategory");
            var rowCount = courseTable.rows.length;
            var duplicateData = true;
            for (var r = 1; r < rowCount; r++) {
                var userId = document.getElementById("addUserToSubCategory").rows[r].cells[0].innerText;
                if (userId === $('#userToSubCategory option:selected').val()) {
                    duplicateData = false;
                }
            }
//                UmUser uu =(UmUser)ses.load(UmUser.class, oo);
//                desig = uu.getPmUserRole().getUserRoleName();
            if (duplicateData) {
                var row = courseTable.insertRow(1);
                $('#addUserToSubCategory > tbody:last').append(row);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(1);
                var cell3 = row.insertCell(2);
                var cell4 = row.insertCell(3);
                cell1.innerHTML = $('#userToSubCategory option:selected').val();
                cell2.innerHTML = $('#userToSubCategory option:selected').text();
                cell3.innerHTML = "";
                cell4.innerHTML = "<button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>";
            } else {
                swal("Stop", "Detail Already added ...!!!!!!", "warning");
            }
        }
    }
    
    //    function for add new Sub Category
    function addSubCategory() {

        var subCategoryName = $("#subCategoryName").val();
        var subCategoryDescription = $("#subCategoryDescription").val();
        var categoryToAddSubCategory = $("#categoryToAddSubCategory option:selected").val();
        if (subCategoryName === "") {
            swal("", "Enter Sub Category Name", "warning");
        } else if (subCategoryDescription === "") {
            swal("", "Enter Sub Category Description", "warning");
        } else if (categoryToAddSubCategory === "0") {
            swal("", "Select Category", "warning");
        } else {
            var tb1 = document.getElementById('addUserToSubCategory');
            var rowCount = tb1.rows.length;
            var ac = {AC: []};
            var newRows = 0;
            var go = 0;
            for (var t = 1; t < rowCount; t++) {
                var userId = document.getElementById("addUserToSubCategory").rows[t].cells[0].innerText;
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
                url: "queueManagement_addSubCategory",
                type: "POST",
                data: "usersDetails=" + usersDetails + "&subCategoryName=" + subCategoryName + "&subCategoryDescription=" + subCategoryDescription + "&categoryToAddSubCategory=" + categoryToAddSubCategory,
                beforeSend: function (xhr) {
                    $('#ADDSUBCTGBTNDIV').empty();
                    $('#ADDSUBCTGBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    $('#ADDSUBCTGBTNDIV').empty();
                    $('#ADDSUBCTGBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addSubCategory()'>Save Changes</button>");
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
