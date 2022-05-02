package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1



/**
 * QmSubCategoriesHasUserId generated by hbm2java
 */
public class QmSubCategoriesHasUserId  implements java.io.Serializable {


     private int qmSubCategoriesId;
     private int umUserId;

    public QmSubCategoriesHasUserId() {
    }

    public QmSubCategoriesHasUserId(int qmSubCategoriesId, int umUserId) {
       this.qmSubCategoriesId = qmSubCategoriesId;
       this.umUserId = umUserId;
    }
   
    public int getQmSubCategoriesId() {
        return this.qmSubCategoriesId;
    }
    
    public void setQmSubCategoriesId(int qmSubCategoriesId) {
        this.qmSubCategoriesId = qmSubCategoriesId;
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
		 if ( !(other instanceof QmSubCategoriesHasUserId) ) return false;
		 QmSubCategoriesHasUserId castOther = ( QmSubCategoriesHasUserId ) other; 
         
		 return (this.getQmSubCategoriesId()==castOther.getQmSubCategoriesId())
 && (this.getUmUserId()==castOther.getUmUserId());
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getQmSubCategoriesId();
         result = 37 * result + this.getUmUserId();
         return result;
   }   


}

