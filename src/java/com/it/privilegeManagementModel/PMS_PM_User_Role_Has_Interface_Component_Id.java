/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.privilegeManagementModel;

import com.it.db.PmUserRoleHasInterfaceComponentId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class PMS_PM_User_Role_Has_Interface_Component_Id {
       Logger logger = Logger.getLogger(this.getClass().getName());
//       method for add user role has interface component to composide table
    public synchronized PmUserRoleHasInterfaceComponentId addUserRoleHasInterfaceComponentToComposite(Session ses, int userRole, int component) {

        try {
            PmUserRoleHasInterfaceComponentId saveUserRoleHasInterfaceComponentToComposite = new PmUserRoleHasInterfaceComponentId();
            saveUserRoleHasInterfaceComponentToComposite.setPmInterfaceComponentId(component);
            saveUserRoleHasInterfaceComponentToComposite.setPmUserRoleId(userRole);
            return saveUserRoleHasInterfaceComponentToComposite;
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
            return null;
        }
    }
}
