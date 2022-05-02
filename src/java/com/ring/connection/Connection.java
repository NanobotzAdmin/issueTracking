/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.connection;

import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.SessionFactory;

/**
 * Hibernate Utility class with a convenient method to get Session Factory
 * object.
 *
 * @author JOY
 */
public class Connection {

    private static final SessionFactory sessionFactory;
    
    static {
        try {
            // Create the SessionFactory from standard (hibernate.cfg.xml) 
            // config file.
            AnnotationConfiguration annotationConfiguration = new AnnotationConfiguration().configure("hibernate.cfg.xml");
//            annotationConfiguration.setProperty("hibernate.connection.password", "N@nob99311");
//            annotationConfiguration.setProperty("hibernate.connection.password", "1234");
//            annotationConfiguration.setProperty("hibernate.connection.password", "3OBsq4!kZC");
            annotationConfiguration.setProperty("hibernate.connection.CharSet", "utf8");
            annotationConfiguration.setProperty("hibernate.connection.characterEncoding", "utf8");
            annotationConfiguration.setProperty("hibernate.connection.useUnicode", "true");
            sessionFactory = annotationConfiguration.buildSessionFactory();
        } catch (Throwable ex) {
            // Log the exception. 
            System.err.println("Initial SessionFactory creation failed." + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }
    
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}
