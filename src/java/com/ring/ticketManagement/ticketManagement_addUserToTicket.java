/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.ticketManagement;

import com.ring.configurationModel.EMAIL_MODEL;
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
@WebServlet(name = "ticketManagement_addUserToTicket", urlPatterns = {"/ticketManagement_addUserToTicket"})
public class ticketManagement_addUserToTicket extends HttpServlet {

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
                    TmTickets selectedTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets().getTicketById(ses, ticketId);
                    if (selectedTicket != null) {
//                        selected User 
                        UmUser selectedUser = (UmUser) ses.load(UmUser.class, user);
                        if (selectedUser != null) {
//                            check ticket has user already exists
                            TmTicketsHasUmUser checkUserExists = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getUsersByTicketIdAndUserId(ses, selectedTicket.getId(), selectedUser.getId());
                            if (checkUserExists == null) {
//                      add user to Ticket
                                TmTicketsHasUmUser addUsersToTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().addTicketHasUsers(ses, selectedTicket.getId(), selectedUser.getId(), status, updatedDate, updatedDate, activeUser.getId(), activeUser.getId());
                                String saveTicketHasUserSessionActivityContent = selectedUser.getFirstName() + " User has been Added To " + selectedTicket.getTicketName() + " Ticket by " + activeUser.getFirstName() + " on " + addedDate;
                                SmSessionActivity sessionActivityToAddUserToTicket = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketHasUserSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.TICKETMANAGEMENT, selectedTicket.getId(), activeSession, activeUser);
                                selectedTicket.setStatus(status);
                                ses.update(selectedTicket);
                                if (selectedUser.getEmailAddress() != null) {

                                    String ticketStatus = null;
                                    if (selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETPENDING) {
                                        ticketStatus = "<span style=\"color:orange\">Pending</span>";
                                    } else if (selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETACTIVE) {
                                        ticketStatus = "<span style=\"color:green\">Active</span>";
                                    } else if (selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETCOMPLETED) {
                                        ticketStatus = "<span style=\"color:blue\">Completed</span>";
                                    } else if (selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETCONFIRMED) {
                                        ticketStatus = "<span style=\"color:black\">Confirmed</span>";
                                    } else if (selectedTicket.getStatus() == STATIC_DATA_MODEL.TICKETARCHIVE) {
                                        ticketStatus = "<span style=\"color:red\">Archive</span>";
                                    }

                                    String emailContent = "<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" style=\"font-family:arial, 'helvetica neue', helvetica, sans-serif\"> \n"
                                            + "    <head> \n"
                                            + "        <meta charset=\"UTF-8\"> \n"
                                            + "            <meta content=\"width=device-width, initial-scale=1\" name=\"viewport\"> \n"
                                            + "                <meta name=\"x-apple-disable-message-reformatting\"> \n"
                                            + "                    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"> \n"
                                            + "                        <meta content=\"telephone=no\" name=\"format-detection\"> \n"
                                            + "                            <title>Assigned to Ticket | <span class=\"text-success\">/title><!--[if (mso 16)]>\n"
                                            + "                              <style type=\"text/css\">\n"
                                            + "                              a {text-decoration: none;}\n"
                                            + "                              </style>\n"
                                            + "                              <![endif]--><!--[if gte mso 9]><style>sup { font-size: 100% !important; }</style><![endif]--><!--[if gte mso 9]>\n"
                                            + "                          <xml>\n"
                                            + "                              <o:OfficeDocumentSettings>\n"
                                            + "                              <o:AllowPNG></o:AllowPNG>\n"
                                            + "                              <o:PixelsPerInch>96</o:PixelsPerInch>\n"
                                            + "                              </o:OfficeDocumentSettings>\n"
                                            + "                          </xml>\n"
                                            + "                          <![endif]--> \n"
                                            + "                            <style type=\"text/css\">\n"
                                            + "                                #outlook a {\n"
                                            + "                                    padding:0;\n"
                                            + "                                }\n"
                                            + "                                .es-button {\n"
                                            + "                                    mso-style-priority:100!important;\n"
                                            + "                                    text-decoration:none!important;\n"
                                            + "                                }\n"
                                            + "                                a[x-apple-data-detectors] {\n"
                                            + "                                    color:inherit!important;\n"
                                            + "                                    text-decoration:none!important;\n"
                                            + "                                    font-size:inherit!important;\n"
                                            + "                                    font-family:inherit!important;\n"
                                            + "                                    font-weight:inherit!important;\n"
                                            + "                                    line-height:inherit!important;\n"
                                            + "                                }\n"
                                            + "                                .es-desk-hidden {\n"
                                            + "                                    display:none;\n"
                                            + "                                    float:left;\n"
                                            + "                                    overflow:hidden;\n"
                                            + "                                    width:0;\n"
                                            + "                                    max-height:0;\n"
                                            + "                                    line-height:0;\n"
                                            + "                                    mso-hide:all;\n"
                                            + "                                }\n"
                                            + "                                [data-ogsb] .es-button {\n"
                                            + "                                    border-width:0!important;\n"
                                            + "                                    padding:10px 20px 10px 20px!important;\n"
                                            + "                                }\n"
                                            + "                                @media only screen and (max-width:600px) {\n"
                                            + "                                    p, ul li, ol li, a {\n"
                                            + "                                        line-height:150%!important\n"
                                            + "                                    }\n"
                                            + "                                    h1, h2, h3, h1 a, h2 a, h3 a {\n"
                                            + "                                        line-height:120%\n"
                                            + "                                    }\n"
                                            + "                                    h1 {\n"
                                            + "                                        font-size:30px!important;\n"
                                            + "                                        text-align:left\n"
                                            + "                                    }\n"
                                            + "                                    h2 {\n"
                                            + "                                        font-size:24px!important;\n"
                                            + "                                        text-align:left\n"
                                            + "                                    }\n"
                                            + "                                    h3 {\n"
                                            + "                                        font-size:20px!important;\n"
                                            + "                                        text-align:left\n"
                                            + "                                    }\n"
                                            + "                                    .es-header-body h1 a, .es-content-body h1 a, .es-footer-body h1 a {\n"
                                            + "                                        font-size:30px!important;\n"
                                            + "                                        text-align:left\n"
                                            + "                                    }\n"
                                            + "                                    .es-header-body h2 a, .es-content-body h2 a, .es-footer-body h2 a {\n"
                                            + "                                        font-size:24px!important;\n"
                                            + "                                        text-align:left\n"
                                            + "                                    }\n"
                                            + "                                    .es-header-body h3 a, .es-content-body h3 a, .es-footer-body h3 a {\n"
                                            + "                                        font-size:20px!important;\n"
                                            + "                                        text-align:left\n"
                                            + "                                    }\n"
                                            + "                                    .es-menu td a {\n"
                                            + "                                        font-size:14px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-header-body p, .es-header-body ul li, .es-header-body ol li, .es-header-body a {\n"
                                            + "                                        font-size:14px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-content-body p, .es-content-body ul li, .es-content-body ol li, .es-content-body a {\n"
                                            + "                                        font-size:14px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-footer-body p, .es-footer-body ul li, .es-footer-body ol li, .es-footer-body a {\n"
                                            + "                                        font-size:14px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-infoblock p, .es-infoblock ul li, .es-infoblock ol li, .es-infoblock a {\n"
                                            + "                                        font-size:12px!important\n"
                                            + "                                    }\n"
                                            + "                                    *[class=\"gmail-fix\"] {\n"
                                            + "                                        display:none!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-txt-c, .es-m-txt-c h1, .es-m-txt-c h2, .es-m-txt-c h3 {\n"
                                            + "                                        text-align:center!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-txt-r, .es-m-txt-r h1, .es-m-txt-r h2, .es-m-txt-r h3 {\n"
                                            + "                                        text-align:right!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-txt-l, .es-m-txt-l h1, .es-m-txt-l h2, .es-m-txt-l h3 {\n"
                                            + "                                        text-align:left!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-txt-r img, .es-m-txt-c img, .es-m-txt-l img {\n"
                                            + "                                        display:inline!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-button-border {\n"
                                            + "                                        display:inline-block!important\n"
                                            + "                                    }\n"
                                            + "                                    a.es-button, button.es-button {\n"
                                            + "                                        font-size:18px!important;\n"
                                            + "                                        display:inline-block!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-adaptive table, .es-left, .es-right {\n"
                                            + "                                        width:100%!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-content table, .es-header table, .es-footer table, .es-content, .es-footer, .es-header {\n"
                                            + "                                        width:100%!important;\n"
                                            + "                                        max-width:600px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-adapt-td {\n"
                                            + "                                        display:block!important;\n"
                                            + "                                        width:100%!important\n"
                                            + "                                    }\n"
                                            + "                                    .adapt-img {\n"
                                            + "                                        width:100%!important;\n"
                                            + "                                        height:auto!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p0 {\n"
                                            + "                                        padding:0!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p0r {\n"
                                            + "                                        padding-right:0!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p0l {\n"
                                            + "                                        padding-left:0!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p0t {\n"
                                            + "                                        padding-top:0!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p0b {\n"
                                            + "                                        padding-bottom:0!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p20b {\n"
                                            + "                                        padding-bottom:20px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-mobile-hidden, .es-hidden {\n"
                                            + "                                        display:none!important\n"
                                            + "                                    }\n"
                                            + "                                    tr.es-desk-hidden, td.es-desk-hidden, table.es-desk-hidden {\n"
                                            + "                                        width:auto!important;\n"
                                            + "                                        overflow:visible!important;\n"
                                            + "                                        float:none!important;\n"
                                            + "                                        max-height:inherit!important;\n"
                                            + "                                        line-height:inherit!important\n"
                                            + "                                    }\n"
                                            + "                                    tr.es-desk-hidden {\n"
                                            + "                                        display:table-row!important\n"
                                            + "                                    }\n"
                                            + "                                    table.es-desk-hidden {\n"
                                            + "                                        display:table!important\n"
                                            + "                                    }\n"
                                            + "                                    td.es-desk-menu-hidden {\n"
                                            + "                                        display:table-cell!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-menu td {\n"
                                            + "                                        width:1%!important\n"
                                            + "                                    }\n"
                                            + "                                    table.es-table-not-adapt, .esd-block-html table {\n"
                                            + "                                        width:auto!important\n"
                                            + "                                    }\n"
                                            + "                                    table.es-social {\n"
                                            + "                                        display:inline-block!important\n"
                                            + "                                    }\n"
                                            + "                                    table.es-social td {\n"
                                            + "                                        display:inline-block!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p5 {\n"
                                            + "                                        padding:5px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p5t {\n"
                                            + "                                        padding-top:5px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p5b {\n"
                                            + "                                        padding-bottom:5px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p5r {\n"
                                            + "                                        padding-right:5px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p5l {\n"
                                            + "                                        padding-left:5px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p10 {\n"
                                            + "                                        padding:10px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p10t {\n"
                                            + "                                        padding-top:10px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p10b {\n"
                                            + "                                        padding-bottom:10px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p10r {\n"
                                            + "                                        padding-right:10px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p10l {\n"
                                            + "                                        padding-left:10px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p15 {\n"
                                            + "                                        padding:15px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p15t {\n"
                                            + "                                        padding-top:15px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p15b {\n"
                                            + "                                        padding-bottom:15px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p15r {\n"
                                            + "                                        padding-right:15px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p15l {\n"
                                            + "                                        padding-left:15px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p20 {\n"
                                            + "                                        padding:20px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p20t {\n"
                                            + "                                        padding-top:20px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p20r {\n"
                                            + "                                        padding-right:20px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p20l {\n"
                                            + "                                        padding-left:20px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p25 {\n"
                                            + "                                        padding:25px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p25t {\n"
                                            + "                                        padding-top:25px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p25b {\n"
                                            + "                                        padding-bottom:25px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p25r {\n"
                                            + "                                        padding-right:25px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p25l {\n"
                                            + "                                        padding-left:25px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p30 {\n"
                                            + "                                        padding:30px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p30t {\n"
                                            + "                                        padding-top:30px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p30b {\n"
                                            + "                                        padding-bottom:30px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p30r {\n"
                                            + "                                        padding-right:30px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p30l {\n"
                                            + "                                        padding-left:30px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p35 {\n"
                                            + "                                        padding:35px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p35t {\n"
                                            + "                                        padding-top:35px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p35b {\n"
                                            + "                                        padding-bottom:35px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p35r {\n"
                                            + "                                        padding-right:35px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p35l {\n"
                                            + "                                        padding-left:35px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p40 {\n"
                                            + "                                        padding:40px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p40t {\n"
                                            + "                                        padding-top:40px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p40b {\n"
                                            + "                                        padding-bottom:40px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p40r {\n"
                                            + "                                        padding-right:40px!important\n"
                                            + "                                    }\n"
                                            + "                                    .es-m-p40l {\n"
                                            + "                                        padding-left:40px!important\n"
                                            + "                                    }\n"
                                            + "                                }\n"
                                            + "                            </style> \n"
                                            + "                            </head> \n"
                                            + "                            <body style=\"width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0\"> \n"
                                            + "                                <div class=\"es-wrapper-color\" style=\"background-color:#91C1FE\"><!--[if gte mso 9]>\n"
                                            + "                                                      <v:background xmlns:v=\"urn:schemas-microsoft-com:vml\" fill=\"t\">\n"
                                            + "                                                              <v:fill type=\"tile\" color=\"#91c1fe\" origin=\"0.5, 0\" position=\"0.5, 0\"></v:fill>\n"
                                            + "                                                      </v:background>\n"
                                            + "                                              <![endif]--> \n"
                                            + "                                    <table class=\"es-wrapper\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;background-color:#91C1FE\"> \n"
                                            + "                                        <tr> \n"
                                            + "                                            <td valign=\"top\" style=\"padding:0;Margin:0\"> \n"
                                            + "                                                <table class=\"es-header\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top\"> \n"
                                            + "                                                    <tr> \n"
                                            + "                                                        <td align=\"center\" style=\"padding:0;Margin:0\"> \n"
                                            + "                                                            <table class=\"es-header-body\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#ffffff\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px\"> \n"
                                            + "                                                                <tr> \n"
                                            + "                                                                    <td align=\"left\" style=\"Margin:0;padding-bottom:10px;padding-top:15px;padding-left:20px;padding-right:20px\"><!--[if mso]><table style=\"width:560px\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"width:194px\"><![endif]--> \n"
                                            + "                                                                        <table class=\"es-left\" cellspacing=\"0\" cellpadding=\"0\" align=\"left\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left\"> \n"
                                            + "                                                                            <tr> \n"
                                            + "                                                                                <td class=\"es-m-p0r es-m-p20b\" align=\"center\" style=\"padding:0;Margin:0;width:174px\"> \n"
                                            + "                                                                                    <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\"> \n"
                                            + "                                                                                        <tr> \n"
                                            + "                                                                                            <td class=\"es-m-p0r es-m-p0t es-m-txt-c\" align=\"left\" style=\"padding:0;Margin:0;padding-top:15px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">" + new Date() + "</p></td> \n"
                                            + "                                                                                        </tr> \n"
                                            + "                                                                                    </table></td> \n"
                                            + "                                                                                <td class=\"es-hidden\" style=\"padding:0;Margin:0;width:20px\"></td> \n"
                                            + "                                                                            </tr> \n"
                                            + "                                                                        </table><!--[if mso]></td><td style=\"width:173px\"><![endif]--> \n"
                                            + "                                                                        <table class=\"es-left\" cellspacing=\"0\" cellpadding=\"0\" align=\"left\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left\"> \n"
                                            + "                                                                            <tr> \n"
                                            + "                                                                                <td class=\"es-m-p20b\" align=\"center\" style=\"padding:0;Margin:0;width:173px\"> \n"
                                            + "                                                                                    <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\"> \n"
                                            + "                                                                                        <tr> \n"
                                            + "                                                                                            <td class=\"es-m-p0l\" align=\"center\" style=\"padding:0;Margin:0;font-size:0px\"><a href=\"https://ring.visioncare.lk/\" target=\"_blank\" style=\"-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;text-decoration:underline;color:#2CB543;font-size:14px\"><img src=\"https://lkgca.stripocdn.email/content/guids/CABINET_66e9744095d6e6437e3de84d15e1e16b/images/colouredlogo_y0c.png\" alt=\"ring ticket management system\" width=\"98\" style=\"display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic\" title=\"ring ticket management system\"></a></td> \n"
                                            + "                                                                                        </tr> \n"
                                            + "                                                                                    </table></td> \n"
                                            + "                                                                            </tr> \n"
                                            + "                                                                        </table><!--[if mso]></td><td style=\"width:20px\"></td><td style=\"width:173px\"><![endif]--> \n"
                                            + "                                                                        <table class=\"es-right\" cellspacing=\"0\" cellpadding=\"0\" align=\"right\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right\"> \n"
                                            + "                                                                            <tr> \n"
                                            + "                                                                                <td align=\"center\" style=\"padding:0;Margin:0;width:173px\"> \n"
                                            + "                                                                                    <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\"> \n"
                                            + "                                                                                        <tr> \n"
                                            + "                                                                                            <td align=\"center\" style=\"padding:0;Margin:0\"><span class=\"es-button-border\" style=\"border-style:solid;border-color:#2CB543;background:#2CB543;border-width:0px 0px 2px 0px;display:inline-block;border-radius:30px;width:auto\"><a href=\"https://ring.visioncare.lk/\" class=\"es-button\" target=\"_blank\" style=\"mso-style-priority:100 !important;text-decoration:none;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;color:#FFFFFF;font-size:18px;border-style:solid;border-color:#31CB4B;border-width:10px 20px 10px 20px;display:inline-block;background:#31CB4B;border-radius:30px;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-weight:normal;font-style:normal;line-height:22px;width:auto;text-align:center\">Go to Login</a></span></td> \n"
                                            + "                                                                                        </tr> \n"
                                            + "                                                                                    </table></td> \n"
                                            + "                                                                            </tr> \n"
                                            + "                                                                        </table><!--[if mso]></td></tr></table><![endif]--></td> \n"
                                            + "                                                                </tr> \n"
                                            + "                                                                <tr> \n"
                                            + "                                                                    <td align=\"left\" style=\"padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px\"> \n"
                                            + "                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\"> \n"
                                            + "                                                                            <tr> \n"
                                            + "                                                                                <td valign=\"top\" align=\"center\" style=\"padding:0;Margin:0;width:560px\"> \n"
                                            + "                                                                                    <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\"> \n"
                                            + "                                                                                        <tr> \n"
                                            + "                                                                                            <td align=\"left\" style=\"padding:0;Margin:0\"><h3 style=\"Margin:0;line-height:24px;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:20px;font-style:normal;font-weight:normal;color:#333333\">Assigned to Ticket | " + ticketStatus + "</h3></td> \n"
                                            + "                                                                                        </tr> \n"
                                            + "                                                                                    </table></td> \n"
                                            + "                                                                            </tr> \n"
                                            + "                                                                            <tr> \n"
                                            + "                                                                                <td valign=\"top\" align=\"center\" style=\"padding:0;Margin:0;width:560px\"> \n"
                                            + "                                                                                    <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\"> \n"
                                            + "                                                                                        <tr> \n"
                                            + "                                                                                            <td style=\"padding:0;Margin:0;padding-bottom:25px\">\n"
                                            + "                                                                                                <p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">\n"
                                            + "                                                                                                    Dear " + selectedUser.getFirstName() + ",\n"
                                            + "                                                                                                    You have been assigned to the ticket number <b>" + selectedTicket.getTid() + "</b><br></br>\n"
                                            + "                                                                                                    by <b>" + activeUser.getFirstName() + "</b> for the ticket created under the title\n"
                                            + "                                                                                                    <b>" + selectedTicket.getTicketName() + "</b>\n"
                                            + "\n"
                                            + "                                                                                                    Please login to the RING Ticket Management to view the ticket.\n"
                                            + "                                                                                                    <!--code load here-->\n"
                                            + "                                                                                                </p>\n"
                                            + "                                                                                            </td> \n"
                                            + "                                                                                        </tr> \n"
                                            + "                                                                                    </table></td> \n"
                                            + "                                                                            </tr> \n"
                                            + "                                                                        </table></td> \n"
                                            + "                                                                </tr> \n"
                                            + "                                                            </table></td> \n"
                                            + "                                                    </tr> \n"
                                            + "                                                </table> \n"
                                            + "                                                <table class=\"es-footer\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top\"> \n"
                                            + "                                                    <tr> \n"
                                            + "                                                        <td align=\"center\" style=\"padding:0;Margin:0\"> \n"
                                            + "                                                            <table class=\"es-footer-body\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#ffffff\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px\"> \n"
                                            + "                                                                <tr> \n"
                                            + "                                                                    <td align=\"left\" bgcolor=\"#ecebeb\" style=\"padding:20px;Margin:0;background-color:#ecebeb\"><!--[if mso]><table style=\"width:560px\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"width:356px\" valign=\"top\"><![endif]--> \n"
                                            + "                                                                        <table class=\"es-left\" cellspacing=\"0\" cellpadding=\"0\" align=\"left\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left\"> \n"
                                            + "                                                                            <tr> \n"
                                            + "                                                                                <td class=\"es-m-p20b\" align=\"left\" style=\"padding:0;Margin:0;width:356px\"> \n"
                                            + "                                                                                    <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\"> \n"
                                            + "                                                                                        <tr> \n"
                                            + "                                                                                            <td esdev-links-color=\"#666666\" align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">You're receiving this email because you are a user registered to Vision Care Ring Ticket Management<br></p></td> \n"
                                            + "                                                                                        </tr> \n"
                                            + "                                                                                    </table></td> \n"
                                            + "                                                                            </tr> \n"
                                            + "                                                                        </table><!--[if mso]></td><td style=\"width:20px\"></td><td style=\"width:184px\" valign=\"top\"><![endif]--> \n"
                                            + "                                                                        <table cellspacing=\"0\" cellpadding=\"0\" align=\"right\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\"> \n"
                                            + "                                                                            <tr> \n"
                                            + "                                                                                <td align=\"left\" style=\"padding:0;Margin:0;width:184px\"> \n"
                                            + "                                                                                    <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\"> \n"
                                            + "                                                                                        <tr> \n"
                                            + "                                                                                            <td class=\"es-m-txt-c\" align=\"left\" style=\"padding:0;Margin:0;padding-bottom:10px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">This is a system generated message. Do not reply.</p></td> \n"
                                            + "                                                                                        </tr> \n"
                                            + "                                                                                    </table></td> \n"
                                            + "                                                                            </tr> \n"
                                            + "                                                                        </table><!--[if mso]></td></tr></table><![endif]--></td> \n"
                                            + "                                                                </tr> \n"
                                            + "                                                            </table></td> \n"
                                            + "                                                    </tr> \n"
                                            + "                                                </table></td> \n"
                                            + "                                        </tr> \n"
                                            + "                                    </table> \n"
                                            + "                                </div>  \n"
                                            + "                            </body>\n"
                                            + "                            </html>";
                                    String locationName = "";
                                    if (selectedTicket.getLmLocations() != null) {
                                        locationName = selectedTicket.getLmLocations().getLocationName();
                                    }
                                    String emailSubject = selectedTicket.getQmQueue().getQueueName() + " | " + selectedTicket.getTid() + " | " + locationName;
                                    EMAIL_MODEL.Sendmail(selectedUser.getEmailAddress(), emailSubject, emailContent);
                                }
                                tr.commit();
                                resultMap.put("result", "1");
                                resultMap.put("displayMessage", "Saved Success...");
                            } else {
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
