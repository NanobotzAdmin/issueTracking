/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.it.queueManagementModel;

import com.it.configurationModel.STATIC_DATA_MODEL;
import com.it.db.QmCategories;
import com.it.db.QmSubCategories;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class QMS_QM_Sub_Categories {
         Logger logger = Logger.getLogger(this.getClass().getName());
     
     //    method for get all active Sub Categories
 public List<QmSubCategories> getAllSubCategoriesByStatus(Session ses, byte status) {
        try {
            if (status == STATIC_DATA_MODEL.PMALL) {
                Query query = ses.createQuery("FROM QmSubCategories");
                return query.list();
            } else {
                Query query = ses.createQuery("FROM QmSubCategories QMSSC Where QMSSC.status ='" + status + "'");
                return query.list();
            }
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
      //    method for check Sub Category name exists
 public QmSubCategories checkNameExists(Session ses, String subCategoryName) {
        try {
                Query query = ses.createQuery("FROM QmSubCategories QMSSC Where QMSSC.subCategoryName ='" + subCategoryName + "'");
                return (QmSubCategories) query.uniqueResult();
            
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
      //    method for get Sub Category by category id
 public List<QmSubCategories> getSubCategoryBYCategoryId(Session ses, int categoryId) {
        try {
                Query query = ses.createQuery("FROM QmSubCategories QMSSC Where QMSSC.qmCategories ='" + categoryId + "'");
                return query.list();
            
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
   //     method for save sub category
     public synchronized QmSubCategories saveSubCategory(Session ses, String subCategoryName, String subCategoryDescription,byte isActive,Date created_at,Date updated_at,QmCategories selectedCategory,int created_by, int updated_by) {
        try {
            QmSubCategories saveData = new QmSubCategories();
            saveData.setCreatedAt(created_at);
            saveData.setCreatedBy(created_by);
            saveData.setDescription(subCategoryDescription);
            saveData.setStatus(isActive);
            saveData.setSubCategoryName(subCategoryName);
            saveData.setUpdatedAt(updated_at);
            saveData.setUpdatedBy(updated_by);
            saveData.setQmCategories(selectedCategory);
            ses.save(saveData);
            return saveData;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
         //     method for update sub Category
     public synchronized QmSubCategories updateSubCategory(Session ses, String subCategoryName, String subCategoryDescription,byte isActive,Date updated_at,QmSubCategories selectedSubCategory,QmCategories selectedCategory,int updated_by) {
        try {
            selectedSubCategory.setDescription(subCategoryDescription);
            selectedSubCategory.setStatus(isActive);
            selectedSubCategory.setSubCategoryName(subCategoryName);
            selectedSubCategory.setUpdatedAt(updated_at);
            selectedSubCategory.setUpdatedBy(updated_by);
            selectedSubCategory.setQmCategories(selectedCategory);
            ses.update(selectedSubCategory);
            return selectedSubCategory;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
