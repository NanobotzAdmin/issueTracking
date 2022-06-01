/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.privilegeManagementModel;

import com.it.db.PmInterface;
import com.it.db.PmInterfaceTopic;
import com.it.db.UmUser;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class PMS_PM_Interface {
      Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active interfaces
    public  List<PmInterface> getAllActiveInterfaces(Session ses,byte status) {
        try {
            Query query = ses.createQuery("FROM PmInterface PMI Where PMI.status ='" + status + "'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
     //    method for get interfaces by topic id
    public  List<PmInterface> getAllInterfacesByTopic(Session ses,byte status,int topicId) {
        try {
            Query query = ses.createQuery("FROM PmInterface PMI Where PMI.status ='" + status + "' AND PMI.pmInterfaceTopic='"+topicId+"' ");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
//    method for check interface name exists
    public synchronized PmInterface searchInterfaceNameExit(Session ses, String interfaceName) {
        try {
            Query query = ses.createQuery("FROM PmInterface PMI Where PMI.interfaceName ='" + interfaceName + "' ");
            return (PmInterface) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
        
//    method for save interface
    public synchronized PmInterface saveInterface(Session ses, String interface_name, String path,String icon_class,String title_class,Date created_at,Date updated_at,byte status,PmInterfaceTopic interfaceGroup, UmUser created_by, UmUser updated_by) {

        try {
            
            PmInterface saveData = new PmInterface();
            saveData.setCreatedAt(created_at);
            saveData.setIconClass(icon_class);
            saveData.setInterfaceName(interface_name);
            saveData.setPath(path);
            saveData.setPmInterfaceTopic(interfaceGroup);
            saveData.setStatus(status);
            saveData.setTileClass(title_class);
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
//    method for update interface
     public synchronized PmInterface updateInterface(Session ses, String interface_name, String path,String icon_class,String title_class,Date updated_at,byte status, PmInterfaceTopic interfaceGroup, UmUser updated_by,PmInterface selectedInterface) {
        try {
            selectedInterface.setInterfaceName(interface_name);
            selectedInterface.setPath(path);
            selectedInterface.setPmInterfaceTopic(interfaceGroup);
            selectedInterface.setIconClass(icon_class);
            selectedInterface.setTileClass(title_class);
            selectedInterface.setUmUserByUpdatedBy(updated_by);
            selectedInterface.setStatus(status);
            selectedInterface.setUpdatedAt(updated_at);
            ses.update(selectedInterface);
            return selectedInterface;
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.toString());
            return null;
        }
    }
    
    
}
