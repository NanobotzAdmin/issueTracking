/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.configurationModel;

import java.text.DecimalFormat;

/**
 *
 * @author Chathuranga
 */
public class NumberFortmaing {

    public static String currencyFormat(double number) {

        DecimalFormat decimalFormat = new DecimalFormat("#.00");
        decimalFormat.setGroupingUsed(true);
        decimalFormat.setGroupingSize(3);

        return decimalFormat.format(number);
        
    }
    
//    public static void main(String[] args) {
//        
//        //ln(currencyFormat(-16844346576521.126));
//    }
}
