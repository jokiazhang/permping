package com.permping.activity;

import java.util.ArrayList;
import com.permping.R;
import com.permping.controller.PermListController;
import com.permping.model.Perm;
import com.permping.utils.facebook.FacebookConnector;
import com.permping.utils.facebook.SessionEvents;
import com.permping.utils.facebook.SessionEvents.AuthListener;
import com.permping.utils.facebook.SessionStore;
import com.permping.adapter.*;
import android.view.View.OnClickListener;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;


public class FollowerActivity extends Activity {
	// The Join button
	private Button join;
	// The Login button
	private Button login;
	
	private String[] list1 = { "Icon", "Icon Creator", "Image", "Image Creator" };
	
	/*
	 * Facebook 
	 */
	private static final String FACEBOOK_APP_ID = "164668790213609";
	private static final String ACCESS_TOKEN = "access_token";
	private static final String ACCESS_EXPIRES = "access_expires";
	private static final String EMAIL = "email";
	private static final String PUBLISH_STREAM = "publish_stream";
	
	/*private Facebook facebook;
	private AsyncFacebookRunner mAsyncRunner;
	private SharedPreferences sharedPreferences;
	private Context context;*/
	
	private final Handler facebookHander = new Handler();
	private FacebookConnector facebookConnector;
	
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
        setContentView(R.layout.followers_layout);
        
        ListView permListView = (ListView) findViewById(R.id.permList);
        PermListController permListController = new PermListController();
        ArrayList<Perm> permList = permListController.getPermList();
        
        PermAdapter permListAdapter = new PermAdapter(this, R.layout.perm_item_1, permList);
        permListView.setAdapter(permListAdapter);
        
        // Initialize the facebook connection
        facebookConnector = new FacebookConnector(FACEBOOK_APP_ID, this, getApplicationContext(), new String[] {EMAIL, PUBLISH_STREAM});
        
        //facebook = new Facebook(APP_ID);
        //mAsyncRunner = new AsyncFacebookRunner(facebook);
        
        join = (Button) findViewById(R.id.bt_join);
        login = (Button) findViewById(R.id.bt_login);
        
        login.setOnClickListener(new OnClickListener() {
			
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent i = new Intent(v.getContext(), LoginPermActivity.class);
				v.getContext().startActivity(i);
			}
		});
        
        final OptionsDialog dialog = new OptionsDialog(this);
		
        // Show the dialog
		join.setOnClickListener(new OnClickListener() {
			
			public void onClick(View v) {
				dialog.show();
			}
		}); 
		
    }
    
    @Override
	protected void onResume() {
		super.onResume();
		//updateLoginStatus();
	}
    

	/**
     * Support to login to Facebook by opening facebook login window.
     *//*
    private void loginToFacebook() {
    	sharedPreferences = getPreferences(MODE_PRIVATE);
		String access_token = sharedPreferences.getString(ACCESS_TOKEN, null);
		long expires = sharedPreferences.getLong(ACCESS_EXPIRES, 0);
		
		if (access_token != null) {
			facebook.setAccessToken(access_token);
		}
		
		if (expires != 0) {
			facebook.setAccessExpires(expires);
		}
		
		if (!facebook.isSessionValid()) {
			facebook.authorize(this, new String[] {EMAIL, PUBLISH_STREAM}, 
					new Facebook.DialogListener() {
				
				@Override
				public void onFacebookError(FacebookError e) {
					// TODO Auto-generated method stub
					
				}
				
				@Override
				public void onError(DialogError e) {
					// TODO Auto-generated method stub
					
				}
				
				@Override
				public void onComplete(Bundle values) {
					// Function to handle complete event
					// Edit Preferences and update facebook access token
					SharedPreferences.Editor editor = sharedPreferences.edit();
					editor.putString(ACCESS_TOKEN, facebook.getAccessToken());
					editor.putLong(ACCESS_EXPIRES, facebook.getAccessExpires());
					editor.commit();
				}
				
				@Override
				public void onCancel() {
					// TODO Auto-generated method stub
					
				}
			});
		}
	}*/
    
    /**
     * This listener is to handle the click action of Join button
     * This should show the dialog and user can choose Facebook or Twitter login
     * or login to Permping directly.
     */
    class OptionsDialog extends Dialog implements android.view.View.OnClickListener {
    	
    	// The "Login with Facebook" button
    	private Button facebookLogin;
    	
    	// The "Login with Twitter" button
    	private Button twitterLogin;
    	
    	// The "Join Permping" button
    	private Button joinPermping;
    	
    	private SharedPreferences prefs;
    	
    	public OptionsDialog(Context context) {
    		super(context);
    		setContentView(R.layout.join_options);
    		
    		facebookLogin = (Button) findViewById(R.id.bt_login_with_facebook);
    		facebookLogin.setOnClickListener(this);
    		twitterLogin = (Button) findViewById(R.id.bt_login_with_twitter);
    		twitterLogin.setOnClickListener(this);
    		joinPermping = (Button) findViewById(R.id.bt_join_permping);
    		joinPermping.setOnClickListener(this);
    		
    		this.prefs = PreferenceManager.getDefaultSharedPreferences(context);
    	}
    	
    	public void onClick(View v) {
			if (v == facebookLogin) {
				if (!facebookConnector.getFacebook().isSessionValid()) {
					AuthListener authListener = new AuthListener() {
						
						@Override
						public void onAuthSucceed() {							
							//Edit Preferences and update facebook access token
							SharedPreferences.Editor editor = prefs.edit();
							editor.putString(ACCESS_TOKEN, facebookConnector.getFacebook().getAccessToken());
							editor.putLong(ACCESS_EXPIRES, facebookConnector.getFacebook().getAccessExpires());
							editor.commit();
						}
						
						@Override
						public void onAuthFail(String error) {
							// TODO Auto-generated method stub							
						}
					};
					
					SessionEvents.addAuthListener(authListener);
					facebookConnector.login();
				}
				this.dismiss();
			} else if (v == twitterLogin) {
				Intent i = new Intent(getContext(), PrepareRequestTokenActivity.class);
				getContext().startActivity(i);
				this.dismiss();
				
			} else { // Show Join Permping screen
				Intent i = new Intent(getContext(), JoinPermActivity.class);
				getContext().startActivity(i);
				this.dismiss();
			}			
		}
    	
    	
    	
    	/*
    	private String getTweetMsg() {
    		return "Tweeting from Android App at " + new DateFormat().toString();
    	}*/	
    }
    
}