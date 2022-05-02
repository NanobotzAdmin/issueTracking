/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.privilegeManagementModel;

import com.ring.db.PmUserRole;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class PMS_PM_User_Role {
       Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active interfaces
    public  List<PmUserRole> getAllActiveUserRoles(Session ses,byte status) {
        try {
            Query query = ses.createQuery("FROM PmUserRole PMUR Where PMUR.status ='" + status + "'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
      //    method for get user role by Id
    public PmUserRole getUserRoleById(Session ses, int id) {
        try {
            Query query = ses.createQuery("FROM PmUserRole PMUR Where PMUR.id ='" + id + "'");
            return (PmUserRole) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }

}
