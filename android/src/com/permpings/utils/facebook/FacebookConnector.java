/**
 * 
 */
package com.permpings.utils.facebook;

import java.io.IOException;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;

import com.permpings.utils.facebook.SessionEvents.AuthListener;
import com.permpings.utils.facebook.SessionEvents.LogoutListener;
import com.permpings.utils.facebook.sdk.AsyncFacebookRunner;
import com.permpings.utils.facebook.sdk.DialogError;
import com.permpings.utils.facebook.sdk.Facebook;
import com.permpings.utils.facebook.sdk.FacebookError;
import com.permpings.utils.facebook.sdk.Facebook.DialogListener;

/**
 * @author Linh Nguyen
 * This is the grapped object of facebook connection.
 */
public class FacebookConnector {
	private Facebook facebook;
	private Context context;
	private String[] permissions;
	private Handler handler;
	private Activity activity;
	private SessionListener sessionListener = new SessionListener();
	
	public FacebookConnector(String appId,Activity activity,Context context,String[] permissions) {
		this.facebook = new Facebook(appId);
		
		SessionStore.restore(facebook, context);
        SessionEvents.addAuthListener(sessionListener);
        SessionEvents.addLogoutListener(sessionListener);
        
		this.context=context;
		this.permissions=permissions;
		this.handler = new Handler();
		this.activity=activity;
	}
	
	public void login() {
		if (!facebook.isSessionValid()) {
			facebook.authorize(this.activity, this.permissions, new LoginDialogListener());
		}
	}
	
	public void logout() {
        SessionEvents.onLogoutBegin();
        com.permpings.utils.facebook.sdk.AsyncFacebookRunner asyncRunner = new AsyncFacebookRunner(this.facebook);
        asyncRunner.logout(this.context, new LogoutRequestListener());
	}
	
	public void postMessageOnWall(String msg) {
		if (facebook.isSessionValid()) {
		    Bundle parameters = new Bundle();
		    parameters.putString("message", msg);
		    try {
				String response = facebook.request("me/feed", parameters,"POST");
				System.out.println(response);
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			login();
		}
	}
	
	public Facebook getFacebook() {
		return this.facebook;
	}
	
	private final class LoginDialogListener implements DialogListener {
        public void onComplete(Bundle values) {
            SessionEvents.onLoginSuccess();
        }

        public void onFacebookError(FacebookError error) {
            SessionEvents.onLoginError(error.getMessage());
        }
        
        public void onError(DialogError error) {
            SessionEvents.onLoginError(error.getMessage());
        }

        public void onCancel() {
            SessionEvents.onLoginError("Action Canceled");
        }
    }

	public class LogoutRequestListener extends BaseRequestListener {
        public void onComplete(String response, final Object state) {
            // callback should be run in the original thread, 
            // not the background thread
            handler.post(new Runnable() {
                public void run() {
                    SessionEvents.onLogoutFinish();
                }
            });
        }
    }
	
	private class SessionListener implements AuthListener, LogoutListener {

		public void onLogoutBegin() {
			// TODO Auto-generated method stub
			
		}

		public void onLogoutFinish() {
			// TODO Auto-generated method stub
			
		}

		public void onAuthSucceed() {
			// TODO Get token return here
				
		}

		public void onAuthFail(String error) {
			// TODO Auto-generated method stub
			
		}
	}
}