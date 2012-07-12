package com.permping.activity;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.permping.TabGroupActivity;
import com.permping.controller.AuthorizeController;
import com.permping.interfaces.Login_delegate;
import com.permping.utils.Constants;
import com.permping.utils.XMLParser;

import android.content.Intent;
import android.os.Bundle;

import android.view.View;

public class FollowerActivityGroup extends TabGroupActivity implements Login_delegate {
	
	public static FollowerActivityGroup context;
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.context = this;
		//View view = getLocalActivityManager().startActivity( "FollowerActivity", new Intent(this, FollowerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		String userEmail = XMLParser.getUserEmail(this);
		String UserPass = XMLParser.getUserPass(this);
		List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(8);
		nameValuePairs.add(new BasicNameValuePair("type", Constants.LOGIN_TYPE));
		nameValuePairs.add(new BasicNameValuePair("oauth_token", ""));
		nameValuePairs.add(new BasicNameValuePair("email", userEmail));
		nameValuePairs.add(new BasicNameValuePair("password", UserPass));
		AuthorizeController authorizeController = new AuthorizeController(FollowerActivityGroup.this);
		authorizeController.authorize(this, nameValuePairs);
		//replaceView(view);
	}
	
	public void onPause() {
		super.onPause();

	}
	
	public void onResume() {
		super.onResume();
		createFollowerActivity();
	}
	
	public void createFollowerActivity() {
		View view = getLocalActivityManager().startActivity( "FollowerActivity", new Intent(this, FollowerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		replaceView(view);
		clearHistory();
	}

	@Override
	public void on_success() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void on_error() {
		// TODO Auto-generated method stub
		
	}

}
