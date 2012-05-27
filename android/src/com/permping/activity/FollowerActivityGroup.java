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
import android.os.StrictMode;
import android.provider.SyncStateContract.Constants;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;
import android.util.Log;
import android.view.View;

public class FollowerActivityGroup extends TabGroupActivity {

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		View view = getLocalActivityManager().startActivity( "FollowerActivity", new Intent(this, FollowerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		replaceView(view);
	}

}
