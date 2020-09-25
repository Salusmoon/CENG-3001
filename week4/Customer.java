/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package tr.biznet.bizzy.service.customer.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import tr.biznet.bizzy.service.pci.domain.Bank;
import tr.biznet.bizzy.service.scan.domain.AssetGroup;

/**
 *
 * @author ftuna
 */
@Table(name="customer")
@Entity
public @Data class Customer implements Serializable{
    @Id
    @GeneratedValue(generator="system-uuid") 
    @GenericGenerator(name="system-uuid",strategy = "uuid")
    @Column(name = "customer_id", length = 50)
    private String customerId;
    @Column(name = "company_name")
    private String companyName;
    @Column(name = "address")
    private String address;
    @Column(name="city")
    private String city;
    @Column(name="country")
    private String country;
    @Column(name="zip_code")
    private String zipCode;
    @Column(name="phone_number")
    private String phoneNumber;
    @Column(name="web_address")
    private String webAddress;
    @Column(name="tax_office")
    private String taxOffice;
    @Column(name="tax_number")
    private String taxNumber;
    @Column(name="parent_customer")
    private String parentCustomer;
    // Fatura tarihi bilgisi. Bu tarihten sonra tarama talebi yapılamaz.
    @Column(name="invoice_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date invoiceDate;
    // Tarama kota bilgisi. -1 ise sınırsız anlamına gelir. Bu durumda IP limitine bakılır.
    @Column(name="scan_count")
    private int scanCount;
    @Column(name="ip_limit")
    private int ipLimit;
    @Column(name="dashboard_graph_generating", columnDefinition = "boolean default false") 
    private boolean dashboardGraphGenerating;    
    
    @Transient
    private Subscription subscription;
    @Transient
    private List<AssetGroup> assetGroups;
    @Transient
    private List<Bank> bankList;
    @Transient
    private Set<String> bankSet;
    @Transient
    private String language;
    @Transient
    private String fileId;
    
    
    
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
}
