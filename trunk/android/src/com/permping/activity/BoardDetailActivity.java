package com.permping.activity;

import java.util.List;

import com.permping.R;
import com.permping.adapter.BoardDetailAdapter;
import com.permping.model.Perm;
import com.permping.model.Transporter;
import com.permping.model.User;
import com.permping.utils.Constants;
import com.permping.utils.PermUtils;
import com.permping.utils.UrlImageViewHelper;

import android.app.Activity;
import android.os.Bundle;
import android.util.DisplayMetrics;
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
		Transporter transporter = (Transporter) extras
				.get(Constants.TRANSPORTER);
		List<Perm> perms = transporter.getPerms();
		String boardName = transporter.getBoardName();

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
/*			
			*//**
			 * TODO: Just for testing the image scaling function
			 *//*
			// <560
			ImageView image1 = (ImageView) findViewById(R.id.image1);
			UrlImageViewHelper.setUrlDrawable(image1, "http://3.bp.blogspot.com/-kZJirjdmR4Q/T6HCHiu--WI/AAAAAAAADdc/75BCY1nVKSQ/s1600/android.png");
			PermUtils.scale("1", image1, screenWidth, screenHeight);
			
			// >560
			ImageView image2 = (ImageView) findViewById(R.id.image2);
			UrlImageViewHelper.setUrlDrawable(image2, "http://www.greggibsonblog.com/blogpix/2009/03/00071.jpg");
			PermUtils.scale(image2, screenWidth, screenHeight);
			
*/		} else {
			setContentView(R.layout.profile_permlist_layout);
			permList = (ListView) findViewById(R.id.permList);
			User user = PermUtils.isAuthenticated(getApplicationContext());
			BoardDetailAdapter boardDetailAdapter = new BoardDetailAdapter(
					this, perms, boardName, screenHeight, screenWidth, user);
			permList.setAdapter(boardDetailAdapter);
		}

		back = (Button) findViewById(R.id.btBack);

		back.setOnClickListener(new View.OnClickListener() {

			public void onClick(View v) {
				ProfileActivityGroup.group.back();
			}
		});
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
}
