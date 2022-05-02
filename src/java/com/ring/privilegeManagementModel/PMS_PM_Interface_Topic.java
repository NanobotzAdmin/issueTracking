/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.privilegeManagementModel;

import com.ring.db.PmInterfaceTopic;
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
public class PMS_PM_Interface_Topic {
     Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active interface topics
    public  List<PmInterfaceTopic> getAllActiveInterfaceTopics(Session ses,byte status) {
        try {
            Query query = ses.createQuery("FROM PmInterfaceTopic PMIT Where PMIT.status ='" + status + "'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for check interface topic name esixt
     public synchronized PmInterfaceTopic searchInterfaceGroupNameExit(Session ses, String groupName) {
        try {
            Query query = ses.createQuery("FROM PmInterfaceTopic PMIT Where PMIT.topicName ='" + groupName + "' ");
            return (PmInterfaceTopic) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
     
//     method for save interface topic
     public synchronized PmInterfaceTopic saveInterfaceGroup(Session ses, String interface_group_name, String menu_icon,String section,Date created_at,Date updated_at,byte status,UmUser created_by, UmUser updated_by) {
        try {
            PmInterfaceTopic saveData = new PmInterfaceTopic();
            saveData.setCreatedAt(created_at);
            saveData.setTopicName(interface_group_name);
            saveData.setMenuIcon(menu_icon);
            saveData.setSectionClass(section);
            saveData.setStatus(status);
            saveData.setUmUserByCreatedBy(created_by);
            saveData.setUmUserByUpdatedBy(updated_by);
            saveData.setUpdatedAt(updated_at);
            ses.save(saveData);
            return saveData;

        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
//     method for update interface topic
      public synchronized PmInterfaceTopic updateInterfaceGroup(Session ses, String interface_group_name, String menu_icon,String section,Date updated_at,byte status,UmUser updated_by,PmInterfaceTopic selectedTopic) {
        try {
            selectedTopic.setTopicName(interface_group_name);
            selectedTopic.setMenuIcon(menu_icon);
            selectedTopic.setUpdatedAt(updated_at);
            selectedTopic.setUmUserByUpdatedBy(updated_by);
            selectedTopic.setSectionClass(section);
            ses.update(selectedTopic);
            return selectedTopic;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
     
}
