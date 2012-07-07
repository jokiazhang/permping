package com.permping.adapter;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.FragmentManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
import com.permping.R;
import com.permping.activity.FollowerActivity;
import com.permping.activity.FollowerActivityGroup;
import com.permping.activity.GoogleMapActivity;
import com.permping.activity.JoinPermActivity;
import com.permping.activity.NewPermActivity;
import com.permping.activity.PrepareRequestTokenActivity;
import com.permping.controller.AuthorizeController;
import com.permping.model.Comment;
import com.permping.model.Perm;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.HttpPermUtils;
import com.permping.utils.PermUtils;
import com.permping.utils.UrlImageViewHelper;
import com.permping.utils.facebook.FacebookConnector;
import com.permping.utils.facebook.SessionEvents;
import com.permping.utils.facebook.SessionEvents.AuthListener;
import com.permping.view.ImageDetail;

public class PermAdapter extends ArrayAdapter<Perm> {

	private ArrayList<Perm> items;
	public static final String TAG = "PermAdapter";
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
	private HashMap<String, View> viewList = new HashMap<String, View>();
	public int count = 11;
	
	private FragmentManager fragmentManager;
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

	public PermAdapter(Context context,FragmentManager fragmentManager, int textViewResourceId,
			ArrayList<Perm> items, Activity activity, int screenWidth,
			int screenHeight, Boolean header, User user) {
		super(context, textViewResourceId, items);
		this.context = context;
		this.fragmentManager = fragmentManager;
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
		try {

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
						PermpingMain.showLogin();
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
			} else if(items != null && !items.isEmpty() && position < items.size()){
				if(position == items.size() - 1) {
					return createFooterView();
				}
				final Perm perm = items.get(position);
				String viewId = perm.getId();
				convertView = viewList.get(viewId);
				
				if (convertView != null){
					Log.i(TAG, "getView() convertView != null");
					addComments(convertView, perm);
					return convertView;
				}else{
					Log.i(TAG, "getView() convertView == null");
					LayoutInflater inflater = (LayoutInflater) this.getContext()
							.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
					final View view = inflater.inflate(R.layout.perm_item_1, null);
		
					like = (Button) view.findViewById(R.id.btnLike);
					// Validate Like or Unlike
					if (perm != null) {
						if (perm.getPermUserLikeCount() != null
								&& "0".equals(perm.getPermUserLikeCount())) {
							like.setText(R.string.bt_like);
						} else {
							like.setText(R.string.bt_unlike);
						}
					}
					
					final String likeString = this.getContext().getResources().getString(R.string.bt_like);
					final String repermString = this.getContext().getResources().getString(R.string.bt_reperm);
					final String commentString = this.getContext().getResources().getString(R.string.bt_comment);
		
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
								util.sendRequest(API.likeURL, nameValuePairs, false);
		
								if (v instanceof Button) {
									String label = ((Button) v).getText().toString();
									int likeCount = Integer.parseInt(perm
											.getPermLikeCount());
									if (label != null && label.equals(likeString)) { // Like
										// Update the count
										likeCount++;
										perm.setPermLikeCount(String.valueOf(likeCount));
										// Change the text to "Unlike"
										((Button)v).setText(R.string.bt_unlike);
										v.invalidate();
									} else { // Unlike
										likeCount = likeCount - 1;
										if (likeCount < 0)
											likeCount = 0;
										perm.setPermLikeCount(String.valueOf(likeCount));
										((Button)v).setText(R.string.bt_like);
										v.invalidate();
									}
								}
								
								String permStatus = likeString + ": " + perm.getPermLikeCount()
										+ " - " + repermString + ": " + perm.getPermRepinCount()
										+ " - " + commentString + ": " + perm.getPermCommentCount();
								TextView txtStatus = (TextView) view
										.findViewById(R.id.permStat);
								if(permStatus != null)
									txtStatus.setText(permStatus);
							} else {
								Toast.makeText(view.getContext(), Constants.NOT_LOGIN,
										Toast.LENGTH_LONG).show();
							}
						}
					});
					
					if(perm.getAuthor().getId().equalsIgnoreCase(user.getId())) {
						like.setVisibility(View.GONE);
					}
		
					reperm = (Button) view.findViewById(R.id.btnRepem);
					reperm.setOnClickListener(new OnClickListener() {
						public void onClick(final View v) {
							user = PermUtils.isAuthenticated(v.getContext());
							if (user != null) {
								Intent myIntent = new Intent(view.getContext(),
										NewPermActivity.class);
								myIntent.putExtra("reperm", true);
								NewPermActivity.boardList = user.getBoards();
								myIntent.putExtra("boardId", perm.getBoard().getId());
								myIntent.putExtra("boardDesc", (String) perm.getBoard().getDescription());
								myIntent.putExtra("permId", (String) perm.getId());
								myIntent.putExtra("userId", user.getId());
//								View repermView = FollowerActivityGroup.group
//										.getLocalActivityManager()
//										.startActivity(
//												"BoardListActivity",
//												myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP))
//										.getDecorView();
//								FollowerActivityGroup.group.replaceView(repermView);
							context.startActivity(myIntent);
							} else {
								Toast.makeText(view.getContext(), Constants.NOT_LOGIN,
										Toast.LENGTH_LONG).show();
							}
						}
					});
		
					comment = (Button) view.findViewById(R.id.btnComment);
					comment.setOnClickListener(new OnClickListener() {
		
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
					if(perm.getLon() ==0 && perm.getLat() == 0){
						gotoMap.setVisibility(View.GONE);
					}else{
						gotoMap.setVisibility(View.VISIBLE);
					}

					
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
						if( perm != null)
							if(perm.getAuthor() != null)
								if(perm.getAuthor().getName() != null)
									an.setText(perm.getAuthor().getName());
		
						// Board name
						TextView bn = (TextView) view.findViewById(R.id.boardName);
						//holder.boardName.setText(perm.getBoard().getName());
						if(perm.getBoard() != null)
							if( perm.getBoard().getName() != null)
								bn.setText(perm.getBoard().getName());
		
						ImageView imageView = (ImageView) view.findViewById(R.id.permImage);
						imageView.setOnClickListener(new View.OnClickListener() {
							
							public void onClick(View arg0) {
								// TODO Auto-generated method stub
//								Intent imageDetail = new Intent(context, ImageDetail.class);
//								imageDetail.putExtra("url", perm.getImage().getUrl());
//								activity.startActivity(imageDetail);
								String permUrl = perm.getImage().getUrl();
								if(permUrl != null && permUrl != "")
									PermpingMain.gotoTab(5, perm.getImage().getUrl());
//								ImageDetail detailImage = new ImageDetail(perm.getImage().getUrl());
//								if(fragmentManager != null)detailImage.show(fragmentManager, "sendEmailFrag");
							}
						});
						//thien
//						if(perm.getImage() != null){
//							if(perm.getImage().getUrl() != null)
//								new getData(perm.getImage().getUrl()).execute(imageView);
//						}
						//endthien
						/*
						 LinearLayout.LayoutParams layoutParams = (LayoutParams) pv.getLayoutParams();
		 				layoutParams.width = 350;
		 				pv.setLayoutParams(layoutParams);
		 				*/
					
						UrlImageViewHelper.setUrlDrawable(imageView, perm.getImage().getUrl() , true ); 
						//PermUtils.scaleImage(pv, screenWidth, screenHeight);
						
						// Perm description
						TextView pd = (TextView) view.findViewById(R.id.permDesc);
						//holder.permDesc.setText(perm.getDescription());
						if(perm != null)
							if(perm.getDescription() != null)
								pd.setText(perm.getDescription());
		
//			thien.messge			String permInfo = "via " + perm.getAuthor().getName()
//								+ " on to " + perm.getBoard().getName();
						String permInfo = perm.getPermDatemessage();
						TextView pi = (TextView) view.findViewById(R.id.permInfo);
						//holder.permInfo.setText(permInfo);
						if( permInfo != null)
							pi.setText(permInfo);
						
						String permStat = likeString + ": " + perm.getPermLikeCount()
								+ " - " + repermString + ": " + perm.getPermRepinCount()
								+ " - " + commentString + ": " + perm.getPermCommentCount();
						
						TextView ps = (TextView) view.findViewById(R.id.permStat);
						//holder.permStat.setText(permStat);
						//holder.permStat.setText(permStat);
						if(permStat !=null)
							ps.setText(permStat);
		
						LinearLayout comments = (LinearLayout) view
								.findViewById(R.id.comments);
						for (int i = 0; i < perm.getComments().size(); i++) {
							View cm = inflater.inflate(R.layout.comment_item, null);
							final Comment pcm = perm.getComments().get(i);
							if (pcm != null && pcm.getAuthor() != null) {
		
								ImageView cma = (ImageView) cm
										.findViewById(R.id.commentAvatar);
								cma.setOnClickListener(new View.OnClickListener() {
									
									public void onClick(View v) {
										// TODO Auto-generated method stub
										PermpingMain.gotoTab(4, pcm);
									}
								});
								UrlImageViewHelper.setUrlDrawable(cma, pcm.getAuthor()
										.getAvatar().getUrl());
		
								TextView authorName = (TextView) cm
										.findViewById(R.id.commentAuthor);
								if(pcm !=null){
									if(pcm.getAuthor() != null)
										if(pcm.getAuthor().getName() != null)
											authorName.setText(pcm.getAuthor().getName());
		
									TextView cmt = (TextView) cm
										.findViewById(R.id.commentContent);
									if(pcm.getContent() != null)
										cmt.setText(pcm.getContent());
								}
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
					viewList.put(perm.getId(), view);
					Log.d("aaa", "================"+view);
					return view;
				}
			}
			else{
				//position > items.size
				//try to create a null view				
				return createNullView();
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			Log.d("aaa", "=========asdfsfsd======="+e.toString());
			return createNullView();
		}
	}
	
	public void addComments(View view, Perm perm) {
		LinearLayout comments = (LinearLayout) view
				.findViewById(R.id.comments);
		if(perm.getComments().size() == comments.getChildCount()) {
			return;
		}
		comments.removeAllViews();
		LayoutInflater inflater = (LayoutInflater) this.getContext()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		for (int i = 0; i < perm.getComments().size(); i++) {
			View cm = inflater.inflate(R.layout.comment_item, null);
			final Comment pcm = perm.getComments().get(i);
			if (pcm != null && pcm.getAuthor() != null) {

				ImageView cma = (ImageView) cm
						.findViewById(R.id.commentAvatar);
				cma.setOnClickListener(new View.OnClickListener() {
					
					public void onClick(View v) {
						// TODO Auto-generated method stub
						PermpingMain.gotoTab(4, pcm);
					}
				});
				UrlImageViewHelper.setUrlDrawable(cma, pcm.getAuthor()
						.getAvatar().getUrl());

				TextView authorName = (TextView) cm
						.findViewById(R.id.commentAuthor);
				if(pcm !=null){
					if(pcm.getAuthor() != null)
						if(pcm.getAuthor().getName() != null)
							authorName.setText(pcm.getAuthor().getName());

					TextView cmt = (TextView) cm
						.findViewById(R.id.commentContent);
					if(pcm.getContent() != null)
						cmt.setText(pcm.getContent());
				}
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
	
	public View createFooterView() {
		final Context context = this.getContext();
		LayoutInflater inflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View footerView = inflater.inflate(R.layout.prev_next_layout, null);
		ImageButton previousButton = (ImageButton) footerView.findViewById(R.id.previous);
		previousButton.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if(activity instanceof FollowerActivity) {
					FollowerActivity follow = ((FollowerActivity)activity);
					follow.loadPreviousItems();
				}

			}
		});

	
		ImageButton nextButton = (ImageButton) footerView.findViewById(R.id.next);
		nextButton.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					if(activity instanceof FollowerActivity) {
						FollowerActivity follow = ((FollowerActivity)activity);
						follow.loadNextItems();
					}
					}
			});
		return footerView;
    
	}

	public View createNullView() {
		LayoutInflater inflater = (LayoutInflater) this.getContext()
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View view = inflater.inflate(R.layout.perm_item_1, null);
		return view;
	}
	
	private void loadImage(ImageView imageView, String url) {
		// TODO Auto-generated method stub
		
	}

	public class getData extends AsyncTask< ImageView  , String, Bitmap>{

		String imageUrl;
		ImageView imageView;
		public getData(String imageLink) {
			// TODO Auto-generated constructor stub
			super();
			imageUrl = imageLink;
		}

		@Override
		protected Bitmap doInBackground(ImageView... params) {
			// TODO Auto-generated method stub
			Bitmap bm = null;
			imageView = params[0];
			Log.d("a","==========>"+imageUrl);
			bm = PermUtils.scaleBitmap(imageUrl);
			return bm;
		}
        @Override
        protected void onPostExecute(Bitmap bitmap) {
            // TODO Auto-generated method stub
            super.onPostExecute(bitmap);   
//            Drawable bm =  imageView.getDrawable();
//            if( bm != null)
//            	((BitmapDrawable)imageView.getDrawable()).getBitmap().recycle();
//            imageView.setScaleType(ScaleType.FIT_XY);
            imageView.setImageBitmap(bitmap);
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
						String response  = util.sendRequest(API.commentUrl, nameValuePairs, false);
						
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
			  				int position = items.indexOf(perm);			  				
			  				Comment comment = new Comment(perm.getId(), cmText);
			  				comment.setAuthor(user);
			  				//perm.addCommnent(comment);
			  				items.get(position).addCommnent(comment);
			  				
			  				if(activity != null) {
			  					ListView list = (ListView) activity.findViewById(R.id.permList);
			  					if(list != null) {
			  						list.invalidateViews();
			  					}
			  				}			  				
			  			}
			  		}
					
				};
				
				if(cmText.length() > 0 ){ //!cmText.isEmpty()
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
		if(items == null) {
		return count;
	}
		return items.size();
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

