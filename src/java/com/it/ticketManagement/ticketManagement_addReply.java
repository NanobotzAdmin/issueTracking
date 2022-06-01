/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.ticketManagement;

import com.it.configurationModel.Decemal_Format;
import com.it.configurationModel.EMAIL_MODEL;
import com.it.configurationModel.SMS_MODEL;
import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.TmReplyMedia;
import com.it.db.TmTicketReply;
import com.it.db.TmTickets;
import com.it.db.TmTicketsHasUmUser;
import com.it.db.UmUser;
import com.it.fileUploadManagementModel.fileUpload_Management;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
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
@WebServlet(name = "ticketManagement_addReply", urlPatterns = {"/ticketManagement_addReply"})
public class ticketManagement_addReply extends HttpServlet {

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
                    Date addedDate = new Date();
//                    String reply = URLDecoder.decode(request.getParameter("reply"), "UTF-8");   
                    String ticketReplyDetails = "";
                    String ticketToReply = "";
                    String expenses = "";
                    String encodedReply = "";
                    FileItemFactory factory = new DiskFileItemFactory();
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    List<FileItem> items = upload.parseRequest(request);
                    for (FileItem element : items) {
                        FileItem fileitem = (FileItem) element;
                        if (fileitem.isFormField()) {
                            if (fileitem.getFieldName().equals("ticketReplyDetails")) {
                                ticketReplyDetails = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("ticketToReply")) {
                                ticketToReply = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("expenses")) {
                                expenses = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("encodedReply")) {
                                encodedReply = fileitem.getString();
                            }
                        }
                    }
                    int ticketId = Integer.parseInt(ticketToReply);
                    double expensesFinal = 0.0;
//                    System.out.println(" encodedReply = " + encodedReply);
//                        select Tickets 
                    TmTickets selectedTicket = new com.it.ticketManagementModel.TMS_TM_Tickets().getTicketById(ses, ticketId);
                    if (selectedTicket != null) {

                        String locationName = "";
                        String customerName = "";
                        if (selectedTicket.getLmLocations() != null) {
                            locationName = selectedTicket.getLmLocations().getLocationName();
                        }
                        if (selectedTicket.getUmCustomer() != null) {
                            customerName = selectedTicket.getUmCustomer().getCustomerName();
                        }

                        UmUser ticketCreatedUser = (UmUser) ses.load(UmUser.class, selectedTicket.getCreatedBy());
                        TmTicketReply lastTicketReply = null;
//                        get ticket has reply
                        List<TmTicketReply> ticketHasReply = new com.it.ticketManagementModel.TMS_TM_Ticket_Reply().getTicketReplyByTicketId(ses, selectedTicket.getId());
                        if (!ticketHasReply.isEmpty()) {
                            lastTicketReply = ticketHasReply.get(ticketHasReply.size() - 1);
                        }
//                        String lastReplyUser = "";
//                        String lastReplyTime = "";
//                        if (lastTicketReply != null) {
//                            UmUser lstru = (UmUser) ses.load(UmUser.class, lastTicketReply.getCreatedBy());
//                            if (lstru != null) {
//                                lastReplyUser = lstru.getFirstName() + " " + lstru.getLastName();
//                            }
//                            lastReplyTime = lastTicketReply.getCreatedAt().toString();
//                        }
                        if (ticketReplyDetails.isEmpty()) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Enter Reply");
                        } else {
                            String decodedReply = URLDecoder.decode(encodedReply, "UTF-8");
//                                System.out.println("decodedReply = " + decodedReply);
//                            save ticket reply
                            TmTicketReply addNewTicketReply = new com.it.ticketManagementModel.TMS_TM_Ticket_Reply().saveTicketReply(ses, decodedReply, STATIC_DATA_MODEL.PMACTIVE, expensesFinal, addedDate, addedDate, selectedTicket, activeUser.getId(), activeUser.getId());
                            if (addNewTicketReply != null) {
//                                double ticketCurrentExpenses = selectedTicket.getTotalExpence();
////                                System.out.println("kjk = " + ticketCurrentExpenses);
//                                double gg = ticketCurrentExpenses + expensesFinal;
////                                System.out.println("final tot = " + gg);
//                                selectedTicket.setTotalExpence(Decemal_Format.RoundTo2Decimals(gg));
//                                ses.update(selectedTicket);
                                //Get Active session object
                                SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                //Save session activity
                                String saveTicketReplySessionActivityContent = addNewTicketReply.getId() + " Issue Reply has been Saved by " + activeUser.getFirstName() + " on " + addedDate;
                                SmSessionActivity sessionActivityToAddTicketReply = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketReplySessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.ISSUESREPLYMANAGEMENT, selectedTicket.getId(), activeSession, activeUser);
                                if (sessionActivityToAddTicketReply != null) {
                                    String ticketReplyMedia = "Issues Reply Media Files/" + selectedTicket.getTicketName() + " - " + selectedTicket.getId();
                                    new fileUpload_Management().createFolder(fileUpload_Management.fileUploadingPath, ticketReplyMedia);
                                    for (FileItem element : items) {
                                        FileItem fileitem2 = (FileItem) element;
                                        if (!fileitem2.isFormField()) {
                                            if (fileitem2.getFieldName().equals("ticketReplyFiles")) {
                                                String extention = new File(element.getName()).getName();
                                                if (!extention.equals("")) {
                                                    FileItem ticketReplyMediaFiles = element;
//                                                    System.out.println("ticketMediaFiles = " + ticketReplyMediaFiles);
//                                                    System.out.println("ticketMedia name = " + ticketReplyMediaFiles.getName());
//                                                    System.out.println("ticketMedia size = " + ticketReplyMediaFiles.getSize());

                                                    String extensionRemoved = ticketReplyMediaFiles.getName().split("\\.")[1];
//                                                    System.out.println("extensionRemoved = " + extensionRemoved);
//                                                    if (extensionRemoved.equalsIgnoreCase("png") || extensionRemoved.equalsIgnoreCase("GIF") || extensionRemoved.equalsIgnoreCase("JPEG") || extensionRemoved.equalsIgnoreCase("TIFF")
//                                                            || extensionRemoved.equalsIgnoreCase("JPG") || extensionRemoved.equalsIgnoreCase("mp4") || extensionRemoved.equalsIgnoreCase("mp3") || extensionRemoved.equalsIgnoreCase("doc")
//                                                            || extensionRemoved.equalsIgnoreCase("docx") || extensionRemoved.equalsIgnoreCase("CSV") || extensionRemoved.equalsIgnoreCase("XLS ") || extensionRemoved.equalsIgnoreCase("xlsx")) {
                                                        if (ticketReplyMediaFiles.getSize() <= 12000000) {
                                                            String saveTicketReplyFiles = new com.it.fileUploadManagementModel.fileUpload_Management().fileItem(ticketReplyMediaFiles, ticketReplyMedia);
//                                                            System.out.println("type = " + ticketReplyMediaFiles.getContentType());
//                                                            System.out.println("path = " + ticketReplyMediaFiles);
//                                                            System.out.println("saveTicketReplyFiles = " + saveTicketReplyFiles);
                                                            TmReplyMedia saveTicketReplyMedia = new com.it.ticketManagementModel.TMS_TM_Reply_Media().saveTicketReplyMedia(ses, extensionRemoved, saveTicketReplyFiles, STATIC_DATA_MODEL.PMACTIVE, addedDate, addedDate, addNewTicketReply, activeUser.getId(), activeUser.getId());
                                                            String saveTicketReplyMediaSessionActivityContent = saveTicketReplyMedia.getId() + " Issue Reply Media has been Saved by " + activeUser.getFirstName() + " on " + addedDate;
                                                            SmSessionActivity sessionActivityToAddTicketReplyMedia = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketReplyMediaSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.ISSUESREPLYMANAGEMENT, selectedTicket.getId(), activeSession, activeUser);
                                                        }
//                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if (selectedTicket.getCreatedBy() == activeUser.getId()) {
                                        String smsCnt = activeUser.getFirstName() +" "+ activeUser.getLastName()+ " has Reply To Issue Number " + selectedTicket.getTid();
                                        List<TmTicketsHasUmUser> getTicketHasUsers = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
                                        if (!getTicketHasUsers.isEmpty()) {
                                            for (TmTicketsHasUmUser ticketHasUser : getTicketHasUsers) {
                                                if (ticketHasUser.getUmUser().getEmailAddress() != null) {
                                                    String smsStatus = SMS_MODEL.Send_SMS(ticketHasUser.getUmUser().getMobileNumber(), smsCnt); 
                                                }
                                            }
                                        }
                                    }else{
                                         List<TmTicketsHasUmUser> getTicketHasUsers = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().getAllUsersByTicketId(ses, selectedTicket.getId());
                                        if (!getTicketHasUsers.isEmpty()) {
                                            for (TmTicketsHasUmUser ticketHasUser : getTicketHasUsers) {
                                                  String smsCnt = ticketHasUser.getUmUser().getFirstName() +" "+ ticketHasUser.getUmUser().getLastName()+ " has Reply To Issue Number " + selectedTicket.getTid();
                                                  String smsStatus = SMS_MODEL.Send_SMS(activeUser.getMobileNumber(), smsCnt); 
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
                        }
                    } else {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Issue Not Found");
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
