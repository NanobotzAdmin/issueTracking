/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.queueManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.QmCategories;
import com.it.db.QmCategoriesHasUser;
import com.it.db.QmQueue;
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
@WebServlet(name = "queueManagement_updateCategory", urlPatterns = {"/queueManagement_updateCategory"})
public class queueManagement_updateCategory extends HttpServlet {

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
                    String categoryNameU = request.getParameter("categoryNameU");
                    String categoryDescriptionU = request.getParameter("categoryDescriptionU");
                    int categoryIdU = Integer.parseInt(request.getParameter("categoryIdU"));
                    int queueToAddCategoryU = Integer.parseInt(request.getParameter("queueToAddCategoryU"));
                    if (categoryIdU <= 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Category Not Found");
                    }else if (queueToAddCategoryU <= 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Queue Not Found");
                    } else if (categoryNameU.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Category Name.");
                    } else if (categoryDescriptionU.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Category Description.");
                    } else {
//                        selected Category
                        QmCategories selectedCategory = (QmCategories) ses.load(QmCategories.class, categoryIdU);
                        if (selectedCategory == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Category Not Found");
                        } else {
                            if (!selectedCategory.getCategoryName().equals(categoryNameU)) {
//                                check updated Category name exists
                                QmCategories checkNameExists = new com.it.queueManagementModel.QMS_QM_Categories().checkNameExists(ses, categoryNameU);
                                if (checkNameExists != null) {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Category Name Exists.");
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
                                
//                                selected Queue 
                                QmQueue selectedQueue = (QmQueue)ses.load(QmQueue.class,queueToAddCategoryU);
                                    if(selectedQueue != null){
//                            update Category details
                                    QmCategories updateCategory = new com.it.queueManagementModel.QMS_QM_Categories().updateCategory(ses, categoryNameU, categoryDescriptionU, STATIC_DATA_MODEL.PMACTIVE, updatedDate, selectedCategory, selectedQueue,activeUser.getId());
                                    if (updateCategory != null) {
                                        //Get Active session object
                                        SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                        //Save session activity
                                        String saveCategorySessionActivityContent = updateCategory.getCategoryName()+ " Category has been Updated by " + activeUser.getFirstName() + " on " + addedDate;
                                        SmSessionActivity sessionActivityToUpdateCategory = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, saveCategorySessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.CATEGORYUPDATE, activeSession, activeUser);
                                        if (sessionActivityToUpdateCategory != null) {
                                           int deleteCategoryHasUsers = new com.it.queueManagementModel.QMS_QM_Categories_Has_User().deleteCategoryHasUsersByCategoryId(ses, selectedCategory.getId());
//                                        add location has users
                                            org.json.JSONObject jObj = new org.json.JSONObject(request.getParameter("usersDetails"));
                                            org.json.JSONArray acData = jObj.getJSONArray("AC");
                                            int r = acData.length();
                                            if (r > 0) {
                                                for (int i = 0; i < r; ++i) {
                                                    org.json.JSONObject data = acData.getJSONObject(i);
                                                    int userId = Integer.parseInt(data.getString("userId"));
                                                    UmUser selecUser = (UmUser) ses.load(UmUser.class, userId);
                                                    if (selecUser != null) {
//                                                    add user to Category
                                                            QmCategoriesHasUser addUsersToCategory = new com.it.queueManagementModel.QMS_QM_Categories_Has_User().addCategoryHasUsers(ses, selectedCategory.getId(), selecUser.getId(), STATIC_DATA_MODEL.PMACTIVE, addedDate, updatedDate, activeUser.getId(), activeUser.getId());
                                                        
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
                                    }else{
                                          resultMap.put("result", "0");
                                        resultMap.put("displayMessage", "Queue Not Found");
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
