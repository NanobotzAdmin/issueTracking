/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.privilegeManagement;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.PmInterfaceTopic;
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
@WebServlet(name = "interfaceManagement_updateInterfaceTopic", urlPatterns = {"/interfaceManagement_updateInterfaceTopic"})
public class interfaceManagement_updateInterfaceTopic extends HttpServlet {

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
                    Date addedDate = new Date();
                    String interfaceTopicId = request.getParameter("interfaceTopicIdUP");
                    String interfaceTopicName = request.getParameter("groupNameUP");
                    String interfaceTopicIcon = request.getParameter("groupIconUP");
                    String topicSection = request.getParameter("groupSectionUP");
                    if (interfaceTopicId.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Topic Not Found..");
                    } else if (interfaceTopicName.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Topic Name can't be empty.");
                    } else if (interfaceTopicIcon.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Topic icon can't be empty.");
                    } else if (topicSection.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Section can't be empty.");
                    } else {   
                        //get selectedInterfaceTopic
                    PmInterfaceTopic selectedTopic = (PmInterfaceTopic)ses.load(PmInterfaceTopic.class, Integer.parseInt(interfaceTopicId));          
                    if (selectedTopic == null) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface topic Not Found.");
                    } else {
                        //Update interface topic
                        PmInterfaceTopic updateInterfaceTopic = new com.ring.privilegeManagementModel.PMS_PM_Interface_Topic().updateInterfaceGroup(ses, interfaceTopicName, interfaceTopicIcon, topicSection, addedDate, STATIC_DATA_MODEL.PMACTIVE, activeUser, selectedTopic);

                        if (updateInterfaceTopic != null) {
 //Get Active session object
                                SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                //Save session activity
                                String updateInterfaceTopicSessionActivityContent = updateInterfaceTopic.getTopicName()+ " Interface Topic has been Updated by " + activeUser.getFirstName()+ " on " + addedDate;
                                SmSessionActivity sessionActivityToUpdateInterfaceTopic = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, updateInterfaceTopicSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.INTERFACETOPICUPDATE, activeSession, activeUser);

                            if (sessionActivityToUpdateInterfaceTopic != null) {
                                tr.commit();
                                resultMap.put("result", "1");
                                resultMap.put("displayMessage", "Update Success...");
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
