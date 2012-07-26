/**
 * 
 */
package com.permpings.controller;

import java.util.List;

import com.permpings.interfaces.Get_Perm_Delegate;
import com.permpings.model.Perm;
import com.permpings.utils.API;
import com.permpings.utils.XMLParser;

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
