/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tr.biznet.bizzy.service.server.enums;

import java.util.LinkedList;
import java.util.List;

/**
 * Specs: 
 * SCANNER, CORE, MODULE, TM, VCS, AGENT, DATABASE
 * TargetType: 
 * SCA (Source Code Analyzer), WEB, NETWORK
 * @author adem.dilbaz
 */
public enum ServerType {
	QUALYS(1,"QUALYS","SCANNER", "NETWORK"),
	NESSUS(2,"NESSUS","SCANNER", "NETWORK"),
	NETSPARKER(3,"NETSPARKER","SCANNER", "WEB"),
        NETSPARKERENT(23,"NETSPARKERENT","SCANNER", "WEB"),
        ACTIVE_DIRECTORY(4,"ACTIVE_DIRECTORY","CORE", ""),
        SMTP(5,"SMTP","CORE", ""),
        NMAP(6, "NMAP","SCANNER", "NETWORK"),
        NEXPOSE(9, "NEXPOSE","SCANNER", "NETWORK"),
        OPENVAS(11, "OPENVAS","SCANNER", "NETWORK"),
        SOBE(12, "SOBE","MODULE", ""),
        SIEM(13, "SIEM","SIEM", ""),
        ARACHNI(14, "ARACHNI","SCANNER", "WEB"),
        JIRA(15, "JIRA","TM", ""),
        ACUNETIX(16,"ACUNETIX","SCANNER", "WEB"),
        SERVICE_MANAGER(17,"SERVICE_MANAGER","TM", ""),
        FORTIFY(18,"FORTIFY","SCANNER", "SCA"),
        SVN(19,"SVN","VCS", ""),
        GIT(20,"GIT","VCS", ""),
        TFS(21,"TFS","VCS", ""),
        MS_SQL(22,"MS_SQL","DATABASE", ""),   
        CHECKMARX(23,"CHECKMARX", "SCANNER", "SCA"),
        AGENT(24,"AGENT","AGENT", ""),
        SECURITY_CENTER(25,"SECURITY_CENTER", "SCANNER", "NETWORK"),
        POSTGRESQL(26,"POSTGRESQL", "DATABASE", ""),
        SERVICE_DESK(27,"SERVICE_DESK", "TM", ""),
        OWAPS(28, "OWAPS", "SCANNER", "WEB");
        
        
    private final int id;
    private final String type;
    private final String spec;
    private final String targetType;
    
    private ServerType(int id, String type, String spec, String targetType) {
        this.id = id;
        this.type = type;
        this.spec = spec;
        this.targetType = targetType;
    }

    public String getType() {
        return type;
    }
    public String getSpec() {
        return spec;
    }
    public String getTargetType() {
        return targetType;
    }
    
    public static ServerType findWithType(String type) {
        for (ServerType v : values()) {
            if (v.getType().equals(type)) {
                return v;
            }
        }
        return null;
    }
    
    public static List<String> findWithSpec(String spec) {
        List<String> list = new LinkedList<>();
        for (ServerType v : values()) {
            if (v.getSpec().equals(spec)) {
                list.add(v.getType());
            }
        }
        return list;
    }
    public static String getTargetTypeByType(String type) {
        for (ServerType v : values()) {
            if (v.getType().equals(type)) {
                return v.getTargetType();
            }
        }
        return null;
    }
    
}
