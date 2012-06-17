package com.permping.adapter;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
import com.permping.R;
import com.permping.activity.AccountActivity;
import com.permping.activity.FollowerActivity;
import com.permping.activity.FollowerActivityGroup;
import com.permping.activity.GoogleMapActivity;
import com.permping.activity.JoinPermActivity;
import com.permping.activity.LoginPermActivity;
import com.permping.activity.NewPermActivity;
import com.permping.activity.PrepareRequestTokenActivity;
import com.permping.activity.ProfileActivityGroup;
import com.permping.controller.AuthorizeController;
import com.permping.model.Perm;
import com.permping.model.Comment;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.HttpPermUtils;
import com.permping.utils.ImageUtil;
import com.permping.utils.PermUtils;
import com.permping.utils.UrlImageViewHelper;
import com.permping.utils.facebook.FacebookConnector;
import com.permping.utils.facebook.SessionEvents;
import com.permping.utils.facebook.SessionEvents.AuthListener;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.hardware.Camera.PreviewCallback;

import android.os.Bundle;import android.os.AsyncTask;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.TextView;
import android.widget.Toast;
import android.view.View.OnClickListener;

public class PermAdapter extends ArrayAdapter<Perm> {

	private ArrayList<Perm> items;

	public Button join;
	public Button login;
	public Button like;
	public Button reperm;
	public Button comment;

	private Activity activity;
	private Boolean header;
	private User user;

	private FacebookConnector facebookConnector;

	private SharedPreferences prefs;

	private int screenWidth;
	private int screenHeight;
	private Context context;

	public int count = 15;
	

	private int nextItems = -1;
/*	
	PermAdapter(ArrayList<Perm> perms) {
		super(PermAdapter.getContext(), new SpecialAdapter(perms), R.layout.pending);
	}
	*/
	public PermAdapter(Context context, int textViewResourceId,
			ArrayList<Perm> items, Activity activity, int screenWidth,
			int screenHeight, Boolean header) {
		super(context, textViewResourceId, items);
		this.context = context;
		this.activity = activity;
		this.header = header;
		this.items = items;
		this.screenWidth = screenWidth;
		this.screenHeight = screenHeight;
		facebookConnector = new FacebookConnector(Constants.FACEBOOK_APP_ID,
				this.activity, context, new String[] { Constants.EMAIL,
						Constants.PUBLISH_STREAM });
		prefs = PreferenceManager.getDefaultSharedPreferences(context);
	}

	public PermAdapter(Context context, int textViewResourceId,
			ArrayList<Perm> items, Activity activity, int screenWidth,
			int screenHeight, Boolean header, User user) {
		super(context, textViewResourceId, items);
		this.context = context;
		this.activity = activity;
		this.header = header;
		this.items = items;
		this.user = user;
		this.screenWidth = screenWidth;
		this.screenHeight = screenHeight;
		facebookConnector = new FacebookConnector(Constants.FACEBOOK_APP_ID,
				this.activity, context, new String[] { Constants.EMAIL,
						Constants.PUBLISH_STREAM });
		prefs = PreferenceManager.getDefaultSharedPreferences(context);

	}

	private String getActivityGroupName() {
		// com.permping.activity.FollowerActivity

		String activityName = activity.getParent().getClass().getName()
				.replace("com.permping.activity.", "");
		return activityName;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		//ViewHolder holder;
		if (position == 0 && this.header == true) {
			LayoutInflater inflater = (LayoutInflater) this.getContext()
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			final View view = inflater.inflate(R.layout.perm_item_2, null);

			// Process buttons
			join = (Button) view.findViewById(R.id.bt_join);
			login = (Button) view.findViewById(R.id.bt_login);
			login.setOnClickListener(new OnClickListener() {

				public void onClick(View v) {
					SharedPreferences.Editor editor = prefs.edit();
					// Set default login type.
					editor.putString(Constants.LOGIN_TYPE,
							Constants.PERMPING_LOGIN);
					editor.commit();
					Intent i = new Intent(v.getContext(),
							LoginPermActivity.class)
							.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					v.getContext().startActivity(i);
				}
			});

			final OptionsDialog dialog = new OptionsDialog(context);

			// Show the dialog
			join.setOnClickListener(new OnClickListener() {

				public void onClick(View v) {
					dialog.show();
				}
			});
			return view;
		} else {
			LayoutInflater inflater = (LayoutInflater) this.getContext()
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			final View view = inflater.inflate(R.layout.perm_item_1, null);

			final Perm perm = items.get(position);

			like = (Button) view.findViewById(R.id.btnLike);
			// Validate Like or Unlike
			if (perm != null) {
				if (perm.getPermUserLikeCount() != null
						&& "0".equals(perm.getPermUserLikeCount())) {
					like.setText(Constants.LIKE);
				} else {
					like.setText(Constants.UNLIKE);
				}
			}

			like.setOnClickListener(new OnClickListener() {
				public void onClick(final View v) {
					user = PermUtils.isAuthenticated(v.getContext());
					if (user != null) {
						// final ProgressDialog dialog =
						// ProgressDialog.show(v.getContext(),
						// "Loading","Please wait...", true);

						HttpPermUtils util = new HttpPermUtils();
						List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
						nameValuePairs.add(new BasicNameValuePair("pid", String
								.valueOf(perm.getId())));
						nameValuePairs.add(new BasicNameValuePair("uid", String
								.valueOf(user.getId())));
						util.sendPostRequest(API.likeURL, nameValuePairs);

						if (v instanceof Button) {
							String label = ((Button) v).getText().toString();
							int likeCount = Integer.parseInt(perm
									.getPermLikeCount());
							if (label != null && label.equals(Constants.LIKE)) { // Like
								// Update the count
								likeCount++;
								perm.setPermLikeCount(String.valueOf(likeCount));
								// Change the text to "Unlike"
								like.setText(Constants.UNLIKE);
							} else { // Unlike
								likeCount = likeCount - 1;
								if (likeCount < 0)
									likeCount = 0;
								perm.setPermLikeCount(String.valueOf(likeCount));
								like.setText(Constants.LIKE);
							}
						}
						String permStatus = "Like: " + perm.getPermLikeCount()
								+ " - Repin: " + perm.getPermRepinCount()
								+ " - Comment: " + perm.getPermCommentCount();
						TextView txtStatus = (TextView) view
								.findViewById(R.id.permStat);
						txtStatus.setText(permStatus);
					} else {
						Toast.makeText(view.getContext(), Constants.NOT_LOGIN,
								Toast.LENGTH_LONG).show();
					}
				}
			});

			reperm = (Button) view.findViewById(R.id.btnRepem);
			reperm.setOnClickListener(new OnClickListener() {
				public void onClick(final View v) {
					user = PermUtils.isAuthenticated(v.getContext());
					if (user != null) {
						Intent myIntent = new Intent(view.getContext(),
								NewPermActivity.class);
						myIntent.putExtra("permID", (String) perm.getId());
						View repermView = FollowerActivityGroup.group
								.getLocalActivityManager()
								.startActivity(
										"BoardListActivity",
										myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP))
								.getDecorView();
						FollowerActivityGroup.group.replaceView(repermView);
					} else {
						Toast.makeText(view.getContext(), Constants.NOT_LOGIN,
								Toast.LENGTH_LONG).show();
					}
				}
			});

			comment = (Button) view.findViewById(R.id.btnComment);
			comment.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					user = PermUtils.isAuthenticated(v.getContext());
					if (user != null) {
						
						PermpingApplication state = (PermpingApplication)v.getContext().getApplicationContext();
						
						CommentDialog commentDialog = new CommentDialog( v.getContext(), perm , state.getUser() );
						commentDialog.show();
					} else {
						Toast.makeText(view.getContext(), Constants.NOT_LOGIN, Toast.LENGTH_LONG).show();
					}
				}
			});
			ImageView gotoMap = (ImageView)view.findViewById(R.id.btnLocation);
			gotoMap.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub

					Intent googleMap = new Intent(context,
							GoogleMapActivity.class);
					Bundle bundle = new Bundle();
					bundle.putFloat("lat", perm.getLat());
					bundle.putFloat("lon", perm.getLon());
					bundle.putString("thumbnail", perm.getImage().getUrl());
					googleMap.putExtra("locationData", bundle);
					Log.d("AA+++++============","========="+perm.getImage().getUrl());
					View view = FollowerActivityGroup.group.getLocalActivityManager().startActivity( "GoogleMapActivity"+perm.getId(), googleMap).getDecorView();
					FollowerActivityGroup.group.replaceView(view);

				}
			});
			/*if (convertView == null) {
				convertView = inflater.inflate(R.layout.perm_item_1, null);
				holder = new ViewHolder();
				holder.avatar = (ImageView) convertView.findViewById(R.id.authorAvatar);
				holder.authorName = (TextView) convertView.findViewById(R.id.authorName);
				holder.boardName = (TextView) convertView.findViewById(R.id.boardName);
				holder.permImage = (ImageView) convertView.findViewById(R.id.permImage);
				holder.permDesc = (TextView) convertView.findViewById(R.id.permDesc);
				holder.permInfo = (TextView) convertView.findViewById(R.id.permInfo);
				holder.permStat = (TextView) convertView.findViewById(R.id.permStat);
				holder.comments = (LinearLayout) convertView.findViewById(R.id.comments);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}*/
			
			if (perm != null) {
				
				// Set the nextItems no.
				if (perm.getNextItem() != null)
					nextItems = Integer.parseInt(perm.getNextItem());
				else
					nextItems = -1;
				
				ImageView av = (ImageView) view.findViewById(R.id.authorAvatar);
				UrlImageViewHelper.setUrlDrawable(av, perm.getAuthor()
						.getAvatar().getUrl());

				TextView an = (TextView) view.findViewById(R.id.authorName);
				//holder.authorName.setText(perm.getAuthor().getName());
				an.setText(perm.getAuthor().getName());

				// Board name
				TextView bn = (TextView) view.findViewById(R.id.boardName);
				//holder.boardName.setText(perm.getBoard().getName());
				bn.setText(perm.getBoard().getName());

				ImageView pv = (ImageView) view.findViewById(R.id.permImage);
				//ImageUtil.imageViewFromURL( pv , perm.getImage().getUrl() );
				/*
				 LinearLayout.LayoutParams layoutParams = (LayoutParams) pv.getLayoutParams();
 				layoutParams.width = 350;
 				pv.setLayoutParams(layoutParams);
 				*/
				UrlImageViewHelper.setUrlDrawable(pv, perm.getImage().getUrl() , true );
				
				//PermUtils.scaleImage(pv, screenWidth, screenHeight);

				// Perm description
				TextView pd = (TextView) view.findViewById(R.id.permDesc);
				//holder.permDesc.setText(perm.getDescription());
				pd.setText(perm.getDescription());

				String permInfo = "via " + perm.getAuthor().getName()
						+ " on to " + perm.getBoard().getName();
				TextView pi = (TextView) view.findViewById(R.id.permInfo);
				//holder.permInfo.setText(permInfo);
				pi.setText(permInfo);

				String permStat = "Like: " + perm.getPermLikeCount()
						+ " - Repin: " + perm.getPermRepinCount()
						+ " - Comment: " + perm.getPermCommentCount();
				TextView ps = (TextView) view.findViewById(R.id.permStat);
				//holder.permStat.setText(permStat);
				//holder.permStat.setText(permStat);
				ps.setText(permStat);

				LinearLayout comments = (LinearLayout) view
						.findViewById(R.id.comments);
				for (int i = 0; i < perm.getComments().size(); i++) {
					View cm = inflater.inflate(R.layout.comment_item, null);
					Comment pcm = perm.getComments().get(i);
					if (pcm != null && pcm.getAuthor() != null) {

						ImageView cma = (ImageView) cm
								.findViewById(R.id.commentAvatar);
						UrlImageViewHelper.setUrlDrawable(cma, pcm.getAuthor()
								.getAvatar().getUrl());

						TextView authorName = (TextView) cm
								.findViewById(R.id.commentAuthor);
						authorName.setText(pcm.getAuthor().getName());

						TextView cmt = (TextView) cm
								.findViewById(R.id.commentContent);
						cmt.setText(pcm.getContent());
						/*
						 * boolean isWrapped = PermUtils.isTextWrapped(activity,
						 * cmt.getText().toString(), cmt.getContext()); if
						 * (isWrapped) { cmt.setMaxLines(5);
						 * cmt.setSingleLine(false);
						 * cmt.setEllipsize(TruncateAt.MARQUEE); }
						 */
						if (i == (perm.getComments().size() - 1)) {
							View sp = (View) cm.findViewById(R.id.separator);
							sp.setVisibility(View.INVISIBLE);
						}
						/*
						 * EllipsizingTextView cmt = (EllipsizingTextView) cm
						 * .findViewById(R.id.commentContent);
						 * cmt.setText(pcm.getContent());
						 * 
						 * if (i == (perm.getComments().size() - 1)) { View sp =
						 * (View) cm.findViewById(R.id.separator);
						 * sp.setVisibility(View.INVISIBLE); }
						 */
						comments.addView(cm);
					}
				}
			}
			//return convertView;
			return view;
		}
	}
	
	
	class CommentDialog extends Dialog implements android.view.View.OnClickListener{
		
		Perm perm  = null;
		User user = null;
		
		Button btnOK = null;
		EditText txtComment = null;
		
		private ProgressDialog dialog;
		
		public CommentDialog(Context context, Perm perm, User user) {
			super(context);
			setContentView( R.layout.comment_dialog );
			this.setTitle( R.string.comment_title );
			
			this.perm = perm;
			this.user = user;
			
			btnOK = (Button) findViewById( R.id.btnOK );
			btnOK.setOnClickListener(this);
			
			txtComment = ( EditText ) findViewById( R.id.commentEditText );
			
			
		}

		@Override
		public void onClick(View v) {
			if( v == btnOK )
			{
				
				
				final String cmText = txtComment.getText().toString();
				
				AsyncTask<Void, Void, String> comment = new AsyncTask<Void, Void, String >(){

					@Override
					protected String doInBackground(Void... arg0) {
						
						HttpPermUtils util = new HttpPermUtils();
						List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
						nameValuePairs.add(new BasicNameValuePair("cmnt", cmText ) );
						nameValuePairs.add(new BasicNameValuePair("pid", perm.getId() ) );
						nameValuePairs.add(new BasicNameValuePair("uid", user.getId() ) );
						String response  = util.sendPostRequest(API.commentUrl, nameValuePairs);
						
						return response;
					}
					
					
					@Override
			  		protected void onProgressUpdate(Void... unsued) {

			  		}

			  		@Override
			  		protected void onPostExecute(String sResponse) {
			  			if (dialog.isShowing()){
			  				dialog.dismiss();
			  				Toast.makeText(context,"Added comment!",Toast.LENGTH_LONG).show();
			  			}
			  		}
					
				};
				
				if( !cmText.isEmpty() ){
					this.dismiss();
					dialog = ProgressDialog.show(context, "Uploading","Please wait...", true);
					comment.execute();
				}
				else{
					Toast.makeText(txtComment.getContext().getApplicationContext(),"Don't leave text blank!",Toast.LENGTH_LONG).show();
				}
				
			}
		}
		
	}

	/**
	 * This listener is to handle the click action of Join button This should
	 * show the dialog and user can choose Facebook or Twitter login or login to
	 * Permping directly.
	 */
	class OptionsDialog extends Dialog implements
			android.view.View.OnClickListener {

		// The "Login with Facebook" button
		private Button facebookLogin;

		// The "Login with Twitter" button
		private Button twitterLogin;

		// The "Join Permping" button
		private Button joinPermping;

		// PermpingApplication state;
		
		
		
		
		

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
					facebookConnector.getFacebook().logout(context);
				} catch (MalformedURLException me) {
					me.printStackTrace();
				} catch (IOException ioe) {
					ioe.printStackTrace();
				}

				// state = (PermpingApplication)
				// getContext().getApplicationContext();

				if (!facebookConnector.getFacebook().isSessionValid()) {
					AuthListener authListener = new AuthListener() {

						public void onAuthSucceed() {
							// Edit Preferences and update facebook access token
							SharedPreferences.Editor editor = prefs.edit();
							editor.putString(Constants.LOGIN_TYPE,
									Constants.FACEBOOK_LOGIN);
							editor.putString(Constants.ACCESS_TOKEN,
									facebookConnector.getFacebook()
											.getAccessToken());
							editor.putLong(Constants.ACCESS_EXPIRES,
									facebookConnector.getFacebook()
											.getAccessExpires());
							editor.commit();

							// Check on server
							List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(
									4);
							nameValuePairs.add(new BasicNameValuePair("type",
									prefs.getString(Constants.LOGIN_TYPE, "")));
							nameValuePairs.add(new BasicNameValuePair(
									"oauth_token", prefs.getString(
											Constants.ACCESS_TOKEN, "")));
							nameValuePairs.add(new BasicNameValuePair("email",
									""));
							nameValuePairs.add(new BasicNameValuePair(
									"password", ""));
							boolean existed = AuthorizeController.authorize(
									getContext(), nameValuePairs);
							Intent intent;
							if (existed) {
								// Forward back to Following tab
								intent = new Intent(context, PermpingMain.class);
								context.startActivity(intent);
							} else {
								// Forward to Create account window
								intent = new Intent(context,
										JoinPermActivity.class);
								context.startActivity(intent);
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
				Intent i = new Intent(context,
						PrepareRequestTokenActivity.class);
				context.startActivity(i);
				this.dismiss();

			} else { // Show Join Permping screen
				prefs.edit().putString(Constants.LOGIN_TYPE,
						Constants.PERMPING_LOGIN);
				Intent i = new Intent(context, JoinPermActivity.class);
				context.startActivity(i);
				this.dismiss();
			}

			// this.dismiss();

		}
	}
/*	
	class SpecialAdapter extends ArrayAdapter<Perm> {
		SpecialAdapter(ArrayList<Perm> perms) {
			super(PermAdapter.getContext(), R.layout.perm_item_special,
					android.R.id.text1, perms);
		}
		
		 
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			View row = super.getView(position, convertView, parent);
			return row;
		}
	}*/
	
	/**
	 * @return the count
	 */
	public int getCount() {
		return count;
	}
	

	/**
	 * @return the nextItems
	 */
	public int getNextItems() {
		return nextItems;
	}

	/**
	 * @param nextItems the nextItems to set
	 */
	public void setNextItems(int nextItems) {
		this.nextItems = nextItems;
	}

	/* (non-Javadoc)
	 * @see android.widget.ArrayAdapter#getItem(int)
	 */
	@Override
	public Perm getItem(int position) {
		// TODO Auto-generated method stub
		return super.getItem(position);
	}

	/* (non-Javadoc)
	 * @see android.widget.ArrayAdapter#getItemId(int)
	 */
	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return super.getItemId(position);
	}
	/*
	static class ViewHolder {
		ImageView avatar;
		TextView authorName;
		TextView boardName;
		ImageView permImage;
		TextView permDesc;
		TextView permInfo;
		TextView permStat;
		LinearLayout comments;
	}*/
}

