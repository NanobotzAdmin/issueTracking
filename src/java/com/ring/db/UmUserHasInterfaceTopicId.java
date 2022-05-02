package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1



/**
 * UmUserHasInterfaceTopicId generated by hbm2java
 */
public class UmUserHasInterfaceTopicId  implements java.io.Serializable {


     private int umUserId;
     private int pmInterfaceTopicId;

    public UmUserHasInterfaceTopicId() {
    }

    public UmUserHasInterfaceTopicId(int umUserId, int pmInterfaceTopicId) {
       this.umUserId = umUserId;
       this.pmInterfaceTopicId = pmInterfaceTopicId;
    }
   
    public int getUmUserId() {
        return this.umUserId;
    }
    
    public void setUmUserId(int umUserId) {
        this.umUserId = umUserId;
    }
    public int getPmInterfaceTopicId() {
        return this.pmInterfaceTopicId;
    }
    
    public void setPmInterfaceTopicId(int pmInterfaceTopicId) {
        this.pmInterfaceTopicId = pmInterfaceTopicId;
    }


   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof UmUserHasInterfaceTopicId) ) return false;
		 UmUserHasInterfaceTopicId castOther = ( UmUserHasInterfaceTopicId ) other; 
         
		 return (this.getUmUserId()==castOther.getUmUserId())
 && (this.getPmInterfaceTopicId()==castOther.getPmInterfaceTopicId());
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getUmUserId();
         result = 37 * result + this.getPmInterfaceTopicId();
         return result;
   }   


}


