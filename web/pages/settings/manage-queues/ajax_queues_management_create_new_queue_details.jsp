<%-- 
    Document   : ajax_queues_management_create_new_queue_details
    Created on : Dec 10, 2021, 2:33:36 AM
    Author     : JOY
--%>

<%@page import="com.ring.db.QmQueueIcons"%>
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
<!--start new queue-->
<div class="row">
    <div class="col-sm-12">
        <h1 class="page-header">New Queue</h1>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <form method="POST" enctype="multipart/form-data" id="fileUploadForm">
                    <div class="card">
                        <div class="card-body">
                            <div class="form-group mb-3">
                                <label>Queue Name</label>
                                <input type="text" class="form-control" id="queueName" name="queueName">
                            </div>
                            <div class="form-group mb-3">
                                <label>Short Description</label>
                                <input type="text" class="form-control" id="queueDescription" name="queueDescription">
                            </div>
                            <div class="form-group mb-3">
                                <label>Background Image</label>
                                <input type="file" class="form-control" id="queueBGImg" name="queueBGImg" >
                            </div>

                            <!--Queue customize start-->
                            <div class="form-group  ">
                                <label class="form-label">Select Icon</label>

                                <div class="d-flex flex-wrap">
                                    <div class="pe-1">
                                        <select class="form-control default-select2" style="color: #fff" id="queueicon" name="queueicon" onchange="changeIcon(this.value)">
                                            <option selected="" value="0" style="color: #000" >-- Select Icon --</option>
                                            <%                                        List<QmQueueIcons> icons = new com.ring.queueManagementModel.QMS_QM_Queue().getIcons(ses);
                                                if (!icons.isEmpty()) {
                                                    for (QmQueueIcons elem : icons) {

                                            %>
                                            <option value="<%=elem.getIconCode()%>" style="color: #000"><%=elem.getIconName()%></option>
                                            <%}
                                                }%>
                                            <!--                                    <option value="fas fa-arrow-alt-circle-right" style="color: #000">Check1</option>
                                                                                <option value="fas fa-arrow-alt-circle-right fa-rotate-90" style="color: #000">Check2</option>
                                                                                <option value="fas fa-arrow-alt-circle-right fa-rotate-180" style="color: #000">Check3</option>
                                                                                <option value="fas fa-arrow-alt-circle-right fa-rotate-270" style="color: #000">Check4</option>
                                                                                <option value="fas fa-arrow-alt-circle-right fa-flip-horizontal" style="color: #000">Check5</option>
                                                                                <option value="fas fa-arrow-alt-circle-right fa-flip-vertical" style="color: #000">Check6</option>-->
                                        </select>
                                    </div>
                                    <div class="pe-1">
                                        <div class="" id="mainIconView"></div>
                                    </div>
                                    <div class="pe-1">
                                        <input type="color" id="favcolor" name="favcolor" id="favcolor" value="#ff0000">
                                    </div>
                                </div>

                            </div>





                        </div>
                        <!--customization end-->

                    </div> 
                    <div class="mb-3">
                        <label class="form-label" onclick="myFunctionQ()"><span class="fa fa-plus"></span>&nbsp;&nbsp;Assign User</label><br>
                        <div id="myDIVQ" style="display: none">
                            <div class="row">
                                <div class="form-group col-md-6">
                                    <label class="form-label">Select User</label>
                                    <select class="form-control default-select2" style="color: #fff" id="userToQueue">
                                        <option selected="" value="0" style="color: #000">-- Select User --</option>
                                        <%                                                List<UmUser> loadUsersToQueue = new com.ring.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                            if (!loadUsersToQueue.isEmpty()) {
                                                for (UmUser elemQ : loadUsersToQueue) {
                                        %>
                                        <option value="<%=elemQ.getId()%>" style="color: #000"><%=elemQ.getFirstName()%> <%=elemQ.getLastName()%></option> 
                                        <%}
                                            }%>
                                    </select>
                                </div>
                                <div class="form-group col-md-6">
                                    <label class="form-label"></label><br>
                                    <button type="button" class="btn btn-success" onclick="addUserDetailsToTableQ()">Add</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group mb-3">
                        <label>Assigned Users</label>
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped" id="addUserToQueue">
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
                        <div class="col-xs-12 col-sm-4" id="ADDQUEBTNDIV">
                            <button type="button" class="btn btn-green btn-sm" style="width: 100%" onclick="addQueue()">Save Changes</button>
                        </div>
                    </div>
            </div>
        </div>
        </form>
    </div>
</div>
</div>
</div>
<!--end new queue-->

<script>
    $(".default-select2").select2();

    function myFunctionQ() {
        var x = document.getElementById("myDIVQ");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
        }
    }
//    function for add users to queue table
    function addUserDetailsToTableQ() {
        if ($('#userToQueue option:selected').val() === "0") {
            swal("", "Select User", "warning");
        } else {
            var courseTable = document.getElementById("addUserToQueue");
            var rowCount = courseTable.rows.length;
            var duplicateData = true;
            for (var r = 1; r < rowCount; r++) {
                var userId = document.getElementById("addUserToQueue").rows[r].cells[0].innerText;
                if (userId === $('#userToQueue option:selected').val()) {
                    duplicateData = false;
                }
            }
//                UmUser uu =(UmUser)ses.load(UmUser.class, oo);
//                desig = uu.getPmUserRole().getUserRoleName();
            if (duplicateData) {
                var row = courseTable.insertRow(1);
                $('#addUserToQueue > tbody:last').append(row);
                var cell1 = row.insertCell(0);
                var cell2 = row.insertCell(1);
                var cell3 = row.insertCell(2);
                var cell4 = row.insertCell(3);
                cell1.innerHTML = $('#userToQueue option:selected').val();
                cell2.innerHTML = $('#userToQueue option:selected').text();
                cell3.innerHTML = "";
                cell4.innerHTML = "<button onclick='$(this).parent().parent().remove();' type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button>";
            } else {
                swal("Stop", "Detail Already added ...!!!!!!", "warning");
            }
        }
    }

    //    function for add new Queue
    function addQueue() {
        var color = document.getElementById("favcolor").value;
//        alert(color);
        event.preventDefault();
//
//        // Get form
        var form = $('#fileUploadForm')[0];
//
//        // Create an FormData object 
        var data = new FormData(form);
//
//        // If you want to add an extra field for the FormData
//        data.append("CustomField", "This is some extra data, testing");

        // disabled the submit button
//        $("#btnSubmit").prop("disabled", true);


        $.ajax({
            type: "POST",
            enctype: 'multipart/form-data',
            url: "queueManagement_addQueue",
            data: data,
            processData: false,
            contentType: false,
            cache: false,
            timeout: 600000,
            beforeSend: function (xhr) {
                $('#ADDQUEBTNDIV').empty();
                $('#ADDQUEBTNDIV').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
            },
            success: function (data) {
                var resultValue = JSON.parse(data);
                if (resultValue.result === "0") {
                    swal("", resultValue.displayMessage, "error");
                    $('#ADDQUEBTNDIV').empty();
                    $('#ADDQUEBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addQueue()'>Save Changes</button>");
                } else if (resultValue.result === "2") {
                    swal("", resultValue.displayMessage, "error");
                    setTimeout(function () {
                        window.location.href = "../../../index.jsp";
                    }, 2000);
                } else if (resultValue.result === "1") {
                    var message = resultValue.displayMessage;
                    var splitMessage = message.split("|");
                    var queId = splitMessage[1];
//                    var resultMessage = splitMessage[0];
                    addUsersToQueue(queId);
                }

            },
            error: function (e) {
                $("#result").text(e.responseText);
                console.log("ERROR : ", e);
                $("#btnSubmit").prop("disabled", false);
            }
        });
    }
    function addUsersToQueue(queueId) {
        var tb1 = document.getElementById('addUserToQueue');
        var rowCount = tb1.rows.length;
        var ac = {AC: []};
        var newRows = 0;
        var go = 0;
        for (var t = 1; t < rowCount; t++) {
            var userId = document.getElementById("addUserToQueue").rows[t].cells[0].innerText;
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
            url: "queueManagement_addUsersToQueue",
            type: "POST",
            data: "usersDetails=" + usersDetails + "&queueId=" + queueId,
            beforeSend: function (xhr) {
            },
            success: function (data) {
                var resultValue = JSON.parse(data);
                if (resultValue.result === "0") {
                    swal("", resultValue.displayMessage, "error");
                    $('#ADDQUEBTNDIV').empty();
                    $('#ADDQUEBTNDIV').html("<button type='button' class='btn btn-green' style='width: 100%' onclick='addQueue()'>Save Changes</button>");
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
            },
            error: function (error) {
            }
        });
    }

    function changeIcon(value) {
//        alert(value);
        document.getElementById("mainIconView").className = "fa-2x " + value;
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
