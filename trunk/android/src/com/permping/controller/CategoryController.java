package com.permping.controller;

import java.util.ArrayList;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import android.os.AsyncTask;

import com.permping.interfaces.get_category_delegate;
import com.permping.model.Category;
import com.permping.utils.API;
import com.permping.utils.XMLParser;

public class CategoryController {
	public static ArrayList<Category> categories = new ArrayList<Category>();
	public  get_category_delegate categoryDelegate;
	public CategoryController(get_category_delegate delegate) {
		this.categoryDelegate = delegate;
	}
	
	public ArrayList<Category> getCategoryList(){
		

		try {
			new getCategoryTask().execute(null);
		} catch (Exception e) {
			// TODO: handle exception
			return null;
		}
		return categories;
	}
	class getCategoryTask extends AsyncTask<String, String, String>{

		@Override
		protected String doInBackground(String... params) {
			// TODO Auto-generated method stub
			try {
				
				XMLParser parser = new XMLParser( API.categoryListURL, true );
				Document doc  = parser.getDoc();
				NodeList categoryList = doc.getElementsByTagName("item");			
				
				categories.add(new Category("-1", "All Catergory"));
				
				for( int i = 0; i < categoryList.getLength(); i ++ ){
					Element categoryElement = (Element) categoryList.item(i);
					
					String categoryId = categoryElement.getElementsByTagName("id").item(0).getFirstChild().getNodeValue();
					String categoryName = categoryElement.getElementsByTagName("title").item(0).getFirstChild().getNodeValue();
					
					Category cat = new Category( categoryId, categoryName );
					categories.add(cat);
					String a = categoryElement.getNodeName();
					String b = a;
				}
				return null;
			} catch (Exception e) {
				// TODO: handle exception
				return null;
			}
		}
	    protected void onPostExecute(String result) {
	        // TODO: check this.exception 
	        // TODO: do something with the feed
	    	categoryDelegate.onCompletedGetCategory(categories);
	    	
	    }
	}
}
