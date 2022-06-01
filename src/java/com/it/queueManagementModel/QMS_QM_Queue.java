/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.queueManagementModel;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.QmQueue;
import com.it.db.QmQueueIcons;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class QMS_QM_Queue {
     Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active Queues
 public List<QmQueue> getAllQueuesByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM QmQueue");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM QmQueue QMSQ Where QMSQ.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
     //    method for check queue name exists
 public QmQueue checkNameExists(Session ses, String queueName) {
        try {
                Query query = ses.createQuery("FROM QmQueue QMSQ Where QMSQ.queueName ='"+queueName+"'");
                return (QmQueue) query.uniqueResult();
            
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
     //    method for get queue Icons
 public List<QmQueueIcons> getIcons(Session ses) {
        try {
                Query query = ses.createQuery("FROM QmQueueIcons");
                return query.list();
            
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
  //     method for save queue
     public synchronized QmQueue saveQueue(Session ses, String queueName, String queueDescription,String backGroundImage,String queueIcon,String queueFontColor,byte isActive,Date created_at,Date updated_at,int created_by, int updated_by) {
        try {
            QmQueue saveData = new QmQueue();
            saveData.setBackgroundImage(backGroundImage);
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setDescription(queueDescription);
            saveData.setQueueName(queueName);
            saveData.setQueueColor(queueFontColor);
            saveData.setQueueIcon(queueIcon);
            saveData.setStatus(isActive);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
      //     method for update queue
     public synchronized QmQueue updateQueue(Session ses, String queueName, String queueDescription,byte isActive,Date updated_at,QmQueue selectedQueue,int updated_by) {
        try { 
            selectedQueue.setDescription(queueDescription);
            selectedQueue.setQueueName(queueName);
            selectedQueue.setStatus(isActive);
            selectedQueue.setUpdatedAt(updated_at);
            selectedQueue.setUpdatedBy(updated_by);
            ses.update(selectedQueue);
            return selectedQueue;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
