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
import com.permping.model.Comment;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.HttpPermUtils;
import com.permping.utils.PermUtils;
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
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.view.View.OnClickListener;

public class PermAdapter extends ArrayAdapter<Perm> {

	private ArrayList<Perm> items;

	public Button join;
	public Button login;
	public Button like;
	private Activity activity;
	private Boolean header;
	private User user;

	private FacebookConnector facebookConnector;

	private SharedPreferences prefs;

	private int screenWidth;
	private int screenHeight;

	public PermAdapter(Context context, int textViewResourceId,
			ArrayList<Perm> items, Activity activity, int screenWidth,
			int screenHeight, Boolean header) {
		super(context, textViewResourceId, items);
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

	@Override
	public View getView(int position, final View convertView, ViewGroup parent) {
		if (position == 0 && this.header == true) {
			LayoutInflater inflater = (LayoutInflater) this.getContext()
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			final View view = inflater.inflate(R.layout.perm_item_2, null);

			// Process buttons
			join = (Button) view.findViewById(R.id.bt_join);
			login = (Button) view.findViewById(R.id.bt_login);
			login.setOnClickListener(new OnClickListener() {

				public void onClick(View v) {
					Intent i = new Intent(v.getContext(),
							LoginPermActivity.class);
					v.getContext().startActivity(i);
				}
			});

			final OptionsDialog dialog = new OptionsDialog(view.getContext());

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

			final Button like = (Button) view.findViewById(R.id.btnLike);
			
			// Validate Like or Unlike
			if (perm != null) {
				if (perm.getPermUserLikeCount() != null && "0".equals(perm.getPermUserLikeCount())) {
					like.setText(Constants.LIKE);
				} else {
					like.setText(Constants.UNLIKE);
				}
			}
			
			like.setOnClickListener(new OnClickListener() {
				public void onClick(final View v) {
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
						TextView txtStatus = (TextView) view.findViewById(R.id.permStat);
						txtStatus.setText(permStatus);
					} else {
						Toast.makeText(view.getContext(), Constants.NOT_LOGIN,
								Toast.LENGTH_LONG).show();
					}
				}
			});

			if (perm != null) {
				ImageView av = (ImageView) view.findViewById(R.id.authorAvatar);
				UrlImageViewHelper.setUrlDrawable(av, perm.getAuthor().getAvatar()
						.getUrl());

				TextView an = (TextView) view.findViewById(R.id.authorName);
				an.setText(perm.getAuthor().getName());

				// Board name
				TextView bn = (TextView) view.findViewById(R.id.boardName);
				bn.setText(perm.getBoard().getName());

				ImageView pv = (ImageView) view.findViewById(R.id.permImage);
				UrlImageViewHelper.setUrlDrawable(pv, perm.getImage().getUrl());
				PermUtils.scale(pv, screenWidth, screenHeight);

				// Perm description
				TextView pd = (TextView) view.findViewById(R.id.permDesc);
				pd.setText(perm.getDescription());

				String permInfo = "via " + perm.getAuthor().getName() + " on to "
						+ perm.getBoard().getName();
				TextView pi = (TextView) view.findViewById(R.id.permInfo);
				pi.setText(permInfo);

				String permStat = "Like: " + perm.getPermLikeCount()
						+ " - Repin: " + perm.getPermRepinCount() + " - Comment: "
						+ perm.getPermCommentCount();
				TextView ps = (TextView) view.findViewById(R.id.permStat);
				ps.setText(permStat);

				LinearLayout comments = (LinearLayout) view
						.findViewById(R.id.comments);
				for (int i = 0; i < perm.getComments().size(); i++) {
					View cm = inflater.inflate(R.layout.comment_item, null);
					Comment pcm = perm.getComments().get(i);
					if (pcm != null) {

						if (pcm.getAuthor() != null) {
							ImageView cma = (ImageView) cm
									.findViewById(R.id.commentAvatar);
							UrlImageViewHelper.setUrlDrawable(cma, pcm
									.getAuthor().getAvatar().getUrl());
						}

						TextView cmt = (TextView) cm
								.findViewById(R.id.commentContent);
						cmt.setText(pcm.getContent());

						if (i == (perm.getComments().size() - 1)) {
							View sp = (View) cm.findViewById(R.id.separator);
							sp.setVisibility(View.INVISIBLE);
						}

						comments.addView(cm);
					}
				}

			}
			return view;
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
					facebookConnector.getFacebook().logout(getContext());
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
								intent = new Intent(getContext(),
										PermpingMain.class);
								getContext().startActivity(intent);
							} else {
								// Forward to Create account window
								intent = new Intent(getContext(),
										JoinPermActivity.class);
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
				Intent i = new Intent(getContext(),
						PrepareRequestTokenActivity.class);
				getContext().startActivity(i);
				this.dismiss();

			} else { // Show Join Permping screen
				prefs.edit().putString(Constants.LOGIN_TYPE,
						Constants.PERMPING_LOGIN);
				Intent i = new Intent(getContext(), JoinPermActivity.class);
				getContext().startActivity(i);
				this.dismiss();
			}

			// this.dismiss();

		}
	}
}