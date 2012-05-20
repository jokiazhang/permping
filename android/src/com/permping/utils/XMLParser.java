package com.permping.utils;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

import android.util.Log;

import com.permping.model.Perm;
import com.permping.model.PermBoard;
import com.permping.model.PermImage;
import com.permping.model.User;

public class XMLParser {
	
	//private String TAG = "XML_PARSER";
	
	private Document doc = null ;
	private String xml = "<empty></empty>";
	public XMLParser( String document ) {
		
		 //TODO Check for s  document is a url
		if( document instanceof String  ){
			this.setDoc(this.parseXMLFromUrl( document ));
		} else {
			this.setDoc(this.parseXMLFromString(document));
		}
	}
	
	public XMLParser( String document, Boolean DownloadFirst ){
		this.setDoc(this.parseXMLFromUrl( document , DownloadFirst ));
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
	
	
	public String getXML( String url ) {
		String line = null;

		try {

			DefaultHttpClient httpClient = new DefaultHttpClient();
			HttpPost httpPost = new HttpPost(url);

			HttpResponse httpResponse = httpClient.execute(httpPost);
			HttpEntity httpEntity = httpResponse.getEntity();
			line = EntityUtils.toString(httpEntity);

		} catch (UnsupportedEncodingException e) {
			line = "<results status=\"error\"><msg>Can't connect to server</msg></results>";
		} catch (MalformedURLException e) {
			line = "<results status=\"error\"><msg>Can't connect to server</msg></results>";
		} catch (IOException e) {
			line = "<results status=\"error\"><msg>Can't connect to server</msg></results>";
		}

		String newString = line.replace(
				"<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "");
		return newString;

	}

	private Document parseXMLFromUrl(String url, Boolean DownloadFirst ) {
		String xml = this.getXML( url );
		//String xml = API.xmlSample;
		if (xml != null) {
			this.xml = xml;
			return this.XMLfromString(xml);
		}
		return null;

	}

	public Document XMLfromString(String xml) {

		Document doc = null;

		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		try {

			DocumentBuilder db = dbf.newDocumentBuilder();

			InputSource is = new InputSource();
			is.setCharacterStream(new StringReader(xml));
			doc = db.parse(is);

		} catch (ParserConfigurationException e) {
			System.out.println("XML parse error: " + e.getMessage());
			return null;
		} catch (SAXException e) {
			System.out.println("Wrong XML file structure: " + e.getMessage());
			return null;
		} catch (IOException e) {
			System.out.println("I/O exeption: " + e.getMessage());
			return null;
		}

		return doc;

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
	
	
	
	public ArrayList<Perm> permListFromNodeList(String parentNode) {

		try { 
		    SAXParserFactory spf = SAXParserFactory.newInstance(); 
		    SAXParser sp = spf.newSAXParser(); 
		 
		    XMLReader xr = sp.getXMLReader(); 
		 
		    DataHandler dataHandler = new DataHandler(); 
		    xr.setContentHandler(dataHandler); 
		 
		    //xr.parse(new InputSource(new StringReader("<data> <section id=\"1\">bla</section> <area>lala</area> </data> "))); 
		    xr.parse(new InputSource(new StringReader(this.xml )));
		 
		    ArrayList<Perm> permList = dataHandler.getPermList(); 
		    
		    return permList;
		  } catch(ParserConfigurationException pce) { 
		    Log.e("SAX XML", "sax parse error", pce); 
		  } catch(SAXException se) { 
		    Log.e("SAX XML", "sax error", se); 
		  } catch(IOException ioe) { 
		    Log.e("SAX XML", "sax parse io error", ioe); 
		  } 
		
		
		return null;
	}


	public class DataHandler extends DefaultHandler {

		// booleans that check whether it's in a specific tag or not
		private boolean _inSection, _inArea;

		// this holds the data
		
		private Perm currentPem = null;
		private User currentUser = null;
		private ArrayList<Perm> permList = new ArrayList<Perm>();
		
		private String currentElement = "";

		public ArrayList<Perm> getPermList(){
			return this.permList;
		}

		/**
		 * This gets called when the xml document is first opened
		 * 
		 * @throws SAXException
		 */
		public void startDocument() throws SAXException {
		}

		/**
		 * Called when it's finished handling the document
		 * 
		 * @throws SAXException
		 */
		public void endDocument() throws SAXException {

		}

		/**
		 * This gets called at the start of an element. Here we're also setting
		 * the booleans to true if it's at that specific tag. (so we know where
		 * we are)
		 * 
		 * @param namespaceURI
		 * @param localName
		 * @param qName
		 * @param atts
		 * @throws SAXException
		 */
		public void startElement(String namespaceURI, String localName, String qName, Attributes atts) throws SAXException {
			
			this.currentElement = localName;
			if( this.currentElement.equals("item")){
				//Create new perm object
				this.currentPem = new Perm();
			}
			
			
		}

		/**
		 * Called at the end of the element. Setting the booleans to false, so
		 * we know that we've just left that tag.
		 * 
		 * @param namespaceURI
		 * @param localName
		 * @param qName
		 * @throws SAXException
		 */
		public void endElement(String namespaceURI, String localName, String qName) throws SAXException {
			
			if( this.currentPem != null && localName.equals("item")) {
				this.permList.add(this.currentPem );
			}
			this.currentElement = null;
			
		}

		/**
		 * Calling when we're within an element. Here we're checking to see if
		 * there is any content in the tags that we're interested in and
		 * populating it in the Config object.
		 * 
		 * @param ch
		 * @param start
		 * @param length
		 */
		public void characters(char ch[], int start, int length) {
			String chars = new String(ch, start, length);
			chars = chars.trim();
			
			
			if( this.currentPem != null ) {
				if( this.currentElement == "permId" ){
					//Perm id
					this.currentPem.setId(chars);
				} else if( this.currentElement == "permImage"){
					PermImage imageObject = new PermImage(chars);
					this.currentPem.setImage( imageObject );
					
					User permAuthor = new User("user"); 
					permAuthor.setName( "Author " );
					permAuthor.setAvatar( imageObject );
					
					this.currentPem.setAuthor(permAuthor);
					
				} else if( this.currentElement == "permCategory"){
					PermBoard permBoard  = new PermBoard( "Board ID ");
					permBoard.setName( chars );
					this.currentPem.setBoard( permBoard );
				} else if( this.currentElement == "user"){
					this.currentUser = new User();
				} else if( this.currentElement == "userId"){
					this.currentUser.setId( chars );
				} else if( this.currentElement=="userName") {
					this.currentUser.setName(chars);
				} else if( this.currentElement == "userAvatar"){
					PermImage userAvatar = new PermImage(chars);
					this.currentUser.setAvatar( userAvatar );
					this.currentPem.setAuthor( this.currentUser );
				}
			}
			
		}
	}
	
	
}
