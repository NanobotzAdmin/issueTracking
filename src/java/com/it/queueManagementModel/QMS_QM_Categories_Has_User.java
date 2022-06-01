/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.queueManagementModel;

import com.it.db.QmCategories;
import com.it.db.QmCategoriesHasUser;
import com.it.db.QmCategoriesHasUserId;
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
public class QMS_QM_Categories_Has_User {
      Logger logger = Logger.getLogger(this.getClass().getName());
    //method for get category has users by category id
    public synchronized List<QmCategoriesHasUser> getAllUsersByCategoryId(Session ses, int categoryId) {
        try {
            Query query = ses.createQuery("FROM QmCategoriesHasUser WHERE qmCategories ='"+categoryId+"'");
            return query.list();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
        //method for get category has user by category id and user id
    public synchronized QmCategoriesHasUser getUsersByCategoryId(Session ses, int categoryId,int userId) {
        try {
            Query query = ses.createQuery("FROM QmCategoriesHasUser WHERE qmCategories='"+categoryId+"' AND umUser='"+userId+"'");
            return (QmCategoriesHasUser) query.uniqueResult();
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
      //    method for delete category has users by category
    public synchronized int deleteCategoryHasUsersByCategoryId(Session ses, int categoryId) {
        try {
            String hql = "DELETE FROM qm_categories_has_user WHERE qm_categories_id=:categoryId";
            Query query = ses.createSQLQuery(hql);
            query.setInteger("categoryId", categoryId);
            return query.executeUpdate();
        } catch (Exception e) {
            logger.error(e.toString()); 
            e.printStackTrace();
            return 0;
        }
    }
    
     //    method for add category has user
    public synchronized QmCategoriesHasUser addCategoryHasUsers(Session ses, int categoryId, int userId,byte isActive,Date createDate, Date updateDate, int createdBy, int updatedBy) {
        try {
            QmCategoriesHasUserId addCategoryIdAndUserId = new com.it.queueManagementModel.QMS_QM_Categories_Has_User_Id().addCategoryHasUsersToComposite(ses, categoryId, userId);
            if (addCategoryIdAndUserId != null) {
                QmCategories selectedCategory = (QmCategories) ses.load(QmCategories.class, addCategoryIdAndUserId.getQmCategoriesId());
                UmUser selectedUser = (UmUser) ses.load(UmUser.class, addCategoryIdAndUserId.getUmUserId());
                QmCategoriesHasUser saveCategoryHasUser = new QmCategoriesHasUser();
                saveCategoryHasUser.setCreatedAt(createDate);
                saveCategoryHasUser.setQmCategories(selectedCategory);
                saveCategoryHasUser.setCreatedBy(createdBy);
                saveCategoryHasUser.setId(addCategoryIdAndUserId);
                saveCategoryHasUser.setStatus(isActive);
                saveCategoryHasUser.setUmUser(selectedUser);
                saveCategoryHasUser.setUpdatedAt(updateDate);
                saveCategoryHasUser.setUpdatedBy(updatedBy);
                ses.save(saveCategoryHasUser);
                return saveCategoryHasUser;
            } else {
                return null;
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
