/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.configurationModel;

/**
 *
 * @author JOY
 */
public class USER_GETNICDETAILS {
       static String id;
    static int Frontid;
    int month[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    public int getYear() {
        return (Frontid + Integer.parseInt(id.substring(0, 2)));
    }

    public int getDays() {
        int d = Integer.parseInt(id.substring(2, 5));
        if (d > 500) {
            return (d - 500);
        } else {
            return d;
        }
    }

    public String getMonth() {
        int mo = 0, da = 0;
        int days = getDays();

        for (int i = 0; i < month.length; i++) {
            if (days < month[i]) {
                mo = i + 1;
                da = days;
                break;
            } else {
                days = days - month[i];
            }
        }
        return mo + "-" + da;

    }

    public String getSex() {
        String M = "1", F = "0";
        int d = Integer.parseInt(id.substring(2, 5));
        if (d > 500) {
            return F;
        } else {
            return M;
        }
    }

    public static String getDOBandGenderByNIC(String nic) {

        char[] cArray = nic.toCharArray();

        String string = "";

        if (cArray.length == 10) {
            USER_GETNICDETAILS N = new USER_GETNICDETAILS();

            id = nic;
            
            Frontid = Integer.parseInt("1900");

            string = N.getYear() + "-" + N.getMonth() + "#" + N.getSex();

        } else {

            String tempStr = "";
            String front = "";

            for (int i = 0; i < cArray.length; i++) {
                if (i < 2) {
                    front += cArray[i];
                } else {
                    tempStr += cArray[i];
                }
            }
            

            USER_GETNICDETAILS N = new USER_GETNICDETAILS();

            Frontid = Integer.parseInt(front+="00");
            id = tempStr;

            string = N.getYear() + "-" + N.getMonth() + "#" + N.getSex();
        }

        return string;
    }

//    public static void main(String[] args) {
//        //System.out.println(getDOBandGenderByNIC("940303532v"));
//        //System.out.println(getDOBandGenderByNIC("200125300159"));
//    }

}
