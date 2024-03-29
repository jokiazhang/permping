/**
 * 
 */
package com.permpings.activity;

import android.app.Activity;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.permpings.PermpingApplication;
import com.permpings.PermpingMain;
import com.permpings.R;
import com.permpings.controller.AuthorizeController;
import com.permpings.model.User;
import com.permpings.utils.PermUtils;
import com.permpings.utils.XMLParser;

/**
 * @author Linh Nguyen
 *
 */
public class AccountActivity extends Activity {

	Button logout;
	Button cancel;
	Button back;
	Button btnAddProfile;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		View contentView = LayoutInflater.from(getParent()).inflate(R.layout.account_layout, null);
        setContentView(contentView);
		
        TextView textView = (TextView)findViewById(R.id.permpingTitle);
		Typeface tf = Typeface.createFromAsset(getAssets(), "ufonts.com_franklin-gothic-demi-cond-2.ttf");
		if(textView != null) {
			textView.setTypeface(tf);
		}
        
		logout = (Button) findViewById(R.id.btLogout);
		cancel = (Button) findViewById(R.id.btCancel);
		btnAddProfile = (Button)findViewById(R.id.btnAddProfile);
//thien		back = (Button) findViewById(R.id.btBack); 
		
		logout.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				// Remove the User object in application state.
				PermpingApplication state = (PermpingApplication) getApplicationContext();
				User user = state.getUser();
				if (user != null) {
					AuthorizeController authorizeController = new AuthorizeController();
					authorizeController.logout(user.getId());
					PermUtils permUtils = new PermUtils();
					permUtils.logOutFacebook(getParent());
					permUtils.logOutTwitter(getApplicationContext());
					state.setUser(null);
					XMLParser.storePermpingAccount(AccountActivity.this, "", "");
				}
				
				((ProfileActivityGroup)(ProfileActivityGroup.group)).createUI();
				
				// Forward to PermpingMain screen (Followers tab)
				//Intent intent = new Intent(v.getContext(), PermpingMain.class);
				//v.getContext().startActivity(intent);
			}
		});
		
		cancel.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				((ProfileActivityGroup)(ProfileActivityGroup.group)).createUI();
			}
		});
		btnAddProfile.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				PermpingMain.gotoTab(2, "UploadProfile");
			}
		});
		
		/*back.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				ProfileActivityGroup.group.back();
			}
		});*/
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event)
	{		
	    if ((keyCode == KeyEvent.KEYCODE_BACK))
	    {
	    	((ProfileActivityGroup)(ProfileActivityGroup.group)).createUI();
	        return true;
	    }
	    return super.onKeyDown(keyCode, event);
	}
	
}
