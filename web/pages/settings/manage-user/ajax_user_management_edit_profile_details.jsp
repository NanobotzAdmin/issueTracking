<%-- 
    Document   : ajax_user_management_edit_profile_details
    Created on : Jan 27, 2022, 1:42:22 PM
    Author     : buddh
--%>

<%@page import="com.ring.db.PmUserRole"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.db.UmUser"%>
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
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {

            UmUser selectedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getParameter("id")));
            if (selectedUser != null) {
%>  
<!--start edit user-->
<h1 class="page-header">Edit User</h1>
<div class="panel panel-inverse">
    <div class="panel-body">
         <form method="POST" enctype="multipart/form-data" id="userUpdateForm">
        <div class="card">
            <div class="card-body">
                <h4 style="text-align: center">~~Personal Details~~</h4><br>
                <div class="form-group mb-3">
                    <label>First Name</label>
                    <input type="hidden"  name="selectedUserForUp" id="selectedUserForUp" value="<%=selectedUser.getId()%>">
                    <input type="text" class="form-control" id="fNameU" name="fNameU" value="<%=selectedUser.getFirstName()%>">
                </div>
                <div class="form-group mb-3">
                    <label>Last Name</label>
                    <input type="text" class="form-control" id="lNameU" name="lNameU" value="<%=selectedUser.getLastName()%>">
                </div>
                <div class="row mb-3">
                    <div class="form-group col-md-6">
                        <label>NIC or Passport</label>
                        <input type="text" class="form-control" id="nicU" name="nicU" value="<%=selectedUser.getNicOrPassport()%>">
                    </div>
                    <!--                    <div class="form-group col-md-6">
                                            <label>Date of Birth</label>
                                            <input type="text" class="form-control" id="datepicker-autoClose"/>
                                        </div>-->
                </div>
                <div class="form-group mb-3">
                    <label>Mobile</label>
                    <input type="text" class="form-control" id="mobileU" name="mobileU" value="<%=selectedUser.getMobileNumber()%>">
                </div>
                <div class="form-group mb-3">
                    <label>E-mail</label>
                    <input type="email" class="form-control" id="emailU" name="emailU" value="<%=selectedUser.getEmailAddress()%>">
                </div>
                <div class="row mb-3">
                    <!--                    <div class="form-group col-md-6">
                                            <label>Gender</label>
                                            <select class="form-control" id="gender" name="gender" style="color: #000">
                                                <option value="1">Male</option>
                                                <option value="0">Female</option>
                                            </select>
                                        </div>-->
                    <div class="form-group col-md-6">
                        <label>Marital Status</label>
                        <select class="form-control" id="maritalStatusU" name="maritalStatusU" style="color: #000">
                            <option value="<%=selectedUser.getMaritialStatus()%>" selected=""><%=selectedUser.getMaritialStatus()%></option>
                            <option value="Married ">Married </option>
                            <option value="Widowed  ">Widowed  </option>
                            <option value="Separated  ">Separated  </option>
                            <option value="Divorced  ">Divorced  </option>
                            <option value="Single  ">Single  </option>
                        </select>
                    </div>
                </div>
                <div class="form-group mb-3">
                    <label>User Role</label>
                    <select class="default-select2 form-control" id="userRoleU" name="userRoleU">
                        <option value="<%=selectedUser.getPmUserRole().getId()%>" selected=""><%=selectedUser.getPmUserRole().getUserRoleName()%></option>>
                        <%                                    
                            List<PmUserRole> loadUserRoleU = new com.ring.privilegeManagementModel.PMS_PM_User_Role().getAllActiveUserRoles(ses, STATIC_DATA_MODEL.PMACTIVE);
                            if (!loadUserRoleU.isEmpty()) {
                                for (PmUserRole urolesU : loadUserRoleU) {
                        %>
                        <option value="<%=urolesU.getId()%>"><%=urolesU.getUserRoleName()%></option>
                        <%}
                                }%>
                    </select>
                </div>

                <div class="form-group mb-3">
                    <label>Employee ID</label>
                    <input type="text" class="form-control" id="empIdU" name="empIdU" value="<%=selectedUser.getRemark2()%>">
                </div>
                <div class="form-group mb-3">
                    <label>Profile Picture</label>
                    <input type="file" class="form-control" id="propicU" name="propicU">
                </div>
                <hr>
                <div class="form-group row mb-3">
                    <label class="col-sm-8"></label>

                    <div class="col-sm-4" id="UPDUSRBTNDIV">
                        <button type="button" class="btn btn-success" style="width: 100%" onclick="updateUserProfileDetails()">Update</button>
                    </div>
                </div>

            </div>
        </div>
         </form>        
    </div>
</div>
<%}%>
<script type="text/javascript">
    $(document).ready(function () {

        $(".default-select2").select2();

//        $("#datepicker-autoClose").datepicker({
//            todayHighlight: true,
//            autoclose: true,
//            format: "yyyy-mm-dd"
//        });
//
//        $(".tagitLocation").tagit({
//            availableTags: ["maharagama", "navala medicore", "townhall", "grandpass", "avissawella", "kandy CC", "head office"]
//        });
    });

 //    function for update selected user Profile
    function updateUserProfileDetails() {
        var fName = $("#fNameU").val();
        var lName = $("#lNameU").val();
        var nic = $("#nicU").val();
        var mobile = $("#mobileU").val();
        var email = $("#emailU").val();
        var maritalStatus = $("#maritalStatusU option:selected").val();
        var userRole = $("#userRoleU option:selected").val();
        var empId = $("#empIdU").val();
        if (fName === "") {
            swal("", "Enter First Name", "warning");
        } else if (lName === "") {
            swal("", "Enter Last Name", "warning");
        } else if (nic === "") {
            swal("", "Enter NIC", "warning");
        } else if (mobile === "") {
            swal("", "Enter mobile Number", "warning");
        } else if (email === "") {
            swal("", "Enter Email", "warning");
        } else if (userRole === "0") {
            swal("", "Select User Role", "warning");
        } else if (empId === "") {
            swal("", "Enter Employee Id", "warning");
        } else {
             if(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            event.preventDefault();
            // Get form
            var form = $('#userUpdateForm')[0];
            // Create an FormData object 
            var data = new FormData(form);
            // If you want to add an extra field for the FormData
//            data.append("CustomField", "This is some extra data, testing");
            // disabled the submit button
//        $("#btnSubmit").prop("disabled", true);
            $.ajax({
                type: "POST",
                enctype: 'multipart/form-data',
                url: "userManagement_updateUserProfile",
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                beforeSend: function (xhr) {
                    $('#UPDUSRBTNDIV').empty();
                    $('#UPDUSRBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        location.reload();
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#UPDUSRBTNDIV').empty();
                     $('#UPDUSRBTNDIV').html("<button type='button' class='btn btn-success' style='width: 100%' onclick='updateUserProfileDetails()'>Update</button>");
                },
                error: function (e) {
//                    $("#result").text(e.responseText);
                    console.log("ERROR : ", e);
//                    $("#btnSubmit").prop("disabled", false);
                }
            });
            }else{
              swal("", "Enter Vaied Email", "warning");  
            } 
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