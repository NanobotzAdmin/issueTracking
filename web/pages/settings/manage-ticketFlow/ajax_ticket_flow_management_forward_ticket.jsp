<%-- 
    Document   : ajax_ticket_flow_management_forward_ticket
    Created on : Jan 5, 2022, 8:57:29 PM
    Author     : buddh
--%>

<%@page import="com.ring.db.LmLocations"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.db.TmTicketsHasUmUser"%>
<%@page import="com.ring.db.QmSubCategories"%>
<%@page import="com.ring.db.QmQueue"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.QmCategories"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.db.TmTickets"%>
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
            int pid = Integer.parseInt(request.getParameter("interfaceId"));
            int queId = Integer.parseInt(request.getParameter("queuId"));
            TmTickets selectedTicket = (TmTickets) ses.load(TmTickets.class, Integer.parseInt(request.getParameter("ticketId")));
            if (selectedTicket != null) {
%> 
<div class="row">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-sm-6">
                <h1 class="page-header" style="color: #fff"> Forward Ticket  &nbsp;&nbsp; <small style="font-size: 15px"> <%=selectedTicket.getTid()%> </small> &nbsp;&nbsp;
                    <div class="avatars">
                        <span class="avatar">
                            <%
//                                get ticker created usr
                                UmUser createdUser = (UmUser) ses.load(UmUser.class, selectedTicket.getCreatedBy());
                            %>
                            <!--<img style="width: 24px;height:24px;" src="${pageContext.request.contextPath}/ImageServlet/<%=createdUser.getRemark1()%>" class=" rounded-pill" />-->
                        </span>
                    </div> 
                </h1>
            </div>
            <!--            <div class="col-sm-1"></div>
                        <div class="col-sm-5">
                            <button type="button" class="btn btn-default btn-sm"><i class="fa fa-trash"></i></button>
                            <button type="button" class="btn btn-gray btn-sm"><i class="fa fa-arrow-right"></i></button>
                            <button type="button" class="btn btn-info btn-sm">Mark Complete</button>
                        </div>-->
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label style="color: #fff">Assigned to</label>
            </div>
            <div class="col-sm-6">
                <div class="avatars">
                    <%
                        List<TmTicketsHasUmUser> loadUsersByTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
                        if (!loadUsersByTicket.isEmpty()) {
                            for (TmTicketsHasUmUser ticketUsrs : loadUsersByTicket) {
                    %>
                    <span class="avatar" style="width: 24px;height:24px;">
                        <img style="width: 24px;height:24px;" src="${pageContext.request.contextPath}/ImageServlet/<%=ticketUsrs.getUmUser().getRemark1()%>" class=" rounded-pill" title="<%=ticketUsrs.getUmUser().getFirstName()%>&nbsp;<%=ticketUsrs.getUmUser().getLastName()%>" />
                    </span>
                    <%}
                        }%>
                </div> 
            </div>
            <div class="col-sm-4">
                <label style="color: #fff"><b>Total Expenses</b> &nbsp;&nbsp;&nbsp; <%=selectedTicket.getTotalExpence()%> Rs</label>
            </div>
        </div>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <h4><%=selectedTicket.getTicketName()%> <small><%=selectedTicket.getCreatedAt()%></small></h4>
                <label style="color: #fff">
                    <%
                        String ticketLocation = "";
                        if (selectedTicket.getLmLocations() != null) {
                            ticketLocation = " | " + selectedTicket.getLmLocations().getLocationName();
                        }
                    %>
                    Ticket Description<%=ticketLocation%>
                </label><br><br>
                <div class="row">

                    <lable>
                        <%=selectedTicket.getTicketDescription()%>
                    </lable>
                    <!--                    <div class="col">
                                            <img class="img-fluid" src="https://m.majorgeeks.com/index.php?ct=content&action=file&id=480"/>    
                                        </div>
                                        <div class="col"> <button class="btn btn-info">Download</button></div>-->
                </div>

            </div>
        </div>
        <div class="panel panel-inverse">
            <div class="panel-body">
                <div class="card">
                    <div class="card-body">
                        <div class="form-group mb-3">
                            <label>Queue</label>
                            <select class="default-select2 form-control" id="queueForTF" onchange="categoryByQueueTF(this.value)">
                                <option value="<%=selectedTicket.getQmQueue().getId()%>" selected=""><%=selectedTicket.getQmQueue().getQueueName()%></option>
                                <%
                                    List<QmQueue> loadQueueTF = new com.ring.queueManagementModel.QMS_QM_Queue().getAllQueuesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                    if (!loadQueueTF.isEmpty()) {
                                        for (QmQueue queueTF : loadQueueTF) {
                                %>
                                <option value="<%=queueTF.getId()%>"><%=queueTF.getQueueName()%></option>
                                <%}
                                    }%>
                            </select>
                        </div>
                        <div class="form-group mb-3" id="categoryTFDiv">
                            <label>Category</label>
                            <select class="default-select2 form-control" id="categoryForTF" onchange="SubCategoryByCategoryTF(this.value)">
                                <%
                                    if (selectedTicket.getQmCategories() != null) {
                                %>
                                <option value="<%=selectedTicket.getQmCategories().getId()%>" selected=""><%=selectedTicket.getQmCategories().getCategoryName()%></option>

                                <%
                                    if (selectedTicket.getQmQueue() != null) {
                                        List<QmCategories> loadCategoryTF = new com.ring.queueManagementModel.QMS_QM_Categories().getCategoryByQueueId(ses, selectedTicket.getQmQueue().getId());
                                        if (!loadCategoryTF.isEmpty()) {
                                            for (QmCategories categoryTF : loadCategoryTF) {
                                %>
                                <option value="<%=categoryTF.getId()%>"><%=categoryTF.getCategoryName()%></option>
                                <%}
                                        }
                                    }
                                %>
                                <%} else {%>
                                <option value="0" selected="">-- Select One --</option>
                                <%
                                    List<QmCategories> loadCategoryTF = new com.ring.queueManagementModel.QMS_QM_Categories().getAllCategoriesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                    if (!loadCategoryTF.isEmpty()) {
                                        for (QmCategories categoryTF : loadCategoryTF) {
                                %>
                                <option value="<%=categoryTF.getId()%>"><%=categoryTF.getCategoryName()%></option>
                                <%}
                                        }
                                    }%>
                            </select>
                        </div>
                        <div class="form-group mb-3" id="subCategoryTFDiv">
                            <label>Sub-Category</label>
                            <select class="default-select2 form-control" id="subCategoryForTF">
                                <%
                                    if (selectedTicket.getQmSubCategories() != null) {
                                %>
                                <option value="<%=selectedTicket.getQmSubCategories().getId()%>" selected=""><%=selectedTicket.getQmSubCategories().getSubCategoryName()%></option>
                                <%
                                    if (selectedTicket.getQmCategories() != null) {
                                        List<QmSubCategories> loadSubCategoryTF = new com.ring.queueManagementModel.QMS_QM_Sub_Categories().getSubCategoryBYCategoryId(ses, selectedTicket.getQmCategories().getId());
                                        if (!loadSubCategoryTF.isEmpty()) {
                                            for (QmSubCategories subCategoryTF : loadSubCategoryTF) {
                                %>
                                <option value="<%=subCategoryTF.getId()%>"><%=subCategoryTF.getSubCategoryName()%></option>
                                <%}
                                        }
                                    }%>

                                <%} else {%>
                                <option value="0" selected="">-- Select One --</option>
                                <%
                                    List<QmSubCategories> loadSubCategoryTF = new com.ring.queueManagementModel.QMS_QM_Sub_Categories().getAllSubCategoriesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                    if (!loadSubCategoryTF.isEmpty()) {
                                        for (QmSubCategories subCategoryTF : loadSubCategoryTF) {
                                %>
                                <option value="<%=subCategoryTF.getId()%>"><%=subCategoryTF.getSubCategoryName()%></option>
                                <%}
                                        }
                                    }%>
                            </select>
                        </div>
                        <div class="form-group mb-3">
                            <label>Location</label>
                            <select class=" default-select2" style="width: 100%" id="loadLocationForwardTicket" name="loadLocationForwardTicket" >
                                <%
                                    if (selectedTicket.getLmLocations() != null) {
                                %>
                                <option value="<%=selectedTicket.getLmLocations().getId()%>" selected=""><%=selectedTicket.getLmLocations().getLocationName()%></option>
                                <%} else {%>
                                <option value="0" selected="">-- Select One --</option>
                                <%
                                    List<LmLocations> loadLocationForwardTickets = new com.ring.locationManagementModel.LMS_LM_Locations().getAllLocationsByStatus(ses, STATIC_DATA_MODEL.PMDEACTIVE);
                                    if (!loadLocationForwardTickets.isEmpty()) {
                                        for (LmLocations locationsFwd : loadLocationForwardTickets) {
                                %>
                                <option value="<%=locationsFwd.getId()%>"><%=locationsFwd.getLocationName()%></option>
                                <%}
                                        }
                                    }%>
                            </select>
                        </div>
                        <div class="row mb-3">
                            <div class="form-group col-md-6">
                                <label>Add User to Ticket</label>
                                <select class="form-control" style="color: #fff" id="userToForwardTicketC">
                                    <option selected="" value="0" style="color: #000">-- Select User --</option>
                                    <%
                                        List<UmUser> loadUsersToTicketForward = new com.ring.userManagementModel.UMS_UM_User().getAllUsersByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                                        if (!loadUsersToTicketForward.isEmpty()) {
                                            for (UmUser elemFT : loadUsersToTicketForward) {
                                    %>
                                    <option value="<%=elemFT.getId()%>" style="color: #000"><%=elemFT.getFirstName()%> <%=elemFT.getLastName()%></option> 
                                    <%}
                                        }%>
                                </select>
                            </div>
                            <div class="form-group col-md-6" id="ADDUSRTOFWDTCKBTN"> 
                                <label></label><br>
                                <button type="button" class="btn btn-green" onclick="addUserToForwardTicket()">Add</button>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped table-sm">
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
                                        List<TmTicketsHasUmUser> loadTicketHasUSerToForwardTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
                                        if (!loadTicketHasUSerToForwardTicket.isEmpty()) {
                                            for (TmTicketsHasUmUser elemTHUFWD : loadTicketHasUSerToForwardTicket) {
                                    %>
                                    <tr>
                                        <td><%=elemTHUFWD.getUmUser().getId()%></td>
                                        <td><%=elemTHUFWD.getUmUser().getFirstName()%> <%=elemTHUFWD.getUmUser().getLastName()%></td>
                                        <td></td>
                                        <td><button onclick="removeUserFromForwardTicket(<%=elemTHUFWD.getUmUser().getId()%>,<%=elemTHUFWD.getTmTickets().getId()%>)" type='button' class='btn btn-sm btn-danger' value='Remove'><span class='fa fa-remove'>Remove</span></button></td>
                                    </tr>
                                    <%}
                                        }%>
                                </tbody>
                            </table>
                        </div>
                        <div class="row mb-3">
                            <label class="form-label col-form-label col-md-9"></label>
                            <div class="col-md-3" id="FWDTCKBTN">
                                <button type="button" class="btn btn-primary" style="width: 100%" onclick="forwardTicket()">Forward</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(".default-select2").select2();

    function categoryByQueueTF(queueId) {
        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_forward_ticket_load_category_by_queue_id.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&queueId=" + queueId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#categoryTFDiv').html(data);
                SubCategoryByCategoryTF(0)
            }
        });
    }
    function SubCategoryByCategoryTF(categoryId) {
        $.ajax({
            url: "pages/settings/manage-ticketFlow/ajax_ticket_flow_management_forward_ticket_load_subcategory_by_category_id.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&categoryId=" + categoryId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#subCategoryTFDiv').html(data);
            }
        });
    }

    //    function for add users to Forward ticket 
    function addUserToForwardTicket() {
        var user = $('#userToForwardTicketC option:selected').val();
        if (user === "0") {
            swal("", "Select User", "warning");
        } else {
            $.ajax({
                url: "ticketManagement_addUserToForwardTicket",
                type: "POST",
                data: "user=" + user + "&ticketId=" + <%=selectedTicket.getId()%>,
                beforeSend: function (xhr) {
                    $('#ADDUSRTOFWDTCKBTN').empty();
                    $('#ADDUSRTOFWDTCKBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
//                        confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                        forwardTicketLoad(<%=selectedTicket.getId()%>,<%=queId%>);
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#ADDUSRTOFWDTCKBTN').empty();
                    $('#ADDUSRTOFWDTCKBTN').html("<label></label><br><button type='button' class='btn btn-green' onclick='addUserToTicketC()'>Add</button>");
                },
                error: function (error) {
                }
            });
        }
    }
    //    function for remove users from forward ticket 
    function removeUserFromForwardTicket(userId, ticketId) {
        $.ajax({
            url: "ticketManagement_removeUserFromForwardTicket",
            type: "POST",
            data: "userId=" + userId + "&ticketId=" + ticketId,
            beforeSend: function (xhr) {
//                $('#ADDUSRTOTCKBTN').empty();
//                $('#ADDUSRTOTCKBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
//                    confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
                    forwardTicketLoad(<%=selectedTicket.getId()%>,<%=queId%>);
                    swal({
                        title: "Done",
                        text: resultValue.displayMessage,
                        timer: 1000,
                        showConfirmButton: false
                    });
                }
//                $('#ADDUSRTOTCKBTN').empty();
//                $('#ADDUSRTOTCKBTN').html("<button type='button' class='btn btn-green' onclick='addUserToTicketC()'>Add</button>");
            },
            error: function (error) {
            }
        });
    }
    //    function for forward ticket
    function forwardTicket() {

        var queueId = $('#queueForTF option:selected').val();
        var categoryId = $('#categoryForTF option:selected').val();
        var subCategoryId = $('#subCategoryForTF option:selected').val();
        var locationId = $('#loadLocationForwardTicket option:selected').val();

        if (queueId === "0") {
            swal("", "Select Queue", "warning");
        } else {
            $.ajax({
                url: "ticketManagement_forwardTicket",
                type: "POST",
                data: "ticketId=" + <%=selectedTicket.getId()%> + "&queueId=" + queueId + "&categoryId=" + categoryId + "&subCategoryId=" + subCategoryId + "&locationId=" + locationId,
                beforeSend: function (xhr) {
                    $('#FWDTCKBTN').empty();
                    $('#FWDTCKBTN').html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                        confirmationTicket(<%=selectedTicket.getId()%>,<%=queId%>);
//                        forwardTicketLoad(<%=selectedTicket.getId()%>,<%=queId%>);
                        swal({
                            title: "Done",
                            text: resultValue.displayMessage,
                            timer: 1000,
                            showConfirmButton: false
                        });
                    }
                    $('#FWDTCKBTN').empty();
                    $('#FWDTCKBTN').html("<button type='button' class='col-sm-2 btn btn-primary float-end' style='width: 100%' onclick='forwardTicket()'>Forward</button>");
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
