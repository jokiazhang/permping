package com.permping.adapter;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.permping.PermpingMain;
import com.permping.R;
import com.permping.activity.JoinPermActivity;
import com.permping.activity.LoginPermActivity;
import com.permping.activity.PrepareRequestTokenActivity;
import com.permping.controller.AuthorizeController;
import com.permping.model.Perm;
import com.permping.utils.Constants;
import com.permping.utils.UrlImageViewHelper;
import com.permping.utils.facebook.FacebookConnector;
import com.permping.utils.facebook.SessionEvents;
import com.permping.utils.facebook.SessionEvents.AuthListener;


import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.view.View.OnClickListener;



public class PermAdapter extends ArrayAdapter<Perm> {

    private ArrayList<Perm> items;
    
    public Button join;
    public Button login;
    private Activity activity ;

    private FacebookConnector facebookConnector;
    
    private SharedPreferences prefs;
    
    public PermAdapter(Context context, int textViewResourceId, ArrayList<Perm> items, Activity activity ) {
            super(context, textViewResourceId, items);
            this.activity = activity;
            this.items = items;
            facebookConnector = new FacebookConnector(Constants.FACEBOOK_APP_ID, 
            		this.activity, context, new String[] {Constants.EMAIL, Constants.PUBLISH_STREAM});
            prefs = PreferenceManager.getDefaultSharedPreferences(context);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
            View v = convertView;
            if( position == 0 )
            {
            	LayoutInflater vi = (LayoutInflater)this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                v = vi.inflate(R.layout.perm_item_2, null);
                
                //Process buttons
                join = (Button) v.findViewById(R.id.bt_join);
                login = (Button) v.findViewById(R.id.bt_login);
                login.setOnClickListener(new OnClickListener() {
        			
        			public void onClick(View v) {
        				Intent i = new Intent(v.getContext(), LoginPermActivity.class);
        				v.getContext().startActivity(i);
        			}
        		});
                
                final OptionsDialog dialog = new OptionsDialog(v.getContext());
        		
                // Show the dialog
        		join.setOnClickListener(new OnClickListener() {
        			
        			public void onClick(View v) {
        				dialog.show();
        			}
        		}); 
                
            }
            else 
            {
	            LayoutInflater vi = (LayoutInflater)this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	            v = vi.inflate(R.layout.perm_item_1, null);
	            
	            Perm o = items.get(position);
	            if (o != null) {
	            		ImageView av = (ImageView) v.findViewById(R.id.authorAvatar);
	            		UrlImageViewHelper.setUrlDrawable(av, o.getAuthor().getAvatar().getUrl() );
	            		
	            		
	            		TextView an = (TextView) v.findViewById(R.id.authorName);
	            		an.setText("name" + o.getAuthor().getName() );
	            		
	            		//Board name
	            		TextView bn = (TextView) v.findViewById(R.id.boardName );
	            		bn.setText(o.getBoard().getName() );
	            		
	            		
	                    ImageView pv = (ImageView) v.findViewById( R.id.permImage);
	                    UrlImageViewHelper.setUrlDrawable(pv, o.getImage().getUrl());
	                    
	            }
            }
            return v;
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
				// Clear FB info to show the login again
				try {
					facebookConnector.getFacebook().logout(getContext());
				} catch (MalformedURLException me) {
					me.printStackTrace();
				} catch (IOException ioe) {
					ioe.printStackTrace();
				}
				
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
							boolean existed = AuthorizeController.authorize(getContext(), nameValuePairs);
							Intent intent;
							if (existed) {
								// Forward back to Following tab
								intent = new Intent(getContext(), PermpingMain.class);
								getContext().startActivity(intent);
							} else {
								// Forward to Create account window
								intent = new Intent(getContext(), JoinPermActivity.class);
								getContext().startActivity(intent);
							}
						}
						
						public void onAuthFail(String error) {
							// TODO Auto-generated method stub							
						}
					};
					
					SessionEvents.addAuthListener(authListener);
					facebookConnector.login();
					this.dismiss();
				}
				
			} else if (v == twitterLogin) {
				Intent i = new Intent(getContext(), PrepareRequestTokenActivity.class);
				getContext().startActivity(i);
				//this.dismiss();
				
			} else { // Show Join Permping screen
				Intent i = new Intent(getContext(), JoinPermActivity.class);
				getContext().startActivity(i);
				//this.dismiss();
			}
			
			//this.dismiss();
			
		}
    }
}