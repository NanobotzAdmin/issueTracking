<%-- 
    Document   : testHomeView
    Created on : Jan 9, 2022, 1:40:24 AM
    Author     : JOY
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--filter div-->
<div class="row">
    <div class="col-sm-3">
        <div class="form-group">
            <label>Queue</label>
            <select class="default-select2 form-control" id="loadQueueToHome">
                <option value="0" selected="">-- Select One --</option>
                <%
                    List<QmQueue> loadQueues = new com.it.queueManagementModel.QMS_QM_Queue().getAllQueuesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                    if (!loadQueues.isEmpty()) {
                        for (QmQueue que : loadQueues) {
                %>
                <option value="<%=que.getId()%>"><%=que.getQueueName()%></option>
                <%}
                            }%>
            </select>
        </div>
    </div>
    <div class="col-sm-3">
        <div class="form-group">
            <label>Category</label>
            <select class="default-select2 form-control" id="loadCategoryToHome">
                <option value="0" selected="">-- Select One --</option>
                <%
                    List<QmCategories> loadCategorys = new com.it.queueManagementModel.QMS_QM_Categories().getAllCategoriesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                    if (!loadCategorys.isEmpty()) {
                        for (QmCategories cat : loadCategorys) {
                %>
                <option value="<%=cat.getId()%>"><%=cat.getCategoryName()%></option>
                <%}
                            }%>
            </select>
        </div>
    </div>
    <div class="col-sm-3">
        <div class="form-group" id="LoadSubCategoryToHome">
            <label>Sub-Category</label>
            <select class="default-select2 form-control" id="loadSubCategoryByCategoryId">
                <option value="0" selected="">-- Select One --</option>
                <%
                    List<QmSubCategories> loadSubCategorys = new com.it.queueManagementModel.QMS_QM_Sub_Categories().getAllSubCategoriesByStatus(ses, STATIC_DATA_MODEL.PMACTIVE);
                    if (!loadSubCategorys.isEmpty()) {
                        for (QmSubCategories subCat : loadSubCategorys) {
                %>
                <option value="<%=subCat.getId()%>"><%=subCat.getSubCategoryName()%></option>
                <%}
                            }%>
            </select>
        </div>
    </div>
    <div class="col-sm-3">
        <div class="form-group">
            <label>Date Range</label>
            <div class="input-group" id="default-daterange">
                <input type="text" name="default-daterange" class="form-control" value="" placeholder="click to select the date range" />
                <div class="input-group-text"><i class="fa fa-calendar"></i></div>
            </div>
        </div>
    </div>
</div>
            
            <!--Table Div-->
            <div class="row">
                                <div class="col">
                                    <!--BEGIN middle pannel-->
                                    <div class="panel panel-inverse">
                                        <div class="panel-body">
                                            <!-- BEGIN Datatable-->
                                            <div class="table-responsive">
                                                <table id="data-table-default" class="table table-striped table-bordered align-middle table-sm">
                                                    <thead>
                                                        <tr>
                                                            <th width="1%">TID</th>
                                                            <th class="text-nowrap">Ticket Title</th>
                                                            <th class="text-nowrap">Category</th>
                                                            <th class="text-nowrap">Sub Category</th>
                                                            <th class="text-nowrap">Status</th>
                                                            <th  data-orderable="false">Assigned</th>
                                                            <th class="text-nowrap">Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                    <%
                                        List<TmTickets> loadTicketsByUserANdCurrentMonth = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketsByUserIdAndCurrentMonth(ses, logedUser.getId());
                                        if(!loadTicketsByUserANdCurrentMonth.isEmpty()){
                                            for (TmTickets ticketsByUser : loadTicketsByUserANdCurrentMonth) {
                                    %>
                                    <tr >
                                        <td width="1%" class="fw-bold text-white"><%=ticketsByUser.getId()%></td>
                                        <td><%=ticketsByUser.getTicketName()%></td>
                                        <td><%=ticketsByUser.getQmCategories().getCategoryName()%></td>
                                        <td><%=ticketsByUser.getQmSubCategories().getSubCategoryName()%></td>
                                        <td>
                                            <%
                                                if(ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETPENDING){
                                            %>
                                            <span class="text-warning">Pending</span>
                                            <%}else if(ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETACTIVE){%>
                                            <span class="text-success">Active</span>
                                             <%}else if(ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETCOMPLETED){%>
                                             <span class="text-info">Completed</span>
                                             <%}else if(ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETCONFIRMED){%>
                                             <span class="text-inverse">Confirmed</span>
                                             <%}else if(ticketsByUser.getStatus() == STATIC_DATA_MODEL.TICKETARCHIVE){%>
                                             <span class="text-danger">Archive</span>
                                             <%}%>
                                        </td>
                                        <td ><div class="avatars">
                                                <span class="avatar">
                                                    <img src="assets/img/user/user-1.jpg" class=" rounded-pill" />
                                                </span>
                                                <span class="avatar">
                                                    <img src="assets/img/user/user-3.jpg" class=" rounded-pill" />
                                                </span>
                                            </div></td>
                                            <td>
                                                <!--<a class="btn btn-white btn-xs" onclick="confirmationTicket(<%=ticketsByUser.getId()%>,<%=ticketsByUser.getQmQueue().getId()%>)">view</a>-->
                                            </td>
                                    </tr>
                                    <%}}%>

                                                    </tbody>
                                                </table>
                                            </div>
                                            <!-- END Datatable-->
                                        </div>
                                    </div>
                                    <!--END middle pannel-->
                                </div>
                            </div>
