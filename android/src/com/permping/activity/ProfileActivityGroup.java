/**
 * 
 */
package com.permping.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.permping.TabGroupActivity;

/**
 * @author Linh Nguyen
 *
 */
public class ProfileActivityGroup extends TabGroupActivity {

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		View view = getLocalActivityManager().startActivity( "ProfileActivity", new Intent(this, ProfileActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		replaceView(view);
	}
	
//	public void onResume(){
//		super.onResume();
//		View view = getLocalActivityManager().startActivity( "ProfileActivity", new Intent(this, ProfileActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
//		replaceView(view);
//	}
}
