package com.permping.activity;

import com.permping.TabGroupActivity;

import android.content.Intent;
import android.os.Bundle;

import android.view.View;

public class FollowerActivityGroup extends TabGroupActivity {
	
	public static FollowerActivityGroup context;
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.context = this;
		View view = getLocalActivityManager().startActivity( "FollowerActivity", new Intent(this, FollowerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		replaceView(view);
	}

}
