package com.permpings.activity;

import java.util.ArrayList;
import java.util.List;

import oauth.signpost.OAuth;
import oauth.signpost.OAuthConsumer;
import oauth.signpost.OAuthProvider;
import oauth.signpost.commonshttp.CommonsHttpOAuthConsumer;
import oauth.signpost.commonshttp.CommonsHttpOAuthProvider;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import twitter4j.http.AccessToken;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;

import com.permpings.PermpingMain;
import com.permpings.controller.AuthorizeController;
import com.permpings.interfaces.Login_delegate;
import com.permpings.utils.Constants;
import com.permpings.utils.PermUtils;
import com.permpings.utils.twitter.OAuthRequestTokenTask;

/**
 * Prepares a OAuthConsumer and OAuthProvider 
 * 
 * OAuthConsumer is configured with the consumer key & consumer secret.
 * OAuthProvider is configured with the 3 OAuth endpoints.
 * 
 * Execute the OAuthRequestTokenTask to retrieve the request, and authorize the request.
 * 
 * After the request is authorized, a callback is made here.
 * 
 */
public class PrepareRequestTokenActivity extends Activity implements Login_delegate{

	final String TAG = getClass().getName();
	
    private OAuthConsumer consumer; 
    private OAuthProvider provider;
    private Activity parentActivity;
    private Context context;  
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		context = PrepareRequestTokenActivity.this;
		parentActivity = getParent();
    	try {
    		this.consumer = new CommonsHttpOAuthConsumer(Constants.CONSUMER_KEY, Constants.CONSUMER_SECRET);
    	    this.provider = new CommonsHttpOAuthProvider(Constants.REQUEST_URL,Constants.ACCESS_URL,Constants.AUTHORIZE_URL);
    	} catch (Exception e) {
    		//Log.e(TAG, "Error creating consumer / provider",e);
		}
    	
       //Log.i(TAG, "Starting task to retrieve request token.");
		new OAuthRequestTokenTask(this,consumer,provider).execute();
	}
	public static boolean flag = false;

	/**
	 * Called when the OAuthRequestTokenTask finishes (user has authorized the request token).
	 * The callback URL will be intercepted here.
	 */
	@Override
	public void onNewIntent(Intent intent) {
		super.onNewIntent(intent); 
		flag = true;
		SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
		final Uri uri = intent.getData();
		if (uri != null && uri.toString().startsWith(Constants.OAUTH_CALLBACK_URL)) {
			//Log.i(TAG, "Callback received : " + uri);
			//Log.i(TAG, "Retrieving Access Token");
			new RetrieveAccessTokenTask(this,consumer,provider,prefs).execute(uri);
			if(!LoginPermActivity.isTwitter)
				finish();	
		}
	}
	
	public class RetrieveAccessTokenTask extends AsyncTask<Uri, Void, Void> {

		private Context	context;
		private OAuthProvider provider;
		private OAuthConsumer consumer;
		private SharedPreferences prefs;
		
		public RetrieveAccessTokenTask(Context context, OAuthConsumer consumer,OAuthProvider provider, SharedPreferences prefs) {
			this.context = context;
			this.consumer = consumer;
			this.provider = provider;
			this.prefs=prefs;
		}


		/**
		 * Retrieve the oauth_verifier, and store the oauth and oauth_token_secret 
		 * for future API calls.
		 */
		@Override
		protected Void doInBackground(Uri...params) {
			final Uri uri = params[0];
			final String oauth_verifier = uri.getQueryParameter(OAuth.OAUTH_VERIFIER);

			try {
				provider.retrieveAccessToken(consumer, oauth_verifier);

				Editor editor = prefs.edit();
				// Set the login type as Twitter
				editor.putString(Constants.LOGIN_TYPE, Constants.TWITTER_LOGIN);
//				editor.putString(OAuth.OAUTH_TOKEN, consumer.getToken());
//				editor.putString(OAuth.OAUTH_TOKEN_SECRET, consumer.getTokenSecret());
				editor.putString(OAuth.OAUTH_VERIFIER, oauth_verifier);
//				editor.commit();
				
				String token = consumer.getToken();
				String secret = consumer.getTokenSecret();
				
				consumer.setTokenWithSecret(token, secret);
				AccessToken accessToken = new AccessToken(token, secret);
				PermUtils permUtils = new PermUtils();
				permUtils.saveTwitterAccess("twitter", accessToken, getApplicationContext());
				//TODO: validate user before forwarding to new page.
				// Check on server
				if(LoginPermActivity.isTwitter){
					List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(5);
					nameValuePairs.add(new BasicNameValuePair("type", "twitter"));
					nameValuePairs.add(new BasicNameValuePair("oauth_token", token));
					nameValuePairs.add(new BasicNameValuePair("oauth_token_secret", secret));
					nameValuePairs.add(new BasicNameValuePair("oath_verifier", oauth_verifier));
					AuthorizeController authorize = new AuthorizeController(PrepareRequestTokenActivity.this);
					authorize.authorize(context, nameValuePairs);
					
				}
			
				//Log.i(TAG, "OAuth - Access Token Retrieved");
				
			} catch (Exception e) {
				//Log.e(TAG, "OAuth - Access Token Retrieval Error", e);
			}

			return null;
		}

/*
		private void executeAfterAccessTokenRetrieval() {
			String msg = getIntent().getExtras().getString("tweet_msg");
			try {
				TwitterUtils.sendTweet(prefs, msg);
			} catch (Exception e) {
				Log.e(TAG, "OAuth - Error sending to Twitter", e);
			}
		}*/
	}

	@Override
	public void on_success() {
		// TODO Auto-generated method stub
		Intent intent = new Intent(context, PermpingMain.class);
		context.startActivity(intent);
		LoginPermActivity.isTwitter =false;
		finish();
	}
	@Override
	public void on_error() {
		// TODO Auto-generated method stub
		Intent intent = new Intent(context, JoinPermActivity.class);
		context.startActivity(intent);
		LoginPermActivity.isTwitter = false;
		finish();
	}	
	
}
