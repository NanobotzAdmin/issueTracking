package com.ring.db;
// Generated Mar 24, 2022 1:49:21 AM by Hibernate Tools 4.3.1



/**
 * QmQueueIcons generated by hbm2java
 */
public class QmQueueIcons  implements java.io.Serializable {


     private Integer id;
     private String iconName;
     private String iconCode;
     private String iconCode2;

    public QmQueueIcons() {
    }

    public QmQueueIcons(String iconName, String iconCode, String iconCode2) {
       this.iconName = iconName;
       this.iconCode = iconCode;
       this.iconCode2 = iconCode2;
    }
   
    public Integer getId() {
        return this.id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    public String getIconName() {
        return this.iconName;
    }
    
    public void setIconName(String iconName) {
        this.iconName = iconName;
    }
    public String getIconCode() {
        return this.iconCode;
    }
    
    public void setIconCode(String iconCode) {
        this.iconCode = iconCode;
    }
    public String getIconCode2() {
        return this.iconCode2;
    }
    
    public void setIconCode2(String iconCode2) {
        this.iconCode2 = iconCode2;
    }




}

