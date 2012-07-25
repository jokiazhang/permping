/**
 * 
 */
package com.permpus.controller;

import java.util.List;

import com.permpus.interfaces.Get_Perm_Delegate;
import com.permpus.model.Perm;
import com.permpus.utils.API;
import com.permpus.utils.XMLParser;

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
