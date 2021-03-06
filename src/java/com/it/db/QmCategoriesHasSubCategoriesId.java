package com.it.db;
// Generated May 31, 2022 9:18:16 PM by Hibernate Tools 4.3.1



/**
 * QmCategoriesHasSubCategoriesId generated by hbm2java
 */
public class QmCategoriesHasSubCategoriesId  implements java.io.Serializable {


     private int qmCategoriesId;
     private int qmSubCategoriesId;

    public QmCategoriesHasSubCategoriesId() {
    }

    public QmCategoriesHasSubCategoriesId(int qmCategoriesId, int qmSubCategoriesId) {
       this.qmCategoriesId = qmCategoriesId;
       this.qmSubCategoriesId = qmSubCategoriesId;
    }
   
    public int getQmCategoriesId() {
        return this.qmCategoriesId;
    }
    
    public void setQmCategoriesId(int qmCategoriesId) {
        this.qmCategoriesId = qmCategoriesId;
    }
    public int getQmSubCategoriesId() {
        return this.qmSubCategoriesId;
    }
    
    public void setQmSubCategoriesId(int qmSubCategoriesId) {
        this.qmSubCategoriesId = qmSubCategoriesId;
    }


   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof QmCategoriesHasSubCategoriesId) ) return false;
		 QmCategoriesHasSubCategoriesId castOther = ( QmCategoriesHasSubCategoriesId ) other; 
         
		 return (this.getQmCategoriesId()==castOther.getQmCategoriesId())
 && (this.getQmSubCategoriesId()==castOther.getQmSubCategoriesId());
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getQmCategoriesId();
         result = 37 * result + this.getQmSubCategoriesId();
         return result;
   }   


}


