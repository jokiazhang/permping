package com.permping.activity;

import java.util.Date;

import com.permping.R;
import com.permping.utils.twitter.TwitterUtils;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.text.format.DateFormat;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class FollowerActivity extends Activity {
	// The Join button
	private Button join;
	// The Login button
	private Button login;
	
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
        setContentView(R.layout.followers_layout);
        
        join = (Button) findViewById(R.id.bt_join);
        login = (Button) findViewById(R.id.bt_login);
        
        login.setOnClickListener(new OnClickListener() {
			
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent i = new Intent(v.		getContext(), LoginPermActivity.class);
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
				
			} else if (v == twitterLogin) {
				if (!TwitterUtils.isAuthenticated(prefs)) {
					Intent i = new Intent(getContext(), PrepareRequestTokenActivity.class);
					i.putExtra("tweet_msg", getTweetMsg());
					getContext().startActivity(i);
				}
			} else { // Show Join Permping screen
				// TODO Auto-generated method stub
				Intent i = new Intent(getContext(), JoinPermActivity.class);
				getContext().startActivity(i);
			}
		}
    	
    	private String getTweetMsg() {
    		return "Tweeting from Android App at " + new DateFormat().toString();
    	}	
    }
}