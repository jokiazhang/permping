/**
 * 
 */
package com.permping;

import com.permping.model.User;

import android.app.Application;

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
	 * @return the user
	 */
	public User getUser() {
		return user;
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(User user) {
		this.user = user;
	}
}
