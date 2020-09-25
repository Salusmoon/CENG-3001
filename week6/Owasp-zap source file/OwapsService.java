/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tr.biznet.bizzy.owaps;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import javax.net.ssl.HttpsURLConnection;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tr.biznet.bizzy.configuration.service.ConfigurationService;
import tr.biznet.bizzy.domain.BizzyException;
import tr.biznet.bizzy.domain.BizzySecurityException;
import tr.biznet.bizzy.plugins.ti.TiService;
import tr.biznet.bizzy.service.asset.service.AssetService;
import tr.biznet.bizzy.service.customer.CustomerService;
import tr.biznet.bizzy.service.dashboard.DashboardService;
import tr.biznet.bizzy.service.mail.MailService;
import tr.biznet.bizzy.service.pci.domain.ScanAsset;
import tr.biznet.bizzy.service.pci.domain.ScanVulnerability;
import tr.biznet.bizzy.service.pci.domain.WebApp;
import tr.biznet.bizzy.service.pentest.PentestService;
import tr.biznet.bizzy.service.pentest.domain.PentestScan;
import tr.biznet.bizzy.service.pentest.domain.ScanProcess;
import tr.biznet.bizzy.service.pentest.domain.ScanStatus;
import tr.biznet.bizzy.service.pentest.domain.ToolScanResults;
import tr.biznet.bizzy.service.scan.domain.Asset;
import tr.biznet.bizzy.service.scan.domain.AssetGroup;
import tr.biznet.bizzy.service.scan.domain.CweId;
import tr.biznet.bizzy.service.scan.domain.GraphFilter;
import tr.biznet.bizzy.service.scan.domain.Port;
import tr.biznet.bizzy.service.scan.domain.Source;
import tr.biznet.bizzy.service.scan.domain.Vulnerability;
import tr.biznet.bizzy.service.scan.domain.VulnerabilityTimeGraph;
import tr.biznet.bizzy.service.server.ServerService;
import tr.biznet.bizzy.service.server.domain.Server;
import tr.biznet.bizzy.service.server.enums.ServerType;
import tr.biznet.bizzy.ticket.service.TicketExternalService;
import tr.biznet.bizzy.util.BizzyUtil;
import tr.biznet.bizzy.util.log.LogLevel;

/**
 *
 * @author berkcan.erguncu
 */
@Service
public class OwapsService {
    
    private static final tr.biznet.bizzy.util.log.Logger logger = tr.biznet.bizzy.util.log.LoggerFactory.getLogger(OwapsService.class);
    private static final String X_AUTH = "X-Auth";
    private static final String CONTENT_TYPE = "Content-Type";

    private String serverUrl;
    private String apiKey;

    @Autowired
    private CustomerService customerService;
    @Autowired
    private AssetService assetService;
    @Autowired
    private PentestService pentestService;
    @Autowired
    private ServerService serverService;
    @Autowired
    private MailService mailService;
    @Autowired
    private ConfigurationService configurationService;
    @Autowired
    private TicketExternalService ticketExternalService;
    @Autowired
    private TiService tiService;
    @Autowired
    private DashboardService dashboardService;

    public boolean initializeAgent(Server owaps) throws BizzyException, BizzySecurityException {
        if (BizzyUtil.isEmpty(owaps.getIp()) || BizzyUtil.isEmpty(owaps.getPort())) {
            throw new BizzyException("Owaps API bilgileri kayıtlı değil ya da eksik!");
        }
        if (BizzyUtil.isEmpty(owaps.getDomain())) {
            throw new BizzyException("Owaps API Key mevcut değil");
        }
        apiKey = owaps.getDomain();
        serverUrl = "https://" + owaps.getIp() + ":" + owaps.getPort() + "/api/v1/";
        return true;
    }
    
    public void updateOwapsScanStates(List<PentestScan> scanListToRestate) {
        logger.log(LogLevel.INFO, "Owaps Scan Restate Task başlıyor.");   
        try {
            for (PentestScan scan : scanListToRestate) {
                boolean completed = true;
                boolean failed = false;
                //Taramaya bağlı bütün owaps taramaları kontrol ediliyor tamamlanmış olanların rapor alma süreci başlatılıyor.
                List<ScanProcess> scanProcessList = pentestService.getScanProcessDetail(scan.getScanId(), null, null, null);
                for (ScanProcess scanProcess : scanProcessList) {
                    String status = getScanStatus(scanProcess.getTargetId());
                    if (parseScanStatus(status) != ScanStatus.COMPLETED) { 
                        completed = false;
                        if(parseScanStatus(status) == ScanStatus.ERROR){
                            failed = true;
                        }
                    } else {
                        String reportId = scanProcess.getReportId();
                        //scan assetin taraması tamamlanmış fakat rapor oluşturma başlatılmamış
                        if (reportId == null) {
                            String generatedReportId = generateReport(scanProcess.getToolScanId());
                            pentestService.saveScanProcessDetail(scan.getScanId(), scanProcess.getTargetId(), scanProcess.getToolScanId(), generatedReportId);
                        } else {
                            String reportStatus = getReportStatus(reportId);
                            //Rapor durumunun boş olması sürecin tamamlanmadığını, download linkinin oluşturulmadığını gösteriyor.
                            if (reportStatus.toUpperCase().equals("")) { 
                                completed = false;           
                            }
                        }
                    }
                }
                //boolean flaglara göre tarama durumunu set ediyoruz.
                if(!completed) {
                    if(failed) {
                        scan.setStatus(ScanStatus.RUNNING);
                    } else {
                        scan.setStatus(ScanStatus.ERROR);
                    }
                } else { 
                    scan.setStatus(ScanStatus.COMPLETED);
                }
                pentestService.updateScanStatus(scan);
                
                //Tarama bittiğine göre sonuçları çekip db'ye yazacağız.
                if (scan.getStatus() == ScanStatus.COMPLETED) {
                    
                    saveOwapsResults(scan.getScanId());

                    try {
                        mailService.sendScanCompletedMail(scan);
                    } catch (BizzyException ex) {
                        logger.log(LogLevel.ERROR, "tarama tamamlandı mail gondermede hata oluştu", ex);
                    }
                    //Tarama durumu COMPLETED ise tarama başlatan kullanıcı mail ile bilgilendiriliyor.
                }
            }
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Owpas API tarama durumu güncelleme işleminde hata !", ex);
        }
        logger.log(LogLevel.INFO, "Owaps Scan Restate Task tamamlandı.");
    }
    public String startScan(Server owaps, PentestScan pentestScan) throws BizzyException, JSONException, Exception {
        String targets = pentestScan.getTargets();
        String[] splittedTargets = targets.split("\\s*,\\s*");
        initializeAgent(owaps);
        String urlStr = serverUrl + "scans";
        List<String> targetIdList = new ArrayList<>();
        String scans = getScans();
        for (String target : splittedTargets) {
            boolean found = false;
            JSONObject json = new JSONObject(scans);
            JSONArray array = json.getJSONArray("scans");
            for (int i = 0; i < array.length(); i++) {
                if (array.getJSONObject(i).getJSONObject("target").getString("address").contains(target)) {
                    found = true;
                    targetIdList.add(array.getJSONObject(i).getString("target_id"));
                    pentestService.saveScanProcessDetail(pentestScan.getScanId(), array.getJSONObject(i).getString("target_id"), null, null);
                    break;
                }
            }
            //targets listesinde girilen url bulunmuyor, ekleyip target idsini alıyor ve san process tablosunda ilgili satıra yazıyoruz.
            if (!found) {
                String targetId = addTarget(owaps, target);
                pentestService.saveScanProcessDetail(pentestScan.getScanId(), targetId, null, null);
                targetIdList.add(targetId);
            }
        }
        //TODO: Bura daha verimli hale getirilebilir. içerideki getscans dışarı çıkartılabilir.
        for (int i = 0; i < targetIdList.size(); i++) {
            //her bir target için tarama başlatıyoruz
            String data = "{\"target_id\":\"" + targetIdList.get(i) + "\",\"profile_id\":\"11111111-1111-1111-1111-111111111111\","
                    + "\"schedule\":{\"disable\": \"False\", \"start_date\":\"None\",\"time_sensitive\":\"False\"}}";
            String data2 = "{\"target_id\":\""+targetIdList.get(i)+"\",\"profile_id\":\"11111111-1111-1111-1111-111111111111\",\"schedule\":{\"disable\":false,\"start_date\":null,\"time_sensitive\":false}}";
            httpPost(urlStr, data2);
            //oluşan taramanın scan idsini alıp scan process tablosunda ilgili satıra yazıyoruz.
            scans = getScans();
            JSONObject json = new JSONObject(scans);
            JSONArray array = json.getJSONArray("scans");
            for (int j = 0; j < array.length(); j++) {
                if (array.getJSONObject(j).getString("target_id").equals(targetIdList.get(i))) {
                    String scanId = array.getJSONObject(j).getString("scan_id");
                    pentestService.saveScanProcessDetail(pentestScan.getScanId(), targetIdList.get(i), scanId, null);
                    break;
                }
            }
        }
        return "";
    }
    
    public void stopScan(PentestScan scan){
       List<ScanProcess> scanProcessList = pentestService.getScanProcessDetail(scan.getScanId(), null, null, null); 
       String urlStr;
       for(ScanProcess item : scanProcessList){
           try {
               urlStr = serverUrl + "scans/"+item.getToolScanId()+"/abort";
               httpDelete(urlStr);
           } catch (Exception ex) {
               logger.log(LogLevel.ERROR, "Owpas scan stop process failed!", ex);
           }
       }
       
        
    }
    
    public String addTarget(Server owaps, String urls) throws BizzyException {
        try {
            initializeAgent(owaps);
        } catch (BizzySecurityException ex) {
            logger.log(LogLevel.ERROR, "Server initialization error!", ex);
        }
        String urlStr = serverUrl + "targets";
        String data = "{\"address\":\"" + urlStr + "\",\"description\":\"" + urlStr + "\",\"criticality\":\"10\"}";
        try {
            String ret = httpPost(urlStr, data);
            JSONObject json = new JSONObject(ret);
            return json.getString("target_id");
        } catch (Exception e) {
            logger.log(LogLevel.ERROR, "Owaps session could not started!", e);
            throw new BizzyException("Session başlatılamadı.", e);
        }
    }
    
     public String getScans() {
        String urlStr = serverUrl + "scans";
        try {
            return httpGet(urlStr);
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Owaps get request error!", ex);
            return "";
        }
    }

    public String getScanStatus(String targetId) {
        try {
            String scans = getScans();
            JSONObject json = new JSONObject(scans);
            JSONArray array = json.getJSONArray("scans");
            for (int i = 0; i < array.length(); i++) {
                if (array.getJSONObject(i).getString("target_id").equals(targetId)) {
                    return array.getJSONObject(i).getJSONObject("current_session").getString("status");
                }
            }
        } catch (JSONException ex) {
            logger.log(LogLevel.ERROR, "Owaps error while getting scan status", ex);
        }
        return "";
    }
    
    public String generateReport(String scanId) {
        try {
            String urlStr = serverUrl + "exports";
            String data = "{\"export_id\":\"21111111-1111-1111-1111-111111111111\",\"source\":{\"list_type\":\"scans\",\"id_list\":[\"" + scanId + "\"]}}";
            String ret = httpPost(urlStr, data);
            JSONObject json = new JSONObject(ret);
            return json.getString("report_id");

        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Owaps get report request error!", ex);
            return "";
        }
    }
    
    public String getAllReports() {
        String urlStr = serverUrl + "reports";
        try {
            return httpGet(urlStr);
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Owaps get all reports request error!", ex);
            return "";
        }
    }

    public String getReportStatus(String reportId) {
        String urlStr = serverUrl + "exports/" + reportId;
        try {
            String res = httpGet(urlStr);
            JSONObject json = new JSONObject(res);
            if (json.getString("status").equals("completed")) {
                JSONArray array = json.getJSONArray("download");
                return array.get(0).toString();
            } else {
                return "";
            }
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Owaps error while getting report status!", ex);
            return "";
        }
    }
    
    public OwapsReport getReportXML(String downloadLink) {
        String urlStr = serverUrl + downloadLink.replace("/api/v1/","" );
        String res;
        OwapsReport owapsReport = null;
        try {
            res = httpGet(urlStr);
            OwapsXmlParser OwapsXmlParser = new OwapsXmlParser();
            owapsReport = (OwapsReport) OwapsXmlParser.parseOwapsOutputWithString(res);
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Owaps error while generating xml report!", ex);
        }
        return owapsReport;
    }
     public List<ScanAsset> parseOwapsDataToScanAssetList(OwapsReport data, String customerId, PentestScan scan) {
        List<ScanAsset> assetList = new ArrayList<>();
        ScanAsset scanAsset = new ScanAsset();
        //todo: kontrol edilmeli

        scanAsset.setScannedIp(data.getTarget_url());

        Asset asset = customerService.getAssetByIp(data.getTarget_url(), customerId);

        if (asset == null) {
            //Yeni asset eklenecek.
//            Asset newAsset = new Asset();
//            newAsset.setIp(scanAsset.getScannedIp());
//            newAsset.setCustomerId(customerId);
//            String assetId = assetService.saveAsset(newAsset);
//            scanAsset.setAssetId(assetId);
        } else {
            //Asset zaten kayıtlı
            scanAsset.setAssetId(asset.getAssetId());
        }

        //Zafiyetlere geçiyoruz
        List<ScanVulnerability> vulnList = new LinkedList();
        List<OwapsAlertItem> items = data.getAlertItem();
        if (items != null && !items.isEmpty()) {
            HashMap<String, ArrayList<WebApp>> map = new HashMap<>();

            for (OwapsAlertItem item : items) {

                WebApp webApp = new WebApp();
                webApp.setApplication(data.getTarget_url());
                
                if (map.containsKey(item.getName())) {
                    map.get(item.getName()).add(webApp);
                } else {
                    ArrayList<WebApp> list = new ArrayList<>();
                    list.add(webApp);
                    map.put(item.getName(), list);

                    ScanVulnerability scanVulnerability = new ScanVulnerability();

                    Vulnerability vuln = new Vulnerability();
                    String risk_desc = item.getRisk_desc();    // risk_code  low (medium)
                    String parts[] = risk_desc.split(" (");
                    String risk_code = parts[0];             // low
                    String reliability = parts[1].substring(0, parts[1].length() - 1);   // medium
                    
                    vuln.setRiskLevel(parseSeverity(risk_code));
                    scanVulnerability.setPluginLevel(parsePluginLevel(risk_code));

                    //Taramanın min. risk seviyesinden küçükse zafiyeti almıyoruz.
                    if (scan.getMinRiskLevel() != null && scan.getMinRiskLevel() > vuln.getRiskLevel()) {
                        continue;
                    }

                    vuln.setSource(Source.OWAPS.toString());
                    vuln.setName(item.getName());

                    
                    if (item.getCweid()!= null ) {
                        List<CweId> cweIdList = new ArrayList<>();
                        CweId cweId = new CweId();
                        cweId.setId(item.getCweid());
                        cweIdList.add(cweId);
                        vuln.setCweIdList(cweIdList);
                    }

                    

                    vuln.setDescription(item.getDesc());

                    StringBuilder references = new StringBuilder();
                    vuln.setReferences(item.getReference());

                    vuln.setSolution(item.getSolution());

                    

                    Port port = new Port();
                    if (data.getTarget_url().contains("https:")) {
                        port.setPortNumber(443);
                        port.setProtocol("TCP");
                        port.setService("https");
                    } else if (data.getTarget_url().contains("http:")) {
                        port.setPortNumber(80);
                        port.setProtocol("TCP");
                        port.setService("http");
                    }
                    //port.setProtocol(item.getProtocol().toUpperCase());
                    //port.setService(item.getService().toLowerCase());
                    vuln.setVulnNumber(String.valueOf(item.getName().hashCode()));
                    scanVulnerability.setPort(port);
                    scanVulnerability.setVulnerability(vuln);

                    //todo : plugin id netleştirilecek
                    scanVulnerability.setPluginId(item.getPlugin_id());
                    scanVulnerability.setSource(Source.OWAPS.toString());
                    scanVulnerability.setActive(true);//Her yeni zafiyet active olarak belirlenir. Eski zafiyetlerin durumuna göre controller'da bu değişebilir.
                    scanVulnerability.setWebApps(map.get(item.getName()));
                    vulnList.add(scanVulnerability);
                }

            }
        }
        scanAsset.setScanVulnerabilityList(vulnList);
        assetList.add(scanAsset);

        return assetList;
    }
    
    public List<ScanAsset> parseOwapsataToScanAssetListSimpleModify(OwapsReport data, String customerId, PentestScan scan) {
        List<ScanAsset> assetList = new ArrayList<>();
        ScanAsset scanAsset = new ScanAsset();

        Asset asset = customerService.getAssetByIp(data.getTarget_url(), customerId);

        if (asset == null) {
        } else {
            scanAsset.setAssetId(asset.getAssetId());
        }

        List<ScanVulnerability> vulnList = new LinkedList();
        List<OwapsAlertItem> items = data.getAlertItem();
        if (items != null && !items.isEmpty()) {
            HashMap<String, ArrayList<WebApp>> map = new HashMap<>();

            for (OwapsAlertItem item : items) {

                WebApp webApp = new WebApp();
                webApp.setApplication(data.getTarget_url());
                
                if (map.containsKey(item.getName())) {
                    map.get(item.getName()).add(webApp);
                } else {
                    ArrayList<WebApp> list = new ArrayList<>();
                    list.add(webApp);
                    map.put(item.getName(), list);

                    ScanVulnerability scanVulnerability = new ScanVulnerability();

                    Vulnerability vuln = new Vulnerability();
                    
                    String risk_desc = item.getRisk_desc();    // risk_code  low (medium)
                    String parts[] = risk_desc.split(" (");
                    String risk_code = parts[0];             // low
                    String reliability = parts[1].substring(0, parts[1].length() - 1);   // medium
                    
                    vuln.setRiskLevel(parseSeverity(risk_code));
                    scanVulnerability.setPluginLevel(parsePluginLevel(risk_code));

                    //Taramanın min. risk seviyesinden küçükse zafiyeti almıyoruz.
                    if (scan.getMinRiskLevel() != null && scan.getMinRiskLevel() > vuln.getRiskLevel()) {
                        continue;
                    }

                    vuln.setSource(Source.OWAPS.toString());
                    vuln.setName(item.getName());
                    vuln.setCount(Integer.parseInt(item.getCount()));
                    
                    if (item.getCweid()!= null ) {
                        List<CweId> cweIdList = new ArrayList<>();
                        CweId cweId = new CweId();
                        cweId.setId(item.getCweid());
                        cweIdList.add(cweId);
                        vuln.setCweIdList(cweIdList);
                    }

                    

                    vuln.setDescription(item.getDesc());

                    StringBuilder references = new StringBuilder();
                    vuln.setReferences(item.getReference());

                    vuln.setSolution(item.getSolution());

                    

                    Port port = new Port();
                    if (data.getTarget_url().contains("https:")) {
                        port.setPortNumber(443);
                        port.setProtocol("TCP");
                        port.setService("https");
                    } else if (data.getTarget_url().contains("http:")) {
                        port.setPortNumber(80);
                        port.setProtocol("TCP");
                        port.setService("http");
                    }
                    //port.setProtocol(item.getProtocol().toUpperCase());
                    //port.setService(item.getService().toLowerCase());
                    vuln.setVulnNumber(String.valueOf(item.getName().hashCode()));
                    scanVulnerability.setPort(port);
                    scanVulnerability.setVulnerability(vuln);

                    //todo : plugin id netleştirilecek
                    scanVulnerability.setPluginId(item.getPlugin_id());
                    scanVulnerability.setSource(Source.OWAPS.toString());
                    scanVulnerability.setActive(true);//Her yeni zafiyet active olarak belirlenir. Eski zafiyetlerin durumuna göre controller'da bu değişebilir.
                    scanVulnerability.setWebApps(map.get(item.getName()));
                    vulnList.add(scanVulnerability);
                }

            }
        }
        scanAsset.setScanVulnerabilityList(vulnList);
        assetList.add(scanAsset);

        return assetList;
    }
    
    public void saveOwapsResults(String scanId) throws BizzySecurityException, Exception {
        long scoreNow = 0;
        int openVulnCountNow = 0;
        PentestScan scan = pentestService.getScanById(scanId);
        try {   // risk skoru alarmı üretmek için tarama sonuçlarını kaydetmeden önceki skor alınır!
            GraphFilter graphFilter = new GraphFilter();
            graphFilter.setCustomerId(scan.getCustomer().getCustomerId());
            graphFilter.setActive(true);
            graphFilter.setStatuses(new String[]{"OPEN", "RISK_ACCEPTED", "RECHECK", "ON_HOLD", "IN_PROGRESS"});
            graphFilter.setRiskLevels(new int[]{1, 2, 3, 4, 5});
            VulnerabilityTimeGraph graph = dashboardService.getTodaySystemTendency(graphFilter, null, null);
            scoreNow = graph.getTotalriskPoint();
            openVulnCountNow = customerService.getVulnerabilitiesCountByCustomerId(graphFilter, null, null);
        } catch (Exception ex) {
            logger.log(LogLevel.ERROR, "Mevcut risk skorunu almada hata!" + ex);
        }

        //scana bağlı bütün target satırlarını scan process tablosundan çekiyoruz.
        List<ScanProcess> scanProcessList = pentestService.getScanProcessDetail(scanId, null, null, null);
        List<ScanAsset> combinedList = new ArrayList<>();

        //Her bir target için scan process tablosundan report id alıp rapordan xml elde ederek scan assete çevrim gerçekleştiriyoruz
        for (ScanProcess scanProcess : scanProcessList) {
            OwapsReport data = getReportXML(getReportStatus(scanProcess.getReportId()));
            combinedList.addAll(parseOwapsDataToScanAssetList(data, scan.getCustomer().getCustomerId(), scan));
        }

        for (ScanAsset sa : combinedList) {
            Asset asset = customerService.getAssetByIp(sa.getScannedIp(), scan.getCustomer().getCustomerId());
            if (asset == null) {
                Asset newAsset = new Asset();
                newAsset.setIp(sa.getScannedIp());
                newAsset.setCustomerId(scan.getCustomer().getCustomerId());
                newAsset.setOperatingSystem(sa.getOperatingSystem());
                newAsset.setHostname(sa.getNetbios());
                if (scan.getAssetGroupId() != null && !"-1".equals(scan.getAssetGroupId())) {
                    // Varlık grubu seçilmişse yeni varlığı gruba ata
                    AssetGroup group = customerService.getAssetGroupById(scan.getAssetGroupId());
                    List<AssetGroup> groups = new LinkedList<>();
                    groups.add(group);
                    newAsset.setGroups(groups);
                }
                String assetId = assetService.saveAsset(newAsset);
                sa.setAssetId(assetId);
            } else {
                if (scan.getAssetGroupId() != null && !"-1".equals(scan.getAssetGroupId())) {
                    // Varlık grubu seçilmişse mevcut varlığı gruba ata
                    String[] assetIds = {asset.getAssetId()};
                    String[] groupIds = {scan.getAssetGroupId()};
                    customerService.assignAssetsToGroup(assetIds, groupIds);
                }
                sa.setAssetId(asset.getAssetId());
            }
        }

        ToolScanResults tsr = new ToolScanResults();
        tsr.setResults(combinedList);
        tsr.setScan(scan);
        tsr.setServerType(ServerType.OWAPS);
        tsr.setScoreNow(scoreNow);
        tsr.setOpenVulnCountNow(openVulnCountNow);
        //Tüm tarayıcılar için ortak tarama sonuçlarını kaydetme, ticket, alarm, syslog işlemleri.
        pentestService.saveToolScanResults(tsr);

    }
    
    public String httpPost(String urlStr, String data) throws Exception {
        URL url = new URL(urlStr);
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setReadTimeout(30000);
        conn.setConnectTimeout(35000);
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setDoInput(true);
        conn.setUseCaches(false);
        conn.setAllowUserInteraction(false);
        //Request'i json formatında gönderiyoruz.
        conn.setRequestProperty(CONTENT_TYPE, "application/json");
        conn.setRequestProperty(X_AUTH, apiKey);

        // Create the form content
        OutputStream out = conn.getOutputStream();
        byte[] outputInBytes = data.getBytes("UTF-8");

        out.write(outputInBytes);

        out.close();

        if (conn.getResponseCode() != 200 && conn.getResponseCode() != 201 ) {
            throw new IOException(conn.getResponseCode() + " " + conn.getResponseMessage());
        }

        // Buffer the result into a string
        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();

        conn.disconnect();
        return sb.toString();
    }

    private String httpGet(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setReadTimeout(10000);
        conn.setConnectTimeout(15000);
        conn.setRequestMethod("GET");
        conn.setDoOutput(true);
        conn.setDoInput(true);
        conn.setUseCaches(false);
        conn.setAllowUserInteraction(false);

        conn.setRequestProperty(X_AUTH, apiKey);

        try {

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            return response.toString();

        } catch (IOException e) {
            logger.log(LogLevel.ERROR, "Owaps get request error!", e);
            throw e;
        }

    }

    public String httpDelete(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setReadTimeout(10000);
        conn.setConnectTimeout(15000);
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setDoInput(true);
        conn.setUseCaches(false);
        conn.setAllowUserInteraction(false);
        conn.setRequestProperty(CONTENT_TYPE, "application/json");

        if (conn.getResponseCode() != 204) {
            throw new IOException(conn.getResponseCode() + " " + conn.getResponseMessage());
        }

        // Buffer the result into a string
        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();

        conn.disconnect();
        return sb.toString();
    }

    public Integer parseSeverity(String severity) {
        if (!BizzyUtil.isEmpty(severity)) {
            switch (severity.toLowerCase()) {
                case "ınformational":
                case "informational":
                    return 0;
                case "Low":
                    return 1;
                case "Medium":
                    return 2;
                case "high":
                    return 5;
                default:
                    break;
            }

        }
        return null;
    }
    
    public String parsePluginLevel(String severity) {
        if (!BizzyUtil.isEmpty(severity)) {
            switch (severity.toLowerCase()) {
                case "ınformational":
                case "informational":
                    return "Info";
                case "low":
                    return "Low";
                case "medium":
                    return "Medium";
                case "high":
                    return "High";
                default:
                    break;
            }

        }
        return null;
    }

    public ScanStatus parseScanStatus(String status) {
        switch (status) {
            case "failed":
                return ScanStatus.ERROR;
            case "pausing":
                return ScanStatus.PAUSING;
            case "paused":
                return ScanStatus.PAUSED;
            case "aborted":
                return ScanStatus.ABORTED;
            case "completed":
                return ScanStatus.COMPLETED;
            case "scheduled":
                return ScanStatus.SCHEDULED;
            case "queued":
                return ScanStatus.QUEUED;
            case "aborting":
            case "starting":
            default:
                return ScanStatus.RUNNING;
        }
    }

    public String replaceUnsupportedTags(String html) {

        html = html.replaceAll("<text>", "<p>");
        html = html.replaceAll("</text>", "</p>");
        html = html.replaceAll("<indentText>", "<p>");
        html = html.replaceAll("</indentText>", "</p>");
        html = html.replaceAll("<link>", " <a>");
        html = html.replaceAll("<link", " <a");
        html = html.replaceAll("</link>", " </a>");
        html = html.replaceAll("target=\"", "href=\"");

        return html;
    }

    public String removeHtmlTags(String html) {
        html = html.replaceAll("<p>", "");
        html = html.replaceAll("</p>", "");
        return html;
    }

 

}

