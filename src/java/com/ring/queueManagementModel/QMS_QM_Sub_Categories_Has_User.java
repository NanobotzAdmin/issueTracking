/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.queueManagementModel;

import com.ring.db.QmSubCategories;
import com.ring.db.QmSubCategoriesHasUser;
import com.ring.db.QmSubCategoriesHasUserId;
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
public class QMS_QM_Sub_Categories_Has_User {
     Logger logger = Logger.getLogger(this.getClass().getName());
    //method for get sub category has users by sub category id
    public synchronized List<QmSubCategoriesHasUser> getAllUsersBySubCategoryId(Session ses, int subCategoryId) {
        try {
            Query query = ses.createQuery("FROM QmSubCategoriesHasUser WHERE qmSubCategories ='"+subCategoryId+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
        //method for get sub category has user by sub category id and user id
    public synchronized QmSubCategoriesHasUser getUsersBySubCategoryId(Session ses, int subCategoryId,int userId) {
        try {
            Query query = ses.createQuery("FROM QmSubCategoriesHasUser WHERE qmSubCategories='"+subCategoryId+"' AND umUser='"+userId+"'");
            return (QmSubCategoriesHasUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
          //    method for delete sub category has users by sub category
    public synchronized int deleteSubCategoryHasUsersBySubCategoryId(Session ses, int subCategoryId) {
        try {
            String hql = "DELETE FROM qm_sub_categories_has_user WHERE qm_sub_categories_id=:subCategoryId";
            Query query = ses.createSQLQuery(hql);
            query.setInteger("subCategoryId", subCategoryId);
            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString()); 
            e.printStackTrace();
            return 0;
        }
    }
    
     //    method for add sub category has user
    public synchronized QmSubCategoriesHasUser addSubCategoryHasUsers(Session ses, int subCategoryId, int userId,byte isActive,Date createDate, Date updateDate, int createdBy, int updatedBy) {
        try {
            QmSubCategoriesHasUserId addSubCategoryIdAndUserId = new com.ring.queueManagementModel.QMS_QM_Sub_Categories_Has_User_Id().addSubCategoryHasUsersToComposite(ses, subCategoryId, userId);
            if (addSubCategoryIdAndUserId != null) {
                QmSubCategories selectedSubCategory = (QmSubCategories) ses.load(QmSubCategories.class, addSubCategoryIdAndUserId.getQmSubCategoriesId());
                UmUser selectedUser = (UmUser) ses.load(UmUser.class, addSubCategoryIdAndUserId.getUmUserId());
                QmSubCategoriesHasUser saveSubCategoryHasUser = new QmSubCategoriesHasUser();
                saveSubCategoryHasUser.setCreatedAt(createDate);
                saveSubCategoryHasUser.setCreatedBy(createdBy);
                saveSubCategoryHasUser.setQmSubCategories(selectedSubCategory);
                saveSubCategoryHasUser.setId(addSubCategoryIdAndUserId);
                saveSubCategoryHasUser.setStatus(isActive);
                saveSubCategoryHasUser.setUmUser(selectedUser);
                saveSubCategoryHasUser.setUpdatedAt(updateDate);
                saveSubCategoryHasUser.setUpdatedBy(updatedBy);
                ses.save(saveSubCategoryHasUser);
                return saveSubCategoryHasUser;
            } else {
                return null;
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
