package com.permping.activity;

import java.util.ArrayList;

import com.permping.R;
import com.permping.TabGroupActivity;
import com.permping.adapter.CategoryAdapter;
import com.permping.adapter.PermAdapter;
import com.permping.controller.CategoryController;
import com.permping.model.Category;
import com.permping.model.PermBoard;
import com.permping.utils.API;

import android.app.Activity;
import android.app.ActivityGroup;
import android.content.Intent;
import android.os.Bundle;
import android.os.StrictMode;
import android.provider.SyncStateContract.Constants;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;
import android.util.Log;
import android.view.View;

public class ExplorerActivity extends Activity {
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.explorer_layout);

		ListView categoriesView = (ListView) findViewById(R.id.categories);
		final CategoryController catController = new CategoryController();
		final ArrayList<Category> categories = catController.getCategoryList();

		CategoryAdapter categoriesAdapter = new CategoryAdapter(this, R.layout.category_item, categories);
		categoriesView.setAdapter(categoriesAdapter);
		categoriesView.setOnItemClickListener(new android.widget.AdapterView.OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

				Intent myIntent = new Intent(view.getContext(), FollowerActivity.class);
				Category cat = categories.get(position);
				String categoryUrl = API.permListFromCategory + cat.getId();
				myIntent.putExtra("categoryURL", categoryUrl);
				View boardListView = ExplorerActivityGroup.group.getLocalActivityManager() .startActivity("BoardListActivity", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
				ExplorerActivityGroup.group.replaceView(boardListView);
			}
		});
		Button btnAllCategory = (Button)findViewById(R.id.btnAllCategory);
		btnAllCategory.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent myIntent = new Intent(v.getContext(), FollowerActivity.class);
				myIntent.putExtra("allcategory", "allcategory");
				View boardListView = ExplorerActivityGroup.group.getLocalActivityManager() .startActivity("BoardListActivity", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
				ExplorerActivityGroup.group.replaceView(boardListView);
			}
		});
	}
}
