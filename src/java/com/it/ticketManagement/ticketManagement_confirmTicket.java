/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.ticketManagement;

import com.it.configurationModel.EMAIL_MODEL;
import com.it.configurationModel.SMS_MODEL;
import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.TmTicketReply;
import com.it.db.TmTickets;
import com.it.db.TmTicketsHasUmUser;
import com.it.db.UmUser;
import java.io.IOException;
import java.io.PrintWriter;
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
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.simple.JSONObject;

/**
 *
 * @author JOY
 */
@WebServlet(name = "ticketManagement_confirmTicket", urlPatterns = {"/ticketManagement_confirmTicket"})
public class ticketManagement_confirmTicket extends HttpServlet {

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
                    int ticketId = Integer.parseInt(request.getParameter("ticketId"));
                    //Get Active session object
                    SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
//                        select Tickets 
                    TmTickets selectedTicket = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketById(ses, ticketId);
                    if (selectedTicket != null) {
                        UmUser ticketCreatedUser = (UmUser) ses.load(UmUser.class, selectedTicket.getCreatedBy());
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        String issuesComplete = selectedTicket.getCreatedAt().toString();
                        String todaty = sdf.format(new Date());
                        Date d1 = sdf.parse(issuesComplete);
                        Date d2 = sdf.parse(todaty);
                        long date1InMs = d1.getTime();
                        long date2InMs = d2.getTime();
                        long difference_In_Time = 0;
                        if (date1InMs > date2InMs) {
                            difference_In_Time = date1InMs - date2InMs;
                        } else {
                            difference_In_Time = date2InMs - date1InMs;
                        }
                        selectedTicket.setStatus(STATIC_DATA_MODEL.TICKETCONFIRMED);
                        selectedTicket.setUpdatedAt(updatedDate);
                        selectedTicket.setUpdatedBy(activeUser.getId());
                        selectedTicket.setConfirmedAt(updatedDate);
                        selectedTicket.setConfirmedBy(activeUser.getId());
                        selectedTicket.setTimeToConfirm(difference_In_Time);
                        ses.update(selectedTicket);
                        String TicketConfirmedSessionActivityContent = selectedTicket.getTicketName() + " Issue has been Confirmed by " + activeUser.getFirstName() + " on " + updatedDate;
                        SmSessionActivity sessionActivityToTicketConfirmed = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, TicketConfirmedSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.ISSUESMANAGEMENT, selectedTicket.getId(), activeSession, activeUser);
                        List<TmTicketsHasUmUser> getTicketHasUsers = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
                        if (!getTicketHasUsers.isEmpty()) {
                            for (TmTicketsHasUmUser ticketHasUser : getTicketHasUsers) {
                                if (ticketHasUser.getUmUser().getMobileNumber() != null) {
                                    String smsCnt = activeUser.getFirstName() + " " + activeUser.getLastName() + " has Confirm Issues Number " + selectedTicket.getTid();
                                    String smsStatus = SMS_MODEL.Send_SMS(ticketHasUser.getUmUser().getMobileNumber(), smsCnt);
                                }
                            }
                        }

                        tr.commit();
                        resultMap.put("result", "1");
                        resultMap.put("displayMessage", "Issue Confirmed");
                    } else {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Issue Not Found.");
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
