/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.privilegeManagement;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.PmInterfaceComponent;
import com.ring.db.PmInterfaceTopic;
import com.ring.db.PmUserRole;
import com.ring.db.PmUserRoleHasInterfaceComponent;
import com.ring.db.SmSession;
import com.ring.db.SmSessionActivity;
import com.ring.db.UmUser;
import com.ring.db.UmUserHasInterfaceComponent;
import com.ring.db.UmUserHasInterfaceTopic;
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
@WebServlet(name = "privilageManagement_addOrDeleteUserRoleHasAllComponentOneClick", urlPatterns = {"/privilageManagement_addOrDeleteUserRoleHasAllComponentOneClick"})
public class privilageManagement_addOrDeleteUserRoleHasAllComponentOneClick extends HttpServlet {

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
        Session session = com.ring.connection.Connection.getSessionFactory().openSession();
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
                    String interfaceTopic = request.getParameter("interfaceTopic");
                    String status = request.getParameter("status");
//                    System.out.println("u role = " + userRole);
//                    System.out.println("interface topic = " + interfaceTopic);
//                    System.out.println("status = " + status);
                    if (userRole.equals("")) {
                        resaltMap.put("result", "0");
                        resaltMap.put("displayMessage", "User Role Not Found  !!!");
                    } else if (interfaceTopic.equals("")) {
                        resaltMap.put("result", "0");
                        resaltMap.put("displayMessage", "Component Not Found  !!!");
                    } else if (status.equals("")) {
                        resaltMap.put("result", "0");
                        resaltMap.put("displayMessage", "Status Not Found  !!!");
                    } else {
                        int uRole = Integer.parseInt(userRole);
                        int interfaceTopicId = Integer.parseInt(interfaceTopic);
                        //Get Active session object
                        SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
//                        selected user Role
                        PmUserRole selectedUserRole = (PmUserRole) session.load(PmUserRole.class, uRole);
//                        selected interfaceTopic 
                        PmInterfaceTopic selectedTopic = (PmInterfaceTopic) session.load(PmInterfaceTopic.class, interfaceTopicId);
                        Date addedDate = new Date();
                        Date updatedDate = new Date();
                        boolean valied1 = false;
                        boolean valied2 = false;
                        boolean valied3 = false;
                        boolean valied8 = false;
                        if (status.equals("N")) {
//                            get interface component by topic id
                            List<PmInterfaceComponent> getComponentByTopic = new com.ring.privilegeManagementModel.PMS_PM_Interface_Component().getComponentByInterfaceTopic(session, selectedTopic.getId());
                            if (!getComponentByTopic.isEmpty()) {
                                for (PmInterfaceComponent umInterfacecomponentsMi7 : getComponentByTopic) {
//                                    check user role has interface component esixts
                                    PmUserRoleHasInterfaceComponent checkUserRoleHasCompId = new com.ring.privilegeManagementModel.PMS_PM_User_Role_Has_Interface_Component().checlUserRoleHasComponent(session, selectedUserRole.getId(), umInterfacecomponentsMi7.getId());
                                    if (checkUserRoleHasCompId == null) {
//                                        add user role has interface compopnent
                                        PmUserRoleHasInterfaceComponent addComponentToUserRole = new com.ring.privilegeManagementModel.PMS_PM_User_Role_Has_Interface_Component().addUserRoleHasInterfaceComponent(session, selectedUserRole.getId(), umInterfacecomponentsMi7.getId(), updatedDate, updatedDate, STATIC_DATA_MODEL.PMACTIVE, activeUser, activeUser);
                                        if (addComponentToUserRole != null) {
                                            int xx = 0;
//                                         load users by user role
                                            List<UmUser> loadAllUsersBYUserRole = new com.ring.userManagementModel.UMS_UM_User().searchUsersByStatusAndUserRole(session, selectedUserRole.getId(), STATIC_DATA_MODEL.ACTIVE);
                                            if (!loadAllUsersBYUserRole.isEmpty()) {
                                                for (UmUser usersByURole : loadAllUsersBYUserRole) {
//                                                    add interfaces to users in that user role   
                                                    UmUserHasInterfaceComponent addSelectedUserToComponent = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().addUserHasInterfaceComponent(session, usersByURole.getId(), umInterfacecomponentsMi7.getId(), updatedDate, updatedDate, STATIC_DATA_MODEL.PMACTIVE, activeUser, activeUser);
//                                        CHECK user has interface topic exist
                                                    UmUserHasInterfaceTopic checkUserHasInterfaceTopicExist = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().getAllInterfacetopicAndUser(session, usersByURole.getId(), interfaceTopicId);
                                                    if (checkUserHasInterfaceTopicExist == null) {
//                                            add user has interface component
                                                        xx++;
                                                        UmUserHasInterfaceTopic addUserHasInterfaceHas = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().saveInterfacetopicHasUser(session, usersByURole.getId(), selectedTopic.getId(), (byte) 2, xx, updatedDate, updatedDate, activeUser, activeUser);
//                                                        save interface topic top user session activity
                                                        String saveinterfaceTopicHasUserSessionActivity = selectedTopic.getTopicName()+ " Interface Topic has been Assigned to " + usersByURole.getFirstName()+ " by " + activeUser.getFirstName()+ " on " + new Date();
                                                        SmSessionActivity saveInterfaceTopicHasUserSessionActivityt = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, saveinterfaceTopicHasUserSessionActivity, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERHASITOPICSAVE, activeSession, activeUser);
                                                    }
//                                                      Save user has interface component add session activity
                                                    String saveintCompoToUserContent = umInterfacecomponentsMi7.getComponentName() + " Interface Component has been Assigned To " + usersByURole.getFirstName()+ " by " + activeUser.getFirstName()+ " on " + new Date();
                                                    SmSessionActivity sessionActivityToComponentAssignUser = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, saveintCompoToUserContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERHASICOMPONENTSAVE, activeSession, activeUser);
                                                    if (sessionActivityToComponentAssignUser != null) {
                                                        valied1 = true;
                                                    }
                                                }
                                            } else {
                                                valied8 = true;
                                            }
                                        }
                                    } else {
                                        int xx = 0;
//                                         add interfaces to users in that user role   
                                        List<UmUser> loadAllUsersBYUserRole = new com.ring.userManagementModel.UMS_UM_User().searchUsersByStatusAndUserRole(session, selectedUserRole.getId(), STATIC_DATA_MODEL.ACTIVE);
                                        if (!loadAllUsersBYUserRole.isEmpty()) {
                                            for (UmUser usersByURole : loadAllUsersBYUserRole) {
//                                          add interfaces to users in that user role   
                                                UmUserHasInterfaceComponent addSelectedUserToComponent = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().addUserHasInterfaceComponent(session, usersByURole.getId(), umInterfacecomponentsMi7.getId(), updatedDate, updatedDate, STATIC_DATA_MODEL.PMACTIVE, activeUser, activeUser);
//                                        check user has interface topic exist
                                                UmUserHasInterfaceTopic checkUserHasInterfaceTopicExist = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().getAllInterfacetopicAndUser(session, usersByURole.getId(), interfaceTopicId);
                                                if (checkUserHasInterfaceTopicExist == null) {
//                                            add user has interface component
                                                    xx++;
                                                    UmUserHasInterfaceTopic addUserHasInterfaceHas = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().saveInterfacetopicHasUser(session, usersByURole.getId(), selectedTopic.getId(), (byte) 2, xx, updatedDate, updatedDate, activeUser, activeUser);
//                                                        save interface topic top user session activity
                                                    String saveinterfaceTopicHasUserSessionActivity = selectedTopic.getTopicName()+ " Interface Topic has been Assigned to " + usersByURole.getFirstName()+ " by " + activeUser.getFirstName()+ " on " + new Date();
                                                    SmSessionActivity saveInterfaceTopicHasUserSessionActivityt = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, saveinterfaceTopicHasUserSessionActivity, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERHASITOPICSAVE, activeSession, activeUser);
                                                }
                                                //                                                      Save user has interface component add session activity
                                                String saveintCompoToUserContent = umInterfacecomponentsMi7.getComponentName() + " Interface Component has been Assigned To " + usersByURole.getFirstName()+ " by " + activeUser.getFirstName()+ " on " + new Date();
                                                SmSessionActivity sessionActivityToComponentAssignUser = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, saveintCompoToUserContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERHASICOMPONENTSAVE, activeSession, activeUser);
                                                if (sessionActivityToComponentAssignUser != null) {
                                                    valied1 = true;
                                                }
                                            }
                                        } else {
                                            valied8 = true;
                                        }
                                    }
                                    if (valied1) {
//                                        add interface component to user role save session activity
                                        String saveCompoToUserRoleContent = umInterfacecomponentsMi7.getComponentName() + " Interface Component has been Assigned To " + selectedUserRole.getUserRoleName() + " by " + activeUser.getFirstName()+ " on " + new Date();
                                        SmSessionActivity sessionActivityToComponentAssignUserRole = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, saveCompoToUserRoleContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERROLEHASICOMPONENTSAVE, activeSession, activeUser);
                                        resaltMap.put("result", "1");
                                        resaltMap.put("displayMessage", "Interfaces Assign Successfull !");
                                    } else if (valied8) {
//                                        add interface component to user role save session activity
                                        String saveCompoToUserRoleContent = umInterfacecomponentsMi7.getComponentName() + " Interface Component has been Assigned To " + selectedUserRole.getUserRoleName() + " by " + activeUser.getFirstName()+ " on " + new Date();
                                        SmSessionActivity sessionActivityToComponentAssignUserRole = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, saveCompoToUserRoleContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERROLEHASICOMPONENTSAVE, activeSession, activeUser);
                                        resaltMap.put("result", "1");
                                        resaltMap.put("displayMessage", "Interfaces Assign Successfull ! But there are no users assigned to the user role !");
                                    } else {
                                        resaltMap.put("result", "0");
                                        resaltMap.put("displayMessage", "Interface Assign Unsuccessfull !");
                                    }
                                }
                            } else {
                                resaltMap.put("result", "0");
                                resaltMap.put("displayMessage", "Interfaces Not Found !!!");
                            }
                        }
                        if (status.equals("S")) {
                            List<PmInterfaceComponent> getComponentByTopic = new com.ring.privilegeManagementModel.PMS_PM_Interface_Component().getComponentByInterfaceTopic(session, selectedTopic.getId());
                            if (!getComponentByTopic.isEmpty()) {
                                for (PmInterfaceComponent umInterfacecomponentsMi7 : getComponentByTopic) {
//                                    deleteUserRole has Interfaces
                                    PmUserRoleHasInterfaceComponent deleteComponent = new com.ring.privilegeManagementModel.PMS_PM_User_Role_Has_Interface_Component().removeUserRoleHasComponent(session, selectedUserRole.getId(), umInterfacecomponentsMi7.getId());
                                    if (deleteComponent != null) {
//                                         remove interface component from user role save session activity
                                        String removeintCompoToUserRoleContent = deleteComponent.getPmInterfaceComponent().getComponentName() + " Interface Component Has been Removed  From " + selectedUserRole.getUserRoleName() + " by " + activeUser.getFirstName()+ new Date();
                                        SmSessionActivity sessionActivityToComponentRemoveUserRole = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, removeintCompoToUserRoleContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.USERROLEHASICOMPONENTREMOVE, activeSession, activeUser);

                                        List<UmUser> loadAllUsersBYUserRole = new com.ring.userManagementModel.UMS_UM_User().searchUsersByStatusAndUserRole(session, selectedUserRole.getId(), STATIC_DATA_MODEL.ACTIVE);
                                        if (!loadAllUsersBYUserRole.isEmpty()) {
//                                deleteUserHasComponents
                                            int checkComponentDeleted = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().deleteUserHasInterfaceComponentByUserRoleId(session, selectedUserRole.getId(), umInterfacecomponentsMi7.getId());
//                                            System.out.println("size =" + checkComponentDeleted);
                                            if (checkComponentDeleted > 0) {
                                                for (UmUser umUserMi7 : loadAllUsersBYUserRole) {
//                                                save session activity to delete component by user role has users
                                                    String removeintCompoToUserHasUsersRoleContent = umInterfacecomponentsMi7.getComponentName() + " Interface Component Has been Removed  From  =" + umUserMi7.getFirstName()+ " by " + activeUser.getFirstName()+ new Date();
                                                    SmSessionActivity sessionActivityToComponentRemoveUserRoleHasUsers = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, removeintCompoToUserHasUsersRoleContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.USERHASICOMPONENTREMOVE, activeSession, activeUser);
                                                }
                                                valied2 = true;
                                            }
                                        } else {
                                            valied3 = true;
                                        }
                                    } else {
                                        resaltMap.put("result", "0");
                                        resaltMap.put("displayMessage", "Interfaces Remove Unsuccessfull !");
                                    }
                                }
                                if (valied2) {
//                                    check user has interface component by userrole id and topic id
                                    List<Object[]> checkUsersHasComponentByTopicAndURole = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().searchusersHasComponenntsByUserRoleIdAndInterfaceTopicId(session, selectedTopic.getId(), selectedUserRole.getId());
//                                    //System.out.println("listSize = " + checkUsersHasComponentByTopicAndURole.size());
                                    if (checkUsersHasComponentByTopicAndURole.isEmpty()) {
//                                                delete interfacetopic has user records by topic id and userrole id
                                        int deleteRecords = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().deleteInterfaceTopicHasUserByUserRoleIdAndTopicId(session, selectedUserRole.getId(), selectedTopic.getId());
//                                        //System.out.println("delete records size =" + deleteRecords);
                                        if (deleteRecords > 0) {
                                            List<UmUser> loadAllUsersBYUserRole2 = new com.ring.userManagementModel.UMS_UM_User().searchUsersByStatusAndUserRole(session, selectedUserRole.getId(), STATIC_DATA_MODEL.ACTIVE);
                                            if (!loadAllUsersBYUserRole2.isEmpty()) {
                                                for (UmUser umUser2 : loadAllUsersBYUserRole2) {
//                                                    save session activity to delete interface topics by user role has users
                                                    String removeintTopicToUserHasUsersRoleContent = selectedTopic.getTopicName()+ " Interface Topic Has been Removed  From " + umUser2.getFirstName()+ " by " + activeUser.getFirstName()+ new Date();
                                                    SmSessionActivity sessionActivityToInterfaceTopicRemoveUserRoleHasUsers = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(session, removeintTopicToUserHasUsersRoleContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.USERHASICOMPONENTREMOVE, activeSession, activeUser);
                                                }
                                            }
                                            resaltMap.put("result", "1");
                                            resaltMap.put("displayMessage", " Interfaces Remove From User Role And Users Successfull !");
                                        } else {
                                            resaltMap.put("result", "0");
                                            resaltMap.put("displayMessage", "Interfaces Remove Unsuccessfull !");
                                        }
                                    } else {
                                        resaltMap.put("result", "1");
                                        resaltMap.put("displayMessage", "Interfaces Remove From User Role And Users Successfull !");
                                    }
                                } else {
                                    resaltMap.put("result", "0");
                                    resaltMap.put("displayMessage", "This Interface Assigned to Specific Users Only. Please Remove Interfaces From Those Users First !");
                                }
                                if (valied3) {
                                    resaltMap.put("result", "1");
                                    resaltMap.put("displayMessage", "Interfaces Remove From User Role Successfull !");
                                }
                            } else {
                                resaltMap.put("result", "0");
                                resaltMap.put("displayMessage", "Interfaces Not Found !!!");
                            }
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
