
package com.permping.activity;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;

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

import com.permping.PermpingApplication;
import com.permping.PermpingMain;
import com.permping.R;
import com.permping.adapter.BoardAdapter;
import com.permping.controller.BoardController;
import com.permping.interfaces.Get_Board_delegate;
import com.permping.model.Category;
import com.permping.model.Comment;
import com.permping.model.Perm;
import com.permping.model.PermBoard;
import com.permping.model.PermImage;
import com.permping.model.Transporter;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.PermUtils;
import com.permping.utils.UrlImageViewHelper;
import com.permping.utils.XMLParser;
import com.permping.utils.facebook.sdk.Util;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.graphics.Bitmap.CompressFormat;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class ProfileActivity extends Activity implements Get_Board_delegate{
	
	private ImageView authorAvatar;
	private TextView authorName;
	private TextView friends;
	private TextView followings;
	private Button btnAccount;
	public User user;
	public static Comment commentData = null;
	public static boolean isUserProfile = true;
	public static int userfollowcount;
	public static int pinCount;
	public static int followerCount;
	
	public static int UPDATE_BUTTON = 1;
	
	public ProgressDialog loadingDialog;
	public PermBoard board;
	public Context context;
	//private int selectedBoardId = -1;
	private BroadcastReceiver receiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {

			if (intent.getAction().equals(FollowerActivity.DOWNLOAD_COMPLETED)) {
				Log.d("thien", "======>>>>??????");
				exeUserProfile();
			} 
		}
	};
	
	public Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if (msg.what == UPDATE_BUTTON) {
				btnAccount.invalidate();
			}
		}
	};
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.profile_layout);
        
        TextView textView = (TextView)findViewById(R.id.permpingTitle);
		Typeface tf = Typeface.createFromAsset(getAssets(), "ufonts.com_franklin-gothic-demi-cond-2.ttf");
		if(textView != null) {
			textView.setTypeface(tf);
		}
		
        showLoadingDialog("Loading", "Please wait...");
        authorAvatar = (ImageView) findViewById(R.id.authorAvatar);
        authorName = (TextView) findViewById(R.id.authorName);
        friends = (TextView) findViewById(R.id.friends);
        followings = (TextView) findViewById(R.id.followings);
        btnAccount = (Button) findViewById(R.id.btAccount);
		IntentFilter intentFilter = new IntentFilter(FollowerActivity.DOWNLOAD_COMPLETED);
		registerReceiver(receiver, intentFilter);
		context = ProfileActivity.this;
		btnAccount.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				String buttonType = btnAccount.getText().toString();
				if(buttonType.equals(context.getString(R.string.logout))){
					Intent myIntent = new Intent(ProfileActivity.this, AccountActivity.class);
					View accountView = ProfileActivityGroup.group.getLocalActivityManager() .startActivity("AccountActivity", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
					ProfileActivityGroup.group.replaceView(accountView);
					
					//View view = getLocalActivityManager().startActivity( "FollowerActivity", new Intent(this, FollowerActivity.class).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
					
					/*PermUtils permUtils = new PermUtils();
					permUtils.logOutFacebook(getParent());
//					permUtils.saveTwitterAccess("twitter", "", getParent()):
					showLoadingDialog("Pregressing", "Please wait...");
					new exeFollow(API.logoutURL, false, true).execute(null);*/
				}else if(buttonType.equals(context.getString(R.string.follow))){
					showLoadingDialog("Pregressing", "Please wait...");
					new exeFollow(API.follow, true, false).execute(null);
				}else if(buttonType.equals(context.getString(R.string.unfollow))){
					showLoadingDialog("Pregressing", "Please wait...");
					new exeFollow(API.follow, true, false).execute(null);
				}else if(buttonType.equals(context.getString(R.string.login))){
					PermpingMain.showLogin();
				}
			}
		});
		PermUtils.clearViewHistory();       
    }
	
    protected void exeUserProfile() {
		// TODO Auto-generated method stub
		if( commentData != null) {
			if(commentData.getAuthor() != null) {
				new getUserProfile(API.getProfileURL+commentData.getAuthor().getId()).execute(null);
			} else {
				new getUserProfile(API.getProfileURL+commentData.getId()).execute(null);
			}
		}
	}
    
    @Override
    protected void onResume(){
    	super.onResume();
    	
    	 /** Load the information from Application (user info) when the page is loaded. */

    	execGetUserProfile();
    }
    public void execGetUserProfile(){

    	if(isUserProfile){
    		
    		user = PermUtils.isAuthenticated(getApplicationContext());
    		if(user != null){
    			btnAccount.setText(context.getString(R.string.logout));
    			ArrayList<PermBoard> boards = (ArrayList<PermBoard>) user.getBoards();
            	BoardAdapter boardAdapter = new BoardAdapter(ProfileActivity.this,R.layout.board_item, boards);
            	exeGet(boardAdapter);
            	btnAccount.setVisibility(View.VISIBLE);
            	btnAccount.invalidate();
    		}else{
    			btnAccount.setText(context.getString(R.string.login));
    			btnAccount.invalidate();
    			PermpingMain.showLogin();
    		}
    		dismissLoadingDialog();
    	}else{
    		
    		if(commentData != null){
    			if(commentData.getAuthor() != null) {
    				if(commentData.getAuthor().getId() != null){
//    		    		showLoadingDialog("Loading", "Please wait");
    		    			new getUserProfile(API.getProfileURL+commentData.getAuthor().getId()).execute(null);
    					
    				}
    			} else {
    				new getUserProfile(API.getProfileURL+commentData.getId()).execute(null);
    			}
    		}
    	}
    }
 
    public void exeGet( BoardAdapter boardAdapter){
    	try {
    	   
            if (user != null) {
            	if(commentData == null) {
            		// The author name
                	String name = user.getName();
                    authorName.setText(name);
                    
                    // The author avatar
                	PermImage avatar = user.getAvatar();
                    UrlImageViewHelper.setUrlDrawable(authorAvatar, avatar.getUrl());
                    
                    // The number of friends
                    friends.setText(String.valueOf(user.getFriends()) + " "+ ProfileActivity.this.getString(R.string.followers));
            	} else {
	                authorName.setText(commentData.getAuthor().getName());
	                PermImage avatar = commentData.getAuthor().getAvatar();
	                UrlImageViewHelper.setUrlDrawable(authorAvatar, avatar.getUrl());
	                friends.setText(String.valueOf(ProfileActivity.this.getString(R.string.perm) + " " + ProfileActivity.pinCount + ProfileActivity.this.getString(R.string.followers) + " " + ProfileActivity.followerCount));
            	}
                
                // The number of followings
//                followings.setText(String.valueOf(user.getFollowings() + " followings"));
                
                // Build the list of user's boards
                ListView userBoards = (ListView) findViewById(R.id.userBoards);
                userBoards.setAdapter(boardAdapter);
                userBoards.setOnItemClickListener(new BoardClickListener());
            } else {
            	PermpingMain.showLogin();
            }        
			
		} catch (Exception e) {
			// TODO: handle exception
		}
    }
    class exeFollow extends AsyncTask<String, Void, Boolean> {

		private String filePath = "";
		public  String title = "";
		public boolean isSuccess =false;
		public boolean isFollow;
		public boolean isLogout;
		public exeFollow(String filePath, boolean isFollow, boolean isLogout) {
			this.filePath = filePath;
			this.isFollow = isFollow;
			this.isLogout = isLogout;
		}
		
		@Override
		protected Boolean doInBackground(String... arg0) {
			// TODO Auto-generated method stub
			try {

				isSuccess = (Boolean)executeMultipartPost( filePath, isFollow, isLogout);
				return isSuccess;
				
			} catch (Exception e) {
				// TODO: handle exception
			}
			return null;
		}

		@Override
		protected void onProgressUpdate(Void... unsued) {
			

		}

		@Override
		protected void onPostExecute(Boolean result) {
			dismissLoadingDialog();
			if(result != null){
				if(result.booleanValue() && btnAccount.getText().equals(context.getString(R.string.logout))){
					PermpingApplication state = (PermpingApplication)context.getApplicationContext();
					state.setUser(null);
					XMLParser.storePermpingAccount(context, "", "");
					PermpingMain.back();
					PermpingMain.showLogin();
					btnAccount.setText(context.getString(R.string.login));
					btnAccount.invalidate();
				}
				else if(result.booleanValue() && btnAccount.getText().equals(context.getString(R.string.follow))) {
					btnAccount.setText(context.getString(R.string.unfollow));
					btnAccount.invalidate();
					Message message = handler.obtainMessage(UPDATE_BUTTON, "");
					handler.sendMessage(message);
				} else if(result.booleanValue() && btnAccount.getText().equals(context.getString(R.string.unfollow))) {
					btnAccount.setText(context.getString(R.string.follow));
					btnAccount.invalidate();
					Message message = handler.obtainMessage(UPDATE_BUTTON, "");
					handler.sendMessage(message);
				}
			}

		}

	}

    
	class getUserProfile extends AsyncTask<ArrayList<PermBoard>, Void, ArrayList<PermBoard>> {

		private String filePath = "";
		public  String title = "";
		public getUserProfile(String filePath) {
			this.filePath = filePath;
		}

		@Override
		protected ArrayList<PermBoard> doInBackground(
				ArrayList<PermBoard>... arg0) {
			// TODO Auto-generated method stub
			ArrayList<PermBoard> boards = null;
			try {

				boards = (ArrayList<PermBoard>)executeMultipartPost( filePath, false, false);
				return boards;
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return null;
			}
		}


		@Override
		protected void onProgressUpdate(Void... unsued) {

		}

		@Override
		protected void onPostExecute(ArrayList<PermBoard> boards) {
			if(ProfileActivity.userfollowcount <= 0) {
				btnAccount.setText(context.getString(R.string.follow));
				btnAccount.invalidate();
			} else {
				btnAccount.setText(context.getString(R.string.unfollow));
				btnAccount.invalidate();
			}
			if(loadingDialog != null)
			if(loadingDialog.isShowing()){
				dismissLoadingDialog();
				//PermpingMain.showLogin();				
			}

			
			if(boards != null){
				Log.d("tttttt","OOOOOOO=======>>>>>"+boards);
	    		user = PermUtils.isAuthenticated(getApplicationContext());
	            BoardAdapter boardAdapter = new BoardAdapter(ProfileActivity.this,R.layout.board_item, boards);
	    		exeGet(boardAdapter);
			}
		} 
	}

	public Object executeMultipartPost(String filePath, boolean isFollow, boolean isLogout) throws Exception {
		Object boards = null ;
		try {

			PermpingApplication state = (PermpingApplication) getApplicationContext();
			User user = state.getUser();

			if (user != null) {

				HttpClient httpClient = new DefaultHttpClient();
				HttpPost postRequest = null;
				MultipartEntity reqEntity = new MultipartEntity(
						HttpMultipartMode.BROWSER_COMPATIBLE);
				if (filePath != null && !"".equals(filePath)) {
					postRequest = new HttpPost(filePath);
					if(isFollow){
						reqEntity.addPart("fuid", new StringBody(user.getId()));
						reqEntity.addPart("tuid", new StringBody(commentData.getAuthor().getId()));
						postRequest.setEntity(reqEntity);
					}else{
						if(isLogout){
							filePath = filePath+user.getId();
						}else{
							reqEntity.addPart("loggedinuid", new StringBody(user.getId()));
							postRequest.setEntity(reqEntity);
						}

					}
								
					HttpResponse response = httpClient.execute(postRequest);
					HttpEntity entry = response.getEntity();
					String readFile = EntityUtils.toString(entry);
					if(isFollow){
						boards = parseXmlFollowFile(readFile);
					}else if(isLogout){
						boards = parseXmlFollowFile(readFile);
					}else{
						boards = parseXmlFile(readFile);
					}
				} 

				
			}
		} catch (Exception e) {
			return null;
		}
		return boards;
		// Toast.makeText(getApplicationContext(),"Please login first!",Toast.LENGTH_LONG).show();
	}
	boolean parseXmlFollowFile(String xmlFile) {
		Document doc = null;

		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		try {

			DocumentBuilder db = dbf.newDocumentBuilder();

			InputSource is = new InputSource();
			is.setCharacterStream(new StringReader(xmlFile));
			if (is != null)
				doc = db.parse(is);
			doc.getDocumentElement().normalize();

			NodeList nodeList = doc.getElementsByTagName("response");

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
					if (Integer.valueOf(status) == 200)
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

	ArrayList<PermBoard> parseXmlFile(String xmlFile) {
		Document doc = null;
		ArrayList<PermBoard> boards = new ArrayList<PermBoard>();
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		try {

			DocumentBuilder db = dbf.newDocumentBuilder();

			InputSource is = new InputSource();
			is.setCharacterStream(new StringReader(xmlFile));
			if (is != null)
				doc = db.parse(is);
			doc.getDocumentElement().normalize();
			NodeList nodeList2 = doc.getElementsByTagName("userfollowcount");
			if(nodeList2 != null){
				if(nodeList2.item(0) != null){
					if(nodeList2.item(0).getChildNodes() != null){
						if(nodeList2.item(0).getChildNodes().item(0) != null){
							ProfileActivity.userfollowcount =  Integer.valueOf(nodeList2.item(0).getChildNodes().item(0).getNodeValue());
						}
					}
				}
			}
			
			NodeList nodeList3 = doc.getElementsByTagName("followerCount");
			if(nodeList3 != null){
				if(nodeList3.item(0) != null){
					if(nodeList3.item(0).getChildNodes() != null){
						if(nodeList3.item(0).getChildNodes().item(0) != null){
							ProfileActivity.followerCount =  Integer.valueOf(nodeList3.item(0).getChildNodes().item(0).getNodeValue());
						}
					}
				}
			}
			
			NodeList nodeList4 = doc.getElementsByTagName("pinCount");
			if(nodeList4 != null){
				if(nodeList4.item(0) != null){
					if(nodeList4.item(0).getChildNodes() != null){
						if(nodeList4.item(0).getChildNodes().item(0) != null){
							ProfileActivity.pinCount =  Integer.valueOf(nodeList4.item(0).getChildNodes().item(0).getNodeValue());
						}
					}
				}
			}
			
			NodeList nodeList = doc.getElementsByTagName("item");

			/** Assign textview array lenght by arraylist size */
			int length = nodeList.getLength();

			for (int i = 0; i < length; i++) {

				Node node = nodeList.item(i);
				
				Element fstElmnt = (Element) node;
				
				NodeList id = fstElmnt.getElementsByTagName("id");
				Element idElement = (Element) id.item(0);
				id = idElement.getChildNodes();
				String permId = ((Node) id.item(0)).getNodeValue();

				NodeList name = fstElmnt.getElementsByTagName("name");
				Element nameElement = (Element) name.item(0);
				name = nameElement.getChildNodes();
				String permName = ((Node) name.item(0)).getNodeValue();
//
//				NodeList description = fstElmnt.getElementsByTagName("description");
//				Element descriptionElement = (Element) description.item(0);
//				description = descriptionElement.getChildNodes();
//				String permDescriptionn = ((Node) description.item(0)).getNodeValue();
				String permDescriptionn = "";
				
				NodeList followers = fstElmnt.getElementsByTagName("followers");
				Element followersElement = (Element) followers.item(0);
				followers = followersElement.getChildNodes();
				String permFollowers = ((Node) followers.item(0)).getNodeValue();
				
				NodeList pin = fstElmnt.getElementsByTagName("pins");
				Element pinElement = (Element) pin.item(0);
				pin = pinElement.getChildNodes();
				String permPin = ((Node) pin.item(0)).getNodeValue();
				
				PermBoard permBoard = new PermBoard(permId, permName, permDescriptionn, Integer.valueOf(permFollowers), Integer.valueOf(permPin));
				if(permBoard != null)
					boards.add(permBoard);
			}

		} catch (ParserConfigurationException e) {
			System.out.println("XML parse error: " + e.getMessage());
			return null;
		} catch (SAXException e) {
			System.out.println("Wrong XML file structure: "
					+ e.getMessage());
			return null;
		} catch (IOException e) {
			System.out.println("I/O exeption: " + e.getMessage());
			return null;
		}

		return boards;
	}

  
    private class BoardClickListener implements OnItemClickListener {

		public void onItemClick(AdapterView<?> parent, View view, int pos,
				long id) {
			board = (PermBoard) parent.getItemAtPosition(pos);
			//BoardController boardController = new BoardController();
			//List<Perm> perms = boardController.getPermsByBoardId(board.getId(), ProfileActivity.this);			
			
			Intent myIntent = new Intent(view.getContext(), FollowerActivity.class);
			String boardUrl = API.permListFromBoardUrl + board.getId();
			myIntent.putExtra("categoryURL", boardUrl);
			View boardListView = ProfileActivityGroup.group.getLocalActivityManager() .startActivity("BoardListActivity", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
			ProfileActivityGroup.group.replaceView(boardListView);
	
		}

    	
    }
	private void showLoadingDialog(String title, String msg) {
		loadingDialog = new ProgressDialog(getParent());
		loadingDialog.setMessage(msg);
		loadingDialog.setTitle(title);
		loadingDialog.setCancelable(true );
		this.loadingDialog.show();
	}
	private void dismissLoadingDialog() {
		if (loadingDialog != null && loadingDialog.isShowing())
			loadingDialog.dismiss();
	}
	@Override
	public void onSuccess(ArrayList<Perm> perms) {
		// TODO Auto-generated method stub
		
		Transporter transporter = new Transporter();
		transporter.setPerms(perms);
		transporter.setBoardName(board.getName());
		
		// Go to the Board Detail screen
		Intent i = new Intent(context, BoardDetailActivity.class);
		i.putExtra(Constants.TRANSPORTER, transporter);
		View boardDetail = ProfileActivityGroup.group.getLocalActivityManager() .startActivity("BoardDetailActivity", i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
		ProfileActivityGroup.group.replaceView(boardDetail);
	}
	@Override
	public void onError() {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event)
	{		
	    if ((keyCode == KeyEvent.KEYCODE_BACK))
	    {
	        PermpingMain.back();
	        return true;
	    }
	    return super.onKeyDown(keyCode, event);
	}
}
