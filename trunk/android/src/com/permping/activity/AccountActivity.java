/**
 * 
 */
package com.permping.activity;

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
import com.permping.R;
import com.permping.controller.AuthorizeController;
import com.permping.model.User;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;

/**
 * @author Linh Nguyen
 *
 */
public class AccountActivity extends Activity {

	Button logout;
	Button cancel;
	Button back;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		View contentView = LayoutInflater.from(getParent()).inflate(R.layout.account_layout, null);
        setContentView(contentView);
		
		logout = (Button) findViewById(R.id.btLogout);
		cancel = (Button) findViewById(R.id.btCancel);
		back = (Button) findViewById(R.id.btBack);
		
		logout.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				// Remove the User object in application state.
				PermpingApplication state = (PermpingApplication) getApplicationContext();
				User user = state.getUser();
				if (user != null) {
					AuthorizeController authorizeController = new AuthorizeController();
					authorizeController.logout(user.getId());
					state.setUser(null);
				}
				
				// Forward to PermpingMain screen (Followers tab)
				Intent intent = new Intent(v.getContext(), PermpingMain.class);
				v.getContext().startActivity(intent);
			}
		});
		
		cancel.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				ProfileActivityGroup.group.back();
			}
		});
		
		back.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				ProfileActivityGroup.group.back();
			}
		});
	}
	
}
