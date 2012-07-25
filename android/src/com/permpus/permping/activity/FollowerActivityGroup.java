package com.permpus.permping.activity;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.permpus.permping.TabGroupActivity;
import com.permpus.permping.controller.AuthorizeController;
import com.permpus.permping.interfaces.Login_delegate;
import com.permpus.permping.model.Comment;
import com.permpus.permping.utils.Constants;
import com.permpus.permping.utils.XMLParser;

public class FollowerActivityGroup extends TabGroupActivity implements Login_delegate {
	
	public static FollowerActivityGroup context;
	public boolean isReload = true;
	public static boolean isTabChanged = false;
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.context = this;
		//View view = getLocalActivityManager().startActivity( "FollowerActivity", new Intent(this, FollowerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		String userEmail = XMLParser.getUserEmail(this);
		String userPass = XMLParser.getUserPass(this);
		long lastTimeLogin = XMLParser.getLastTimeLogin(this);
		long timeout = System.currentTimeMillis() - lastTimeLogin;
		if(userEmail.length() > 0 && userPass.length() > 0) {
			//if(timeout < XMLParser.ACCOUNT_TIME_OUT) {
				List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(8);
				nameValuePairs.add(new BasicNameValuePair("type", Constants.LOGIN_TYPE));
				nameValuePairs.add(new BasicNameValuePair("oauth_token", ""));
				nameValuePairs.add(new BasicNameValuePair("email", userEmail));
				nameValuePairs.add(new BasicNameValuePair("password", userPass));
				AuthorizeController authorizeController = new AuthorizeController(FollowerActivityGroup.this);
				authorizeController.authorize(this, nameValuePairs);
				isReload = true;
			/*} 
			else {
				PermpingApplication state = (PermpingApplication) getApplicationContext();
				User user = state.getUser();
				if (user != null) {
					AuthorizeController authorizeController = new AuthorizeController();
					authorizeController.logout(user.getId());
					state.setUser(null);
					XMLParser.storePermpingAccount(this, "", "");
				}				
			}*/
		}
		createFollowerActivity();
		//replaceView(view);
	}
	
	public void onPause() {
		super.onPause();

	}
	
	public void onResume() {
		super.onResume();
		if(isTabChanged) {
			createFollowerActivity();
		}
		isReload = false;
	}
	
	public void createFollowerActivity() {
		View view = getLocalActivityManager().startActivity( "FollowerActivity", new Intent(this, FollowerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		replaceView(view);
		clearHistory();
	}

	public static void createProfileActivity(Object comment, boolean isUserProfile) {		
//		PermpingApplication state = (PermpingApplication) group.getApplicationContext();
//		User user = state.getUser();
//		if(user != null) 
//		{
			//group.clearHistory();
			ProfileActivity.commentData = ( Comment)comment;
			ProfileActivity.isUserProfile = false;
			View view = group.getLocalActivityManager().startActivity( "ProfileActivity", new Intent(group, ProfileActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
			setTabGroup(group);
			group.replaceView(view);
//		} else {
//			String message = "Please login";
//			Toast.makeText(group, message, message.length());
//		}
		
	}
	
	@Override
	public void on_success() {
		// TODO Auto-generated method stub
		if(isReload == false) {
			createFollowerActivity();
			isReload = true;
		}
	}

	@Override
	public void on_error() {
		// TODO Auto-generated method stub
		
	}

}
