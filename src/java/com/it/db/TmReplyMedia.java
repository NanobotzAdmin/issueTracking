package com.it.db;
// Generated May 31, 2022 9:18:16 PM by Hibernate Tools 4.3.1


import java.util.Date;

/**
 * TmReplyMedia generated by hbm2java
 */
public class TmReplyMedia  implements java.io.Serializable {


     private Integer id;
     private TmTicketReply tmTicketReply;
     private String mediaType;
     private String mediaPath;
     private Date createdAt;
     private Date updatedAt;
     private Byte status;
     private String remark1;
     private String remark2;
     private int createdBy;
     private int updatedBy;

    public TmReplyMedia() {
    }

	
    public TmReplyMedia(TmTicketReply tmTicketReply, int createdBy, int updatedBy) {
        this.tmTicketReply = tmTicketReply;
        this.createdBy = createdBy;
        this.updatedBy = updatedBy;
    }
    public TmReplyMedia(TmTicketReply tmTicketReply, String mediaType, String mediaPath, Date createdAt, Date updatedAt, Byte status, String remark1, String remark2, int createdBy, int updatedBy) {
       this.tmTicketReply = tmTicketReply;
       this.mediaType = mediaType;
       this.mediaPath = mediaPath;
       this.createdAt = createdAt;
       this.updatedAt = updatedAt;
       this.status = status;
       this.remark1 = remark1;
       this.remark2 = remark2;
       this.createdBy = createdBy;
       this.updatedBy = updatedBy;
    }
   
    public Integer getId() {
        return this.id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    public TmTicketReply getTmTicketReply() {
        return this.tmTicketReply;
    }
    
    public void setTmTicketReply(TmTicketReply tmTicketReply) {
        this.tmTicketReply = tmTicketReply;
    }
    public String getMediaType() {
        return this.mediaType;
    }
    
    public void setMediaType(String mediaType) {
        this.mediaType = mediaType;
    }
    public String getMediaPath() {
        return this.mediaPath;
    }
    
    public void setMediaPath(String mediaPath) {
        this.mediaPath = mediaPath;
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


