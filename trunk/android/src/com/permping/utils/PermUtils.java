/**
 * 
 */
package com.permping.utils;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;

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

	    	imageView.setAdjustViewBounds(true);
	    	
	    	if (downloadedImageWidth <= 560) { // image width <= 560 pixel
	        	if (screenWidth == 320 && screenHeight == 480) {
	        		// Set the height
	        		imageView.setMaxHeight(downloadedImageHeight/560*304);
	        		// Set the width
	        		imageView.setMaxWidth(downloadedImageWidth/560*304);
	        	} else if (screenWidth == 480 && screenHeight == 800) {
	        		// Set the height
	        		imageView.setMaxHeight(downloadedImageHeight/560*456);
	        		// Set the width
	        		imageView.setMaxWidth(downloadedImageWidth/560*456);
	        	} else if (screenWidth == 800 && screenHeight == 1280) {
	        		// Set the height
	        		imageView.setMaxHeight(downloadedImageHeight/560*760);
	        		// Set the width
	        		imageView.setMaxWidth(downloadedImageWidth/560*760);
	        	} else { // Other resolution
	        		
	        	}
	        } else { // image width > 560 pixel  
	        	if (screenWidth == 320 && screenHeight == 480) {
	        		// Set the height
	        		imageView.setMaxHeight(downloadedImageHeight*304/downloadedImageWidth);
	        		// Set the width
	        		imageView.setMaxWidth(304);
	        	} else if (screenWidth == 480 && screenHeight == 800) {
	        		// Set the height
	        		imageView.setMaxHeight(downloadedImageHeight*456/downloadedImageWidth);
	        		// Set the width
	        		imageView.setMaxWidth(456);
	        	} else if (screenWidth == 800 && screenHeight == 1280) {
	        		// Set the height
	        		imageView.setMaxHeight(downloadedImageHeight*760/downloadedImageWidth);
	        		// Set the width
	        		imageView.setMaxWidth(760);
	        	} else { // Other resolution
	        		
	        	}
	        }
	    	imageView.setScaleType(ScaleType.FIT_XY);
	    	
		}
	}
}
