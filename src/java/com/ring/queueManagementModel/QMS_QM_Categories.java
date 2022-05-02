/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.queueManagementModel;

import com.ring.configurationModel.STATIC_DATA_MODEL;
import com.ring.db.QmCategories;
import com.ring.db.QmQueue;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class QMS_QM_Categories {
         Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active Categories
 public List<QmCategories> getAllCategoriesByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM QmCategories");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM QmCategories QMSC Where QMSC.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
      //    method for check Category name exists
 public QmCategories checkNameExists(Session ses, String categoryName) {
        try {
                Query query = ses.createQuery("FROM QmCategories QMSC Where QMSC.categoryName ='" + categoryName + "'");
                return (QmCategories) query.uniqueResult();
            
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
      //    method for get Category by queue id
 public List<QmCategories> getCategoryByQueueId(Session ses, int queueId) {
        try {
                Query query = ses.createQuery("FROM QmCategories QMSC Where QMSC.qmQueue ='" + queueId + "'");
                return query.list();
            
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
   //     method for save category
     public synchronized QmCategories saveCategory(Session ses, String categoryName, String categoryDescription,byte isActive,Date created_at,Date updated_at,QmQueue selectedQueue,int created_by, int updated_by) {
        try {
            QmCategories saveData = new QmCategories();
            saveData.setCategoryName(categoryName);
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setDescription(categoryDescription);
            saveData.setStatus(isActive);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            saveData.setQmQueue(selectedQueue);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
         //     method for update Category
     public synchronized QmCategories updateCategory(Session ses, String categoryName, String categoryDescription,byte isActive,Date updated_at,QmCategories selectedCategory,QmQueue selectedQueue,int updated_by) {
        try {    
            selectedCategory.setCategoryName(categoryName);
            selectedCategory.setDescription(categoryDescription);
            selectedCategory.setStatus(isActive);
            selectedCategory.setUpdatedAt(updated_at);
            selectedCategory.setUpdatedBy(updated_by);
            selectedCategory.setQmQueue(selectedQueue);
            ses.update(selectedCategory);
            return selectedCategory;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }

}
