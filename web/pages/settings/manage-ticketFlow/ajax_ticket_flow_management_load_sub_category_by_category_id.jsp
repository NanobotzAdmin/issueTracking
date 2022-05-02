<%-- 
    Document   : ajax_ticket_flow_management_load_sub_category_by_category_id
    Created on : Jan 6, 2022, 2:11:22 AM
    Author     : JOY
--%>

<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.db.QmSubCategories"%>
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

            int categoryId = Integer.parseInt(request.getParameter("catId"));
%> 
<label>Sub-Category</label>
<select class="default-select2 form-control" id="loadSubCategoryByCategoryId">
    <option value="0" selected="">-- Select One --</option>
    <%
        List<QmSubCategories> loadSubCatByCatId = new com.ring.queueManagementModel.QMS_QM_Sub_Categories().getSubCategoryBYCategoryId(ses, categoryId);
        if(!loadSubCatByCatId.isEmpty()){
            for (QmSubCategories subCat : loadSubCatByCatId) {
    %>
    <option value="<%=subCat.getId()%>"><%=subCat.getSubCategoryName()%></option>
    <%}}%>
</select>
    
    <script type="text/javascript">
        $(".default-select2").select2();
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
