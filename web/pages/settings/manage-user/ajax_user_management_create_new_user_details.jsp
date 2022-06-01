<%-- 
    Document   : ajax_user_management_create_new_user_details
    Created on : Dec 31, 2021, 7:34:40 AM
    Author     : JOY
--%>

<%@page import="org.hibernate.Transaction"%>
<%@page import="com.it.db.PmUserRole"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="java.util.List"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
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

%>  
<!--start create new user-->
<h1 class="page-header">Create New User</h1>
<div class="panel panel-inverse">
    <div class="panel-body">
        <div class="card">
            <div class="card-body">
                <form method="POST" enctype="multipart/form-data" id="userForm">
                    <h4 style="text-align: center">~~Personal Details~~</h4><br>
                    <div class="form-group mb-3">
                        <label>First Name</label>
                        <input type="text" class="form-control" id="fName" name="fName">
                    </div>
                    <div class="form-group mb-3">
                        <label>Last Name</label>
                        <input type="text" class="form-control" id="lName" name="lName">
                    </div>
                    <div class="row mb-3">
                        <div class="form-group col-md-6">
                            <label>NIC</label>
                            <input type="text" class="form-control" id="nic" name="nic">
                        </div>
                        <!--                    <div class="form-group col-md-6">
                                                <label>Date of Birth</label>
                                                <input type="text" class="form-control" id="datepicker-autoClose"/>
                                            </div>-->
                    </div>
                    <div class="form-group mb-3">
                        <label>Mobile</label>
                        <input type="text" class="form-control" id="mobile" name="mobile">
                    </div>
                    <div class="form-group mb-3">
                        <label>E-mail</label>
                        <input type="email" class="form-control" id="email" name="email">
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
                            <select class="form-control" id="maritalStatus" name="maritalStatus" style="color: #000">
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
                        <select class="default-select2 form-control" id="userRole" name="userRole">
                            <option value="0" selected="">-- Select User Role --</option>>
                            <%                                    List<PmUserRole> loadUserRole = new com.it.privilegeManagementModel.PMS_PM_User_Role().getAllActiveUserRoles(ses, STATIC_DATA_MODEL.PMACTIVE);
                                if (!loadUserRole.isEmpty()) {
                                    for (PmUserRole uroles : loadUserRole) {
                            %>
                            <option value="<%=uroles.getId()%>"><%=uroles.getUserRoleName()%></option>
                            <%}
                                    }%>
                        </select>
                    </div>
                    <!--                <div class="form-group mb-3">
                                        <label>Locations</label>
                                        <ul id="jquery-tagIt-warning" class="tagitLocation warning tagit">
                                            <li>tag 1</li>
                                            <li>tag 2</li>
                                        </ul>
                                    </div>-->
                    <div class="form-group mb-3">
                        <label>Employee ID</label>
                        <input type="text" class="form-control" id="empId" name="empId" onkeyup="setValue()">
                    </div>
                    <div class="form-group mb-3">
                        <label>Profile Picture</label>
                        <input type="file" class="form-control" id="propic" name="propic">
                    </div>
                    <hr>
                    <h4 style="text-align: center">~~Login Details~~</h4><br>
                    <div class="form-group mb-3">
                        <label>Username</label>
                        <input type="text" disabled="" class="form-control" id="uname" name="uname">
                    </div>
                    <div class="form-group mb-3">
                        <label>Password</label>
                        <input type="password" class="form-control" id="pass" name="pass">
                    </div>
                    <div class="form-group mb-3">
                        <label>Confirm Password</label>
                        <input type="password" class="form-control" id="cPass" name="cPass">
                    </div>

                    <div class="form-group row mb-3">
                        <label class="col-sm-8"></label>
                        <div class="col-sm-2">
                            <button type="button" class="btn btn-info" style="width: 100%">Profile</button>
                        </div>
                        <div class="col-sm-2" id="ADDUSRBTNDIV">
                            <button type="button" class="btn btn-success" style="width: 100%" onclick="addNewUser()">Save</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {

        $(".default-select2").select2();

        $("#datepicker-autoClose").datepicker({
            todayHighlight: true,
            autoclose: true,
            format: "yyyy-mm-dd"
        });

        $(".tagitLocation").tagit({
            availableTags: ["maharagama", "navala medicore", "townhall", "grandpass", "avissawella", "kandy CC", "head office"]
        });
    });

    //    function for add new User
//    function addNewUser() {
//        var fName = $("#fName").val();
//        var lName = $("#lName").val();
//        var nic = $("#nic").val();
////        var datepickerautoClose = $("#datepicker-autoClose").val();
//        var mobile = $("#mobile").val();
//        var email = $("#email").val();
////        var gender = $("#gender option:selected").val();
//        var maritalStatus = $("#maritalStatus option:selected").val();
//        var userRole = $("#userRole option:selected").val();
//        var empId = $("#empId").val();
//        var uname = $("#uname").val();
//        var pass = $("#pass").val();
//        var cPass = $("#cPass").val();
////        alert(datepickerautoClose);
//        if (fName === "") {
//            swal("", "Enter First Name", "warning");
//        } else if (lName === "") {
//            swal("", "Enter Last Name", "warning");
//        } else if (nic === "") {
//            swal("", "Enter NIC", "warning");
////        } else if (datepickerautoClose === "") {
////            swal("", "Select DOB", "warning");
//        } else if (mobile === "") {
//            swal("", "Enter mobile Number", "warning");
//        } else if (email === "") {
//            swal("", "Enter Email", "warning");
//        } else if (userRole === "0") {
//            swal("", "Select User Role", "warning");
//        } else if (empId === "") {
//            swal("", "Enter Employee Id", "warning");
//        } else if (uname === "") {
//            swal("", "Enter User Name", "warning");
//        } else if (pass === "") {
//            swal("", "Enter Password", "warning");
//        } else if (cPass === "") {
//            swal("", "Enter Confirm Password", "warning");
//        } else if (pass !== cPass) {
//            swal("", "Password Not Mached", "warning");
//        } else {
//            $.ajax({
//                url: "userManagement_addUser",
//                type: "POST",
//                data: "fName=" + fName + "&lName=" + lName + "&nic=" + nic + "&mobile=" + mobile + "&email=" + email + "&maritalStatus=" + maritalStatus + "&userRole=" + userRole + "&empId=" + empId + "&uname=" + uname + "&pass=" + pass + "&cPass=" + cPass,
//                beforeSend: function (xhr) {
//                    $('#ADDUSRBTNDIV').empty();
//                    $('#ADDUSRBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
//                },
//                success: function (data) {
//                    var resultValue = JSON.parse(data);
//                    if (resultValue.result === "0") {
//                        swal("", resultValue.displayMessage, "error");
//                    } else if (resultValue.result === "2") {
//                        swal("", resultValue.displayMessage, "error");
//                        setTimeout(function () {
//                            window.location.href = "../../../index.jsp";
//                        }, 2000);
//                    } else if (resultValue.result === "1") {
//                        location.reload();
//                        swal({
//                            title: "Done",
//                            text: resultValue.displayMessage,
//                            timer: 1000,
//                            showConfirmButton: false
//                        });
//                    }
//                    $('#ADDUSRBTNDIV').empty();
//                    $('#ADDUSRBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addNewUser()'>Save</button>");
//                },
//                error: function (error) {
//                }
//            });
//        }
//    }

    //    function for add new Queue
    function addNewUser() {
        var fName = $("#fName").val();
        var lName = $("#lName").val();
        var nic = $("#nic").val();
        var mobile = $("#mobile").val();
        var email = $("#email").val();
        var maritalStatus = $("#maritalStatus option:selected").val();
        var userRole = $("#userRole option:selected").val();
        var empId = $("#empId").val();
        var uname = $("#uname").val();
        var pass = $("#pass").val();
        var cPass = $("#cPass").val();
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
        } else if (uname === "") {
            swal("", "Enter User Name", "warning");
        } else if (pass === "") {
            swal("", "Enter Password", "warning");
        } else if (cPass === "") {
            swal("", "Enter Confirm Password", "warning");
        } else if (pass !== cPass) {
            swal("", "Password Not Mached", "warning");
        } else {
            if(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            event.preventDefault();
            // Get form
            var form = $('#userForm')[0];
            // Create an FormData object 
            var data = new FormData(form);
            // If you want to add an extra field for the FormData
//            data.append("CustomField", "This is some extra data, testing");
            // disabled the submit button
//        $("#btnSubmit").prop("disabled", true);
            $.ajax({
                type: "POST",
                enctype: 'multipart/form-data',
                url: "userManagement_addUser",
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                beforeSend: function (xhr) {
                    $('#ADDUSRBTNDIV').empty();
                    $('#ADDUSRBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    $('#ADDUSRBTNDIV').empty();
                     $('#ADDUSRBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addNewUser()'>Save</button>");
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

    function  setValue(){
        var a = $('#empId').val();
        $('#uname').val(a);
    }








</script>
<!--end create new user-->
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
