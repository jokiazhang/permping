/**
 * 
 */
package com.permping.utils;

import android.content.Context;
import android.graphics.drawable.Drawable;
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
	        		imageView.setMaxHeight((downloadedImageHeight/560)*304);
	        		// Set the width
	        		imageView.setMaxWidth((downloadedImageWidth/560)*304);
	        		
	        		desiredWidth = (downloadedImageWidth/560)*304;
	        		desiredHeight = (downloadedImageHeight/560)*304;
	        		
	        	} else if (screenWidth == 480 && screenHeight == 800) {
	        		// Set the height
	        		imageView.setMaxHeight((downloadedImageHeight/560)*456);
	        		// Set the width
	        		imageView.setMaxWidth((downloadedImageWidth/560)*456);
	        		
	        		desiredWidth = (downloadedImageWidth/560)*456;
	        		desiredHeight = (downloadedImageHeight/560)*456;
	        	} else if (screenWidth == 800 && screenHeight == 1280) {
	        		// Set the height
	        		imageView.setMaxHeight((downloadedImageHeight/560)*760);
	        		// Set the width
	        		imageView.setMaxWidth((downloadedImageWidth/560)*760);

	        		desiredWidth = (downloadedImageWidth/560)*760;
	        		desiredHeight = (downloadedImageHeight/560)*760;
	        	} else { // Other resolution
	        		
	        	}
	        } else { // image width > 560 pixel  
	        	if (screenWidth == 320 && screenHeight == 480) {
	        		// Set the height
	        		imageView.setMaxHeight(downloadedImageHeight*304/downloadedImageWidth);
	        		// Set the width
	        		imageView.setMaxWidth(304);
	        		
	        		desiredWidth = 304;
	        		desiredHeight = downloadedImageHeight*304/downloadedImageWidth;
	        	} else if (screenWidth == 480 && screenHeight == 800) {
	        		// Set the height
	        		imageView.setMaxHeight(downloadedImageHeight*456/downloadedImageWidth);
	        		// Set the width
	        		imageView.setMaxWidth(456);
	        		
	        		desiredWidth = 456;
	        		desiredHeight = downloadedImageHeight*456/downloadedImageWidth;
	        	} else if (screenWidth == 800 && screenHeight == 1280) {
	        		// Set the height
	        		imageView.setMaxHeight(downloadedImageHeight*760/downloadedImageWidth);
	        		// Set the width
	        		imageView.setMaxWidth(760);

	        		desiredWidth = 760;
	        		desiredHeight = downloadedImageHeight*760/downloadedImageWidth;
	        	} else { // Other resolution
	        		
	        	}
	        }
	    	/*
	    	ViewGroup.LayoutParams layoutParams;
	    	if (flag != null && "1".equals(flag)) {
	    		//LinearLayout layout = (LinearLayout) parent;
	    		layoutParams = new LinearLayout.LayoutParams(desiredWidth, desiredHeight);
	    	} else {
	    		layoutParams = new TableRow.LayoutParams(desiredWidth, desiredHeight);
	    	}
	    	
	    	imageView.setLayoutParams(layoutParams);*/
	    	imageView.setScaleType(ImageView.ScaleType.FIT_XY);
	    	
		}
	}
}
