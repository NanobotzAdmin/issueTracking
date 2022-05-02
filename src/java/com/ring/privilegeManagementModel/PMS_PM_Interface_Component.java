/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.privilegeManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.PmInterface;
import com.ring.db.PmInterfaceComponent;
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
public class PMS_PM_Interface_Component {

    Logger logger = Logger.getLogger(this.getClass().getName());
//    method for get all active interface components 
    public synchronized List<PmInterfaceComponent> getAllInterfaceComponents(Session ses, byte status) {
        try {
            Query query = ses.createQuery("FROM PmInterfaceComponent WHERE status='"+status+"' ");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for get interface components by interface id
    public synchronized List<PmInterfaceComponent> getAllInterfaceComponentsByInterface(Session ses, int interfaceId) {
        try {
            Query query = ses.createQuery("FROM PmInterfaceComponent WHERE pmInterface ='" + interfaceId + "' and status='"+STATIC_DATA_MODEL.PMACTIVE+"' ");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for get interface component by topic id
    public synchronized List<PmInterfaceComponent> getComponentByInterfaceTopic(Session ses,int interfaceTopic) {
        try {
            Query query = ses.createQuery("FROM PmInterfaceComponent PMIFC WHERE PMIFC.pmInterface IN(SELECT PMIF.id FROM PmInterface PMIF WHERE PMIF.pmInterfaceTopic='"+interfaceTopic+"' )");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }

    }
//    method for check interface componen name exist
    public synchronized PmInterfaceComponent searchComponentIdExit(Session ses, String componentId) {
        try {
            Query query = ses.createQuery("FROM PmInterfaceComponent PMIFC Where PMIFC.componentId ='" + componentId + "' ");
            return (PmInterfaceComponent) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    
//    method for save interface component
    public synchronized PmInterfaceComponent saveInterfaceComponent(Session ses, String component_name, String componentId,Date created_at, Date updated_at,byte status,PmInterface interfaceId,UmUser createdBy,UmUser updatedBy) {
        try {
            PmInterfaceComponent saveData = new PmInterfaceComponent();
            saveData.setComponentId(componentId);
            saveData.setComponentName(component_name);
            saveData.setCreatedAt(created_at);
            saveData.setPmInterface(interfaceId);
            saveData.setStatus(status);
            saveData.setUmUserByCreatedBy(createdBy);
            saveData.setUmUserByUpdatedBy(updatedBy);
            saveData.setUpdatedAt(updated_at);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
//    Method for update interface component
    public synchronized PmInterfaceComponent updateInterfaceComponent(Session ses, String component_name, String componentID, Date updated_at,byte Status, PmInterface selectedInterface,UmUser updated_by, PmInterfaceComponent selectedComponent) {
        try {
            selectedComponent.setComponentName(component_name);
            selectedComponent.setComponentId(componentID);
            selectedComponent.setStatus(Status);
            selectedComponent.setUpdatedAt(updated_at);
            selectedComponent.setUmUserByUpdatedBy(updated_by);
            ses.update(selectedComponent);
            return selectedComponent;
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
            return null;
        }
    }
}
