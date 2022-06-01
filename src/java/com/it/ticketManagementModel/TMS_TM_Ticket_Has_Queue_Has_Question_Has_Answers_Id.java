/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.ticketManagementModel;

import com.it.db.TmTicketHasQueueHasQuestionHasAnswers;
import com.it.db.TmTicketHasQueueHasQuestionHasAnswersId;
import com.it.db.TmTicketsHasUmUserId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class TMS_TM_Ticket_Has_Queue_Has_Question_Has_Answers_Id {
                 Logger logger = Logger.getLogger(this.getClass().getName());
//       method for add ticket has Queue Has Question Has Answers to composite table
    public synchronized TmTicketHasQueueHasQuestionHasAnswersId addTicketHasQueueHasQuestionHasAnswerstoToComposite(Session ses, int ticketId, int queueId,int questionId,int answerId) {
        try {
            TmTicketHasQueueHasQuestionHasAnswersId saveTicketHasQueueHasQuestionHasAnswerstoToComposite = new TmTicketHasQueueHasQuestionHasAnswersId();
           saveTicketHasQueueHasQuestionHasAnswerstoToComposite.setQmQueueHasQuestionQmQueueId(queueId);
           saveTicketHasQueueHasQuestionHasAnswerstoToComposite.setQmQueueHasQuestionRcasQuestionId(questionId);
           saveTicketHasQueueHasQuestionHasAnswerstoToComposite.setRcasAnswersId(answerId);
           saveTicketHasQueueHasQuestionHasAnswerstoToComposite.setTmTicketsId(ticketId);
            return saveTicketHasQueueHasQuestionHasAnswerstoToComposite;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
