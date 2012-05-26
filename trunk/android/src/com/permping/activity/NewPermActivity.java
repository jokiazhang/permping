package com.permping.activity;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStreamReader;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;

import com.permping.R;
import com.permping.utils.API;

import android.app.Activity;
import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class NewPermActivity extends Activity {

	private String imagePath = "";
	private ProgressDialog dialog;
	
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        setContentView(R.layout.new_perm_layout);
        
        
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
				ByteArrayOutputStream bos = new ByteArrayOutputStream();
				Bitmap bm = BitmapFactory.decodeFile(filePath);;
				bm.compress(CompressFormat.JPEG, 75, bos);
				byte[] data = bos.toByteArray();
				
				HttpClient httpClient = new DefaultHttpClient();
				HttpPost postRequest = new HttpPost("http://10.0.2.2/perm/testupload.php");
				//HttpPost postRequest = new HttpPost(API.addNewPermUrl);
				String fileName = new File(filePath).getName();
				ByteArrayBody bab = new ByteArrayBody(data, fileName);
				MultipartEntity reqEntity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
				reqEntity.addPart("url", bab);
				reqEntity.addPart("photoCaption", new StringBody(fileName));
				postRequest.setEntity(reqEntity);
				HttpResponse response = httpClient.execute(postRequest);
				BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"));
				
				String sResponse;
				StringBuilder s = new StringBuilder();
				while ((sResponse = reader.readLine()) != null) {
					s = s.append(sResponse);
				}
				System.out.println("Response: " + s);
			} catch (Exception e) {
				// handle exception here
				
				ImageActivityGroup.group.back();
				Toast.makeText(getApplicationContext(),"Post error",Toast.LENGTH_LONG).show();
				Log.e(e.getClass().getName(), e.getMessage());
			}
		}
		
		
		
		@Override
		protected void onProgressUpdate(Void... unsued) {

		}

		@Override
		protected void onPostExecute(String sResponse) {
			
			if (dialog.isShowing()){
				dialog.dismiss();
				//Toast.makeText(getApplicationContext(),sResponse,Toast.LENGTH_LONG).show();
				ImageActivityGroup.group.back();
			}
			
		}
	}
	
	
}
