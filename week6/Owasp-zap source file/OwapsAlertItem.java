/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tr.biznet.bizzy.owaps;

import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

/**
 *
 * @author Berkcan.Erguncu 05350309219 arabeni yala beni :*
 */

@XmlAccessorType(XmlAccessType.FIELD)
public class OwapsAlertItem {
    
    @XmlElement(name = "pluginid")
    private String plugin_id;
    
    @XmlElement(name = "alert")
    private String alert;
    
    @XmlElement(name = "name")
    private String name;
    
    @XmlElement(name = "riskcode")
    private String risk_code;
    
    @XmlElement(name = "confidence")
    private String confidence;
    
    @XmlElement(name = "riskdesc")
    private String risk_desc;
    
    @XmlElement(name = "desc")
    private String desc;
    
    @XmlElement(name = "instances")
    private List<OwapsInstances> instances;
    
    @XmlElement(name = "count")
    private String count;
    
    @XmlElement(name = "solution")
    private String solution;
    
    @XmlElement(name = "reference")
    private String reference;
    
    @XmlElement(name = "cweid")
    private String cweid;
    
    @XmlElement(name = "wascid")
    private String wascid;
    
    @XmlElement(name = "sourceid")
    private String sourceid;

    public String getPlugin_id() {
        return plugin_id;
    }

    public void setPlugin_id(String plugin_id) {
        this.plugin_id = plugin_id;
    }

    public String getAlert() {
        return alert;
    }

    public void setAlert(String alert) {
        this.alert = alert;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRisk_code() {
        return risk_code;
    }

    public void setRisk_code(String risk_code) {
        this.risk_code = risk_code;
    }

    public String getConfidence() {
        return confidence;
    }

    public void setConfidence(String confidence) {
        this.confidence = confidence;
    }

    public String getRisk_desc() {
        return risk_desc;
    }

    public void setRisk_desc(String risk_desc) {
        this.risk_desc = risk_desc;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public List<OwapsInstances> getInstances() {
        return instances;
    }

    public void setInstances(List<OwapsInstances> instances) {
        this.instances = instances;
    }

    public String getCount() {
        return count;
    }

    public void setCount(String count) {
        this.count = count;
    }

    public String getSolution() {
        return solution;
    }

    public void setSolution(String solution) {
        this.solution = solution;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getCweid() {
        return cweid;
    }

    public void setCweid(String cweid) {
        this.cweid = cweid;
    }

    public String getWascid() {
        return wascid;
    }

    public void setWascid(String wascid) {
        this.wascid = wascid;
    }

    public String getSourceid() {
        return sourceid;
    }

    public void setSourceid(String sourceid) {
        this.sourceid = sourceid;
    }
    
}
