/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.ticketManagementModel;

import com.ring.db.TmTickets;
import com.ring.db.TmTicketsHasUmUser;
import com.ring.db.TmTicketsHasUmUserId;
import com.ring.db.UmUser;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class TMS_TM_Tickets_Has_Um_User {
    Logger logger = Logger.getLogger(this.getClass().getName());
    //method for get Ticket has users by ticket id
    public synchronized List<TmTicketsHasUmUser> getAllUsersByTicketId(Session ses, int ticketId) {
        try {
            Query query = ses.createQuery("FROM TmTicketsHasUmUser WHERE tmTickets ='"+ticketId+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
        //method for get ticket has user by ticket id and user id
    public synchronized TmTicketsHasUmUser getUsersByTicketIdAndUserId(Session ses, int ticketId,int userId) {
        try {
            Query query = ses.createQuery("FROM TmTicketsHasUmUser WHERE tmTickets='"+ticketId+"' AND umUser='"+userId+"'");
            return (TmTicketsHasUmUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for delete ticket has users by ticket
    public synchronized int deleteTicketHasUsersByTicketId(Session ses, int ticketId) {
        try {
            String hql = "DELETE FROM tm_tickets_has_um_user WHERE tm_tickets_id=:ticketId";
            Query query = ses.createSQLQuery(hql);
            query.setInteger("ticketId", ticketId);
            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString()); 
            e.printStackTrace();
            return 0;
        }
    }
     //    method for add Ticket has user
    public synchronized TmTicketsHasUmUser addTicketHasUsers(Session ses, int ticketId, int userId,byte isActive,Date createDate, Date updateDate, int createdBy, int updatedBy) {
        try {
            TmTicketsHasUmUserId addTicketIdAndUserId = new com.ring.ticketManagementModel.TMS_TM_Tickets_Has_Um_User_Id().addTicketHasUsersToComposite(ses, ticketId, userId);
            if (addTicketIdAndUserId != null) {
                TmTickets selectedTicket = (TmTickets) ses.load(TmTickets.class, addTicketIdAndUserId.getTmTicketsId());
                UmUser selectedUser = (UmUser) ses.load(UmUser.class, addTicketIdAndUserId.getUmUserId());
                TmTicketsHasUmUser saveTicketHasUser = new TmTicketsHasUmUser();
                saveTicketHasUser.setCreatedAt(createDate);
                saveTicketHasUser.setTmTickets(selectedTicket);
                saveTicketHasUser.setCreatedBy(createdBy);
                saveTicketHasUser.setId(addTicketIdAndUserId);
                saveTicketHasUser.setStatus(isActive);
                saveTicketHasUser.setUmUser(selectedUser);
                saveTicketHasUser.setUpdatedAt(updateDate);
                saveTicketHasUser.setUpdatedBy(updatedBy);
                ses.save(saveTicketHasUser);
                return saveTicketHasUser;
            } else {
                return null;
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    } 
    
    
}
