/**
 * 
 */
package com.permping.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.TableLayout;
import android.widget.TableRow;

import com.permping.PermpingApplication;
import com.permping.model.User;

/**
 * @author Linh Nguyen
 *
 */
public class PermUtils {

	public static User isAuthenticated(Context context) {
		PermpingApplication state = (PermpingApplication) context;
    	if (state != null) {
    		User user = state.getUser();
    		return user;
    	}
    	
    	return null;
	}
	
	/**
	 * Scale the ImageView based on the screen's resolution
	 * @param imageView the ImageView object
	 * @param screenWidth the screen'width which the view is displayed.
	 * @param screenHeight the screen's height which the view is displayed.
	 */
	public static void scale(ImageView imageView, int screenWidth, int screenHeight) {
		imageView.buildDrawingCache();
		//Bitmap bitmap = imageView.getDrawingCache();

		Drawable bitmap = imageView.getDrawable();
		if (bitmap != null) {
			int downloadedImageWidth = bitmap.getIntrinsicWidth();
	    	int downloadedImageHeight= bitmap.getIntrinsicHeight();

	    	int desiredWidth = 0;
	    	int desiredHeight = 0;
	    	
	    	imageView.setAdjustViewBounds(true);
	    	    	
	    	if (downloadedImageWidth <= 560) { // image width <= 560 pixel
	        	if (screenWidth == 320 && screenHeight == 480) {
	        		// Set the height
	        		//imageView.setMaxHeight((downloadedImageHeight/560)*304);
	        		// Set the width
	        		//imageView.setMaxWidth((downloadedImageWidth/560)*304);
	        		
	        		desiredWidth = (downloadedImageWidth/560)*304;
	        		desiredHeight = (downloadedImageHeight/560)*304;
	        		
	        	} else if (screenWidth == 480 && screenHeight == 800) {
	        		// Set the height
	        		//imageView.setMaxHeight((downloadedImageHeight/560)*456);
	        		// Set the width
	        		//imageView.setMaxWidth((downloadedImageWidth/560)*456);
	        		
	        		desiredWidth = (downloadedImageWidth/560)*456;
	        		desiredHeight = (downloadedImageHeight/560)*456;
	        	} else if (screenWidth == 800 && screenHeight == 1280) {
	        		// Set the height
	        		//imageView.setMaxHeight((downloadedImageHeight/560)*760);
	        		// Set the width
	        		//imageView.setMaxWidth((downloadedImageWidth/560)*760);

	        		desiredWidth = (downloadedImageWidth/560)*760;
	        		desiredHeight = (downloadedImageHeight/560)*760;
	        	} else { // Other resolution
	        		
	        	}
	        } else { // image width > 560 pixel  
	        	if (screenWidth == 320 && screenHeight == 480) {
	        		// Set the height
	        		//imageView.setMaxHeight(downloadedImageHeight*304/downloadedImageWidth);
	        		// Set the width
	        		//imageView.setMaxWidth(304);
	        		
	        		desiredWidth = 304;
	        		desiredHeight = downloadedImageHeight*304/downloadedImageWidth;
	        	} else if (screenWidth == 480 && screenHeight == 800) {
	        		// Set the height
	        		//imageView.setMaxHeight(downloadedImageHeight*456/downloadedImageWidth);
	        		// Set the width
	        		//imageView.setMaxWidth(456);
	        		
	        		desiredWidth = 456;
	        		desiredHeight = downloadedImageHeight*456/downloadedImageWidth;
	        	} else if (screenWidth == 800 && screenHeight == 1280) {
	        		// Set the height
	        		//imageView.setMaxHeight(downloadedImageHeight*760/downloadedImageWidth);
	        		// Set the width
	        		//imageView.setMaxWidth(760);

	        		desiredWidth = 760;
	        		desiredHeight = downloadedImageHeight*760/downloadedImageWidth;
	        	} else { // Other resolution
	        		
	        	}
	        }
	    	imageView.setMaxHeight(desiredHeight);
    		// Set the width
    		imageView.setMaxWidth(desiredWidth);
	    	/*
	    	ViewGroup.LayoutParams layoutParams;
	    	if (flag != null && "1".equals(flag)) {
	    		//LinearLayout layout = (LinearLayout) parent;
	    		layoutParams = new LinearLayout.LayoutParams(desiredWidth, desiredHeight);
	    	} else {
	    		layoutParams = new TableRow.LayoutParams(desiredWidth, desiredHeight);
	    	}
	    	
	    	imageView.setLayoutParams(layoutParams);*/
//	    	imageView.setScaleType(ImageView.ScaleType.FIT_XY);
	    	
//	    	Bitmap copy = Bitmap.createScaledBitmap(bitmap, (int) desiredWidth, (int) desiredHeight, false);
//	    	imageView.setBackgroundDrawable(new BitmapDrawable(copy));
//	    	LayoutParams params = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
//	    	imageView.setLayoutParams(params);
//	    	imageView.setMaxHeight((int) desiredHeight);
//	    	imageView.setMaxWidth((int) desiredHeight);

	    	
		}
	}
	
	public static void scaleImage(ImageView view, int screenWidth, int screenHeight)
	{
	    // Get the ImageView and its bitmap
	    Drawable drawing = view.getDrawable();
	    if (drawing != null) {
		    Bitmap bitmap = ((BitmapDrawable)drawing).getBitmap();
		    if (bitmap != null) {
		    	// Get current dimensions
			    int width = bitmap.getWidth();
			    int height = bitmap.getHeight();
			    float boundBoxInDp = 500;
			    if (screenWidth == 320 && screenHeight == 480) {
			    	boundBoxInDp = 304;
	        		
	        	} else if (screenWidth == 480 && screenHeight == 800) {
	        		boundBoxInDp = 456;
	        	} else if (screenWidth == 800 && screenHeight == 1280) {
	        		boundBoxInDp =760;
	        	} else { // Other resolution
	        		
	        	}
			    // Determine how much to scale: the dimension requiring less scaling is
			    // closer to the its side. This way the image always stays inside your
			    // bounding box AND either x/y axis touches it.
			    float xScale = ((float) boundBoxInDp) / width;
			    float yScale = ((float) boundBoxInDp) / height;
			    float scale = (xScale <= yScale) ? xScale : yScale;
	
			    // Create a matrix for the scaling and add the scaling data
			    Matrix matrix = new Matrix();
			    matrix.postScale(scale, scale);
	
			    // Create a new bitmap and convert it to a format understood by the ImageView
			    Bitmap scaledBitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, true);
			    BitmapDrawable result = new BitmapDrawable(scaledBitmap);
			    width = scaledBitmap.getWidth();
			    height = scaledBitmap.getHeight();
	
			    // Apply the scaled bitmap
			    view.setImageDrawable(result);
			   
			    // Now change ImageView's dimensions to match the scaled image
			    LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) view.getLayoutParams();
			    params.width = width;
			    params.height = height;
			    view.setLayoutParams(params);
			     
		    }
	    }
	}
}
