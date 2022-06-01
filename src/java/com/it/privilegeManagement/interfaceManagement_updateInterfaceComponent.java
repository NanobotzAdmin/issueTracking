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
@WebServlet(name = "interfaceManagement_updateInterfaceComponent", urlPatterns = {"/interfaceManagement_updateInterfaceComponent"})
public class interfaceManagement_updateInterfaceComponent extends HttpServlet {

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
                    int interfaceId = Integer.parseInt(request.getParameter("interfaceIdToComponentUP"));
                    int ComponentId = Integer.parseInt(request.getParameter("interfaceComponentIdUP"));
                    String interfaceComponentName = request.getParameter("interfaceComponentNameUP");
                    String interfaceComponentID = request.getParameter("interfaceComponentNameIdUP");
                    if (interfaceId == 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Not Found.");
                    } else if (ComponentId == 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Component Not Found.");
                    } else if (interfaceComponentName.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Component Name can't be empty.");
                    } else if (interfaceComponentID.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Interface Component ID can't be empty.");
                    } else {
                        //Search selected interface Component
                        PmInterfaceComponent selectedInterfaceComponent = (PmInterfaceComponent) ses.load(PmInterfaceComponent.class, ComponentId);
                        if (selectedInterfaceComponent == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Interface Component Not Found.");
                        } else {
                            //Get selected interface 
                            PmInterface interfaceToComponentUP = (PmInterface) ses.load(PmInterface.class, interfaceId);
                            //Update interface component
                            PmInterfaceComponent updateInterfacesComponent = new com.it.privilegeManagementModel.PMS_PM_Interface_Component().updateInterfaceComponent(ses, interfaceComponentName, interfaceComponentID, addedDate, STATIC_DATA_MODEL.PMACTIVE, interfaceToComponentUP, activeUser, selectedInterfaceComponent);
                            if (updateInterfacesComponent != null) {
//Get Active session object
                                SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                //Save session activity
                                String updateInterfaceComponentSessionActivityContent = updateInterfacesComponent.getComponentName() + " Interface Component has been Updated by " + activeUser.getFirstName()+ " on " + addedDate;
                                SmSessionActivity sessionActivityToUpdateInterfaceComponent = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, updateInterfaceComponentSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.INTERFACECOMPONENTUPDATE, activeSession, activeUser);
                                if (sessionActivityToUpdateInterfaceComponent != null) {
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
