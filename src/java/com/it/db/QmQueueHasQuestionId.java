package com.it.db;
// Generated May 31, 2022 9:18:16 PM by Hibernate Tools 4.3.1



/**
 * QmQueueHasQuestionId generated by hbm2java
 */
public class QmQueueHasQuestionId  implements java.io.Serializable {


     private int qmQueueId;
     private int rcasQuestionId;

    public QmQueueHasQuestionId() {
    }

    public QmQueueHasQuestionId(int qmQueueId, int rcasQuestionId) {
       this.qmQueueId = qmQueueId;
       this.rcasQuestionId = rcasQuestionId;
    }
   
    public int getQmQueueId() {
        return this.qmQueueId;
    }
    
    public void setQmQueueId(int qmQueueId) {
        this.qmQueueId = qmQueueId;
    }
    public int getRcasQuestionId() {
        return this.rcasQuestionId;
    }
    
    public void setRcasQuestionId(int rcasQuestionId) {
        this.rcasQuestionId = rcasQuestionId;
    }


   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof QmQueueHasQuestionId) ) return false;
		 QmQueueHasQuestionId castOther = ( QmQueueHasQuestionId ) other; 
         
		 return (this.getQmQueueId()==castOther.getQmQueueId())
 && (this.getRcasQuestionId()==castOther.getRcasQuestionId());
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getQmQueueId();
         result = 37 * result + this.getRcasQuestionId();
         return result;
   }   


}


