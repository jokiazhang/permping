package com.permping;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class PermpingMain extends Activity {
	// The Join button
	private Button join;
	// The Login button
	private Button login;
	
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
        setContentView(R.layout.launch);
        
        join = (Button) findViewById(R.id.bt_join);
        login = (Button) findViewById(R.id.bt_login);
        
        final OptionsDialog dialog = new OptionsDialog(this);
		
        // Show the dialog
		join.setOnClickListener(new OnClickListener() {
			
			public void onClick(View v) {
				dialog.show();
			}
		});
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
    	
    	public OptionsDialog(Context context) {
    		super(context);
    		setContentView(R.layout.join_options);
    		
    		facebookLogin = (Button) findViewById(R.id.bt_login_with_facebook);
    		facebookLogin.setOnClickListener(this);
    		twitterLogin = (Button) findViewById(R.id.bt_login_with_twitter);
    		twitterLogin.setOnClickListener(this);
    		joinPermping = (Button) findViewById(R.id.bt_join_permping);
    		joinPermping.setOnClickListener(this);    		
    	}
    	
    	public void onClick(View v) {
			if (v == facebookLogin) {
				
			} else if (v == twitterLogin) {
				
			} else {
				Intent i = new Intent(getContext(), LoginPermActivity.class);
				getContext().startActivity(i);
			}
		}
    }
}