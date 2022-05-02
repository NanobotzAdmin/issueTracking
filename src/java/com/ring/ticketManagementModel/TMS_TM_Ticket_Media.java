/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.ticketManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.TmTicketMedia;
import com.ring.db.TmTickets;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class TMS_TM_Ticket_Media {
    Logger logger = Logger.getLogger(this.getClass().getName());
     //    method for get all active tickets
    public List<TmTicketMedia> getAllTicketMediaByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM TmTicketMedia");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM TmTicketMedia TMSTKM Where TMSTKM.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
      //    method for get tickets media by ticket id
    public List<TmTicketMedia> getTicketMediaByTicketd(Session ses, int ticketId) {
        try {
            Query query = ses.createQuery("FROM TmTicketMedia TMSTKM Where TMSTKM.tmTickets ='" + ticketId + "'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    
        //     method for save new ticket media
    public synchronized TmTicketMedia saveTicketMedia(Session ses, String mediaType, String mediaPath, byte status,Date created_at, Date updated_at, TmTickets ticket, int created_by, int updated_by) {
        try {
            TmTicketMedia saveData = new TmTicketMedia();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setMediaPath(mediaPath);
            saveData.setMediaType(mediaType);
            saveData.setStatus(status);
            saveData.setTmTickets(ticket);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
