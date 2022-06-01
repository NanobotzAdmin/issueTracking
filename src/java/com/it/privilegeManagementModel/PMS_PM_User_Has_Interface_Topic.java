/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.privilegeManagementModel;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.PmInterfaceTopic;
import com.it.db.UmUser;
import com.it.db.UmUserHasInterfaceTopic;
import com.it.db.UmUserHasInterfaceTopicId;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class PMS_PM_User_Has_Interface_Topic {
    Logger logger = Logger.getLogger(this.getClass().getName());
    
//    method for check user has interface top
    public synchronized UmUserHasInterfaceTopic getAllInterfacetopicAndUser(Session ses, int user, int interfaceTopic) {
        Query query = ses.createQuery("FROM UmUserHasInterfaceTopic UMUHIFT WHERE UMUHIFT.umUserByUmUserId='" + user + "' and UMUHIFT.pmInterfaceTopic='" + interfaceTopic + "'");
        return (UmUserHasInterfaceTopic) query.uniqueResult();
    }
//    method for get user has interface topics
    public synchronized List<UmUserHasInterfaceTopic> getAllInterfacetopicByUser(Session ses, int user) {
        Query query = ses.createQuery("FROM UmUserHasInterfaceTopic UMUHIFT WHERE UMUHIFT.umUserByUmUserId='" + user + "'");
        return query.list();
    }
//    method for delete user has interface topic details by user role id
     public synchronized int deleteInterfaceTopicHasUserByUserRoleIdAndTopicId(Session ses, int userRoleId, int topicId) {
        try {
            String hql = "DELETE FROM UmUserHasInterfaceTopic WHERE pmInterfaceTopic =:topicId AND umUserByUmUserId IN(SELECT id FROM UmUser WHERE pmUserRole=:userRoleId and status='"+STATIC_DATA_MODEL.ACTIVE+"' )";
            Query query = ses.createQuery(hql);
            query.setInteger("userRoleId", userRoleId);
            query.setInteger("topicId", topicId);
            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return 0;
        }
    }
//    method for delete user has interface topic details by topic id
     public synchronized int deleteInterfaceTopicHasUserByUserAndTopicId(Session ses, int userId, int topicId) {
        try {
            String hql = "DELETE FROM UmUserHasInterfaceTopic WHERE pmInterfaceTopic =:topicId AND umUserByUmUserId=:userId";
            Query query = ses.createQuery(hql);
            query.setInteger("userId", userId);
            query.setInteger("topicId", topicId);
            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return 0;
        }
    }
     //    method for delete user has interface topic details by topic id and User id
     public synchronized UmUserHasInterfaceTopic removeInterfaceTopicHasUser(Session ses, int userId, int interfaceTopic) {
        try {

            UmUserHasInterfaceTopicId addCompositeKey = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic_Id().addUserHasInterfaceComponentToComposite(ses, userId, interfaceTopic);

            if (addCompositeKey != null) {
                 UmUser usr = (UmUser) ses.load(UmUser.class, addCompositeKey.getUmUserId());
                PmInterfaceTopic topic = (PmInterfaceTopic) ses.load(PmInterfaceTopic.class, addCompositeKey.getPmInterfaceTopicId());

                UmUserHasInterfaceTopic removeUserHasInterfaceTopic = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic().getAllInterfacetopicAndUser(ses, usr.getId(), topic.getId()); 

                if (removeUserHasInterfaceTopic != null) {
                    ses.delete(removeUserHasInterfaceTopic);
                    return removeUserHasInterfaceTopic;

                } else {
                    return null;
                }
            } else {
                return null;
            }
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    
//    method for add interface top to user
    public synchronized UmUserHasInterfaceTopic saveInterfacetopicHasUser(Session ses, int user, int interfaceTopic,byte status, int position, Date createdDate, Date UpdatedDate, UmUser createdBy, UmUser updatedBy) {

        try {
            UmUserHasInterfaceTopicId addCompositeKey = new com.it.privilegeManagementModel.PMS_PM_User_Has_Interface_Topic_Id().addUserHasInterfaceComponentToComposite(ses, user, interfaceTopic);

//                ////System.out.println(addCompositeKey.getUmUserMi7Id());
            if (addCompositeKey != null) {

                UmUser usr = (UmUser) ses.load(UmUser.class, addCompositeKey.getUmUserId());
                PmInterfaceTopic topic = (PmInterfaceTopic) ses.load(PmInterfaceTopic.class, addCompositeKey.getPmInterfaceTopicId());

                UmUserHasInterfaceTopic saveData = new UmUserHasInterfaceTopic();
                saveData.setId(addCompositeKey);
                saveData.setPmInterfaceTopic(topic);
                saveData.setUmUserByUmUserId(usr);
                saveData.setStatus(status);
                saveData.setPositionNumber(position);
                saveData.setCreatedAt(createdDate);
                saveData.setUpdatedAt(UpdatedDate);
                saveData.setUmUserByCreatedBy(createdBy);
                saveData.setUmUserByUpdatedBy(updatedBy);
                ses.save(saveData);
                return saveData;

            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
            return null;
        }
    }
}
