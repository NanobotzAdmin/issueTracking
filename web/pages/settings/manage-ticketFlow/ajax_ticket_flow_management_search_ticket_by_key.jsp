<%-- 
    Document   : ajax_ticket_flow_management_search_ticket_by_key
    Created on : Feb 11, 2022, 3:25:42 AM
    Author     : JOY
--%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.List"%>
<%@page import="org.hibernate.Query"%>
<%@page import="com.it.connection.Connection"%>
<%@page import="org.hibernate.Session"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
 <%

        Session ses = Connection.getSessionFactory().openSession();
        JSONArray jr = new JSONArray();
        try {

            String queryParameter = request.getParameter("searchTerm");

            String sql = "SELECT  tm_tickets where tid like '%"+queryParameter+"%' GROUP BY tm_tickets.tid";
            //System.out.println(sql);
            Query query1 = ses.createSQLQuery(sql);
            List<String> whomList = query1.list();

            for (String whom : whomList) {

                JSONObject jo = new JSONObject();
                jo.put("name", whom);
                jo.put("value", whom);
                jr.add(jo);

            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            ses.clear();
            ses.close();
            out.println(jr.toJSONString());

        }
    %>
