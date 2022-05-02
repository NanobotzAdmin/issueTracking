/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.queueManagementModel;

import com.ring.db.QmQueue;
import com.ring.db.QmQueueHasUser;
import com.ring.db.QmQueueHasUserId;
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
public class QMS_QM_Queue_Has_User {
      Logger logger = Logger.getLogger(this.getClass().getName());
    //method for get queue has users by queue id
    public synchronized List<QmQueueHasUser> getAllUsersByLocationId(Session ses, int queueId) {
        try {
            Query query = ses.createQuery("FROM QmQueueHasUser WHERE qmQueue ='"+queueId+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //method for get queues  by user id
    public synchronized List<QmQueueHasUser> getQueuesByUserId(Session ses, int userId) {
        try {
            Query query = ses.createQuery("FROM QmQueueHasUser WHERE umUser ='"+userId+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
        //method for get queue has user by queue id and user id
    public synchronized QmQueueHasUser getUsersByQueueId(Session ses, int queueId,int userId) {
        try {
            Query query = ses.createQuery("FROM QmQueueHasUser WHERE qmQueue='"+queueId+"' AND umUser='"+userId+"'");
            return (QmQueueHasUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for delete queue has users by queue
    public synchronized int deleteQueueHasUsersByQueueId(Session ses, int queueId) {
        try {
            String hql = "DELETE FROM qm_queue_has_user WHERE qm_queue_id=:queueId";
            Query query = ses.createSQLQuery(hql);
            query.setInteger("queueId", queueId);
            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString()); 
            e.printStackTrace();
            return 0;
        }
    }
    
     //    method for add queue has user
    public synchronized QmQueueHasUser addQueueHasUsers(Session ses, int queueId, int userId,byte isActive,Date createDate, Date updateDate, int createdBy, int updatedBy) {
        try {
            QmQueueHasUserId addQueueIdAndUserId = new com.ring.queueManagementModel.QMS_QM_Queue_Has_User_Id().addQueueHasUsersToComposite(ses, queueId, userId);
            if (addQueueIdAndUserId != null) {
                QmQueue selectedQueue = (QmQueue) ses.load(QmQueue.class, addQueueIdAndUserId.getQmQueueId());
                UmUser selectedUser = (UmUser) ses.load(UmUser.class, addQueueIdAndUserId.getUmUserId());
                QmQueueHasUser saveQueueHasUser = new QmQueueHasUser();
                saveQueueHasUser.setCreatedAt(createDate);
                saveQueueHasUser.setQmQueue(selectedQueue);
                saveQueueHasUser.setCreatedBy(createdBy);
                saveQueueHasUser.setId(addQueueIdAndUserId);
                saveQueueHasUser.setStatus(isActive);
                saveQueueHasUser.setUmUser(selectedUser);
                saveQueueHasUser.setUpdatedAt(updateDate);
                saveQueueHasUser.setUpdatedBy(updatedBy);
                ses.save(saveQueueHasUser);
                return saveQueueHasUser;
            } else {
                return null;
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
