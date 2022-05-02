package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1



/**
 * TmTicketsHasUmUserId generated by hbm2java
 */
public class TmTicketsHasUmUserId  implements java.io.Serializable {


     private int tmTicketsId;
     private int umUserId;

    public TmTicketsHasUmUserId() {
    }

    public TmTicketsHasUmUserId(int tmTicketsId, int umUserId) {
       this.tmTicketsId = tmTicketsId;
       this.umUserId = umUserId;
    }
   
    public int getTmTicketsId() {
        return this.tmTicketsId;
    }
    
    public void setTmTicketsId(int tmTicketsId) {
        this.tmTicketsId = tmTicketsId;
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
		 if ( !(other instanceof TmTicketsHasUmUserId) ) return false;
		 TmTicketsHasUmUserId castOther = ( TmTicketsHasUmUserId ) other; 
         
		 return (this.getTmTicketsId()==castOther.getTmTicketsId())
 && (this.getUmUserId()==castOther.getUmUserId());
   }
   
   public int hashCode() {
         int result = 17;
         
         result = 37 * result + this.getTmTicketsId();
         result = 37 * result + this.getUmUserId();
         return result;
   }   


}

