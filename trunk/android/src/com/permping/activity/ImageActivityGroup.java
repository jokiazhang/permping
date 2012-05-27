package com.permping.activity;


import com.permping.TabGroupActivity;

import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;

public class ImageActivityGroup extends TabGroupActivity {

private int CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE = 1224;
	
	private int SELECT_PICTURE = 1;
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		View view = getLocalActivityManager().startActivity( "ImageActivity", new Intent(this, ImageActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		replaceView(view);
	
		
	}
	
	public static String imagePath = "";
	
	//Gallery process
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
	    if (resultCode == RESULT_OK) {
	        if (requestCode == SELECT_PICTURE || requestCode == CAPTURE_IMAGE_ACTIVITY_REQUEST_CODE ) {
	        	String selectedImagePath = "";
	        	if( data == null || true ) {
	        		selectedImagePath = getImagePath();
	        	} else {
		            Uri selectedImageUri = data.getData();
		            
		            if( requestCode == SELECT_PICTURE ){
		            	selectedImagePath = getPath(selectedImageUri);
		            } else {
		            	selectedImagePath = getPath(selectedImageUri);
		            }
	        	}
	            //Start activity allow user input perm info
	            Intent myIntent = new Intent(this, NewPermActivity.class);
	            myIntent.putExtra("imagePath", selectedImagePath );
				View boardListView = ExplorerActivityGroup.group.getLocalActivityManager() .startActivity("NewPermActivity", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
				ImageActivityGroup.group.replaceView(boardListView);

				//dialog = ProgressDialog.show(this, "Uploading","Please wait...", true);
				//new ImageUpload( selectedImagePath ).execute();
	        }
	    }
	    
	    ImageActivityGroup.imagePath = "";
	}

	public String getPath(Uri uri) {
	    String[] projection = { MediaStore.Images.Media.DATA };
	    Cursor cursor = managedQuery(uri, projection, null, null, null);
	    int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
	    cursor.moveToFirst();
	    return cursor.getString(column_index);
	}
	
	
	public String getImagePath(){


		// Describe the columns you'd like to have returned. Selecting from the Thumbnails location gives you both the Thumbnail Image ID, as well as the original image ID
		String[] projection = {
		 MediaStore.Images.Thumbnails._ID,  // The columns we want
		 MediaStore.Images.Thumbnails.IMAGE_ID,
		 MediaStore.Images.Thumbnails.KIND,
		 MediaStore.Images.Thumbnails.DATA};
		 String selection = MediaStore.Images.Thumbnails.KIND + "="  + // Select only mini's
		 MediaStore.Images.Thumbnails.MINI_KIND;

		 String sort = MediaStore.Images.Thumbnails._ID + " DESC";

		//At the moment, this is a bit of a hack, as I'm returning ALL images, and just taking the latest one. There is a better way to narrow this down I think with a WHERE clause which is currently the selection variable
		Cursor myCursor = this.managedQuery(MediaStore.Images.Thumbnails.EXTERNAL_CONTENT_URI, projection, selection, null, sort);

		long imageId = 0l;
		long thumbnailImageId = 0l;
		String thumbnailPath = "";

		try{
		 myCursor.moveToFirst();
		imageId = myCursor.getLong(myCursor.getColumnIndexOrThrow(MediaStore.Images.Thumbnails.IMAGE_ID));
		thumbnailImageId = myCursor.getLong(myCursor.getColumnIndexOrThrow(MediaStore.Images.Thumbnails._ID));
		thumbnailPath = myCursor.getString(myCursor.getColumnIndexOrThrow(MediaStore.Images.Thumbnails.DATA));
		}
		finally{myCursor.close();}

		 //Create new Cursor to obtain the file Path for the large image

		 String[] largeFileProjection = {
		 MediaStore.Images.ImageColumns._ID,
		 MediaStore.Images.ImageColumns.DATA
		 };

		 String largeFileSort = MediaStore.Images.ImageColumns._ID + " DESC";
		 myCursor = this.managedQuery(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, largeFileProjection, null, null, largeFileSort);
		String largeImagePath = "";

		try{
		 myCursor.moveToFirst();

		//This will actually give yo uthe file path location of the image.
		largeImagePath = myCursor.getString(myCursor.getColumnIndexOrThrow(MediaStore.Images.ImageColumns.DATA));
		}
		finally{myCursor.close();}
		 // These are the two URI's you'll be interested in. They give you a handle to the actual images
		 Uri uriLargeImage = Uri.withAppendedPath(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, String.valueOf(imageId));
		 Uri uriThumbnailImage = Uri.withAppendedPath(MediaStore.Images.Thumbnails.EXTERNAL_CONTENT_URI, String.valueOf(thumbnailImageId));

		// I've left out the remaining code, as all I do is assign the URI's to my own objects anyways...
		 return largeImagePath;
		}
	
	
	
	

}
