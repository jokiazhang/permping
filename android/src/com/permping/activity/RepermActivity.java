/**
 * 
 */
package com.permping.activity;

import com.permping.R;

import android.app.Activity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;

/**
 * @author Linh Nguyen
 *
 */
public class RepermActivity extends Activity {
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		View contentView = LayoutInflater.from(getParent()).inflate(R.layout.reperm_layout, null);
        setContentView(contentView);
	}
}
