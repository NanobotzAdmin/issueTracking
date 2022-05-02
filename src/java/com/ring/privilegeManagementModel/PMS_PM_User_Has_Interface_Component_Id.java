/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.privilegeManagementModel;

import com.ring.db.UmUserHasInterfaceComponentId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class PMS_PM_User_Has_Interface_Component_Id {
    Logger logger = Logger.getLogger(this.getClass().getName());
//       method for add user has interface component to composide table
    public synchronized UmUserHasInterfaceComponentId addUserHasInterfaceComponentToComposite(Session ses, int userId, int component) {

        try {
            UmUserHasInterfaceComponentId saveUserHasInterfaceComponentToComposite = new UmUserHasInterfaceComponentId();
            saveUserHasInterfaceComponentToComposite.setPmInterfaceComponentId(component);
            saveUserHasInterfaceComponentToComposite.setUmUserId(userId);
            return saveUserHasInterfaceComponentToComposite;
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
            return null;
        }
    }
}
