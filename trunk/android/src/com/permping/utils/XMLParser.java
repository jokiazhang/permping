package com.permping.utils;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public class XMLParser {
	
	private String TAG = "XML_PARSER";
	
	private Document doc = null ;
	public XMLParser( String document ) throws IOException, ParserConfigurationException, SAXException{
		 //TODO Check for s  document is a url
		if( document instanceof String  ){
			this.setDoc(this.parseXMLFromUrl( document ));
		} else {
			this.setDoc(this.parseXMLFromString(document));
		}
	}
	
	
	private Document parseXMLFromUrl( String url ) throws IOException, ParserConfigurationException, SAXException{
		
		URL uri = new URL(url);
		URLConnection ucon = uri.openConnection();
		ucon.connect();
		InputStream in = uri.openStream();
		
		DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		return builder.parse(in, null);
	}
	
	private Document parseXMLFromString( String document ){
		//TODO implement this
		return null;
	}


	public Document getDoc() {
		return doc;
	}


	public void setDoc(Document doc) {
		this.doc = doc;
	}
	
}
