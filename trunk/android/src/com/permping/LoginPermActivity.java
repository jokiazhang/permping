/**
 * 
 */
package com.permping;

import android.app.Activity;
import android.os.Bundle;

/**
 * @author Linh Nguyen
 * This activity supports to authenticate the user
 * by user-name and password. Also, it can communicate 
 * to FB and Twitter to do authentication as well
 */
public class LoginPermActivity extends Activity {
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        setContentView(R.layout.permping_login);
	}
}
