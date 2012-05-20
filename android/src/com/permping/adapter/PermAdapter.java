package com.permping.adapter;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.permping.PermpingApplication;
import com.permping.R;
import com.permping.activity.JoinPermActivity;
import com.permping.activity.LoginPermActivity;
import com.permping.activity.PrepareRequestTokenActivity;
import com.permping.model.Perm;
import com.permping.model.PermBoard;
import com.permping.model.PermImage;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.UrlImageViewHelper;
import com.permping.utils.XMLParser;
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

	public boolean isError = false;
    
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
					facebookConnector.getFacebook().logout(v.getContext());
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
							editor.putString(Constants.ACCESS_TOKEN, facebookConnector.getFacebook().getAccessToken());
							editor.putLong(Constants.ACCESS_EXPIRES, facebookConnector.getFacebook().getAccessExpires());
							editor.commit();
						}
						
						public void onAuthFail(String error) {
							// TODO Auto-generated method stub							
						}
					};
					
					SessionEvents.addAuthListener(authListener);
					facebookConnector.login();
				}
				this.dismiss();
				
				// Send to server to check if the account is created
				// If existed => back to Home page (Popular screen)
				// If not existed => go to Create Account screen.
				XMLParser parser = new XMLParser(API.authorizeURL);
				Document document = parser.getDoc();
				NodeList nodes = document.getElementsByTagName("response");
				Element element = (Element) nodes.item(0);
				if (element != null) {
					String userId = null;
					String userName = null;
					PermImage userAvatar = null;
					int followings = -1;
					int friends = -1;
					List<PermBoard> boards = new ArrayList<PermBoard>();
					User user = null;
					
					String nodeName = element.getNodeName();
					if (nodeName != null && !nodeName.equals("error")) {
						/**
						 * Login success
						 */
						NodeList userInfo = element.getElementsByTagName("user");
						if (userInfo != null) {
							Element userElement = (Element) userInfo.item(0);
							if (userElement != null) {
								// Get user Id
								userId = userElement.getElementsByTagName("userId").item(0).
										getFirstChild().getNodeValue();
								// Get username
								userName = userElement.getElementsByTagName("userName").item(0).
										getFirstChild().getNodeValue();
								// Get user avatar
								userAvatar = new PermImage(userElement.getElementsByTagName("userAvatar").item(0).
										getFirstChild().getNodeValue());
								// Get number of followings
								followings = Integer.parseInt(userElement.getElementsByTagName("followings").item(0).
										getFirstChild().getNodeValue());
								// Get number of friends
								friends = Integer.parseInt(userElement.getElementsByTagName("friends").item(0).
										getFirstChild().getNodeValue());
								// Get list of boards
								NodeList userBoards = userElement.getElementsByTagName("boards");
								if (userBoards != null) {
									PermBoard permBoard;
									for (int i = 0; i < userBoards.getLength(); i++) {
										Element boardElement = (Element) userBoards.item(i);
										if (boardElement != null) {
											permBoard = new PermBoard();
											permBoard.setName(boardElement.getElementsByTagName("name").
													item(0).getFirstChild().getNodeValue());
											permBoard.setId(boardElement.getElementsByTagName("id").
													item(0).getFirstChild().getNodeValue());
											permBoard.setDescription(boardElement.getElementsByTagName("description").
													item(0).getFirstChild().getNodeValue());
											permBoard.setFollowers(Integer.parseInt(boardElement.getElementsByTagName("followers").
													item(0).getFirstChild().getNodeValue()));
											permBoard.setPins(Integer.parseInt(boardElement.getElementsByTagName("pins").
													item(0).getFirstChild().getNodeValue()));
											boards.add(permBoard);
										}
									}
								}
							}
						}
						user = new User(userId, userName, userAvatar, friends, followings, boards);
					} else {
						/**
						 * Login fail
						 */
					}
					
					// Store the user object to PermpingApplication
					PermpingApplication state = (PermpingApplication) v.getContext();
					state.setUser(user);
				}
				for (int i = 0; i < nodes.getLength(); i++) {
					element = (Element) nodes.item(i);
					if (element.getNodeName() != null && element.getNodeName().equals("error")) {
						isError = true;
						break; // exit the loop
					}
				}
				if (!isError) {
					// Parse the contents
					for (int i = 0; i < nodes.getLength(); i++) {
						element = (Element) nodes.item(i);
						if (element != null) {
							element.getNodeName();
							
						}
					}
				} else {
					
				}
				
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
    }
    
}