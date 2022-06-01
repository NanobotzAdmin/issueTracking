/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.ticketManagement;

import com.it.configurationModel.SMS_MODEL;
import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.LmLocations;
import com.it.db.QmCategories;
import com.it.db.QmQueue;
import com.it.db.QmSubCategories;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.TmTicketMedia;
import com.it.db.TmTickets;
import com.it.db.TmTicketsHasUmUser;
import com.it.db.UmCustomer;
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
@WebServlet(name = "ticketManagement_addTicket", urlPatterns = {"/ticketManagement_addTicket"})
public class ticketManagement_addTicket extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, String> resultMap = new HashMap<String, String>();
        Session ses = com.it.connection.Connection.getSessionFactory().openSession();
        Transaction tr = ses.beginTransaction();
        Logger logger = Logger.getLogger(this.getClass().getName());
        UmUser activeUser = null;
        String locationName = "";
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
                    String ticketName = "";
                    String queueIdToTicket = "";
                    String category = "";
                    String subCategory = "";
                    String location = "";
                    String ticketDetails = "";
                    String ticketKey = "";
                    String customer = "";
                    String ticketD = "";
                    String hhh = "";
                    FileItemFactory factory = new DiskFileItemFactory();
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    List<FileItem> items = upload.parseRequest(request);
                    for (FileItem element : items) {
                        FileItem fileitem = (FileItem) element;
                        if (fileitem.isFormField()) {
                            if (fileitem.getFieldName().equals("queueIdToTicket")) {
                                queueIdToTicket = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("ticketName")) {
                                ticketName = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("loadCategoryByQueueIdForNewTicket")) {
                                category = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("loadSubCategoryByCategoryIdForNewTicket")) {
                                subCategory = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("loadLocationForNewTicket")) {
                                location = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("ticketDetails")) {
                                ticketDetails = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("ticketKey")) {
                                ticketKey = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("customerForTicket")) {
                                customer = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("encodedString")) {
                                ticketD = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("usersDetails")) {
                                hhh = fileitem.getString();
                            }
                        } else {
//                            if (fileitem.getFieldName().equals("ticketFiles")) {
//                                String extention = new File(element.getName()).getName();
//                                if (!extention.equals("")) {
//                                    FileItem queueBgImage = element;
////                                    System.out.println("queueBgImage = " + queueBgImage);
//                                }
//                            }
                        }
                    }
//                    System.out.println("ticketName = " + ticketName);
//                    System.out.println("queueIdToTicket = " + queueIdToTicket);
//                    System.out.println("category = " + category);
//                    System.out.println("subCategory = " + subCategory);
//                    System.out.println("ticketKey = " + ticketKey);
//                    System.out.println("ticketDetails = " + ticketDetails);
//                    System.out.println("ticketD = " + ticketD);
//                    String fqn = new String(ticketD.getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
//                    System.out.println("FINAL TICKET DETAILS = " + ticketName);
                    Date addedDate = new Date();
                    Date updatedDate = new Date();
                    int loadCategoryId = Integer.parseInt(category);
                    int loadSubCategoryId = Integer.parseInt(subCategory);
                    int queueId = Integer.parseInt(queueIdToTicket);
                    int locationId = Integer.parseInt(location);
                    int customerInt = Integer.parseInt(customer);
                    QmCategories selectedCategory = null;
                    QmSubCategories selectedSubCategory = null;
                    LmLocations selectedLocation = null;
                    UmCustomer selectedCustomer = null;
                    String decodedString = URLDecoder.decode(ticketD, "UTF-8");
//                    System.out.println("decode details = " + decodedString);
                    byte status = STATIC_DATA_MODEL.TICKETACTIVE;
                    double totalExpenses = 0;
                    if (ticketName.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Issue Name.");
//                    } else if (loadCategoryId == 0) {
//                        resultMap.put("result", "0");
//                        resultMap.put("displayMessage", "Select Category");
//                    } else if (loadSubCategoryId == 0) {
//                        resultMap.put("result", "0");
//                        resultMap.put("displayMessage", "Select Sub Category");
                    } else {
//                        select queue 
                        QmQueue selectedQueue = (QmQueue) ses.load(QmQueue.class, queueId);
                        if (loadCategoryId > 0) {
//                        select category
                            selectedCategory = (QmCategories) ses.load(QmCategories.class, loadCategoryId);
                        }
                        if (loadSubCategoryId > 0) {
//                        select sub category
                            selectedSubCategory = (QmSubCategories) ses.load(QmSubCategories.class, loadSubCategoryId);
                        }
                        if (locationId > 0) {
//                        select location
                            selectedLocation = (LmLocations) ses.load(LmLocations.class, locationId);
                        }
                        if (selectedQueue != null) {
                            if (customerInt > 0) {
                                selectedCustomer = (UmCustomer) ses.load(UmCustomer.class, customerInt);
                            }
                            String ticketLocation = "";
                            String ticketCustomer = "";
                            String ticketCustomerEmail = "";
                            String ticketCustomerPhoneNumber = "";
                            if (selectedLocation != null) {
                                ticketLocation = selectedLocation.getLocationName();
                            }
                            if (selectedCustomer != null) {
                                ticketCustomer = selectedCustomer.getCustomerName();
                                ticketCustomerEmail = selectedCustomer.getEmailAddress();
                                ticketCustomerPhoneNumber = selectedCustomer.getMobileNumber();
                            }
//                           save ticket details
                            TmTickets addNewTicket = new com.it.ticketManagementModel.TMS_TM_Tickets().saveTicket(ses, ticketName, decodedString, status, totalExpenses, updatedDate, updatedDate, selectedQueue, selectedCategory, selectedSubCategory, ticketKey, activeUser.getId(), activeUser.getId(), selectedCustomer, selectedLocation);
                            if (addNewTicket != null) {
                                //Get Active session object
                                SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                //Save session activity
                                String saveTicketSessionActivityContent = addNewTicket.getTicketName() + " Issue has been Saved by " + activeUser.getFirstName() + " on " + addedDate;
                                SmSessionActivity sessionActivityToAddTicket = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.ISSUESMANAGEMENT, addNewTicket.getId(), activeSession, activeUser);
                                if (sessionActivityToAddTicket != null) {
//                                        add Ticket has media files
                                    String QueueBackGroundEmage = "Issue Media Files/" + addNewTicket.getTicketName() + " - " + addNewTicket.getId();
                                    new fileUpload_Management().createFolder(fileUpload_Management.fileUploadingPath, QueueBackGroundEmage);
                                    for (FileItem element : items) {
                                        FileItem fileitem2 = (FileItem) element;
                                        if (!fileitem2.isFormField()) {
                                            if (fileitem2.getFieldName().equals("ticketFiles")) {
                                                String extention = new File(element.getName()).getName();
                                                if (!extention.equals("")) {
                                                    FileItem ticketMediaFiles = element;
//                                                    System.out.println("ticketMediaFiles = " + ticketMediaFiles);
                                                    String extensionRemoved = ticketMediaFiles.getName().split("\\.")[1];
//                                                    if (extensionRemoved.equalsIgnoreCase("png") || extensionRemoved.equalsIgnoreCase("GIF") || extensionRemoved.equalsIgnoreCase("JPEG") || extensionRemoved.equalsIgnoreCase("TIFF")
//                                                            || extensionRemoved.equalsIgnoreCase("JPG") || extensionRemoved.equalsIgnoreCase("mp4") || extensionRemoved.equalsIgnoreCase("mp3") || extensionRemoved.equalsIgnoreCase("doc")
//                                                            || extensionRemoved.equalsIgnoreCase("docx") || extensionRemoved.equalsIgnoreCase("CSV") || extensionRemoved.equalsIgnoreCase("XLS ") || extensionRemoved.equalsIgnoreCase("xlsx")) {
                                                        if (ticketMediaFiles.getSize() <= 12000000) {
                                                            String saveTicketFiles = new com.it.fileUploadManagementModel.fileUpload_Management().fileItem(ticketMediaFiles, QueueBackGroundEmage);
//                                                    System.out.println("type = " + ticketMediaFiles.getContentType());
//                                                    System.out.println("path = " + saveTicketFiles);
                                                            TmTicketMedia saveTicketMedia = new com.it.ticketManagementModel.TMS_TM_Ticket_Media().saveTicketMedia(ses, extensionRemoved, saveTicketFiles, STATIC_DATA_MODEL.PMACTIVE, updatedDate, updatedDate, addNewTicket, activeUser.getId(), activeUser.getId());
                                                            String saveTicketMediaSessionActivityContent = saveTicketMedia.getId() + " Issue Media has been Saved by " + activeUser.getFirstName() + " on " + addedDate;
                                                            SmSessionActivity sessionActivityToAddTicketMedia = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketMediaSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.ISSUESMANAGEMENT, addNewTicket.getId(), activeSession, activeUser);
                                                        }
//                                                    }
                                                }
                                            }
                                        }
                                    }
//                                    if (selectedCustomer != null && selectedCustomer.getIsVerified() == 1) {
////                                        System.out.println("get in");
////                                        int hh = Integer.parseInt(selectedCustomer.getMobileNumber());
//                                        String msg = "Your inquiry has been recorded in our ticketing system. Inquiry Reference: " + ticketKey + ". Click here to track your inquiry https://ring.visioncare.lk/Ring/publicTicketView.jsp?ticketid="+ticketKey;
//                                        String smsStatus = SMS_MODEL.PostSend(msg, selectedCustomer.getMobileNumber());
////                                        System.out.println("sms status = " + smsStatus);
//                                        if (smsStatus.equals("200")) {
////                                            System.out.println("msg send");
//                                        } else {
////                                            System.out.println("msg not send");
//                                        }
//                                    }
//                                    String ticketStatus = null;
//                                    if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETPENDING) {
//                                        ticketStatus = "<span style=\"color:orange\">Pending</span>";
//                                    } else if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETACTIVE) {
//                                        ticketStatus = "<span style=\"color:green\">Active</span>";
//                                    } else if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETSTARTED) {
//                                        ticketStatus = "<span style=\"color:blue\">Started</span>";
//                                    } else if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETCOMPLETED) {
//                                        ticketStatus = "<span style=\"color:black\">Completed</span>";
//                                    } else if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETCONFIRMED) {
//                                        ticketStatus = "<span style=\"color:red\">Confirmed</span>";
//                                    }
                                    org.json.JSONObject jObj = new org.json.JSONObject(hhh);
                                    org.json.JSONArray acData = jObj.getJSONArray("AC");
                                    int r = acData.length();
//                            if (r > 0) {
//                                status = STATIC_DATA_MODEL.TICKETACTIVE;
//                            }
                                    //Get Active session object
//                            SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
//                                        add Ticket has users
                                    if (r > 0) {
                                        for (int i = 0; i < r; ++i) {
                                            org.json.JSONObject data = acData.getJSONObject(i);
                                            int userId = Integer.parseInt(data.getString("userId"));
                                            UmUser selecUser = (UmUser) ses.load(UmUser.class, userId);
                                            if (selecUser != null) {
//                                        System.out.println("ticket id = " + selectedTicket.getId());
//                                        System.out.println("ticket name = " + selectedTicket.getTicketName());
//                                        System.out.println("user id = " + selecUser.getId() + " name = " + selecUser.getFirstName());
//                                                    add user to Ticket
                                                TmTicketsHasUmUser addUsersToTicket = new com.it.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().addTicketHasUsers(ses, addNewTicket.getId(), selecUser.getId(), STATIC_DATA_MODEL.PMACTIVE, addedDate, addedDate, activeUser.getId(), activeUser.getId());
                                                String saveTicketHasUserSessionActivityContent = addUsersToTicket.getUmUser().getFirstName() + " User has been Added To " + addUsersToTicket.getTmTickets().getId() + " Issue by " + activeUser.getFirstName() + " on " + addedDate;
                                                SmSessionActivity sessionActivityToAddUserToTicket = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketHasUserSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.ISSUESMANAGEMENT, addNewTicket.getId(), activeSession, activeUser);
                                                if (selecUser.getMobileNumber() != null) {
                                                    String smsCnt = activeUser.getFirstName() + " " + activeUser.getLastName() + " has given you a new Issue ";
                                                    String smsStatus = SMS_MODEL.Send_SMS(selecUser.getMobileNumber(), smsCnt); 
                                                }
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
                                resultMap.put("displayMessage", "Error ! Issue Not Saved !");
                            }
                        } else {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Error ! Queue not Selected !");
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
