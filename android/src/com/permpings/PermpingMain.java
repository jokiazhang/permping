package com.permpings;

import android.app.TabActivity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TabHost;
import android.widget.TabHost.OnTabChangeListener;
import android.widget.TabHost.TabSpec;

import com.permpings.activity.AudioPlayerActivity;
import com.permpings.activity.ExplorerActivityGroup;
import com.permpings.activity.FollowerActivity;
import com.permpings.activity.FollowerActivityGroup;
import com.permpings.activity.ImageActivityGroup;
import com.permpings.activity.LoginPermActivity;
import com.permpings.activity.MyDiaryActivityGroup;
import com.permpings.activity.ProfileActivityGroup;
import com.permpings.model.User;
import com.permpings.utils.PermUtils;

public class PermpingMain extends TabActivity  {
    /** Called when the activity is first created. */
	public static String UID = "121";
	private static TabHost tabHost;
	public static Context context;
	public static boolean isUserProfile = true;
	public static boolean isKakao = false;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        tabHost = getTabHost();
        context = PermpingMain.this;
        tabHost.getTabWidget().setBackgroundResource( R.drawable.tabs_background );
        
        // Tab for followers
        TabSpec followers = tabHost.newTabSpec("Followers");
        followers.setIndicator("Followers", getResources().getDrawable(R.drawable.icon_follower_tab));
        Intent followersIntent = new Intent(this, FollowerActivityGroup.class);
        followers.setContent(followersIntent);
        tabHost.addTab( followers );
        
        // Tab for Explorer
        TabSpec explorer = tabHost.newTabSpec("Explorer");
        // setting Title and Icon for the Tab
        explorer.setIndicator("Explorer", getResources().getDrawable(R.drawable.icon_explorer_tab));
        Intent explorerIntent = new Intent(this, ExplorerActivityGroup.class);
        explorer.setContent(explorerIntent);
        tabHost.addTab( explorer );
        
        // Tab for Image
        TabSpec image = tabHost.newTabSpec("Images");
        image.setIndicator("Images", getResources().getDrawable(R.drawable.icon_image_tab));
        Intent imageIntent = new Intent(this, ImageActivityGroup.class);
        image.setContent(imageIntent);
        tabHost.addTab( image );
        
        TabSpec mydiary = tabHost.newTabSpec("My Diary");
        mydiary.setIndicator("My Diary", getResources().getDrawable(R.drawable.icon_mydiary_tab));
        Intent mydiaryIntent = new Intent(this, MyDiaryActivityGroup.class);
        mydiary.setContent(mydiaryIntent);
        tabHost.addTab( mydiary );
        
        TabSpec profile = tabHost.newTabSpec("Profile");
        profile.setIndicator("Profile", getResources().getDrawable(R.drawable.icon_profile_tab));
        Intent profileIntent = new Intent(this, ProfileActivityGroup.class);
        profile.setContent(profileIntent);
        tabHost.addTab( profile );
        
        tabHost.setOnTabChangedListener(new OnTabChangeListener() {
			
			@Override
			public void onTabChanged(String tabId) {
				// TODO Auto-generated method stub
				int currentTab = PermpingMain.getCurrentTab();
		    	if( currentTab == 0){
					FollowerActivityGroup.isTabChanged = false;
					ExplorerActivityGroup.isTabChanged = true;
					ProfileActivityGroup.isTabChanged = true;
					MyDiaryActivityGroup.isTabChanged = true;
		    	}else if(currentTab == 1){
		    		FollowerActivityGroup.isTabChanged = true;
					ExplorerActivityGroup.isTabChanged = false;
					ProfileActivityGroup.isTabChanged = true;
					MyDiaryActivityGroup.isTabChanged = true;
		    	}else if(currentTab == 2){
		    		FollowerActivityGroup.isTabChanged = true;
					ExplorerActivityGroup.isTabChanged = true;
					ProfileActivityGroup.isTabChanged = true;
					MyDiaryActivityGroup.isTabChanged = true;
		    	}else if(currentTab == 3){
		    		FollowerActivityGroup.isTabChanged = true;
					ExplorerActivityGroup.isTabChanged = true;
					ProfileActivityGroup.isTabChanged = true;
					MyDiaryActivityGroup.isTabChanged = false;
		    	}else if(currentTab == 4){
		    		FollowerActivityGroup.isTabChanged = true;
					ExplorerActivityGroup.isTabChanged = true;
					ProfileActivityGroup.isTabChanged = false;
					MyDiaryActivityGroup.isTabChanged = true;
		    	}
			}
		});
        
        // Set the event for Followers tab
        tabHost.getTabWidget().getChildAt(0).setOnTouchListener(new FollowerHandler());
        
        // Set the event for Explorer tab
        tabHost.getTabWidget().getChildAt(1).setOnTouchListener(new View.OnTouchListener() {

        	@Override
    		public boolean onTouch(View v, MotionEvent event) {
        		//do whatever you need
        		ExplorerActivityGroup.group.clearHistory();
        		return false;

            }
        });
        
        // Set the event for Images tab
        tabHost.getTabWidget().getChildAt(2).setOnTouchListener(new View.OnTouchListener() {

        	@Override
    		public boolean onTouch(View v, MotionEvent event) {
        		//do whatever you need
        		ImageActivityGroup.group.clearHistory();
        		return false;

            }
        });
        
        // Set the event for MyDiary tab
        //tabHost.getTabWidget().getChildAt(3).setOnTouchListener(new ValidateHandler());
        tabHost.getTabWidget().getChildAt(3).setOnTouchListener(new View.OnTouchListener() {

        	@Override
    		public boolean onTouch(View v, MotionEvent event) {
        		//do whatever you need
        		MyDiaryActivityGroup.group.clearHistory();
        		return false;

            }
        }); 
        // Set the event for Profile tab
        tabHost.getTabWidget().getChildAt(4).setOnTouchListener(new View.OnTouchListener() {

        	@Override
    		public boolean onTouch(View v, MotionEvent event) {
        		//do whatever you need
        		ProfileActivityGroup.group.clearHistory();
        		return false;

            }
        });        
    }
    
    private class ProfileHandler implements View.OnTouchListener {
    	boolean ret = false;
    	@Override
		public boolean onTouch(View v, MotionEvent event) {
	        User user = PermUtils.isAuthenticated(getApplicationContext());
	        if (user != null) {
	        	UID = user.getId();
	        	getTabHost().setCurrentTab(4);
	        	ret = false;
	        } else {
	        	// Go to login screen
	        	getTabHost().setCurrentTab(4);
	        	showLogin();
				ret = true;
	        }
	        
	        return ret;
    	}
    }
    private class FollowerHandler implements View.OnTouchListener {
    	
    	@Override
		public boolean onTouch(View v, MotionEvent event) {
    		User user = PermUtils.isAuthenticated(getApplicationContext());
	        if (user != null) {
	        	// Load following perms of user
	        	v.findViewById(R.id.permList);
	        	
	        } else {
	        	
	        }
	        FollowerActivityGroup.group.clearHistory();
	        return false;
    	}
    }
    
    private class ValidateHandler implements View.OnTouchListener {

		@Override
		public boolean onTouch(View v, MotionEvent event) {
			boolean ret = false;
			int action = event.getAction();
			if (action == MotionEvent.ACTION_UP) {
				/** Load the information from Application (user info) when the page is loaded. */
		        User user = PermUtils.isAuthenticated(getApplicationContext());
		        if (user != null) {
		        	UID = user.getId();
		        	tabHost.setCurrentTab(4);
		        	gotoDiaryTab(null);
		        	ret = false;
		        } else {
		        	// Go to login screen
		        	gotoDiaryTab(null);
		        	showLogin();
					ret = false;
		        }
		        MyDiaryActivityGroup.group.clearHistory();
			}
			return ret;
		}

    }
    public static void showLogin(){
    	closeLoginActivity();
    	Intent myIntent = new Intent(context, LoginPermActivity.class);
    	int currentTab = tabHost.getCurrentTab();
    	if( currentTab == 0){
			View boardListView = FollowerActivityGroup.group.getLocalActivityManager() .startActivity("detail", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
			FollowerActivityGroup.group.replaceView(boardListView);
    	}else if(currentTab == 1){
			View boardListView = ExplorerActivityGroup.group.getLocalActivityManager() .startActivity("detail", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
			ExplorerActivityGroup.group.replaceView(boardListView);
    	}else if(currentTab == 2){
			View boardListView = ImageActivityGroup.group.getLocalActivityManager() .startActivity("detail", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
			ImageActivityGroup.group.replaceView(boardListView);
    	}else if(currentTab == 3){
			View boardListView = MyDiaryActivityGroup.group.getLocalActivityManager() .startActivity("detail", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
			MyDiaryActivityGroup.group.replaceViewWithoutHistory(boardListView);
    	}else if(currentTab == 4){
			View boardListView = ProfileActivityGroup.group.getLocalActivityManager() .startActivity("detail", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
			ProfileActivityGroup.group.replaceViewWithoutHistory(boardListView);
    	}
    }
    public static void back(){
    	
    	int currentTab = tabHost.getCurrentTab();
    	if( currentTab == 0){
			FollowerActivityGroup.group.back();
    	}else if(currentTab == 1){
    		//View view = ProfileActivityGroup.group.getLocalActivityManager().startActivity( "ExplorerActivity", new Intent(context, ExplorerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
			ExplorerActivityGroup.group.back();
    		//ExplorerActivityGroup.group.overrideView(view);
    	}else if(currentTab == 2){
			ImageActivityGroup.group.back();
    	}else if(currentTab == 3){
			MyDiaryActivityGroup.group.back();
    	}else if(currentTab == 4){

    		//View view = ProfileActivityGroup.group.getLocalActivityManager().startActivity( "ProfileActivity", new Intent(context, ProfileActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
			ProfileActivityGroup.group.back();
    		//ProfileActivityGroup.group.overrideView(view);

    	}
    }
	public static void gotoDiaryTab(String UID) {
		// TODO Auto-generated method stub
		tabHost.setCurrentTab(3);
	}
	public static void gotoTab(int tab, Object data){
		
		if(tab == 4){			
			//tabHost.setCurrentTab(tab);
			isUserProfile = false;
			FollowerActivityGroup.createProfileActivity(data, false);
			
			
			
		}else if(tab == 5){
//			Intent imageDetail = new Intent(context, ImageDetail.class);
//			imageDetail.putExtra("url", (String) data);
//			context.startActivity(imageDetail);
			if(FollowerActivity.loadPermList != null) {
				FollowerActivity.loadPermList.cancel(true);
			}
			String link = (String) data;
			Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(link));
			FollowerActivityGroup.context.startActivity(browserIntent);
			FollowerActivity.isRefesh = false;
		}else if(tab==2){
			tabHost.setCurrentTab(2);
		} else if(tab == 6){
			String link = (String) data;
			Intent playAudioIntent = new Intent(FollowerActivityGroup.context, AudioPlayerActivity.class);
			playAudioIntent.putExtra("url", link);
			//Log.d("permAudio=",""+link);
			FollowerActivityGroup.context.startActivity(playAudioIntent);
//			FollowerActivity.isRefesh = false;
		}
		
	}
	public static int getCurrentTab(){
		return tabHost.getCurrentTab(); 
	}
	public void on_success() {
		// TODO Auto-generated method stub
//		getTabHost().setCurrentTab(3);
	}
	public void on_error() {
		// TODO Auto-generated method stub
		
	}
	
	public static void closeLoginActivity() {
    	FollowerActivityGroup.group.getLocalActivityManager().destroyActivity("detail", true);
    	ExplorerActivityGroup.group.getLocalActivityManager().destroyActivity("detail", true);
    	ImageActivityGroup.group.getLocalActivityManager().destroyActivity("detail", true);
    	MyDiaryActivityGroup.group.getLocalActivityManager().destroyActivity("detail", true);
    	ProfileActivityGroup.group.getLocalActivityManager().destroyActivity("detail", true);
    }
	
	public static void refeshFollowerActivity() {
		if(PermpingMain.getCurrentTab() == 0) {
			FollowerActivityGroup.group.sendBroadcast("", "");					
		}
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event)
	{
	    if ((keyCode == KeyEvent.KEYCODE_BACK))
	    {
	        PermpingMain.back();
	        return true;
	    } else {
	    	return super.onKeyDown(keyCode, event);
	    }
	}
}