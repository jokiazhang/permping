
package com.permping.activity;
import java.util.ArrayList;

import com.permping.R;
import com.permping.adapter.CategoryAdapter;
import com.permping.adapter.PermAdapter;
import com.permping.controller.CategoryController;
import com.permping.model.Category;

import android.app.Activity;
import android.os.Bundle;
import android.os.StrictMode;
import android.widget.ListView;

public class ExplorerActivity extends Activity {
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.explorer_layout);
        
        
        ListView categoriesView = (ListView) findViewById(R.id.categories);
        CategoryController catController  = new CategoryController();
        ArrayList <Category> categories = catController.getCategoryList();
        
        CategoryAdapter categoriesAdapter = new CategoryAdapter( this, R.layout.category_item , categories);
        categoriesView.setAdapter(categoriesAdapter);
        
        
        String a = "";
        String b = a;
        
    }
}
