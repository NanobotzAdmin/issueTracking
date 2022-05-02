/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.ring.queueManagementModel;

import com.ring.db.QmCategoriesHasUserId;
import org.apache.log4j.Logger;
import org.hibernate.Session;

/**
 *
 * @author JOY
 */
public class QMS_QM_Categories_Has_User_Id {
                Logger logger = Logger.getLogger(this.getClass().getName());
//       method for add category has users to composide table
    public synchronized QmCategoriesHasUserId addCategoryHasUsersToComposite(Session ses, int categoryId, int userId) {
        try {
            QmCategoriesHasUserId saveCategoryHasUsersToComposite = new QmCategoriesHasUserId();
            saveCategoryHasUsersToComposite.setQmCategoriesId(categoryId);
            saveCategoryHasUsersToComposite.setUmUserId(userId);
            return saveCategoryHasUsersToComposite;
        } catch (Exception e) {
            logger.error(e.toString());
            return null;
        }
    }
}
