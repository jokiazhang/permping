/**
 * 
 */
package com.permpings.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.permpings.PermpingMain;
import com.permpings.TabGroupActivity;
import com.permpings.model.User;
import com.permpings.utils.PermUtils;

/**
 * @author Linh Nguyen
 *
 */
public class MyDiaryActivityGroup extends TabGroupActivity {
	public static MyDiaryActivityGroup context;
	public static boolean isTabChanged = false;
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		View view = getLocalActivityManager().startActivity( "MyDiaryActivity", new Intent(this, MyDiaryActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		replaceView(view);
		context = this;
	}
	
	public void onPause() {
		super.onPause();
	}
	
	public void onResume() {
		super.onResume();
		if(isTabChanged) {
			createUI();
		}
		
	}
	
	public void createUI() {
		User user = PermUtils.isAuthenticated(getApplicationContext());
		setTabGroup(this);
        if (user != null) {
        	View view = getLocalActivityManager().startActivity( "MyDiaryActivity", new Intent(this, MyDiaryActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
    		replaceView(view);
    		clearHistory();
    	} else {
			PermpingMain.showLogin();
		}
	}
}
