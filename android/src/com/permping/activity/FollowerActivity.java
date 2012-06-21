package com.permping.activity;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
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
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.ListView;

public class FollowerActivity extends Activity {

	

	public String url = "";
	public Boolean header = true;

	private ArrayList<Perm> permListMain;

	public static int screenWidth;
	public static int screenHeight;
	public static boolean isLogin = false;
	int nextItem = -1;

	private ProgressDialog dialog;
	
	PermAdapter permListAdapter;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.followers_layout);

	
	}

	@Override
	protected void onResume() {
		super.onResume();
		
		if(isLogin){
			User user2 = PermUtils.isAuthenticated(getApplicationContext());
			if(user2 != null){
				String id = user2.getId();
				if(id != null)
					PermpingMain.gotoDiaryTab(id);
			}
			isLogin = false;
		}else {
			// Get the screen's size.
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
			if (extras != null) {
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
	}

	private void loadPerms() {
		ListView permListView = (ListView) findViewById(R.id.permList);
		User user = PermUtils.isAuthenticated(getApplicationContext());
		if(permListMain != null && !permListMain.isEmpty()){
			this.permListAdapter = new PermAdapter(FollowerActivityGroup.context,
					R.layout.perm_item_1, permListMain, this, screenWidth, screenHeight, header, user);
			permListView.setAdapter(permListAdapter);
			permListView.setSelection(0);
			
			permListView.setOnScrollListener(new OnScrollListener() {
				
				public void onScrollStateChanged(AbsListView view, int scrollState) {
					
				}
				
				public void onScroll(AbsListView view, int firstVisibleItem,
						int visibleItemCount, int totalItemCount) {
					// TODO Auto-generated method stub
					
					boolean loadMore = firstVisibleItem + visibleItemCount >= totalItemCount;
					if (loadMore && permListAdapter != null) {
						nextItem = permListAdapter.getNextItems();
						permListAdapter.count += visibleItemCount;					
						dialog = ProgressDialog.show(getParent(), "Loading more", "Please wait...",
								true);
						new LoadPermList().execute();
						
						permListAdapter.notifyDataSetChanged();
					}
				}
			});
		}else{
			
			
		}

	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onDestroy()
	 
	@Override
	protected void onDestroy() {
		
	}
	
	private void unbindDrawables(View view) {
		if (view.getBackground() != null) {
            view.getBackground().setCallback(null);
        }
        if (view instanceof ViewGroup) {
            for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
                unbindDrawables(((ViewGroup) view).getChildAt(i));
            }
            ((ViewGroup) view).removeAllViews();
        }

	}
*/	
	
	// AsyncTask task for upload file

	class LoadPermList extends AsyncTask<Void, Void, String> {

		@Override
		protected String doInBackground(Void... params) {
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
			permListMain = permList;
						
			return null;
		}

		@Override
		protected void onProgressUpdate(Void... unsued) {

		}

		@Override
		protected void onPostExecute(String sResponse) {
			loadPerms();
			//permListMain.size();
			if (dialog != null && dialog.isShowing()) {
				dialog.dismiss();
			}
		}
	}
	
}