/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tr.biznet.bizzy.service.scan.domain;

/**
 *
 * @author adem.dilbaz
 */
public enum Source {
    QUALYS,
    BURP,
    NMAP,
    NESSUS,
    NEXPOSE,
    OPENVAS,
    NETSPARKER,
    NETSPARKERENT,
    PENTEST,  //Pentest Taraması, elle tarama oluşturulduğunda bu değer verilir.
    APPSCAN,
    OWAPS,
    FORTIFY,
    WEBINSPECT,
    ARACHNI,
    WAPITI,
    ACUNETIX,
    EXCEL,
    CHECKMARX,
    SECURITY_CENTER
}
