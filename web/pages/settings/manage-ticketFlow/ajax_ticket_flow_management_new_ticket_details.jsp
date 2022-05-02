<%-- 
    Document   : ajax_ticket_flow_management_new_ticket_details
    Created on : Jan 5, 2022, 3:08:00 PM
    Author     : buddh
--%>

<%@page import="org.json.JSONArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.ring.db.LmLocations"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.ring.db.QmQueue"%>
<%@page import="com.ring.db.UmCustomer"%>
<%@page import="com.ring.db.QmSubCategories"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.QmQueueHasUser"%>
<%@page import="com.ring.db.QmCategories"%>
<%@page import="java.util.List"%>
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
            JSONArray jArray = new JSONArray();
            List<UmUser> allusr = new com.ring.userManagementModel.UMS_UM_User().getAllUsersByStatusAndAsc(ses, STATIC_DATA_MODEL.PMACTIVE);
            if (!allusr.isEmpty()) {
                for (UmUser elem : allusr) {
                    jArray.put(elem.getFirstName() + " " + elem.getLastName());
                }

            }
//            System.out.println("jArray = " + jArray);
            int interfaceId = Integer.parseInt(request.getParameter("interfaceId"));
            int quIdToNewTicket = Integer.parseInt(request.getParameter("quIdToNewTicket"));
            int catForTicket = Integer.parseInt(request.getParameter("catForTicket"));
            int subForTicket = Integer.parseInt(request.getParameter("subForTicket"));
            QmCategories selectedCategory = null;
            QmSubCategories selectedSubCategory = null;
            if (catForTicket > 0) {
                selectedCategory = (QmCategories) ses.load(QmCategories.class, catForTicket);
            }
            if (subForTicket > 0) {
                selectedSubCategory = (QmSubCategories) ses.load(QmSubCategories.class, subForTicket);
            }
            QmQueue selectedQueueFT = (QmQueue) ses.load(QmQueue.class, quIdToNewTicket);
            if (selectedQueueFT != null) {
                String tickKey = new com.ring.configurationModel.KEY_GENERATOR().generateKey(6);
                Calendar c = Calendar.getInstance();
                int year = c.get(Calendar.YEAR);
                int month = c.get(Calendar.MONTH) + 1;
                String jj = year + "";
                String substring = jj.substring(Math.max(jj.length() - 2, 0));
                String finalKey = substring + "/" + month + "/" + tickKey;
%> 
<!--start new ticket--> 
<div class="row">
    <div class="col-sm-12">
        <h1 class="page-header"> New Ticket  &nbsp;&nbsp; <small style="font-size: 15px"> <%=finalKey%> </small> &nbsp;&nbsp;
            <div class="avatars">
                <span class="avatar">
                    <img src="${pageContext.request.contextPath}/ImageServlet/<%=logedUser.getRemark1()%>" class=" rounded-pill" />
                </span>
            </div>
        </h1>

        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <label>Assigned to </label>
                        <div class="avatars">
                            <span class="avatar">
                                <img src="${pageContext.request.contextPath}/ImageServlet/<%=logedUser.getRemark1()%>" class=" rounded-pill" />
                            </span>
                        </div>
                        <br><br>
                        <form method="POST" enctype="multipart/form-data" id="fileUploadForm">
                            <input type="hidden" id="ticketKey" name="ticketKey" value="<%=finalKey%>" >
                            <div class="form-group mb-3">
                                <label>Ticket Title</label>
                                <input type="hidden" class="form-control" id="queueIdToTicket" name="queueIdToTicket" value="<%=quIdToNewTicket%>">
                                <input type="text" class="form-control" id="ticketName" name="ticketName">
                            </div>
                            <div class="form-group mb-3">
                                <label>Category</label>
                                <select class=" default-select2" style="width: 100%" id="loadCategoryByQueueIdForNewTicket" name="loadCategoryByQueueIdForNewTicket" onchange="loadSubCategoryByCategoryForNewTicket(this.value)">
                                    <%
                                        if (selectedCategory != null) {
                                    %>
                                    <option value="<%=selectedCategory.getId()%>" selected=""><%=selectedCategory.getCategoryName()%></option>
                                    <%} else {%>
                                    <option value="0" selected="">-- Select One --</option>
                                    <%}%>
                                    <%                            List<QmCategories> loadCategoryForNewTickets = new com.ring.queueManagementModel.QMS_QM_Categories().getCategoryByQueueId(ses, quIdToNewTicket);
                                        if (!loadCategoryForNewTickets.isEmpty()) {
                                            for (QmCategories catByQueueToNewTicket : loadCategoryForNewTickets) {
                                    %>
                                    <option value="<%=catByQueueToNewTicket.getId()%>"><%=catByQueueToNewTicket.getCategoryName()%></option>
                                    <%}
                                        }%>
                                </select>
                            </div>
                            <div class="form-group mb-3"   id="loadSubCatForNewTicketDiv">
                                <label>Sub-Category</label>
                                <select class="default-select2" style="width: 100%" id="loadSubCategoryByCategoryIdForNewTicket" name="loadSubCategoryByCategoryIdForNewTicket">
                                    <%
                                        if (selectedSubCategory != null) {
                                    %>
                                    <option value="<%=selectedSubCategory.getId()%>" selected=""><%=selectedSubCategory.getSubCategoryName()%></option>
                                    <%} else if (selectedCategory != null) {%>
                                    <%
                                        if (selectedCategory != null) {
                                            List<QmSubCategories> subCatByCat = new com.ring.queueManagementModel.QMS_QM_Sub_Categories().getSubCategoryBYCategoryId(ses, selectedCategory.getId());
                                            if (!subCatByCat.isEmpty()) {
                                                for (QmSubCategories sCat : subCatByCat) {
//                                                    if (sCat.getId() != selectedSubCategory.getId()) {
                                    %>
                                    <option value="<%=sCat.getId()%>" selected=""><%=sCat.getSubCategoryName()%></option>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <option value="0" selected="">-- Select One --</option>
                                    <%}
                                        }%>
                                    <%} else {%>
                                    <option value="0" selected="">-- Select One --</option>
                                    <%}%>
                                </select>
                            </div>
                            <div class="form-group mb-3">
                                <label>Location</label>
                                <select class=" default-select2" style="width: 100%" id="loadLocationForNewTicket" name="loadLocationForNewTicket" onchange="loadUsersByLocation(this.value)">
                                    <option value="0" selected="">-- Select Location --</option>
                                    <%
                                        List<LmLocations> loadLocationForNewTickets = new com.ring.locationManagementModel.LMS_LM_Locations().getAllLocationsByStatus(ses, STATIC_DATA_MODEL.PMDEACTIVE);
                                        if (!loadLocationForNewTickets.isEmpty()) {
                                            for (LmLocations locations : loadLocationForNewTickets) {
                                    %>
                                    <option value="<%=locations.getId()%>"><%=locations.getLocationName()%></option>
                                    <%}
                                        }%>
                                </select>
                            </div>
                            <%
                                //                                check log user is in selected queu
                                QmQueueHasUser checkLogedUserInQueue = new com.ring.queueManagementModel.QMS_QM_Queue_Has_User().getUsersByQueueId(ses, quIdToNewTicket, logedUser.getId());
                                if (checkLogedUserInQueue != null) {
                            %>
                            <input type="hidden" id="checkUserInQueue" value="1">
                            <%} else {%>
                            <input type="hidden" id="checkUserInQueue" value="0">
                            <%}%>

                            <%
                                if (checkLogedUserInQueue != null) {
                            %>




                            <!--CCCCCC-->
                            <div class="mb-3">
                                <label class="form-label"<span class="fa fa-plus"></span>&nbsp;&nbsp;Add User to Ticket</label><br>
                                <!--<div id="myDIVQ" style="display: none">-->
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <label class="form-label">Select User</label>
                                        <select class="default-select2" style="color: #fff" id="userToTicket">
                                            <option selected="" value="0" style="color: #000">-- Select User --</option>
                                            <%
                                                List<UmUser> loadUsersToTicket = new com.ring.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                                if (!loadUsersToTicket.isEmpty()) {
                                                    for (UmUser elemT : loadUsersToTicket) {
                                            %>
                                            <option value="<%=elemT.getId()%>" style="color: #000"><%=elemT.getFirstName()%> <%=elemT.getLastName()%></option> 
                                            <%}
                                                }%>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label class="form-label"></label><br>
                                        <button type="button" class="btn btn-success" onclick="addUserDetailsToTableTicket()">Add</button>
                                    </div>
                                </div>
                                <!--</div>-->
                            </div>
                            <div class="form-group mb-3">
                                <label>Assigned Users</label>
                                <div class="table-responsive" id="USRDIV">
                                    <table class="table table-bordered table-striped" id="addUserToTicket">
                                        <thead>
                                            <tr>
                                                <th hidden="">Id</th>
                                                <th>Name</th>
                                                <th>Designation</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td hidden=""><%=logedUser.getId()%></td>
                                                <td><%=logedUser.getFirstName()%> <%=logedUser.getLastName()%></td>
                                                <td></td>
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>






                            <%}%>

                            <div class="form-group mb-3">
                                <input class="mb-2" type="checkbox" id="attachCustomerCheckbox" onClick="toggleCustomer()"/> Customer Related Issue
                                <div id="attachCustomer" class="hideDiv">
                                    <div class="row">
                                        <div class="col-xs-12 col-sm-10">
                                            <select class="default-select2" id="customerForTicket" name="customerForTicket">
                                                <option value="0" selected="">--Select Customer--</option>
                                                <%
                                                    List<UmCustomer> loadCustomersToTicket = new com.ring.customerManagementModel.CMS_UM_Customer().getAllCustomersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                                    if (!loadCustomersToTicket.isEmpty()) {
                                                        for (UmCustomer cus : loadCustomersToTicket) {
                                                %>
                                                <option value="<%=cus.getId()%>" ><%=cus.getCustomerName()%>|<%=cus.getMobileNumber()%></option>
                                                <%}
                                                    }%>
                                            </select>
                                        </div>
                                        <div class="col-xs-12 col-sm-2">
                                            <a class="btn btn-primary btn-warning" data-bs-toggle="modal" href="#modal-createCustomer">New</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group mb-3">
                                <div class="avatars">
                                    <span class="avatar">
                                        <img src="${pageContext.request.contextPath}/ImageServlet/<%=logedUser.getRemark1()%>" class=" rounded-pill" />
                                    </span>
                                </div> &nbsp;&nbsp;
                                <label style="font-size: 14px">Ticket Details</label>
                                <div class="summernote" name="ticketDetails" id="ticketDetails" style="color: #000000"></div>
                            </div>


                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <input type="file" class="form-control" id="ticketFiles" name="ticketFiles" multiple="multiple">
                                </div>
                                <label class="form-label col-form-label col-md-5"></label>
                                <div class="col-md-3" id="ADDTCKDIV">
                                    <button type="button" class="btn btn-green" style="width: 100%" onclick="addTicket()">Create Ticket</button>
                                </div>
                            </div>
                        </form>
                        <!-- #modal-createCustomer -->
                        <!--                        <div class="modal fade" id="modal-createCustomer">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h4 class="modal-title">Create New Customer</h4>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="row">
                                                                    <div class="col-sm-12">
                        
                        
                                                                        <div class="form-group mb-3">
                                                                            <label>Customer Name</label>
                                                                            <input type="text" class="form-control modalFormInput" id="fullName" placeholder="Full Name of Customer">
                                                                        </div>
                                                                        <div class="form-group mb-3">
                                                                            <label>Address</label>
                                                                            <input type="text" class="form-control" id="address" placeholder="Current Address of Customer">
                                                                        </div>
                                                                        <div class="form-group mb-3">
                                                                            <label>Branch</label>
                                                                            <select class="form-control default-select2" style="color: #000" id="loadBranches">
                                                                                <option value="0" selected="">-- Select Branch --</option>
                        
                                                                                <option value="0">branch</option>
                        
                                                                            </select>
                                                                        </div>
                                                                        <div class="row mb-3">
                                                                            <div class="form-group col-md-6">
                                                                                <label>Mobile</label>
                                                                                <input type="text" class="form-control" id="mobile" placeholder="Current Mobile Number">
                                                                            </div>
                                                                            <div class="form-group col-md-3" id="SNDOTPDIV">
                                                                                <label></label><br>
                                                                                <div id="SNDOTPBTN">
                                                                                    <button type="button" class="btn btn-primary" onclick="sendOTP2()">Send OTP</button>
                                                                                </div>
                                                                            </div>
                                                                            <div class="form-group col-md-4" id="RESNDOTPDIV" style="display: none">
                                                                                <label></label><br>
                                                                                <button type="button" class="btn btn-default" onclick="sendOTP2()">Resend</button>
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
                                                                                    <button type="button" class="btn btn-outline-success" onclick="verifyOTP2()">Verify</button>
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
                                                                                                        <div class="col-md-3">
                                                                                                            <button type="button" class="btn btn-outline-white" style="width: 100%" >View Activity</button>
                                                                        </div>
                                                                        <div class="col-md-3" id="ADDCUSTBTNDIV">
                                                                            <button type="button" class="btn btn-green" style="width: 100%" onclick="addNewCustomer2()">Save</button>
                                                                        </div>
                        
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <a href="javascript:;" class="btn btn-white" data-bs-dismiss="modal" id="CLSCUSBTN2">Close</a>
                                                                <a href="javascript:;" class="btn btn-success">Save</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>   -->

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--end new ticket-->
<%} else {%>
<h1>Queue Not Found</h1>
<%}%>



<script type="text/javascript">

    $(".default-select2").select2();
    $(".summernote").summernote({
        height: "150",
        color: "#000000",
        toolbar: [
            // [groupName, [list of button]]
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['fontsize', ['fontsize']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['height', ['height']]
        ]
    });



    function toggleCustomer() {
        var checkBox = document.getElementById("attachCustomerCheckbox");
        console.log(checkBox);

        let divElement = document.getElementById("attachCustomer");
        console.log(divElement);

        divElement.classList.toggle('hideDiv');
    }

    $(".summernote").summernote({
        height: "150",
        color: "#000000",
          hint: {
            mentions: <%=jArray%>,
            match: /\B@(\w*)$/,
            search: function (keyword, callback) {
                callback($.grep(this.mentions, function (item) {
                    return item.indexOf(keyword) == 0;
                }));
            },
            content: function (item) {
                return item;
            }
        }
    });
//    $(".summernote").summernote({
//        height: 100,
//        toolbar: false,
//        hint: {
//            mentions: <%=jArray%>,
//            match: /\B@(\w*)$/,
//            search: function (keyword, callback) {
//                callback($.grep(this.mentions, function (item) {
//                    return item.indexOf(keyword) == 0;
//                }));
//            },
//            content: function (item) {
//                return item;
//            }
//        }
//    });

    function loadSubCategoryByCategoryForNewTicket(catIdNewTicket) {
        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_new_ticket_details_load_Sub_category_by_category_id.jsp",
            type: "POST",
            data: "interfaceId=" + <%=interfaceId%> + "&catId=" + catIdNewTicket,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#loadSubCatForNewTicketDiv').html(data);
            }
        });
    }
    function loadUsersByLocation(locationId) {
        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_new_ticket_details_load_users_by_location_id.jsp",
            type: "POST",
            data: "interfaceId=" + <%=interfaceId%> + "&locationId=" + locationId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#USRDIV').html(data);
            }
        });
    }

    //    function for add users to ticket table
    function addUserDetailsToTableTicket() {
        if ($('#userToTicket option:selected').val() === "0") {
            swal("", "Select User", "warning");
        } else {
            var courseTable = document.getElementById("addUserToTicket");
            var rowCount = courseTable.rows.length;
            var duplicateData = true;
            for (var r = 1; r < rowCount; r++) {
                var userId = document.getElementById("addUserToTicket").rows[r].cells[0].innerText;
                if (userId === $('#userToTicket option:selected').val()) {
                    duplicateData = false;
                }
            }
//                UmUser uu =(UmUser)ses.load(UmUser.class, oo);
//                desig = uu.getPmUserRole().getUserRoleName();
            if (duplicateData) {
                var row = courseTable.insertRow(1);
                $('#addUserToTicket > tbody:last').append(row);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(1);
                var cell3 = row.insertCell(2);
                var cell4 = row.insertCell(3);
                cell1.innerHTML = $('#userToTicket option:selected').val();
                cell1.style.display = "none";
                cell2.innerHTML = $('#userToTicket option:selected').text();
                cell3.innerHTML = "";
                cell4.innerHTML = "<button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>";
            } else {
                swal("Stop", "Detail Already added ...!!!!!!", "warning");
            }
        }
    }

    //    function for add new Ticket
    function addTicket() {
//        var ticketKey = $("#ticketKey").val();
//        alert(ticketKey);
        var ticketName = $("#ticketName").val();
        var loadCategoryByQueueIdForNewTicket = $("#loadCategoryByQueueIdForNewTicket option:selected").val();
        var loadSubCategoryByCategoryIdForNewTicket = $("#loadSubCategoryByCategoryIdForNewTicket option:selected").val();
//        var checkUserInQueue = $("#checkUserInQueue").val();
        var ticketD = $('#ticketDetails').summernote('code');
//        alert(loadSubCategoryByCategoryIdForNewTicket);
//        alert(ticketDetails);
//        var encodedString = encodeURI(ticketD);
//        alert(encodedString);
        if (ticketName === "") {
            swal("", "Enter Ticket Name", "warning");
//        } else if (loadCategoryByQueueIdForNewTicket === "0") {
//            swal("", "Select Category", "warning");
//        } else if (loadSubCategoryByCategoryIdForNewTicket === "0") {
//            swal("", "Select Sub Category", "warning");
        } else {
            event.preventDefault();
            // Get form
            var form = $('#fileUploadForm')[0];
            // Create an FormData object 
            var data = new FormData(form);
//            alert(ticketD);
            var encodedString = encodeURIComponent(ticketD);
//            alert(encodedString);
            // If you want to add an extra field for the FormData
            data.append("encodedString", encodedString);
            // disabled the submit button
//        $("#btnSubmit").prop("disabled", true);
            var checkUserInQueue = $("#checkUserInQueue").val();
            var ac = {AC: []};
            if (checkUserInQueue === "1") {
                var tb1 = document.getElementById('addUserToTicket');
                var rowCount = tb1.rows.length;
                var newRows = 0;
                var go = 0;
                for (var t = 1; t < rowCount; t++) {
                    var userId = document.getElementById("addUserToTicket").rows[t].cells[0].innerText;
                    if (userId === "" || userId === "0") {
                    } else {
                        go++;
                        ac.AC.push({"userId": userId});
                        newRows++;
                    }
                }
            }
            var usersDetails = JSON.stringify(ac);

            data.append("usersDetails", usersDetails);



            $.ajax({
                type: "POST",
//                enctype: 'multipart/form-data',
                url: "ticketManagement_addTicket",
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                beforeSend: function (xhr) {
                    $('#ADDTCKDIV').empty();
                    $('#ADDTCKDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
                },
                success: function (data) {
                    var resultValue = JSON.parse(data);
                    if (resultValue.result === "0") {
                        swal("", resultValue.displayMessage, "error");
                        $('#ADDTCKDIV').empty();
                        $('#ADDTCKDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addTicket()'>Create Ticket</button>");
                    } else if (resultValue.result === "2") {
                        swal("", resultValue.displayMessage, "error");
                        setTimeout(function () {
                            window.location.href = "../../../index.jsp";
                        }, 2000);
                    } else if (resultValue.result === "1") {
                        var message = resultValue.displayMessage;
//                        var splitMessage = message.split("|");
//                        var ticketId = splitMessage[1];
//                          var resultMessage = splitMessage[0];
//                        alert(ticketId);
//                        addUsersToTicket(ticketId);
                        loadTicketPage('pages/settings/manage-ticketFlow/ticketFlow_management.jsp', 7,<%=quIdToNewTicket%>,<%=catForTicket%>,<%=subForTicket%>, '${pageContext.request.contextPath}/ImageServlet/<%=selectedQueueFT.getBackgroundImage()%>')
                                                swal({
                                                    title: "Done",
                                                    text: resultValue.displayMessage,
                                                    timer: 1000,
                                                    showConfirmButton: false
                                                });
                                            }

                                        },
                                        error: function (e) {
                                            $("#result").text(e.responseText);
                                            console.log("ERROR : ", e);
                                            $("#btnSubmit").prop("disabled", false);
                                        }
                                    });
                                }
                            }

//    function addUsersToTicket(ticketId) {
//        var checkUserInQueue = $("#checkUserInQueue").val();
//        var ac = {AC: []};
//        if (checkUserInQueue === "1") {
//            var tb1 = document.getElementById('addUserToTicket');
//            var rowCount = tb1.rows.length;
//            var newRows = 0;
//            var go = 0;
//            for (var t = 1; t < rowCount; t++) {
//                var userId = document.getElementById("addUserToTicket").rows[t].cells[0].innerText;
//                if (userId === "" || userId === "0") {
//                } else {
//                    go++;
//                    ac.AC.push({"userId": userId});
//                    newRows++;
//                }
//            }
//        }
//        var usersDetails = JSON.stringify(ac);
//        alert(usersDetails);
//        $.ajax({
//            url: "ticketManagement_addUsersToTicket",
//            type: "POST",
//            data: "usersDetails=" + usersDetails + "&ticketId=" + ticketId,
//            beforeSend: function (xhr) {
//            },
//            success: function (data) {
//                var resultValue = JSON.parse(data);
//                if (resultValue.result === "0") {
//                    swal("", resultValue.displayMessage, "error");
//                    $('#ADDTCKDIV').empty();
//                    $('#ADDTCKDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addTicket()'>Create Ticket</button>");
//                } else if (resultValue.result === "2") {
//                    swal("", resultValue.displayMessage, "error");
//                    setTimeout(function () {
//                        window.location.href = "../../../index.jsp";
//                    }, 2000);
//                } else if (resultValue.result === "1") {
////                    location.reload();
//                    loadTicketPage('pages/settings/manage-ticketFlow/ticketFlow_management.jsp', 7,<%=quIdToNewTicket%>,<%=catForTicket%>,<%=subForTicket%>, '${pageContext.request.contextPath}/ImageServlet/<%=selectedQueueFT.getBackgroundImage()%>')
//                                        swal({
//                                            title: "Done",
//                                            text: resultValue.displayMessage,
//                                            timer: 1000,
//                                            showConfirmButton: false
//                                        });
//                                    }
//                                },
//                                error: function (error) {
//                                }
//                            });
//
//                        }

                            //      function for send otp
                            function sendOTP2() {
                                var mobile = $("#mobile").val();
                                if (mobile === "") {
                                    swal("", "Enter Mobile Number", "warning");
                                } else {
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
                                            $('#SNDOTPBTN').html("<button type='button' class='btn btn-primary' onclick='sendOTP2()'>Send OTP</button>");
                                        },
                                        error: function (error) {
                                        }
                                    });
                                }
                            }
////      function for verify otp
//                        function verifyOTP2() {
//                            var typedOtp = $("#otpCode").val();
//                            if (typedOtp === "") {
//                                swal("", "Enter OTP Code", "warning");
//                            } else {
//                                $.ajax({
//                                    url: "customerManagement_verifyOTP",
//                                    type: "POST",
//                                    data: "typedOtp=" + typedOtp,
//                                    beforeSend: function (xhr) {
//                                        $('#VROTPBTN').empty();
//                                        $('#VROTPBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
//                                    },
//                                    success: function (data) {
//                                        var resultValue = JSON.parse(data);
//                                        if (resultValue.result === "0") {
//                                            swal("", resultValue.displayMessage, "error");
//                                        } else if (resultValue.result === "2") {
//                                            swal("", resultValue.displayMessage, "error");
//                                            setTimeout(function () {
//                                                window.location.href = "../../../index.jsp";
//                                            }, 2000);
//                                        } else if (resultValue.result === "1") {
//                                            $("#isverify").val(1);
//                                            document.getElementById("SNDOTPDIV").style.display = "none";
//                                            document.getElementById("RESNDOTPDIV").style.display = "none";
//                                            document.getElementById("OTPVRFDIV").style.display = "none";
//                                            swal({
//                                                title: "Done",
//                                                text: resultValue.displayMessage,
//                                                timer: 1000,
//                                                showConfirmButton: false
//                                            });
//                                        }
//                                        $('#VROTPBTN').empty();
//                                        $('#VROTPBTN').html("<button type='button' class='btn btn-outline-success' onclick='verifyOTP2()'>verify</button>");
//                                    },
//                                    error: function (error) {
//                                    }
//                                });
//                            }
//                        }
//                        //    function for add new Customer
//                        function addNewCustomer2() {
//                            var fullName = $("#fullName").val();
//                            var address = $("#address").val();
//                            var loadBranches = $("#loadBranches option:selected").val();
//                            var mobile = $("#mobile").val();
//                            var otpCode = $("#otpCode").val();
//                            var isverify = $("#isverify").val();
//                            var email = $("#email").val();
//                            var nic = $("#nic").val();
//                            if (fullName === "") {
//                                swal("", "Enter Full Name", "warning");
//                            } else if (address === "") {
//                                swal("", "Enter Address", "warning");
//                            } else if (nic === "") {
//                                swal("", "Enter NIC", "warning");
//                            } else if (mobile === "") {
//                                swal("", "Enter Mobile Number", "warning");
//                            } else if (otpCode === "") {
//                                swal("", "Enter OTP Code", "warning");
//                            } else if (email === "") {
//                                swal("", "Enter Email", "warning");
//                            } else if (nic === "") {
//                                swal("", "Enter NIC", "warning");
//                            } else if (isverify === "0") {
//                                swal("", "Verify Mobile Number", "warning");
//                            } else {
//                                $.ajax({
//                                    url: "customerManagement_addCustomer",
//                                    type: "POST",
//                                    data: "fullName=" + fullName + "&address=" + address + "&loadBranches=" + loadBranches + "&mobile=" + mobile + "&otpCode=" + otpCode + "&isverify=" + isverify + "&email=" + email
//                                            + "&nic=" + nic + "&mode=" + "B",
//                                    beforeSend: function (xhr) {
//                                        $('#ADDCUSTBTNDIV').empty();
//                                        $('#ADDCUSTBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
//                                    },
//                                    success: function (data) {
//                                        var resultValue = JSON.parse(data);
//                                        if (resultValue.result === "0") {
//                                            swal("", resultValue.displayMessage, "error");
//                                        } else if (resultValue.result === "2") {
//                                            swal("", resultValue.displayMessage, "error");
//                                            setTimeout(function () {
//                                                window.location.href = "../../../index.jsp";
//                                            }, 2000);
//                                        } else if (resultValue.result === "1") {
//                                            var message = resultValue.displayMessage;
//                                            var splitMessage = message.split("|");
//                                            var crid = splitMessage[1];
//                                            var crName = splitMessage[2];
//                                            var resultMessage = splitMessage[0];
////                                            location.reload();
//                                            var newCust = document.getElementById("customerForTicket");
//                                            var option1;
//                                            option1 = document.createElement("option");
//                                            option1.value = crid;
//                                            option1.text = crName;
//                                            newCust.add(option1);
//                                            swal({
//                                                title: "Done",
//                                                text: resultMessage,
//                                                timer: 1000,
//                                                showConfirmButton: false
//                                            });
//                                             $("#CLSCUSBTN2").trigger("click");
//                                        }
//                                        $('#ADDCUSTBTNDIV').empty();
//                                        $('#ADDCUSTBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addNewCustomer2()'>Save</button>");
//                                    },
//                                    error: function (error) {
//                                    }
//                                });
//                            }
//                        }


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