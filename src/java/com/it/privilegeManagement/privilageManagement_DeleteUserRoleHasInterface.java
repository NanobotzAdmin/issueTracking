/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.privilegeManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.PmInterface;
import com.it.db.PmUserRole;
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
@WebServlet(name = "privilageManagement_DeleteUserRoleHasInterface", urlPatterns = {"/privilageManagement_DeleteUserRoleHasInterface"})
public class privilageManagement_DeleteUserRoleHasInterface extends HttpServlet {

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
        Map<String, String> resaltMap = new HashMap<String, String>();
        Session session = com.it.connection.Connection.getSessionFactory().openSession();
        Transaction tr = session.beginTransaction();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser activeUser = null;
        try {
            if (request.getSession().getAttribute("nowLoginUser") == null) {
                resaltMap.put("result", "2");
                resaltMap.put("displayMessage", "Session Time Out.");
            } else {
                activeUser = (UmUser) session.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
                if (activeUser == null) {
                    resaltMap.put("result", "2");
                    resaltMap.put("displayMessage", "Session Time Out.");
                } else {
                    String userRole = request.getParameter("userRoleId");
                    String interfaceId = request.getParameter("interfaceId");
                    if (userRole.equals("")) {
                        resaltMap.put("result", "0");
                        resaltMap.put("displayMessage", "User Role Not Found  !!!");
                    } else if (interfaceId.equals("")) {
                        resaltMap.put("result", "0");
                        resaltMap.put("displayMessage", "Interface Not Found  !!!");
                    } else {
                        int uRole = Integer.parseInt(userRole);
                        int sInterface = Integer.parseInt(interfaceId);
                        //Get Active session object
                        SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
//                        selected user Role
                        PmUserRole selectedUserRole = (PmUserRole) session.load(PmUserRole.class, uRole);
//                        selected interface
                        PmInterface selectedInterface = (PmInterface) session.load(PmInterface.class, sInterface);
                        Date addedDate = new Date();
//                                delete user role has assigned component
                        int deleteComponent = new com.it.privilegeManagementModel.PMS_PM_User_Role_Has_Interface_Component().deleteUserRoleHasInterface(session, selectedUserRole.getId(), selectedInterface.getId());

                        if (deleteComponent > 0) {
//                                      delete user role has interface component save session activity?
                            String deleteUserRoleHasInterfaceContent = selectedInterface.getInterfaceName() + " Interface has been Delete From " + selectedUserRole.getUserRoleName() + " by " + activeUser.getFirstName()+ " on " + addedDate;
                            SmSessionActivity sessionActivityToDeleteUserRoleHasInterface = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, deleteUserRoleHasInterfaceContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.USERROLEHASICOMPONENTREMOVE, activeSession, activeUser);
                            resaltMap.put("result", "1");
                            resaltMap.put("displayMessage", "Interface Remove Successfull !");

                        } else {
                            resaltMap.put("result", "0");
                            resaltMap.put("displayMessage", "Interface Remove Unsuccessfull !");
                        }

                    }
                }
            }
            tr.commit();
        } catch (Exception e) {
            tr.rollback();
            e.printStackTrace();
            logger.error(e.toString());
            resaltMap.put("result", "0");
            resaltMap.put("displayMessage", e.getMessage());
        } finally {
            session.clear();
            session.close();
            out.print(JSONObject.toJSONString(resaltMap));
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
