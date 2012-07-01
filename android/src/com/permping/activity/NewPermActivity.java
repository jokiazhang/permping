package com.permping.activity;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import twitter4j.http.AccessToken;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.Toast;
import android.widget.ToggleButton;

import com.permping.PermpingApplication;
import com.permping.R;
import com.permping.adapter.BoardSpinnerAdapter;
import com.permping.model.Category;
import com.permping.model.PermBoard;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.KakaoLink;
import com.permping.utils.PermUtils;

public class NewPermActivity extends Activity implements OnClickListener {

	private String imagePath = "";
	private ProgressDialog dialog;
	private int boardId = -1;
	public static int LOGIN_FACEBOOK = 1;
	public static int LOGIN_TWITTER = 2;
	public static int SHARE_FB = 1;
	public static int SHARE_TWITTER = 2;
	public int type = 0;
	private int permID = -1;
	private ToggleButton btnShareFacebook;
	private ToggleButton btnShareTwitter;
	private ToggleButton btnShareKakao;
	private ToggleButton btnLocation;
	private EditText permDesc;
	private String facebookToken;
	private AccessToken twitterAccessToken;
	private double lat = 0.0;
	private double lon = 0.0;
	private PermUtils permUtils;
	private LocationManager mlocManager;
	private LocationListener mlocListener;
	private ArrayList<Category> categories;
	private String permId;
	private ArrayList<PermBoard> boards;
	private LinearLayout btnCatilogy;
	public Handler handleFbLogin = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if (msg.what == LOGIN_FACEBOOK) {
				dialog = ProgressDialog.show(getParent(), "Loading",
						"Please wait...", true);
				new LoadBoards().execute();
				new ImageUpload(imagePath).execute();
			}
		}
	};

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// setContentView(R.layout.new_perm_layout);
		View contentView = LayoutInflater.from(getParent()).inflate(
				R.layout.new_perm_layout, null);
		setContentView(contentView);
		btnShareFacebook = (ToggleButton) contentView
				.findViewById(R.id.share_facebookr);
		btnShareTwitter = (ToggleButton) contentView
				.findViewById(R.id.share_twitter);
		btnShareKakao = (ToggleButton) contentView
				.findViewById(R.id.share_kakao);
		btnLocation = (ToggleButton) contentView.findViewById(R.id.location);
		btnCatilogy = (LinearLayout)contentView.findViewById(R.id.categoryItemLayout1);
		btnShareFacebook.setOnClickListener(this);
		btnShareTwitter.setOnClickListener(this);
		btnShareKakao.setOnClickListener(this);
		btnLocation.setOnClickListener(this);
		btnCatilogy.setOnClickListener(this);
		permUtils = new PermUtils();
		Bundle extras = getIntent().getExtras();
		if (extras != null) {
			this.imagePath = (String) extras.get("imagePath");
			if (extras.get("permID") != null)
				this.permID = Integer.parseInt((String) extras.get("permID"));

		}

		final Button buttonCANCEL = (Button) findViewById(R.id.buttonCANCEL);
		buttonCANCEL.setOnClickListener(this);

		final Button buttonOK = (Button) findViewById(R.id.buttonOK);
		buttonOK.setOnClickListener(this);
		permDesc = (EditText) findViewById(R.id.permDesc);
		initToggleStatus();
		mlocManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
		mlocListener = new MyLocationListener();
		new LoadBoards().execute();

	}

	private void initToggleStatus() {
		// TODO Auto-generated method stub
		facebookToken = permUtils.getFacebookToken(NewPermActivity.this);
		twitterAccessToken = permUtils.getTwitterAccess(NewPermActivity.this);
		if (facebookToken == null || facebookToken.isEmpty()) {
			btnShareFacebook.setChecked(false);
		} else {
			btnShareFacebook.setChecked(true);
		}
		if (twitterAccessToken == null) {
			btnShareTwitter.setChecked(false);

		} else {
			btnShareTwitter.setChecked(false);
		}
		if (btnLocation.isChecked()) {
			mlocManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0,
					0, mlocListener);
		} else {
			lon = 0;
			lat = 0;
		}
	}

	public void onBackPressed() {
		super.onBackPressed();
	}

	/*
	 * (non-Javadoc)
	 * 
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

			Log.d("CreatePerm",
					"Touch event " + event.getRawX() + "," + event.getRawY()
							+ " " + x + "," + y + " rect " + w.getLeft() + ","
							+ w.getTop() + "," + w.getRight() + ","
							+ w.getBottom() + " coords " + scrcoords[0] + ","
							+ scrcoords[1]);
			if (event.getAction() == MotionEvent.ACTION_UP
					&& (x < w.getLeft() || x >= w.getRight() || y < w.getTop() || y > w
							.getBottom())) {
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(getWindow().getCurrentFocus()
						.getWindowToken(), 0);
			}
		}
		return ret;
	}

	public void setSpinnerData() {
		Spinner boardSelect = (Spinner) findViewById(R.id.boardSpinnerNewPerm);
		addItemsOnMainCategory(boardSelect, boards);
		boardSelect
				.setOnItemSelectedListener(new CategorySpinnerSelectedListener());
	}

	private void addItemsOnMainCategory(Spinner spinner,
			ArrayList<PermBoard> boards) {
		BoardSpinnerAdapter boardSpinnerAdapter = new BoardSpinnerAdapter(this,
				boards);
		spinner.setAdapter(boardSpinnerAdapter);
		PermBoard initial = (PermBoard) boardSpinnerAdapter.getItem(0);
		if (initial != null)
			boardId = Integer.parseInt(initial.getId());
	}

	private class CategorySpinnerSelectedListener implements
			OnItemSelectedListener {

		public void onItemSelected(AdapterView<?> parent, View view, int pos,
				long id) {
			PermBoard board = (PermBoard) parent.getItemAtPosition(pos);
			boardId = Integer.parseInt(board.getId());
		}

		public void onNothingSelected(AdapterView<?> arg0) {
			// TODO Auto-generated method stub

		}
	}

	class LoadBoards extends AsyncTask<Void, Void, String> {

		@Override
		protected String doInBackground(Void... params) {
			// CategoryController catController = new CategoryController();
			// categories = catController.getCategoryList();
			// BoardController boardController = new BoardController();
			User user = PermUtils.isAuthenticated(getApplicationContext());
			if (user != null)
				// boards = boardController.getBoardList("121");
				boards = (ArrayList<PermBoard>) user.getBoards();
			else {
				// User has no boards created
			}
			return null;
		}

		@Override
		protected void onProgressUpdate(Void... unsued) {

		}

		@Override
		protected void onPostExecute(String sResponse) {
			
			setSpinnerData();
			if(dialog != null){
				if (dialog.isShowing()) {
					dialog.dismiss();
				}	
			}
			

		}
	}

	// AsyncTask task for upload file

	class ImageUpload extends AsyncTask<Void, Void, String> {

		String filePath = "";

		public ImageUpload(String filePath) {
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

				if (user != null) {

					HttpClient httpClient = new DefaultHttpClient();
					// HttpPost postRequest = new
					// HttpPost("http://10.0.2.2/perm/testupload.php");
					HttpPost postRequest = null;
					MultipartEntity reqEntity = new MultipartEntity(
							HttpMultipartMode.BROWSER_COMPATIBLE);
					if (filePath != null && !"".equals(filePath)) {
						postRequest = new HttpPost(API.addNewPermUrl);

						ByteArrayOutputStream bos = new ByteArrayOutputStream();
						Bitmap bm = BitmapFactory.decodeFile(filePath);
						;
						bm.compress(CompressFormat.JPEG, 75, bos);
						byte[] data = bos.toByteArray();

						String fileName = new File(filePath).getName();
						ByteArrayBody bab = new ByteArrayBody(data, fileName);
						reqEntity.addPart("img", bab);
						reqEntity.addPart("photoCaption", new StringBody(
								fileName));
					} else if (permID > 0) { // Reperm
						postRequest = new HttpPost(API.repermUrl);

						reqEntity.addPart("pid",
								new StringBody(String.valueOf(permID)));
					}
					reqEntity.addPart("uid", new StringBody(user.getId()));
					reqEntity.addPart("board",
							new StringBody(String.valueOf(boardId)));
					reqEntity.addPart("board_desc", new StringBody(permDesc
							.getText().toString()));
					if (facebookToken != null)
						reqEntity.addPart("fb_oauth_token", new StringBody(
								facebookToken));
					if (twitterAccessToken != null) {
						reqEntity.addPart("tw_oauth_token", new StringBody(
								twitterAccessToken.getToken()));
						reqEntity.addPart(
								"tw_oauth_token_secret",
								new StringBody(twitterAccessToken
										.getTokenSecret()));
					}
					reqEntity.addPart("lat", new StringBody("" + lat));
					reqEntity.addPart("long", new StringBody("" + lon));
					postRequest.setEntity(reqEntity);
					HttpResponse response = httpClient.execute(postRequest);
					HttpEntity entry = response.getEntity();
					String readFile = EntityUtils.toString(entry);

					boolean uploadStatus = parseXmlFile(readFile);
					if( uploadStatus && btnShareKakao.isChecked()){
						gotoKakao();
					}else{

					}
				}
			} catch (Exception e) {

			}
			// Toast.makeText(getApplicationContext(),"Please login first!",Toast.LENGTH_LONG).show();
		}

		boolean parseXmlFile(String xmlFile) {
			Document doc = null;

			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			try {

				DocumentBuilder db = dbf.newDocumentBuilder();

				InputSource is = new InputSource();
				is.setCharacterStream(new StringReader(xmlFile));
				if (is != null)
					doc = db.parse(is);
				doc.getDocumentElement().normalize();

				NodeList nodeList = doc.getElementsByTagName("respond");

				/** Assign textview array lenght by arraylist size */
				int length = nodeList.getLength();

				for (int i = 0; i < length; i++) {

					Node node = nodeList.item(i);
					Element fstElmnt = (Element) node;
					NodeList nameList = fstElmnt
							.getElementsByTagName("errorcode");
					Element nameElement = null;
					if (nameList != null) {
						nameElement = (Element) nameList.item(0);
						nameList = nameElement.getChildNodes();
						String status = ((Node) nameList.item(0))
								.getNodeValue();
						if (status != null)
							return true;
					}

				}

			} catch (ParserConfigurationException e) {
				System.out.println("XML parse error: " + e.getMessage());
				return false;
			} catch (SAXException e) {
				System.out.println("Wrong XML file structure: "
						+ e.getMessage());
				return false;
			} catch (IOException e) {
				System.out.println("I/O exeption: " + e.getMessage());
				return false;
			}

			return false;
		}

		@Override
		protected void onProgressUpdate(Void... unsued) {

		}

		@Override
		protected void onPostExecute(String sResponse) {

			if (dialog.isShowing()) {
				dialog.dismiss();
				ImageActivityGroup.group.back();
				if(btnShareKakao.isChecked()){
					Toast.makeText(getApplicationContext(),
							"Uploaded new perm and shared to Kakao app!", Toast.LENGTH_LONG).show();
				}else{
					Toast.makeText(getApplicationContext(),
							"Uploaded new perm!", Toast.LENGTH_LONG).show();
				}
			}

		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (dialog.isShowing()) {
			dialog.dismiss();
		}
	}

	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		int id = arg0.getId();
		switch (id) {
		case R.id.buttonCANCEL:
			ImageActivityGroup.group.back();
			break;
		case R.id.buttonOK:
			uploadPerm();
			break;
		case R.id.share_facebookr:
			shareFb();
			break;
		case R.id.share_twitter:
			shareTwitter();
			break;
		case R.id.share_kakao:
			shareKakao();
			break;
		case R.id.location:
			locationChange();
		case R.id.categoryItemLayout1:
			new LoadBoards().execute();
			break;
		default:
			break;
		}
	}

	private void locationChange() {
		// TODO Auto-generated method stub
		if (btnLocation.isChecked()) {
			lat = 0;
			lon = 0;

		} else {
			mlocManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0,
					0, mlocListener);
		}
	}

	private void shareKakao() {
		// TODO Auto-generated method stub
		if(btnShareKakao.isChecked())
			btnShareFacebook.setChecked(false);
		else
			btnShareKakao.setChecked(true);
	}

	private void shareTwitter() {
		// TODO Auto-generated method stub

	}

	private void shareFb() {
		// TODO Auto-generated method stub
		facebookToken = permUtils.getFacebookToken(NewPermActivity.this);
		if( btnShareFacebook.isChecked()){
			btnShareFacebook.setChecked(false);
			permUtils.logOutFacebook(NewPermActivity.this);
		
		}else{
			if (facebookToken == null || facebookToken.isEmpty()) {
				permUtils.integateLoginFacebook(NewPermActivity.this, handleFbLogin);
			}
		}
	}

	private void uploadPerm() {
		// TODO Auto-generated method stub
		File file = new File(imagePath);
		long length = file.length();
		Bitmap bmpPic = BitmapFactory.decodeFile(imagePath);
		if ((bmpPic.getWidth() >= 1024) && (bmpPic.getHeight() >= 1024)) {
		    BitmapFactory.Options bmpOptions = new BitmapFactory.Options();
		    bmpOptions.inSampleSize = 1;
		    while ((bmpPic.getWidth() >= 1024) && (bmpPic.getHeight() >= 1024)) {
		        bmpOptions.inSampleSize++;
		        bmpPic = BitmapFactory.decodeFile(imagePath, bmpOptions);
		    }
		   
		}
//		int compressQuality = 104; // quality decreasing by 5 every loop. (start from 99)
//		int streamLength = 1024;
//		while (streamLength >= 1024) {
//		    ByteArrayOutputStream bmpStream = new ByteArrayOutputStream();
//		    compressQuality -= 5;
//		    bmpPic.compress(Bitmap.CompressFormat.JPEG, compressQuality, bmpStream);
//		    byte[] bmpPicByteArray = bmpStream.toByteArray();
//		    streamLength = bmpPicByteArray.length;
//		    Log.d("Size: ","======>" + streamLength);
//		}
//		try {
//		    FileOutputStream bmpFile = new FileOutputStream(imagePath);
//		    bmpPic.compress(Bitmap.CompressFormat.JPEG, compressQuality, bmpFile);
//		    bmpFile.flush();
//		    bmpFile.close();
//		} catch (Exception e) {
//		    
//		}
		if (facebookToken == null && facebookToken.isEmpty()
				&& twitterAccessToken == null) {
			Toast.makeText(getApplicationContext(),
					"Please choose the share type!", Toast.LENGTH_LONG).show();
		} else {
			if (imagePath != "" || permID > 0) {

				dialog = ProgressDialog.show(getParent(), "Uploading",
						"Please wait...", true);
				new ImageUpload(imagePath).execute();
				// if( facebookToken == null || facebookToken .isEmpty()){
				// permUtils.integateLoginFacebook(NewPermActivity.this,
				// handleFbLogin);
				// }else{
				// new ImageUpload( imagePath ).execute();
				// }
			}
		}

	}

	public class MyLocationListener implements LocationListener {

		@Override
		public void onLocationChanged(Location loc) {

			loc.getLatitude();

			loc.getLongitude();
			lat = loc.getLatitude();
			lon = loc.getLongitude();
		}

		@Override
		public void onProviderDisabled(String provider) {

		}

		@Override
		public void onProviderEnabled(String provider) {
		}

		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {

		}

	}/* End of Class MyLocationListener */
	public void gotoKakao() throws Exception{
		
		try {
			String strMessage = "pindetails/"+ permId;//"카카오링크를 사용하여 메세지를 전달해 보세요."; 
			String strURL = "http://link.kakao.com";
			String strAppId = "com.kakao.android.image";
			String strAppVer = "2.0";
			String strAppName = "[Permping]";//"[카카오톡]";
			String strInstallUrl = "market://details?id=com.kakao.talk"; 
			ArrayList<Map<String, String>> arrMetaInfo = new ArrayList<Map<String, String>>();
		
			Map<String, String> metaInfoAndroid = new Hashtable<String, String>(
					1);
			metaInfoAndroid.put("os", "android");
			metaInfoAndroid.put("devicetype", "phone");
			metaInfoAndroid.put("installurl", strInstallUrl);
			metaInfoAndroid.put("executeurl", "android.com");
			arrMetaInfo.add(metaInfoAndroid);
			KakaoLink link = new KakaoLink(NewPermActivity.this, strURL, strAppId, strAppVer,strMessage, strAppName, arrMetaInfo, "UTF-8");

			if (link.isAvailable()) {
				startActivity(link.getIntent());
			}
			startActivity(link.getIntent());
		} catch (Exception e) {
			// TODO: handle exception
		}

	}
}
