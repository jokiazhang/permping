/**
 * 
 */
package com.permping.activity;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.permping.PermpingMain;
import com.permping.R;
import com.permping.controller.AuthorizeController;
import com.permping.utils.Constants;
import com.permping.utils.facebook.FacebookConnector;
import com.permping.utils.facebook.SessionEvents;
import com.permping.utils.facebook.SessionEvents.AuthListener;

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
	private FacebookConnector facebookConnector;
	
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
        
        // Login button
        login.setOnClickListener(new View.OnClickListener() {
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
        
        // 
        facebookConnector = new FacebookConnector(Constants.FACEBOOK_APP_ID, 
        		this, getApplicationContext(), new String[] {Constants.EMAIL, Constants.PUBLISH_STREAM});
        //Login with Facebook button
        facebookLogin.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				// Clear FB info to show the login again
				try {
					facebookConnector.getFacebook().logout(v.getContext());
				} catch (MalformedURLException me) {
					me.printStackTrace();
				} catch (IOException ioe) {
					ioe.printStackTrace();
				}
				
			    //state = (PermpingApplication) getContext().getApplicationContext();
				
				if (!facebookConnector.getFacebook().isSessionValid()) {
					AuthListener authListener = new AuthListener() {
						
						public void onAuthSucceed() {							
							//Edit Preferences and update facebook access token
							SharedPreferences.Editor editor = prefs.edit();
							editor.putString(Constants.LOGIN_TYPE, Constants.FACEBOOK_LOGIN);
							editor.putString(Constants.ACCESS_TOKEN, facebookConnector.getFacebook().getAccessToken());
							editor.putLong(Constants.ACCESS_EXPIRES, facebookConnector.getFacebook().getAccessExpires());
							editor.commit();
						

							// Check on server
							List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(4);
							nameValuePairs.add(new BasicNameValuePair("type", prefs.getString(Constants.LOGIN_TYPE, "")));
							nameValuePairs.add(new BasicNameValuePair("oauth_token", prefs.getString(Constants.ACCESS_TOKEN, "")));
							nameValuePairs.add(new BasicNameValuePair("email", ""));
							nameValuePairs.add(new BasicNameValuePair("password", ""));
							boolean existed = AuthorizeController.authorize(getApplicationContext(), nameValuePairs);
							Intent intent;
							if (existed) {
								// Forward back to Following tab
								intent = new Intent(getApplicationContext(), PermpingMain.class);
								getApplicationContext().startActivity(intent);
							} else {
								// Forward to Create account window
								intent = new Intent(getApplicationContext(), JoinPermActivity.class);
								getApplicationContext().startActivity(intent);
							}
						}
						
						public void onAuthFail(String error) {
							// TODO Auto-generated method stub							
						}
					};
					
					SessionEvents.addAuthListener(authListener);
					facebookConnector.login();
					
				}
			}
        });
        
        // Twitter Login button
        twitterLogin.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent i = new Intent(v.getContext(), PrepareRequestTokenActivity.class);
				v.getContext().startActivity(i);	
			}
		});
	}
}