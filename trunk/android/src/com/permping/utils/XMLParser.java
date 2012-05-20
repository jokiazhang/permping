package com.permping.utils;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.permping.model.Perm;

public class XMLParser {
	
	//private String TAG = "XML_PARSER";
	
	private Document doc = null ;
	public XMLParser( String document ) {
		
		 //TODO Check for s  document is a url
		if( document instanceof String  ){
			this.setDoc(this.parseXMLFromUrl( document ));
		} else {
			this.setDoc(this.parseXMLFromString(document));
		}
	}
	
	
	private Document parseXMLFromUrl( String url ) {
		try {
			URL uri = new URL(url);
			URLConnection ucon = uri.openConnection();
			ucon.connect();
			InputStream in = uri.openStream();
			DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			return builder.parse(in, null);
			
		} catch ( IOException e ) {
			return null;
		} catch ( ParserConfigurationException e ) {
			return null;
		} catch( SAXException e ) {
			return null;
		}
		
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
	
	
	/**
	 * Statics method
	 */
	public ArrayList<Perm> permListFromNodeList( NodeList nodeList){
		return null;
	}
	
	
	
	
}
