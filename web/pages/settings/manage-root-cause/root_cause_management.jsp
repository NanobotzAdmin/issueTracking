<%-- 
    Document   : root_cause_management
    Created on : Nov 24, 2021, 1:41:22 AM
    Author     : JOY
--%>

<%@page import="com.ring.db.RcasAnswers"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.RcasQuestion"%>
<%@page import="com.ring.db.UmUserHasInterfaceComponent"%>
<%@page import="com.ring.db.PmInterfaceComponent"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.db.UmUser"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    if (request.getSession().getAttribute("nowLoginUser") != null) {
        Session ses = com.ring.connection.Connection.getSessionFactory().openSession();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser logedUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
        String gg = (request.getParameter("pageUrl"));
        int pid = Integer.parseInt(request.getParameter("interface"));
        String content_prefix = "../../";
        try {
%>
<h1 class="page-header">Root Cause Analysis Settings</h1><br>
<%
    List<PmInterfaceComponent> getComponentByIterfaceId = new com.ring.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, pid);
    boolean rootCauseManagementMain = false;

    if (!getComponentByIterfaceId.isEmpty()) {
        for (PmInterfaceComponent cmpt : getComponentByIterfaceId) {
            UmUserHasInterfaceComponent getUserHasComponentByUserAndComponentId = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, logedUser.getId(), cmpt.getId());
            if (getUserHasComponentByUserAndComponentId != null) {
                if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("ROOTCAUSEMAINCOMPONENT")) {
                    rootCauseManagementMain = true;
                }

            }
        }
    }
%>
<%
    if (rootCauseManagementMain) {
%> 


<ul class="nav nav-tabs">
    <li class="nav-item">
        <a href="#default-tab-1" data-bs-toggle="tab" class="nav-link active" onclick="clearRightContentDivRCMS()">Question Pool</a>
    </li>
    <li class="nav-item">
        <a href="#default-tab-2" data-bs-toggle="tab" class="nav-link" onclick="clearRightContentDivRCMS()">Answer Pool</a>
    </li>
    <li class="nav-item">
        <a href="#default-tab-3" data-bs-toggle="tab" class="nav-link" >Data</a>
    </li>
</ul>

<div class="tab-content bg-white-transparent-2 p-3 rounded-bottom">
    <div class="tab-pane fade active show" id="default-tab-1">
        <div class="row">
            <div class="col-sm-12">
                <div class="form-group row">
                    <h4 class="col-sm-9">Current Question List</h4>
                    <div class="col-sm-3">
                        <button type="button" class="btn btn-outline-success" style="width: 100%" onclick="newQuestionDetails()">Add New Question</button>
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
                                                <th>No</th>
                                                <th>Question</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                List<RcasQuestion> loadAllRootCauseQuestion = new com.ring.rootCauseManagementModel.RCMS_Rcas_Question().getAllRootCauseByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                                if (!loadAllRootCauseQuestion.isEmpty()) {
                                                    for (RcasQuestion elem : loadAllRootCauseQuestion) {
                                            %>
                                            <tr class="odd gradeX">
                                                <td><%=elem.getId()%></td>
                                                <td><%=elem.getQuestionName()%></td>
                                                <td>
                                                    <button type="button" class="btn btn-outline-warning btn-xs" onclick="loadRootCsueQuestionDetailsToManage(<%=elem.getId()%>)">Manage</button>
                                                    <!--<button type="button" class="btn btn-outline-white" >View Activity</button>-->
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

    <div class="tab-pane fade" id="default-tab-2">
        <div class="row">
            <div class="col-sm-12">
                <div class="form-group row">
                    <h4 class="col-sm-9">Current Answer List</h4>
                    <div class="col-sm-3">
                        <button type="button" class="btn btn-outline-success" style="width: 100%"  onclick="newAnswerDetails()">Add New Answer</button>
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
                                                <th>No</th>
                                                <th>Answer</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                List<RcasAnswers> loadAllRootCauseAnswers = new com.ring.rootCauseManagementModel.RCMS_Rcas_Answers().getAllAnswersByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                                if (!loadAllRootCauseAnswers.isEmpty()) {
                                                    for (RcasAnswers elemA : loadAllRootCauseAnswers) {
                                            %>
                                            <tr class="odd gradeX">
                                                <td><%=elemA.getId()%></td>
                                                <td><%=elemA.getAnswer()%></td>
                                                <td>
                                                    <button type="button" class="btn btn-outline-warning btn-xs" onclick="loadRootCsueAnswerDetailsToManage(<%=elemA.getId()%>)">Manage</button>
                                                    <!--<button type="button" class="btn btn-outline-white" >View Activity</button>-->
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
    <div class="tab-pane fade" id="default-tab-3">
        <div class="row">
            <div class="col-sm-12">
                <div class="form-group row">
                    <div class="col-sm-6"></div>
                    <div class="col-sm-6">
                        <div class="input-group" id="default-daterange">
                            <input type="text" name="default-daterange" class="form-control" value="" placeholder="click to select the date range" />
                            <div class="input-group-text"><i class="fa fa-calendar"></i></div>
                        </div>
                    </div>
                </div>
            </div><br><br><br>
            <div class="panel panel-inverse">
                <div class="panel-body">
                    <div class="card">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table id="data-table-default" class="table table-striped table-bordered align-middle">
                                    <thead>
                                        <tr>
                                            <th>Cause</th>
                                            <th>Main</th>
                                            <th>Sub</th>
                                            <th>Miner</th>
                                            <th>View</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <a href="" onclick="viewTicket()" style="text-decoration: none">View Ticket</a>
                                            </td>
                                        </tr>
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
        responsive: true
    });

    $("#default-daterange").daterangepicker({
        opens: "right",
        format: "MM/DD/YYYY",
        separator: " to ",
        startDate: moment().subtract("days", 29),
        endDate: moment(),
        minDate: "01/01/2021",
        maxDate: "12/31/2021",
    }, function (start, end) {
        $("#default-daterange input").val(start.format("MMMM D, YYYY") + " - " + end.format("MMMM D, YYYY"));
    });



    function clearRightContentDivRCMS() {

        $('#right_content_div').html("");

    }
    
    
//    function for view ticket
  function viewTicket() {
        $.ajax({
            url: "pages/settings/manage-root-cause/ajax_root_cause_management_view_ticket.jsp",
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
    

    //    function for load add new Question details
    function newQuestionDetails() {
        $.ajax({
            url: "pages/settings/manage-root-cause/ajax_root_cause_management_create_new_question_details.jsp",
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
    //     function for load add new Answer details
    function newAnswerDetails() {
        $.ajax({
            url: "pages/settings/manage-root-cause/ajax_root_cause_management_create_new_answer_details.jsp",
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
    //    function for load manage Question details
    function loadRootCsueQuestionDetailsToManage(id) {
        $.ajax({
            url: "pages/settings/manage-root-cause/ajax_root_cause_management_manege_question_details.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&id=" + id,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
            }
        });
    }
    //    function for load manage Answer details
    function loadRootCsueAnswerDetailsToManage(id) {
        $.ajax({
            url: "pages/settings/manage-root-cause/ajax_root_cause_management_manege_answer_details.jsp",
            type: "POST",
            data: "interfaceId=" + <%=pid%> + "&id=" + id,
            beforeSend: function (xhr) {
            },
            complete: function () {
            },
            success: function (data) {
                $('#right_content_div').html(data);
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