/**
 * 
 */
package com.permping.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.permping.PermpingMain;
import com.permping.TabGroupActivity;
import com.permping.model.User;
import com.permping.utils.PermUtils;

/**
 * @author Linh Nguyen
 *
 */
public class ProfileActivityGroup extends TabGroupActivity {

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		View view = getLocalActivityManager().startActivity( "ProfileActivity", new Intent(this, ProfileActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		replaceView(view);
	}
	
	public void onPause() {
		super.onPause();
	}
	
	public void onResume(){
		super.onResume();
		User user = PermUtils.isAuthenticated(getApplicationContext());
		setTabGroup(this);
        if (user != null) {
        	View view = getLocalActivityManager().startActivity( "ProfileActivity", new Intent(this, ProfileActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
    		replaceView(view);
    	} else {
			PermpingMain.showLogin();
		}
	}
}
