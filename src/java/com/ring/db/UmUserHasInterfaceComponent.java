package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1


import java.util.Date;

/**
 * UmUserHasInterfaceComponent generated by hbm2java
 */
public class UmUserHasInterfaceComponent  implements java.io.Serializable {


     private UmUserHasInterfaceComponentId id;
     private PmInterfaceComponent pmInterfaceComponent;
     private UmUser umUserByCreatedBy;
     private UmUser umUserByUpdatedBy;
     private UmUser umUserByUmUserId;
     private Date createdAt;
     private Date updatedAt;
     private Byte status;
     private String remark1;
     private String remark2;

    public UmUserHasInterfaceComponent() {
    }

	
    public UmUserHasInterfaceComponent(UmUserHasInterfaceComponentId id, PmInterfaceComponent pmInterfaceComponent, UmUser umUserByCreatedBy, UmUser umUserByUpdatedBy, UmUser umUserByUmUserId) {
        this.id = id;
        this.pmInterfaceComponent = pmInterfaceComponent;
        this.umUserByCreatedBy = umUserByCreatedBy;
        this.umUserByUpdatedBy = umUserByUpdatedBy;
        this.umUserByUmUserId = umUserByUmUserId;
    }
    public UmUserHasInterfaceComponent(UmUserHasInterfaceComponentId id, PmInterfaceComponent pmInterfaceComponent, UmUser umUserByCreatedBy, UmUser umUserByUpdatedBy, UmUser umUserByUmUserId, Date createdAt, Date updatedAt, Byte status, String remark1, String remark2) {
       this.id = id;
       this.pmInterfaceComponent = pmInterfaceComponent;
       this.umUserByCreatedBy = umUserByCreatedBy;
       this.umUserByUpdatedBy = umUserByUpdatedBy;
       this.umUserByUmUserId = umUserByUmUserId;
       this.createdAt = createdAt;
       this.updatedAt = updatedAt;
       this.status = status;
       this.remark1 = remark1;
       this.remark2 = remark2;
    }
   
    public UmUserHasInterfaceComponentId getId() {
        return this.id;
    }
    
    public void setId(UmUserHasInterfaceComponentId id) {
        this.id = id;
    }
    public PmInterfaceComponent getPmInterfaceComponent() {
        return this.pmInterfaceComponent;
    }
    
    public void setPmInterfaceComponent(PmInterfaceComponent pmInterfaceComponent) {
        this.pmInterfaceComponent = pmInterfaceComponent;
    }
    public UmUser getUmUserByCreatedBy() {
        return this.umUserByCreatedBy;
    }
    
    public void setUmUserByCreatedBy(UmUser umUserByCreatedBy) {
        this.umUserByCreatedBy = umUserByCreatedBy;
    }
    public UmUser getUmUserByUpdatedBy() {
        return this.umUserByUpdatedBy;
    }
    
    public void setUmUserByUpdatedBy(UmUser umUserByUpdatedBy) {
        this.umUserByUpdatedBy = umUserByUpdatedBy;
    }
    public UmUser getUmUserByUmUserId() {
        return this.umUserByUmUserId;
    }
    
    public void setUmUserByUmUserId(UmUser umUserByUmUserId) {
        this.umUserByUmUserId = umUserByUmUserId;
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




}

