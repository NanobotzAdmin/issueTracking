/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.queueManagementModel;

import com.ring.db.QmQueueHasUserId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class QMS_QM_Queue_Has_User_Id {
            Logger logger = Logger.getLogger(this.getClass().getName());
//       method for add queue has users to composide table
    public synchronized QmQueueHasUserId addQueueHasUsersToComposite(Session ses, int queueId, int userId) {
        try {
            QmQueueHasUserId saveQueueHasUsersToComposite = new QmQueueHasUserId();
            saveQueueHasUsersToComposite.setQmQueueId(queueId);
            saveQueueHasUsersToComposite.setUmUserId(userId);
            return saveQueueHasUsersToComposite;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
