
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
import com.permping.utils.UrlImageViewHelper;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class ProfileActivity extends Activity {
	
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.profile_layout);
        /*
        ImageView authorAvatar = (ImageView) findViewById(R.id.authorAvatar);
        TextView authorName = (TextView) findViewById(R.id.authorName);
        TextView friends = (TextView) findViewById(R.id.friends);
        TextView followings = (TextView) findViewById(R.id.followings);
        
        /** Load the information from Appliaction (user info) when the page is loaded. */
        /*
        PermpingApplication state = (PermpingApplication) getApplicationContext();
        User user = state.getUser();
        if (user != null) {
        	String name = user.getName();
            PermImage avatar = user.getAvatar();
            //String permNo = String.valueOf(user.getPin());
            String fr = String.valueOf(user.getFriends());
            List<PermBoard> boards = user.getBoards();
            
            // Get the component Ids to fill the data 
            // The author avatar on the top left.
            UrlImageViewHelper.setUrlDrawable(authorAvatar, avatar.getUrl());
            //UrlImageViewHelper.setUrlDrawable(authorAvatar, "http://4.bp.blogspot.com/_n3ecP8ZNh28/TEYB2wyIJDI/AAAAAAAAACw/Fry7Qdpvbzo/s1600/390261_f520.jpg");
            
            // The author name
            authorName.setText(name);
            
            // The info below the author name
            friends.setText(fr + " friends");
            followings.setText(String.valueOf(user.getFollowings() + " followings"));
        } else {
        	// User is not authorized yet -> forward to login screen
        	Toast toast = Toast.makeText(getApplicationContext(), "User is not authorized! Please do it.", Toast.LENGTH_SHORT);
        	toast.setGravity(Gravity.TOP | Gravity.CENTER, 0, 50);
        	toast.show();
        }
        */
        
        /** Build the list of boards using ListAdapter */
        ListView userBoards = (ListView) findViewById(R.id.userBoards);
        BoardController boardController = new BoardController();
		final ArrayList<PermBoard> boards = boardController.getUserBoads();
        BoardAdapter boardAdapter = new BoardAdapter(this,R.layout.board_item, boards  );
        userBoards.setAdapter(boardAdapter);
        
        
    }
}
