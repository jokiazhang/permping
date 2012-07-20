package com.permping.activity;

import java.util.ArrayList;

import com.permping.R;
import com.permping.TabGroupActivity;
import com.permping.adapter.CategoryAdapter;
import com.permping.adapter.PermAdapter;
import com.permping.controller.CategoryController;
import com.permping.model.Category;

import android.app.Activity;
import android.app.ActivityGroup;
import android.content.Intent;
import android.os.Bundle;
//import android.os.StrictMode;
import android.provider.SyncStateContract.Constants;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;
import android.util.Log;
import android.view.View;

public class ExplorerActivityGroup extends TabGroupActivity {

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		//View view = getLocalActivityManager().startActivity( "ExplorerActivity", new Intent(this, ExplorerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		View view = getLocalActivityManager().startActivity( "ExplorerActivity", new Intent(this, ExplorerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		setTabGroup(this);
		replaceView(view);
		clearHistory();
		//replaceView(view);
	}
	
	public void onPause() {
		super.onPause();
	}
	
	public void onResume() {
		super.onResume();
//		View view = getLocalActivityManager().startActivity( "ExplorerActivity", new Intent(this, ExplorerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
//		setTabGroup(this);
//		replaceView(view);
//		clearHistory();
	}
	

}
