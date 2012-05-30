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
public class MyDiaryActivityGroup extends TabGroupActivity {
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		View view = getLocalActivityManager().startActivity( "MyDiaryActivity", new Intent(this, MyDiaryActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		replaceView(view);
	}
}
