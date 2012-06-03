/**
 * 
 */
package com.permping.activity;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.permping.PermpingApplication;
import com.permping.R;
import com.permping.adapter.CategorySpinnerAdapter;
import com.permping.controller.AuthorizeController;
import com.permping.controller.CategoryController;
import com.permping.model.Category;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.XMLParser;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethod;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

/**
 * @author Linh Nguyen
 *
 */
public class CreateBoardActivity extends Activity {

	private Spinner mainCategory;
	private EditText boardName;
	private EditText boardDescription;
	private Button createBoard;
	private int categoryId = -1;
	
	/**
	 * Initialize the View
	 */
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		//setContentView(R.layout.createboard_layout);
		
		View contentView = LayoutInflater.from(getParent()).inflate(R.layout.createboard_layout, null);
        setContentView(contentView);
		
		CategoryController catController = new CategoryController();
		final ArrayList<Category> categories = catController.getCategoryList();
		
		// Build the category spinner
		mainCategory = (Spinner) findViewById(R.id.categorySpinner);
		addItemsOnMainCategory(mainCategory, categories);
		mainCategory.setOnItemSelectedListener(new CategorySpinnerSelectedListener());		
		
		boardName = (EditText) findViewById(R.id.boardName);
		boardDescription = (EditText) findViewById(R.id.boardDescription);
		
		createBoard = (Button) findViewById(R.id.createBoard);
		createBoard.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
	        	List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(4);
	        	PermpingApplication state = (PermpingApplication) getApplicationContext();
	        	if (state != null) {
	        		User user = state.getUser();
	        		if (user != null) {
	        			nameValuePairs.add(new BasicNameValuePair(Constants.BOARD_NAME, 
	        					boardName.getText().toString()));
	        			nameValuePairs.add(new BasicNameValuePair(Constants.CATEGORY_ID, 
	        					String.valueOf(categoryId)));
	        			nameValuePairs.add(new BasicNameValuePair(Constants.BOARD_USER_ID, 
	        					user.getId()));
	        			nameValuePairs.add(new BasicNameValuePair(Constants.BOARD_DESCRIPTION, 
	        					boardDescription.getText().toString()));
	        			
	        			XMLParser parser = new XMLParser(API.createBoardURL, nameValuePairs);
	        			if (parser.getDoc() != null) {
	        				AuthorizeController authorizeController = new AuthorizeController();
	        				User updated = authorizeController.getUserProfileById(user.getId());
	        				if (updated != null)
	        					state.setUser(updated);
	        				Toast toast = Toast.makeText(getApplicationContext(), "Board is created successfully!", Toast.LENGTH_LONG);
	    		        	toast.setGravity(Gravity.TOP | Gravity.CENTER, 0, 300);
	    		        	toast.show();
	    		        	/*InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
	    		        	imm.hideSoftInputFromWindow(windowToken, flags)
	    		        	*///getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
	    		        	ImageActivityGroup.group.back();
	        			} else {
	        				Toast toast = Toast.makeText(getApplicationContext(), "Create new board failed! Please try again.", Toast.LENGTH_LONG);
	    		        	toast.setGravity(Gravity.TOP | Gravity.CENTER, 0, 300);
	    		        	toast.show();
	    		        	boardName.setText("");
	    		        	boardDescription.setText("");
	        			}
	        		}
	        	}
			}
		});
	}
	
	/* (non-Javadoc)
	 * @see android.app.Activity#dispatchTouchEvent(android.view.MotionEvent)
	 */
	@Override
	public boolean dispatchTouchEvent(MotionEvent event) {
		View view = getCurrentFocus();
		boolean ret = super.dispatchTouchEvent(event);
		if (view instanceof EditText) {
			View w = getCurrentFocus();
			int scrcoords[] = new int[2];
			w.getLocationOnScreen(scrcoords);
			float x = event.getRawX() + w.getLeft() - scrcoords[0];
	        float y = event.getRawY() + w.getTop() - scrcoords[1];

	        Log.d("CreateBoard", "Touch event " + event.getRawX() + "," + event.getRawY() +
	        		" " + x + "," + y + " rect " + w.getLeft() + "," + w.getTop() + "," +
	        		w.getRight() + "," + w.getBottom() + " coords " + scrcoords[0] + "," + scrcoords[1]);
	        if (event.getAction() == MotionEvent.ACTION_UP && (x < w.getLeft() || x >= w.getRight() || y < w.getTop() || y > w.getBottom()) ) { 
	            InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
	            imm.hideSoftInputFromWindow(getWindow().getCurrentFocus().getWindowToken(), 0);
	        }
		}
		return ret;
	}

	private void addItemsOnMainCategory(Spinner spinner, ArrayList<Category> categories) {
		CategorySpinnerAdapter categorySpinnerAdapter = new CategorySpinnerAdapter(this, categories);
		spinner.setAdapter(categorySpinnerAdapter);
		Category initial = (Category) categorySpinnerAdapter.getItem(0);
		if (initial != null)
			categoryId = Integer.parseInt(initial.getId());		
	}
	
	private class CategorySpinnerSelectedListener implements OnItemSelectedListener {

		public void onItemSelected(AdapterView<?> parent, View view, int pos,
				long id) {
			Category category = (Category) parent.getItemAtPosition(pos);
			categoryId = Integer.parseInt(category.getId());		}

		public void onNothingSelected(AdapterView<?> arg0) {
			
		}		
	}
	
	private void getUserProfileById(String userId) {
		
	}
}


