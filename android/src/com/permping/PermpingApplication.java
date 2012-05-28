/**
 * 
 */
package com.permping;

import com.permping.model.User;

import android.app.Application;
import android.content.Context;

/**
 * @author Linh Nguyen
 * This class is to store the global information (data objects, variable)
 * during the Permping application is running
 */
public class PermpingApplication extends Application {
	/**
	 * The perm user stored in application context
	 */
	private User user;

	/**
	 * The current login type 
	 */
	private String loginType;
	
	/**
	 * @return the user
	 */
	public User getUser() {
		//return new User("121");
		return user;
		
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(User user) {
		this.user = user;
	}

	/**
	 * @return the loginType
	 */
	public String getLoginType() {
		return loginType;
	}

	/**
	 * @param loginType the loginType to set
	 */
	public void setLoginType(String loginType) {
		this.loginType = loginType;
	}
	
	/*
	
	private static Context context;
	public void onCreate(){
		PermpingApplication.context = getApplicationContext();
	}
	
	public static Context getAppContext(){
		return PermpingApplication.context;
	}
	
	*/
}