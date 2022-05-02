/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.privilegeManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.PmInterfaceComponent;
import com.ring.db.UmUser;
import com.ring.db.UmUserHasInterfaceComponent;
import com.ring.db.UmUserHasInterfaceComponentId;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class PMS_PM_User_Has_Interface_Component {
    Logger logger = Logger.getLogger(this.getClass().getName());
//method for get user has interface components by user id
    public synchronized List<UmUserHasInterfaceComponent> getAllUserHasInterfaceComponentByUserId(Session ses, int userId) {
        try {
            Query query = ses.createQuery("FROM UmUserHasInterfaceComponent WHERE umUserByUmUserId ='"+userId+"' AND status='"+STATIC_DATA_MODEL.ACTIVE+"' ");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for get all users has interface component by user role id and interface topic id
    public synchronized List<UmUserHasInterfaceComponent> getAllUserHasInterfaceComponentByUserRoleAndTopicId(Session ses, int userRoleId, int topicId) {
        try {
            Query query = ses.createQuery("FROM UmUserHasInterfaceComponent UHIC WHERE UHIC.pmInterfaceComponent IN(SELECT PMIC.id FROM PmInterfaceComponent PMIC WHERE PMIC.pmInterface IN(SELECT PMIF.id FROM PmInterface PMIF WHERE PMIF.pmInterfaceTopic='"+topicId+"')) AND  UHIC.umUserByUmUserId IN(SELECT UMUSR.id FROM UmUser UMUSR WHERE UMUSR.pmUserRole='"+userRoleId+"' AND UMUSR.status='"+STATIC_DATA_MODEL.ACTIVE+"')");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for get all users has interface component by user role id and interface id
    public synchronized List<UmUserHasInterfaceComponent> getAllUserHasInterfaceComponentByUserRoleAndInterfaceId(Session ses, int userRoleId, int interfaceId) {
        try {
            Query query = ses.createQuery("FROM UmUserHasInterfaceComponent UHIC WHERE UHIC.pmInterfaceComponent IN(SELECT PMIC.id FROM PmInterfaceComponent PMIC WHERE PMIC.pmInterface='"+interfaceId+"') AND  UHIC.umUserByUmUserId IN(SELECT UMUSR.id FROM UmUser UMUSR WHERE UMUSR.pmUserRole='"+userRoleId+"' AND UMUSR.status='"+STATIC_DATA_MODEL.ACTIVE+"')");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for get  user has interface component by user id and interface topic id
    public synchronized List<UmUserHasInterfaceComponent> getAllUserHasInterfaceComponentByUserIdTopicId(Session ses, int user, int topicId) {
        try {
            Query query = ses.createQuery("FROM UmUserHasInterfaceComponent UHIC WHERE UHIC.pmInterfaceComponent IN(SELECT PMIC.id FROM PmInterfaceComponent PMIC WHERE PMIC.pmInterface IN(SELECT PMI.id FROM PmInterface PMI WHERE PMI.pmInterfaceTopic='"+topicId+"')) AND  UHIC.umUserByUmUserId='"+user+"' ");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for get  user has interface component by user id and interface id
    public synchronized List<UmUserHasInterfaceComponent> getAllUserHasInterfaceComponentByUserAndInterfaceId(Session ses, int user, int interfaceId) {
        try {
            Query query = ses.createQuery("FROM UmUserHasInterfaceComponent UHIC WHERE UHIC.pmInterfaceComponent IN(SELECT PMIC.id FROM PmInterfaceComponent PMIC WHERE PMIC.pmInterface='"+interfaceId+"') AND  UHIC.umUserByUmUserId='"+user+"' ");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for get all users has interface component by user role id and component id
    public synchronized List<UmUserHasInterfaceComponent> getAllUserHasInterfaceComponentByUserRoleAndComponentId(Session ses, int userRoleId, int componentId) {
        try {
            Query query = ses.createQuery("FROM UmUserHasInterfaceComponent UHIC WHERE UHIC.pmInterfaceComponent='"+componentId+"'  AND  UHIC.umUserByUmUserId IN(SELECT UMUSR.id FROM UmUser UMUSR WHERE UMUSR.pmUserRole='"+userRoleId+"' AND UMUSR.status='"+STATIC_DATA_MODEL.ACTIVE+"')");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for getll all user has interface component by User id And component id
    public synchronized UmUserHasInterfaceComponent getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(Session ses, int userId,int componentId) {
        try {
            Query query = ses.createQuery("FROM UmUserHasInterfaceComponent UHIC WHERE UHIC.umUserByUmUserId ='"+userId+"' and UHIC.pmInterfaceComponent ='"+componentId+"' " );
            return (UmUserHasInterfaceComponent) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for delete user has interface component
    public synchronized int deleteUserHasInterfaceComponentByUserRoleId(Session ses, int userRoleId, int componentId) {
        try {
            String hql = "DELETE FROM um_user_has_interface_component WHERE pm_interface_component_id= :componentId  AND um_user_id IN\n"
                    + "(SELECT id FROM um_user WHERE pm_user_role_id= :userRoleID and status='"+STATIC_DATA_MODEL.ACTIVE+"' )";
            Query query = ses.createSQLQuery(hql);
            query.setInteger("componentId", componentId);
            query.setInteger("userRoleID", userRoleId);
            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString()); 
            e.printStackTrace();
            return 0;
        }
    }
//    method for delete user has interface component
    public synchronized int deleteUserHasInterfaceComponentByUserId(Session ses, int userId, int componentId) {
        try {
            String hql = "DELETE FROM um_user_has_interface_component WHERE pm_interface_component_id=:componentId  AND um_user_id=:userId ";
            Query query = ses.createSQLQuery(hql);
            query.setInteger("componentId", componentId);
            query.setInteger("userId", userId);
            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString()); 
            e.printStackTrace();
            return 0;
        }
    }
//    method for user has component by user role id and interface topic id
    public synchronized List<Object[]> searchusersHasComponenntsByUserRoleIdAndInterfaceTopicId(Session ses, int topicId,int userRoleId) {
        try {
        String hql = "FROM UmUserHasInterfaceComponent UHIC WHERE UHIC.pmInterfaceComponent IN(SELECT PMIC.id FROM PmInterfaceComponent PMIC WHERE PMIC.pmInterface IN(SELECT PMIF.id FROM PmInterface PMIF WHERE PMIF.pmInterfaceTopic='"+topicId+"')) AND  UHIC.umUserByUmUserId IN(SELECT UMUSR.id FROM UmUser UMUSR WHERE UMUSR.pmUserRole='"+userRoleId+"' AND UMUSR.status='"+STATIC_DATA_MODEL.ACTIVE+"')";
            
            Query query = ses.createQuery(hql);
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for user has component by user  id and interface topic id
    public synchronized List<Object[]> searchusersHasComponenntsByUserIdAndInterfaceTopicId(Session ses, int topicId,int userId) {
        try {
        String hql = "FROM UmUserHasInterfaceComponent UHIC WHERE UHIC.pmInterfaceComponent IN(SELECT PMIC.id FROM PmInterfaceComponent PMIC WHERE PMIC.pmInterface IN(SELECT PMIF.id FROM PmInterface PMIF WHERE PMIF.pmInterfaceTopic='"+topicId+"')) AND  UHIC.umUserByUmUserId='"+userId+"'";
            
            Query query = ses.createQuery(hql);
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    
      public synchronized UmUserHasInterfaceComponent removeUserHasComponent(Session ses, int userId, int componentId) {
        try {

            UmUserHasInterfaceComponentId addComponentIdAndUserId =  new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component_Id().addUserHasInterfaceComponentToComposite(ses, userId, componentId);

            if (addComponentIdAndUserId != null) {
                UmUser selectedUser = (UmUser) ses.load(UmUser.class, addComponentIdAndUserId.getUmUserId());
                PmInterfaceComponent selectedComponent = (PmInterfaceComponent) ses.load(PmInterfaceComponent.class, addComponentIdAndUserId.getPmInterfaceComponentId());

                UmUserHasInterfaceComponent searchComponentDetail = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component().getAllUserHasInterfaceComponentByUserIdAndComponentIdUniq(ses, selectedUser.getId(), selectedComponent.getId());    

                if (searchComponentDetail != null) {
                    ses.delete(searchComponentDetail);
                    return searchComponentDetail;

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
    
//    method for add interface component to user
    public synchronized UmUserHasInterfaceComponent addUserHasInterfaceComponent(Session ses, int userId, int component, Date createDate, Date updateDate,byte status, UmUser createdBy, UmUser updatedBy) {

        try {

            UmUserHasInterfaceComponentId addComponentIdAndUserId = new com.ring.privilegeManagementModel.PMS_PM_User_Has_Interface_Component_Id().addUserHasInterfaceComponentToComposite(ses, userId, component);

            if (addComponentIdAndUserId != null) {
                UmUser selectedUser = (UmUser) ses.load(UmUser.class, addComponentIdAndUserId.getUmUserId());
                PmInterfaceComponent selectedComponent = (PmInterfaceComponent) ses.load(PmInterfaceComponent.class, addComponentIdAndUserId.getPmInterfaceComponentId());

                UmUserHasInterfaceComponent saveUserHasInterfaceComponent = new UmUserHasInterfaceComponent();
                saveUserHasInterfaceComponent.setCreatedAt(createDate);
                saveUserHasInterfaceComponent.setPmInterfaceComponent(selectedComponent);
                saveUserHasInterfaceComponent.setStatus(status);
                saveUserHasInterfaceComponent.setUmUserByUmUserId(selectedUser);
                saveUserHasInterfaceComponent.setUmUserByCreatedBy(createdBy);
                saveUserHasInterfaceComponent.setUmUserByUpdatedBy(updatedBy);
                saveUserHasInterfaceComponent.setUpdatedAt(updateDate);
                saveUserHasInterfaceComponent.setId(addComponentIdAndUserId);
                ses.save(saveUserHasInterfaceComponent);
                return saveUserHasInterfaceComponent;
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
