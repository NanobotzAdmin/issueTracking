/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.queueManagement;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.QmQueue;
import com.it.db.QmQueueHasUser;
import com.it.db.SmSession;
import com.it.db.SmSessionActivity;
import com.it.db.UmUser;
import com.it.fileUploadManagementModel.fileUpload_Management;
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
@WebServlet(name = "queueManagement_updateQueue", urlPatterns = {"/queueManagement_updateQueue"})
public class queueManagement_updateQueue extends HttpServlet {

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
                    boolean valied1 = false;
                    boolean valied2 = false;
                    Date addedDate = new Date();
                    String queueNameU = "";
                    String queueIdU = "";
                    String queueDescriptionU = "";
                    String queueiconU = "";
                    String queueFontColorU = "";
                    FileItem queueBgImage = null;
                    FileItemFactory factory = new DiskFileItemFactory();
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    List<FileItem> items = upload.parseRequest(request);
                    for (FileItem element : items) {
                        FileItem fileitem = (FileItem) element;
                        if (fileitem.isFormField()) {
                            if (fileitem.getFieldName().equals("queueNameU")) {
                                queueNameU = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("queueIdU")) {
                                queueIdU = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("queueDescriptionU")) {
                                queueDescriptionU = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("queueiconU")) {
                                queueiconU = fileitem.getString();
                            }
                            if (fileitem.getFieldName().equals("favcolor")) {
                                queueFontColorU = fileitem.getString();
                            }
                        } else {
                            if (fileitem.getFieldName().equals("queueImageUpdate")) {
                                String extention = new File(element.getName()).getName();
                                if (!extention.equals("")) {
                                    queueBgImage = element;
                                }
                            }
                        }
                    }
                    int queueId = Integer.parseInt(queueIdU);
                    if (queueId <= 0) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Queue Not Found");
                    } else if (queueNameU.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Queue Name.");
                    } else if (queueDescriptionU.isEmpty()) {
                        resultMap.put("result", "0");
                        resultMap.put("displayMessage", "Enter Queue Description.");
                    } else {
//                        selected queue
                        QmQueue selectedQueue = (QmQueue) ses.load(QmQueue.class, queueId);
                        if (selectedQueue == null) {
                            resultMap.put("result", "0");
                            resultMap.put("displayMessage", "Queue Not Found");
                        } else {
                            if (!selectedQueue.getQueueName().equals(queueNameU)) {
//                                check updated queue name exists
                                QmQueue checkNameExists = new com.it.queueManagementModel.QMS_QM_Queue().checkNameExists(ses, queueNameU);
                                if (checkNameExists != null) {
                                    resultMap.put("result", "0");
                                    resultMap.put("displayMessage", "Queue Name Exists.");
                                } else {
                                    valied1 = true;
                                }
                            } else {
                                valied1 = true;
                            }
                            if (valied1) {
                                if (queueBgImage != null) {
                                    if (!queueBgImage.getContentType().equals("image/jpeg")) {
                                        resultMap.put("result", "0");
                                        resultMap.put("displayMessage", "Select JPG Image File");
                                    } else {
                                        valied2 = true;
                                    }
                                } else {
                                    valied2 = true;
                                }
                                if (valied2) {
//                            update Queue details
                                    QmQueue updateQueue = new com.it.queueManagementModel.QMS_QM_Queue().updateQueue(ses, queueNameU, queueDescriptionU,STATIC_DATA_MODEL.PMACTIVE, addedDate, selectedQueue, activeUser.getId());
                                    if (updateQueue != null) {
                                        //Get Active session object
                                        SmSession activeSession = (SmSession) request.getSession().getAttribute("logUserHttpSession");
                                        //Save session activity
                                        String saveQueueSessionActivityContent = updateQueue.getQueueName() + " Queue has been Updated by " + activeUser.getFirstName() + " on " + addedDate;
                                        SmSessionActivity sessionActivityToUpdateQueue = new com.it.userManagementModel.UMS_UM_Session_Activity().saveSessionActivity(ses, saveQueueSessionActivityContent, new Date(), STATIC_DATA_MODEL.UPDATE, STATIC_DATA_MODEL.QUEUEUPDATE, activeSession, activeUser);
                                        if (sessionActivityToUpdateQueue != null) {
                                            if (queueBgImage != null) {
                                                String QueueBackGroundEmage = "Queue Back Ground Images/" + updateQueue.getQueueName() + " - " + updateQueue.getId();
                                                new fileUpload_Management().createFolder(fileUpload_Management.fileUploadingPath, QueueBackGroundEmage);
                                                String saveQueueBgImage = new com.it.fileUploadManagementModel.fileUpload_Management().fileItem(queueBgImage, QueueBackGroundEmage);
                                                updateQueue.setBackgroundImage(saveQueueBgImage);
                                            }
                                            updateQueue.setQueueColor(queueFontColorU);
                                            updateQueue.setQueueIcon(queueiconU);
                                            ses.update(updateQueue);
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
