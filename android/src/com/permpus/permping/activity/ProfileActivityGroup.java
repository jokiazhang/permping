/**
 * 
 */
package com.permpus.permping.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;

import com.permpus.permping.PermpingMain;
import com.permpus.permping.TabGroupActivity;
import com.permpus.permping.model.Comment;
import com.permpus.permping.model.User;
import com.permpus.permping.utils.PermUtils;

/**
 * @author Linh Nguyen
 *
 */
public class ProfileActivityGroup extends TabGroupActivity {
	public static boolean isTabChanged = false;
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
		if(isTabChanged) {
			createUI();
		}
	}
	
	public void createUI() {
		ProfileActivity.commentData = null;
		ProfileActivity.isUserProfile = true;
		User user = PermUtils.isAuthenticated(getApplicationContext());
		setTabGroup(this);
        if (user != null) {
        	Comment comment = new Comment(user.getId());
			comment.setAuthor(user);
			ProfileActivity.commentData = comment;
        	View view = getLocalActivityManager().startActivity( "ProfileActivity", new Intent(this, ProfileActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
    		replaceView(view);
    		clearHistory(); 
    	} else {
    		clearHistory();
			PermpingMain.showLogin();
		}
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event)
	{		
	    if ((keyCode == KeyEvent.KEYCODE_BACK))
	    {
	    	Activity accountActivity = ProfileActivityGroup.group.getCurrentActivity();
	    	if(accountActivity instanceof AccountActivity) {
	    		return accountActivity.onKeyDown(keyCode, event);
	    	}
	        PermpingMain.back();
	        return true;
	    }
	    return super.onKeyDown(keyCode, event);
	}
}
