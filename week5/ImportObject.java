/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tr.biznet.bizzy.service.pentest.domain;

import java.io.InputStream;
import java.io.Serializable;
import java.util.List;
import java.util.Map;
import lombok.Data;
import tr.biznet.bizzy.owaps.OwapsReport;
import tr.biznet.bizzy.plugins.acunetix.domain.AcunetixReport;
import tr.biznet.bizzy.plugins.appScan.domain.scan.AppScanReport;
import tr.biznet.bizzy.plugins.arachni.domain.scan.ArachniReport;
import tr.biznet.bizzy.plugins.burp.domain.scan.Issues;
import tr.biznet.bizzy.plugins.checkmarx.domain.CheckmarxReport;
import tr.biznet.bizzy.plugins.fortify.domain.scan.FortifyReport;
import tr.biznet.bizzy.plugins.nessus.domain.scan.NessusClientData_v2;
import tr.biznet.bizzy.plugins.netsparker.domain.NetsparkerEntReport;
import tr.biznet.bizzy.plugins.netsparker.domain.NetsparkerReport;
import tr.biznet.bizzy.plugins.qualys.domain.report.fetch.Scan;
import tr.biznet.bizzy.plugins.wapiti.domain.scan.WapitiReport;
import tr.biznet.bizzy.plugins.webinspect.domain.scan.WebinspectInfo;
import tr.biznet.bizzy.plugins.webinspect.domain.scan.WebinspectReport;
import tr.biznet.bizzy.service.kb.domain.KBItem;

/**
 *
 * @author ismail.okutucu
 */
@Data
public class ImportObject implements Serializable {

    private InputStream fileStream;
    private InputStream finalFileStream;
    private Map<String, String> importCategories;
    List<KBItem> kbCategories;
    NessusClientData_v2 nessus;
    Issues burp;
    Scan qualys;
    AppScanReport appScan;
    FortifyReport fortify;
    WebinspectReport webinspect;
    WebinspectInfo webinspectInfo;
    ArachniReport arachni;
    WapitiReport wapiti;
    NetsparkerReport netsparker; 
    NetsparkerEntReport netsparkerEnt;
    AcunetixReport acunetix;
    CheckmarxReport checkmarxReport;
    OwapsReport owapsReport;
}
