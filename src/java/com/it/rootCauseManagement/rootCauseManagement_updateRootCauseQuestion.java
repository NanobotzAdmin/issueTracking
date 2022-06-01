/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.rootCauseManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.QmQueue;
import com.it.db.QmQueueHasQuestion;
import com.it.db.QmQueueHasUser;
import com.it.db.RcasQuestion;
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
@WebServlet(name = "rootCauseManagement_updateRootCauseQuestion", urlPatterns = {"/rootCauseManagement_updateRootCauseQuestion"})
public class rootCauseManagement_updateRootCauseQuestion extends HttpServlet {

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
                    boolean valied1 = false;
                    Date addedDate = new Date();
                    Date updatedDate = new Date();
                    String rcasQuestionU = request.getParameter("rcasQuestionU");
                    int rcasQuestionIdU = Integer.parseInt(request.getParameter("rcasQuestionIdU"));
                    if (rcasQuestionIdU <= 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Question Not Found");
                    } else if (rcasQuestionU.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Question Name.");
                    } else {
//                        selected question
                        RcasQuestion selectedRCQ = (RcasQuestion) ses.load(RcasQuestion.class, rcasQuestionIdU);
                        if (selectedRCQ == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Question Not Found");
                        } else {
                            if (!selectedRCQ.getQuestionName().equals(rcasQuestionU)) {
//                                check updated question name exists
                                RcasQuestion checkNameExists = new com.it.rootCauseManagementModel.RCMS_Rcas_Question().checkNameExists(ses, rcasQuestionU);
                                if (checkNameExists != null) {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Question Name Exists.");
                                } else {
////                                    save location history
//                                    String locationHistoryDescription = "Location name Updated To " + locationName;
//                                    LmLocationHistory addLocationHistory = new com.it.locationManagementModel.LMS_LM_Location_History().saveLocationHistory(ses, locationHistoryDescription, updatedDate, updatedDate, selectedLocation, activeUser.getId(), activeUser.getId());
                                    valied1 = true;
                                }
                            } else {
                                valied1 = true;
                            }
                            if (valied1) {
//                            update question details
                                    RcasQuestion updateQuestion = new com.it.rootCauseManagementModel.RCMS_Rcas_Question().updateRootCauseQuestionQueue(ses, rcasQuestionU, STATIC_DATA_MODEL.PMACTIVE, updatedDate, selectedRCQ, activeUser.getId());
                                    if (updateQuestion != null) {
                                        //Get Active session object
                                        SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                        //Save session activity
                                        String updateQuestionSessionActivityContent = updateQuestion.getQuestionName()+ " Question has been Updated by " + activeUser.getFirstName() + " on " + addedDate;
                                        SmSessionActivity sessionActivityToUpdateQuestion = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, updateQuestionSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.ROOTCAUSEQUESTION,updateQuestion.getId(),activeSession, activeUser);
                                        if (sessionActivityToUpdateQuestion != null) {
                                           int deleteRCQHasQues = new com.it.rootCauseManagementModel.RCMS_QM_Queue_Has_Question().deleteRCQHasQueueByRCQId(ses, selectedRCQ.getId());
//                                        add location has users
                                            org.json.JSONObject jObj = new org.json.JSONObject(request.getParameter("queueDetails"));
                                            org.json.JSONArray acData = jObj.getJSONArray("AC");
                                            int r = acData.length();
                                            if (r > 0) {
                                                for (int i = 0; i < r; ++i) {
                                                    org.json.JSONObject data = acData.getJSONObject(i);
                                                    int queueId = Integer.parseInt(data.getString("queueId"));
                                                    QmQueue selecQueue = (QmQueue) ses.load(QmQueue.class, queueId);
                                                    if (selecQueue != null) {
//                                                    add question has queues
                                                            QmQueueHasQuestion addQueuesToQuestion = new com.it.rootCauseManagementModel.RCMS_QM_Queue_Has_Question().addRCQHasQueue(ses, selecQueue.getId(), selectedRCQ.getId(), STATIC_DATA_MODEL.PMACTIVE, updatedDate, updatedDate, activeUser.getId(), activeUser.getId());
                                                        
                                                    }
                                                }
                                            }
                                            tr.commit();
                                            resultMap.put("result", "1");
                                            resultMap.put("displayMessage", "Saved Success...");

                                        } else {
                                            resultMap.put("result", "0");
                                            resultMap.put("displayMessage", "Error...");
                                        }
                                    } else {
                                        resultMap.put("result", "0");
                                        resultMap.put("displayMessage", "Error...");
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
