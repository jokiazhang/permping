/**
 * 
 */
package com.permping.utils;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import twitter4j.http.AccessToken;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.permping.PermpingApplication;
import com.permping.activity.ExplorerActivityGroup;
import com.permping.activity.FollowerActivity;
import com.permping.activity.FollowerActivityGroup;
import com.permping.activity.ImageActivityGroup;
import com.permping.activity.MyDiaryActivityGroup;
import com.permping.activity.NewPermActivity;
import com.permping.activity.ProfileActivityGroup;
import com.permping.model.User;
import com.permping.utils.facebook.sdk.DialogError;
import com.permping.utils.facebook.sdk.Facebook;
import com.permping.utils.facebook.sdk.Facebook.DialogListener;
import com.permping.utils.facebook.sdk.FacebookError;

/**
 * @author Linh Nguyen
 * 
 */
public class PermUtils {

	public static User isAuthenticated(Context context) {
		PermpingApplication state = (PermpingApplication) context
				.getApplicationContext();
		if (state != null) {
			User user = state.getUser();
			return user;
		}

		return null;
	}

	public static void clearViewHistory() {
		/*ExplorerActivityGroup.group.clearHistory();
		FollowerActivityGroup.group.clearHistory();
		ImageActivityGroup.group.clearHistory();
		ProfileActivityGroup.group.clearHistory();
		MyDiaryActivityGroup.group.clearHistory();*/
	}

	/**
	 * calculate image size
	 */
	public static void calculateImageSize(Context context) {
		PermpingApplication state = (PermpingApplication) context;
		if (state != null) {
			DisplayMetrics metrics = state.getDisplayMetrics();
			int screenWidth = metrics.widthPixels;
			int screenHeight = metrics.heightPixels;

		}
		// return null;
	}

	/**
	 * Scale the ImageView based on the screen's resolution
	 * 
	 * @param imageView
	 *            the ImageView object
	 * @param screenWidth
	 *            the screen'width which the view is displayed.
	 * @param screenHeight
	 *            the screen's height which the view is displayed.
	 */
	public static void scaleImage(ImageView view, int screenWidth,
			int screenHeight) {
		// Get the ImageView and its bitmap
		Drawable drawing = view.getDrawable();
		if (drawing != null) {
			Bitmap bitmap = ((BitmapDrawable) drawing).getBitmap();
			if (bitmap != null) {
				// Get current dimensions
				int width = bitmap.getWidth();
				int height = bitmap.getHeight();
				// float boundBoxInDp = 500;
				float desiredWidth = 500;
				float desiredHeight = 500;
				if (width <= 560) { // image width <= 560 pixel
					if (screenWidth == 320 && screenHeight == 480) {
						desiredWidth = ((float) width / 560) * 304;
						desiredHeight = ((float) height / 560) * 304;
					} else if (screenWidth == 480 && screenHeight == 800) {
						desiredWidth = ((float) width / 560) * 456;
						desiredHeight = ((float) height / 560) * 456;
					} else if (screenWidth == 800 && screenHeight == 1280) {
						desiredWidth = ((float) width / 560) * 760;
						desiredHeight = ((float) height / 560) * 760;
					} else { // Other resolution

					}
				} else { // image width > 560 pixel
					if (screenWidth == 320 && screenHeight == 480) {
						desiredWidth = 304;
						desiredHeight = (float) height * 304 / (float) width;
					} else if (screenWidth == 480 && screenHeight == 800) {
						desiredWidth = 456;
						desiredHeight = (float) height * 456 / (float) width;
					} else if (screenWidth == 800 && screenHeight == 1280) {
						desiredWidth = 760;
						desiredHeight = (float) height * 760 / (float) width;
					} else { // Other resolution

					}
				}
				// Determine how much to scale: the dimension requiring less
				// scaling is
				// closer to the its side. This way the image always stays
				// inside your
				// bounding box AND either x/y axis touches it.
				float xScale = ((float) desiredWidth) / width;
				float yScale = (float) desiredHeight / height;
				float scale = (xScale <= yScale) ? xScale : yScale;

				// Create a matrix for the scaling and add the scaling data
				Matrix matrix = new Matrix();
				matrix.postScale(scale, scale);

				// Create a new bitmap and convert it to a format understood by
				// the ImageView
				Bitmap scaledBitmap = Bitmap.createBitmap(bitmap, 0, 0, width,
						height, matrix, true);

				BitmapDrawable result = new BitmapDrawable(scaledBitmap);

				width = scaledBitmap.getWidth();
				height = scaledBitmap.getHeight();

				// Apply the scaled bitmap
				view.setImageDrawable(result);

				// Now change ImageView's dimensions to match the scaled image
				LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) view
						.getLayoutParams();
				params.width = width;
				params.height = height;
				view.setLayoutParams(params);

				unbindDrawables(view);
				System.gc();
				Runtime.getRuntime().gc();

			}

		}

	}

	/**
	 * 
	 * @param view
	 */
	private static void unbindDrawables(View view) {
		if (view.getBackground() != null) {
			view.getBackground().setCallback(null);
		}
		if (view instanceof ViewGroup) {
			for (int i = 0; i < ((ViewGroup) view).getChildCount(); i++) {
				unbindDrawables(((ViewGroup) view).getChildAt(i));
			}
			((ViewGroup) view).removeAllViews();
		}
	}

	/**
	 * Check if the text should be wrapped (when the text's length is greater
	 * than the screen's width.
	 * 
	 * @param text
	 *            the text.
	 * @return true if text will be wrapped. Else, it returns false.
	 */
	public static boolean isTextWrapped(Activity activity, String text,
			Context context) {
		boolean isWrapped = false;
		int textWidth = 0;
		int deviceWidth = 0;

		// Calculate the width of text
		TextView textView = new TextView(context);
		textView.setVisibility(View.GONE);
		Rect bounds = new Rect();
		Paint textPaint = textView.getPaint();
		textPaint.getTextBounds(text, 0, text.length(), bounds);
		textWidth = bounds.width();

		// Calculate the width of screen
		DisplayMetrics displaymetrics = new DisplayMetrics();
		activity.getWindowManager().getDefaultDisplay()
				.getMetrics(displaymetrics);
		deviceWidth = displaymetrics.widthPixels;

		isWrapped = textWidth > deviceWidth ? true : false;

		return isWrapped;
	}

	public static Bitmap LoadImage(String URL, BitmapFactory.Options options) {
		Bitmap bitmap = null;
		InputStream in = null;
		try {
			in = OpenHttpConnection(URL);
			bitmap = BitmapFactory.decodeStream(in, null, options);
			if (in != null)
				in.close();
		} catch (IOException e1) {
		}
		return bitmap;
	}

	public static InputStream OpenHttpConnection(String strURL)
			throws IOException {
		InputStream inputStream = null;
		URL url = new URL(strURL);
		URLConnection conn = url.openConnection();

		try {
			HttpURLConnection httpConn = (HttpURLConnection) conn;
			httpConn.setRequestMethod("GET");
			httpConn.connect();

			if (httpConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
				inputStream = httpConn.getInputStream();
			}
		} catch (Exception ex) {
		}
		return inputStream;
	}

	public static Bitmap scaleBitmap(String url) {
		try {
			Bitmap bm = null;
			BitmapFactory.Options bmOptions;
			bmOptions = new BitmapFactory.Options();
			bmOptions.inSampleSize = 1;
			bmOptions.inJustDecodeBounds = false;
			Bitmap bitmp = LoadImage(url, bmOptions);
			if (bitmp != null) {
				int height = bitmp.getHeight();
				int width = bitmp.getWidth();
				int deviceSizeHeight = FollowerActivity.screenHeight;
				int deviceSizeWidth = FollowerActivity.screenWidth;
				int imgWidth = 0, imgHeight = 0;
				if (deviceSizeWidth <= 320) { // 320 x 480
					// marginLeft = 8;
					// marginRight = 8;
					if (width < 560) {
						imgWidth = (width * 304 / 560);
						imgHeight = (height * 304 / 560);
					} else {
						imgWidth = 304;
						imgHeight = (height * 304) / width;
					}
				} else if (deviceSizeWidth <= 480) { // 480 x 800
					// marginLeft = 12;
					// marginRight = 12;
					if (width < 560) {
						imgWidth = (width * 456 / 560);
						imgHeight = (height * 456 / 560);
					} else {
						imgWidth = 456;
						imgHeight = (height * 456) / width;
					}
				} else if (deviceSizeWidth <= 800) { // 800 x 1280
					// marginLeft = 20;
					// marginRight = 20;
					if (width < 560) {
						imgWidth = (width * 760 / 560);
						imgHeight = (height * 760 / 560);
					} else {
						imgWidth = 760;
						imgHeight = (height * 760) / width;
					}
				}
				// bm = Bitmap.createScaledBitmap(bitmp, imgWidth*6,
				// imgHeight*6, false);
			}
			return bm;
		} catch (Exception e) {
			// TODO: handle exception
			return null;
		}

	}

	// Login facebook get token
	public String integateLoginFacebook(final Activity activity, final Handler handleFbLogin) {
		final SharedPreferences prefs;
	    Facebook mFacebook;
	    String token = null;
		mFacebook = new Facebook(Constants.FACEBOOK_APP_ID);
		mFacebook.authorize(activity, new String[] { "email", "status_update",
				"user_birthday" }, new DialogListener() {
			@Override
			public void onComplete(Bundle values) {
				Log.d("", "=====>"+values.toString());
				String accessToken = values.getString("access_token");
				saveFacebookToken("oauth_token", accessToken, activity);
				 Message message = handleFbLogin.obtainMessage(NewPermActivity.LOGIN_FACEBOOK, "");
				 handleFbLogin.sendMessage(message);
			}

			@Override
			public void onFacebookError(FacebookError error) {
				 Message message = handleFbLogin.obtainMessage(NewPermActivity.MESSAGE_LOGIN_FACEBOOK_ERROR, "");
				 handleFbLogin.sendMessage(message);
			}

			@Override
			public void onError(DialogError e) {
				 Message message = handleFbLogin.obtainMessage(NewPermActivity.MESSAGE_LOGIN_FACEBOOK_ERROR, "");
				 handleFbLogin.sendMessage(message);
			}

			@Override
			public void onCancel() {
				// cancel press or back press
				 Message message = handleFbLogin.obtainMessage(NewPermActivity.MESSAGE_LOGIN_FACEBOOK_ERROR, "");
				 handleFbLogin.sendMessage(message);
			}
		});
		return getFacebookToken(activity);
	}

	public void saveFacebookToken(String key, String value, Activity activity) {
		SharedPreferences sharedPreferences = activity
				.getPreferences(Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPreferences.edit();
		editor.putString("oauth_token", value);
		editor.commit();
	}

	public String getFacebookToken(Activity activity) {
		SharedPreferences sharedPreferences = activity
				.getPreferences(Context.MODE_PRIVATE);
		return sharedPreferences.getString("oauth_token", "");
	}
	public boolean saveTwitterAccess(String key, AccessToken value, Context activity) {
		Editor editor = activity.getSharedPreferences("TWITTER",
				Context.MODE_PRIVATE).edit();
		if(value.getToken() != null)
			editor.putString("twitter_key", value.getToken());
		if(value.getTokenSecret() != null)
			editor.putString("twitter_secret", value.getTokenSecret());
		return editor.commit();
	}

	public AccessToken getTwitterAccess(Context activity) {
		SharedPreferences savedSession = activity.getSharedPreferences(
				"TWITTER", Context.MODE_PRIVATE);
		String key = savedSession.getString("twitter_key", "");
		String secret = savedSession.getString("twitter_secret", "");
		if (key == "" || secret == "") {
			return null;
		}
		return new AccessToken(key, secret);
	}
	public boolean logOutFacebook(Activity activity){
		String result = "";
		try {
			Facebook mFacebook = new Facebook(Constants.FACEBOOK_APP_ID);
			result = mFacebook.logout(activity.getApplicationContext());
			saveFacebookToken("oauth_token", "", activity);
			if(result.equals("true"))
				return true;
			else 
				return false;
		} catch (Exception e) {
			// TODO: handle exception
			return false;
		}
		
	}
}
