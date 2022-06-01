/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.privilegeManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.PmInterfaceComponent;
import com.it.db.PmInterfaceTopic;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.UmUser;
import com.it.db.UmUserHasInterfaceComponent;
import com.it.db.UmUserHasInterfaceTopic;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
@WebServlet(name = "privilageManagement_addOrDeleteUserHasComponent", urlPatterns = {"/privilageManagement_addOrDeleteUserHasComponent"})
public class privilageManagement_addOrDeleteUserHasComponent extends HttpServlet {

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
                    String user = request.getParameter("user");
                    String component = request.getParameter("component");
                    String status = request.getParameter("status");
                    if (user.equals("")) {
                        resaltMap.put("result", "0");
                        resaltMap.put("displayMessage", "User Not Found  !!!");
                    } else if (component.equals("")) {
                        resaltMap.put("result", "0");
                        resaltMap.put("displayMessage", "Component Not Found  !!!");
                    } else if (status.equals("")) {
                        resaltMap.put("result", "0");
                        resaltMap.put("displayMessage", "Status Not Found  !!!");
                    } else {
                        int userId = Integer.parseInt(user);
                        int compont = Integer.parseInt(component);
                        //Get Active session object
                        SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
//                        selected user 
                        UmUser selectedUser = (UmUser) session.load(UmUser.class, userId);
//                        selected component
                        PmInterfaceComponent selectedComponent = (PmInterfaceComponent) session.load(PmInterfaceComponent.class, compont);
                        //                        selected interfaceTopic 
                        PmInterfaceTopic selectedTopic = (PmInterfaceTopic) session.load(PmInterfaceTopic.class, selectedComponent.getPmInterface().getPmInterfaceTopic().getId());
                        if (selectedUser != null && selectedComponent != null) {
//                        selected user role
                            Date addedDate = new Date();
                            Date updatedDate = new Date();
                            int xx = 0;
                            if (status.equals("N")) {
                                UmUserHasInterfaceComponent addComponentToUser = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().addUserHasInterfaceComponent(session, selectedUser.getId(), selectedComponent.getId(), addedDate, updatedDate, STATIC_DATA_MODEL.PMACTIVE, activeUser, activeUser);
                                if (addComponentToUser != null) {
                                    UmUserHasInterfaceTopic checkUserHasInterfaceTopicExist = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().getAllInterfacetopicAndUser(session, selectedUser.getId(), selectedTopic.getId());
                                    if (checkUserHasInterfaceTopicExist == null) {
//                                            add user has interface component
                                        xx++;
                                        UmUserHasInterfaceTopic addUserHasInterfaceTopic = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().saveInterfacetopicHasUser(session, selectedUser.getId(), selectedTopic.getId(), STATIC_DATA_MODEL.PMACTIVE, xx, addedDate, updatedDate, activeUser, activeUser);
                                        String saveinterfaceTopicHasUserSessionActivity = selectedTopic.getTopicName()+ " Interface Topic has been Assigned to " + selectedUser.getFirstName()+ " by " + activeUser.getFirstName()+ " on " + new Date();
                                        SmSessionActivity saveInterfaceTopicHasUserSessionActivityt = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, saveinterfaceTopicHasUserSessionActivity, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERHASITOPICSAVE, activeSession, activeUser);
                                    }
                                    String saveintCompoToUserContent = addComponentToUser.getPmInterfaceComponent().getComponentName() + " Interface Component has been Assigned To " + selectedUser.getFirstName()+ " by " + activeUser.getFirstName()+ " on " + new Date();
                                    SmSessionActivity sessionActivityToComponentAssignUser = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, saveintCompoToUserContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERHASICOMPONENTSAVE, activeSession, activeUser);
                                    resaltMap.put("result", "1");
                                    resaltMap.put("displayMessage", "Component Assign Successfull !");
                                } else {
                                    resaltMap.put("result", "0");
                                    resaltMap.put("displayMessage", "Component Assign Unsuccessfull !");
                                }
                            }
                            if (status.equals("S")) {
                                int deleteComponent = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().deleteUserHasInterfaceComponentByUserId(session, selectedUser.getId(), selectedComponent.getId());
                                if (deleteComponent > 0) {
//                                    check user has interface component by userrole id and topic id
                                    List<Object[]> checkUsersHasComponentByTopicAndUserId = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().searchusersHasComponenntsByUserIdAndInterfaceTopicId(session, selectedTopic.getId(), selectedUser.getId());
                                    if (checkUsersHasComponentByTopicAndUserId.isEmpty()) {
//                                        delete interfacetopic has user records by topic id and user id
                                        int deleteUInterfaceTopicHasUserRecord = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().deleteInterfaceTopicHasUserByUserAndTopicId(session, selectedUser.getId(), selectedTopic.getId());
                                        if (deleteUInterfaceTopicHasUserRecord > 0) {
//                                            save session activity to delete component by user 
                                            String removeintCompoToUserContent = selectedComponent.getComponentName() + " Interface Component Has been Removed  From  =" + selectedUser.getFirstName()+ " by " + activeUser.getFirstName()+ new Date();
                                            SmSessionActivity sessionActivityToComponentRemoveFromUser = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, removeintCompoToUserContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.USERHASICOMPONENTREMOVE, activeSession, activeUser);
                                            String removeintTopicToUserHasUsersRoleContent = selectedTopic.getTopicName()+ " Interface Topic Has been Removed  From " + selectedUser.getFirstName()+ " by " + activeUser.getFirstName()+ new Date();
                                            SmSessionActivity sessionActivityToInterfaceTopicRemoveUserRoleHasUsers = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, removeintTopicToUserHasUsersRoleContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.USERHASICOMPONENTREMOVE, activeSession, activeUser);
                                            resaltMap.put("result", "1");
                                            resaltMap.put("displayMessage", "Component Remove Successfull !");
                                        } else {
                                            resaltMap.put("result", "0");
                                            resaltMap.put("displayMessage", "Component Remove Unsuccessfull !");
                                        }
                                    } else {
                                        //Save session activity
                                        String removeintCompoToUserContent = selectedComponent.getComponentName() + " Interface Component Has been Removed  From  =" + selectedUser.getFirstName()+ " by " + activeUser.getFirstName()+ new Date();
                                        SmSessionActivity sessionActivityToComponentRemoveFromUser = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, removeintCompoToUserContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.USERHASICOMPONENTREMOVE, activeSession, activeUser);
                                        resaltMap.put("result", "1");
                                        resaltMap.put("displayMessage", "Component Remove Successfull !");
                                    }
                                } else {
                                    resaltMap.put("result", "0");
                                    resaltMap.put("displayMessage", "Component Remove Unsuccessfull !");
                                }
                            }
                        } else {
                            resaltMap.put("result", "0");
                            resaltMap.put("displayMessage", "Component Or User Not Found");
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
