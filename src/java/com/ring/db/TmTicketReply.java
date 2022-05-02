package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1


import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * TmTicketReply generated by hbm2java
 */
public class TmTicketReply  implements java.io.Serializable {


     private Integer id;
     private TmTickets tmTickets;
     private String replyDescription;
     private Date createdAt;
     private Date updatedAt;
     private Byte status;
     private String remark1;
     private String remark2;
     private int createdBy;
     private int updatedBy;
     private Double replyExpence;
     private Set tmReplyMedias = new HashSet(0);

    public TmTicketReply() {
    }

	
    public TmTicketReply(TmTickets tmTickets, int createdBy, int updatedBy) {
        this.tmTickets = tmTickets;
        this.createdBy = createdBy;
        this.updatedBy = updatedBy;
    }
    public TmTicketReply(TmTickets tmTickets, String replyDescription, Date createdAt, Date updatedAt, Byte status, String remark1, String remark2, int createdBy, int updatedBy, Double replyExpence, Set tmReplyMedias) {
       this.tmTickets = tmTickets;
       this.replyDescription = replyDescription;
       this.createdAt = createdAt;
       this.updatedAt = updatedAt;
       this.status = status;
       this.remark1 = remark1;
       this.remark2 = remark2;
       this.createdBy = createdBy;
       this.updatedBy = updatedBy;
       this.replyExpence = replyExpence;
       this.tmReplyMedias = tmReplyMedias;
    }
   
    public Integer getId() {
        return this.id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    public TmTickets getTmTickets() {
        return this.tmTickets;
    }
    
    public void setTmTickets(TmTickets tmTickets) {
        this.tmTickets = tmTickets;
    }
    public String getReplyDescription() {
        return this.replyDescription;
    }
    
    public void setReplyDescription(String replyDescription) {
        this.replyDescription = replyDescription;
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
    public Double getReplyExpence() {
        return this.replyExpence;
    }
    
    public void setReplyExpence(Double replyExpence) {
        this.replyExpence = replyExpence;
    }
    public Set getTmReplyMedias() {
        return this.tmReplyMedias;
    }
    
    public void setTmReplyMedias(Set tmReplyMedias) {
        this.tmReplyMedias = tmReplyMedias;
    }




}


