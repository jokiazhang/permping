/**
 * 
 */
package com.permping.activity;

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
import com.permping.R;
import com.permping.utils.PermUtils;

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
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		View contentView = LayoutInflater.from(getParent()).inflate(R.layout.account_layout, null);
        setContentView(contentView);
		
		logout = (Button) findViewById(R.id.btLogout);
		cancel = (Button) findViewById(R.id.btCancel);
		
		logout.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// Remove the User object in application state.
				PermpingApplication state = (PermpingApplication) getApplicationContext();
				state.setUser(null);
				
				// Forward to PermpingMain screen (Followers tab)
				/*Intent i = new Intent(v.getContext(), PermpingMain.class);
				View view = ProfileActivityGroup.group.getLocalActivityManager().startActivity("FollowerActivity", i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
				ProfileActivityGroup.group.replaceView(view);*/
				Intent intent = new Intent(v.getContext(), PermpingMain.class);
				v.getContext().startActivity(intent);
			}
		});
		
		cancel.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				ProfileActivityGroup.group.back();
			}
		});
	}
	
}
