package com.permping;

import java.util.ArrayList;

import android.app.Activity;
import android.app.ActivityGroup;
import android.content.Intent;
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
		history.add(v);
		// Changes this Groups View to the new View.
		setContentView(v);
	}
	public void overrideView(View v) {
		// Adds the old one to history
		history.add(v);
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
			finish();
		}
	}




}