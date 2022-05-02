/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.ticketManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.QmCategories;
import com.ring.db.QmQueue;
import com.ring.db.QmSubCategories;
import com.ring.db.TmTicketReply;
import com.ring.db.TmTickets;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class TMS_TM_Ticket_Reply {
          Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active tickets
 public List<TmTicketReply> getAllTicketReplyByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM TmTicketReply");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM TmTicketReply TMSTKR Where TMSTKR.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
     //    method for get ticket reply by ticket id
 public List<TmTicketReply> getTicketReplyByTicketId(Session ses, int ticketId) {
        try {
                Query query = ses.createQuery("FROM TmTicketReply TMSTKR Where TMSTKR.tmTickets ='" + ticketId + "'");
                return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
 //     method for save new ticket reply
     public synchronized TmTicketReply saveTicketReply(Session ses, String replyDescription,byte status,double expenses,Date created_at,Date updated_at,TmTickets selectedTicket,int created_by, int updated_by) {
        try {
            TmTicketReply saveData = new TmTicketReply();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setReplyDescription(replyDescription);
            saveData.setStatus(status);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            saveData.setTmTickets(selectedTicket);
            saveData.setReplyExpence(expenses);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
 
}
