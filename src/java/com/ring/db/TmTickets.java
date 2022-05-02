package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1


import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * TmTickets generated by hbm2java
 */
public class TmTickets  implements java.io.Serializable {


     private Integer id;
     private LmLocations lmLocations;
     private QmCategories qmCategories;
     private QmQueue qmQueue;
     private QmSubCategories qmSubCategories;
     private UmCustomer umCustomer;
     private String ticketName;
     private String ticketDescription;
     private Date createdAt;
     private Date updatedAt;
     private Date completedAt;
     private Date confirmedAt;
     private Date archivedAt;
     private Byte status;
     private String remark1;
     private String remark2;
     private int createdBy;
     private int updatedBy;
     private Integer completedBy;
     private Integer confirmedBy;
     private Integer archivedBy;
     private Double totalExpence;
     private Long timeToComplete;
     private Long timeToConfirm;
     private Long timeToArchive;
     private String tid;
     private Set tmTicketReplies = new HashSet(0);
     private Set tmTicketMedias = new HashSet(0);
     private Set tmTicketHasQueueHasQuestionHasAnswerses = new HashSet(0);
     private Set tmTicketsHasUmUsers = new HashSet(0);

    public TmTickets() {
    }

	
    public TmTickets(QmQueue qmQueue, int createdBy, int updatedBy) {
        this.qmQueue = qmQueue;
        this.createdBy = createdBy;
        this.updatedBy = updatedBy;
    }
    public TmTickets(LmLocations lmLocations, QmCategories qmCategories, QmQueue qmQueue, QmSubCategories qmSubCategories, UmCustomer umCustomer, String ticketName, String ticketDescription, Date createdAt, Date updatedAt, Date completedAt, Date confirmedAt, Date archivedAt, Byte status, String remark1, String remark2, int createdBy, int updatedBy, Integer completedBy, Integer confirmedBy, Integer archivedBy, Double totalExpence, Long timeToComplete, Long timeToConfirm, Long timeToArchive, String tid, Set tmTicketReplies, Set tmTicketMedias, Set tmTicketHasQueueHasQuestionHasAnswerses, Set tmTicketsHasUmUsers) {
       this.lmLocations = lmLocations;
       this.qmCategories = qmCategories;
       this.qmQueue = qmQueue;
       this.qmSubCategories = qmSubCategories;
       this.umCustomer = umCustomer;
       this.ticketName = ticketName;
       this.ticketDescription = ticketDescription;
       this.createdAt = createdAt;
       this.updatedAt = updatedAt;
       this.completedAt = completedAt;
       this.confirmedAt = confirmedAt;
       this.archivedAt = archivedAt;
       this.status = status;
       this.remark1 = remark1;
       this.remark2 = remark2;
       this.createdBy = createdBy;
       this.updatedBy = updatedBy;
       this.completedBy = completedBy;
       this.confirmedBy = confirmedBy;
       this.archivedBy = archivedBy;
       this.totalExpence = totalExpence;
       this.timeToComplete = timeToComplete;
       this.timeToConfirm = timeToConfirm;
       this.timeToArchive = timeToArchive;
       this.tid = tid;
       this.tmTicketReplies = tmTicketReplies;
       this.tmTicketMedias = tmTicketMedias;
       this.tmTicketHasQueueHasQuestionHasAnswerses = tmTicketHasQueueHasQuestionHasAnswerses;
       this.tmTicketsHasUmUsers = tmTicketsHasUmUsers;
    }
   
    public Integer getId() {
        return this.id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    public LmLocations getLmLocations() {
        return this.lmLocations;
    }
    
    public void setLmLocations(LmLocations lmLocations) {
        this.lmLocations = lmLocations;
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
    public QmSubCategories getQmSubCategories() {
        return this.qmSubCategories;
    }
    
    public void setQmSubCategories(QmSubCategories qmSubCategories) {
        this.qmSubCategories = qmSubCategories;
    }
    public UmCustomer getUmCustomer() {
        return this.umCustomer;
    }
    
    public void setUmCustomer(UmCustomer umCustomer) {
        this.umCustomer = umCustomer;
    }
    public String getTicketName() {
        return this.ticketName;
    }
    
    public void setTicketName(String ticketName) {
        this.ticketName = ticketName;
    }
    public String getTicketDescription() {
        return this.ticketDescription;
    }
    
    public void setTicketDescription(String ticketDescription) {
        this.ticketDescription = ticketDescription;
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
    public Date getCompletedAt() {
        return this.completedAt;
    }
    
    public void setCompletedAt(Date completedAt) {
        this.completedAt = completedAt;
    }
    public Date getConfirmedAt() {
        return this.confirmedAt;
    }
    
    public void setConfirmedAt(Date confirmedAt) {
        this.confirmedAt = confirmedAt;
    }
    public Date getArchivedAt() {
        return this.archivedAt;
    }
    
    public void setArchivedAt(Date archivedAt) {
        this.archivedAt = archivedAt;
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
    public Integer getCompletedBy() {
        return this.completedBy;
    }
    
    public void setCompletedBy(Integer completedBy) {
        this.completedBy = completedBy;
    }
    public Integer getConfirmedBy() {
        return this.confirmedBy;
    }
    
    public void setConfirmedBy(Integer confirmedBy) {
        this.confirmedBy = confirmedBy;
    }
    public Integer getArchivedBy() {
        return this.archivedBy;
    }
    
    public void setArchivedBy(Integer archivedBy) {
        this.archivedBy = archivedBy;
    }
    public Double getTotalExpence() {
        return this.totalExpence;
    }
    
    public void setTotalExpence(Double totalExpence) {
        this.totalExpence = totalExpence;
    }
    public Long getTimeToComplete() {
        return this.timeToComplete;
    }
    
    public void setTimeToComplete(Long timeToComplete) {
        this.timeToComplete = timeToComplete;
    }
    public Long getTimeToConfirm() {
        return this.timeToConfirm;
    }
    
    public void setTimeToConfirm(Long timeToConfirm) {
        this.timeToConfirm = timeToConfirm;
    }
    public Long getTimeToArchive() {
        return this.timeToArchive;
    }
    
    public void setTimeToArchive(Long timeToArchive) {
        this.timeToArchive = timeToArchive;
    }
    public String getTid() {
        return this.tid;
    }
    
    public void setTid(String tid) {
        this.tid = tid;
    }
    public Set getTmTicketReplies() {
        return this.tmTicketReplies;
    }
    
    public void setTmTicketReplies(Set tmTicketReplies) {
        this.tmTicketReplies = tmTicketReplies;
    }
    public Set getTmTicketMedias() {
        return this.tmTicketMedias;
    }
    
    public void setTmTicketMedias(Set tmTicketMedias) {
        this.tmTicketMedias = tmTicketMedias;
    }
    public Set getTmTicketHasQueueHasQuestionHasAnswerses() {
        return this.tmTicketHasQueueHasQuestionHasAnswerses;
    }
    
    public void setTmTicketHasQueueHasQuestionHasAnswerses(Set tmTicketHasQueueHasQuestionHasAnswerses) {
        this.tmTicketHasQueueHasQuestionHasAnswerses = tmTicketHasQueueHasQuestionHasAnswerses;
    }
    public Set getTmTicketsHasUmUsers() {
        return this.tmTicketsHasUmUsers;
    }
    
    public void setTmTicketsHasUmUsers(Set tmTicketsHasUmUsers) {
        this.tmTicketsHasUmUsers = tmTicketsHasUmUsers;
    }




}


