/**
 * 
 */
package com.permping.controller;

import java.util.List;

import com.permping.interfaces.Get_Perm_Delegate;
import com.permping.model.Perm;
import com.permping.utils.API;
import com.permping.utils.XMLParser;

/**
 * @author Linh Nguyen
 *
 */
public class MyDiaryController {

	/**
	 * Default constructor.
	 */
	public MyDiaryController() {
		
	}
	
	public List<Perm> getPermsByDate(String date, Get_Perm_Delegate delegate) {
		if (date == null || "".equals(date))
			return null;
		XMLParser parser = new XMLParser(API.getPermsByDate + date, delegate,  XMLParser.GET_PERMS_BY_DATE);
		return parser.getPerms();
	}
}
