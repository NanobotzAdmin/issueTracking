package com.it.db;
// Generated May 31, 2022 9:18:16 PM by Hibernate Tools 4.3.1


import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * QmSubCategories generated by hbm2java
 */
public class QmSubCategories  implements java.io.Serializable {


     private Integer id;
     private QmCategories qmCategories;
     private String subCategoryName;
     private String description;
     private Date createdAt;
     private Date updatedAt;
     private Byte status;
     private String remark1;
     private String remark2;
     private int createdBy;
     private int updatedBy;
     private Set<TmTickets> tmTicketses = new HashSet<TmTickets>(0);
     private Set<QmCategoriesHasSubCategories> qmCategoriesHasSubCategorieses = new HashSet<QmCategoriesHasSubCategories>(0);
     private Set<QmSubCategoriesHasUser> qmSubCategoriesHasUsers = new HashSet<QmSubCategoriesHasUser>(0);

    public QmSubCategories() {
    }

	
    public QmSubCategories(QmCategories qmCategories, int createdBy, int updatedBy) {
        this.qmCategories = qmCategories;
        this.createdBy = createdBy;
        this.updatedBy = updatedBy;
    }
    public QmSubCategories(QmCategories qmCategories, String subCategoryName, String description, Date createdAt, Date updatedAt, Byte status, String remark1, String remark2, int createdBy, int updatedBy, Set<TmTickets> tmTicketses, Set<QmCategoriesHasSubCategories> qmCategoriesHasSubCategorieses, Set<QmSubCategoriesHasUser> qmSubCategoriesHasUsers) {
       this.qmCategories = qmCategories;
       this.subCategoryName = subCategoryName;
       this.description = description;
       this.createdAt = createdAt;
       this.updatedAt = updatedAt;
       this.status = status;
       this.remark1 = remark1;
       this.remark2 = remark2;
       this.createdBy = createdBy;
       this.updatedBy = updatedBy;
       this.tmTicketses = tmTicketses;
       this.qmCategoriesHasSubCategorieses = qmCategoriesHasSubCategorieses;
       this.qmSubCategoriesHasUsers = qmSubCategoriesHasUsers;
    }
   
    public Integer getId() {
        return this.id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    public QmCategories getQmCategories() {
        return this.qmCategories;
    }
    
    public void setQmCategories(QmCategories qmCategories) {
        this.qmCategories = qmCategories;
    }
    public String getSubCategoryName() {
        return this.subCategoryName;
    }
    
    public void setSubCategoryName(String subCategoryName) {
        this.subCategoryName = subCategoryName;
    }
    public String getDescription() {
        return this.description;
    }
    
    public void setDescription(String description) {
        this.description = description;
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
    public Set<TmTickets> getTmTicketses() {
        return this.tmTicketses;
    }
    
    public void setTmTicketses(Set<TmTickets> tmTicketses) {
        this.tmTicketses = tmTicketses;
    }
    public Set<QmCategoriesHasSubCategories> getQmCategoriesHasSubCategorieses() {
        return this.qmCategoriesHasSubCategorieses;
    }
    
    public void setQmCategoriesHasSubCategorieses(Set<QmCategoriesHasSubCategories> qmCategoriesHasSubCategorieses) {
        this.qmCategoriesHasSubCategorieses = qmCategoriesHasSubCategorieses;
    }
    public Set<QmSubCategoriesHasUser> getQmSubCategoriesHasUsers() {
        return this.qmSubCategoriesHasUsers;
    }
    
    public void setQmSubCategoriesHasUsers(Set<QmSubCategoriesHasUser> qmSubCategoriesHasUsers) {
        this.qmSubCategoriesHasUsers = qmSubCategoriesHasUsers;
    }




}


