/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.rootCauseManagement;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.QmQueue;
import com.ring.db.QmQueueHasQuestion;
import com.ring.db.RcasAnswers;
import com.ring.db.RcasQuestion;
import com.ring.db.SmSession;
import com.ring.db.SmSessionActivity;
import com.ring.db.UmUser;
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
@WebServlet(name = "rootCauseManagement_updateRootCauseAnswer", urlPatterns = {"/rootCauseManagement_updateRootCauseAnswer"})
public class rootCauseManagement_updateRootCauseAnswer extends HttpServlet {

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
        Session ses = com.ring.connection.Connection.getSessionFactory().openSession();
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
                    String answerU = request.getParameter("answerU");
                    int answerIdU = Integer.parseInt(request.getParameter("answerIdU"));
                    if (answerIdU <= 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Answer Not Found");
                    } else if (answerU.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Answer");
                    } else {
//                        selected Answer
                        RcasAnswers selectedRCA = (RcasAnswers) ses.load(RcasAnswers.class, answerIdU);
                        if (selectedRCA == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Answer Not Found");
                        } else {
                            if (!selectedRCA.getAnswer().equals(answerU)) {
//                                check updated answer name exists
                                RcasAnswers checkNameExists = new com.ring.rootCauseManagementModel.RCMS_Rcas_Answers().checkNameExists(ses, answerU);
                                if (checkNameExists != null) {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Answer Exists.");
                                } else {
////                                    save location history
//                                    String locationHistoryDescription = "Location name Updated To " + locationName;
//                                    LmLocationHistory addLocationHistory = new com.ring.locationManagementModel.LMS_LM_Location_History().saveLocationHistory(ses, locationHistoryDescription, updatedDate, updatedDate, selectedLocation, activeUser.getId(), activeUser.getId());
                                    valied1 = true;
                                }
                            } else {
                                valied1 = true;
                            }
                            if (valied1) {
//                            update Answer details
                                    RcasAnswers updateAnswer = new com.ring.rootCauseManagementModel.RCMS_Rcas_Answers().updateRootCauseAnswer(ses, answerU, STATIC_DATA_MODEL.PMACTIVE, updatedDate, selectedRCA, activeUser.getId());
                                    if (updateAnswer != null) {
                                        //Get Active session object
                                        SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                        //Save session activity
                                        String updateAnswerSessionActivityContent = updateAnswer.getAnswer()+ " Answer has been Updated by " + activeUser.getFirstName() + " on " + addedDate;
                                        SmSessionActivity sessionActivityToUpdateAnswer = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, updateAnswerSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.ROOTCAUSEANSWER,updateAnswer.getId(),activeSession, activeUser);
                                        if (sessionActivityToUpdateAnswer != null) {
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
