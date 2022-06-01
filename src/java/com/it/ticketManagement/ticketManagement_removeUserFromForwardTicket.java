/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.ticketManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.TmTickets;
import com.it.db.TmTicketsHasUmUser;
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
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.simple.JSONObject;

/**
 *
 * @author JOY
 */
@WebServlet(name = "ticketManagement_removeUserFromForwardTicket", urlPatterns = {"/ticketManagement_removeUserFromForwardTicket"})
public class ticketManagement_removeUserFromForwardTicket extends HttpServlet {

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
//        response.setContentType("text/html;charset=UTF-8");
//        request.setCharacterEncoding("UTF-8");
//        PrintWriter out = response.getWriter();
//        Map<String, String> resultMap = new HashMap<String, String>();
//        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
//        Transaction tr = ses.beginTransaction();
//        Logger logger = Logger.getLogger(this.getClass().getName());
//        UmUser activeUser = null;
//        try {
//            if (request.getSession().getAttribute("nowLoginUser") == null) {
//                resultMap.put("result", "2");
//                resultMap.put("displayMessage", "Session Time Out.");
//            } else {
//                activeUser = (UmUser) ses.load(UmUser.class, Integer.parseInt(request.getSession().getAttribute("nowLoginUser").toString()));
//                if (activeUser == null) {
//                    resultMap.put("result", "2");
//                    resultMap.put("displayMessage", "Session Time Out.");
//                } else {
//                    Date addedDate = new Date();
//                    Date updatedDate = new Date();
//                    int ticketId = Integer.parseInt(request.getParameter("ticketId"));
//                    int user = Integer.parseInt(request.getParameter("userId"));
//                    //Get Active session object
//                    SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
////                        select Tickets 
//                    TmTickets selectedTicket = (TmTickets) ses.load(TmTickets.class, ticketId);
//                    if (selectedTicket != null) {
////                        selected User 
//                        UmUser selectedUser = (UmUser) ses.load(UmUser.class, user);
//                        if (selectedUser != null) {
//
//                            //                    check ticket has user already exists
//                            TmTicketsHasUmUser checkUserExists = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getUsersByTicketIdAndUserId(ses, selectedTicket.getId(), selectedUser.getId());
////                            delete user
//                            ses.delete(checkUserExists);
//
//                            String removeUserFromTicketSessionActivityContent = selectedUser.getFirstName() + " User has been Removed From " + selectedTicket.getTicketName() + " Ticket by " + activeUser.getFirstName() + " on " + addedDate;
//                            SmSessionActivity sessionActivityToRemoveUserFromTicket = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, removeUserFromTicketSessionActivityContent, new Date(), STATIC_DATA_MODEL.DELETE, STATIC_DATA_MODEL.TICKETMANAGEMENT, selectedTicket.getId(), activeSession, activeUser);
//
////                            check ticket has users
//                            List<TmTicketsHasUmUser> checkUsersList = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
//                            if (!checkUsersList.isEmpty()) {
//                                selectedTicket.setStatus(STATIC_DATA_MODEL.TICKETACTIVE);
//                                ses.update(selectedTicket);
//                            } else {
//                                selectedTicket.setStatus(STATIC_DATA_MODEL.TICKETPENDING);
//                                ses.update(selectedTicket);
//                            }
//
//                            tr.commit();
//                            resultMap.put("result", "1");
//                            resultMap.put("displayMessage", "Remove Done");
//                        } else {
//                            resultMap.put("result", "0");
//                            resultMap.put("displayMessage", "User Not Found.");
//                        }
//                    } else {
//                        resultMap.put("result", "0");
//                        resultMap.put("displayMessage", "Ticket Not Found.");
//                    }
//
//                }
//            }
//        } catch (Exception e) {
//            tr.rollback();
//            e.printStackTrace();
//            logger.error(e.toString());
//            resultMap.put("result", "0");
//            resultMap.put("displayMessage", e.getMessage());
//        } finally {
//            ses.clear();
//            ses.close();
//            out.print(JSONObject.toJSONString(resultMap));
//        }
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
