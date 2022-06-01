/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.userManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.UmUser;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.simple.JSONObject;

/**
 *
 * @author JOY
 */
@WebServlet(name = "userManagement_userLogout", urlPatterns = {"/userManagement_userLogout"})
public class userManagement_userLogout extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Map<String, String> resultMap = new HashMap<String, String>();
        Transaction tr = ses.beginTransaction();
        PrintWriter out = response.getWriter();
        UmUser activeUser = null;
        Logger logger = Logger.getLogger(this.getClass().getName());
        try {
            if (request.getSession().getAttribute("nowLoginUser") == null) {
                response.sendRedirect("index.jsp");
            } else {
                activeUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
                if (activeUser == null) {
                    response.sendRedirect("index.jsp");
                } else {
 //            get loguserhttp attribute from Session object
                    SmSession updateHttpSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                    Date outDate = new Date();
//            update user logout time in db
                   updateHttpSession.setTimeOut(outDate);
                   ses.update(updateHttpSession);
                    Date httpSessionDate = new Date();
                    
                    String saveContent = activeUser.getFirstName()+ " User Logout";
//                    Save SessionActivity in db
                    SmSessionActivity saveHttpSessionActivity = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, saveContent, outDate, STATIC_DATA_MODEL.LOGOUT, STATIC_DATA_MODEL.USERLOGOUT, updateHttpSession, activeUser);
                    if (saveHttpSessionActivity != null) {
                        request.getSession().invalidate();
                        response.sendRedirect("index.jsp");
                    } else {
                        resultMap.put("result", "2");
                        resultMap.put("displayMessage", "Error.");
                    }

                }
            }
            tr.commit();
        } catch (Exception e) {
            tr.rollback();
            logger.error(e.toString());
            e.printStackTrace();
        } finally {
            ses.clear();
            ses.close();
            out.print(JSONObject.toJSONString(resultMap));
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
