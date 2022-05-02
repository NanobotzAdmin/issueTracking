/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.rootCauseManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.QmQueue;
import com.ring.db.RcasQuestion;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class RCMS_Rcas_Question {
        Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active Queues
 public List<RcasQuestion> getAllRootCauseByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM RcasQuestion");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM RcasQuestion RCMSQ Where RCMSQ.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for check question name exists
 public RcasQuestion checkNameExists(Session ses, String questionName) {
        try {
                Query query = ses.createQuery("FROM RcasQuestion RCMSQ Where RCMSQ.questionName ='" + questionName + "'");
                return (RcasQuestion) query.uniqueResult();
            
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
   //     method for save Root Cause Questions
     public synchronized RcasQuestion saveRootCauseQuestionQueue(Session ses, String questionName, byte isActive,Date created_at,Date updated_at,int created_by, int updated_by) {
        try {
            RcasQuestion saveData = new RcasQuestion();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setQuestionName(questionName);
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
       //     method for update Root Cause Questions
     public synchronized RcasQuestion updateRootCauseQuestionQueue(Session ses, String questionName,byte isActive,Date updated_at,RcasQuestion selectedRootCauseQuestion,int updated_by) {
        try {    
            selectedRootCauseQuestion.setCreatedBy(updated_by);
            selectedRootCauseQuestion.setQuestionName(questionName);
            selectedRootCauseQuestion.setStatus(isActive);
            selectedRootCauseQuestion.setUpdatedAt(updated_at);
            ses.update(selectedRootCauseQuestion);
            return selectedRootCauseQuestion;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
