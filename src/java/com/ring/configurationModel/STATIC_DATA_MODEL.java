/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.configurationModel;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 *
 * @author JOY
 */
public class STATIC_DATA_MODEL {

//1  use for session activity
//    (activity types)
    public static String INSERT = "Insert";
    public static String UPDATE = "Update";
    public static String DELETE = "Delete";
    public static String SEARCH = "Search";
    public static String CLICK = "Click";
    public static String LOGIN = "Login";
    public static String LOGOUT = "Logout";

//    (activity topics)
    public static String USERLOGIN = "User Login";
    public static String USERLOGOUT = "User Logout";
    public static String USERLOGINATTEMP = "User Login Attemp";
    public static String USERHASITOPICSAVE = "User Has Interface Topic Save";
    public static String USERHASICOMPONENTSAVE = "User Has Interface Component Save";
    public static String USERROLEHASICOMPONENTSAVE = "User Role Has Interface Component Save";
    public static String USERROLEHASICOMPONENTREMOVE = "User Role Has Interface Component Remove";
    public static String USERHASICOMPONENTREMOVE = "User Has Interface Component Remove";
    public static String USERHASITOPICREMOVE = "User Has Interface Topic Remove";
    public static String INTERFACETOPICSAVE = "Interface Topic Save";
    public static String INTERFACESAVE = "Interface Save";
    public static String INTERFACECOMPONENTSAVE = "Interface Component Save";
    public static String INTERFACETOPICUPDATE = "Interface Topic Update";
    public static String INTERFACEUPDATE = "Interface Update";
    public static String INTERFACECOMPONENTUPDATE = "Interface Component Update";
    public static String DESIGNATIONSAVE = "Designation Save";
    public static String DESIGNATIONSUPDATE = "Designation Update";
     public static String LOCATIONSAVE = "Location Save";
     public static String LOCATIONUPDATE = "Location Update";
     public static String QUEUESAVE = "Queue Save";
     public static String QUEUEUPDATE = "Queue Update";
     public static String QUEUEMANAGEMENT = "Queue Management";
     public static String CATEGORYSAVE = "Category Save";
     public static String CATEGORYUPDATE = "Category Update";
     public static String SUBCATEGORYSAVE = "Sub Category Save";
     public static String SUBCATEGORYUPDATE = "Sub Category Update";
     public static String ROOTCAUSEQUESTION = "Root Cause Question";
     public static String ROOTCAUSEANSWER= "Root Cause Answer";
     public static String USERMANAGEMENT= "User Management";
     public static String CUSTOMERMANAGEMENT= "Customer Management";
     public static String TICKETMANAGEMENT= "Ticket Management";
     public static String TICKETREPLYMANAGEMENT= "Ticket Reply Management";

//    add to map
    public static Map<String, Integer> getTopics() {
        Map<String, Integer> dataMap = new HashMap<String, Integer>();

        dataMap.put(USERLOGIN, 1);
        dataMap.put(USERLOGOUT, 2);
        dataMap.put(USERLOGINATTEMP, 3);
        dataMap.put(USERHASITOPICSAVE, 4);
        dataMap.put(USERHASICOMPONENTSAVE, 5);
        dataMap.put(USERROLEHASICOMPONENTSAVE, 6);
        dataMap.put(USERROLEHASICOMPONENTREMOVE, 7);
        dataMap.put(USERHASICOMPONENTREMOVE, 8);
        dataMap.put(USERHASITOPICREMOVE, 9);
        dataMap.put(INTERFACETOPICSAVE, 10);
        dataMap.put(INTERFACESAVE, 11);
        dataMap.put(INTERFACECOMPONENTSAVE, 12);
        dataMap.put(INTERFACETOPICUPDATE, 13);
        dataMap.put(INTERFACEUPDATE, 14);

        return dataMap;
    }

//2  use for user status
    public static Byte PENDING = 1;
    public static Byte ACTIVE = 2;
    public static Byte DEACTIVE = 3;
    public static Byte BLOCK = 4;
    
    public static boolean ISACTIVE = true;
    public static boolean ISDEACTIVE = false;
    

//3 use for login attemps
    public static Byte ISSUCCESSTRUE = 1;
    public static Byte ISSUCCESSFALSE = 0;
    public static Byte ISCLEAREDTRUE = 1;
    public static Byte ISCLEAREDFALSE = 0;

//4 user for privillege management 
//        (status for interface topics,interfaces,interface component,user role)
    public static Byte PMALL = 0;
    public static Byte PMACTIVE = 2;
    public static Byte PMDEACTIVE = 1;

//5 encryption keys
    public static final String EKEY = "E27776246F9487B1";
    public static final String KEYVECTOR = "401c482200651600";

    //6 Finget Print status for user
    public static Byte NOTASSIGNED = 0;
    public static Byte ADDID = 1;
    public static Byte CONFIRMADDEDID = 2;
    public static Byte REMOVEID = 3;

//7  user for device modes
    public static boolean ENROLMENT = false;
    public static boolean ATTENDANCE = true;

//8    user salutation
    public static String MR = "Mr";
    public static String MRS = "Mrs";
    public static String MS = "Ms";

//9      leave settings
//      leave calculation method
    public static Byte NA = 1;
    public static Byte PERMONTH = 2;
    public static Byte PERYEAR = 3;

//      leave payment type
    public static Byte FULLPAY = 1;
    public static Byte HALFPAY = 2;
    public static Byte NOPAY = 3;
    public static Byte HOLD = 4;

//    leave request status
    public static Byte LEAVEREQUESTED = 1;
    public static Byte LEAVERECOMMENDED = 2;
    public static Byte LEAVEAPPROVED= 3;
    public static Byte LEAVEDECLINED= 4;
    
//    Ticket  Status 
    public static Byte TICKETPENDING = 1;
    public static Byte TICKETACTIVE = 2;
    public static Byte TICKETCOMPLETED= 3;
    public static Byte TICKETCONFIRMED= 4;
    public static Byte TICKETARCHIVE= 5;
    
    
    
    
    
   public static synchronized char[] OTP(int len)
    {
        System.out.println("Generating OTP using random() : ");
        System.out.print("You OTP is : ");
  
        // Using numeric values
        String numbers = "0123456789";
  
        // Using random method
        Random rndm_method = new Random();
  
        char[] otp = new char[len];
  
        for (int i = 0; i < len; i++)
        {
            // Use of charAt() method : to get character value
            // Use of nextInt() as it is scanning the value as int
            otp[i] =
             numbers.charAt(rndm_method.nextInt(numbers.length()));
        }
        return otp;
    }
    
    
}
