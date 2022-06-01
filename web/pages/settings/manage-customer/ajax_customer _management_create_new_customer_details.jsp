<%-- 
    Document   : ajax_customer _management_create_new_customer_details
    Created on : Jan 4, 2022, 12:46:02 PM
    Author     : JOY
--%>

<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.LmLocations"%>
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
//        Transaction tr = ses.beginTransaction();
//        tr.commit();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        try {

%>  
<!--start Customer Profile 3--> 
<div class="row">
    <div class="col-sm-12">
        <h1 class="page-header"> Create New Customer</h1>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <div class="form-group mb-3">
                            <label>Customer Name</label>
                            <input type="text" class="form-control" id="fullName" placeholder="Full Name of Customer">
                        </div>
                        <div class="form-group mb-3">
                            <label>Address</label>
                            <input type="text" class="form-control" id="address" placeholder="Current Address of Customer">
                        </div>
                        <div class="form-group mb-3">
                            <label>Branch</label>
                            <select class="form-control default-select2" style="color: #000" id="loadBranches">
                                <option value="0" selected="">-- Select Branch --</option>
                                <%
                                    List<LmLocations> loadBranches = new com.it.locationManagementModel.LMS_LM_Locations().getAllLocationsByStatus(ses, STATIC_DATA_MODEL.PMDEACTIVE);
                                    if(!loadBranches.isEmpty()){
                                        for (LmLocations branch : loadBranches) {
                                %>
                                <option value="<%=branch.getId()%>"><%=branch.getLocationName()%></option>
                                <%}}%>
                            </select>
                        </div>
                        <div class="row mb-3">
                            <div class="form-group col-md-6">
                                <label>Mobile</label>
                                <input type="text" class="form-control" id="mobile" placeholder="Current Mobile Number">
                            </div>
                            <div class="form-group col-md-2" id="SNDOTPDIV">
                                <label></label><br>
                                <div id="SNDOTPBTN">
                                <button type="button" class="btn btn-primary" onclick="sendOTP()">Send OTP</button>
                                </div>
                            </div>
                            <div class="form-group col-md-4" id="RESNDOTPDIV" style="display: none">
                                <label></label><br>
                                <button type="button" class="btn btn-default" onclick="sendOTP()">Resend</button>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="form-group col-md-6">
                                <label>Enter OTP</label>
                                <input type="number" class="form-control" id="otpCode" placeholder="OTP the Customer Received">
                                <input type="hidden" id="isverify" value="0" disabled=""> 
                            </div>
                            <div class="form-group col-md-6" id="OTPVRFDIV" style="display: none" >
                                <label></label><br>
                                <div id="VROTPBTN">
                                <button type="button" class="btn btn-outline-success" onclick="verifyOTP()">Verify</button>
                                </div>
                            </div>
                        </div>
                        <div class="form-group mb-3">
                            <label>E-mail</label>
                            <input type="email" class="form-control" id="email" placeholder="Current Email Address">
                        </div>
                        <div class="form-group mb-3">
                            <label>NIC</label>
                            <input type="text" class="form-control" id="nic" placeholder="Current NIC Number">
                        </div>

                        <div class="row mb-3">
                            <label class="form-label col-form-label col-md-6"></label>
<!--                            <div class="col-md-3">
                                <button type="button" class="btn btn-outline-white" style="width: 100%" >View Activity</button>-->
                            </div>
                            <div class="col-md-3" id="ADDCUSTBTNDIV">
                                <button type="button" class="btn btn-green" style="width: 100%" onclick="addNewCustomer()">Save</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<!--end Customer Profile 3--> 
<script type="text/javascript">
    $(document).ready(function () {
        $(".default-select2").select2();  
    });
//      function for send otp
        function sendOTP(){
            var mobile = $("#mobile").val();
            if(mobile === ""){
                 swal("", "Enter Mobile Number", "warning");
            }else{
                 $.ajax({
                url: "customerManagement_sendOTP",
                type: "POST",
                data: "mobile=" + mobile,
                beforeSend: function (xhr) {
                    $('#SNDOTPBTN').empty();
                    $('#SNDOTPBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        
                        document.getElementById("SNDOTPDIV").style.display = "none";    
                        document.getElementById("RESNDOTPDIV").style.display = "block";    
                        document.getElementById("OTPVRFDIV").style.display = "block";    
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#SNDOTPBTN').empty();
                    $('#SNDOTPBTN').html("<button type='button' class='btn btn-primary' onclick='sendOTP()'>Send OTP</button>");
                },
                error: function (error) {
                }
            });
            }
        }
//      function for verify otp
        function verifyOTP(){
            var typedOtp = $("#otpCode").val();
            if(typedOtp === ""){
                 swal("", "Enter OTP Code", "warning");
            }else{
                 $.ajax({
                url: "customerManagement_verifyOTP",
                type: "POST",
                data: "typedOtp=" + typedOtp,
                beforeSend: function (xhr) {
                    $('#VROTPBTN').empty();
                    $('#VROTPBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        $("#isverify").val(1);
                        document.getElementById("SNDOTPDIV").style.display = "none";    
                        document.getElementById("RESNDOTPDIV").style.display = "none";    
                        document.getElementById("OTPVRFDIV").style.display = "none";    
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#VROTPBTN').empty();
                    $('#VROTPBTN').html("<button type='button' class='btn btn-outline-success' onclick='verifyOTP()'>verify</button>");
                },
                error: function (error) {
                }
            });
            }
        }
          //    function for add new Customer
    function addNewCustomer() {
        var fullName = $("#fullName").val();
        var address = $("#address").val();
        var loadBranches = $("#loadBranches option:selected").val();
        var mobile = $("#mobile").val();
        var otpCode = $("#otpCode").val();
        var isverify = $("#isverify").val();
        var email = $("#email").val();
        var nic = $("#nic").val();
        if (fullName === "") {
            swal("", "Enter Full Name", "warning");
        } else if (address === "") {
            swal("", "Enter Address", "warning");
        } else if (nic === "") {
            swal("", "Enter NIC", "warning");
        } else if (mobile === "") {
            swal("", "Enter Mobile Number", "warning");
        } else if (otpCode === "") {
            swal("", "Enter OTP Code", "warning");
        } else if (email === "") {
            swal("", "Enter Email", "warning");
        } else if (nic === "") {
            swal("", "Enter NIC", "warning");
        } else if (isverify === "0") {
            swal("", "Verify Mobile Number", "warning");
        } else {
            $.ajax({
                url: "customerManagement_addCustomer",
                type: "POST",
                data: "fullName=" + fullName + "&address=" + address + "&loadBranches=" + loadBranches + "&mobile=" + mobile + "&otpCode=" + otpCode + "&isverify=" + isverify + "&email=" + email
                + "&nic=" + nic + "&mode=" + "B",
                beforeSend: function (xhr) {
                    $('#ADDCUSTBTNDIV').empty();
                    $('#ADDCUSTBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    $('#ADDCUSTBTNDIV').empty();
                    $('#ADDCUSTBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addNewCustomer()'>Save</button>");
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