package com.permping.activity;

import java.util.ArrayList;
import java.util.List;

import com.permping.PermpingMain;
import com.permping.R;
import com.permping.adapter.BoardDetailAdapter;
import com.permping.adapter.PermAdapter;
import com.permping.model.Perm;
import com.permping.model.Transporter;
import com.permping.model.User;
import com.permping.utils.Constants;
import com.permping.utils.PermUtils;
import com.permping.utils.UrlImageViewHelper;

import android.app.Activity;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class BoardDetailActivity extends Activity {

	private ListView permList;
	private TextView message;
	Button back;

	int screenWidth;
	int screenHeight;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		Bundle extras = getIntent().getExtras();
		Transporter transporter =null;
		if(extras != null)
			transporter = (Transporter) extras
				.get(Constants.TRANSPORTER);
		ArrayList<Perm> perms = null;
		String boardName = null;
		if(transporter != null){
			perms = transporter.getPerms();
			boardName = transporter.getBoardName();
		}
		// Get the screen's size.
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);

		screenHeight = metrics.heightPixels;
		screenWidth = metrics.widthPixels;

		if (perms == null || perms.size() == 0) {
			// Display man hinh No Perms Found
			setContentView(R.layout.profile_emptyperm_layout);
			message = (TextView) findViewById(R.id.message);
			message.setText("No Perms Found. Please press Back to select another board!");
		} else {
			setContentView(R.layout.profile_permlist_layout);
			permList = (ListView) findViewById(R.id.permList);
			User user = PermUtils.isAuthenticated(getApplicationContext());
//			BoardDetailAdapter boardDetailAdapter = new BoardDetailAdapter(
//					this, perms, boardName, screenHeight, screenWidth, user);
			PermAdapter boardDetailAdapter =  new PermAdapter(MyDiaryActivityGroup.context,
					null,R.layout.perm_item_1, perms, BoardDetailActivity.this, screenHeight, screenWidth, false, user);

			permList.setAdapter(boardDetailAdapter);
		}

//		thien back = (Button) findViewById(R.id.btBack);
//
//		back.setOnClickListener(new View.OnClickListener() {
//
//			public void onClick(View v) {
//				ProfileActivityGroup.group.back();
//			}
//		});
	}

	/**
	 * This code is being executed when the layout has not been laid out yet.
	 */
	/*
	 * public void onGlobalLayout() { // Get the screen's size. DisplayMetrics
	 * metrics = new DisplayMetrics();
	 * getWindowManager().getDefaultDisplay().getMetrics(metrics);
	 * 
	 * screenHeight = metrics.heightPixels; screenWidth = metrics.widthPixels; }
	 */
	
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
