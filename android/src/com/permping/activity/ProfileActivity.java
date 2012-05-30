
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
import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class ProfileActivity extends Activity {
	
	ImageView authorAvatar;
	TextView authorName;
	TextView friends;
	TextView followings;
	Button account;
	
	private int selectedBoardId = -1;
	
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.profile_layout);
        
        authorAvatar = (ImageView) findViewById(R.id.authorAvatar);
        authorName = (TextView) findViewById(R.id.authorName);
        friends = (TextView) findViewById(R.id.friends);
        followings = (TextView) findViewById(R.id.followings);
        account = (Button) findViewById(R.id.btAccount);
        
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
            friends.setText(String.valueOf(user.getFriends()) + " followers ");
            
            // The number of followings
            followings.setText(String.valueOf(user.getFollowings() + " followings"));
            
            // Build the list of user's boards
            ListView userBoards = (ListView) findViewById(R.id.userBoards);
            ArrayList<PermBoard> boards = (ArrayList<PermBoard>) user.getBoards();
            BoardAdapter boardAdapter = new BoardAdapter(this,R.layout.board_item, boards);
            userBoards.setAdapter(boardAdapter);
            userBoards.setOnItemClickListener(new BoardClickListener());
            
            // Account button process
            account.setOnClickListener(new View.OnClickListener() {
				
				@Override
				public void onClick(View v) {
					// Go to the Create Board screen.
					Intent i = new Intent(v.getContext(), AccountActivity.class);
					View view = ProfileActivityGroup.group.getLocalActivityManager().startActivity("AccountActivity", i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
					ProfileActivityGroup.group.replaceView(view);
				}
			});
            
        } else {
        	Intent i = new Intent(getApplicationContext(), LoginPermActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			getApplicationContext().startActivity(i);
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
