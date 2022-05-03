/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.ticketManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.LmLocations;
import com.ring.db.QmCategories;
import com.ring.db.QmQueue;
import com.ring.db.QmSubCategories;
import com.ring.db.TmTickets;
import com.ring.db.UmCustomer;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class TMS_TM_Tickets {

    Logger logger = Logger.getLogger(this.getClass().getName());

    //    method for get all active tickets
    public List<TmTickets> getAllTicketsByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM TmTickets TMSTK ORDER BY TMSTK.id DESC");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.status ='" + status + "' ORDER BY TMSTK.id DESC");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get tickets by queue id
    public List<TmTickets> getTicketsByQueueId(Session ses, int queueId) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.qmQueue ='" + queueId + "'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for get tickets by queue id and status
    public List<TmTickets> getTicketsByQueueIdAndStatus(Session ses, int queueId,byte status) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.qmQueue ='" + queueId + "' AND TMSTK.status='"+status+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get tickets by category id
    public List<TmTickets> getTicketsByCategoryId(Session ses, int categoryId) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.qmCategories ='" + categoryId + "'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for get tickets by category id ans status
    public List<TmTickets> getTicketsByCategoryIdAndStatus(Session ses, int categoryId,byte status) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.qmCategories ='" + categoryId + "' AND TMSTK.status='"+status+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get tickets by sub category id
    public List<TmTickets> getTicketsBySubCategoryId(Session ses, int subCategoryId) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.qmSubCategories ='" + subCategoryId + "'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for get tickets by sub category id and status
    public List<TmTickets> getTicketsBySubCategoryIdAndStatus(Session ses, int subCategoryId,byte status) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.qmSubCategories ='" + subCategoryId + "' AND TMSTK.status='"+status+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get user created active tickets 
    public List<TmTickets> getUserCreatedActiveTickets(Session ses, int user, byte status) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.status ='" + status + "' AND TMSTK.createdBy='" + user + "' ");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get user created complete tickets 
    public List<TmTickets> getUserCreatedCompleteTickets(Session ses, int user, byte status, byte status2) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.status ='" + status + "' OR TMSTK.status ='" + status2 + "' AND TMSTK.createdBy='" + user + "' ");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get Ticket by ticket key 
    public TmTickets getTicketByKey(Session ses, String key) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.tid ='" + key + "'");
            return (TmTickets) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get Ticket by ticket id 
    public TmTickets getTicketById(Session ses, int id) {
        try {
            Query query = ses.createQuery("FROM TmTickets TMSTK Where TMSTK.id ='" + id + "'");
            return (TmTickets) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for get  created tickets by queue or category or sub category

    public List<TmTickets> getTicketsByQueueOrCatOrSubCat(Session ses, int queueId, int categoryId, int subCatoegoryId) {
        try {
            String query = "FROM TmTickets TMSTK Where TMSTK.status Is Not Null ";
            if (queueId > 0) {
                query += "AND TMSTK.qmQueue='" + queueId + "'";
            }
            if (categoryId > 0) {
                query += "AND TMSTK.qmCategories='" + categoryId + "'";
            }
            if (subCatoegoryId > 0) {
                query += "AND TMSTK.qmSubCategories='" + subCatoegoryId + "'";
            }
            query += "ORDER BY TMSTK.id DESC";

            Query finalQuery = ses.createQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for get  created tickets by queue or category or sub category with date range

    public List<TmTickets> getTicketsByQueueOrCatOrSubCatAndDateRange(Session ses, int queueId, int categoryId, int subCatoegoryId, String startDate, String endDate) {
        try {
            String query = "FROM TmTickets TMSTK Where TMSTK.status Is Not Null ";
            if (queueId > 0) {
                query += "AND TMSTK.qmQueue='" + queueId + "'";
            }
            if (categoryId > 0) {
                query += "AND TMSTK.qmCategories='" + categoryId + "'";
            }
            if (subCatoegoryId > 0) {
                query += "AND TMSTK.qmSubCategories='" + subCatoegoryId + "'";
            }
            if (!startDate.isEmpty() && !endDate.isEmpty()) {
                query += " AND TMSTK.createdAt BETWEEN '" + startDate + "' AND '" + endDate + "' ";
            }
            Query finalQuery = ses.createQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //    method for get   tickets by status and date range
    public List<TmTickets> getTicketsByStatusAndDateRange(Session ses, byte status, String startDate, String endDate) {
        try {
            String query = "FROM TmTickets TMSTK Where TMSTK.status Is Not Null ";
            if (status > 0) {
                query += "AND TMSTK.status='" + status + "'";
            }
            if (!startDate.isEmpty() && !endDate.isEmpty()) {
                query += " AND TMSTK.createdAt BETWEEN '" + startDate + "' AND '" + endDate + "' ";
            }
            Query finalQuery = ses.createQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get tickets by user id and current month
    public List<Object[]> getTicketsByUserIdAndCurrentMonth(Session ses, int userId) {
        try {
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MONTH, 0);
            calendar.set(Calendar.DATE, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
            Date monthFirstDay = calendar.getTime();
            calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
            Date monthLastDay = calendar.getTime();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
//        SimpleDateFormat df = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
            String startDateStr = df.format(monthFirstDay);
            String endDateStr = df.format(monthLastDay);
            String query = "SELECT\n"
                    + "    tm_tickets.id\n"
                    + "    , tm_tickets.ticket_name\n"
                    + "    , tm_tickets.qm_queue_id\n"
                    + "    , tm_tickets.qm_categories_id\n"
                    + "    , tm_tickets.qm_sub_categories_id\n"
                    + "    , tm_tickets.created_by\n"
                    + "    , tm_tickets_has_um_user.um_user_id\n"
                    + "FROM\n"
                    + "    nanobotz_issue_tracking.tm_tickets_has_um_user\n"
                    + "    INNER JOIN nanobotz_issue_tracking.tm_tickets \n"
                    + "        ON (tm_tickets_has_um_user.tm_tickets_id = tm_tickets.id)\n"
                    + "WHERE (tm_tickets.created_by='" + userId + "' OR tm_tickets_has_um_user.um_user_id='" + userId + "' AND tm_tickets.created_at BETWEEN '" + startDateStr + "' AND '" + endDateStr + "')GROUP BY tm_tickets.id;";
//            System.out.println(" final qu = " + query);
            Query finalQuery = ses.createSQLQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get tickets by user id and current month
    public List<Object[]> getTicketsByUserIdAndCurrentMonthAndStatus(Session ses, int userId, byte status, byte status2, byte status3) {
        try {
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MONTH, 0);
            calendar.set(Calendar.DATE, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
            Date monthFirstDay = calendar.getTime();
            calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
            Date monthLastDay = calendar.getTime();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
//        SimpleDateFormat df = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
            String startDateStr = df.format(monthFirstDay);
            String endDateStr = df.format(monthLastDay);
            String query = "SELECT\n"
                    + "    tm_tickets.id\n"
                    + "    , tm_tickets.ticket_name\n"
                    + "    , tm_tickets.qm_queue_id\n"
                    + "    , tm_tickets.qm_categories_id\n"
                    + "    , tm_tickets.qm_sub_categories_id\n"
                    + "    , tm_tickets.created_by\n"
                    + "    , tm_tickets_has_um_user.um_user_id\n"
                    + "FROM\n"
                    + "    nanobotz_issue_tracking.tm_tickets_has_um_user\n"
                    + "    INNER JOIN nanobotz_issue_tracking.tm_tickets \n"
                    + "        ON (tm_tickets_has_um_user.tm_tickets_id = tm_tickets.id)\n"
                    + "WHERE (tm_tickets.created_by='" + userId + "' OR tm_tickets_has_um_user.um_user_id='" + userId + "' AND tm_tickets.created_at BETWEEN '" + startDateStr + "' AND '" + endDateStr + "') AND (tm_tickets.status='" + status + "' OR tm_tickets.status='" + status2 + "' OR tm_tickets.status='" + status3 + "')GROUP BY tm_tickets.id;";
//            System.out.println(" final qu = " + query);
            Query finalQuery = ses.createSQLQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get tickets by user id and queue Id
    public List<Object[]> getTicketsByUserIdAndQueueId(Session ses, int userId, int queueId, int catId, int subCatId) {
        try {
            String query = "SELECT\n"
                    + "    tm_tickets.id\n"
                    + "    , tm_tickets.ticket_name\n"
                    + "    , tm_tickets.qm_queue_id\n"
                    + "    , tm_tickets.qm_categories_id\n"
                    + "    , tm_tickets.qm_sub_categories_id\n"
                    + "    , tm_tickets.created_by\n"
                    + "    , tm_tickets_has_um_user.um_user_id\n"
                    + "FROM\n"
                    + "    nanobotz_issue_tracking.tm_tickets_has_um_user\n"
                    + "    INNER JOIN nanobotz_issue_tracking.tm_tickets \n"
                    + "        ON (tm_tickets_has_um_user.tm_tickets_id = tm_tickets.id)\n"
                    + "WHERE (tm_tickets.created_by='" + userId + "' OR tm_tickets_has_um_user.um_user_id='" + userId + "')";
            if (queueId > 0) {
                query += "AND tm_tickets.qm_queue_id='" + queueId + "'";
            }
            if (catId > 0) {
                query += "AND tm_tickets.qm_categories_id ='" + catId + "'";
            }
            if (subCatId > 0) {
                query += "AND tm_tickets.qm_sub_categories_id ='" + subCatId + "'";
            }
            query += "GROUP BY tm_tickets.id";
//            System.out.println(" final qu = " + query);
            Query finalQuery = ses.createSQLQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get ticket total expenses by para *********************** method for get total expence fast
//    public double getTicketTotalExpenceByUserIdAndQueueId(Session ses, int userId, int queueId, int catId, int subCatId) {
//        try {
//            String query = "SELECT\n"
//                    + "    tm_tickets.id\n"
//                    + "    , tm_tickets.ticket_name\n"
//                    + "    , tm_tickets.qm_queue_id\n"
//                    + "    , tm_tickets.qm_categories_id\n"
//                    + "    , tm_tickets.qm_sub_categories_id\n"
//                    + "    , tm_tickets.created_by\n"
//                    + "    , tm_tickets_has_um_user.um_user_id\n"
//                    + " , SUM(`tm_tickets`.`total_expence`)\n"
//                    + "FROM\n"
//                    + "    nanobotz_issue_tracking.tm_tickets_has_um_user\n"
//                    + "    INNER JOIN nanobotz_issue_tracking.tm_tickets \n"
//                    + "        ON (tm_tickets_has_um_user.tm_tickets_id = tm_tickets.id)\n"
//                    + "WHERE (tm_tickets.created_by='" + userId + "' OR tm_tickets_has_um_user.um_user_id='" + userId + "')";
//            if (queueId > 0) {
//                query += "AND tm_tickets.qm_queue_id='" + queueId + "'";
//            }
//            if (catId > 0) {
//                query += "AND tm_tickets.qm_categories_id ='" + catId + "'";
//            }
//            if (subCatId > 0) {
//                query += "AND tm_tickets.qm_sub_categories_id ='" + subCatId + "'";
//            }
//            query += "GROUP BY tm_tickets.id";
////            System.out.println(" final qu = " + query);
//            Query finalQuery = ses.createSQLQuery(query);
//            double gg = 0.0;
//            if(finalQuery.list().get(0) != null){
//                gg = (double) finalQuery.list().get(7);
//            }
//            System.out.println("gg = " + gg);
//            return gg;
//        } catch (Exception e) {
//            e.printStackTrace();
////            logger.error(e.toString());
//            return 0.0;
//        }
//    }

    //    method for get tickets by user id and queue Id by date range
    public List<Object[]> getTicketsByUserIdAndQueueIdByDateRange(Session ses, int userId, int queueId, int catId, int subCatId, String startDate, String endDate) {
        try {
            String query = "SELECT\n"
                    + "    tm_tickets.id\n"
                    + "    , tm_tickets.ticket_name\n"
                    + "    , tm_tickets.qm_queue_id\n"
                    + "    , tm_tickets.qm_categories_id\n"
                    + "    , tm_tickets.qm_sub_categories_id\n"
                    + "    , tm_tickets.created_by\n"
                    + "    , tm_tickets_has_um_user.um_user_id\n"
                    + "FROM\n"
                    + "    nanobotz_issue_tracking.tm_tickets_has_um_user\n"
                    + "    INNER JOIN nanobotz_issue_tracking.tm_tickets \n"
                    + "        ON (tm_tickets_has_um_user.tm_tickets_id = tm_tickets.id)\n"
                    + "WHERE (tm_tickets.created_by='" + userId + "' OR tm_tickets_has_um_user.um_user_id='" + userId + "')";
            if (queueId > 0) {
                query += "AND tm_tickets.qm_queue_id='" + queueId + "'";
            }
            if (catId > 0) {
                query += "AND tm_tickets.qm_categories_id ='" + catId + "'";
            }
            if (subCatId > 0) {
                query += "AND tm_tickets.qm_sub_categories_id ='" + subCatId + "'";
            }
            if (!startDate.isEmpty() && !endDate.isEmpty()) {
                query += " AND tm_tickets.created_at BETWEEN '" + startDate + "' AND '" + endDate + "' ";
            }
            query += "GROUP BY tm_tickets.id";
//            System.out.println(" final qu = " + query);
            Query finalQuery = ses.createSQLQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get complete tickets by user id and queue Id
    public List<Object[]> getCompleteTicketsByUserIdAndQueueId(Session ses, int userId, int queueId, int catId, int subCatId, byte status, byte status2, byte status3) {
        try {
            String query = "SELECT\n"
                    + "    tm_tickets.id\n"
                    + "    , tm_tickets.ticket_name\n"
                    + "    , tm_tickets.qm_queue_id\n"
                    + "    , tm_tickets.qm_categories_id\n"
                    + "    , tm_tickets.qm_sub_categories_id\n"
                    + "    , tm_tickets.created_by\n"
                    + "    , tm_tickets_has_um_user.um_user_id\n"
                    + "FROM\n"
                    + "    nanobotz_issue_tracking.tm_tickets_has_um_user\n"
                    + "    INNER JOIN nanobotz_issue_tracking.tm_tickets \n"
                    + "        ON (tm_tickets_has_um_user.tm_tickets_id = tm_tickets.id)\n"
                    + "WHERE (tm_tickets.created_by='" + userId + "' OR tm_tickets_has_um_user.um_user_id='" + userId + "') AND (tm_tickets.status='" + status + "' OR tm_tickets.status='" + status2 + "' OR tm_tickets.status='" + status3 + "')";
            if (queueId > 0) {
                query += "AND tm_tickets.qm_queue_id='" + queueId + "'";
            }
            if (catId > 0) {
                query += "AND tm_tickets.qm_categories_id ='" + catId + "'";
            }
            if (subCatId > 0) {
                query += "AND tm_tickets.qm_sub_categories_id ='" + subCatId + "'";
            }
            query += "GROUP BY tm_tickets.id";
//            System.out.println(" final qu = " + query);
            Query finalQuery = ses.createSQLQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get selected user assigned active tickets
    public List<Object[]> getUserAssignedActiveTicket(Session ses, int userId, byte status) {
        try {
            String query = "SELECT\n"
                    + "    `tm_tickets`.`id`\n"
                    + "    , `tm_tickets`.`status`\n"
                    + "    , `tm_tickets_has_um_user`.`tm_tickets_id`\n"
                    + "    , `tm_tickets_has_um_user`.`um_user_id`\n"
                    + "FROM\n"
                    + "    `nanobotz_issue_tracking`.`tm_tickets_has_um_user`\n"
                    + "    INNER JOIN `nanobotz_issue_tracking`.`tm_tickets` \n"
                    + "        ON (`tm_tickets_has_um_user`.`tm_tickets_id` = `tm_tickets`.`id`)\n"
                    + "WHERE (`tm_tickets`.`status` ='" + status + "'\n"
                    + "    AND `tm_tickets_has_um_user`.`um_user_id` ='" + userId + "')";

//            System.out.println(" final qu = " + query);
            Query finalQuery = ses.createSQLQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //    method for get selected user assigned complete tickets
    public List<Object[]> getUserAssignedCompleteTicket(Session ses, int userId, byte status, byte status2) {
        try {
            String query = "SELECT\n"
                    + "    `tm_tickets`.`id`\n"
                    + "    , `tm_tickets`.`status`\n"
                    + "    , `tm_tickets_has_um_user`.`tm_tickets_id`\n"
                    + "    , `tm_tickets_has_um_user`.`um_user_id`\n"
                    + "FROM\n"
                    + "    `nanobotz_issue_tracking`.`tm_tickets_has_um_user`\n"
                    + "    INNER JOIN `nanobotz_issue_tracking`.`tm_tickets` \n"
                    + "        ON (`tm_tickets_has_um_user`.`tm_tickets_id` = `tm_tickets`.`id`)\n"
                    + "WHERE (`tm_tickets`.`status` ='" + status + "'\n"
                    + "OR `tm_tickets`.`status` ='" + status2 + "'\n"
                    + "    AND `tm_tickets_has_um_user`.`um_user_id` ='" + userId + "')";

//            System.out.println(" final qu = " + query);
            Query finalQuery = ses.createSQLQuery(query);
            return finalQuery.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

    //     method for save new ticket
    public synchronized TmTickets saveTicket(Session ses, String ticketName, String ticketDescription, byte status, double totExpenses, Date created_at, Date updated_at, QmQueue selectedQueue, QmCategories category, QmSubCategories subCategory, String ticketKey, int created_by, int updated_by, UmCustomer customer,LmLocations selectedLocation) {
        try {
            TmTickets saveData = new TmTickets();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setQmCategories(category);
            saveData.setQmQueue(selectedQueue);
            saveData.setQmSubCategories(subCategory);
            saveData.setStatus(status);
            saveData.setTicketDescription(ticketDescription);
            saveData.setTicketName(ticketName);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            saveData.setTotalExpence(totExpenses);
            saveData.setTid(ticketKey);
            saveData.setUmCustomer(customer);
            saveData.setLmLocations(selectedLocation);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

}
