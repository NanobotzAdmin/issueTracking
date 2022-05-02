/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.ticketManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.TmReplyMedia;
import com.ring.db.TmTicketReply;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class TMS_TM_Reply_Media {
      Logger logger = Logger.getLogger(this.getClass().getName());
     //    method for get all active tickets reply media
    public List<TmReplyMedia> getAllTicketMediaByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM TmReplyMedia");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM TmReplyMedia TMSTKR Where TMSTKR.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
          //    method for get reply media by reply id
    public List<TmReplyMedia> getReplyMediaByReplyId(Session ses, int replyId) {
        try {
            Query query = ses.createQuery("FROM TmReplyMedia TMSTKRM Where TMSTKRM.tmTicketReply ='" + replyId + "'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    
        //     method for save new ticket reply media
    public synchronized TmReplyMedia saveTicketReplyMedia(Session ses, String mediaType, String mediaPath, byte status,Date created_at, Date updated_at, TmTicketReply ticketReply, int created_by, int updated_by) {
        try {
            TmReplyMedia saveData = new TmReplyMedia();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setMediaPath(mediaPath);
            saveData.setMediaType(mediaType);
            saveData.setStatus(status);
            saveData.setTmTicketReply(ticketReply);
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
