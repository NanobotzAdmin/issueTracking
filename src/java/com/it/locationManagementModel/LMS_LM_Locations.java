/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.locationManagementModel;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.LmLocations;
import com.it.db.UmUser;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class LMS_LM_Locations {
      Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active Locations
 public List<LmLocations> getAllLocationsByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM LmLocations");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM LmLocations LMSL Where LMSL.isActive ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
     //    method for check location name exists
 public LmLocations checkNameExists(Session ses, String locationName) {
        try {
                Query query = ses.createQuery("FROM LmLocations LMSL Where LMSL.locationName ='" + locationName + "'");
                return (LmLocations) query.uniqueResult();  
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
     //    method for check location Address exists
 public LmLocations checkAddressExists(Session ses, String locationAddress) {
        try {
                Query query = ses.createQuery("FROM LmLocations LMSL Where LMSL.locationAddress ='" + locationAddress + "'");
                return (LmLocations) query.uniqueResult();     
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
 //     method for save location
     public synchronized LmLocations saveLocation(Session ses, String locationName, String address,String mobile,String landnumber,boolean isActive,Date created_at,Date updated_at,UmUser branchManager,int created_by, int updated_by) {
        try {
            LmLocations saveData = new LmLocations();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setIsActive(isActive);
            saveData.setLandPhoneNumber(landnumber);
            saveData.setLocationAddress(address);
            saveData.setLocationName(locationName);
            saveData.setMobileNumber(mobile);
            saveData.setUmUser(branchManager);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
 //     method for update location
     public synchronized LmLocations updateLocation(Session ses, String locationName, String address,String mobile,String landnumber,boolean isActive,Date updated_at,UmUser branchManager,LmLocations selectedLocation,int updated_by) {
        try {    
            selectedLocation.setIsActive(isActive);
            selectedLocation.setLandPhoneNumber(landnumber);
            selectedLocation.setLocationAddress(address);
            selectedLocation.setLocationName(locationName);
            selectedLocation.setMobileNumber(mobile);
            selectedLocation.setUmUser(branchManager);
            selectedLocation.setUpdatedAt(updated_at);
            selectedLocation.setUpdatedBy(updated_by);
            ses.update(selectedLocation);
            return selectedLocation;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
