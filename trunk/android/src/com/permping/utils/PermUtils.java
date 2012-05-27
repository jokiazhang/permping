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

	public static boolean isAuthenticated(Context context) {
		boolean ret = false;
		PermpingApplication state = (PermpingApplication) context;
    	if (state != null) {
    		User user = state.getUser();
    		if (user != null)
    			ret = true;
    	}
    	
    	return ret;
	}
}
