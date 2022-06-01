/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.ticketManagementModel;

import com.it.db.QmQueueHasUserId;
import com.it.db.TmTicketsHasUmUserId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class TMS_TM_Tickets_Has_Um_User_Id {
             Logger logger = Logger.getLogger(this.getClass().getName());
//       method for add ticket has users to composide table
    public synchronized TmTicketsHasUmUserId addTicketHasUsersToComposite(Session ses, int ticketId, int userId) {
        try {
            TmTicketsHasUmUserId saveTicketHasUsersToComposite = new TmTicketsHasUmUserId();
            saveTicketHasUsersToComposite.setTmTicketsId(ticketId);
            saveTicketHasUsersToComposite.setUmUserId(userId);
            return saveTicketHasUsersToComposite;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
