/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.rootCauseManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.RcasAnswers;
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
public class RCMS_Rcas_Answers {
     Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active Answers
 public List<RcasAnswers> getAllAnswersByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM RcasAnswers");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM RcasAnswers RCMSA Where RCMSA.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for check Answer name exists
 public RcasAnswers checkNameExists(Session ses, String answer) {
        try {
                Query query = ses.createQuery("FROM RcasAnswers RCMSA Where RCMSA.answer ='" + answer + "'");
                return (RcasAnswers) query.uniqueResult();
            
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
   //     method for save Root Cause Answer
     public synchronized RcasAnswers saveRootCauseAnswer(Session ses, String answer, byte isActive,Date created_at,Date updated_at,int created_by, int updated_by) {
        try {
            RcasAnswers saveData = new RcasAnswers();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setAnswer(answer);
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
       //     method for update Root Cause Answer
     public synchronized RcasAnswers updateRootCauseAnswer(Session ses, String answer,byte isActive,Date updated_at,RcasAnswers selectedRootCauseAnswer,int updated_by) {
        try {    
            selectedRootCauseAnswer.setCreatedBy(updated_by);
            selectedRootCauseAnswer.setAnswer(answer);
            selectedRootCauseAnswer.setStatus(isActive);
            selectedRootCauseAnswer.setUpdatedAt(updated_at);
            ses.update(selectedRootCauseAnswer);
            return selectedRootCauseAnswer;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
