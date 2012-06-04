package com.permping.activity;

import java.util.ArrayList;
import com.permping.R;
import com.permping.controller.PermListController;
import com.permping.model.Perm;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.PermUtils;
import com.permping.adapter.*;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.widget.ListView;

public class FollowerActivity extends Activity {

	public String url = "";
	public Boolean header = true;

	private ArrayList<Perm> permListMain;

	int screenWidth;
	int screenHeight;

	private ProgressDialog dialog;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.followers_layout);

		// Get the screen's size.
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);

		screenHeight = metrics.heightPixels;
		screenWidth = metrics.widthPixels;

		User user = PermUtils.isAuthenticated(getApplicationContext());
		Bundle extras = getIntent().getExtras();
		if (extras != null) {
			this.url = (String) extras.get("categoryURL");
			this.header = false;
		} else if (user != null) {
			this.url = API.followingPerm + String.valueOf(user.getId());
			this.header = false;
		}
		ListView permListView = (ListView) findViewById(R.id.permList);
		/*
		 * PermListController permListController = new PermListController( );
		 * 
		 * ArrayList<Perm> permList = permListController.getPermList( url );
		 * 
		 * PermAdapter permListAdapter = new PermAdapter(FollowerActivity.this,
		 * R.layout.perm_item_1, permList, FollowerActivity.this, header);
		 * permListView.setAdapter(permListAdapter);
		 */

		dialog = ProgressDialog.show(getParent(), "Loading", "Please wait...",
				true);
		new LoadPermList().execute();
	}

	@Override
	protected void onResume() {
		super.onResume();
	}

	private void loadPerms() {
		ListView permListView = (ListView) findViewById(R.id.permList);
		User user = PermUtils.isAuthenticated(getApplicationContext());
		PermAdapter permListAdapter = new PermAdapter(FollowerActivityGroup.context,
				R.layout.perm_item_1, permListMain, this, screenWidth, screenHeight, header, user);
		permListView.setAdapter(permListAdapter);
	}

	// AsyncTask task for upload file

	class LoadPermList extends AsyncTask<Void, Void, String> {

		@Override
		protected String doInBackground(Void... params) {
			PermListController permListController = new PermListController();
			ArrayList<Perm> permList = permListController.getPermList(url);

			permListMain = permList;
			return null;
		}

		@Override
		protected void onProgressUpdate(Void... unsued) {

		}

		@Override
		protected void onPostExecute(String sResponse) {
			loadPerms();
			if (dialog.isShowing()) {
				dialog.dismiss();
			}
		}
	}
}