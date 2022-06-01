<%-- 
    Document   : ajax_customer _management_manage_customer_details
    Created on : Jan 5, 2022, 1:04:32 AM
    Author     : JOY
--%>

<%@page import="com.it.db.UmCustomer"%>
<%@page import="com.it.db.LmLocations"%>
<%@page import="java.util.List"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
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
            UmCustomer selectedCustomer = (UmCustomer) ses.load(UmCustomer.class, Integer.parseInt(request.getParameter("id")));
            if (selectedCustomer != null) {
%>
<div class="row">
    <div class="col-sm-12">
        <h1 class="page-header"> Manage Customer</h1>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <div class="form-group mb-3">
                            <label>Customer Name</label>
                            <input type="text" class="form-control" id="fullNameU" value="<%=selectedCustomer.getCustomerName()%>" >
                        </div>
                        <div class="form-group mb-3">
                            <label>Address</label>
                            <input type="text" class="form-control" id="addressU" value="<%=selectedCustomer.getAddress()%>">
                        </div>
                        <div class="form-group mb-3">
                            <label>Branch</label>
                            <select class="form-control default-select2" style="color: #000" id="loadBranchesU">
                                <%
                                    if (selectedCustomer.getLmLocations() != null) {
                                %>
                                <option value="<%=selectedCustomer.getLmLocations().getId()%>" selected=""><%=selectedCustomer.getLmLocations().getLocationName()%></option>
                                <%} else {%>
                                <option value="0" selected="">-- Select Branch --</option>
                                <%}%>
                                <%
                                    List<LmLocations> loadBranchesU = new com.it.locationManagementModel.LMS_LM_Locations().getAllLocationsByStatus(ses, STATIC_DATA_MODEL.PMDEACTIVE);
                                    if (!loadBranchesU.isEmpty()) {
                                        for (LmLocations branchU : loadBranchesU) {
                                %>
                                <option value="<%=branchU.getId()%>"><%=branchU.getLocationName()%></option>
                                <%}
                                    }%>
                            </select>
                        </div>
                        <div class="row mb-3">
                            <div class="form-group col-md-6">
                                <label>Mobile</label>
                                <input type="text" class="form-control" id="mobileU" value="<%=selectedCustomer.getMobileNumber()%>">
                            </div>
                            <div class="form-group col-md-2" id="SNDOTPDIVU">
                                <label></label><br>
                                <div id="SNDOTPBTNU">
                                    <button type="button" class="btn btn-primary" onclick="sendOTPU()">Send OTP</button>
                                </div>
                            </div>
                            <div class="form-group col-md-4" id="RESNDOTPDIVU" style="display: none">
                                <label></label><br>
                                <button type="button" class="btn btn-default" onclick="sendOTPU()">Resend</button>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="form-group col-md-6">
                                <label>Enter OTP</label>
                                <input type="number" class="form-control" id="otpCodeU">
                                <input type="hidden" id="isverifyU" value="0" disabled=""> 
                            </div>
                            <div class="form-group col-md-6" id="OTPVRFDIVU" style="display: none" >
                                <label></label><br>
                                <div id="VROTPBTNU">
                                    <button type="button" class="btn btn-outline-success" onclick="verifyOTPU()">Verify</button>
                                </div>
                            </div>
                        </div>
                        <div class="form-group mb-3">
                            <label>E-mail</label>
                            <input type="email" class="form-control" id="emailU" value="<%=selectedCustomer.getEmailAddress()%>">
                        </div>
                        <div class="form-group mb-3">
                            <label>NIC</label>
                            <input type="text" class="form-control" id="nicU" value="<%=selectedCustomer.getNic()%>">
                        </div>

                        <div class="row mb-3">
                            <label class="form-label col-form-label col-md-6"></label>
                            <!--                            <div class="col-md-3">
                                                            <button type="button" class="btn btn-outline-white" style="width: 100%" >View Activity</button>-->
                        </div>
                        <div class="col-md-3" id="ADDCUSTBTNDIVU">
                            <button type="button" class="btn btn-green" style="width: 100%" onclick="updateCustomer()">Save changes</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $(".default-select2").select2();
    });
    //      function for send otp
        function sendOTPU(){
            var mobile = $("#mobileU").val();
            if(mobile === ""){
                 swal("", "Enter Mobile Number", "warning");
            }else{
                 $.ajax({
                url: "customerManagement_sendOTP",
                type: "POST",
                data: "mobile=" + mobile,
                beforeSend: function (xhr) {
                    $('#SNDOTPBTNU').empty();
                    $('#SNDOTPBTNU').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        
                        document.getElementById("SNDOTPDIVU").style.display = "none";    
                        document.getElementById("RESNDOTPDIVU").style.display = "block";    
                        document.getElementById("OTPVRFDIVU").style.display = "block";    
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#SNDOTPBTNU').empty();
                    $('#SNDOTPBTNU').html("<button type='button' class='btn btn-primary' onclick='sendOTPU()'>Send OTP</button>");
                },
                error: function (error) {
                }
            });
            }
        }
    //      function for verify otp
        function verifyOTPU(){
            var typedOtp = $("#otpCodeU").val();
            if(typedOtp === ""){
                 swal("", "Enter OTP Code", "warning");
            }else{
                 $.ajax({
                url: "customerManagement_verifyOTP",
                type: "POST",
                data: "typedOtp=" + typedOtp,
                beforeSend: function (xhr) {
                    $('#VROTPBTNU').empty();
                    $('#VROTPBTNU').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        $("#isverifyU").val(1);
                        document.getElementById("SNDOTPDIVU").style.display = "none";    
                        document.getElementById("RESNDOTPDIVU").style.display = "none";    
                        document.getElementById("OTPVRFDIVU").style.display = "none";    
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#VROTPBTNU').empty();
                    $('#VROTPBTNU').html("<button type='button' class='btn btn-outline-success' onclick='verifyOTP()'>verify</button>");
                },
                error: function (error) {
                }
            });
            }
        }
        //    function for update Customer
    function updateCustomer() {
        var fullNameU = $("#fullNameU").val();
        var addressU = $("#addressU").val();
        var loadBranchesU = $("#loadBranchesU option:selected").val();
        var mobileU = $("#mobileU").val();
        var otpCodeU = $("#otpCodeU").val();
        var isverifyU = $("#isverifyU").val();
        var emailU = $("#emailU").val();
        var nicU = $("#nicU").val();
        if (fullNameU === "") {
            swal("", "Enter Full Name", "warning");
        } else if (addressU === "") {
            swal("", "Enter Address", "warning");
        } else if (nicU === "") {
            swal("", "Enter NIC", "warning");
        } else if (mobileU === "") {
            swal("", "Enter Mobile Number", "warning");
        } else if (otpCodeU === "") {
            swal("", "Enter OTP Code", "warning");
        } else if (emailU === "") {
            swal("", "Enter Email", "warning");
        } else if (nicU === "") {
            swal("", "Enter NIC", "warning");
        } else if (isverifyU === "0") {
            swal("", "Verify Mobile Number", "warning");
        } else {
            $.ajax({
                url: "customerManagement_updateCustomer",
                type: "POST",
                data: "fullNameU=" + fullNameU + "&addressU=" + addressU + "&loadBranchesU=" + loadBranchesU + "&mobileU=" + mobileU + "&otpCodeU=" + otpCodeU + "&isverifyU=" + isverifyU + "&emailU=" + emailU
                + "&nicU=" + nicU + "&custId=" + <%=selectedCustomer.getId()%>,
                beforeSend: function (xhr) {
                    $('#ADDCUSTBTNDIVU').empty();
                    $('#ADDCUSTBTNDIVU').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                       loadCustomer(<%=selectedCustomer.getId()%>);
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#ADDCUSTBTNDIVU').empty();
                    $('#ADDCUSTBTNDIVU').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='updateCustomer()'>Save Changes</button>");
                },
                error: function (error) {
                }
            });
        }
    }
    
</script>                  
<%}%>                             
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
