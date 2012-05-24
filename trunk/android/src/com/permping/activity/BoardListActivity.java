package com.permping.activity;

import java.util.ArrayList;

import com.permping.R;
import com.permping.TabGroupActivity;
import com.permping.adapter.CategoryAdapter;
import com.permping.adapter.PermAdapter;
import com.permping.controller.CategoryController;
import com.permping.model.Category;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.StrictMode;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;
import android.view.View;

public class BoardListActivity extends Activity {
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.explorer_layout);
		
		ListView categoriesView = (ListView) findViewById(R.id.categories);
		CategoryController catController = new CategoryController();
		final ArrayList<Category> categories = catController.getCategoryList();

		CategoryAdapter categoriesAdapter = new CategoryAdapter(this, R.layout.category_item, categories);
		categoriesView.setAdapter(categoriesAdapter);

		categoriesView.setOnItemClickListener(new android.widget.AdapterView.OnItemClickListener() {
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// When clicked, show a toast with the TextView text
				/*
				//Bundle extras = getIntent().getExtras(); 
				if(extras !=null && false )
				{
					Category cat = categories.get(position);
					Intent myIntent = new Intent(view.getContext(), ExplorerActivity.class);
					myIntent.putExtra("abc", "defffff dfsdf");
					startActivity(myIntent);
					
				}
				else
				{
					//String value = extras.getString("abc");
					Toast.makeText(getApplicationContext(), "uuuuuu" , Toast.LENGTH_SHORT).show();
				}*/
				Toast.makeText(getApplicationContext(), "uuuuuu" , Toast.LENGTH_SHORT).show();
			}
		});


	}
	
	public void onBackPressed(){
		String a = "";
		String b = a;
		
		this.finish();
		return;
	}
	
}
