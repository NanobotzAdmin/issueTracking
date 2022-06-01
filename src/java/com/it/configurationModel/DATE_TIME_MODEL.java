/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.configurationModel;

/**
 *
 * @author JOY
 */
public class DATE_TIME_MODEL {

    public static synchronized String getTimeDiff(long timeDiff) {
        try {
//            long difference_In_Seconds = (timeDiff / 1000) % 60;
            long difference_In_Minutes = (timeDiff / (1000 * 60)) % 60;
            long difference_In_Hours = (timeDiff / (1000 * 60 * 60)) % 24;
//            long difference_In_Years = (timeDiff / (1000l * 60 * 60 * 24 * 365));
            long difference_In_Days = (timeDiff / (1000 * 60 * 60 * 24)) % 365;
//            String finalUotput = difference_In_Years+" years, "+ difference_In_Days+ " days, "+ difference_In_Hours+ " hours, "+ difference_In_Minutes+ " minutes, "+ difference_In_Seconds+ " seconds";
            String finalUotput = difference_In_Days+ " days, "+ difference_In_Hours+ " hours, "+ difference_In_Minutes+ " minutes";
//             System.out.print("Difference "+ "between two dates is: ");
//            System.out.println(difference_In_Years+ " years, "+ difference_In_Days+ " days, "+ difference_In_Hours+ " hours, "+ difference_In_Minutes+ " minutes, "+ difference_In_Seconds+ " seconds");
            return finalUotput;
        } catch (Exception e) {
            return null;
        }
    }
}
