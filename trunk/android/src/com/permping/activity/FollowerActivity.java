package com.permping.activity;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.util.DisplayMetrics;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.ListView;

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
import com.permping.R;
import com.permping.adapter.PermAdapter;
import com.permping.controller.PermListController;
import com.permping.model.Perm;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.PermUtils;

public class FollowerActivity extends FragmentActivity {

	
	public static final String DOWNLOAD_COMPLETED = "DOWNLOAD_COMPLETED";
	public String url = "";
	public Boolean header = true;

	private ArrayList<Perm> permListMain;

	public static int screenWidth;
	public static int screenHeight;
	public static boolean isLogin = false;
	public static boolean isRefesh = true;
	int nextItem = -1;
//	FragmentManager t = ggetSupportFragmentManager();
	private ProgressDialog dialog;
	
	private int currentItemInScrollList = 0;
	
	PermAdapter permListAdapter;
	private BroadcastReceiver receiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {

			if (intent.getAction().equals(DOWNLOAD_COMPLETED)) {
				exeFollowerActivity();
			} 
		}
	};
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.followers_layout);
		IntentFilter intentFilter = new IntentFilter(DOWNLOAD_COMPLETED);
		registerReceiver(receiver, intentFilter);
		
	}

	@Override
	protected void onResume() {
		super.onResume();
		
		if(isLogin && PermpingMain.getCurrentTab() == 3){
			User user2 = PermUtils.isAuthenticated(getApplicationContext());
			if(user2 != null){
				String id = user2.getId();
				if(id != null)
					PermpingMain.gotoDiaryTab(id);
			}
			isLogin = false;
		}else if(PermpingMain.getCurrentTab() == 0 && isRefesh){
			// Get the screen's size.
			exeFollowerActivity();
		}else if(PermpingMain.getCurrentTab() == 1){
			exeFollowerActivity();
		} else if(!isRefesh){
			isRefesh = true;
		}
	}

	private void exeFollowerActivity() {
		// TODO Auto-generated method stub
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		
		
		//Set to application
		PermpingApplication state = (PermpingApplication) this.getApplication();
		if (state != null) {
			state.setDisplayMetrics(metrics);
		}
		
		
		screenHeight = metrics.heightPixels;
		screenWidth = metrics.widthPixels;

		User user = PermUtils.isAuthenticated(getApplicationContext());
		Bundle extras = getIntent().getExtras();
		if(extras != null && extras.containsKey("allcategory")){
			this.url = API.getNewPerm;
			this.header = false;
		}else if (extras != null) {
			this.url = (String) extras.get("categoryURL");
			this.header = false;
		} else if (user != null) {
			this.url = API.followingPerm + String.valueOf(user.getId());
			this.header = false;
		}
		dialog = ProgressDialog.show(getParent(), "Loading", "Please wait...",
				true);
		new LoadPermList().execute();
	}

	private void loadPerms() {
		ListView permListView = (ListView) findViewById(R.id.permList);
		User user = PermUtils.isAuthenticated(getApplicationContext());
		if(permListMain != null && !permListMain.isEmpty()){
			if(permListAdapter == null) {
			this.permListAdapter = new PermAdapter(FollowerActivityGroup.context,
					getSupportFragmentManager(),R.layout.perm_item_1, permListMain, this, screenWidth, screenHeight, header, user);
			
				permListView.setAdapter(permListAdapter);
			permListView.setOnScrollListener(new OnScrollListener() {
				
				public void onScrollStateChanged(AbsListView view, int scrollState) {
					
				}
				
				public void onScroll(AbsListView view, int firstVisibleItem,
						int visibleItemCount, int totalItemCount) {
					// TODO Auto-generated method stub
						if(currentItemInScrollList == firstVisibleItem) {
							return;
						} else {
							currentItemInScrollList = firstVisibleItem;
							if (firstVisibleItem + 1 == totalItemCount) {
						nextItem = permListAdapter.getNextItems();
								//permListAdapter.count += visibleItemCount;					
						dialog = ProgressDialog.show(getParent(), "Loading more", "Please wait...",
								true);
								
						new LoadPermList().execute();
								//permListAdapter.notifyDataSetChanged();
							}
						}
						
					}
				});
			} else {
				/*if(permListAdapter.getCount() > permListMain.size()) {
					permListAdapter.clear();
				}*/
				int nextItemCount = permListMain.size() - permListAdapter.getCount();
				int currentAdapterItemCount = permListAdapter.getCount();				
				if(nextItemCount > 0) {
					for(int i = 0; i < nextItemCount; i++) {
						permListAdapter.add(permListMain.get(currentAdapterItemCount + i));
					}
						permListAdapter.notifyDataSetChanged();
					}
				//permListAdapter.clear();
				}
			permListView.setSelection(currentItemInScrollList);			
			
		}else{
			
			
		}

	}

	
	// AsyncTask task for upload file

	class LoadPermList extends AsyncTask<ArrayList<Perm>, Void, ArrayList<Perm>> {

		@Override
		protected ArrayList<Perm> doInBackground(ArrayList<Perm>... params) {
			// TODO Auto-generated method stub
			PermListController permListController = new PermListController();
			ArrayList<Perm> permList = null;
			try {				
				if (nextItem != -1) {
					List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
					nameValuePairs.add(new BasicNameValuePair("nextItem", String.valueOf(nextItem)));
					permList = permListController.getPermList(url, nameValuePairs);
				} else {
					permList = permListController.getPermList(url);
				}
			} catch (Exception e) {
				// TODO: handle exception
			}			
			if(permListMain == null) {
			permListMain = permList;
			} else {				
				if(permList != null) {
					for(int i=0; i < permList.size(); i++) {
						permListMain.add(permList.get(i));
					}
				}
				
			}
						
			return permList;
		}

		@Override
		protected void onProgressUpdate(Void... unsued) {

		}

		@Override
		protected void onPostExecute(ArrayList< Perm> sResponse) {
			loadPerms();
			//permListMain.size();
			if (dialog != null && dialog.isShowing()) {
				dialog.dismiss();
			}
		}

	}
	
}