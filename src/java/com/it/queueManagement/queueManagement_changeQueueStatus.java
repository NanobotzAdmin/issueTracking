/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.queueManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.QmQueue;
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
@WebServlet(name = "queueManagement_changeQueueStatus", urlPatterns = {"/queueManagement_changeQueueStatus"})
public class queueManagement_changeQueueStatus extends HttpServlet {

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
        PrintWriter out = response.getWriter();
        Map<String, String> resultMap = new HashMap<String, String>();
        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Transaction tr = ses.beginTransaction();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser activeUser = null;
        try {
            if (request.getSession().getAttribute("nowLoginUser") == null) {
                resultMap.put("result", "2");
                resultMap.put("displayMessage", "Session Time Out.");
            } else {
                activeUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
                if (activeUser == null) {
                    resultMap.put("result", "2");
                    resultMap.put("displayMessage", "Session Time Out.");
                } else {
                    Date updatedDate = new Date();
                    String state = request.getParameter("state");
                    int id = Integer.parseInt(request.getParameter("id"));
                    if (id <= 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Queue Not Found");
                    } else if (state.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Status Not Found");
                    } else {
//                        selected queue
                        QmQueue selectedQueue = (QmQueue) ses.load(QmQueue.class, id);
                        if (selectedQueue == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Queue Not Found");
                        } else {
                            if (state.equals("D")) {
//                                    deactivate queue
                                selectedQueue.setStatus(STATIC_DATA_MODEL.PMDEACTIVE);
                                ses.update(selectedQueue);
                                //Get Active session object
                                SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                //Save session activity
                                String changeQueueStatusSessionActivityContent = selectedQueue.getQueueName() + " Queue has been Deactivated by " + activeUser.getFirstName() + " on " + updatedDate;
                                SmSessionActivity sessionActivityTochangeQueue = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, changeQueueStatusSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.QUEUEMANAGEMENT, selectedQueue.getId(), activeSession, activeUser);
                                if (sessionActivityTochangeQueue != null) {
                                    tr.commit();
                                    resultMap.put("result", "1");
                                    resultMap.put("displayMessage", "Deactivate Success");
                                } else {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Error");
                                }
                            } else if (state.equals("A")) {
                                //                                    activate queue
                                selectedQueue.setStatus(STATIC_DATA_MODEL.PMACTIVE);
                                ses.update(selectedQueue);
                                //Get Active session object
                                SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                //Save session activity
                                String changeQueueStatusSessionActivityContent = selectedQueue.getQueueName() + " Queue has been Activated by " + activeUser.getFirstName() + " on " + updatedDate;
                                SmSessionActivity sessionActivityTochangeQueue = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, changeQueueStatusSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.QUEUEMANAGEMENT, selectedQueue.getId(), activeSession, activeUser);
                                if (sessionActivityTochangeQueue != null) {
                                    tr.commit();
                                    resultMap.put("result", "1");
                                    resultMap.put("displayMessage", "Activate Success");
                                } else {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Error");
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            tr.rollback();
            e.printStackTrace();
            logger.error(e.toString());
            resultMap.put("result", "0");
            resultMap.put("displayMessage", e.getMessage());
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
