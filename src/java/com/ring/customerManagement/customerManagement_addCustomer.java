/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.customerManagement;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.LmLocations;
import com.ring.db.SmSession;
import com.ring.db.SmSessionActivity;
import com.ring.db.UmCustomer;
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
@WebServlet(name = "customerManagement_addCustomer", urlPatterns = {"/customerManagement_addCustomer"})
public class customerManagement_addCustomer extends HttpServlet {

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
                    String fullName = request.getParameter("fullName");
                    String address = request.getParameter("address");
                    int loadBranches = Integer.parseInt(request.getParameter("loadBranches"));
                    String mobile = request.getParameter("mobile");
                    String mode = request.getParameter("mode");
                    int otpCode = Integer.parseInt(request.getParameter("otpCode"));
                    byte isverify = Byte.parseByte(request.getParameter("isverify"));
                    String email = request.getParameter("email");
                    String nic = request.getParameter("nic");
                    if (isverify == 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Verify Mobile Number");
                    } else {
                        LmLocations selectedBranch = null;
//                        select branch
                        if (loadBranches > 0) {
                            selectedBranch = (LmLocations) ses.load(LmLocations.class, loadBranches);
                        }
//                        check NIC exists
                        UmCustomer checkNIC = new com.ring.customerManagementModel.CMS_UM_Customer().checkCustomerNic(ses, nic);
                        if (checkNIC != null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "NIC Already Exist");
                        } else {
//                            check email exist
                            UmCustomer checkEmail = new com.ring.customerManagementModel.CMS_UM_Customer().checkCustomerEmail(ses, email);
                            if (checkEmail != null) {
                                resultMap.put("result", "0");
                                resultMap.put("displayMessage", "Email Already Exist");
                            } else {
//                                check customer name
                                UmCustomer checkName = new com.ring.customerManagementModel.CMS_UM_Customer().checkCustomerName(ses, fullName);
                                if (checkName != null) {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Name Already Exist");
                                } else {
//                                    check mobile number
                                    UmCustomer checkNumber = new com.ring.customerManagementModel.CMS_UM_Customer().checkCustomerPhoneNumber(ses, mobile);
                                    if (checkNumber != null) {
                                        resultMap.put("result", "0");
                                        resultMap.put("displayMessage", "Mobile Number Already Exist");
                                    } else {
//                            save new customer
                                        UmCustomer addNewCustomer = new com.ring.customerManagementModel.CMS_UM_Customer().saveNewCustomer(ses, fullName, address, STATIC_DATA_MODEL.PMACTIVE, mobile, isverify, otpCode, nic, email, addedDate, updatedDate, selectedBranch, activeUser.getId(), activeUser.getId());
                                        if (addNewCustomer != null) {
                                            //Get Active session object
                                            SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                            //Save session activity
                                            String saveNewCustomerSessionActivityContent = addNewCustomer.getCustomerName() + " New Customer has been Saved by " + activeUser.getFirstName() + " on " + addedDate;
                                            SmSessionActivity sessionActivityToAddNewCustomer = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveNewCustomerSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.CUSTOMERMANAGEMENT, addNewCustomer.getId(), activeSession, activeUser);
                                            if (sessionActivityToAddNewCustomer != null) {
                                                if (mode.equals("B")) {
                                                    int id = addNewCustomer.getId();
                                                    String name = addNewCustomer.getCustomerName();
                                                    resultMap.put("result", "1");
                                                    resultMap.put("displayMessage", "Save Success...|" + id + "|" + name);
                                                } else {
                                                    tr.commit();
                                                    resultMap.put("result", "1");
                                                    resultMap.put("displayMessage", "Save Success...");
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
