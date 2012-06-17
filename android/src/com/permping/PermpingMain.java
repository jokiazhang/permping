package com.permping;

import android.app.TabActivity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TabHost;
import android.widget.TabHost.TabSpec;

import com.permping.activity.ExplorerActivityGroup;
import com.permping.activity.FollowerActivityGroup;
import com.permping.activity.ImageActivityGroup;
import com.permping.activity.LoginPermActivity;
import com.permping.activity.MyDiaryActivityGroup;
import com.permping.activity.ProfileActivityGroup;
import com.permping.model.User;
import com.permping.utils.PermUtils;

public class PermpingMain extends TabActivity  {
    /** Called when the activity is first created. */
	private static int TAB_DIARY = 3;
	private int tab_tyle;
	public static String UID = "121";
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        TabHost tabHost = getTabHost();
        //tabHost.setBackgroundResource(R.drawable.tabs_background);
        tabHost.getTabWidget().setBackgroundResource( R.drawable.tabs_background );
        
        // Tab for followers
        TabSpec followers = tabHost.newTabSpec("Followers");
        followers.setIndicator("Followers", getResources().getDrawable(R.drawable.icon_follower_tab));
        Intent followersIntent = new Intent(this, FollowerActivityGroup.class);
        //Intent followersIntent = new Intent(this, FollowerActivity.class);
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
        
        //Remove item background
        for( int i = 0; i< tabHost.getTabWidget().getChildCount(); i ++ )
        	tabHost.getTabWidget().getChildAt(i).setBackgroundColor(  Color.TRANSPARENT );
        
        // Set the event for Profile tab
        tabHost.getTabWidget().getChildAt(4).setOnTouchListener(new ValidateHandler());
        /*tabHost.getTabWidget().getChildAt(4).setOnTouchListener(new View.OnTouchListener() {
			
			public boolean onTouch(View v, MotionEvent event) {				
				boolean ret = false;
				int action = event.getAction();
				if (action == MotionEvent.ACTION_UP) {
					*//** Load the information from Appliaction (user info) when the page is loaded. *//*
			        User user = PermUtils.isAuthenticated(getApplicationContext());
			        if (user != null) {
			        	ret = false;
			        } else {
			        	// Go to login screen
						Intent i = new Intent(getApplicationContext(), LoginPermActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						getApplicationContext().startActivity(i);
						ret = true;
			        }
				}
				return ret;
			}
		});*/
        
        // Set the event for MyDiary tab
        tabHost.getTabWidget().getChildAt(3).setOnTouchListener(new ValidateHandler());
        
        // Set the event for Followers tab
        tabHost.getTabWidget().getChildAt(0).setOnTouchListener(new FollowerHandler());
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
		        	getTabHost().setCurrentTab(3);
		        	ret = false;
		        } else {
		        	// Go to login screen
		        	tab_tyle = 3;
					Intent i = new Intent(getApplicationContext(), LoginPermActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					getApplicationContext().startActivity(i);	        	
					ret = true;
		        }
			}
			return ret;
		}

    }
	private void gotoDiaryTab(User user) {
		// TODO Auto-generated method stub
		Intent googleMap = new Intent(PermpingMain.this,
				MyDiaryActivityGroup.class);
		Bundle bundle = new Bundle();
		bundle.putString("uid",user.getId());
		googleMap.putExtra("diaryData", bundle);
		View view = MyDiaryActivityGroup.group.getLocalActivityManager().startActivity( "GoogleMapActivity"+user.getId(), googleMap).getDecorView();
		MyDiaryActivityGroup.group.replaceView(view);
	}
	public void on_success() {
		// TODO Auto-generated method stub
//		getTabHost().setCurrentTab(3);
	}
	public void on_error() {
		// TODO Auto-generated method stub
		
	}
}