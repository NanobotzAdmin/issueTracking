/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.privilegeManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.PmInterface;
import com.it.db.PmInterfaceComponent;
import com.it.db.PmInterfaceTopic;
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
@WebServlet(name = "interfaceManagement_addInterfaceComponent", urlPatterns = {"/interfaceManagement_addInterfaceComponent"})
public class interfaceManagement_addInterfaceComponent extends HttpServlet {

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
                    Date addedDate = new Date();
                    Date updatedDate = new Date();
                    int interfaceId = Integer.parseInt(request.getParameter("interfaceId"));
                    String componentName = request.getParameter("componentName");
                    String componentId = request.getParameter("componentId");
                    if (interfaceId == 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Please select Interface.");
                    } else if (componentName.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Componant Name can't be empty.");
                    } else if (componentId.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Componant Id can't be empty.");
                    } else {
 //                 check interface component name already exist 
                        PmInterfaceComponent checkComponent = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().searchComponentIdExit(ses, componentId);
                    if (checkComponent != null) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface component already exist.");
                    } else {
//                      Get selected interface
                        PmInterface newInterface = (PmInterface) ses.load(PmInterface.class, interfaceId);
//                      Save interdace component
                        PmInterfaceComponent subInterface = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().saveInterfaceComponent(ses, componentName, componentId, updatedDate, updatedDate, STATIC_DATA_MODEL.PMACTIVE, newInterface, activeUser, activeUser);
                        if (subInterface != null) {
//                      Get Active session object
                              //Get Active session object
                                SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                //Save session activity
                                String saveInterfaceComponentSessionActivityContent = subInterface.getComponentName()+ " Interface Component has been Saved by " + activeUser.getFirstName()+ " on " + addedDate;
                                SmSessionActivity sessionActivityToAddInterfaceComponent = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, saveInterfaceComponentSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.INTERFACESAVE, activeSession, activeUser);
                            if (sessionActivityToAddInterfaceComponent != null) {
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
