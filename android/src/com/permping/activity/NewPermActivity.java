package com.permping.activity;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.HTTP;
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
import android.graphics.Path;
import android.graphics.Typeface;
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
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
import com.permping.R;
import com.permping.adapter.BoardSpinnerAdapter;
import com.permping.model.Category;
import com.permping.model.PermBoard;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.KakaoLink;
import com.permping.utils.PermUtils;

public class NewPermActivity extends Activity implements OnClickListener {

	public static List<PermBoard> boardList = new ArrayList<PermBoard>();
	private String boardIdRe ="";
	private String boardDescRe = "";
	private String permIdRe = "";
	private String userIdRe = "";
	private String imagePath = "";
	private int boardId = -1;
	private String permAndroidLink="";
	private String permIphoneLink="";
	public static int LOGIN_FACEBOOK = 1;
	public static int MESSAGE_LOGIN_FACEBOOK_ERROR = 100;
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
	private List<PermBoard> boards;
	private LinearLayout btnCatilogy;
	private ImageView rightArrow;
//	private ProgressDialog loadingDialog;
	ProgressBar progressBar;
	Button btnOk;
	private Context context;
	public static boolean  isReperm = false;
	private boolean uploadStatus = false;
	public Handler handleFbLogin = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if (msg.what == LOGIN_FACEBOOK) {
				
				showLoadingDialog("Processing", "Please wait...");
//				new LoadBoards().execute();
//				new ImageUpload(imagePath).execute();
				btnShareFacebook.setChecked(true);
			}
			
			if (msg.what == MESSAGE_LOGIN_FACEBOOK_ERROR) {
				btnShareFacebook.setChecked(false);
			}
		}
	};

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// setContentView(R.layout.new_perm_layout);
		setContentView(R.layout.new_perm_layout);
		
		TextView textView = (TextView)findViewById(R.id.permpingTitle);
		Typeface tf = Typeface.createFromAsset(getAssets(), "ufonts.com_franklin-gothic-demi-cond-2.ttf");
		if(textView != null) {
			textView.setTypeface(tf);
		}
		progressBar = (ProgressBar)findViewById(R.id.progressBar2);
		btnShareFacebook = (ToggleButton) findViewById(R.id.share_facebookr);
		btnShareTwitter = (ToggleButton) findViewById(R.id.share_twitter);
		btnShareKakao = (ToggleButton) findViewById(R.id.share_kakao);
		btnLocation = (ToggleButton) findViewById(R.id.location);
		btnCatilogy = (LinearLayout) findViewById(R.id.categoryItemLayout1);
		rightArrow = (ImageView)findViewById(R.id.rightArrow);
		rightArrow.setOnClickListener(this);
		btnShareFacebook.setOnClickListener(this);
		btnShareTwitter.setOnClickListener(this);
		btnShareKakao.setOnClickListener(this);
		btnLocation.setOnClickListener(this);
		btnCatilogy.setOnClickListener(this);
		permUtils = new PermUtils();
		final Button buttonCANCEL = (Button) findViewById(R.id.buttonCANCEL);
		buttonCANCEL.setOnClickListener(this);
		btnOk = (Button) findViewById(R.id.buttonOK);
		btnOk.setOnClickListener(this);
		permDesc = (EditText) findViewById(R.id.permDesc);
		initToggleStatus();
		mlocManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
		mlocListener = new MyLocationListener();
		context = NewPermActivity.this;
		Bundle extras = getIntent().getExtras();
		if (extras != null) {
			if(extras.get("reperm") != null){
				isReperm = true;
				boardIdRe = (String) extras.getString("boardId");
				boardDescRe = (String) extras.getString("boardDesc");
				permIdRe = (String) extras.getString("permId");
				userIdRe = (String) extras.getString("userId");
				initValue();
				new LoadBoards().execute();
			}else{
				this.imagePath = (String) extras.get("imagePath");
				if (extras.get("permID") != null)
					this.permID = Integer.parseInt((String) extras.get("permID"));
				new LoadBoards().execute();
			}

		}

	}

	private void initValue() {
		// TODO Auto-generated method stub
		if(boardDescRe != null)
			permDesc.setText(this.boardDescRe);
//		btnShareFacebook.setEnabled(false);
//		btnShareTwitter.setEnabled(false);
		btnShareKakao.setEnabled(false);
	}

	private void initToggleStatus() {
		// TODO Auto-generated method stub
		facebookToken = permUtils.getFacebookToken(NewPermActivity.this);
		twitterAccessToken = permUtils.getTwitterAccess(NewPermActivity.this);
		if (facebookToken == null || facebookToken == "") {// &&
															// facebookToken.isEmpty()
			btnShareFacebook.setChecked(false);
		} else {
			btnShareFacebook.setChecked(true);
		}
		if (twitterAccessToken == null) {
			btnShareTwitter.setChecked(false);

		} else {
			btnShareTwitter.setChecked(true);
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
		boardSelect.setOnItemSelectedListener(new CategorySpinnerSelectedListener());
	}

	private void addItemsOnMainCategory(Spinner spinner,
			List<PermBoard> boards2) {
		BoardSpinnerAdapter boardSpinnerAdapter = new BoardSpinnerAdapter(this,
				boards2);
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
			dismissLoadingDialog();

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
					Charset chars = Charset.forName("UTF-8");
					facebookToken = permUtils.getFacebookToken(NewPermActivity.this);
					twitterAccessToken = permUtils.getTwitterAccess(NewPermActivity.this);

					MultipartEntity reqEntity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE, null, Charset.forName(HTTP.UTF_8));
					if (!isReperm && filePath != null && !"".equals(filePath)) {
						postRequest = new HttpPost(API.addNewPermUrl);

						ByteArrayOutputStream bos = new ByteArrayOutputStream();
						Bitmap bm = BitmapFactory.decodeFile(filePath);
//						bm = getBitmap(filePath);
						bm.compress(CompressFormat.JPEG, 75, bos);
						byte[] data = bos.toByteArray();

						String fileName = new File(filePath).getName();
						ByteArrayBody bab = new ByteArrayBody(data, fileName);
						reqEntity.addPart("img", bab);
						reqEntity.addPart("photoCaption", new StringBody(
								fileName, chars));
						reqEntity.addPart("uid", new StringBody(user.getId(), chars));
						reqEntity.addPart("board",
								new StringBody(String.valueOf(boardId), chars));
						reqEntity.addPart("board_desc", new StringBody(permDesc
								.getText().toString(), chars));
					} else if (isReperm ) { // Reperm
						postRequest = new HttpPost(API.repermUrl);

						reqEntity.addPart("pid",
								new StringBody(String.valueOf(permIdRe), chars));
						reqEntity.addPart("uid", new StringBody(String.valueOf(userIdRe), chars));
						reqEntity.addPart("board",
								new StringBody(String.valueOf(boardId), chars));
						reqEntity.addPart("board_desc", new StringBody(permDesc
								.getText().toString(), chars));
					}
					String type = "";
					if (facebookToken != null){
						reqEntity.addPart("fb_oauth_token", new StringBody(
								facebookToken, chars));
						type = "facebook";
					}
					if (twitterAccessToken != null) {
						reqEntity.addPart("tw_oauth_token", new StringBody(
								twitterAccessToken.getToken(), chars));
						reqEntity.addPart(
								"tw_oauth_token_secret",
								new StringBody(twitterAccessToken
										.getTokenSecret(), chars));
						type = "twitter";
					}
					if( facebookToken != null && twitterAccessToken != null){
						type = "all";
					}
					reqEntity.addPart("type", new StringBody("" + type, chars));
					reqEntity.addPart("lat", new StringBody("" + lat, chars));
					reqEntity.addPart("long", new StringBody("" + lon, chars));
					postRequest.setEntity(reqEntity);
					HttpResponse response = httpClient.execute(postRequest);
					HttpEntity entry = response.getEntity();
					String readFile = EntityUtils.toString(entry);

					parseXmlFile(readFile);
					}
			} catch (Exception e) {

			}
			// Toast.makeText(getApplicationContext(),"Please login first!",Toast.LENGTH_LONG).show();
		}

		private Bitmap checkBitmapSize(Bitmap bm) {
			// TODO Auto-generated method stub
			Bitmap bmResult = null;
			return bmResult;
		}
		  private Bitmap getBitmap(String path) {
			    try {
			        final int IMAGE_MAX_SIZE = 1200000; // 1.2MP
			        // Decode image size
			        BitmapFactory.Options o = new BitmapFactory.Options();
			        o.inJustDecodeBounds = true;
			        int scale = 1;
			        while ((o.outWidth * o.outHeight) * (1 / Math.pow(scale, 2)) > IMAGE_MAX_SIZE) {
			            scale++;
			        }
			        Log.d("","scale = " + scale + ", orig-width: " + o.outWidth       + ", orig-height: " + o.outHeight);

			        Bitmap b = null;
			        if (scale > 1) {
			            scale--;
			            // scale to max possible inSampleSize that still yields an image
			            // larger than target
			            o = new BitmapFactory.Options();
			            o.inSampleSize = scale;
			            b = BitmapFactory.decodeFile(path);

			            // resize to desired dimensions
			            int height = b.getHeight();
			            int width = b.getWidth();
			            Log.d("", "1th scale operation dimenions - width: " + width    + ", height: " + height);

			            double y = Math.sqrt(IMAGE_MAX_SIZE
			                    / (((double) width) / height));
			            double x = (y / height) * width;

			            Bitmap scaledBitmap = Bitmap.createScaledBitmap(b, (int) x,     (int) y, true);
			            b.recycle();
			            b = scaledBitmap;

			            System.gc();
			        } else {
			            b = BitmapFactory.decodeFile(path);
			        }


			        Log.d("", "bitmap size - width: "+b.getWidth()+ ", height: " + b.getHeight()+"");
			        return b;
			    } catch (Exception e) {
			        Log.e("", e.getMessage(),e);
			        return null;
			    }
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

					NodeList nameListLink = fstElmnt
							.getElementsByTagName("permAndroidLink");
					Element nameElementLink = null;
					if (nameListLink != null) {
						nameElementLink = (Element) nameListLink.item(0);
						nameListLink = nameElementLink.getChildNodes();
						permAndroidLink = ((Node) nameListLink.item(0))
								.getNodeValue();

					}
					NodeList nameListLinkIphone = fstElmnt
							.getElementsByTagName("permIphoneLink");
					Element nameElementLinkIphone = null;
					if (nameListLinkIphone != null) {
						nameElementLinkIphone = (Element) nameListLinkIphone.item(0);
						nameListLinkIphone = nameElementLinkIphone.getChildNodes();
						permIphoneLink = ((Node) nameListLinkIphone.item(0))
								.getNodeValue();

					}
					NodeList nameListId = fstElmnt
							.getElementsByTagName("permId");
					Element nameElementId = null;
					if (nameListId != null) {
						nameElementId = (Element) nameListId.item(0);
						nameListId = nameElementId.getChildNodes();
						permId = ((Node) nameListId.item(0))
								.getNodeValue();

					}
					NodeList nameList = fstElmnt
							.getElementsByTagName("errorcode");
					Element nameElement = null;
					if (nameList != null) {
						nameElement = (Element) nameList.item(0);
						if( nameElement != null){
							nameList = nameElement.getChildNodes();
							String status = ((Node) nameList.item(0))
									.getNodeValue();
							if (status.equals("200")){
								uploadStatus = true;
								return true;
							}	
						}
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

			if (progressBar.getVisibility()==View.VISIBLE) {
				dismissLoadingDialog();
//				ImageActivityGroup.group.back();
				if (btnShareKakao.isChecked()) {
					if( isReperm){
						Toast.makeText(getApplicationContext(),
								"Re-Permed  and shared to Kakao app!",
								Toast.LENGTH_LONG).show();
						isReperm = false;
					}else{
						Toast.makeText(getApplicationContext(),
								"Uploaded new perm \nLet share on Kakao app!",
								Toast.LENGTH_LONG).show();
						if (uploadStatus && btnShareKakao.isChecked()) {//uploadStatus && 
							try {
								gotoKakao();
							} catch (Exception e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						} else {

						}

					}

				} else {
					if(isReperm){
						Toast.makeText(getApplicationContext(),
								"Re-Permed!", Toast.LENGTH_LONG).show();
						isReperm =false;
					}else{
						Toast.makeText(getApplicationContext(),
								"Uploaded new perm!", Toast.LENGTH_LONG).show();
					}
					ImageActivityGroup.uploaded =true;
					finish();
				}
				
			}

		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		dismissLoadingDialog();
	}

	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		int id = arg0.getId();
		switch (id) {
		case R.id.buttonCANCEL:
//			ImageActivityGroup.group.back();
			finish();
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
			break;
		case R.id.rightArrow:
//			new LoadBoards().execute();
			new CategorySpinnerSelectedListener();
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
		if (btnShareKakao.isChecked())
			btnShareKakao.setChecked(true);
		else
			btnShareKakao.setChecked(false);
	}

	private void shareTwitter() {
		// TODO Auto-generated method stub
		if (twitterAccessToken == null) {
			Intent i = new Intent(context, PrepareRequestTokenActivity.class);
			context.startActivity(i);	
			btnShareTwitter.setChecked(true);
		} else {
			btnShareTwitter.setChecked(true);
		}
	}

	private void shareFb() {
		facebookToken = permUtils.getFacebookToken(NewPermActivity.this);
		if (facebookToken == null || facebookToken == "") {
			permUtils.integateLoginFacebook(NewPermActivity.this,
					handleFbLogin);
		} else {
			btnShareFacebook.setChecked(false);
			permUtils.logOutFacebook(NewPermActivity.this);
		}		
	}

	private void uploadPerm() {
		// TODO Auto-generated method stub
		if (facebookToken == null && twitterAccessToken == null) {
			Toast.makeText(getApplicationContext(),
					"Please choose the share type!", Toast.LENGTH_LONG).show();
		} else {
			if (imagePath != "" || permID > 0) {

				showLoadingDialog("Processing", "Please wait...");
				new ImageUpload(imagePath).execute();

			}else if(isReperm){
				showLoadingDialog("Processing", "Please wait...");
				new ImageUpload(imagePath).execute();
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

	public void gotoKakao() throws Exception {

		try {
			String strMessage = "pindetails/" + permId;// "카카오링크를 사용하여 메세지를 전달해 보세요.";
			String strURL = "Android: "+permAndroidLink+" & Iphone: "+permIphoneLink;//"http://link.kakao.com";
			String strAppId = "com.kakao.android.image";
			String strAppVer = "2.0";
			String strAppName = "[Permping]";// "[카카오톡]";
			String strInstallUrl = "Android: "+permAndroidLink+" &Iphone: "+permIphoneLink;;
			ArrayList<Map<String, String>> arrMetaInfo = new ArrayList<Map<String, String>>();

			Map<String, String> metaInfoAndroid = new Hashtable<String, String>(
					1);
			metaInfoAndroid.put("os", "android");
			metaInfoAndroid.put("devicetype", "phone");
			metaInfoAndroid.put("installurl", strInstallUrl);
			metaInfoAndroid.put("executeurl", "android.com");
			arrMetaInfo.add(metaInfoAndroid);
			KakaoLink link = new KakaoLink(NewPermActivity.this, strURL,
					strAppId, strAppVer, strMessage, strAppName, arrMetaInfo,
					"UTF-8");

			if (link.isAvailable()) {
				startActivity(link.getIntent());
			}
			startActivity(link.getIntent());
			
		} catch (Exception e) {
			// TODO: handle exception
		}

	}
	private void showLoadingDialog(String title, String msg) {
//		loadingDialog = new ProgressDialog(context);
//		loadingDialog.setMessage(msg);
//		loadingDialog.setTitle(title);
//		loadingDialog.setCancelable(true);
//		loadingDialog.show();
		btnOk.setVisibility(View.INVISIBLE);
		progressBar.setVisibility(View.VISIBLE);
	}

	private void dismissLoadingDialog() {
//		if (loadingDialog != null )
//			if(loadingDialog.isShowing())
//				loadingDialog.dismiss();
		if(progressBar.getVisibility()==View.VISIBLE){
			progressBar.setVisibility(View.INVISIBLE);
			btnOk.setVisibility(View.VISIBLE);
		}
		
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
//			PermpingMain.back();
			finish();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}
}
