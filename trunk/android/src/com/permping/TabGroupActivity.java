package com.permping;

import java.util.ArrayList;

import android.app.Activity;
import android.app.ActivityGroup;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
public class TabGroupActivity extends ActivityGroup {

	// Keep this in a static variable to make it accessible for all the nesten
	// activities,
	// lets them manipulate the view
	public static TabGroupActivity group;

	// Need to keep track of the history if you want the back-button to
	// work properly, don't use this if your activities requires a lot of
	// memory.
	private ArrayList<View> history;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.history = new ArrayList<View>();
		group = this;
		

	}
	
	public void clearHistory(){
		//this.history.clear();
		for( int i = 1; i < history.size(); i++ ){
			history.remove(i);
		}
	}

	public void replaceView(View v) {
		// Adds the old one to history
		//history.add(v);
		// Changes this Groups View to the new View.
		setContentView(v);
	}
	public void overrideView(View v) {
		// Adds the old one to history
		//history.add(v);
		setContentView(v);
		if(history.size() >= 2)
			history.remove(history.size()- 2);
	}
	public void back() {
		if (history.size() > 0) {
			if (history.size() == 1)
				setContentView(history.get(history.size() - 1));
			else {
				history.remove(history.size() - 1);
				setContentView(history.get(history.size() - 1));
			}
		} else {
			Resources res = this.getApplicationContext().getResources();
			AlertDialog alertDialog = new AlertDialog.Builder(this).create();		
			alertDialog.setTitle(res.getString(R.string.exit_title));
			alertDialog.setMessage(res.getString(R.string.exit_content));
			alertDialog.setButton(res.getString(R.string.yes), new DialogInterface.OnClickListener() {
			   public void onClick(DialogInterface dialog, int which) {
			      // here you can add functions
				  finish();
			   }
			});
			alertDialog.setButton2(res.getString(R.string.no), new DialogInterface.OnClickListener() {
			   public void onClick(DialogInterface dialog, int which) {
					      
			   }
			});
			alertDialog.setIcon(R.drawable.icon);
			alertDialog.show();
			
			
		}
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event)
	{		
	    if ((keyCode == KeyEvent.KEYCODE_BACK))
	    {
	        PermpingMain.back();
	        return true;
	    }
	    return super.onKeyDown(keyCode, event);
	}
}