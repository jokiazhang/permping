
package com.permping.activity;
import java.util.ArrayList;
import java.util.List;

import com.permping.PermpingApplication;
import com.permping.R;
import com.permping.adapter.BoardAdapter;
import com.permping.controller.BoardController;
import com.permping.model.PermBoard;
import com.permping.model.PermImage;
import com.permping.model.User;
import com.permping.utils.PermUtils;
import com.permping.utils.UrlImageViewHelper;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class ProfileActivity extends Activity {
	
	ImageView authorAvatar;
	TextView authorName;
	TextView friends;
	TextView followings;
	
	private int selectedBoardId = -1;
	
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.profile_layout);
        
        authorAvatar = (ImageView) findViewById(R.id.authorAvatar);
        authorName = (TextView) findViewById(R.id.authorName);
        friends = (TextView) findViewById(R.id.friends);
        followings = (TextView) findViewById(R.id.followings);
        
        /** Load the information from Appliaction (user info) when the page is loaded. */
        User user = PermUtils.isAuthenticated(getApplicationContext());
        if (user != null) {
        	// The author name
        	String name = user.getName();
            authorName.setText(name);
            
            // The author avatar
        	PermImage avatar = user.getAvatar();
            UrlImageViewHelper.setUrlDrawable(authorAvatar, avatar.getUrl());
            
            // The number of friends
            friends.setText(String.valueOf(user.getFriends()) + " friends ");
            
            // The number of followings
            followings.setText(String.valueOf(user.getFollowings() + " followings"));
            
            // Build the list of user's boards
            ListView userBoards = (ListView) findViewById(R.id.userBoards);
            ArrayList<PermBoard> boards = (ArrayList<PermBoard>) user.getBoards();
            BoardAdapter boardAdapter = new BoardAdapter(this,R.layout.board_item, boards);
            userBoards.setAdapter(boardAdapter);
            userBoards.setOnItemClickListener(new BoardClickListener());
            
        } else {
        	// User is not authorized yet -> forward to login screen
        	Toast toast = Toast.makeText(getApplicationContext(), "User is not authorized! Please do it.", Toast.LENGTH_SHORT);
        	toast.setGravity(Gravity.TOP | Gravity.CENTER, 0, 50);
        	toast.show();
        }        
    }
    
    private class BoardClickListener implements OnItemClickListener {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int pos,
				long id) {
			PermBoard board = (PermBoard) parent.getItemAtPosition(pos);
			selectedBoardId = Integer.parseInt(board.getId());
			BoardController boardController = new BoardController();
			ArrayList<PermBoard> perms = boardController.getPermByBoardId(board.getId());
			System.out.println(perms.size());
		}

		/*@Override
		public void onNothingClick(AdapterView<?> arg0) {
			// TODO Auto-generated method stub
			
		}*/
    	
    }
}
