/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.configurationModel;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 *
 * @author Chathuranga
 */
public class Decemal_Format {

    public synchronized static double RoundTo2Decimals(double val) {
        Double value = BigDecimal.valueOf(val).setScale(2, RoundingMode.HALF_UP).doubleValue();
        return value;
    }

    public synchronized static double RoundTo1Decimals(double val) {
        Double value = BigDecimal.valueOf(val).setScale(1, RoundingMode.HALF_UP).doubleValue();
        return value;
    }

    public synchronized static double RoundTo0Decimals(double val) {
        Double value = BigDecimal.valueOf(val).setScale(0, RoundingMode.HALF_UP).doubleValue();
        return value;
    }

    public static double RoundToNearestX(double x, int roundTo) {
        double val = 0.0;
        val = (Math.rint((double) x / roundTo) * roundTo);
        return val;
    }

    
//    public static void main(String[] args) {
//        System.out.println(RoundToNearestX(31007.97, 100));
//    }
}
