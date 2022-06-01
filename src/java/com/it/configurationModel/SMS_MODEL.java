/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.configurationModel;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.IDN;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.net.ssl.HttpsURLConnection;

/**
 *
 * @author JOY
 */
public class SMS_MODEL {

//    public static void main(String[] args) throws URISyntaxException, IOException {
////        Send_SMS("0777822509", "Hi");
////        Send("AAAAA", "94713700471"); 
//        PostSend("Hi", "0713700471");
//    }
    public static synchronized String Send_SMS(String mobileNumber, String message) throws URISyntaxException {
//      String msg = "Your OTP Is "+message;
//      System.out.println("message = " + message);
//      System.out.println("Number - "+mobileNumber);
        String https_url = "https://bulksms.hutch.lk/sendsmsmultimask.php?USER=Sofmcs&PWD=SofM@123&MASK=NANOBOTZ&NUM=" + mobileNumber.trim() + "&MSG=" + message + "";
        URL url1 = null;
        try {
            url1 = new URL(https_url);
        } catch (MalformedURLException ex) {
            Logger.getLogger(SMS_MODEL.class.getName()).log(Level.SEVERE, null, ex);
        }
        URI uri = new URI(url1.getProtocol(), url1.getUserInfo(), IDN.toASCII(url1.getHost()), url1.getPort(), url1.getPath(), url1.getQuery(), url1.getRef());
        String correctEncodedURL = uri.toASCIIString();
//        System.out.println(correctEncodedURL);
//        System.out.println("url sms = " + https_url);
        URL url;
        String retNote = "";
//        "https://bulksms.hutch.lk/sendsmsmultimask.php?USER=Sofmcs&PWD=SofM@123&MASK=NANOBOTZ&NUM=0713700471&MSG="+message
//System.out.println("url = " + https_url);
        try {
            url = new URL(correctEncodedURL);
            HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
            //dumpl all cert info
//         print_https_cert(con);
            //dump all the content
//         print_content(con);
            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            retNote = br.readLine();

        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return retNote;
    }

//    public static synchronized String Send_SMS(String mobileNumber, String message) throws URISyntaxException {
//
////           String msg = "Your OTP Is "+message;
////        System.out.println("message = " + message);
////        System.out.println("Number - "+mobileNumber);
//
//        String https_url = "https://bulksms.hutch.lk/sendsmsmultimask.php?USER=Sofmcs&PWD=SofM@123&MASK=NANOBOTZ&NUM=" + mobileNumber.trim() + "&MSG=" + message + "";
////        String https_url = "http://smsm.lankabell.com:4090/Sms.svc/SendSms?phoneNumber="+mobileNumber.trim()+"&smsMessage="+message+"&companyId=VISIONADMINN403&pword=PD68gw3LK1";
//        
////        http://smsm.lankabell.com:40X0/Sms.svc/SendSms?phoneNumber=07XXXXXXXX&smsMessage=MESSAGE&companyId=APINAME&pword=PASSWORD;
//        
//        URL url1 = null;
//        try {
//            url1 = new URL(https_url);
//        } catch (MalformedURLException ex) {
//            Logger.getLogger(SMS_MODEL.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        
//        
//        URI uri = new URI(url1.getProtocol(), url1.getUserInfo(), IDN.toASCII(url1.getHost()), url1.getPort(), url1.getPath(), url1.getQuery(), url1.getRef());
//        String correctEncodedURL = uri.toASCIIString();
//        
////        System.out.println(correctEncodedURL);
////
////        System.out.println("url sms = " + https_url);
//        URL url;
//        String retNote = "";
////        "https://bulksms.hutch.lk/sendsmsmultimask.php?USER=Sofmcs&PWD=SofM@123&MASK=NANOBOTZ&NUM=0713700471&MSG="+message
////System.out.println("url = " + https_url);
//        try {
//
//            url = new URL(correctEncodedURL);
//            HttpURLConnection con = (HttpURLConnection) url.openConnection();
////            con.setRequestProperty("User-Agent", "Mozilla/5.0");
////            con.setRequestProperty("LB_Key750", "VklTSU9OQURNSU5ONDAzIF9CMFM6UEQ2OGd3M0xLMV9COVM=");
//            //dumpl all cert info
////         print_https_cert(con);
//            //dump all the content
////         print_content(con);
//            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
//            retNote = br.readLine();
//
//        } catch (MalformedURLException e) {
//            e.printStackTrace();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        return retNote;
//    }
//    public static synchronized String Send(String msg, String no) throws MalformedURLException, IOException {
////JSONArray mjr=new JSONArray();
////        String mask = "DIYON";
////        if (no.length() > 9) {
////            no = no.substring(no.length() - 9);
////        }
////        no = "94" + no;
//
////        msg = URLEncoder.encode(msg, "UTF-8");
//
//String url = "http://smsm.lankabell.com:4090/Sms.svc/SendSms?phoneNumber="+no+"&smsMessage="+msg+"&companyId=VISIONADMINN403&pword=PD68gw3LK1";
////        String url = "https://bulksms.hutch.lk/sendsmsmultimask.php?USER=Sofmcs&PWD=SofM@123&MASK=" + mask + "&NUM=" + no + "&MSG=" + msg;
//        URL obj = new URL(url);
//        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
//        con.setRequestMethod("GET");
//        con.setRequestProperty("User-Agent", "Mozilla/5.0");
//        con.setRequestProperty("LB_Key750", "VklTSU9OQURNSU5ONDAzIF9CMFM6UEQ2OGd3M0xLMV9COVM=");
//        int responseCode = con.getResponseCode();
//        try {
//
//            System.out.println("GET Response Code :: " + responseCode);
//            if (responseCode == HttpURLConnection.HTTP_OK) { // success
//                BufferedReader in = new BufferedReader(new InputStreamReader(
//                        con.getInputStream()));
//                String inputLine;
//                StringBuffer response = new StringBuffer();
//
//                while ((inputLine = in.readLine()) != null) {
//                    response.append(inputLine);
//                }
//                in.close();
//
//                // print result
////                System.out.println(response.toString());
//                return response.toString();
//            } else {
//                // System.out.println("GET request not worked");
//                return "GET request not worked";
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            return "400";
//        }
//    }
//    public static String PostSend(final String msg, String no) throws MalformedURLException, IOException {
//        final JSONArray mjr = new JSONArray();
//        System.setProperty("jsse.enableSNIExtension", "false");
//        System.setProperty("https.protocols", "TLSv1,TLSv1.1,TLSv1.2");
//
////        if (no.length() > 9) {
////            no = no.substring(no.length() - 9);
////        }
////        no = "94" + no;
//        try {
//            JSONArray jr = new JSONArray();
//            JSONObject messages = new JSONObject();
//            JSONObject job = new JSONObject();
//            job.put("CompanyId", "VISIONADMINN403");
//            job.put("Pword", "PD68gw3LK1");
//            job.put("SmsMessage", msg);
//            job.put("PhoneNumber", no);
//            jr.add(job);
//            messages.put("method body", jr);
//            String jsonInputString = job.toJSONString();
////            final Calendar cal = Calendar.getInstance();
////            cal.setTime(new Date());
////            final SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
//            URL url = new URL("http://smsm.lankabell.com:4040/Sms.svc/PostSendSms");
//            HttpURLConnection con = (HttpURLConnection) url.openConnection();
//            con.setRequestMethod("POST");
//            con.setRequestProperty("Content-Type", "application/json");
//            con.setRequestProperty("LB_Key750", "VklTSU9OQURNSU5ONDAzIF9CMFM6UEQ2OGd3M0xLMV9COVM=");
////            System.out.println(""+jsonInputString);
//            con.setDoOutput(true);
//            try (OutputStream os = con.getOutputStream()) {
//                byte[] input = jsonInputString.getBytes("utf-8");
//                os.write(input, 0, input.length);
//            }
//            int responseCode = con.getResponseCode();
//            BufferedReader in = new BufferedReader(new InputStreamReader(
//                    con.getInputStream()));
//            String inputLine;
//            StringBuffer response = new StringBuffer();
//
//            while ((inputLine = in.readLine()) != null) {
//                response.append(inputLine);
//            }
//            in.close();
////            System.out.println(responseCode);
//            return responseCode + "";
//        } catch (Exception e) {
//            e.printStackTrace();
//            return "400";
//        }
//    }
}
