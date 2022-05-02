package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1


import java.util.Date;

/**
 * TmTicketsHasUmUser generated by hbm2java
 */
public class TmTicketsHasUmUser  implements java.io.Serializable {


     private TmTicketsHasUmUserId id;
     private TmTickets tmTickets;
     private UmUser umUser;
     private Date createdAt;
     private Date updatedAt;
     private Byte status;
     private String remark1;
     private String remark2;
     private int createdBy;
     private int updatedBy;

    public TmTicketsHasUmUser() {
    }

	
    public TmTicketsHasUmUser(TmTicketsHasUmUserId id, TmTickets tmTickets, UmUser umUser, int createdBy, int updatedBy) {
        this.id = id;
        this.tmTickets = tmTickets;
        this.umUser = umUser;
        this.createdBy = createdBy;
        this.updatedBy = updatedBy;
    }
    public TmTicketsHasUmUser(TmTicketsHasUmUserId id, TmTickets tmTickets, UmUser umUser, Date createdAt, Date updatedAt, Byte status, String remark1, String remark2, int createdBy, int updatedBy) {
       this.id = id;
       this.tmTickets = tmTickets;
       this.umUser = umUser;
       this.createdAt = createdAt;
       this.updatedAt = updatedAt;
       this.status = status;
       this.remark1 = remark1;
       this.remark2 = remark2;
       this.createdBy = createdBy;
       this.updatedBy = updatedBy;
    }
   
    public TmTicketsHasUmUserId getId() {
        return this.id;
    }
    
    public void setId(TmTicketsHasUmUserId id) {
        this.id = id;
    }
    public TmTickets getTmTickets() {
        return this.tmTickets;
    }
    
    public void setTmTickets(TmTickets tmTickets) {
        this.tmTickets = tmTickets;
    }
    public UmUser getUmUser() {
        return this.umUser;
    }
    
    public void setUmUser(UmUser umUser) {
        this.umUser = umUser;
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


