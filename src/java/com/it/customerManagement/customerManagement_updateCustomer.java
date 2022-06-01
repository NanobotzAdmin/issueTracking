/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.customerManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.LmLocations;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.UmCustomer;
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
@WebServlet(name = "customerManagement_updateCustomer", urlPatterns = {"/customerManagement_updateCustomer"})
public class customerManagement_updateCustomer extends HttpServlet {

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
                    Date updatedDate = new Date();
                    String fullName = request.getParameter("fullNameU");
                    String address = request.getParameter("addressU");
                    int loadBranches = Integer.parseInt(request.getParameter("loadBranchesU"));
                    String mobile = request.getParameter("mobileU");
                    int otpCode = Integer.parseInt(request.getParameter("otpCodeU"));
                    int custId = Integer.parseInt(request.getParameter("custId"));
                    byte isverify = Byte.parseByte(request.getParameter("isverifyU"));
                    String email = request.getParameter("emailU");
                    String nic = request.getParameter("nicU");
                    boolean valied1 = false;
                    boolean valied2 = false;
                    if (isverify == 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Verify Mobile Number");
                    } else {

                        UmCustomer selectedCustomer = (UmCustomer) ses.load(UmCustomer.class, custId);
                        if (selectedCustomer == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Customer Not Found");
                        } else {
                            LmLocations selectedBranch = null;
//                        select branch
                            if (loadBranches > 0) {
                                selectedBranch = (LmLocations) ses.load(LmLocations.class, loadBranches);
                            }
//                        check NIC exists
                            if (selectedCustomer.getNic().equals(nic)) {
                                valied1 = true;
                            } else {
                                UmCustomer checkNIC = new com.it.customerManagementModel.CMS_UM_Customer().checkCustomerNic(ses, nic);
                                if (checkNIC != null) {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "NIC Already Exist");
                                } else {
                                    valied1 = true;
                                }
                            }

                            if (valied1) {
//                            check email exist
                                if (selectedCustomer.getEmailAddress().equals(email)) {
                                    valied2 = true;
                                } else {
                                    UmCustomer checkEmail = new com.it.customerManagementModel.CMS_UM_Customer().checkCustomerEmail(ses, email);
                                    if (checkEmail != null) {
                                        resultMap.put("result", "0");
                                        resultMap.put("displayMessage", "Email Already Exist");
                                    } else {
                                        valied2 = true;
                                    }
                                }
                                if (valied2) {
//                            update new customer
                                    UmCustomer updateCustomer = new com.it.customerManagementModel.CMS_UM_Customer().updateCustomer(ses, fullName, address, STATIC_DATA_MODEL.PMACTIVE, mobile, isverify, otpCode, nic, email, updatedDate, selectedBranch, selectedCustomer, activeUser.getId(), activeUser.getId());
                                    if (updateCustomer != null) {
                                        //Get Active session object
                                        SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                        //Save session activity
                                        String updateCustomerSessionActivityContent = updateCustomer.getCustomerName() + "  Customer has been Updated by " + activeUser.getFirstName() + " on " + updatedDate;
                                        SmSessionActivity sessionActivityToUpdateCustomer = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, updateCustomerSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.CUSTOMERMANAGEMENT, updateCustomer.getId(), activeSession, activeUser);
                                        if (sessionActivityToUpdateCustomer != null) {
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
