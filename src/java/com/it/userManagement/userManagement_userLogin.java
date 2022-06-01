/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.userManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.UmUser;
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
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.simple.JSONObject;
import org.mindrot.BCrypt;

/**
 *
 * @author JOY
 */
@WebServlet(name = "userManagement_userLogin", urlPatterns = {"/userManagement_userLogin"})
public class userManagement_userLogin extends HttpServlet {

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
        Map<Integer, String> pageAdd = new HashMap<Integer, String>();
        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Transaction tr = ses.beginTransaction();
        Logger logger = Logger.getLogger(this.getClass().getName());
        try {
            String userName = request.getParameter("emailAddress");
            String password = request.getParameter("password");
//            boolean remember = Boolean.parseBoolean(request.getParameter("remember"));
            if (userName.isEmpty()) {
                resultMap.put("result", "0");
                resultMap.put("displayMessage", "Enter User Name");
            } else if (password.isEmpty()) {
                resultMap.put("result", "0");
                resultMap.put("displayMessage", "Enter Password");
            } else {
                UmUser userLogin = new com.it.userManagementModel.UMS_UM_User().getUserNameHasUser(ses, userName);
//check userName and password mach user 
                if (userLogin != null) {
//                     check active user password matched
                            if (password.equals(userLogin.getPassword())) {
                                if (userLogin.getStatus() == STATIC_DATA_MODEL.ACTIVE && userLogin.getPmUserRole()!= null) {
//                      set http session to active user
                                    HttpSession httpSession = request.getSession();
//                                    String genAuthKey = new com.it.configurationModel.KEY_GENERATOR().genAuthenticationKey();
//                                    System.out.println("auth key = " + genAuthKey);
//                      set userlogin type object to http session variable  
                                    httpSession.setAttribute("nowLoginUser", userLogin.getId());
//                                    httpSession.setAttribute("uniqueNumber", userLogin.getPublicKey());
//                                    httpSession.setAttribute("gan", genAuthKey);
//                                    set user authentication key
//                                    userLogin.setUniqueAuthKey(genAuthKey);
                                    ses.update(userLogin);
//                              create date and string variables to save date and http session ip
                                    Date httpSessionDate = new Date();
                                    String httpSessipnIpAddress = request.getRemoteAddr();
//                              save login user session in db  
                                    SmSession saveLoginUserSession = new com.it.userManagementModel.UMS_UM_Session().saveHttpSession(ses, httpSessionDate, httpSessionDate, httpSessionDate, httpSessipnIpAddress, userLogin);
//                              set  saveLoginUserSession type object to httpSession variable
                                    httpSession.setAttribute("logUserHttpSession", saveLoginUserSession);
                                    String sessionDescription = userLogin.getFirstName()+" " +userLogin.getLastName() +" User has Logged in to System ";
//                                    save session activity
                                    SmSessionActivity saveSessionActivity = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, sessionDescription, httpSessionDate, STATIC_DATA_MODEL.LOGIN, STATIC_DATA_MODEL.USERLOGIN, saveLoginUserSession, userLogin);

//                              check Status and apply conditions
                                    // generate token and save it to token history tabel.
                                    resultMap.put("result", "2");
                                    resultMap.put("displayMessage", "Login Success");
                                } else if (userLogin.getStatus() == 2 && userLogin.getPmUserRole() == null) {
                                    resultMap.put("result", "6");
                                    resultMap.put("displayMessage", "User Role Not Assigned ");
                                } else if (userLogin.getStatus() == 1) {
                                    resultMap.put("result", "1");
                                    resultMap.put("displayMessage", "Your Account is Pending");
                                } else if (userLogin.getStatus() == 4) {
                                    resultMap.put("result", "4");
                                    resultMap.put("displayMessage", "Your Account is Blocked");
                                } else if (userLogin.getStatus() == 3) {
                                    resultMap.put("result", "3");
                                    resultMap.put("displayMessage", "Your Account is Deactive");
                                }
                            }else{
                                 resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Password Incorrect");
                            }
                } else {
                    resultMap.put("result", "5");
                    resultMap.put("displayMessage", "Login Credential Incorrect");
                }
            }
            tr.commit();
        } catch (Exception e) {
            tr.rollback();
            logger.error(e.toString());
            e.printStackTrace();
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
