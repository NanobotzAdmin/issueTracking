/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.ticketManagementModel;

import com.ring.db.QmQueueHasQuestion;
import com.ring.db.RcasAnswers;
import com.ring.db.TmTicketHasQueueHasQuestionHasAnswers;
import com.ring.db.TmTicketHasQueueHasQuestionHasAnswersId;
import com.ring.db.TmTickets;
import java.util.Date;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class TMS_TM_Ticket_Has_Queue_Has_Question_Has_Answers {
    Logger logger = Logger.getLogger(this.getClass().getName());
     //    method for add Ticket has queue has question has answers
    public synchronized TmTicketHasQueueHasQuestionHasAnswers addTicketHasQueueHasQuestionHasAnswers(Session ses, int ticketId, int queueId,int questionId,int answerId,byte isActive,Date createDate, Date updateDate, int createdBy, int updatedBy) {
        try {
            TmTicketHasQueueHasQuestionHasAnswersId addTicketHasRootCauseId = new com.ring.ticketManagementModel.TMS_TM_Ticket_Has_Queue_Has_Question_Has_Answers_Id().addTicketHasQueueHasQuestionHasAnswerstoToComposite(ses, ticketId, queueId, questionId, answerId);
            if(addTicketHasRootCauseId != null){
                TmTicketHasQueueHasQuestionHasAnswers addRootCause = new TmTicketHasQueueHasQuestionHasAnswers();
//                get queue has question
                QmQueueHasQuestion getSelectedQueueHasQuestion = new com.ring.rootCauseManagementModel.RCMS_QM_Queue_Has_Question().getRCQHasQueueByRCQIdAndQueueId(ses, addTicketHasRootCauseId.getQmQueueHasQuestionRcasQuestionId(), addTicketHasRootCauseId.getQmQueueHasQuestionQmQueueId());
                if(getSelectedQueueHasQuestion != null){
                    addRootCause.setCreatedAt(createDate);
                    addRootCause.setCreatedBy(createdBy);
                    addRootCause.setId(addTicketHasRootCauseId);
                    addRootCause.setQmQueueHasQuestion(getSelectedQueueHasQuestion);
                    addRootCause.setRcasAnswers((RcasAnswers)ses.load(RcasAnswers.class, addTicketHasRootCauseId.getRcasAnswersId()));
                    addRootCause.setStatus(isActive);
                    addRootCause.setTmTickets((TmTickets)ses.load(TmTickets.class, addTicketHasRootCauseId.getTmTicketsId()));
                    addRootCause.setUpdatedAt(updateDate);
                    addRootCause.setUpdatedBy(updatedBy);
                    ses.save(addRootCause);
                    return addRootCause;       
                }else{
                    return null;
                }
            } else {
                return null;
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }           
}
