/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.locationManagementModel;

import com.it.db.LmLocationHistory;
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
public class LMS_LM_Location_History {
        Logger logger = Logger.getLogger(this.getClass().getName());
    //method for get location History by location id
    public synchronized List<LmLocationHistory> getAllHistoryLocationId(Session ses, int locationId) {
        try {
            Query query = ses.createQuery("FROM LmLocationHistory WHERE lmLocations ='"+locationId+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    
     //     method for save location history
     public synchronized LmLocationHistory saveLocationHistory(Session ses, String description,Date created_at,Date updated_at,LmLocations location,int created_by, int updated_by) {
        try {
            LmLocationHistory saveData = new LmLocationHistory();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setLmLocations(location);
            saveData.setUpdateDescription(description);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    
}
