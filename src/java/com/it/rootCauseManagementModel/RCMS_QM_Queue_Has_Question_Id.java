/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.rootCauseManagementModel;

import com.it.db.QmQueueHasQuestionId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class RCMS_QM_Queue_Has_Question_Id {
                Logger logger = Logger.getLogger(this.getClass().getName());
//       method for add RCQ has queue to composide table
    public synchronized QmQueueHasQuestionId addRCQHasQueueToComposite(Session ses, int queueId, int rcqId) {
        try {
            QmQueueHasQuestionId saveQueueHasRCQToComposite = new QmQueueHasQuestionId();
            saveQueueHasRCQToComposite.setQmQueueId(queueId);
            saveQueueHasRCQToComposite.setRcasQuestionId(rcqId);
            return saveQueueHasRCQToComposite;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
