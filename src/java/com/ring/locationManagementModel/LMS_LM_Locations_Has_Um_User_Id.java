/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.locationManagementModel;

import com.ring.db.LmLocationsHasUmUserId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class LMS_LM_Locations_Has_Um_User_Id {
        Logger logger = Logger.getLogger(this.getClass().getName());
//       method for add location has users to composide table
    public synchronized LmLocationsHasUmUserId addLocationHasUsersToComposite(Session ses, int locationId, int userId) {
        try {
            LmLocationsHasUmUserId saveLocationHasUsersToComposite = new LmLocationsHasUmUserId();
            saveLocationHasUsersToComposite.setLmLocationsId(locationId);
            saveLocationHasUsersToComposite.setUmUserId(userId);
            return saveLocationHasUsersToComposite;
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
            return null;
        }
    }
}
