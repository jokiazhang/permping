package com.permping.activity;

import com.permping.PermpingMain;
import com.permping.TabGroupActivity;
import com.permping.model.User;
import com.permping.utils.PermUtils;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import android.view.View;

public class FollowerActivityGroup extends TabGroupActivity {
	
	public static FollowerActivityGroup context;
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.context = this;
		//View view = getLocalActivityManager().startActivity( "FollowerActivity", new Intent(this, FollowerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		//replaceView(view);
	}
	
	public void onPause() {
		super.onPause();

	}
	
	public void onResume() {
		super.onResume();
		View view = getLocalActivityManager().startActivity( "FollowerActivity", new Intent(this, FollowerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		replaceView(view);
		clearHistory();
	}

}
