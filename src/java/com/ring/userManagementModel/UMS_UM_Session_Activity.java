/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.userManagementModel;

import com.ring.db.SmSession;
import com.ring.db.SmSessionActivity;
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
public class UMS_UM_Session_Activity {
//     Logger logger = Logger.getLogger(this.getClass().getName());
    
     //    method for get user activities by filters
    public synchronized List<SmSessionActivity> searchActivitiesByfilters(Session ses, int branchId, int departmentId,int userId,String activityType,String startDate,String endDate) {
        try {
            String query = "";
            query = "From SmSessionActivity SMSUSA where SMSUSA.umUser is not null";
            
            if (!startDate.isEmpty() && !endDate.isEmpty()) {
                query += " AND SMSUSA.createdAt BETWEEN '" + startDate + "' AND '" + endDate + "' ";
            }
            if (branchId > 0) {
                query += " AND SMSUSA.umUser IN(SELECT UMSUSR.id FROM UmUser UMSUSR WHERE UMSUSR.omBranches='"+branchId+"' )";
            }
            if (departmentId > 0) {
                query += " AND SMSUSA.umUser IN(SELECT UMSUSR.id FROM UmUser UMSUSR WHERE UMSUSR.omDepartment='"+departmentId+"' )";
            }
            if (userId > 0) {
                query += " AND SMSUSA.umUser='"+userId+"' ";
            }
            if (!activityType.equals("") && !activityType.equals("nothing")) {
                query += " AND SMSUSA.activityType='"+activityType+"' ";
            }
            Query searchUsers = ses.createQuery(query);
            return searchUsers.list();
        } catch (Exception e) {
            return null;
        }
    }
     //    method for get activities by selected user
    public synchronized List<SmSessionActivity> searchActivitiesByUser(Session ses, int userId) {
        try {
            String query = "";
            query = "From SmSessionActivity SMSUSA where SMSUSA.umUser='"+userId+"' ";
           
            Query searchUsers = ses.createQuery(query);
            return searchUsers.list();
        } catch (Exception e) {
            return null;
        }
    }
     //    method for get activities by selected ticket
    public synchronized List<SmSessionActivity> searchActivitiesByTicketId(Session ses, int ticketId,String topic1,String topic2) {
        try {
            String query = "";
            query = "From SmSessionActivity SMSUSA where SMSUSA.activityId='"+ticketId+"' AND (SMSUSA.activityTopic='"+topic1+"' OR SMSUSA.activityTopic='"+topic2+"') ORDER BY SMSUSA.id DESC";
            Query finalQuery = ses.createQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            return null;
        }
    }
     //    method for get activities by selected ticket to time line show
    public synchronized List<SmSessionActivity> searchActivitiesByTicketIdToTimeLine(Session ses, int ticketId,String topic1,String topic2) {
        try {
            String query = "";
            query = "From SmSessionActivity SMSUSA where SMSUSA.activityId='"+ticketId+"' AND (SMSUSA.description LIKE '%Ticket has been Saved by %' OR SMSUSA.description LIKE '%Ticket has been Completed by%' OR SMSUSA.description LIKE '%Ticket has been Rejected by%' OR SMSUSA.description LIKE '%Ticket has been Confirmed by%' OR SMSUSA.description LIKE '%Ticket has been Archived by%')  AND (SMSUSA.activityTopic='"+topic1+"' OR SMSUSA.activityTopic='"+topic2+"') ORDER BY SMSUSA.id DESC";
            Query finalQuery = ses.createQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            return null;
        }
    }
    //    method for save session activity
    public SmSessionActivity saveSessionActivity(Session ses, String description, Date date,String activityType,String activityTopic,SmSession activeHttpSession,UmUser createdBy) {
        try {
            SmSessionActivity sessionActivity = new SmSessionActivity();
           sessionActivity.setActivityTopic(activityTopic);
           sessionActivity.setActivityType(activityType);
           sessionActivity.setCreatedAt(date);
           sessionActivity.setDescription(description);
           sessionActivity.setSmSession(activeHttpSession);
           sessionActivity.setUmUser(createdBy);
            ses.save(sessionActivity);
            return sessionActivity;
        } catch (Exception e) {
//             logger.error(e.toString());
            e.printStackTrace();
            return null;
        }

    }
    //    method for save session activity new method
    public SmSessionActivity saveSessionActivityNew(Session ses, String description, Date date,String activityType,String activityTopic,int activityId,SmSession activeHttpSession,UmUser createdBy) {
        try {
            SmSessionActivity sessionActivity = new SmSessionActivity();
           sessionActivity.setActivityTopic(activityTopic);
           sessionActivity.setActivityId(activityId);
           sessionActivity.setActivityType(activityType);
           sessionActivity.setCreatedAt(date);
           sessionActivity.setDescription(description);
           sessionActivity.setSmSession(activeHttpSession);
           sessionActivity.setUmUser(createdBy);
            ses.save(sessionActivity);
            return sessionActivity;
        } catch (Exception e) {
//             logger.error(e.toString());
            e.printStackTrace();
            return null;
        }

    }
}
