/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.userManagementModel;

import com.it.db.SmSession;
import com.it.db.UmUser;
import java.util.Date;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class UMS_UM_Session {

    Logger logger = Logger.getLogger(this.getClass().getName());

//     method for save session
    public SmSession saveHttpSession(Session ses, Date timeIn, Date timeOut, Date addedDate, String ipAddress, UmUser addedBy) {
        try {
            SmSession sessionSave = new SmSession();
            sessionSave.setCreatedAt(addedDate);
            sessionSave.setIpAddress(ipAddress);
            sessionSave.setTimeIn(timeIn);
            sessionSave.setUmUser(addedBy);
            ses.save(sessionSave);
            return sessionSave;
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;

        }

    }

}
