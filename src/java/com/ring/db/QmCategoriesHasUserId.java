package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1



/**
 * QmCategoriesHasUserId generated by hbm2java
 */
public class QmCategoriesHasUserId  implements java.io.Serializable {


     private int qmCategoriesId;
     private int umUserId;

    public QmCategoriesHasUserId() {
    }

    public QmCategoriesHasUserId(int qmCategoriesId, int umUserId) {
       this.qmCategoriesId = qmCategoriesId;
       this.umUserId = umUserId;
    }
   
    public int getQmCategoriesId() {
        return this.qmCategoriesId;
    }
    
    public void setQmCategoriesId(int qmCategoriesId) {
        this.qmCategoriesId = qmCategoriesId;
    }
    public int getUmUserId() {
        return this.umUserId;
    }
    
    public void setUmUserId(int umUserId) {
        this.umUserId = umUserId;
    }


   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof QmCategoriesHasUserId) ) return false;
		 QmCategoriesHasUserId castOther = ( QmCategoriesHasUserId ) other; 
         
		 return (this.getQmCategoriesId()==castOther.getQmCategoriesId())
 && (this.getUmUserId()==castOther.getUmUserId());
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getQmCategoriesId();
         result = 37 * result + this.getUmUserId();
         return result;
   }   


}

