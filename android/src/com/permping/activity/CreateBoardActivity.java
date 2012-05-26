/**
 * 
 */
package com.permping.activity;

import java.util.ArrayList;

import com.permping.R;
import com.permping.controller.CategoryController;
import com.permping.model.Category;

import android.app.Activity;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

/**
 * @author Linh Nguyen
 *
 */
public class CreateBoardActivity extends Activity {

	private Button createBoard;
	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.createboard_layout);
		
		CategoryController catController = new CategoryController();
		final ArrayList<Category> categories = catController.getCategoryList();
		
		createBoard = (Button) findViewById(R.id.createBoard);
		createBoard.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Toast toast = Toast.makeText(getApplicationContext(), "Not finished yet!", Toast.LENGTH_SHORT);
	        	toast.setGravity(Gravity.TOP | Gravity.CENTER, 0, 50);
	        	toast.show();
			}
		});
	}	
}
