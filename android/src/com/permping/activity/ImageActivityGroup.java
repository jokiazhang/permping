package com.permping.activity;


import com.permping.R;
import com.permping.TabGroupActivity;

import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;

public class ImageActivityGroup extends TabGroupActivity {

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		View view = getLocalActivityManager().startActivity( "ImageActivity", new Intent(this, ImageActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		replaceView(view);
	
		
	}
	
	//Gallery process
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
	    if (resultCode == RESULT_OK) {
	        if (requestCode == 1) {
	            Uri selectedImageUri = data.getData();
	            String selectedImagePath = getPath(selectedImageUri);
	            
	            //Start activity allow user input perm info
	            Intent myIntent = new Intent(this, NewPermActivity.class);
	            myIntent.putExtra("imagePath", selectedImagePath );
				View boardListView = ExplorerActivityGroup.group.getLocalActivityManager() .startActivity("NewPermActivity", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
				ImageActivityGroup.group.replaceView(boardListView);

				//dialog = ProgressDialog.show(this, "Uploading","Please wait...", true);
				//new ImageUpload( selectedImagePath ).execute();
	        }
	    }
	}

	public String getPath(Uri uri) {
	    String[] projection = { MediaStore.Images.Media.DATA };
	    Cursor cursor = managedQuery(uri, projection, null, null, null);
	    int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
	    cursor.moveToFirst();
	    return cursor.getString(column_index);
	}
	
	
	
	
	
	

}
