<%-- 
    Document   : ajax_ticket_flow_management_forward_ticket_load_category_by_queue_id
    Created on : Jan 6, 2022, 1:12:24 PM
    Author     : JOY
--%>

<%@page import="org.hibernate.Transaction"%>
<%@page import="com.ring.db.QmCategories"%>
<%@page import="com.ring.configurationModel.STATIC_DATA_MODEL"%>
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
            int queueId = Integer.parseInt(request.getParameter("queueId"));
%>
<label>Category</label>
<select class="default-select2 form-control" id="categoryForTF" onchange="SubCategoryByCategoryTF(this.value)">
    <option value="0" selected="">-- Select One --</option>
    <%
        List<QmCategories> loadCategoryTF = new com.ring.queueManagementModel.QMS_QM_Categories().getCategoryByQueueId(ses, queueId);
        if (!loadCategoryTF.isEmpty()) {
            for (QmCategories categoryTF : loadCategoryTF) {
    %>
    <option value="<%=categoryTF.getId()%>"><%=categoryTF.getCategoryName()%></option>
    <%}
                                    }%>
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

