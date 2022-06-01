/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.userManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.configurationModel.USER_GETNICDETAILS;
import com.it.db.PmInterfaceTopic;
import com.it.db.PmUserRole;
import com.it.db.PmUserRoleHasInterfaceComponent;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.UmUser;
import com.it.db.UmUserHasInterfaceComponent;
import com.it.db.UmUserHasInterfaceTopic;
import com.it.fileUploadManagementModel.fileUpload_Management;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.simple.JSONObject;

/**
 *
 * @author JOY
 */
@WebServlet(name = "userManagement_updateUserProfile", urlPatterns = {"/userManagement_updateUserProfile"})
public class userManagement_updateUserProfile extends HttpServlet {

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
//        Logger logger = Logger.getLogger(this.getClass().getName());
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
                    String selectedUserForUp = "";
                    String fName = "";
                    String lName = "";
                    String nic = "";
                    String mobile = "";
                    String email = "";
                    String maritalStatus = "";
                    String userRole = "";
                    String empId = "";
                    FileItem userImage = null;
                    FileItemFactory factory = new DiskFileItemFactory();
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    List<FileItem> items = upload.parseRequest(request);
                    for (FileItem element : items) {
                        FileItem fileitem = (FileItem) element;
                        if (fileitem.isFormField()) {
                            if (fileitem.getFieldName().equals("fNameU")) {
                                fName = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("lNameU")) {
                                lName = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("nicU")) {
                                nic = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("mobileU")) {
                                mobile = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("emailU")) {
                                email = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("maritalStatusU")) {
                                maritalStatus = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("userRoleU")) {
                                userRole = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("empIdU")) {
                                empId = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("selectedUserForUp")) {
                                selectedUserForUp = fileitem.getString();
                            }
                        } else {
                            if (fileitem.getFieldName().equals("propicU")) {
                                String extention = new File(element.getName()).getName();
                                if (!extention.equals("")) {
                                    userImage = element;
                                }
                            }
                        }
                    }
                    //Get Active session object
                    SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                    int selectUsr = 0;
                    int useRoleNumber = 0;
                    if (!userRole.isEmpty()) {
                        useRoleNumber = Integer.parseInt(userRole);
                    }
                    if (!selectedUserForUp.isEmpty()) {
                        selectUsr = Integer.parseInt(selectedUserForUp);
                    }
                    if (userImage != null) {
//                        if (!userImage.getContentType().equals("image/jpeg")) {
//                            resultMap.put("result", "0");
//                            resultMap.put("displayMessage", "Select JPG Image File");
//                        } else {
                            valied1 = true;
//                        }
                    } else {
                        valied1 = true;
                    }
                    if (valied1) {
//                            selected user for update 
                        UmUser selectedUserFrUp = new com.it.userManagementModel.UMS_UM_User().getUserById(ses, selectUsr);
                        if (selectedUserFrUp == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "User  Not Found");
                        } else {
//                        selected user role
                            PmUserRole selectedUserRole = new com.it.privilegeManagementModel.PMS_PM_User_Role().getUserRoleById(ses, useRoleNumber);
                            if (selectedUserRole == null) {
                                resultMap.put("result", "0");
                                resultMap.put("displayMessage", "User Role Not Found");
                            } else {

//                                check user user role changed or not
                                if (selectedUserFrUp.getPmUserRole().getId() != selectedUserRole.getId()) {
                                    //                            remove user current component
                                    List<UmUserHasInterfaceComponent> loadUserHasAllComponent = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserId(ses, selectedUserFrUp.getId());
                                    if (!loadUserHasAllComponent.isEmpty()) {
                                        for (UmUserHasInterfaceComponent compoByUserId : loadUserHasAllComponent) {
                                            UmUserHasInterfaceComponent removeUserHasComponent = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().removeUserHasComponent(ses, selectedUserFrUp.getId(), compoByUserId.getPmInterfaceComponent().getId());
                                            String removeintCompoToUserContent = compoByUserId.getPmInterfaceComponent().getComponentName() + " Interface Component Has been Removed  From  =" + selectedUserFrUp.getFirstName() + " by " + activeUser.getFirstName() + new Date();
                                            SmSessionActivity sessionActivityToComponentRemoveFromUser = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, removeintCompoToUserContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.USERHASICOMPONENTREMOVE, selectedUserFrUp.getId(), activeSession, activeUser);
                                        }
                                    }
                                    //                            remove user current interface topics
                                    List<UmUserHasInterfaceTopic> ift = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().getAllInterfacetopicByUser(ses, selectedUserFrUp.getId());
                                    if (!ift.isEmpty()) {
                                        for (UmUserHasInterfaceTopic umIn : ift) {
                                            UmUserHasInterfaceTopic removeInterfaceTopic = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().removeInterfaceTopicHasUser(ses, selectedUserFrUp.getId(), umIn.getPmInterfaceTopic().getId());
                                            String removeintTopicToUserHasUsersRoleContent = umIn.getPmInterfaceTopic().getTopicName() + " Interface Topic Has been Removed  From " + selectedUserFrUp.getFirstName() + " by " + activeUser.getFirstName() + new Date();
                                            SmSessionActivity sessionActivityToInterfaceTopicRemoveUserRoleHasUsers = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, removeintTopicToUserHasUsersRoleContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.USERHASICOMPONENTREMOVE, selectedUserFrUp.getId(), activeSession, activeUser);
                                        }
                                    }
//                                        add new user role has component to user
                                    int xx = 0;
                                    List<PmUserRoleHasInterfaceComponent> loadUserRoleHasAllComponent = new com.it.privilegeManagementModel.PMS_PM_User_Role_Has_Interface_Component().loadUserRoleHasComponent(ses, selectedUserRole.getId());
                                    if (!loadUserRoleHasAllComponent.isEmpty()) {
                                        for (PmUserRoleHasInterfaceComponent compoByURole : loadUserRoleHasAllComponent) {
                                            PmInterfaceTopic selectedTopic = (PmInterfaceTopic) ses.load(PmInterfaceTopic.class, compoByURole.getPmInterfaceComponent().getPmInterface().getPmInterfaceTopic().getId());
                                            UmUserHasInterfaceComponent addSelectedUserToComponent = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().addUserHasInterfaceComponent(ses, selectedUserFrUp.getId(), compoByURole.getPmInterfaceComponent().getId(), addedDate, addedDate, STATIC_DATA_MODEL.PMACTIVE, activeUser, activeUser);
                                            String saveintCompoToUserContent = addSelectedUserToComponent.getPmInterfaceComponent().getComponentName() + " Interface Component has been Assigned To " + selectedUserFrUp.getFirstName() + " by " + activeUser.getFirstName() + " on " + new Date();
                                            SmSessionActivity sessionActivityToComponentAssignUser = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveintCompoToUserContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERHASICOMPONENTSAVE, selectedUserFrUp.getId(), activeSession, activeUser);
                                            //                              load user has interface topic exist
                                            UmUserHasInterfaceTopic checkUserHasInterfaceTopicExist = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().getAllInterfacetopicAndUser(ses, selectedUserFrUp.getId(), selectedTopic.getId());
                                            if (checkUserHasInterfaceTopicExist == null) {
//                                            add user has interface component
                                                xx++;
                                                UmUserHasInterfaceTopic addUserHasInterfaceHas = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().saveInterfacetopicHasUser(ses, selectedUserFrUp.getId(), selectedTopic.getId(), STATIC_DATA_MODEL.PMACTIVE, xx, addedDate, addedDate, activeUser, activeUser);
                                                String saveinterfaceTopicHasUserSessionActivity = selectedTopic.getTopicName() + " Interface Topic has been Assigned to " + selectedUserFrUp.getFirstName() + " by " + activeUser.getFirstName() + " on " + new Date();
                                                SmSessionActivity saveInterfaceTopicHasUserSessionActivityt = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveinterfaceTopicHasUserSessionActivity, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.USERHASITOPICSAVE, selectedUserFrUp.getId(), activeSession, activeUser);
                                            }
                                        }
                                    }
                                }
                                //                                    get gender and birthday using NIC
                                String[] parts = USER_GETNICDETAILS.getDOBandGenderByNIC(nic).split("#");
                                DateFormat format = new SimpleDateFormat("yyy-MM-dd");
                                Date dob = format.parse(parts[0]);
                                byte gndr = (byte) Integer.parseInt(parts[1]);
                                boolean gender = true;
                                if (gndr == 0) {
                                    gender = false;
                                }
//                            update  user profile
                                UmUser updateUserProfile = new com.it.userManagementModel.UMS_UM_User().updateUserProfile(ses, fName, lName, STATIC_DATA_MODEL.PMACTIVE, nic, dob, mobile, email, gndr, maritalStatus, empId, updatedDate, selectedUserRole, activeUser.getId(), selectedUserFrUp);
                                if (updateUserProfile != null) {
                                    //Save session activity
                                    String updateUserSessionActivityContent = updateUserProfile.getFirstName() + "  User has been Updated by " + activeUser.getFirstName() + " on " + addedDate;
                                    SmSessionActivity sessionActivityToAddNewUser = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, updateUserSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.USERMANAGEMENT, updateUserProfile.getId(), activeSession, activeUser);
                                    if (sessionActivityToAddNewUser != null) {
                                        if (userImage != null) {
                                            String QueueBackGroundEmage = "User Profile Image/" + updateUserProfile.getFirstName() + " - " + updateUserProfile.getId();
                                            new fileUpload_Management().createFolder(fileUpload_Management.fileUploadingPath, QueueBackGroundEmage);
                                            String saveQueueBgImage = new com.it.fileUploadManagementModel.fileUpload_Management().fileItem(userImage, QueueBackGroundEmage);
                                            updateUserProfile.setRemark1(saveQueueBgImage);
                                            ses.update(updateUserProfile);
                                        }
                                        tr.commit();
                                        resultMap.put("result", "1");
                                        resultMap.put("displayMessage", "Save Success...");
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
//            logger.error(e.toString());
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
