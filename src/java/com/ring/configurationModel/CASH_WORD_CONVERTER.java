/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.configurationModel;

import java.util.StringTokenizer;

/**
 *
 * @author JOY
 */
public class CASH_WORD_CONVERTER {
    public static final String[] units = {
    "", " One", "Two", "Three", "Four", "Five", "Six", "Seven",
    "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen",
    "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"
};

public static final String[] tens = {
    "", // 0
    "", // 1
    "Twenty", // 2
    "Thirty", // 3
    "Forty", // 4
    "Fifty", // 5
    "Sixty", // 6
    "Seventy", // 7
    "Eighty", // 8
    "Ninety" // 9
};

public static String doubleConvert(final double n) {
    String pass = n + "";
    System.out.println("pas = " + pass);
    StringTokenizer token = new StringTokenizer(pass, ".");
    String first = token.nextToken();
    String last = token.nextToken();
    try {
        pass = convert(Integer.parseInt(first))+" ";
        pass=pass+"Rupees And";
        for (int i = 0; i < last.length(); i++) {
            String get=convert(Integer.parseInt(last.charAt(i)+""));
            if(get.isEmpty()){
            pass=pass+" "+"Zero";
            }else{
            pass=pass+" "+get;    
            }
            pass=pass+" Cents";
        }

    } catch (NumberFormatException nf) {
    }
    System.out.println(" final pass = " + pass);
    return pass;
}

public static String convert(final int n) {
    if (n < 0) {
        return "Minus " + convert(-n);
    }

    if (n < 20) {
        return units[n];
    }

    if (n < 100) {
        return tens[n / 10] + ((n % 10 != 0) ? " " : "") + units[n % 10];
    }

    if (n < 1000) {
        return units[n / 100] + " Hundred " + ((n % 100 != 0) ? " " : "") + convert(n % 100);
    }

    if (n < 1000000) {
        return convert(n / 1000) + " Thousand " + ((n % 1000 != 0) ? " " : "") + convert(n % 1000);
    }

    if (n < 1000000000) {
        return convert(n / 1000000) + " Million " + ((n % 1000000 != 0) ? " " : "") + convert(n % 1000000);
    }

    return convert(n / 1000000000) + " Billion " + ((n % 1000000000 != 0) ? " " : "") + convert(n % 1000000000);
  }

//    public static void main(String[] args) {
//        //ln(doubleConvert(151002.25));
//    }
}
