/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.rootCauseManagementModel;

import com.it.db.QmQueue;
import com.it.db.QmQueueHasQuestion;
import com.it.db.QmQueueHasQuestionId;
import com.it.db.RcasQuestion;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class RCMS_QM_Queue_Has_Question {
       Logger logger = Logger.getLogger(this.getClass().getName());
    //method for get RCQ has queue by RCQ id
    public synchronized List<QmQueueHasQuestion> getAllRCQHasQueueByRCQId(Session ses, int rcqId) {
        try {
            Query query = ses.createQuery("FROM QmQueueHasQuestion WHERE rcasQuestion ='"+rcqId+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
         //method for get rcq has queue by rcq id and queue id
    public synchronized QmQueueHasQuestion getRCQHasQueueByRCQIdAndQueueId(Session ses, int rcqId,int queueId) {
        try {
            Query query = ses.createQuery("FROM QmQueueHasQuestion WHERE rcasQuestion='"+rcqId+"' AND qmQueue='"+queueId+"'");
            return (QmQueueHasQuestion) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //method for get questiob by queue id
    public synchronized List<QmQueueHasQuestion> getAllQueueByQueueId(Session ses, int queue) {
        try {
            Query query = ses.createQuery("FROM QmQueueHasQuestion WHERE qmQueue ='"+queue+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
     //    method for delete RCQ has queue by RCQ id
    public synchronized int deleteRCQHasQueueByRCQId(Session ses, int rcqId) {
        try {
            String hql = "DELETE FROM qm_queue_has_question WHERE rcas_question_id=:rcqId";
            Query query = ses.createSQLQuery(hql);
            query.setInteger("rcqId", rcqId);
            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString()); 
            e.printStackTrace();
            return 0;
        }
    }
     //    method for add RCQ has queue
    public synchronized QmQueueHasQuestion addRCQHasQueue(Session ses, int queueId, int rcqId,byte isActive,Date createDate, Date updateDate, int createdBy, int updatedBy) {
        try {
            QmQueueHasQuestionId addQueueHasQuestionId = new com.it.rootCauseManagementModel.RCMS_QM_Queue_Has_Question_Id().addRCQHasQueueToComposite(ses, queueId, rcqId);
            if (addQueueHasQuestionId != null) {
                QmQueue selectedQueue = (QmQueue) ses.load(QmQueue.class, addQueueHasQuestionId.getQmQueueId());
                RcasQuestion selectedRCQ = (RcasQuestion) ses.load(RcasQuestion.class, addQueueHasQuestionId.getRcasQuestionId());
                QmQueueHasQuestion saveQueueHasRCQ = new QmQueueHasQuestion();
                saveQueueHasRCQ.setCreatedAt(createDate);
                saveQueueHasRCQ.setQmQueue(selectedQueue);
                saveQueueHasRCQ.setCreatedBy(createdBy);
                saveQueueHasRCQ.setId(addQueueHasQuestionId);
                saveQueueHasRCQ.setStatus(isActive);
                saveQueueHasRCQ.setRcasQuestion(selectedRCQ);
                saveQueueHasRCQ.setUpdatedAt(updateDate);
                saveQueueHasRCQ.setUpdatedBy(updatedBy);
                ses.save(saveQueueHasRCQ);
                return saveQueueHasRCQ;
            } else {
                return null;
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
