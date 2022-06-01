<%-- 
    Document   : queues_management
    Created on : Nov 24, 2021, 1:40:36 AM
    Author     : JOY
--%>

<%@page import="com.it.db.TmTickets"%>
<%@page import="com.it.db.QmQueueHasUser"%>
<%@page import="com.it.db.QmQueueHasCategories"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="com.it.db.QmSubCategories"%>
<%@page import="com.it.db.QmCategories"%>
<%@page import="com.it.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.it.db.QmQueue"%>
<%@page import="com.it.db.UmUserHasInterfaceComponent"%>
<%@page import="com.it.db.PmInterfaceComponent"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page import="com.it.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") != null) {
        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Transaction tr = ses.beginTransaction();
        tr.commit();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        String gg = (request.getParameter("pageUrl"));
        int pid = Integer.parseInt(request.getParameter("interface"));
        String content_prefix = "../../";
        try {
%>

<%
    List<PmInterfaceComponent> getComponentByIterfaceId = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, pid);
    boolean queuesManagementMain = false;

    if (!getComponentByIterfaceId.isEmpty()) {
        for (PmInterfaceComponent cmpt : getComponentByIterfaceId) {
            UmUserHasInterfaceComponent getUserHasComponentByUserAndComponentId = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, logedUser.getId(), cmpt.getId());
            if (getUserHasComponentByUserAndComponentId != null) {
                if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("QUEUESMAINCOMPONENT")) {
                    queuesManagementMain = true;
                }

            }
        }
    }
%>
<%
    if (queuesManagementMain) {
%> 

<ul class="nav nav-tabs">
    <li class="nav-item">
        <a href="#default-tab-1" data-bs-toggle="tab" class="nav-link active" onclick="clearRightContentDiv()">Queues</a>
    </li>
    <li class="nav-item">
        <a href="#default-tab-2" data-bs-toggle="tab" class="nav-link" onclick="clearRightContentDiv()">Categories</a>
    </li>
    <li class="nav-item">
        <a href="#default-tab-3" data-bs-toggle="tab" class="nav-link" onclick="clearRightContentDiv()">Sub Categories</a>
    </li>
</ul>
<div class="tab-content bg-white-transparent-2 p-3 rounded-bottom">
    <div class="tab-pane fade active show" id="default-tab-1">
        <div class="row">
            <div class="col-sm-12">
                <h1 class="page-header"> Queue Management</h1>
                <div class="form-group row">
                    <h4 class="col-sm-9">Current Queues List</h4>
                    <div class="col-sm-3">
                        <button type="button" class="btn btn-outline-success" style="width: 100%" onclick="newQueuesDetails('<%=pid%>', '<%=gg%>')">Create New Queues</button>
                    </div>
                </div><br>
                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table id="data-table-default" class="table table-striped table-bordered align-middle">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Queue Name</th>
                                                <th>Categories</th>
                                                <th>Members</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int qu = 0;
                                                List<QmQueue> loadAllQueues = new com.it.queueManagementModel.QMS_QM_Queue().getAllQueuesByStatus(ses, STATIC_DATA_MODEL.PMALL);
//                                                System.out.println("li size = " + loadAllQueues.size());
                                                if (!loadAllQueues.isEmpty()) {
                                                    for (QmQueue elem : loadAllQueues) {
                                                        qu++;
                                            %>
                                            <tr class="odd gradeX">
                                                <td><%=qu%></td>
                                                <td><%=elem.getQueueName()%></td>
                                                <td>
                                                    <%
                                                        List<QmCategories> loadAllCategoriesByqueue = new com.it.queueManagementModel.QMS_QM_Categories().getCategoryByQueueId(ses, elem.getId());
                                                        if (!loadAllCategoriesByqueue.isEmpty()) {
                                                            for (QmCategories cat : loadAllCategoriesByqueue) {
                                                    %>
                                                    <span class="badge bg-success"><%=cat.getCategoryName()%></span>
                                                    <%}
                                                        }%>
                                                </td>
                                                <td></td>
                                                <td>
                                                    <div class="btn-group">
                                                    <button type="button" class="btn btn-outline-warning btn-xs" onclick="loadQueueDetailsToManage(<%=elem.getId()%>, '<%=pid%>', '<%=gg%>')">Manage</button>
                                                    <%if (elem.getStatus() == STATIC_DATA_MODEL.PMACTIVE) {%>
                                                    <div id="QUESTATECHNGBTNDIV<%=elem.getId()%>"><button type="button" class="btn btn-outline-danger btn-xs" onclick="changeStatus(<%=elem.getId()%>, 'D')">Deactivate</button></div>
                                                    <%} else {%>
                                                    <div id="QUESTATECHNGBTNDIV<%=elem.getId()%>"><button type="button" class="btn btn-outline-success btn-xs" onclick="changeStatus(<%=elem.getId()%>, 'A')">Activate</button></div>
                                                    <%}%>

                                                    <%
                                                        List<QmCategories> checkQueueHasCategories = new com.it.queueManagementModel.QMS_QM_Categories().getCategoryByQueueId(ses, elem.getId());
                                                        List<QmQueueHasUser> checkQueueHasUsers = new com.it.queueManagementModel.QMS_QM_Queue_Has_User().getAllUsersByLocationId(ses, elem.getId());
                                                        List<TmTickets> checkQueueHasTicktes = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsByQueueId(ses, elem.getId());
                                                        if (checkQueueHasCategories.isEmpty() && checkQueueHasUsers.isEmpty() && checkQueueHasTicktes.isEmpty()) {
                                                    %>
                                                    <div id="QUEDLTBTNDIV<%=elem.getId()%>"><button type="button" class="btn btn-outline-white btn-xs" onclick="deleteQueue(<%=elem.getId()%>, )">Delete Queue</button></div>
                                                    <%}%>
                                                    </div>
                                                </td>
                                            </tr>
                                            <%}
                                                }%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="form-label col-form-label col-md-9"></label>
                    <!--                <div class="col-md-3">
                                        <button type="button" class="btn btn-outline-white" style="width: 100%">View Activity</button>
                                    </div>-->
                </div>


            </div>
        </div>
    </div>

    <div class="tab-pane fade" id="default-tab-2">
        <div class="row">
            <div class="col-sm-12">
                <h1 class="page-header"> Category Management</h1>
                <div class="form-group row">
                    <h4 class="col-sm-9">Assigned Category List</h4>
                    <div class="col-sm-3">
                        <button type="button" class="btn btn-outline-success" style="width: 100%" onclick="newCategoryDetails('<%=pid%>', '<%=gg%>')">Create Category</button>
                    </div>
                </div><br>
                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table id="data-table-default2" class="table table-striped table-bordered align-middle">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Category Name</th>
                                                <th>Queue</th>
                                                <th>Members</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int cat = 0;
                                                List<QmCategories> loadAllCategories = new com.it.queueManagementModel.QMS_QM_Categories().getAllCategoriesByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                                if (!loadAllCategories.isEmpty()) {
                                                    for (QmCategories elemCat : loadAllCategories) {
                                                        cat++;
                                            %>
                                            <tr class="odd gradeX">
                                                <td><%=cat%></td>
                                                <td><%=elemCat.getCategoryName()%></td>
                                                <td><span class="badge bg-success"><%=elemCat.getQmQueue().getQueueName()%></span></td>
                                                <td>45</td>
                                                <td>
                                                    <button type="button" class="btn btn-outline-warning btn-xs" onclick="loadCategoryDetailsToManage(<%=elemCat.getId()%>, '<%=pid%>', '<%=gg%>')">Manage</button>
                                                    <!--<button type="button" class="btn btn-outline-white btn-xs">View Activity</button>-->
                                                </td>
                                            </tr>
                                            <%}
                                                }%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="form-label col-form-label col-md-9"></label>
                    <!--                <div class="col-md-3">
                                        <button type="button" class="btn btn-outline-white" style="width: 100%">View Activity</button>
                                    </div>-->
                </div>


            </div>
        </div> 
    </div>

    <div class="tab-pane fade" id="default-tab-3">

        <div class="row">
            <div class="col-sm-12">
                <h1 class="page-header">Sub Category Management</h1> 
                <div class="form-group row">
                    <h4 class="col-sm-9">Assigned Sub Category List</h4>
                    <div class="col-sm-3">
                        <button type="button" class="btn btn-outline-success" style="width: 100%" onclick="newSubCategoryDetails('<%=pid%>', '<%=gg%>')">Create Sub Category</button>
                    </div>
                </div><br>
                <div class="panel panel-inverse">
                    <div class="panel-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table id="data-table-default3" class="table table-striped table-bordered align-middle">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Sub Categories</th>
                                                <th>Categories</th>
                                                <th>Members</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int subCat = 0;
                                                List<QmSubCategories> loadAllSubCategories = new com.it.queueManagementModel.QMS_QM_Sub_Categories().getAllSubCategoriesByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                                if (!loadAllSubCategories.isEmpty()) {
                                                    for (QmSubCategories elemSubCat : loadAllSubCategories) {
                                                        subCat++;
                                            %>
                                            <tr class="odd gradeX">
                                                <td><%=subCat%></td>
                                                <td><%=elemSubCat.getSubCategoryName()%></td>
                                                <td>
                                                    <span class="badge bg-success"><%=elemSubCat.getQmCategories().getCategoryName()%></span>
                                                </td>
                                                <td>45</td>
                                                <td>
                                                    <button type="button" class="btn btn-outline-warning btn-xs" onclick="loadSubCategoryDetailsToManage(<%=elemSubCat.getId()%>, '<%=pid%>', '<%=gg%>')">Manage</button>
                                                </td>
                                            </tr>
                                            <%}
                                                }%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>





<script>

    $('#data-table-default').DataTable({
//        responsive: true
    });
    $('#data-table-default2').DataTable({
//        responsive: true
    });
    $('#data-table-default3').DataTable({
//        responsive: true
    });

    //    function for load add new queue details
    function newQueuesDetails(pId, gg) {
        $.ajax({
            url: "pages/settings/manage-queues/ajax_queues_management_create_new_queue_details.jsp",
            type: "POST",
            data: "interfaceId=" + pId + "&pageUrl=" + gg,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for load queue details to manage
    function loadQueueDetailsToManage(queId, pId, gg) {
        $.ajax({
            url: "pages/settings/manage-queues/ajax_queues_management_manage_queue_details.jsp",
            type: "POST",
            data: "queId=" + queId + "&interfaceId=" + pId + "&pageUrl=" + gg,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for load queue history details 
    function loadQueueHistoryDetails() {
        $.ajax({
            url: "pages/settings/manage-queues/ajax_queues_management_load_queue_history_details.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%>,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for load add new category details
    function newCategoryDetails(pId, gg) {
        $.ajax({
            url: "pages/settings/manage-queues/ajax_queues_management_create_new_category_details.jsp",
            type: "POST",
            data: "interfaceId=" + pId + "&pageUrl=" + gg,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for load Category details to manage
    function loadCategoryDetailsToManage(categoryId, pId, gg) {
        $.ajax({
            url: "pages/settings/manage-queues/ajax_queues_management_manage_category_details.jsp",
            type: "POST",
            data: "categoryId=" + categoryId + "&interfaceId=" + pId + "&pageUrl=" + gg,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for load add new Sub category details
    function newSubCategoryDetails(pId, gg) {
        $.ajax({
            url: "pages/settings/manage-queues/ajax_queues_management_create_new_sub_category_details.jsp",
            type: "POST",
            data: "interfaceId=" + pId + "&pageUrl=" + gg,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for load Sub Category details to manage
    function loadSubCategoryDetailsToManage(subCategoryId) {
        $.ajax({
            url: "pages/settings/manage-queues/ajax_queues_management_manage_sub_category_details.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&subCategoryId=" + subCategoryId,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    function clearRightContentDiv() {

        $('#right_content_div').html("");

    }

    function changeStatus(id, state) {
        $.ajax({
            url: "queueManagement_changeQueueStatus",
            type: "POST",
            data: "id=" + id + "&state=" + state,
            beforeSend: function (xhr) {
                $('#QUESTATECHNGBTNDIV' + id).empty();
                $('#QUESTATECHNGBTNDIV' + id).html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                $('#QUESTATECHNGBTNDIV' + id).empty();
                if (state === "D") {
                    $('#QUESTATECHNGBTNDIV' + id).html("<button type='button' class='btn btn-danger btn-sm' onclick='changeStatus('" + id + "', 'D')'>Deactivate</button>");
                } else {
                    $('#QUESTATECHNGBTNDIV' + id).html("<button type='button' class='btn btn-success btn-sm' onclick='changeStatus('" + id + "', 'A')'>Activate</button");
                }
            },
            error: function (error) {
            }
        });

    }
    function deleteQueue(id) {
        $.ajax({
            url: "queueManagement_deleteQueue",
            type: "POST",
            data: "id=" + id,
            beforeSend: function (xhr) {
                $('#QUEDLTBTNDIV' + id).empty();
                $('#QUEDLTBTNDIV' + id).html("<img src='assets/img/Wedges.gif' class='pull-right' style='width: 24px; height: 24px;'>");
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
                $('#QUEDLTBTNDIV' + id).empty();
                $('#QUEDLTBTNDIV' + id).html("<button type='button' class='btn btn-danger btn-sm' onclick='deleteQueue('" + id + "')'>Delete Queue</button");

            },
            error: function (error) {
            }
        });

    }


</script>
<%} else {
        response.sendRedirect("home.jsp");
    }%>


<%        } catch (Exception e) {
        logger.error(logedUser.getId() + " - " + logedUser.getFirstName() + " : " + e.toString());
    } finally {
        logger = null;
        logedUser = null;
        ses.clear();
        ses.close();
        System.gc();
    }

%>




<%} else {
        response.sendRedirect("index.jsp");

    }%>