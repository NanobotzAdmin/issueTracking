package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1



/**
 * PmUserRoleHasInterfaceComponentId generated by hbm2java
 */
public class PmUserRoleHasInterfaceComponentId  implements java.io.Serializable {


     private int pmUserRoleId;
     private int pmInterfaceComponentId;

    public PmUserRoleHasInterfaceComponentId() {
    }

    public PmUserRoleHasInterfaceComponentId(int pmUserRoleId, int pmInterfaceComponentId) {
       this.pmUserRoleId = pmUserRoleId;
       this.pmInterfaceComponentId = pmInterfaceComponentId;
    }
   
    public int getPmUserRoleId() {
        return this.pmUserRoleId;
    }
    
    public void setPmUserRoleId(int pmUserRoleId) {
        this.pmUserRoleId = pmUserRoleId;
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
		 if ( !(other instanceof PmUserRoleHasInterfaceComponentId) ) return false;
		 PmUserRoleHasInterfaceComponentId castOther = ( PmUserRoleHasInterfaceComponentId ) other; 
         
		 return (this.getPmUserRoleId()==castOther.getPmUserRoleId())
 && (this.getPmInterfaceComponentId()==castOther.getPmInterfaceComponentId());
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getPmUserRoleId();
         result = 37 * result + this.getPmInterfaceComponentId();
         return result;
   }   


}

