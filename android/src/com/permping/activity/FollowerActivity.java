package com.permping.activity;

import java.util.ArrayList;
import com.permping.R;
import com.permping.controller.PermListController;
import com.permping.model.Perm;
import com.permping.adapter.*;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.widget.ListView;


public class FollowerActivity extends Activity {
	
	public String url = "";
	public Boolean header = true;
	
	private ArrayList<Perm> permListMain;
	
	
	private ProgressDialog dialog;
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
        setContentView(R.layout.followers_layout);
        
        
    	Bundle extras = getIntent().getExtras();
		if( extras != null ) {
			this.url = (String) extras.get("boardUrl");
			this.header = false;
		}
		 ListView permListView = (ListView) findViewById(R.id.permList);
		 /*
	        PermListController permListController = new PermListController( );
	        
	        ArrayList<Perm> permList = permListController.getPermList( url );
	        
	        PermAdapter permListAdapter = new PermAdapter(FollowerActivity.this, R.layout.perm_item_1, permList, FollowerActivity.this, header);
	        permListView.setAdapter(permListAdapter);
	        */
		 
		 
		 dialog = ProgressDialog.show(getParent(), "Loading","Please wait...", true);
		 new LoadPermList().execute();
    }
    
    @Override
	protected void onResume() {
		super.onResume();
	}
    
    private void loadPerms(){
    	ListView permListView = (ListView) findViewById(R.id.permList);
    	PermAdapter permListAdapter = new PermAdapter(this, R.layout.perm_item_1, permListMain, this, header);
	    permListView.setAdapter(permListAdapter);
    }
    
    
    
    
  //AsyncTask task for upload file
	
  	class LoadPermList extends AsyncTask<Void, Void, String> {

  		
  		@Override
  		protected String doInBackground(Void... params) {
  	        PermListController permListController = new PermListController( );
  	        ArrayList<Perm> permList = permListController.getPermList( url );
  	        
  	        permListMain = permList;
  			return null;
  		}
  		
  		@Override
  		protected void onProgressUpdate(Void... unsued) {

  		}

  		@Override
  		protected void onPostExecute(String sResponse) {
  			loadPerms();
  			if (dialog.isShowing()){
  				dialog.dismiss();
  			}
  		}
  	}
}