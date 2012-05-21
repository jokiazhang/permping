package com.permping.controller;

import java.util.ArrayList;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.permping.model.Category;
import com.permping.utils.API;
import com.permping.utils.XMLParser;

public class CategoryController {

	public CategoryController() {
		
	}
	
	public ArrayList<Category> getCategoryList(){
		
		ArrayList<Category> categories = new ArrayList<Category>();
		
		XMLParser parser = new XMLParser( API.categoryListURL, true );
		Document doc  = parser.getDoc();
		NodeList categoryList = doc.getElementsByTagName("category");
		
		for( int i = 1; i < categoryList.getLength(); i ++ ){
			Element categoryElement = (Element) categoryList.item(i);
			
			String categoryId = categoryElement.getElementsByTagName("id").item(0).getFirstChild().getNodeValue();
			String categoryName = categoryElement.getElementsByTagName("title").item(0).getFirstChild().getNodeValue();
			
			Category cat = new Category( categoryId, categoryName );
			categories.add(cat);
			String a = categoryElement.getNodeName();
			String b = a;
		}
		
		return categories;
	}
}
