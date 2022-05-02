/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.privilegeManagementModel;

import com.ring.db.UmUserHasInterfaceTopicId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class PMS_PM_User_Has_Interface_Topic_Id {
    Logger logger = Logger.getLogger(this.getClass().getName());

    public synchronized UmUserHasInterfaceTopicId addUserHasInterfaceComponentToComposite(Session ses, int userId, int topic) {

        try {
            UmUserHasInterfaceTopicId saveUserHasInterfaceComponentToComposite = new UmUserHasInterfaceTopicId();
            saveUserHasInterfaceComponentToComposite.setPmInterfaceTopicId(topic);
            saveUserHasInterfaceComponentToComposite.setUmUserId(userId);
            return saveUserHasInterfaceComponentToComposite;
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
            return null;
        }
    }
}
