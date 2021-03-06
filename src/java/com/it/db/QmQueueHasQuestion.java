package com.it.db;
// Generated May 31, 2022 9:18:16 PM by Hibernate Tools 4.3.1


import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * QmQueueHasQuestion generated by hbm2java
 */
public class QmQueueHasQuestion  implements java.io.Serializable {


     private QmQueueHasQuestionId id;
     private QmQueue qmQueue;
     private RcasQuestion rcasQuestion;
     private Date createdAt;
     private Date updatedAt;
     private Byte status;
     private String remark1;
     private String remark2;
     private int createdBy;
     private int updatedBy;
     private Set<TmTicketHasQueueHasQuestionHasAnswers> tmTicketHasQueueHasQuestionHasAnswerses = new HashSet<TmTicketHasQueueHasQuestionHasAnswers>(0);

    public QmQueueHasQuestion() {
    }

	
    public QmQueueHasQuestion(QmQueueHasQuestionId id, QmQueue qmQueue, RcasQuestion rcasQuestion, int createdBy, int updatedBy) {
        this.id = id;
        this.qmQueue = qmQueue;
        this.rcasQuestion = rcasQuestion;
        this.createdBy = createdBy;
        this.updatedBy = updatedBy;
    }
    public QmQueueHasQuestion(QmQueueHasQuestionId id, QmQueue qmQueue, RcasQuestion rcasQuestion, Date createdAt, Date updatedAt, Byte status, String remark1, String remark2, int createdBy, int updatedBy, Set<TmTicketHasQueueHasQuestionHasAnswers> tmTicketHasQueueHasQuestionHasAnswerses) {
       this.id = id;
       this.qmQueue = qmQueue;
       this.rcasQuestion = rcasQuestion;
       this.createdAt = createdAt;
       this.updatedAt = updatedAt;
       this.status = status;
       this.remark1 = remark1;
       this.remark2 = remark2;
       this.createdBy = createdBy;
       this.updatedBy = updatedBy;
       this.tmTicketHasQueueHasQuestionHasAnswerses = tmTicketHasQueueHasQuestionHasAnswerses;
    }
   
    public QmQueueHasQuestionId getId() {
        return this.id;
    }
    
    public void setId(QmQueueHasQuestionId id) {
        this.id = id;
    }
    public QmQueue getQmQueue() {
        return this.qmQueue;
    }
    
    public void setQmQueue(QmQueue qmQueue) {
        this.qmQueue = qmQueue;
    }
    public RcasQuestion getRcasQuestion() {
        return this.rcasQuestion;
    }
    
    public void setRcasQuestion(RcasQuestion rcasQuestion) {
        this.rcasQuestion = rcasQuestion;
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
    public Set<TmTicketHasQueueHasQuestionHasAnswers> getTmTicketHasQueueHasQuestionHasAnswerses() {
        return this.tmTicketHasQueueHasQuestionHasAnswerses;
    }
    
    public void setTmTicketHasQueueHasQuestionHasAnswerses(Set<TmTicketHasQueueHasQuestionHasAnswers> tmTicketHasQueueHasQuestionHasAnswerses) {
        this.tmTicketHasQueueHasQuestionHasAnswerses = tmTicketHasQueueHasQuestionHasAnswerses;
    }




}


