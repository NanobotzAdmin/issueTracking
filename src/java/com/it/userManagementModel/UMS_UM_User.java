/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.userManagementModel;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.PmUserRole;
import com.it.db.RcasQuestion;
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
public class UMS_UM_User {
    
    Logger logger = Logger.getLogger(this.getClass().getName());

    //    method for get all Users by status
    public List<UmUser> getAllUsersByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM UmUser");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM UmUser UMSUSR Where UMSUSR.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for get all Users by status and alphe
    public List<UmUser> getAllUsersByStatusAndAsc(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM UmUser");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM UmUser UMSUSR Where UMSUSR.status ='" + status + "' ORDER BY UMSUSR.firstName ASC");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }

    //    method for get user Name has user
    public UmUser getUserNameHasUser(Session ses, String userName) {
        try {
            Query query = ses.createQuery("FROM UmUser UMSUSR Where UMSUSR.userName ='" + userName + "' OR UMSUSR.remark2='"+userName+"' OR UMSUSR.emailAddress='"+userName+"'");
            return (UmUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for get user by Id
    public UmUser getUserById(Session ses, int id) {
        try {
            Query query = ses.createQuery("FROM UmUser UMSUSR Where UMSUSR.id ='" + id + "'");
            return (UmUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for check NIC Exists
    public UmUser checkNic(Session ses, String NIC) {
        try {
            Query query = ses.createQuery("FROM UmUser UMSUSR Where UMSUSR.nicOrPassport ='" + NIC + "'");
            return (UmUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for check Email Exists
    public UmUser checkEmail(Session ses, String email) {
        try {
            Query query = ses.createQuery("FROM UmUser UMSUSR Where UMSUSR.emailAddress ='" + email + "'");
            return (UmUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }
    //    method for check employe Id
    public UmUser checkEmployeeId(Session ses, String employeeId) {
        try {
            Query query = ses.createQuery("FROM UmUser UMSUSR Where UMSUSR.remark2 ='" + employeeId + "'");
            return (UmUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            e.printStackTrace();
            return null;
        }
    }

    //    method for get users by user role and status
    public synchronized List<UmUser> searchUsersByStatusAndUserRole(Session ses, int userRoleId, byte status) {
        
        try {
            String query = "";
            query = "From UmUser UMUSR where UMUSR.status is not null";
            if (userRoleId > 0) {
                query += " and UMUSR.pmUserRole='" + userRoleId + "' ";
            }
            if (status > 0) {
                query += " and UMUSR.status='" + status + "' ";
            }
            Query searchUsers = ses.createQuery(query);
            return searchUsers.list();
        } catch (Exception e) {
            return null;
        }
    }
    //     method for save new user
    public synchronized UmUser saveNewUser(Session ses, String firstName, String lastName, byte status, String userName, String password, String nic, Date DOB, String mobile, String email, byte gender, String maritualStatus, String EID,Date created_at, Date updated_at, PmUserRole userRole, int created_by, int updated_by) {
        try {
            UmUser saveData = new UmUser();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setDateOfBirth(DOB);
            saveData.setEmailAddress(email);
            saveData.setFirstName(firstName);
            saveData.setGender(gender);
            saveData.setLastName(lastName);
            saveData.setMaritialStatus(maritualStatus);
            saveData.setMobileNumber(mobile);
            saveData.setNicOrPassport(nic);
            saveData.setPassword(password);
            saveData.setPmUserRole(userRole);
            saveData.setStatus(status);
            saveData.setUserName(userName);
            saveData.setRemark2(EID);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
    //     method for update  user profile details
    public synchronized UmUser updateUserProfile(Session ses, String firstName, String lastName, byte status, String nic, Date DOB, String mobile, String email, byte gender, String maritualStatus, String EID,Date updated_at, PmUserRole userRole, int updated_by,UmUser selectedUser) {
        try {
            
            selectedUser.setDateOfBirth(DOB);
            selectedUser.setEmailAddress(email);
            selectedUser.setFirstName(firstName);
            selectedUser.setGender(gender);
            selectedUser.setLastName(lastName);
            selectedUser.setMaritialStatus(maritualStatus);
            selectedUser.setMobileNumber(mobile);
            selectedUser.setNicOrPassport(nic);
            selectedUser.setPmUserRole(userRole);
            selectedUser.setStatus(status);
            selectedUser.setRemark2(EID);
            selectedUser.setUpdatedAt(updated_at);
            selectedUser.setUpdatedBy(updated_by);
            ses.save(selectedUser);
            return selectedUser;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
