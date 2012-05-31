/**
 * 
 */
package com.permping.controller;

import java.util.List;

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
	
	public List<Perm> getPermsByDate(String date) {
		if (date == null || "".equals(date))
			return null;
		XMLParser parser = new XMLParser(API.getPermsByDate + date);
		return parser.getPerms();
	}
}
