<%-- 
    Document   : customer_management
    Created on : Dec 14, 2021, 12:00:59 AM
    Author     : buddh
--%>

<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
<%@page import="com.ring.db.UmCustomer"%>
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
<h1 class="page-header">Customer List</h1><br>
<%
    List<PmInterfaceComponent> getComponentByIterfaceId = new com.ring.privilegeManagementModel.PMS_PM_Interface_Component().getAllInterfaceComponentsByInterface(ses, pid);
    boolean customerManagementMain = false;

    if (!getComponentByIterfaceId.isEmpty()) {
        for (PmInterfaceComponent cmpt : getComponentByIterfaceId) {
            UmUserHasInterfaceComponent getUserHasComponentByUserAndComponentId = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, logedUser.getId(), cmpt.getId());
            if (getUserHasComponentByUserAndComponentId != null) {
                if (getUserHasComponentByUserAndComponentId.getPmInterfaceComponent().getComponentId().equals("CUSTOMERMAINCOMPONENT")) {
                    customerManagementMain = true;
                }

            }
        }
    }
%>
<%
    if (customerManagementMain) {
%> 
<div class="container-fluid">
    <div class="row">
        <div class="col-sm-12">
            <div class="form-group row">
                <h4 class="col-sm-9"></h4>
                <div class="col-sm-3">
                    <button type="button" class="btn btn-outline-success" style="width: 100%" onclick="newCustomer()">Create Customer</button>
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
                                            <th>CID</th>
                                            <th>Customer Name</th>
                                            <th>Branch</th>
                                            <th>Mobile</th>
                                            <th>Verification</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<UmCustomer> loadAllCustomers = new com.ring.customerManagementModel.CMS_UM_Customer().getAllCustomersByStatus(ses, STATIC_DATA_MODEL.PMALL);
                                            if(!loadAllCustomers.isEmpty()){
                                                for (UmCustomer cust : loadAllCustomers) {
                                        %>
                                        <tr class="odd gradeX">
                                            <td><%=cust.getId()%></td>
                                            <td><%=cust.getCustomerName()%></td>
                                            <td><%if(cust.getLmLocations() != null){out.write(cust.getLmLocations().getLocationName());}else{out.write("--");}%></td>
                                            <td><%=cust.getMobileNumber()%></td>
                                            <td><%if(cust.getIsVerified() == 0){out.write("Not Verified");}else{out.write("Verified");}%></td>
                                            <td><%if(cust.getStatus()== 2){out.write("Active");}else{out.write("Deactive");}%></td>
                                            <td>
                                                <button class="btn btn-primary btn-xs" onclick="loadCustomer(<%=cust.getId()%>)"><i class="fa fa-eye"></i></button>
                                            </td>
                                        </tr>
                                        <%}}%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!--start Customer Profile--> 
<!--            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header"> Customer Profile</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label>Customer Name</label>
                                        <input type="text" class="form-control">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Branch</label>
                                        <select class="default-select2 form-control">
                                            <option>Select One</option>
                                        </select>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="form-group col-md-6">
                                            <label>Mobile</label>
                                            <input type="text" class="form-control">
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label></label><br>
                                            <a href=""> <label>Verified</label></a>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>E-mail</label>
                                        <input type="email" class="form-control">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>NIC</label>
                                        <input type="text" class="form-control">
                                    </div>
                                    <div class="form-group mb-3">
                                        <label>Tickets</label>
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>TID</th>
                                                        <th>Category</th>
                                                        <th>Status</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                        <td><button type="button" class="btn btn-primary btn-xs"><span class="fa fa-eye"></span></button></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>


                                    <div class="row mb-3">
                                        <label class="form-label col-form-label col-md-6"></label>
                                        <div class="col-md-3">
                                            <button type="button" class="btn btn-outline-white" style="width: 100%">View Activity</button>
                                        </div>
                                        <div class="col-md-3">
                                            <button type="button" class="btn btn-green" style="width: 100%">Save Changes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>-->
            <!--end Customer Profile--> 
            <!--start queue activity--> 
<!--            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header"> Customer Activity</h1>
                    <div class="panel panel-inverse">
                        <div class="panel-body">
                            <div class="card">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Timestamp</th>
                                                    <th>Activity Description</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>-->
            <!--end queue activity--> 

        </div>
    </div>
</div>



<script>

    $(".default-select2").select2();

    $('#data-table-default').DataTable({
        responsive: true
    });
    
//    function for load add new Customer details
    function newCustomer() {
        $.ajax({
            url: "pages/settings/manage-customer/ajax_customer _management_create_new_customer_details.jsp",
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
//    function for load  Customer details to update
    function loadCustomer(id) {
        $.ajax({
            url: "pages/settings/manage-customer/ajax_customer _management_manage_customer_details.jsp",
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