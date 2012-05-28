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
import com.permping.controller.CategoryController;
import com.permping.model.Category;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.XMLParser;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
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
				/*Toast toast = Toast.makeText(getApplicationContext(), "Not finished yet!", Toast.LENGTH_SHORT);
	        	toast.setGravity(Gravity.TOP | Gravity.CENTER, 0, 50);
	        	toast.show();*/
	        	
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
	        			if (parser != null) {
	        				// TODO: Notify that board is created already
	        			}
	        			ImageActivityGroup.group.back();
	        		}
	        	}
	        	
			}
		});
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
}


