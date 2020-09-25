/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tr.biznet.bizzy.owaps;

import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author berkcan.erguncu
 */
@XmlRootElement(name = "OWASPZAPReport")
@XmlAccessorType(XmlAccessType.FIELD)
public class OwapsReport {
    
    @XmlElement(name="generated")
    private String scanDate;
    
    @XmlElement(name="name")
    private String target_url;
    
    @XmlElementWrapper(name = "alerts")
    @XmlElement(name="alertitem")
    private List<OwapsAlertItem> AlertItem;

    public String getScanDate() {
        return scanDate;
    }

    public void setScanDate(String scanDate) {
        this.scanDate = scanDate;
    }

    public String getTarget_url() {
        return target_url;
    }

    public void setTarget_url(String target_url) {
        this.target_url = target_url;
    }

    public List<OwapsAlertItem> getAlertItem() {
        return AlertItem;
    }

    public void setAlertItem(List<OwapsAlertItem> AlertItem) {
        this.AlertItem = AlertItem;
    }
    
    
    
    
}
