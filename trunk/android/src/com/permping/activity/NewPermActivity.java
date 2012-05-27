package com.permping.activity;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;

import com.permping.PermpingApplication;
import com.permping.R;
import com.permping.adapter.CategorySpinnerAdapter;
import com.permping.controller.CategoryController;
import com.permping.model.Category;
import com.permping.model.User;
import com.permping.utils.API;

import android.app.Activity;
import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

public class NewPermActivity extends Activity {

	private String imagePath = "";
	private ProgressDialog dialog;
	private int categoryId = -1;
	
	private EditText permDesc;
	
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        //setContentView(R.layout.new_perm_layout);
        View contentView = LayoutInflater.from(getParent()).inflate(R.layout.new_perm_layout, null);
        setContentView(contentView);
        
        Bundle extras = getIntent().getExtras();
		if( extras != null ) {
			this.imagePath = (String) extras.get("imagePath");
		}
        
        final Button buttonCANCEL = (Button) findViewById(R.id.buttonCANCEL);
        buttonCANCEL.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
              ImageActivityGroup.group.back();
			}
		});
        
        
        final Button buttonOK = (Button) findViewById(R.id.buttonOK);
        buttonOK.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
              if(imagePath != "" ){
            	  dialog = ProgressDialog.show(getParent(), "Uploading","Please wait...", true);
            	  new ImageUpload( imagePath ).execute();
              }
			}
		});
        
        
        permDesc = (EditText)findViewById(R.id.permDesc);
        
        CategoryController catController = new CategoryController();
		final ArrayList<Category> categories = catController.getCategoryList();
        Spinner mainCategory = (Spinner) findViewById(R.id.categorySpinnerNewPerm);
		addItemsOnMainCategory(mainCategory, categories);
		mainCategory.setOnItemSelectedListener(new CategorySpinnerSelectedListener());		
        
        
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
			// TODO Auto-generated method stub
			
		}		
	}
	
	
	//AsyncTask task for upload file
	
	class ImageUpload extends AsyncTask<Void, Void, String> {

		String filePath = "";
		
		public ImageUpload(String filePath ){
			this.filePath = filePath;
		}
		
		@Override
		protected String doInBackground(Void... params) {
			// TODO Auto-generated method stub
			try {
				executeMultipartPost();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return null;
		}
		
		
		public void executeMultipartPost() throws Exception {
			try {
				
				PermpingApplication state = (PermpingApplication) getApplicationContext();
		        User user = state.getUser();
		        
		        if( user!= null ){

					ByteArrayOutputStream bos = new ByteArrayOutputStream();
					Bitmap bm = BitmapFactory.decodeFile(filePath);;
					bm.compress(CompressFormat.JPEG, 75, bos);
					byte[] data = bos.toByteArray();
					
					HttpClient httpClient = new DefaultHttpClient();
					//HttpPost postRequest = new HttpPost("http://10.0.2.2/perm/testupload.php");
					HttpPost postRequest = new HttpPost(API.addNewPermUrl);
					String fileName = new File(filePath).getName();
					ByteArrayBody bab = new ByteArrayBody(data, fileName);
					MultipartEntity reqEntity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
					reqEntity.addPart("url", bab);
					//reqEntity.addPart("url", new StringBody( "http://www.allbestwallpapers.com/wallpaper/black/thumb/white_rose.jpg") );
					reqEntity.addPart("photoCaption", new StringBody(fileName));
					reqEntity.addPart("uid", new StringBody( user.getId() ) );
					reqEntity.addPart("board", new StringBody( String.valueOf( categoryId )));
					reqEntity.addPart("board_desc", new StringBody(permDesc.getText().toString()  ) );
					
					
					postRequest.setEntity(reqEntity);
					HttpResponse response = httpClient.execute(postRequest);
					BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"));
					
					String sResponse;
					StringBuilder s = new StringBuilder();
					while ((sResponse = reader.readLine()) != null) {
						s = s.append(sResponse);
					}
					System.out.println("Response: " + s);
		        }
			} catch (Exception e) {
				// handle exception here
				
				ImageActivityGroup.group.back();
				Toast.makeText(getApplicationContext(),"Post error",Toast.LENGTH_LONG).show();
				Log.e(e.getClass().getName(), e.getMessage());
			}
			Toast.makeText(getApplicationContext(),"Please login first!",Toast.LENGTH_LONG).show();
		}
		
		
		
		@Override
		protected void onProgressUpdate(Void... unsued) {

		}

		@Override
		protected void onPostExecute(String sResponse) {
			
			if (dialog.isShowing()){
				dialog.dismiss();
				ImageActivityGroup.group.back();
				Toast.makeText(getApplicationContext(),"Uploaded new perm!",Toast.LENGTH_LONG).show();
			}
			
		}
	}
	
	
}
