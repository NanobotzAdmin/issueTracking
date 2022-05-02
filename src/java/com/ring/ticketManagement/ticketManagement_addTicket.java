/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.ticketManagement;

import com.ring.configurationModel.EMAIL_MODEL;
import com.ring.configurationModel.SMS_MODEL;
import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.LmLocations;
import com.ring.db.QmCategories;
import com.ring.db.QmQueue;
import com.ring.db.QmQueueHasUser;
import com.ring.db.QmSubCategories;
import com.ring.db.SmSession;
import com.ring.db.SmSessionActivity;
import com.ring.db.TmTicketMedia;
import com.ring.db.TmTickets;
import com.ring.db.TmTicketsHasUmUser;
import com.ring.db.UmCustomer;
import com.ring.db.UmUser;
import com.ring.fileUploadManagementModel.fileUpload_Management;
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
        Session ses = com.ring.connection.Connection.getSessionFactory().openSession();
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
                        resultMap.put("displayMessage", "Enter Ticket Name.");
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

//                            save ticket details
                            TmTickets addNewTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets().saveTicket(ses, ticketName, decodedString, status, totalExpenses, updatedDate, updatedDate, selectedQueue, selectedCategory, selectedSubCategory, ticketKey, activeUser.getId(), activeUser.getId(), selectedCustomer, selectedLocation);
                            if (addNewTicket != null) {
                                //Get Active session object
                                SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                //Save session activity
                                String saveTicketSessionActivityContent = addNewTicket.getTicketName() + " Ticket has been Saved by " + activeUser.getFirstName() + " on " + addedDate;
                                SmSessionActivity sessionActivityToAddTicket = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.TICKETMANAGEMENT, addNewTicket.getId(), activeSession, activeUser);
                                if (sessionActivityToAddTicket != null) {
//                                        add Ticket has media files
                                    String QueueBackGroundEmage = "Ticket Media Files/" + addNewTicket.getTicketName() + " - " + addNewTicket.getId();
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
                                                    if (extensionRemoved.equalsIgnoreCase("png") || extensionRemoved.equalsIgnoreCase("GIF") || extensionRemoved.equalsIgnoreCase("JPEG") || extensionRemoved.equalsIgnoreCase("TIFF")
                                                            || extensionRemoved.equalsIgnoreCase("JPG") || extensionRemoved.equalsIgnoreCase("mp4") || extensionRemoved.equalsIgnoreCase("mp3") || extensionRemoved.equalsIgnoreCase("doc")
                                                            || extensionRemoved.equalsIgnoreCase("docx") || extensionRemoved.equalsIgnoreCase("CSV") || extensionRemoved.equalsIgnoreCase("XLS ") || extensionRemoved.equalsIgnoreCase("xlsx")) {
                                                        if (ticketMediaFiles.getSize() <= 12000000) {
                                                            String saveTicketFiles = new com.ring.fileUploadManagementModel.fileUpload_Management().fileItem(ticketMediaFiles, QueueBackGroundEmage);
//                                                    System.out.println("type = " + ticketMediaFiles.getContentType());
//                                                    System.out.println("path = " + saveTicketFiles);
                                                            TmTicketMedia saveTicketMedia = new com.ring.ticketManagementModel.TMS_TM_Ticket_Media().saveTicketMedia(ses, extensionRemoved, saveTicketFiles, STATIC_DATA_MODEL.PMACTIVE, updatedDate, updatedDate, addNewTicket, activeUser.getId(), activeUser.getId());
                                                            String saveTicketMediaSessionActivityContent = saveTicketMedia.getId() + " Ticket Media has been Saved by " + activeUser.getFirstName() + " on " + addedDate;
                                                            SmSessionActivity sessionActivityToAddTicketMedia = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketMediaSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.TICKETMANAGEMENT, addNewTicket.getId(), activeSession, activeUser);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if (selectedCustomer != null && selectedCustomer.getIsVerified() == 1) {
//                                        System.out.println("get in");
//                                        int hh = Integer.parseInt(selectedCustomer.getMobileNumber());
                                        String msg = "Your inquiry has been recorded in our ticketing system. Inquiry Reference: " + ticketKey + ". Click here to track your inquiry https://ring.visioncare.lk/Ring/publicTicketView.jsp?ticketid="+ticketKey;
                                        String smsStatus = SMS_MODEL.PostSend(msg, selectedCustomer.getMobileNumber());
//                                        System.out.println("sms status = " + smsStatus);
                                        if (smsStatus.equals("200")) {
//                                            System.out.println("msg send");
                                        } else {
//                                            System.out.println("msg not send");
                                        }

                                    }
                                    String ticketStatus = null;

                                    if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETPENDING) {
                                        ticketStatus = "<span style=\"color:orange\">Pending</span>";
                                    } else if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETACTIVE) {
                                        ticketStatus = "<span style=\"color:green\">Active</span>";
                                    } else if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETCOMPLETED) {
                                        ticketStatus = "<span style=\"color:blue\">Completed</span>";
                                    } else if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETCONFIRMED) {
                                        ticketStatus = "<span style=\"color:black\">Confirmed</span>";
                                    } else if (addNewTicket.getStatus() == STATIC_DATA_MODEL.TICKETARCHIVE) {
                                        ticketStatus = "<span style=\"color:red\">Archive</span>";
                                    }

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
                                                String emailContent = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
                                                        + "<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" style=\"font-family:arial, 'helvetica neue', helvetica, sans-serif\">\n"
                                                        + "    <head>\n"
                                                        + "        <meta charset=\"UTF-8\">\n"
                                                        + "            <meta content=\"width=device-width, initial-scale=1\" name=\"viewport\">\n"
                                                        + "                <meta name=\"x-apple-disable-message-reformatting\">\n"
                                                        + "                    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n"
                                                        + "                        <meta content=\"telephone=no\" name=\"format-detection\">\n"
                                                        + "                            <title>Assigned to ticket</title><!--[if (mso 16)]>\n"
                                                        + "                            <style type=\"text/css\">\n"
                                                        + "                            a {text-decoration: none;}\n"
                                                        + "                            </style>\n"
                                                        + "                            <![endif]--><!--[if gte mso 9]><style>sup { font-size: 100% !important; }</style><![endif]--><!--[if gte mso 9]>\n"
                                                        + "                            <xml>\n"
                                                        + "                            <o:OfficeDocumentSettings>\n"
                                                        + "                            <o:AllowPNG></o:AllowPNG>\n"
                                                        + "                            <o:PixelsPerInch>96</o:PixelsPerInch>\n"
                                                        + "                            </o:OfficeDocumentSettings>\n"
                                                        + "                            </xml>\n"
                                                        + "                            <![endif]--><!--[if !mso]><!-- -->\n"
                                                        + "                            <link href=\"https://fonts.googleapis.com/css?family=Open+Sans:400,400i,700,700i\" rel=\"stylesheet\"><!--<![endif]-->\n"
                                                        + "                                <style type=\"text/css\">\n"
                                                        + "                                    #outlook a {\n"
                                                        + "                                        padding:0;\n"
                                                        + "                                    }\n"
                                                        + "                                    .es-button {\n"
                                                        + "                                        mso-style-priority:100!important;\n"
                                                        + "                                        text-decoration:none!important;\n"
                                                        + "                                    }\n"
                                                        + "                                    a[x-apple-data-detectors] {\n"
                                                        + "                                        color:inherit!important;\n"
                                                        + "                                        text-decoration:none!important;\n"
                                                        + "                                        font-size:inherit!important;\n"
                                                        + "                                        font-family:inherit!important;\n"
                                                        + "                                        font-weight:inherit!important;\n"
                                                        + "                                        line-height:inherit!important;\n"
                                                        + "                                    }\n"
                                                        + "                                    .es-desk-hidden {\n"
                                                        + "                                        display:none;\n"
                                                        + "                                        float:left;\n"
                                                        + "                                        overflow:hidden;\n"
                                                        + "                                        width:0;\n"
                                                        + "                                        max-height:0;\n"
                                                        + "                                        line-height:0;\n"
                                                        + "                                        mso-hide:all;\n"
                                                        + "                                    }\n"
                                                        + "                                    [data-ogsb] .es-button {\n"
                                                        + "                                        border-width:0!important;\n"
                                                        + "                                        padding:10px 20px 10px 20px!important;\n"
                                                        + "                                    }\n"
                                                        + "                                    @media only screen and (max-width:600px) {p, ul li, ol li, a { line-height:150%!important } h1, h2, h3, h1 a, h2 a, h3 a { line-height:120% } h1 { font-size:30px!important; text-align:left } h2 { font-size:24px!important; text-align:left } h3 { font-size:20px!important; text-align:left } .es-header-body h1 a, .es-content-body h1 a, .es-footer-body h1 a { font-size:30px!important; text-align:left } .es-header-body h2 a, .es-content-body h2 a, .es-footer-body h2 a { font-size:24px!important; text-align:left } .es-header-body h3 a, .es-content-body h3 a, .es-footer-body h3 a { font-size:20px!important; text-align:left } .es-menu td a { font-size:14px!important } .es-header-body p, .es-header-body ul li, .es-header-body ol li, .es-header-body a { font-size:14px!important } .es-content-body p, .es-content-body ul li, .es-content-body ol li, .es-content-body a { font-size:14px!important } .es-footer-body p, .es-footer-body ul li, .es-footer-body ol li, .es-footer-body a { font-size:14px!important } .es-infoblock p, .es-infoblock ul li, .es-infoblock ol li, .es-infoblock a { font-size:12px!important } *[class=\"gmail-fix\"] { display:none!important } .es-m-txt-c, .es-m-txt-c h1, .es-m-txt-c h2, .es-m-txt-c h3 { text-align:center!important } .es-m-txt-r, .es-m-txt-r h1, .es-m-txt-r h2, .es-m-txt-r h3 { text-align:right!important } .es-m-txt-l, .es-m-txt-l h1, .es-m-txt-l h2, .es-m-txt-l h3 { text-align:left!important } .es-m-txt-r img, .es-m-txt-c img, .es-m-txt-l img { display:inline!important } .es-button-border { display:inline-block!important } a.es-button, button.es-button { font-size:18px!important; display:inline-block!important } .es-adaptive table, .es-left, .es-right { width:100%!important } .es-content table, .es-header table, .es-footer table, .es-content, .es-footer, .es-header { width:100%!important; max-width:600px!important } .es-adapt-td { display:block!important; width:100%!important } .adapt-img { width:100%!important; height:auto!important } .es-m-p0 { padding:0!important } .es-m-p0r { padding-right:0!important } .es-m-p0l { padding-left:0!important } .es-m-p0t { padding-top:0!important } .es-m-p0b { padding-bottom:0!important } .es-m-p20b { padding-bottom:20px!important } .es-mobile-hidden, .es-hidden { display:none!important } tr.es-desk-hidden, td.es-desk-hidden, table.es-desk-hidden { width:auto!important; overflow:visible!important; float:none!important; max-height:inherit!important; line-height:inherit!important } tr.es-desk-hidden { display:table-row!important } table.es-desk-hidden { display:table!important } td.es-desk-menu-hidden { display:table-cell!important } .es-menu td { width:1%!important } table.es-table-not-adapt, .esd-block-html table { width:auto!important } table.es-social { display:inline-block!important } table.es-social td { display:inline-block!important } .es-m-p5 { padding:5px!important } .es-m-p5t { padding-top:5px!important } .es-m-p5b { padding-bottom:5px!important } .es-m-p5r { padding-right:5px!important } .es-m-p5l { padding-left:5px!important } .es-m-p10 { padding:10px!important } .es-m-p10t { padding-top:10px!important } .es-m-p10b { padding-bottom:10px!important } .es-m-p10r { padding-right:10px!important } .es-m-p10l { padding-left:10px!important } .es-m-p15 { padding:15px!important } .es-m-p15t { padding-top:15px!important } .es-m-p15b { padding-bottom:15px!important } .es-m-p15r { padding-right:15px!important } .es-m-p15l { padding-left:15px!important } .es-m-p20 { padding:20px!important } .es-m-p20t { padding-top:20px!important } .es-m-p20r { padding-right:20px!important } .es-m-p20l { padding-left:20px!important } .es-m-p25 { padding:25px!important } .es-m-p25t { padding-top:25px!important } .es-m-p25b { padding-bottom:25px!important } .es-m-p25r { padding-right:25px!important } .es-m-p25l { padding-left:25px!important } .es-m-p30 { padding:30px!important } .es-m-p30t { padding-top:30px!important } .es-m-p30b { padding-bottom:30px!important } .es-m-p30r { padding-right:30px!important } .es-m-p30l { padding-left:30px!important } .es-m-p35 { padding:35px!important } .es-m-p35t { padding-top:35px!important } .es-m-p35b { padding-bottom:35px!important } .es-m-p35r { padding-right:35px!important } .es-m-p35l { padding-left:35px!important } .es-m-p40 { padding:40px!important } .es-m-p40t { padding-top:40px!important } .es-m-p40b { padding-bottom:40px!important } .es-m-p40r { padding-right:40px!important } .es-m-p40l { padding-left:40px!important } }\n"
                                                        + "                                </style>\n"
                                                        + "                                </head>\n"
                                                        + "                                <body data-new-gr-c-s-loaded=\"14.1055.0\" style=\"width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0\">\n"
                                                        + "                                    <div class=\"es-wrapper-color\" style=\"background-color:#FAFBFB\"><!--[if gte mso 9]>\n"
                                                        + "                                    <v:background xmlns:v=\"urn:schemas-microsoft-com:vml\" fill=\"t\">\n"
                                                        + "                                    <v:fill type=\"tile\" color=\"#fafbfb\"></v:fill>\n"
                                                        + "                                    </v:background>\n"
                                                        + "                                    <![endif]-->\n"
                                                        + "                                        <table class=\"es-wrapper\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;background-color:#FAFBFB\">\n"
                                                        + "                                            <tr>\n"
                                                        + "                                                <td valign=\"top\" style=\"padding:0;Margin:0\">\n"
                                                        + "                                                    <table class=\"es-header\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top\">\n"
                                                        + "                                                        <tr>\n"
                                                        + "                                                            <td align=\"center\" style=\"padding:0;Margin:0\">\n"
                                                        + "                                                                <table class=\"es-header-body\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#ffffff\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px\">\n"
                                                        + "                                                                    <tr>\n"
                                                        + "                                                                        <td align=\"left\" bgcolor=\"#ecebeb\" style=\"Margin:0;padding-bottom:10px;padding-top:15px;padding-left:20px;padding-right:20px;background-color:#ecebeb\"><!--[if mso]><table style=\"width:560px\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"width:299px\" valign=\"top\"><![endif]-->\n"
                                                        + "                                                                            <table class=\"es-left\" cellspacing=\"0\" cellpadding=\"0\" align=\"left\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td class=\"es-m-p0r es-m-p20b\" align=\"center\" style=\"padding:0;Margin:0;width:299px\">\n"
                                                        + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td class=\"es-m-txt-c\" align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\">" + new Date() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Title&nbsp;</b>" + addNewTicket.getTicketName() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-top:10px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Ref:&nbsp;</b>" + addNewTicket.getTid() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Created by:&nbsp;</b>" + activeUser.getFirstName() + " " + activeUser.getLastName() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Created Date:&nbsp;</b>" + addNewTicket.getCreatedAt() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Location:&nbsp;</b>" + ticketLocation + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Queue Name:&nbsp;</b>" + addNewTicket.getQmQueue().getQueueName() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Customer Name:&nbsp;</b>" + ticketCustomer + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Customer Email:&nbsp;</b>" + ticketCustomerEmail + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Customer Phone Number:&nbsp;</b>" + ticketCustomerPhoneNumber + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table><!--[if mso]></td><td style=\"width:20px\"></td><td style=\"width:241px\" valign=\"top\"><![endif]-->\n"
                                                        + "                                                                            <table class=\"es-right\" cellspacing=\"0\" cellpadding=\"0\" align=\"right\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td align=\"center\" style=\"padding:0;Margin:0;width:241px\">\n"
                                                        + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td class=\"es-m-p0l\" align=\"right\" style=\"padding:0;Margin:0;font-size:0px\"><a href=\"https://ring.visioncare.lk/\" target=\"_blank\" style=\"-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;text-decoration:underline;color:#2CB543;font-size:14px\"><img src=\"https://lkgca.stripocdn.email/content/guids/CABINET_6aa402089819e66ea9f9f022e51770cf/images/colouredlogo_aZE.png\" alt=\"ring ticket management system\" width=\"98\" style=\"display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic\" title=\"ring ticket management system\"></a></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"right\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:'open sans', 'helvetica neue', helvetica, arial, sans-serif;line-height:32px;color:#0099ff;font-size:21px\">&nbsp;Ticket Management</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"right\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:-apple-system, blinkmacsystemfont, 'segoe ui', roboto, helvetica, arial, sans-serif, 'apple color emoji', 'segoe ui emoji', 'segoe ui symbol';line-height:18px;color:#000000;font-size:12px\">Next Generation of Customer Service</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table><!--[if mso]></td></tr></table><![endif]--></td>\n"
                                                        + "                                                                    </tr>\n"
                                                        + "                                                                    <tr>\n"
                                                        + "                                                                        <td align=\"left\" style=\"padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px\"><!--[if mso]><table style=\"width:560px\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"width:249px\" valign=\"top\"><![endif]-->\n"
                                                        + "                                                                            <table cellpadding=\"0\" cellspacing=\"0\" class=\"es-left\" align=\"left\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td class=\"es-m-p20b\" align=\"left\" style=\"padding:0;Margin:0;width:249px\">\n"
                                                        + "                                                                                        <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-top:15px\"><h3 style=\"Margin:0;line-height:24px;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:20px;font-style:normal;font-weight:normal;color:#333333\">Assigned to Ticket | " + ticketStatus + "</h3></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table><!--[if mso]></td><td style=\"width:20px\"></td><td style=\"width:291px\" valign=\"top\"><![endif]-->\n"
                                                        + "                                                                            <table cellpadding=\"0\" cellspacing=\"0\" class=\"es-right\" align=\"right\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td align=\"left\" style=\"padding:0;Margin:0;width:291px\">\n"
                                                        + "                                                                                        <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0;padding-top:25px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:11px;color:#333333;font-size:11px\">Assigned by : " + activeUser.getFirstName() + "&nbsp;</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table><!--[if mso]></td></tr></table><![endif]--></td>\n"
                                                        + "                                                                    </tr>\n"
                                                        + "                                                                    <tr>\n"
                                                        + "                                                                        <td align=\"left\" style=\"padding:0;Margin:0;padding-left:20px;padding-right:20px\">\n"
                                                        + "                                                                            <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td valign=\"top\" align=\"center\" style=\"padding:0;Margin:0;width:560px\">\n"
                                                        + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"center\" style=\"padding:0;Margin:0;font-size:0\">\n"
                                                        + "                                                                                                    <table border=\"0\" width=\"100%\" height=\"100%\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                                        <tr>\n"
                                                        + "                                                                                                            <td style=\"padding:0;Margin:0;border-bottom:1px solid #cccccc;background:unset;height:1px;width:100%;margin:0px\"></td>\n"
                                                        + "                                                                                                        </tr>\n"
                                                        + "                                                                                                    </table></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-bottom:5px;padding-top:10px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">Dear <strong>" + selecUser.getFirstName() + "</strong>, You have been assigned to this ticket.</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-top:10px;padding-bottom:15px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">\n"
                                                        + "                                                                                                        <strong>Ticket Description:</strong><br>\n"
                                                        + "                                                                                                           " + addNewTicket.getTicketDescription() + "\n"
                                                        + "                                                                                                            </p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"center\" style=\"padding:15px;Margin:0;font-size:0\">\n"
                                                        + "                                                                                                    <table border=\"0\" width=\"100%\" height=\"100%\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                                        <tr>\n"
                                                        + "                                                                                                            <td style=\"padding:0;Margin:0;border-bottom:0px solid #cccccc;background:unset;height:1px;width:100%;margin:0px\"></td>\n"
                                                        + "                                                                                                        </tr>\n"
                                                        + "                                                                                                    </table></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table></td>\n"
                                                        + "                                                                    </tr>\n"
                                                        + "                                                                </table></td>\n"
                                                        + "                                                        </tr>\n"
                                                        + "                                                    </table>\n"
                                                        + "                                                    <table class=\"es-footer\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top\">\n"
                                                        + "                                                        <tr>\n"
                                                        + "                                                            <td align=\"center\" style=\"padding:0;Margin:0\">\n"
                                                        + "                                                                <table class=\"es-footer-body\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#ffffff\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px\">\n"
                                                        + "                                                                    <tr>\n"
                                                        + "                                                                        <td align=\"left\" bgcolor=\"#ecebeb\" style=\"padding:20px;Margin:0;background-color:#ecebeb\">\n"
                                                        + "                                                                            <table cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td align=\"left\" style=\"padding:0;Margin:0;width:560px\">\n"
                                                        + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td esdev-links-color=\"#666666\" align=\"center\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:14px\"><span style=\"font-size:14px\">You're receiving this email because you are a user registered to<br><strong>Ring Ticket Management</strong>&nbsp;<br>This is a system generated message. Do not reply.<br>Technical Support on Ring Ticket Management | Call Isuru: 077 125 4919</span><br><br><span style=\"font-size:10px\">All copyrights reserved by Vision Care Optical Services | RING Ticket Management System &copy;2022 | Powered By <a href=\"https://nanobotz.lk/\">Nanobotz</a></span></p></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table>\n"
                                                        + "                                                                                                                                </div>\n"
                                                        + "                                                                                                                                </body>\n"
                                                        + "                                                                                                                                </html>";

                                                TmTicketsHasUmUser addUsersToTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().addTicketHasUsers(ses, addNewTicket.getId(), selecUser.getId(), STATIC_DATA_MODEL.PMACTIVE, addedDate, addedDate, activeUser.getId(), activeUser.getId());
                                                String saveTicketHasUserSessionActivityContent = addUsersToTicket.getUmUser().getFirstName() + " User has been Added To " + addUsersToTicket.getTmTickets().getId() + " Ticket by " + activeUser.getFirstName() + " on " + addedDate;
                                                SmSessionActivity sessionActivityToAddUserToTicket = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketHasUserSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.TICKETMANAGEMENT, addNewTicket.getId(), activeSession, activeUser);
                                                if (selecUser.getEmailAddress() != null) {
//                                            System.out.println("hg5fhgfjgkjfhytdjhgjdhgfkgjhfhfjk");

                                                    if (addNewTicket.getLmLocations() != null) {
                                                        locationName = addNewTicket.getLmLocations().getLocationName();
                                                    }

                                                    String emailSubject = addNewTicket.getQmQueue().getQueueName() + " | " + addNewTicket.getTid() + " | " + locationName;
                                                    EMAIL_MODEL.Sendmail(selecUser.getEmailAddress(), emailSubject, emailContent);
                                                }
                                            }
                                        }
                                    } else {
//                                add ticket created user to ticket has user table default
                                        TmTicketsHasUmUser addUsersToTicket = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User().addTicketHasUsers(ses, addNewTicket.getId(), activeUser.getId(), STATIC_DATA_MODEL.PMACTIVE, addedDate, addedDate, activeUser.getId(), activeUser.getId());
//                                UmUser ticketCreatedUser = (UmUser) ses.load(UmUser.class, addNewTicket.getCreatedBy());
                                        String saveTicketHasUserSessionActivityContent = activeUser.getFirstName() + " User has been Added To " + addNewTicket.getId() + " Ticket by " + activeUser.getFirstName() + " on " + addedDate;
                                        SmSessionActivity sessionActivityToAddUserToTicket = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivityNew(ses, saveTicketHasUserSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.TICKETMANAGEMENT, addNewTicket.getId(), activeSession, activeUser);

                                        String emailContent = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
                                                + "<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" style=\"font-family:arial, 'helvetica neue', helvetica, sans-serif\">\n"
                                                + "    <head>\n"
                                                + "        <meta charset=\"UTF-8\">\n"
                                                + "            <meta content=\"width=device-width, initial-scale=1\" name=\"viewport\">\n"
                                                + "                <meta name=\"x-apple-disable-message-reformatting\">\n"
                                                + "                    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n"
                                                + "                        <meta content=\"telephone=no\" name=\"format-detection\">\n"
                                                + "                            <title>Assigned to ticket</title><!--[if (mso 16)]>\n"
                                                + "                            <style type=\"text/css\">\n"
                                                + "                            a {text-decoration: none;}\n"
                                                + "                            </style>\n"
                                                + "                            <![endif]--><!--[if gte mso 9]><style>sup { font-size: 100% !important; }</style><![endif]--><!--[if gte mso 9]>\n"
                                                + "                            <xml>\n"
                                                + "                            <o:OfficeDocumentSettings>\n"
                                                + "                            <o:AllowPNG></o:AllowPNG>\n"
                                                + "                            <o:PixelsPerInch>96</o:PixelsPerInch>\n"
                                                + "                            </o:OfficeDocumentSettings>\n"
                                                + "                            </xml>\n"
                                                + "                            <![endif]--><!--[if !mso]><!-- -->\n"
                                                + "                            <link href=\"https://fonts.googleapis.com/css?family=Open+Sans:400,400i,700,700i\" rel=\"stylesheet\"><!--<![endif]-->\n"
                                                + "                                <style type=\"text/css\">\n"
                                                + "                                    #outlook a {\n"
                                                + "                                        padding:0;\n"
                                                + "                                    }\n"
                                                + "                                    .es-button {\n"
                                                + "                                        mso-style-priority:100!important;\n"
                                                + "                                        text-decoration:none!important;\n"
                                                + "                                    }\n"
                                                + "                                    a[x-apple-data-detectors] {\n"
                                                + "                                        color:inherit!important;\n"
                                                + "                                        text-decoration:none!important;\n"
                                                + "                                        font-size:inherit!important;\n"
                                                + "                                        font-family:inherit!important;\n"
                                                + "                                        font-weight:inherit!important;\n"
                                                + "                                        line-height:inherit!important;\n"
                                                + "                                    }\n"
                                                + "                                    .es-desk-hidden {\n"
                                                + "                                        display:none;\n"
                                                + "                                        float:left;\n"
                                                + "                                        overflow:hidden;\n"
                                                + "                                        width:0;\n"
                                                + "                                        max-height:0;\n"
                                                + "                                        line-height:0;\n"
                                                + "                                        mso-hide:all;\n"
                                                + "                                    }\n"
                                                + "                                    [data-ogsb] .es-button {\n"
                                                + "                                        border-width:0!important;\n"
                                                + "                                        padding:10px 20px 10px 20px!important;\n"
                                                + "                                    }\n"
                                                + "                                    @media only screen and (max-width:600px) {p, ul li, ol li, a { line-height:150%!important } h1, h2, h3, h1 a, h2 a, h3 a { line-height:120% } h1 { font-size:30px!important; text-align:left } h2 { font-size:24px!important; text-align:left } h3 { font-size:20px!important; text-align:left } .es-header-body h1 a, .es-content-body h1 a, .es-footer-body h1 a { font-size:30px!important; text-align:left } .es-header-body h2 a, .es-content-body h2 a, .es-footer-body h2 a { font-size:24px!important; text-align:left } .es-header-body h3 a, .es-content-body h3 a, .es-footer-body h3 a { font-size:20px!important; text-align:left } .es-menu td a { font-size:14px!important } .es-header-body p, .es-header-body ul li, .es-header-body ol li, .es-header-body a { font-size:14px!important } .es-content-body p, .es-content-body ul li, .es-content-body ol li, .es-content-body a { font-size:14px!important } .es-footer-body p, .es-footer-body ul li, .es-footer-body ol li, .es-footer-body a { font-size:14px!important } .es-infoblock p, .es-infoblock ul li, .es-infoblock ol li, .es-infoblock a { font-size:12px!important } *[class=\"gmail-fix\"] { display:none!important } .es-m-txt-c, .es-m-txt-c h1, .es-m-txt-c h2, .es-m-txt-c h3 { text-align:center!important } .es-m-txt-r, .es-m-txt-r h1, .es-m-txt-r h2, .es-m-txt-r h3 { text-align:right!important } .es-m-txt-l, .es-m-txt-l h1, .es-m-txt-l h2, .es-m-txt-l h3 { text-align:left!important } .es-m-txt-r img, .es-m-txt-c img, .es-m-txt-l img { display:inline!important } .es-button-border { display:inline-block!important } a.es-button, button.es-button { font-size:18px!important; display:inline-block!important } .es-adaptive table, .es-left, .es-right { width:100%!important } .es-content table, .es-header table, .es-footer table, .es-content, .es-footer, .es-header { width:100%!important; max-width:600px!important } .es-adapt-td { display:block!important; width:100%!important } .adapt-img { width:100%!important; height:auto!important } .es-m-p0 { padding:0!important } .es-m-p0r { padding-right:0!important } .es-m-p0l { padding-left:0!important } .es-m-p0t { padding-top:0!important } .es-m-p0b { padding-bottom:0!important } .es-m-p20b { padding-bottom:20px!important } .es-mobile-hidden, .es-hidden { display:none!important } tr.es-desk-hidden, td.es-desk-hidden, table.es-desk-hidden { width:auto!important; overflow:visible!important; float:none!important; max-height:inherit!important; line-height:inherit!important } tr.es-desk-hidden { display:table-row!important } table.es-desk-hidden { display:table!important } td.es-desk-menu-hidden { display:table-cell!important } .es-menu td { width:1%!important } table.es-table-not-adapt, .esd-block-html table { width:auto!important } table.es-social { display:inline-block!important } table.es-social td { display:inline-block!important } .es-m-p5 { padding:5px!important } .es-m-p5t { padding-top:5px!important } .es-m-p5b { padding-bottom:5px!important } .es-m-p5r { padding-right:5px!important } .es-m-p5l { padding-left:5px!important } .es-m-p10 { padding:10px!important } .es-m-p10t { padding-top:10px!important } .es-m-p10b { padding-bottom:10px!important } .es-m-p10r { padding-right:10px!important } .es-m-p10l { padding-left:10px!important } .es-m-p15 { padding:15px!important } .es-m-p15t { padding-top:15px!important } .es-m-p15b { padding-bottom:15px!important } .es-m-p15r { padding-right:15px!important } .es-m-p15l { padding-left:15px!important } .es-m-p20 { padding:20px!important } .es-m-p20t { padding-top:20px!important } .es-m-p20r { padding-right:20px!important } .es-m-p20l { padding-left:20px!important } .es-m-p25 { padding:25px!important } .es-m-p25t { padding-top:25px!important } .es-m-p25b { padding-bottom:25px!important } .es-m-p25r { padding-right:25px!important } .es-m-p25l { padding-left:25px!important } .es-m-p30 { padding:30px!important } .es-m-p30t { padding-top:30px!important } .es-m-p30b { padding-bottom:30px!important } .es-m-p30r { padding-right:30px!important } .es-m-p30l { padding-left:30px!important } .es-m-p35 { padding:35px!important } .es-m-p35t { padding-top:35px!important } .es-m-p35b { padding-bottom:35px!important } .es-m-p35r { padding-right:35px!important } .es-m-p35l { padding-left:35px!important } .es-m-p40 { padding:40px!important } .es-m-p40t { padding-top:40px!important } .es-m-p40b { padding-bottom:40px!important } .es-m-p40r { padding-right:40px!important } .es-m-p40l { padding-left:40px!important } }\n"
                                                + "                                </style>\n"
                                                + "                                </head>\n"
                                                + "                                <body data-new-gr-c-s-loaded=\"14.1055.0\" style=\"width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0\">\n"
                                                + "                                    <div class=\"es-wrapper-color\" style=\"background-color:#FAFBFB\"><!--[if gte mso 9]>\n"
                                                + "                                    <v:background xmlns:v=\"urn:schemas-microsoft-com:vml\" fill=\"t\">\n"
                                                + "                                    <v:fill type=\"tile\" color=\"#fafbfb\"></v:fill>\n"
                                                + "                                    </v:background>\n"
                                                + "                                    <![endif]-->\n"
                                                + "                                        <table class=\"es-wrapper\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;background-color:#FAFBFB\">\n"
                                                + "                                            <tr>\n"
                                                + "                                                <td valign=\"top\" style=\"padding:0;Margin:0\">\n"
                                                + "                                                    <table class=\"es-header\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top\">\n"
                                                + "                                                        <tr>\n"
                                                + "                                                            <td align=\"center\" style=\"padding:0;Margin:0\">\n"
                                                + "                                                                <table class=\"es-header-body\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#ffffff\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px\">\n"
                                                + "                                                                    <tr>\n"
                                                + "                                                                        <td align=\"left\" bgcolor=\"#ecebeb\" style=\"Margin:0;padding-bottom:10px;padding-top:15px;padding-left:20px;padding-right:20px;background-color:#ecebeb\"><!--[if mso]><table style=\"width:560px\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"width:299px\" valign=\"top\"><![endif]-->\n"
                                                + "                                                                            <table class=\"es-left\" cellspacing=\"0\" cellpadding=\"0\" align=\"left\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left\">\n"
                                                + "                                                                                <tr>\n"
                                                + "                                                                                    <td class=\"es-m-p0r es-m-p20b\" align=\"center\" style=\"padding:0;Margin:0;width:299px\">\n"
                                                + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td class=\"es-m-txt-c\" align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\">" + new Date() + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Title&nbsp;</b>" + addNewTicket.getTicketName() + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-top:10px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Ref:&nbsp;</b>" + addNewTicket.getTid() + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Created by:&nbsp;</b>" + activeUser.getFirstName() + " " + activeUser.getLastName() + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Created Date:&nbsp;</b>" + addNewTicket.getCreatedAt() + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Location:&nbsp;</b>" + ticketLocation + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Queue Name:&nbsp;</b>" + addNewTicket.getQmQueue().getQueueName() + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Customer Name:&nbsp;</b>" + ticketCustomer + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Customer Email:&nbsp;</b>" + ticketCustomerEmail + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Customer Phone Number:&nbsp;</b>" + ticketCustomerPhoneNumber + "</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                        </table></td>\n"
                                                + "                                                                                </tr>\n"
                                                + "                                                                            </table><!--[if mso]></td><td style=\"width:20px\"></td><td style=\"width:241px\" valign=\"top\"><![endif]-->\n"
                                                + "                                                                            <table class=\"es-right\" cellspacing=\"0\" cellpadding=\"0\" align=\"right\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right\">\n"
                                                + "                                                                                <tr>\n"
                                                + "                                                                                    <td align=\"center\" style=\"padding:0;Margin:0;width:241px\">\n"
                                                + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td class=\"es-m-p0l\" align=\"right\" style=\"padding:0;Margin:0;font-size:0px\"><a href=\"https://ring.visioncare.lk/\" target=\"_blank\" style=\"-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;text-decoration:underline;color:#2CB543;font-size:14px\"><img src=\"https://lkgca.stripocdn.email/content/guids/CABINET_6aa402089819e66ea9f9f022e51770cf/images/colouredlogo_aZE.png\" alt=\"ring ticket management system\" width=\"98\" style=\"display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic\" title=\"ring ticket management system\"></a></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"right\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:'open sans', 'helvetica neue', helvetica, arial, sans-serif;line-height:32px;color:#0099ff;font-size:21px\">&nbsp;Ticket Management</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"right\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:-apple-system, blinkmacsystemfont, 'segoe ui', roboto, helvetica, arial, sans-serif, 'apple color emoji', 'segoe ui emoji', 'segoe ui symbol';line-height:18px;color:#000000;font-size:12px\">Next Generation of Customer Service</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                        </table></td>\n"
                                                + "                                                                                </tr>\n"
                                                + "                                                                            </table><!--[if mso]></td></tr></table><![endif]--></td>\n"
                                                + "                                                                    </tr>\n"
                                                + "                                                                    <tr>\n"
                                                + "                                                                        <td align=\"left\" style=\"padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px\"><!--[if mso]><table style=\"width:560px\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"width:249px\" valign=\"top\"><![endif]-->\n"
                                                + "                                                                            <table cellpadding=\"0\" cellspacing=\"0\" class=\"es-left\" align=\"left\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left\">\n"
                                                + "                                                                                <tr>\n"
                                                + "                                                                                    <td class=\"es-m-p20b\" align=\"left\" style=\"padding:0;Margin:0;width:249px\">\n"
                                                + "                                                                                        <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-top:15px\"><h3 style=\"Margin:0;line-height:24px;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:20px;font-style:normal;font-weight:normal;color:#333333\">Assigned to Ticket | " + ticketStatus + "</h3></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                        </table></td>\n"
                                                + "                                                                                </tr>\n"
                                                + "                                                                            </table><!--[if mso]></td><td style=\"width:20px\"></td><td style=\"width:291px\" valign=\"top\"><![endif]-->\n"
                                                + "                                                                            <table cellpadding=\"0\" cellspacing=\"0\" class=\"es-right\" align=\"right\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right\">\n"
                                                + "                                                                                <tr>\n"
                                                + "                                                                                    <td align=\"left\" style=\"padding:0;Margin:0;width:291px\">\n"
                                                + "                                                                                        <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0;padding-top:25px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:11px;color:#333333;font-size:11px\">Assigned by : " + activeUser.getFirstName() + "&nbsp;</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                        </table></td>\n"
                                                + "                                                                                </tr>\n"
                                                + "                                                                            </table><!--[if mso]></td></tr></table><![endif]--></td>\n"
                                                + "                                                                    </tr>\n"
                                                + "                                                                    <tr>\n"
                                                + "                                                                        <td align=\"left\" style=\"padding:0;Margin:0;padding-left:20px;padding-right:20px\">\n"
                                                + "                                                                            <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                <tr>\n"
                                                + "                                                                                    <td valign=\"top\" align=\"center\" style=\"padding:0;Margin:0;width:560px\">\n"
                                                + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"center\" style=\"padding:0;Margin:0;font-size:0\">\n"
                                                + "                                                                                                    <table border=\"0\" width=\"100%\" height=\"100%\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                                        <tr>\n"
                                                + "                                                                                                            <td style=\"padding:0;Margin:0;border-bottom:1px solid #cccccc;background:unset;height:1px;width:100%;margin:0px\"></td>\n"
                                                + "                                                                                                        </tr>\n"
                                                + "                                                                                                    </table></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-bottom:5px;padding-top:10px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">Dear <strong>" + addUsersToTicket.getUmUser().getFirstName() + "</strong>, You have been assigned to this ticket.</p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-top:10px;padding-bottom:15px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">\n"
                                                + "                                                                                                        <strong>Ticket Description:</strong><br>\n"
                                                + "                                                                                                           " + addNewTicket.getTicketDescription() + "\n"
                                                + "                                                                                                            </p></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td align=\"center\" style=\"padding:15px;Margin:0;font-size:0\">\n"
                                                + "                                                                                                    <table border=\"0\" width=\"100%\" height=\"100%\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                                        <tr>\n"
                                                + "                                                                                                            <td style=\"padding:0;Margin:0;border-bottom:0px solid #cccccc;background:unset;height:1px;width:100%;margin:0px\"></td>\n"
                                                + "                                                                                                        </tr>\n"
                                                + "                                                                                                    </table></td>\n"
                                                + "                                                                                            </tr>\n"
                                                + "                                                                                        </table></td>\n"
                                                + "                                                                                </tr>\n"
                                                + "                                                                            </table></td>\n"
                                                + "                                                                    </tr>\n"
                                                + "                                                                </table></td>\n"
                                                + "                                                        </tr>\n"
                                                + "                                                    </table>\n"
                                                + "                                                    <table class=\"es-footer\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top\">\n"
                                                + "                                                        <tr>\n"
                                                + "                                                            <td align=\"center\" style=\"padding:0;Margin:0\">\n"
                                                + "                                                                <table class=\"es-footer-body\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#ffffff\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px\">\n"
                                                + "                                                                    <tr>\n"
                                                + "                                                                        <td align=\"left\" bgcolor=\"#ecebeb\" style=\"padding:20px;Margin:0;background-color:#ecebeb\">\n"
                                                + "                                                                            <table cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                <tr>\n"
                                                + "                                                                                    <td align=\"left\" style=\"padding:0;Margin:0;width:560px\">\n"
                                                + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                + "                                                                                            <tr>\n"
                                                + "                                                                                                <td esdev-links-color=\"#666666\" align=\"center\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:14px\"><span style=\"font-size:14px\">You're receiving this email because you are a user registered to<br><strong>Ring Ticket Management</strong>&nbsp;<br>This is a system generated message. Do not reply.<br>Technical Support on Ring Ticket Management | Call Isuru: 077 125 4919</span><br><br><span style=\"font-size:10px\">All copyrights reserved by Vision Care Optical Services | RING Ticket Management System &copy;2022 | Powered By <a href=\"https://nanobotz.lk/\">Nanobotz</a></span></p></td>\n"
                                                + "                                                                                                                                </tr>\n"
                                                + "                                                                                                                                </table></td>\n"
                                                + "                                                                                                                                </tr>\n"
                                                + "                                                                                                                                </table></td>\n"
                                                + "                                                                                                                                </tr>\n"
                                                + "                                                                                                                                </table></td>\n"
                                                + "                                                                                                                                </tr>\n"
                                                + "                                                                                                                                </table></td>\n"
                                                + "                                                                                                                                </tr>\n"
                                                + "                                                                                                                                </table>\n"
                                                + "                                                                                                                                </div>\n"
                                                + "                                                                                                                                </body>\n"
                                                + "                                                                                                                                </html>";

                                        if (addNewTicket.getLmLocations() != null) {
                                            locationName = addNewTicket.getLmLocations().getLocationName();
                                        }

                                        String emailSubject = addNewTicket.getQmQueue().getQueueName() + " | " + addNewTicket.getTid() + " | " + locationName;
                                        EMAIL_MODEL.Sendmail(activeUser.getEmailAddress(), emailSubject, emailContent);
                                    }

                                    String emailContent3 = "";
                                    //                                    send mail to que has users
                                    List<QmQueueHasUser> getQueueHasUsers = new com.ring.queueManagementModel.QMS_QM_Queue_Has_User().getAllUsersByLocationId(ses, selectedQueue.getId());
                                    if (!getQueueHasUsers.isEmpty()) {
                                        for (QmQueueHasUser queueHasUser : getQueueHasUsers) {
                                            if (queueHasUser.getUmUser().getEmailAddress() != null) {

                                                emailContent3 = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
                                                        + "<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" style=\"font-family:arial, 'helvetica neue', helvetica, sans-serif\">\n"
                                                        + "    <head>\n"
                                                        + "        <meta charset=\"UTF-8\">\n"
                                                        + "            <meta content=\"width=device-width, initial-scale=1\" name=\"viewport\">\n"
                                                        + "                <meta name=\"x-apple-disable-message-reformatting\">\n"
                                                        + "                    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n"
                                                        + "                        <meta content=\"telephone=no\" name=\"format-detection\">\n"
                                                        + "                            <title>Assigned to ticket</title><!--[if (mso 16)]>\n"
                                                        + "                            <style type=\"text/css\">\n"
                                                        + "                            a {text-decoration: none;}\n"
                                                        + "                            </style>\n"
                                                        + "                            <![endif]--><!--[if gte mso 9]><style>sup { font-size: 100% !important; }</style><![endif]--><!--[if gte mso 9]>\n"
                                                        + "                            <xml>\n"
                                                        + "                            <o:OfficeDocumentSettings>\n"
                                                        + "                            <o:AllowPNG></o:AllowPNG>\n"
                                                        + "                            <o:PixelsPerInch>96</o:PixelsPerInch>\n"
                                                        + "                            </o:OfficeDocumentSettings>\n"
                                                        + "                            </xml>\n"
                                                        + "                            <![endif]--><!--[if !mso]><!-- -->\n"
                                                        + "                            <link href=\"https://fonts.googleapis.com/css?family=Open+Sans:400,400i,700,700i\" rel=\"stylesheet\"><!--<![endif]-->\n"
                                                        + "                                <style type=\"text/css\">\n"
                                                        + "                                    #outlook a {\n"
                                                        + "                                        padding:0;\n"
                                                        + "                                    }\n"
                                                        + "                                    .es-button {\n"
                                                        + "                                        mso-style-priority:100!important;\n"
                                                        + "                                        text-decoration:none!important;\n"
                                                        + "                                    }\n"
                                                        + "                                    a[x-apple-data-detectors] {\n"
                                                        + "                                        color:inherit!important;\n"
                                                        + "                                        text-decoration:none!important;\n"
                                                        + "                                        font-size:inherit!important;\n"
                                                        + "                                        font-family:inherit!important;\n"
                                                        + "                                        font-weight:inherit!important;\n"
                                                        + "                                        line-height:inherit!important;\n"
                                                        + "                                    }\n"
                                                        + "                                    .es-desk-hidden {\n"
                                                        + "                                        display:none;\n"
                                                        + "                                        float:left;\n"
                                                        + "                                        overflow:hidden;\n"
                                                        + "                                        width:0;\n"
                                                        + "                                        max-height:0;\n"
                                                        + "                                        line-height:0;\n"
                                                        + "                                        mso-hide:all;\n"
                                                        + "                                    }\n"
                                                        + "                                    [data-ogsb] .es-button {\n"
                                                        + "                                        border-width:0!important;\n"
                                                        + "                                        padding:10px 20px 10px 20px!important;\n"
                                                        + "                                    }\n"
                                                        + "                                    @media only screen and (max-width:600px) {p, ul li, ol li, a { line-height:150%!important } h1, h2, h3, h1 a, h2 a, h3 a { line-height:120% } h1 { font-size:30px!important; text-align:left } h2 { font-size:24px!important; text-align:left } h3 { font-size:20px!important; text-align:left } .es-header-body h1 a, .es-content-body h1 a, .es-footer-body h1 a { font-size:30px!important; text-align:left } .es-header-body h2 a, .es-content-body h2 a, .es-footer-body h2 a { font-size:24px!important; text-align:left } .es-header-body h3 a, .es-content-body h3 a, .es-footer-body h3 a { font-size:20px!important; text-align:left } .es-menu td a { font-size:14px!important } .es-header-body p, .es-header-body ul li, .es-header-body ol li, .es-header-body a { font-size:14px!important } .es-content-body p, .es-content-body ul li, .es-content-body ol li, .es-content-body a { font-size:14px!important } .es-footer-body p, .es-footer-body ul li, .es-footer-body ol li, .es-footer-body a { font-size:14px!important } .es-infoblock p, .es-infoblock ul li, .es-infoblock ol li, .es-infoblock a { font-size:12px!important } *[class=\"gmail-fix\"] { display:none!important } .es-m-txt-c, .es-m-txt-c h1, .es-m-txt-c h2, .es-m-txt-c h3 { text-align:center!important } .es-m-txt-r, .es-m-txt-r h1, .es-m-txt-r h2, .es-m-txt-r h3 { text-align:right!important } .es-m-txt-l, .es-m-txt-l h1, .es-m-txt-l h2, .es-m-txt-l h3 { text-align:left!important } .es-m-txt-r img, .es-m-txt-c img, .es-m-txt-l img { display:inline!important } .es-button-border { display:inline-block!important } a.es-button, button.es-button { font-size:18px!important; display:inline-block!important } .es-adaptive table, .es-left, .es-right { width:100%!important } .es-content table, .es-header table, .es-footer table, .es-content, .es-footer, .es-header { width:100%!important; max-width:600px!important } .es-adapt-td { display:block!important; width:100%!important } .adapt-img { width:100%!important; height:auto!important } .es-m-p0 { padding:0!important } .es-m-p0r { padding-right:0!important } .es-m-p0l { padding-left:0!important } .es-m-p0t { padding-top:0!important } .es-m-p0b { padding-bottom:0!important } .es-m-p20b { padding-bottom:20px!important } .es-mobile-hidden, .es-hidden { display:none!important } tr.es-desk-hidden, td.es-desk-hidden, table.es-desk-hidden { width:auto!important; overflow:visible!important; float:none!important; max-height:inherit!important; line-height:inherit!important } tr.es-desk-hidden { display:table-row!important } table.es-desk-hidden { display:table!important } td.es-desk-menu-hidden { display:table-cell!important } .es-menu td { width:1%!important } table.es-table-not-adapt, .esd-block-html table { width:auto!important } table.es-social { display:inline-block!important } table.es-social td { display:inline-block!important } .es-m-p5 { padding:5px!important } .es-m-p5t { padding-top:5px!important } .es-m-p5b { padding-bottom:5px!important } .es-m-p5r { padding-right:5px!important } .es-m-p5l { padding-left:5px!important } .es-m-p10 { padding:10px!important } .es-m-p10t { padding-top:10px!important } .es-m-p10b { padding-bottom:10px!important } .es-m-p10r { padding-right:10px!important } .es-m-p10l { padding-left:10px!important } .es-m-p15 { padding:15px!important } .es-m-p15t { padding-top:15px!important } .es-m-p15b { padding-bottom:15px!important } .es-m-p15r { padding-right:15px!important } .es-m-p15l { padding-left:15px!important } .es-m-p20 { padding:20px!important } .es-m-p20t { padding-top:20px!important } .es-m-p20r { padding-right:20px!important } .es-m-p20l { padding-left:20px!important } .es-m-p25 { padding:25px!important } .es-m-p25t { padding-top:25px!important } .es-m-p25b { padding-bottom:25px!important } .es-m-p25r { padding-right:25px!important } .es-m-p25l { padding-left:25px!important } .es-m-p30 { padding:30px!important } .es-m-p30t { padding-top:30px!important } .es-m-p30b { padding-bottom:30px!important } .es-m-p30r { padding-right:30px!important } .es-m-p30l { padding-left:30px!important } .es-m-p35 { padding:35px!important } .es-m-p35t { padding-top:35px!important } .es-m-p35b { padding-bottom:35px!important } .es-m-p35r { padding-right:35px!important } .es-m-p35l { padding-left:35px!important } .es-m-p40 { padding:40px!important } .es-m-p40t { padding-top:40px!important } .es-m-p40b { padding-bottom:40px!important } .es-m-p40r { padding-right:40px!important } .es-m-p40l { padding-left:40px!important } }\n"
                                                        + "                                </style>\n"
                                                        + "                                </head>\n"
                                                        + "                                <body data-new-gr-c-s-loaded=\"14.1055.0\" style=\"width:100%;font-family:arial, 'helvetica neue', helvetica, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0\">\n"
                                                        + "                                    <div class=\"es-wrapper-color\" style=\"background-color:#FAFBFB\"><!--[if gte mso 9]>\n"
                                                        + "                                    <v:background xmlns:v=\"urn:schemas-microsoft-com:vml\" fill=\"t\">\n"
                                                        + "                                    <v:fill type=\"tile\" color=\"#fafbfb\"></v:fill>\n"
                                                        + "                                    </v:background>\n"
                                                        + "                                    <![endif]-->\n"
                                                        + "                                        <table class=\"es-wrapper\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;background-color:#FAFBFB\">\n"
                                                        + "                                            <tr>\n"
                                                        + "                                                <td valign=\"top\" style=\"padding:0;Margin:0\">\n"
                                                        + "                                                    <table class=\"es-header\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top\">\n"
                                                        + "                                                        <tr>\n"
                                                        + "                                                            <td align=\"center\" style=\"padding:0;Margin:0\">\n"
                                                        + "                                                                <table class=\"es-header-body\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#ffffff\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px\">\n"
                                                        + "                                                                    <tr>\n"
                                                        + "                                                                        <td align=\"left\" bgcolor=\"#ecebeb\" style=\"Margin:0;padding-bottom:10px;padding-top:15px;padding-left:20px;padding-right:20px;background-color:#ecebeb\"><!--[if mso]><table style=\"width:560px\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"width:299px\" valign=\"top\"><![endif]-->\n"
                                                        + "                                                                            <table class=\"es-left\" cellspacing=\"0\" cellpadding=\"0\" align=\"left\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td class=\"es-m-p0r es-m-p20b\" align=\"center\" style=\"padding:0;Margin:0;width:299px\">\n"
                                                        + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td class=\"es-m-txt-c\" align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\">" + new Date() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Title&nbsp;</b>" + addNewTicket.getTicketName() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-top:10px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Ref:&nbsp;</b>" + addNewTicket.getTid() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Created by:&nbsp;</b>" + activeUser.getFirstName() + " " + activeUser.getLastName() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Ticket Created Date:&nbsp;</b>" + addNewTicket.getCreatedAt() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Location:&nbsp;</b>" + ticketLocation + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Queue Name:&nbsp;</b>" + addNewTicket.getQmQueue().getQueueName() + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Customer Name:&nbsp;</b>" + ticketCustomer + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Customer Email:&nbsp;</b>" + ticketCustomerEmail + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:11px\"><b>Customer Phone Number:&nbsp;</b>" + ticketCustomerPhoneNumber + "</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table><!--[if mso]></td><td style=\"width:20px\"></td><td style=\"width:241px\" valign=\"top\"><![endif]-->\n"
                                                        + "                                                                            <table class=\"es-right\" cellspacing=\"0\" cellpadding=\"0\" align=\"right\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td align=\"center\" style=\"padding:0;Margin:0;width:241px\">\n"
                                                        + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td class=\"es-m-p0l\" align=\"right\" style=\"padding:0;Margin:0;font-size:0px\"><a href=\"https://ring.visioncare.lk/\" target=\"_blank\" style=\"-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;text-decoration:underline;color:#2CB543;font-size:14px\"><img src=\"https://lkgca.stripocdn.email/content/guids/CABINET_6aa402089819e66ea9f9f022e51770cf/images/colouredlogo_aZE.png\" alt=\"ring ticket management system\" width=\"98\" style=\"display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic\" title=\"ring ticket management system\"></a></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"right\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:'open sans', 'helvetica neue', helvetica, arial, sans-serif;line-height:32px;color:#0099ff;font-size:21px\">&nbsp;Ticket Management</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"right\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:-apple-system, blinkmacsystemfont, 'segoe ui', roboto, helvetica, arial, sans-serif, 'apple color emoji', 'segoe ui emoji', 'segoe ui symbol';line-height:18px;color:#000000;font-size:12px\">Next Generation of Customer Service</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table><!--[if mso]></td></tr></table><![endif]--></td>\n"
                                                        + "                                                                    </tr>\n"
                                                        + "                                                                    <tr>\n"
                                                        + "                                                                        <td align=\"left\" style=\"padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px\"><!--[if mso]><table style=\"width:560px\" cellpadding=\"0\" cellspacing=\"0\"><tr><td style=\"width:249px\" valign=\"top\"><![endif]-->\n"
                                                        + "                                                                            <table cellpadding=\"0\" cellspacing=\"0\" class=\"es-left\" align=\"left\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:left\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td class=\"es-m-p20b\" align=\"left\" style=\"padding:0;Margin:0;width:249px\">\n"
                                                        + "                                                                                        <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-top:15px\"><h3 style=\"Margin:0;line-height:24px;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;font-size:20px;font-style:normal;font-weight:normal;color:#333333\">Assigned to Ticket | " + ticketStatus + "</h3></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table><!--[if mso]></td><td style=\"width:20px\"></td><td style=\"width:291px\" valign=\"top\"><![endif]-->\n"
                                                        + "                                                                            <table cellpadding=\"0\" cellspacing=\"0\" class=\"es-right\" align=\"right\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;float:right\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td align=\"left\" style=\"padding:0;Margin:0;width:291px\">\n"
                                                        + "                                                                                        <table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" autocomplete=\"off\" style=\"padding:0;Margin:0;padding-top:25px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:11px;color:#333333;font-size:11px\">Assigned by : " + activeUser.getFirstName() + "&nbsp;</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table><!--[if mso]></td></tr></table><![endif]--></td>\n"
                                                        + "                                                                    </tr>\n"
                                                        + "                                                                    <tr>\n"
                                                        + "                                                                        <td align=\"left\" style=\"padding:0;Margin:0;padding-left:20px;padding-right:20px\">\n"
                                                        + "                                                                            <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td valign=\"top\" align=\"center\" style=\"padding:0;Margin:0;width:560px\">\n"
                                                        + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"center\" style=\"padding:0;Margin:0;font-size:0\">\n"
                                                        + "                                                                                                    <table border=\"0\" width=\"100%\" height=\"100%\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                                        <tr>\n"
                                                        + "                                                                                                            <td style=\"padding:0;Margin:0;border-bottom:1px solid #cccccc;background:unset;height:1px;width:100%;margin:0px\"></td>\n"
                                                        + "                                                                                                        </tr>\n"
                                                        + "                                                                                                    </table></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-bottom:5px;padding-top:10px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">Dear <strong>" + queueHasUser.getUmUser().getFirstName() + "</strong>, You have been assigned to this ticket.</p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"left\" style=\"padding:0;Margin:0;padding-top:10px;padding-bottom:15px\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:21px;color:#333333;font-size:14px\">\n"
                                                        + "                                                                                                        <strong>Ticket Description:</strong><br>\n"
                                                        + "                                                                                                            " + addNewTicket.getTicketDescription() + "\n"
                                                        + "                                                                                                            </p></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td align=\"center\" style=\"padding:15px;Margin:0;font-size:0\">\n"
                                                        + "                                                                                                    <table border=\"0\" width=\"100%\" height=\"100%\" cellpadding=\"0\" cellspacing=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                                        <tr>\n"
                                                        + "                                                                                                            <td style=\"padding:0;Margin:0;border-bottom:0px solid #cccccc;background:unset;height:1px;width:100%;margin:0px\"></td>\n"
                                                        + "                                                                                                        </tr>\n"
                                                        + "                                                                                                    </table></td>\n"
                                                        + "                                                                                            </tr>\n"
                                                        + "                                                                                        </table></td>\n"
                                                        + "                                                                                </tr>\n"
                                                        + "                                                                            </table></td>\n"
                                                        + "                                                                    </tr>\n"
                                                        + "                                                                </table></td>\n"
                                                        + "                                                        </tr>\n"
                                                        + "                                                    </table>\n"
                                                        + "                                                    <table class=\"es-footer\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top\">\n"
                                                        + "                                                        <tr>\n"
                                                        + "                                                            <td align=\"center\" style=\"padding:0;Margin:0\">\n"
                                                        + "                                                                <table class=\"es-footer-body\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#ffffff\" align=\"center\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#FFFFFF;width:600px\">\n"
                                                        + "                                                                    <tr>\n"
                                                        + "                                                                        <td align=\"left\" bgcolor=\"#ecebeb\" style=\"padding:20px;Margin:0;background-color:#ecebeb\">\n"
                                                        + "                                                                            <table cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                <tr>\n"
                                                        + "                                                                                    <td align=\"left\" style=\"padding:0;Margin:0;width:560px\">\n"
                                                        + "                                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" role=\"presentation\" style=\"mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px\">\n"
                                                        + "                                                                                            <tr>\n"
                                                        + "                                                                                                <td esdev-links-color=\"#666666\" align=\"center\" style=\"padding:0;Margin:0\"><p style=\"Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:arial, 'helvetica neue', helvetica, sans-serif;line-height:17px;color:#333333;font-size:14px\"><span style=\"font-size:14px\">You're receiving this email because you are a user registered to<br><strong>Ring Ticket Management</strong>&nbsp;<br>This is a system generated message. Do not reply.<br>Technical Support on Ring Ticket Management | Call Isuru: 077 125 4919</span><br><br><span style=\"font-size:10px\">All copyrights reserved by Vision Care Optical Services | RING Ticket Management System &copy;2022 | Powered By <a href=\"https://nanobotz.lk/\">Nanobotz</a></span></p></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table></td>\n"
                                                        + "                                                                                                                                </tr>\n"
                                                        + "                                                                                                                                </table>\n"
                                                        + "                                                                                                                                </div>\n"
                                                        + "                                                                                                                                </body>\n"
                                                        + "                                                                                                                                </html>";
                                                if (addNewTicket.getLmLocations() != null) {
                                                    locationName = addNewTicket.getLmLocations().getLocationName();
                                                }
                                                String emailSubject3 = addNewTicket.getQmQueue().getQueueName() + " | " + addNewTicket.getTid() + " | " + locationName;
                                                EMAIL_MODEL.Sendmail(queueHasUser.getUmUser().getEmailAddress(), emailSubject3, emailContent3);
                                            }
                                        }
                                    }

                                    tr.commit();
                                    resultMap.put("result", "1");
                                    resultMap.put("displayMessage", "Saved Success...");

//                                    tr.commit();
//                                    resultMap.put("result", "1");
//                                    resultMap.put("displayMessage", "Saved Success|" + addNewTicket.getId() + "|");
                                } else {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Error...");
                                }
                            } else {
                                resultMap.put("result", "0");
                                resultMap.put("displayMessage", "Error ! Ticket Not Saved !");
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
