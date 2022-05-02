<%-- 
    Document   : ajax_location_management_load_location_history_details
    Created on : Dec 4, 2021, 4:21:21 AM
    Author     : JOY
--%>

<%@page import="com.ring.db.LmLocationHistory"%>
<%@page import="java.util.List"%>
<%@page import="com.ring.db.LmLocations"%>
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
        try {

            LmLocations selectedLocation = (LmLocations) ses.load(LmLocations.class, Integer.parseInt(request.getParameter("locationId")));
            if (selectedLocation != null) {
%> 
    <!--start location activity-->
            <div class="row">
                <div class="col-sm-12">
                    <h1 class="page-header"> Locations Activity</h1>
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
                                                <%
                                                    List<LmLocationHistory> loadLocationHistorytByLocation = new com.ring.locationManagementModel.LMS_LM_Location_History().getAllHistoryLocationId(ses, selectedLocation.getId());
                                                    if(!loadLocationHistorytByLocation.isEmpty()){
                                                        for (LmLocationHistory locationHistory : loadLocationHistorytByLocation) {
                                                %>
                                                <tr>
                                                    <td><%=locationHistory.getCreatedAt()%></td>
                                                    <td><%=locationHistory.getUpdateDescription()%></td>
                                                </tr>
                                                <%}}%>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--end location activity-->
            
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
