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
import android.graphics.Typeface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.util.DisplayMetrics;

import android.view.KeyEvent;
import android.widget.AbsListView;
import android.widget.TextView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.ListView;

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
import com.permping.R;
import com.permping.TabGroupActivity;
import com.permping.adapter.PermAdapter;
import com.permping.controller.PermListController;
import com.permping.interfaces.Login_delegate;
import com.permping.model.Perm;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.PermUtils;
import com.permping.utils.UrlImageViewHelper;

public class FollowerActivity extends FragmentActivity implements Login_delegate{

	
	public static final String DOWNLOAD_COMPLETED = "DOWNLOAD_COMPLETED";
	public String url = "";
	public Boolean header = true;

	private ArrayList<Perm> permListMain;

	public static int screenWidth;
	public static int screenHeight;
	public static boolean isLogin = false;
	public static boolean isRefesh = true;
	public static boolean isCalendar = false;
	int nextItem = -1;
//	FragmentManager t = ggetSupportFragmentManager();
	private ProgressDialog dialog;
	
	ListView permListView;
	
	PermAdapter permListAdapter;
	
	public static LoadPermList loadPermList;
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
		
		TextView textView = (TextView)findViewById(R.id.permpingTitle);
		Typeface tf = Typeface.createFromAsset(getAssets(), "ufonts.com_franklin-gothic-demi-cond-2.ttf");
		if(textView != null) {
			textView.setTypeface(tf);
		}
		
		IntentFilter intentFilter = new IntentFilter(DOWNLOAD_COMPLETED);
		registerReceiver(receiver, intentFilter);
		
		permListView = (ListView) findViewById(R.id.permList);
		
		PermUtils.clearViewHistory();
		loadPermList = new LoadPermList();
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
		}else if(PermpingMain.getCurrentTab() == 1 || PermpingMain.getCurrentTab() == 4){
			exeFollowerActivity();
		}else if(PermpingMain.getCurrentTab() == 3) { 
			isCalendar = true;
			exeFollowerActivity();
		}else if(!isRefesh){
			isRefesh = true;
		}
	}
	
	protected void onPause () {
    	super.onPause();
    	clearData();
    	if (dialog != null && dialog.isShowing()) {
			dialog.dismiss();
		}
    }

	public void exeFollowerActivity() {
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
		}else if( extras != null && extras.containsKey("permByDate")){
			this.url = (String)extras.getString("permByDate");
			this.header = false;
		}else if (extras != null) {
			this.url = (String) extras.get("categoryURL");
			this.header = false;
		} else if (user != null) {
			this.url = API.followingPerm + String.valueOf(user.getId());
			this.header = false;
		}
		clearData();
		dialog = ProgressDialog.show(getParent(), "Loading", "Please wait...",
				true);
		loadPermList = new LoadPermList();
		loadPermList.execute();
	}
	
	
	public void loadPreviousItems() {
		if(nextItem > -1) {
			nextItem = nextItem - 1;
			//loadItems("Loading previous");
			clearData();
			dialog = ProgressDialog.show(getParent(), "Loading previous", "Please wait...",
	    			true);
			
			loadPermList = new LoadPermList();
			loadPermList.execute();
		}
		
	}

	public void loadNextItems() {
		if(permListAdapter != null) {
			nextItem = permListAdapter.getNextItems();
			clearData();
	    	dialog = ProgressDialog.show(getParent(), "Loading more", "Please wait...",
	    			true);
			
	    	loadPermList = new LoadPermList();
			loadPermList.execute();
		}		
	}
	
	public void cancelLoadPermList() {
		if(loadPermList != null) {
			loadPermList.cancel(true);
		}
	}
	
	private void loadPerms() {
		User user = PermUtils.isAuthenticated(getApplicationContext());		
		if(permListMain != null && !permListMain.isEmpty()){
			clearData();
			this.permListAdapter = new PermAdapter(FollowerActivityGroup.context,
					getSupportFragmentManager(),R.layout.perm_item_1, permListMain, this, screenWidth, screenHeight, header, user);
			permListView.setAdapter(permListAdapter);
			permListView.setSelection(0);	
		}else{
			
			
		}

	}
	
	public void clearData() {
		if(permListAdapter != null && !permListAdapter.isEmpty()) {
			permListAdapter.clear();
			UrlImageViewHelper.clearAllImageView();				
		}
	}

	
	// AsyncTask task for upload file

	public class LoadPermList extends AsyncTask<ArrayList<Perm>, Void, ArrayList<Perm>> {

		@Override
		protected ArrayList<Perm> doInBackground(ArrayList<Perm>... params) {
			// TODO Auto-generated method stub
			PermListController permListController = new PermListController();
			ArrayList<Perm> permList = null;
			try {				
				if (nextItem != -1) {
					List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
					nameValuePairs.add(new BasicNameValuePair("nextItem", String.valueOf(nextItem)));
					if(isCalendar){
						nameValuePairs.add(new BasicNameValuePair("uid", PermpingMain.UID));
						isCalendar =false;
					}

					permList = permListController.getPermList(url, nameValuePairs);
				} else {
					if(isCalendar){
						List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
						nameValuePairs.add(new BasicNameValuePair("uid", PermpingMain.UID));
						permList = permListController.getPermList(url,nameValuePairs);
						isCalendar =false;
					}else{
						permList = permListController.getPermList(url);	
					}
					
				}
			} catch (Exception e) {
				// TODO: handle exception
				if (dialog != null && dialog.isShowing()) {
					dialog.dismiss();
				}
			}			
			permListMain = permList;
						
			return permListMain;
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
			permListAdapter.notifyDataSetChanged();
		}

	}
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event)
	{
	    if ((keyCode == KeyEvent.KEYCODE_BACK))
	    {
	        PermpingMain.back();
	        return true;
	    }
	    return super.onKeyDown(keyCode, event);
	}

	@Override
	public void on_success() {
		// TODO Auto-generated method stub
		PermpingMain.refeshFollowerActivity();
	}

	@Override
	public void on_error() {
		// TODO Auto-generated method stub
		//Logger.appendLog("test log", "loginerror");
		Intent intent = new Intent(getApplicationContext(), JoinPermActivity.class);
		this.startActivity(intent);		
	}
}