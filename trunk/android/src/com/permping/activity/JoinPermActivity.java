/**
 * 
 */
package com.permping.activity;

import java.util.ArrayList;
import java.util.List;

import oauth.signpost.OAuth;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
import com.permping.R;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.XMLParser;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

/**
 * @author Linh Nguyen
 * This activity supports to create new Perming account.
 */
public class JoinPermActivity extends Activity implements TextWatcher {
	Button createAccount;
	EditText name;
	EditText nickName;
	EditText userName;
	EditText email;
	EditText password;
	EditText confirmPassword;
	private SharedPreferences prefs;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        setContentView(R.layout.permping_join);
        
        prefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        
        name = (EditText) findViewById(R.id.acccountName);
		//name.addTextChangedListener(this);
        //nickName = (EditText) findViewById(R.id.nickName);
        email = (EditText) findViewById(R.id.acccountEmail);
		//email.addTextChangedListener(this);
		password = (EditText) findViewById(R.id.acccountPassword);
		//password.addTextChangedListener(this);
		confirmPassword = (EditText) findViewById(R.id.accountConfirmPassword);
        //confirmPassword.addTextChangedListener(this);
        
        createAccount = (Button) findViewById(R.id.createAccount);
        createAccount.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				// Send request to server to create new account along with its params
				List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(8);				
				nameValuePairs.add(new BasicNameValuePair("type", prefs.getString(Constants.LOGIN_TYPE, "")));
				if (prefs.getString(Constants.LOGIN_TYPE, "").equals(Constants.FACEBOOK_LOGIN)) {// Facebook
					nameValuePairs.add(new BasicNameValuePair("oauth_token", prefs.getString(Constants.ACCESS_TOKEN, "")));
					nameValuePairs.add(new BasicNameValuePair("name", name.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("username", name.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("email", email.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("password", password.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("cpassword", confirmPassword.getText().toString()));
				} else if(prefs.getString(Constants.LOGIN_TYPE, "").equals(Constants.TWITTER_LOGIN)) { // Twitter
					nameValuePairs.add(new BasicNameValuePair("oauth_token", prefs.getString(OAuth.OAUTH_TOKEN, "")));
					nameValuePairs.add(new BasicNameValuePair("oauth_token_secret", prefs.getString(OAuth.OAUTH_TOKEN_SECRET, "")));
					nameValuePairs.add(new BasicNameValuePair("name", name.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("username", name.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("email", email.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("password", password.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("cpassword", confirmPassword.getText().toString()));
				} else { // Perm
					nameValuePairs.add(new BasicNameValuePair("oauth_token", ""));
					nameValuePairs.add(new BasicNameValuePair("name", name.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("username", name.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("email", email.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("password", password.getText().toString()));
					nameValuePairs.add(new BasicNameValuePair("cpassword", confirmPassword.getText().toString()));
				}
				
				XMLParser parser = new XMLParser(API.createAccountURL, nameValuePairs);
				User user = parser.getUser();
				if (user != null) {
					// Store the user object to PermpingApplication
					PermpingApplication state = (PermpingApplication) getApplicationContext();
					state.setUser(user);
				} else {

				}
				Intent i = new Intent(v.getContext(), PermpingMain.class);
				v.getContext().startActivity(i);
			}
		});
	}
	public void afterTextChanged(Editable s) {
		// TODO Auto-generated method stub
		if (name.getText().toString().equals("")) {
			name.setError("Name is required!");
		}
		if (email.getText().toString().equals("")) {
			email.setError("Email is required!");
		}
		if (password.getText().toString().equals("")) {
			password.setError("Password is required!");
		}
		if (confirmPassword.getText().toString().equals("") || !confirmPassword.getText().toString().equals(password.getText().toString())) {
			confirmPassword.setError("Confirm password is invalid!");
		}
	}
	public void beforeTextChanged(CharSequence s, int start, int count,
			int after) {
		// TODO Auto-generated method stub
		
	}
	public void onTextChanged(CharSequence s, int start, int before, int count) {
		// TODO Auto-generated method stub
		
	}
}
