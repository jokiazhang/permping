package com.permping.activity;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import com.permping.R;
import com.permping.model.User;
import com.permping.utils.PermUtils;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.LinearLayout;

public class ImageActivity extends Activity {
	private int CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE = 1224;
	
	private int SELECT_PICTURE = 1;
	
	
	//private ProgressDialog dialog;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.image_layout);

		final LinearLayout takePhoto = (LinearLayout) findViewById(R.id.takePhoto);
		takePhoto.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				// define the file-name to save photo taken by Camera activity
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.ENGLISH);
		        String strCurDate = dateFormat.format(new Date(System.currentTimeMillis()));
		        String imageName = "" + strCurDate + ".jpg";
		        
				// create parameters for Intent with filename
				ContentValues values = new ContentValues();
				values.put(MediaStore.Images.Media.TITLE, imageName );
				values.put(MediaStore.Images.Media.DESCRIPTION, "Image capture by camera");
				// imageUri is the current activity attribute, define and save
				// it for later usage (also in onSaveInstanceState)
				Uri imageUri = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
				ImageActivityGroup.imagePath = imageUri.getPath() + "/" + imageName ;
				// create new Intent
				Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
				intent.putExtra(MediaStore.EXTRA_OUTPUT, imageName );
				intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1);
				getParent().startActivityForResult(intent, CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE);
				//ImageActivityGroup.imagePath = intent.getData().getPath();
				//getParent().startActivityForResult(Intent.createChooser(intent, "Select Picture"), CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE);
			}
		});
		
		
		
		final LinearLayout openGalerry = (LinearLayout) findViewById(R.id.gallery);
		openGalerry.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				   // select a file
                Intent intent = new Intent();
                intent.setType("image/*");
                intent.setAction(Intent.ACTION_GET_CONTENT);
                getParent().startActivityForResult(Intent.createChooser(intent, "Select Picture"), SELECT_PICTURE);
			}
		});
		
		final LinearLayout createBoard = (LinearLayout) findViewById(R.id.createBoard);
		createBoard.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				User user = PermUtils.isAuthenticated(getApplicationContext());
				if (user != null) {
					// Go to the Create Board screen.
					Intent i = new Intent(v.getContext(), CreateBoardActivity.class);
					View view = ImageActivityGroup.group.getLocalActivityManager().startActivity("CreateBoardActivity", i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
					ImageActivityGroup.group.replaceView(view);
				} else {
					// Go to login screen
					Intent i = new Intent(v.getContext(), LoginPermActivity.class);
					v.getContext().startActivity(i);
				}
				
			}
		});

	}
	/*
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE) {
			if (resultCode == RESULT_OK) {
				// use imageUri here to access the image
				Uri selectedImageUri = data.getData();
				String selectedImagePath = selectedImageUri.getPath();
				String b  = selectedImagePath;
			} else if (resultCode == RESULT_CANCELED) {
				Toast.makeText(this, "Picture was not taken",
						Toast.LENGTH_SHORT);
			} else {
				Toast.makeText(this, "Picture was not taken",
						Toast.LENGTH_SHORT);
			}
		}
	}
	
	 /*
	public static File convertImageUriToFile(Uri imageUri, Activity activity) {
		Cursor cursor = null;
		try {
			String[] proj = { MediaStore.Images.Media.DATA,
					MediaStore.Images.Media._ID,
					MediaStore.Images.ImageColumns.ORIENTATION };
			cursor = activity.managedQuery(imageUri, proj, // Which columns to
															// return
					null, // WHERE clause; which rows to return (all rows)
					null, // WHERE clause selection arguments (none)
					null); // Order-by clause (ascending by name)
			int file_ColumnIndex = cursor
					.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
			int orientation_ColumnIndex = cursor
					.getColumnIndexOrThrow(MediaStore.Images.ImageColumns.ORIENTATION);
			if (cursor.moveToFirst()) {
				String orientation = cursor.getString(orientation_ColumnIndex);
				return new File(cursor.getString(file_ColumnIndex));
			}
			return null;
		} finally {
			if (cursor != null) {
				cursor.close();
			}
		}
	}
	*/
}
