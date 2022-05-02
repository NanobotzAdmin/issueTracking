/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.locationManagement;

import com.ring.configurationModel.EMAIL_MODEL;
import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.LmLocationHistory;
import com.ring.db.LmLocations;
import com.ring.db.LmLocationsHasUmUser;
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
@WebServlet(name = "locationManagement_addLocation", urlPatterns = {"/locationManagement_addLocation"})
public class locationManagement_addLocation extends HttpServlet {

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
                    String locationName = request.getParameter("locationName");
                    String address = request.getParameter("address");
                    String mobile = request.getParameter("mobile");
                    String landnumber = request.getParameter("landnumber");
                    int branchManager = Integer.parseInt(request.getParameter("branchManager"));
                    if (locationName.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Location Name.");
                    } else if (address.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Location Addreess.");
                    } else if (mobile.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Location Mobile Number.");
                    } else if (landnumber.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Location Land Number.");
                    } else if (branchManager <= 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Select Branch Manager");
                    } else {
//                        get branch manager
                        UmUser selectedBranchManager = (UmUser) ses.load(UmUser.class, branchManager);
                        if (selectedBranchManager == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Branch Manager not Found.");
                        } else {
//                            check location name exists
                            LmLocations checkName = new com.ring.locationManagementModel.LMS_LM_Locations().checkNameExists(ses, locationName);
                            if (checkName != null) {
                                resultMap.put("result", "0");
                                resultMap.put("displayMessage", "Branch Name Exists.");
                            } else {
//                            check address exists
                                LmLocations checkAddress = new com.ring.locationManagementModel.LMS_LM_Locations().checkAddressExists(ses, address);
                                if (checkAddress != null) {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Branch Address Exists.");
                                } else {
//                            save location details
                                    LmLocations addNewLocation = new com.ring.locationManagementModel.LMS_LM_Locations().saveLocation(ses, locationName, address, mobile, landnumber, STATIC_DATA_MODEL.ISACTIVE, updatedDate, updatedDate, selectedBranchManager, activeUser.getId(), activeUser.getId());
                                    if (addNewLocation != null) {
                                        //Get Active session object
                                        SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                        //Save session activity
                                        String saveLocationSessionActivityContent = addNewLocation.getLocationName() + " Location has been Saved by " + activeUser.getFirstName() + " on " + addedDate;
                                        SmSessionActivity sessionActivityToAddLocation = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, saveLocationSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.LOCATIONSAVE, activeSession, activeUser);
                                        if (sessionActivityToAddLocation != null) {
//                                    save location history
                                            String locationHistoryDescription = addNewLocation.getLocationName() + " Location Saved";
                                            LmLocationHistory addLocationHistory = new com.ring.locationManagementModel.LMS_LM_Location_History().saveLocationHistory(ses, locationHistoryDescription, updatedDate, updatedDate, addNewLocation, activeUser.getId(), activeUser.getId());
                                            if (addLocationHistory != null) {
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
//                                                    add user to location
                                                            LmLocationsHasUmUser addUsersToLocation = new com.ring.locationManagementModel.LMS_LM_Locations_Has_Um_User().addLocationHasUsers(ses, addNewLocation.getId(), selecUser.getId(), STATIC_DATA_MODEL.ISACTIVE, updatedDate, updatedDate, activeUser.getId(), activeUser.getId());
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
                                    } else {
                                        resultMap.put("result", "0");
                                        resultMap.put("displayMessage", "Error...");
                                    }
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
