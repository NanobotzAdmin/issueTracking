/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.ticketManagement;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.SmSession;
import com.ring.db.SmSessionActivity;
import com.ring.db.TmTickets;
import com.ring.db.TmTicketsHasUmUser;
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
@WebServlet(name = "ticketManagement_addUserToForwardTicket", urlPatterns = {"/ticketManagement_addUserToForwardTicket"})
public class ticketManagement_addUserToForwardTicket extends HttpServlet {

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
                    int ticketId = Integer.parseInt(request.getParameter("ticketId"));
                    int user = Integer.parseInt(request.getParameter("user"));
                    byte status = STATIC_DATA_MODEL.TICKETACTIVE;
                    //Get Active session object
                    SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
//                        select Tickets 
                    TmTickets selectedTicket = (TmTickets) ses.load(TmTickets.class, ticketId);
                    if (selectedTicket != null) {
//                        selected User 
                        UmUser selectedUser = (UmUser) ses.load(UmUser.class, user);
                        if (selectedUser != null) {
//                            check ticket has user already exists
                        TmTicketsHasUmUser checkUserExists = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getUsersByTicketIdAndUserId(ses, selectedTicket.getId(), selectedUser.getId());
                        if(checkUserExists == null){
//                      add user to Ticket
                            TmTicketsHasUmUser addUsersToTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().addTicketHasUsers(ses, selectedTicket.getId(), selectedUser.getId(), status, updatedDate, updatedDate, activeUser.getId(), activeUser.getId());
                            String saveTicketHasUserSessionActivityContent = selectedUser.getFirstName() + " User has been Added To " + selectedTicket.getTicketName() + " Ticket by " + activeUser.getFirstName() + " on " + addedDate;
                            SmSessionActivity sessionActivityToAddUserToTicket = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketHasUserSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.TICKETMANAGEMENT, selectedTicket.getId(), activeSession, activeUser);
                            selectedTicket.setStatus(status);
                            ses.update(selectedTicket);
                            tr.commit();
                            resultMap.put("result", "1");
                            resultMap.put("displayMessage", "Saved Success...");
                        }else{
                             resultMap.put("result", "0");
                            resultMap.put("displayMessage", "User Already In");
                        }
                        } else {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "User Not Found.");
                        }
                    } else {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Ticket Not Found.");
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
