/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.queueManagement;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.QmQueue;
import com.ring.db.SmSession;
import com.ring.db.SmSessionActivity;
import com.ring.db.UmUser;
import com.ring.fileUploadManagementModel.fileUpload_Management;
import java.io.File;
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
@WebServlet(name = "queueManagement_addQueue", urlPatterns = {"/queueManagement_addQueue"})
public class queueManagement_addQueue extends HttpServlet {

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
                    String queueName = "";
                    String queueDescription = "";
                    String queueicon = "";
                    String queueFontColor = "";
                    FileItem queueBgImage = null;
                    boolean valied = false;
                    FileItemFactory factory = new DiskFileItemFactory();
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    List<FileItem> items = upload.parseRequest(request);
                    for (FileItem element : items) {
                        FileItem fileitem = (FileItem) element;
                        if (fileitem.isFormField()) {
                            if (fileitem.getFieldName().equals("queueName")) {
                                queueName = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("queueDescription")) {
                                queueDescription = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("queueicon")) {
                                queueicon = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("favcolor")) {
                                queueFontColor = fileitem.getString();
                            }
                        } else {
                            if (fileitem.getFieldName().equals("queueBGImg")) {
                                String extention = new File(element.getName()).getName();
                                if (!extention.equals("")) {
                                    queueBgImage = element;
                                }
                            }
                        }
                    }
                    if (queueName.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Queue Name.");
                    } else if (queueDescription.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Queue Description.");
                    } else {
                        if (queueBgImage != null) {
                            if (!queueBgImage.getContentType().equals("image/jpeg")) {
                                resultMap.put("result", "0");
                                resultMap.put("displayMessage", "Select JPG Image File");
                            } else {
                                valied = true;
                            }
                        } else {
                            valied = true;
                        }
                        if (valied) {
//                                check queue name exists
                            QmQueue checkName = new com.ring.queueManagementModel.QMS_QM_Queue().checkNameExists(ses, queueName);
                            if (checkName != null) {
                                resultMap.put("result", "0");
                                resultMap.put("displayMessage", "Queue Exists.");
                            } else {
//                           save queue details
                                QmQueue addNewQueue = new com.ring.queueManagementModel.QMS_QM_Queue().saveQueue(ses, queueName, queueDescription, null, queueicon, queueFontColor, STATIC_DATA_MODEL.PMACTIVE, addedDate, addedDate, activeUser.getId(), activeUser.getId());
                                if (addNewQueue != null) {
                                    //Get Active session object
                                    SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                    //Save session activity
                                    String saveQueueSessionActivityContent = addNewQueue.getQueueName() + " Queue has been Saved by " + activeUser.getFirstName() + " on " + addedDate;
                                    SmSessionActivity sessionActivityToAddQueue = new com.ring.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, saveQueueSessionActivityContent, new Date(), STATIC_DATA_MODEL.INSERT, STATIC_DATA_MODEL.QUEUESAVE, activeSession, activeUser);
                                    if (sessionActivityToAddQueue != null) {
                                        if (queueBgImage != null) {
//                                    System.out.println("type + =" + queueBgImage.getContentType());
                                            String QueueBackGroundEmage = "Queue Back Ground Images/" + addNewQueue.getQueueName() + " - " + addNewQueue.getId();
                                            new fileUpload_Management().createFolder(fileUpload_Management.fileUploadingPath, QueueBackGroundEmage);
                                            String saveQueueBgImage = new com.ring.fileUploadManagementModel.fileUpload_Management().fileItem(queueBgImage, QueueBackGroundEmage);
                                            addNewQueue.setBackgroundImage(saveQueueBgImage);
                                            ses.update(addNewQueue);
                                        }
                                        tr.commit();
                                        resultMap.put("result", "1");
                                        resultMap.put("displayMessage", "Saved Success|" + addNewQueue.getId() + "|");
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
