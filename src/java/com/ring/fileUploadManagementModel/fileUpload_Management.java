/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.fileUploadManagementModel;

import com.ring.configurationModel.KEY_GENERATOR;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 *
 * @author JOY
 */
public class fileUpload_Management {
    
//    public static String fileUploadingPath = "/Users/JOY/Documents/RING/";//for Windows
//    public static String fileUploadingPath = "/Users/dinuka/Documents/RING/";//for Mac
    public static String fileUploadingPath = "/opt/RING_FILES";//for Server

    public void createFolder(String Location, String folderName) {
        try {
//            Path path = Paths.get(Location + "\\" + folderName);//For windows
            Path path = Paths.get(Location + "/" + folderName);//for mac
            Files.createDirectories(path);
        } catch (IOException ex) {
            Logger.getLogger(fileUpload_Management.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public ArrayList<Map<String, String>> uploadFiles(HttpServletRequest request, String folderName, String specialValue, String action) {

        ArrayList<Map<String, String>> arrayList = new ArrayList<Map<String, String>>();

        Map<String, String> resaltMap2 = new HashMap<String, String>();

        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        ////System.out.println("000000000000000000000");
        if (isMultipart) {
            ////System.out.println("1111111111111111111");
            FileItemFactory ft = new DiskFileItemFactory();

            ServletFileUpload upload = new ServletFileUpload(ft);

            try {
                List<FileItem> fit = upload.parseRequest(request);

                ////System.out.println("2222222222222222222222222");
                for (FileItem f : fit) {
                    if (!f.isFormField()) {
                        ////System.out.println("333333333333333333333");
                        String extention = new File(f.getName()).getName();
                        String savePath = fileUploadingPath + "/" + folderName + "/" + System.currentTimeMillis() + "_" + specialValue + "_" + action + "_" + extention;

                        ////System.out.println("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD =" + savePath);
                        ////System.out.println("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM =" + request.getServletContext().getRealPath("/"));

                        f.write(new File(savePath));
//                        f.write(new File(request.getServletContext().getRealPath("/") + savePath));

                        Map<String, String> resaltMap = new HashMap<String, String>();

                        resaltMap.put("result", "1");
                        resaltMap.put("displayMessage", "File uploading Success.");
                        resaltMap.put("fileLocation", savePath);

                        arrayList.add(resaltMap);
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
                resaltMap2.put("result", "0");
                resaltMap2.put("displayMessage", "File upload is failed!!!");
                arrayList.add(resaltMap2);
            }
        }
        ////System.out.println("***************************************");
        return arrayList;
    }

    public ArrayList<Map<String, String>> uploadFilesWithFileItemList(List<FileItem> fileItem, String folderName, String specialValue, String action, HttpServletRequest request) {

        ArrayList<Map<String, String>> arrayList = new ArrayList<Map<String, String>>();

        Map<String, String> resaltMap2 = new HashMap<String, String>();

        FileItemFactory ft = new DiskFileItemFactory();

        ServletFileUpload upload = new ServletFileUpload(ft);
        //  // //////////System.out.println("");
        try {
            List<FileItem> fit = fileItem;
            for (FileItem f : fit) {
                if (!f.isFormField()) {
                    String extention = new File(f.getName()).getName();
                    String savePath = fileUploadingPath + folderName + "/" + System.currentTimeMillis() + "_" + specialValue + "_" + action + "_" + extention;

//                    // //////////System.out.println("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD =" + savePath);
//                    // //////////System.out.println("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM =" + request.getServletContext().getRealPath("/"));
                    f.write(new File(savePath));
//                    f.write(new File(request.getServletContext().getRealPath("/") + savePath));

                    Map<String, String> resaltMap = new HashMap<String, String>();

                    Long fileSize = f.getSize();

                    resaltMap.put("result", "1");
                    resaltMap.put("displayMessage", "File uploading Success.");
                    resaltMap.put("fileLocation", savePath);
                    resaltMap.put("size", fileSize.doubleValue() + "");

                    arrayList.add(resaltMap);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resaltMap2.put("result", "0");
            resaltMap2.put("displayMessage", e.getMessage());
            arrayList.add(resaltMap2);
        }
        return arrayList;
    }

    public ArrayList<Map<String, String>> uploadFilesWithFileItemListURLAlreadyHave(List<FileItem> fileItem, String folderName, String specialValue, String docName, HttpServletRequest request) {

        ArrayList<Map<String, String>> arrayList = new ArrayList<Map<String, String>>();

        Map<String, String> resaltMap2 = new HashMap<String, String>();

        FileItemFactory ft = new DiskFileItemFactory();

        ServletFileUpload upload = new ServletFileUpload(ft);
        //  // //////////System.out.println("");
        try {
            List<FileItem> fit = fileItem;
            for (FileItem f : fit) {
                if (!f.isFormField()) {
                    // //////////System.out.println(folderName);
                    String extention = new File(f.getName()).getName();
                    String savePath = folderName + "/" + System.currentTimeMillis() + "_" + specialValue + "_" + docName + "_" + extention;

                    //////////System.out.println("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD =" + savePath);
                    //////////System.out.println("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM =" + request.getServletContext().getRealPath("/"));
                    f.write(new File(savePath));
//                    f.write(new File(request.getServletContext().getRealPath("/") + savePath));

                    Map<String, String> resaltMap = new HashMap<String, String>();

                    Long fileSize = f.getSize();

                    resaltMap.put("result", "1");
                    resaltMap.put("displayMessage", "File uploading Success.");
                    resaltMap.put("fileLocation", savePath);
                    resaltMap.put("size", fileSize.doubleValue() + "");

                    arrayList.add(resaltMap);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resaltMap2.put("result", "0");
            resaltMap2.put("displayMessage", e.getMessage());
            arrayList.add(resaltMap2);
        }
        return arrayList;
    }

    public synchronized String fileItem(FileItem element, String folder) {
        try {
            FileItem fileitem = (FileItem) element;
            String extention = fileitem.getName();     
            String generateImageName = KEY_GENERATOR.generateImageName(10);      
            String getCurrentname[] = extention.split("[.]");
            String jj = getCurrentname[getCurrentname.length-1];
//            System.out.println("jj = " + jj);
            String savePath = fileUploadingPath + "/" + folder + "/" + System.currentTimeMillis() + "_" + generateImageName+"."+jj;
            element.write(new File(savePath));
            return savePath;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
