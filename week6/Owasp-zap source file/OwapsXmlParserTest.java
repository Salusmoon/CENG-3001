/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tr.biznet.bizzy.owaps;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import java.util.stream.Stream;
import javax.xml.bind.JAXBException;




/**
 *
 * @author berkcan.erguncu
 */
public class OwapsXmlParserTest {
    private OwapsXmlParser owapsxmlparser;


    public void setUp() throws JAXBException {
        owapsxmlparser = new OwapsXmlParser();
    }


    public void readWapitiOutput() throws IOException, FileNotFoundException, JAXBException {
        try (FileInputStream fileInputStream = new FileInputStream("C:\\Users\\berkcan\\Downloads\\owapszap.xml")) {
            OwapsReport owapsData = owapsxmlparser.parseOwapsOutput(fileInputStream);

            System.out.println("Target Url:" + owapsData.getTarget_url());
            System.out.println("Scan Date: " + owapsData.getScanDate());
            
            owapsData.getAlertItem().stream().map((item) -> {
                System.out.println("Plugin id: " + item.getPlugin_id());
                return item;
            }).map((item) -> {
                System.out.println("Alert: " + item.getAlert());
                return item;
            }).map((item) -> {
                System.out.println("Alert Name: " + item.getName());
                return item;
            }).map((item) -> {
                System.out.println("Risk code: " + item.getRisk_code());
                return item;
            }).map((item) -> {
                System.out.println("Confidence level: " + item.getConfidence());
                return item;
            }).map((item) -> {
                System.out.println("Risk case: " + item.getRisk_desc());
                return item;
            }).map((item) -> {
                System.out.println("description: " + item.getDesc());
                return item;
            }).map((item) -> {
                List<OwapsInstances> ins = item.getInstances();
                for(int i = 0; i< ins.size(); i++ ){
                    System.out.println("URL: " + ins.get(i).getUrl());
                    System.out.println("Method: " + ins.get(i).getMethod());
                    System.out.println("Evidence: " + ins.get(i).getEvidence());
                }
                return item;
            }).map((item) -> {
                System.out.println("Count: " + item.getCount());
                return item;
            }).map((item) -> {
                System.out.println("Solution " + item.getSolution());
                return item;
            }).map((item) -> {
                System.out.println("Reference: " + item.getReference());
                return item;
            }).map((item) -> {
                System.out.println("cweid " + item.getCweid());
                return item;
            }).map((item) -> {
                System.out.println("wascid: " + item.getWascid());
                return item;
            }).map((item) -> {
                System.out.println("sourceid " + item.getSourceid());
                return item;
            });
                
                
                
           /* owapsData.getInstances().stream().map((item) -> {
                System.out.println("Zafiyet URL: " + item.getUrl());
                return item;
            }).map((item) -> {
                System.out.println("Zafiyet Methodu: " + item.getMethod());
                return item;
            }).map((item) -> {
                System.out.println("Zafiyet Kanıtı " + item.getEvidence());
                return item;
            }); */

        }
    }

}
