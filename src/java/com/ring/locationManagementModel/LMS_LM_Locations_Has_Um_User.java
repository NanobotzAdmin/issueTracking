/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.locationManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.LmLocations;
import com.ring.db.LmLocationsHasUmUser;
import com.ring.db.LmLocationsHasUmUserId;
import com.ring.db.UmUser;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class LMS_LM_Locations_Has_Um_User {
    Logger logger = Logger.getLogger(this.getClass().getName());
    //method for get location has users by location id
    public synchronized List<LmLocationsHasUmUser> getAllUsersByLocationId(Session ses, int locationId) {
        try {
            Query query = ses.createQuery("FROM LmLocationsHasUmUser WHERE lmLocations ='"+locationId+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //method for get location has user by location id and user id
    public synchronized LmLocationsHasUmUser getUsersByLocationId(Session ses, int locationId,int userId) {
        try {
            Query query = ses.createQuery("FROM LmLocationsHasUmUser WHERE lmLocations='"+locationId+"' AND umUser='"+userId+"'");
            return (LmLocationsHasUmUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for add location has user
    public synchronized LmLocationsHasUmUser addLocationHasUsers(Session ses, int locationId, int userId,boolean isActive,Date createDate, Date updateDate, int createdBy, int updatedBy) {
        try {
            LmLocationsHasUmUserId addLocationIdAndUserId = new com.ring.locationManagementModel.LMS_LM_Locations_Has_Um_User_Id().addLocationHasUsersToComposite(ses, locationId, userId);
            if (addLocationIdAndUserId != null) {
                LmLocations selectedLocation = (LmLocations) ses.load(LmLocations.class, addLocationIdAndUserId.getLmLocationsId());
                UmUser selectedUser = (UmUser) ses.load(UmUser.class, addLocationIdAndUserId.getUmUserId());
                LmLocationsHasUmUser saveLocationHasUser = new LmLocationsHasUmUser();
                saveLocationHasUser.setCreatedAt(createDate);
                saveLocationHasUser.setLmLocations(selectedLocation);
                saveLocationHasUser.setCreatedBy(createdBy);
                saveLocationHasUser.setId(addLocationIdAndUserId);
                saveLocationHasUser.setIsActive(isActive);
                saveLocationHasUser.setUmUser(selectedUser);
                saveLocationHasUser.setUpdatedAt(updateDate);
                saveLocationHasUser.setUpdatedBy(updatedBy);
                ses.save(saveLocationHasUser);
                return saveLocationHasUser;
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
            return null;
        }
    }
}
