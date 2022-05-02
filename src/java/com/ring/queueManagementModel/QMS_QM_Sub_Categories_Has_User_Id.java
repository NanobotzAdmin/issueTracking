/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.queueManagementModel;

import com.ring.db.QmSubCategoriesHasUserId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class QMS_QM_Sub_Categories_Has_User_Id {
                    Logger logger = Logger.getLogger(this.getClass().getName());
//       method for add sub category has users to composide table
    public synchronized QmSubCategoriesHasUserId addSubCategoryHasUsersToComposite(Session ses, int subCategoryId, int userId) {
        try {
            QmSubCategoriesHasUserId saveSubCategoryHasUsersToComposite = new QmSubCategoriesHasUserId();
            saveSubCategoryHasUsersToComposite.setQmSubCategoriesId(subCategoryId);
            saveSubCategoryHasUsersToComposite.setUmUserId(userId);
            return saveSubCategoryHasUsersToComposite;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
