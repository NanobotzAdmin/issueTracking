<%-- 
    Document   : ajax_queues_management_manage_queue_details
    Created on : Dec 10, 2021, 2:38:59 AM
    Author     : JOY
--%>

<%@page import="com.it.db.QmQueueIcons"%>
<%@page import="com.it.db.QmQueueHasUser"%>
<%@page import="com.it.db.QmQueue"%>
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
            QmQueue selectedQueue = (QmQueue) ses.load(QmQueue.class, Integer.parseInt(request.getParameter("queId")));
            if (selectedQueue != null) {
%>           
<!--start queue details-->
<div class="row">
    <div class="col-sm-12">
        <h1 class="page-header"> Queue Details</h1>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <form method="POST" enctype="multipart/form-data" id="queueImageUpdate">
                            <div class="form-group mb-3">
                                <label>Queue Name</label>
                                <input type="text" class="form-control" id="queueNameU" name="queueNameU" value="<%=selectedQueue.getQueueName()%>">
                                <input type="hidden" class="form-control" id="queueIdU" name="queueIdU" value="<%=selectedQueue.getId()%>">
                            </div>
                            <div class="form-group mb-3">
                                <label>Short Description</label>
                                <input type="text" class="form-control" id="queueDescriptionU" name="queueDescriptionU" value="<%=selectedQueue.getDescription()%>">
                            </div>
                            <div class="form-group mb-3">
                                <input type="file" class="form-control" id="queueImageUpdate" name="queueImageUpdate" >
                            </div>
                            <div class="form-group ">
                                <label class="form-label">Select Icon</label>
                                <div class="d-flex flex-wrap">
                                    <div class="pe-1">
                                        <select class="form-control default-select2" style="color: #fff" id="queueiconU" name="queueiconU" onchange="changeIconU(this.value)">
                                            <option selected="" value="0" style="color: #000" >-- Select Icon --</option>
                                            <%
                                                List<QmQueueIcons> icons = new com.it.queueManagementModel.QMS_QM_Queue().getIcons(ses);
                                                if (!icons.isEmpty()) {
                                                    for (QmQueueIcons elem : icons) {

                                            %>
                                            <option value="<%=elem.getIconCode()%>" style="color: #000"><%=elem.getIconName()%></option>
                                            <%}
                                                }%>
                                        </select>
                                    </div>
                                    <div class="pe-1">
                                        <div class="" id="mainIconViewU"></div>
                                    </div>
                                    <div class="pe-1">
                                        <input type="color" id="favcolor" name="favcolor" value="<%=selectedQueue.getQueueColor()%>">
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label" onclick="myFunctionQU()"><span class="fa fa-plus"></span>&nbsp;&nbsp;Assign User</label><br>
                                <div id="myDIVQU" style="display: none">
                                    <div class="row">
                                        <div class="form-group col-md-6">
                                            <label class="form-label">Select User</label>
                                            <select class="form-control default-select2" style="color: #fff" id="userToQueueU">
                                                <option selected="" value="0" style="color: #000">-- Select User --</option>
                                                <%
                                                    List<UmUser> loadUsersToQueueU = new com.it.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                                    if (!loadUsersToQueueU.isEmpty()) {
                                                        for (UmUser elemQU : loadUsersToQueueU) {
                                                %>
                                                <option value="<%=elemQU.getId()%>" style="color: #000"><%=elemQU.getFirstName()%> <%=elemQU.getLastName()%></option> 
                                                <%}
                                                    }%>
                                            </select>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label class="form-label"></label><br>
                                            <div id="ADDUSRTOQUEUPDBTN"><button type="button" class="btn btn-success" onclick="addUserToQueueUpdate()">Add</button></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group mb-3">
                                <label>Assigned Users</label>
                                <div class="table-responsive">
                                    <table class="table table-bordered table-striped" id="addUserToQueueU">
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
                                                List<QmQueueHasUser> loadQueueHasUsers = new com.it.queueManagementModel.QMS_QM_Queue_Has_User().getAllUsersByLocationId(ses, selectedQueue.getId());
                                                if (!loadQueueHasUsers.isEmpty()) {
                                                    for (QmQueueHasUser userByQueuen : loadQueueHasUsers) {
                                            %>
                                            <tr>
                                                <td><%=userByQueuen.getUmUser().getId()%></td>
                                                <td><%=userByQueuen.getUmUser().getFirstName()%> <%=userByQueuen.getUmUser().getLastName()%></td>
                                                <td></td>
                                                <td>
                                                    <button type="button" class="btn btn-sm btn-danger" value="Remove"  onclick="removeUserFromQueue('<%=userByQueuen.getUmUser().getId()%>', '<%=userByQueuen.getQmQueue().getId()%>')"><span class='fa fa-remove'>Remove</span></button>
                                                </td>
                                            </tr>
                                            <%}
                                                }%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="form-label col-form-label col-md-9"></label>
                                <div class="col-md-3" id="UPDQUBTNDIV">
                                    <button type="button" class="btn btn-green btn-sm" style="width: 100%" onclick="updateQueue()">Save Changes</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--end queue details-->
<%}%>
<script>
    $(".default-select2").select2();
    
    function myFunctionQU() {
        var x = document.getElementById("myDIVQU");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    }
//    //    function for add users to queue table
//    function addUserDetailsToTableQU() {
//        if ($('#userToQueueU option:selected').val() === "0") {
//            swal("", "Select User", "warning");
//        } else {
//            var courseTable = document.getElementById("addUserToQueueU");
//            var rowCount = courseTable.rows.length;
//            var duplicateData = true;
//            for (var r = 1; r < rowCount; r++) {
//                var userId = document.getElementById("addUserToQueueU").rows[r].cells[0].innerText;
//                if (userId === $('#userToQueueU option:selected').val()) {
//                    duplicateData = false;
//                }
//            }
////                UmUser uu =(UmUser)ses.load(UmUser.class, oo);
////                desig = uu.getPmUserRole().getUserRoleName();
//            if (duplicateData) {
//                var row = courseTable.insertRow(1);
//                $('#addUserToQueueU > tbody:last').append(row);
//                var cell1 = row.insertCell(0);
//                var cell2 = row.insertCell(1);
//                var cell3 = row.insertCell(2);
//                var cell4 = row.insertCell(3);
//                cell1.innerHTML = $('#userToQueueU option:selected').val();
//                cell2.innerHTML = $('#userToQueueU option:selected').text();
//                cell3.innerHTML = "";
//                cell4.innerHTML = "<button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>";
//            } else {
//                swal("Stop", "Detail Already added ...!!!!!!", "warning");
//            }
//        }
//    }
    //    function for update Queue
    function updateQueue() {
        var queueNameU = $("#queueNameU").val();
        var queueDescriptionU = $("#queueDescriptionU").val();
        var queueIdU = $("#queueIdU").val();
        if (queueNameU === "") {
            swal("", "Enter Queue Name", "warning");
        } else if (queueDescriptionU === "") {
            swal("", "Enter Queue Description", "warning");
        } else {
            event.preventDefault();
            // Get form
            var form = $('#queueImageUpdate')[0];
            // Create an FormData object 
            var data = new FormData(form);
            // If you want to add an extra field for the FormData
            data.append("CustomField", "This is some extra data, testing");
            $.ajax({
                type: "POST",
                enctype: 'multipart/form-data',
                url: "queueManagement_updateQueue",
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                beforeSend: function (xhr) {
                    $('#UPDQUBTNDIV').empty();
                    $('#UPDQUBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
//                         loadPage('<%=gg%>',<%=pid%>)
                        loadQueueDetailsToManage(<%=selectedQueue.getId()%>,<%=pid%>, '<%=gg%>');
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#UPDQUBTNDIV').empty();
                    $('#UPDQUBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='updateQueue()'>Save Changes</button>");
                },
                error: function (error) {
                }
            });
        }
    }

    //    function for add users to queue update
    function addUserToQueueUpdate() {
        var user = $('#userToQueueU option:selected').val();
        if (user === "0") {
            swal("", "Select User", "warning");
        } else {
            $.ajax({
                url: "queueManagement_addUsersToQueueUpdate",
                type: "POST",
                data: "user=" + user + "&queueId=" + <%=selectedQueue.getId()%>,
                beforeSend: function (xhr) {
                    $('#ADDUSRTOQUEUPDBTN').empty();
                    $('#ADDUSRTOQUEUPDBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        loadQueueDetailsToManage(<%=selectedQueue.getId()%>,<%=pid%>, '<%=gg%>');
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#ADDUSRTOQUEUPDBTN').empty();
                    $('#ADDUSRTOQUEUPDBTN').html("<label></label><br><button type='button' class='btn btn-success' onclick='addUserToQueueUpdate()'>Add</button>");
                },
                error: function (error) {
                }
            });
        }
    }
    //    function for add users to queue update
    function removeUserFromQueue(userId, queueId) {
        alert(userId);
        alert(queueId);
        $.ajax({
            url: "queueManagement_removeUsersFromQueueUpdate",
            type: "POST",
            data: "user=" + userId + "&queueId=" + queueId,
            beforeSend: function (xhr) {
//                    $('#ADDUSRTOQUEUPDBTN').empty();
//                    $('#ADDUSRTOQUEUPDBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                    loadQueueDetailsToManage(<%=selectedQueue.getId()%>,<%=pid%>, '<%=gg%>');
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
//                    $('#ADDUSRTOQUEUPDBTN').empty();
//                    $('#ADDUSRTOQUEUPDBTN').html("<label></label><br><button type='button' class='btn btn-success' onclick='addUserToQueueUpdate()'>Add</button>");
            },
            error: function (error) {
            }
        });

    }
    function changeIconU(valueU) {
//        alert(value);
        document.getElementById("mainIconViewU").className = "" + valueU;
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
