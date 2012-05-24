/**
 * 
 */
package com.permping.activity;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.permping.PermpingMain;
import com.permping.R;
import com.permping.controller.AuthorizeController;
import com.permping.utils.Constants;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

/**
 * @author Linh Nguyen
 * This activity supports to authenticate the user
 * by user-name and password. Also, it can communicate 
 * to FB and Twitter to do authentication as well
 */
public class LoginPermActivity extends Activity {
	
	EditText email;
	EditText password;
	Button facebookLogin;
	Button twitterLogin;
	Button login;
	
	SharedPreferences prefs;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        setContentView(R.layout.permping_login);
        
        prefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        
        email         = (EditText) findViewById(R.id.permEmail);
        password      = (EditText) findViewById(R.id.permPassword);
        facebookLogin = (Button) findViewById(R.id.loginfb);
        twitterLogin  = (Button) findViewById(R.id.logintw);
        login         = (Button) findViewById(R.id.loginPerm);
        
        login.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(8);
				nameValuePairs.add(new BasicNameValuePair("type", prefs.getString(Constants.LOGIN_TYPE, "")));
				nameValuePairs.add(new BasicNameValuePair("oauth_token", ""));
				nameValuePairs.add(new BasicNameValuePair("email", email.getText().toString()));
				nameValuePairs.add(new BasicNameValuePair("password", password.getText().toString()));
				
				boolean existed = AuthorizeController.authorize(v.getContext(), nameValuePairs);
				Intent intent;
				if (existed) {
					// Forward back to Following tab
					intent = new Intent(v.getContext(), PermpingMain.class);
					v.getContext().startActivity(intent);
				} else {
					// Error! Login failed!
				}
			}			
		});
	}
}