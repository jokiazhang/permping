package com.permping.activity;

import java.util.ArrayList;
import com.permping.R;
import com.permping.controller.PermListController;
import com.permping.model.Perm;
import com.permping.adapter.*;

import android.app.Activity;
import android.os.Bundle;
import android.widget.ListView;


public class FollowerActivity extends Activity {
		
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
        setContentView(R.layout.followers_layout);
        
        ListView permListView = (ListView) findViewById(R.id.permList);
        PermListController permListController = new PermListController();
        
        ArrayList<Perm> permList = permListController.getPermList();
        
        PermAdapter permListAdapter = new PermAdapter(this, R.layout.perm_item_1, permList, this);
        permListView.setAdapter(permListAdapter);
        
        
    }
    
    @Override
	protected void onResume() {
		super.onResume();
	}
}