package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1



/**
 * UmUserHasInterfaceComponentId generated by hbm2java
 */
public class UmUserHasInterfaceComponentId  implements java.io.Serializable {


     private int umUserId;
     private int pmInterfaceComponentId;

    public UmUserHasInterfaceComponentId() {
    }

    public UmUserHasInterfaceComponentId(int umUserId, int pmInterfaceComponentId) {
       this.umUserId = umUserId;
       this.pmInterfaceComponentId = pmInterfaceComponentId;
    }
   
    public int getUmUserId() {
        return this.umUserId;
    }
    
    public void setUmUserId(int umUserId) {
        this.umUserId = umUserId;
    }
    public int getPmInterfaceComponentId() {
        return this.pmInterfaceComponentId;
    }
    
    public void setPmInterfaceComponentId(int pmInterfaceComponentId) {
        this.pmInterfaceComponentId = pmInterfaceComponentId;
    }


   public boolean equals(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof UmUserHasInterfaceComponentId) ) return false;
		 UmUserHasInterfaceComponentId castOther = ( UmUserHasInterfaceComponentId ) other; 
         
		 return (this.getUmUserId()==castOther.getUmUserId())
 && (this.getPmInterfaceComponentId()==castOther.getPmInterfaceComponentId());
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getUmUserId();
         result = 37 * result + this.getPmInterfaceComponentId();
         return result;
   }   


}

