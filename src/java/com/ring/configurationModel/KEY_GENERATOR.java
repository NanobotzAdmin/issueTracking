/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.configurationModel;

import java.util.Random;

/**
 *
 * @author JOY
 */
public class KEY_GENERATOR {

    public static synchronized String generateKey(int length) {
        String alphabet = new String("0123456789abcdefghijklmnopqrstuvwxyz"); // 9
//        ABCDEFGHIJKLMNOPQRSTUVWXYZ
        int n = alphabet.length(); // 10
        String result = new String();
        Random r = new Random(); // 11
        for (int i = 0; i < length; i++) // 12
        {
            result = result + alphabet.charAt(r.nextInt(n)); //13
        }
        return result;
    }
    public static synchronized String generateImageName(int length) {
        String alphabet = new String("ABCDEFGHIJKLMNOPQRSTUVWXYZ"); // 9
//        ABCDEFGHIJKLMNOPQRSTUVWXYZ
        int n = alphabet.length(); // 10
        String result = new String();
        Random r = new Random(); // 11
        for (int i = 0; i < length; i++) // 12
        {
            result = result + alphabet.charAt(r.nextInt(n)); //13
        }
        return result;
    }
}
