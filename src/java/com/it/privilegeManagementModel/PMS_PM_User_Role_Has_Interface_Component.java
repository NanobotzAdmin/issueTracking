/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.privilegeManagementModel;

import com.it.db.PmInterfaceComponent;
import com.it.db.PmUserRole;
import com.it.db.PmUserRoleHasInterfaceComponent;
import com.it.db.PmUserRoleHasInterfaceComponentId;
import com.it.db.UmUser;
import com.it.db.UmUserHasInterfaceComponent;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author JOY
 */
public class PMS_PM_User_Role_Has_Interface_Component {

    Logger logger = Logger.getLogger(this.getClass().getName());
//    method for load user role has interface component by user role id and interfce id

    public synchronized List<PmUserRoleHasInterfaceComponent> getAllUserRoleHasInterfaceComponentByUserRoleAndInterfaceId(Session ses, int userRoleId, int interfaceId) {
        try {
            Query query = ses.createQuery("FROM PmUserRoleHasInterfaceComponent PMURHIFC WHERE PMURHIFC.pmInterfaceComponent IN(SELECT PMIFC.id FROM PmInterfaceComponent PMIFC WHERE PMIFC.pmInterface='" + interfaceId + "') AND  PMURHIFC.pmUserRole='" + userRoleId + "' ");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    check user role has interface component
    public synchronized PmUserRoleHasInterfaceComponent checlUserRoleHasComponent(Session ses, int userRoleId, int compId) {
        try {
            Query query = ses.createQuery("FROM PmUserRoleHasInterfaceComponent PMURHIC WHERE PMURHIC.pmUserRole='" + userRoleId + "' AND PMURHIC.pmInterfaceComponent='" + compId + "' ");
            return (PmUserRoleHasInterfaceComponent) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    check user role has interface component
    public synchronized List<PmUserRoleHasInterfaceComponent> loadUserRoleHasComponent(Session ses, int userRoleId) {
        try {
            Query query = ses.createQuery("FROM PmUserRoleHasInterfaceComponent PMURHIC WHERE PMURHIC.pmUserRole='" + userRoleId + "'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for delete user role has interface component by user role and interface id
    public synchronized int deleteUserRoleHasInterface(Session ses, int userRoleId, int interfaceId) {
        try {


            String hql = "DELETE FROM PmUserRoleHasInterfaceComponent WHERE pmInterfaceComponent IN(SELECT PMIFC.id FROM PmInterfaceComponent PMIFC WHERE PMIFC.pmInterface= :interfaceId )  AND pmUserRole= :userRoleID ";
            Query query = ses.createQuery(hql);
            //////System.out.println(user.getUid() + " and pid: " + pid);
            query.setInteger("interfaceId", interfaceId);
            query.setInteger("userRoleID", userRoleId);
//            ////System.out.println("asdsadada"+query.executeUpdate());

            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString()); 
            e.printStackTrace();
            return 0;
        }
    }
    //         get user role and componet detail
     public synchronized PmUserRoleHasInterfaceComponent getUroleAndComponentData(Session ses, PmUserRole userRoleId, PmInterfaceComponent componentId, PmUserRoleHasInterfaceComponentId compoId) {
        try {
            Criteria cri_getUroleAndComponentData = ses.createCriteria(PmUserRoleHasInterfaceComponent.class);
            cri_getUroleAndComponentData.add(Restrictions.eq("pmUserRole", userRoleId));
            cri_getUroleAndComponentData.add(Restrictions.eq("pmInterfaceComponent", componentId));
            cri_getUroleAndComponentData.add(Restrictions.eq("id", compoId));
            return (PmUserRoleHasInterfaceComponent) cri_getUroleAndComponentData.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }

//    method for add user role has inteface component
    public synchronized PmUserRoleHasInterfaceComponent addUserRoleHasInterfaceComponent(Session ses, int urole, int component, Date createDate, Date updateDate, byte status, UmUser createdBy, UmUser updatedBy) {

        try {

            PmUserRoleHasInterfaceComponentId addComponentIdAndUserRoleId = new com.it.privilegeManagementModel.PMS_PM_User_Role_Has_Interface_Component_Id().addUserRoleHasInterfaceComponentToComposite(ses, urole, component);

            if (addComponentIdAndUserRoleId != null) {
                PmUserRole selectedPrivilage = (PmUserRole) ses.load(PmUserRole.class, addComponentIdAndUserRoleId.getPmUserRoleId());
                PmInterfaceComponent selectedComponent = (PmInterfaceComponent) ses.load(PmInterfaceComponent.class, addComponentIdAndUserRoleId.getPmInterfaceComponentId());

                PmUserRoleHasInterfaceComponent saveUserRoleHasInterfaceComponent = new PmUserRoleHasInterfaceComponent();
                saveUserRoleHasInterfaceComponent.setCreatedAt(createDate);
                saveUserRoleHasInterfaceComponent.setPmInterfaceComponent(selectedComponent);
                saveUserRoleHasInterfaceComponent.setPmUserRole(selectedPrivilage);
                saveUserRoleHasInterfaceComponent.setUmUserByCreatedBy(createdBy);
                saveUserRoleHasInterfaceComponent.setUmUserByUpdatedBy(updatedBy);
                saveUserRoleHasInterfaceComponent.setUpdatedAt(updateDate);
                saveUserRoleHasInterfaceComponent.setStatus(status);
                saveUserRoleHasInterfaceComponent.setId(addComponentIdAndUserRoleId);
                ses.save(saveUserRoleHasInterfaceComponent);
                return saveUserRoleHasInterfaceComponent;
            } else {
                return null;
            }

        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
            return null;
        }
    }
//     method for remove user role has interface component

    public synchronized PmUserRoleHasInterfaceComponent removeUserRoleHasComponent(Session ses, int userRoleId, int componentId) {
        try {
            PmUserRoleHasInterfaceComponentId addComponentIdAndUserRoleId = new com.it.privilegeManagementModel.PMS_PM_User_Role_Has_Interface_Component_Id().addUserRoleHasInterfaceComponentToComposite(ses, userRoleId, componentId);
            if (addComponentIdAndUserRoleId != null) {
                PmUserRole selectedPrivilage = (PmUserRole) ses.load(PmUserRole.class, addComponentIdAndUserRoleId.getPmUserRoleId());
                PmInterfaceComponent selectedComponent = (PmInterfaceComponent) ses.load(PmInterfaceComponent.class, addComponentIdAndUserRoleId.getPmInterfaceComponentId());

                PmUserRoleHasInterfaceComponent searchComponentDetail = new com.it.privilegeManagementModel.PMS_PM_User_Role_Has_Interface_Component().getUroleAndComponentData(ses, selectedPrivilage, selectedComponent, addComponentIdAndUserRoleId);
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

}
