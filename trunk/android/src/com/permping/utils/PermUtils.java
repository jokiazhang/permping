/**
 * 
 */
package com.permping.utils;

import android.content.Context;

import com.permping.PermpingApplication;
import com.permping.model.User;

/**
 * @author Linh Nguyen
 *
 */
public class PermUtils {

	public static User isAuthenticated(Context context) {
		PermpingApplication state = (PermpingApplication) context;
    	if (state != null) {
    		User user = state.getUser();
    		return user;
    	}
    	
    	return null;
	}
}
