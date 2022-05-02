/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.customerManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.LmLocations;
import com.ring.db.PmUserRole;
import com.ring.db.UmCustomer;
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
public class CMS_UM_Customer {

    Logger logger = Logger.getLogger(this.getClass().getName());

    //    method for get all Customers by status
    public List<UmCustomer> getAllCustomersByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM UmCustomer");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM UmCustomer CMSCUS Where CMSCUS.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for check customer NIC Exists
    public UmCustomer checkCustomerNic(Session ses, String nic) {
        try {
            Query query = ses.createQuery("FROM UmCustomer CMSCUS Where CMSCUS.nic ='" + nic + "'");
            return (UmCustomer) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for check customer email Exists
    public UmCustomer checkCustomerEmail(Session ses, String email) {
        try {
            Query query = ses.createQuery("FROM UmCustomer CMSCUS Where CMSCUS.emailAddress ='" + email + "'");
            return (UmCustomer) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for check customer name
    public UmCustomer checkCustomerName(Session ses, String name) {
        try {
            Query query = ses.createQuery("FROM UmCustomer CMSCUS Where CMSCUS.customerName ='" + name + "'");
            return (UmCustomer) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for check customer phone number
    public UmCustomer checkCustomerPhoneNumber(Session ses, String number) {
        try {
            Query query = ses.createQuery("FROM UmCustomer CMSCUS Where CMSCUS.mobileNumber ='" + number + "'");
            return (UmCustomer) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }

    //     method for save new customer
    public synchronized UmCustomer saveNewCustomer(Session ses, String customerName, String address, byte status, String mobile, byte isVerified, int otp, String nic, String email, Date created_at, Date updated_at, LmLocations location, int created_by, int updated_by) {
        try {
            UmCustomer saveData = new UmCustomer();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setCustomerName(customerName);
            saveData.setAddress(address);
            saveData.setEmailAddress(email);
            saveData.setIsVerified(isVerified);
            saveData.setLmLocations(location);
            saveData.setMobileNumber(mobile);
            saveData.setStatus(status);
            saveData.setNic(nic);
            saveData.setOtp(otp);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
     //     method for update customer
    public synchronized UmCustomer updateCustomer(Session ses, String customerName, String address, byte status, String mobile, byte isVerified, int otp, String nic, String email,Date updated_at, LmLocations location,UmCustomer selectedCustomer, int created_by, int updated_by) {
        try {
            selectedCustomer.setCustomerName(customerName);
            selectedCustomer.setAddress(address);
            selectedCustomer.setEmailAddress(email);
            selectedCustomer.setIsVerified(isVerified);
            selectedCustomer.setLmLocations(location);
            selectedCustomer.setMobileNumber(mobile);
            selectedCustomer.setStatus(status);
            selectedCustomer.setNic(nic);
            selectedCustomer.setOtp(otp);
            selectedCustomer.setUpdatedAt(updated_at);
            selectedCustomer.setUpdatedBy(updated_by);
            ses.save(selectedCustomer);
            return selectedCustomer;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    
    
    
}
