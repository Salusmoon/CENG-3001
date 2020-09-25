/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tr.biznet.bizzy.owaps;

import java.io.InputStream;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import org.json.JSONException;
import org.json.JSONObject;
/**
 *
 * @author berkcan.erguncu
 */
public class OwapsXmlParser {
    
    private final XMLInputFactory xif;
    private final JAXBContext owapsOutputContext;

    public OwapsXmlParser() throws JAXBException {
        xif = XMLInputFactory.newFactory();
        xif.setProperty(XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES, false);
        xif.setProperty(XMLInputFactory.SUPPORT_DTD, false);
        owapsOutputContext = JAXBContext.newInstance(OwapsReport.class);
    }    
    public OwapsReport parseOwapsOutput(InputStream inputStream) throws JAXBException {
        Unmarshaller jaxbUnmarshaller = owapsOutputContext.createUnmarshaller();
        return (OwapsReport) jaxbUnmarshaller.unmarshal(createStreamReader(inputStream));
    }
    public OwapsReport parseOwapsOutputWithString(String content) throws JAXBException, JSONException {
        Unmarshaller jaxbUnmarshaller = owapsOutputContext.createUnmarshaller();
        StringReader reader = new StringReader(content);
        OwapsReport owapsReport = (OwapsReport) jaxbUnmarshaller.unmarshal(reader);
        return owapsReport;
    }

    private XMLStreamReader createStreamReader(InputStream inputStream) throws JAXBException {
        try {
            return xif.createXMLStreamReader(inputStream);
        } catch (XMLStreamException ex) {
            throw new JAXBException(ex);
        }
    }
}

