package com.it.db;
// Generated May 31, 2022 9:18:16 PM by Hibernate Tools 4.3.1


import java.util.Date;

/**
 * QmQueueHasCategories generated by hbm2java
 */
public class QmQueueHasCategories  implements java.io.Serializable {


     private QmQueueHasCategoriesId id;
     private QmCategories qmCategories;
     private QmQueue qmQueue;
     private Date createdAt;
     private Date updatedAt;
     private Byte status;
     private String remark1;
     private String remark2;
     private int createdBy;
     private int updatedBy;

    public QmQueueHasCategories() {
    }

	
    public QmQueueHasCategories(QmQueueHasCategoriesId id, QmCategories qmCategories, QmQueue qmQueue, int createdBy, int updatedBy) {
        this.id = id;
        this.qmCategories = qmCategories;
        this.qmQueue = qmQueue;
        this.createdBy = createdBy;
        this.updatedBy = updatedBy;
    }
    public QmQueueHasCategories(QmQueueHasCategoriesId id, QmCategories qmCategories, QmQueue qmQueue, Date createdAt, Date updatedAt, Byte status, String remark1, String remark2, int createdBy, int updatedBy) {
       this.id = id;
       this.qmCategories = qmCategories;
       this.qmQueue = qmQueue;
       this.createdAt = createdAt;
       this.updatedAt = updatedAt;
       this.status = status;
       this.remark1 = remark1;
       this.remark2 = remark2;
       this.createdBy = createdBy;
       this.updatedBy = updatedBy;
    }
   
    public QmQueueHasCategoriesId getId() {
        return this.id;
    }
    
    public void setId(QmQueueHasCategoriesId id) {
        this.id = id;
    }
    public QmCategories getQmCategories() {
        return this.qmCategories;
    }
    
    public void setQmCategories(QmCategories qmCategories) {
        this.qmCategories = qmCategories;
    }
    public QmQueue getQmQueue() {
        return this.qmQueue;
    }
    
    public void setQmQueue(QmQueue qmQueue) {
        this.qmQueue = qmQueue;
    }
    public Date getCreatedAt() {
        return this.createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    public Date getUpdatedAt() {
        return this.updatedAt;
    }
    
    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
    public Byte getStatus() {
        return this.status;
    }
    
    public void setStatus(Byte status) {
        this.status = status;
    }
    public String getRemark1() {
        return this.remark1;
    }
    
    public void setRemark1(String remark1) {
        this.remark1 = remark1;
    }
    public String getRemark2() {
        return this.remark2;
    }
    
    public void setRemark2(String remark2) {
        this.remark2 = remark2;
    }
    public int getCreatedBy() {
        return this.createdBy;
    }
    
    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }
    public int getUpdatedBy() {
        return this.updatedBy;
    }
    
    public void setUpdatedBy(int updatedBy) {
        this.updatedBy = updatedBy;
    }




}


