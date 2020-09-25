/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tr.biznet.bizzy.owaps;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

/**
 *
 * @author berkcan.erguncu
 */
@XmlAccessorType(XmlAccessType.FIELD)
public class OwapsInstances {
    
    @XmlElement(name = "uri")
    private String url;
    
    @XmlElement(name = "method")
    private String method;
    
    @XmlElement(name = "evidence")
    private String evidence;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getEvidence() {
        return evidence;
    }

    public void setEvidence(String evidence) {
        this.evidence = evidence;
    }
    
    
    
}
