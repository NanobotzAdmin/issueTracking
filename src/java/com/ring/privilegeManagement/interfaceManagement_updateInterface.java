/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.privilegeManagement;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.PmInterface;
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
@WebServlet(name = "interfaceManagement_updateInterface", urlPatterns = {"/interfaceManagement_updateInterface"})
public class interfaceManagement_updateInterface extends HttpServlet {

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
                    Date updatedDate = new Date();
                    int interfaceTopicId = Integer.parseInt(request.getParameter("interfaceTopicIdUP"));
                    int interfaceId = Integer.parseInt(request.getParameter("interfaceId"));
                    String interfaceName = request.getParameter("interfacename");
                    String interfacePath = request.getParameter("interfaceurl");
                    String iconClass = request.getParameter("iconclass");
                    String titleClass = request.getParameter("titleclass");
                    if (interfaceTopicId == 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Topic Not Found.");
                    } else if (interfaceId == 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Not Found.");
                    } else if (interfaceName.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Name can't be empty.");
                    } else if (interfacePath.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface URL can't be empty.");
                    } else if (iconClass.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Icon Class can't be empty.");
                    } else if (titleClass.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Title Class can't be empty.");
                    } else {
                        //Search selected interface
                        PmInterface selectedInterface = (PmInterface) ses.load(PmInterface.class, interfaceId);
                        if (selectedInterface == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Interface Not Found.");
                        } else {
                            //Get selected interface topic
                            PmInterfaceTopic interfaceTopic = (PmInterfaceTopic) ses.load(PmInterfaceTopic.class, interfaceTopicId);
                            //Update interface
                            PmInterface updateInterfaces = new com.ring.privilegeManagementModel.PMS_PM_Interface().updateInterface(ses, interfaceName, interfacePath, iconClass, titleClass, updatedDate, STATIC_DATA_MODEL.PMACTIVE, interfaceTopic, activeUser, selectedInterface);
                            if (updateInterfaces != null) {
//Get Active session object
                                SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                //Save session activity
                                String updateInterfaceSessionActivityContent = updateInterfaces.getInterfaceName() + " Interface has been Updated by " + activeUser.getFirstName()+ " on " + addedDate;
                                SmSessionActivity sessionActivityToUpdateInterface = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, updateInterfaceSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.INTERFACEUPDATE, activeSession, activeUser);
                                if (sessionActivityToUpdateInterface != null) {
                                    tr.commit();
                                    resultMap.put("result", "1");
                                    resultMap.put("displayMessage", "Update Success...");
                                } else {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Error..2.");
                                }
                            } else {
                                resultMap.put("result", "0");
                                resultMap.put("displayMessage", "Error...1");
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
