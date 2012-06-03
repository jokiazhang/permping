/**
 * 
 */
package com.permping.adapter;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import com.permping.R;
import com.permping.activity.BoardDetailActivity;
import com.permping.activity.NewPermActivity;
import com.permping.activity.ProfileActivityGroup;
import com.permping.activity.RepermActivity;
import com.permping.model.Comment;
import com.permping.model.Perm;
import com.permping.model.PermBoard;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.HttpPermUtils;
import com.permping.utils.PermUtils;
import com.permping.utils.UrlImageViewHelper;

import android.app.Activity;
import android.content.Intent;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.TextView;
import android.widget.Toast;

/**
 * @author Linh Nguyen
 *
 */
public class BoardDetailAdapter extends BaseAdapter implements ListAdapter {

	private Activity activity;
	private List<Perm> perms;
	private String boardName;
	private int screenWidth;
	private int screenHeight;
	private User user;
	
	public BoardDetailAdapter(Activity activity, List<Perm> perms, String boardName, 
			int screenWidth, int screenHeight, User user) {
		this.activity = activity;
		this.perms = perms;
		this.boardName = boardName;
		this.screenHeight = screenHeight;
		this.screenWidth = screenWidth;
		this.user = user;
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		final LayoutInflater inflater = activity.getLayoutInflater();
		final View view = inflater.inflate(R.layout.profile_perm_layout, null);
		
		final Perm perm = perms.get(position);
		final Button like = (Button) view.findViewById(R.id.btLike);
		final Button rePerm = (Button) view.findViewById(R.id.btReperm);
		
		// Validate Like or Unlike
		if (perm != null) {
			if (perm.getPermUserLikeCount() != null && "0".equals(perm.getPermUserLikeCount())) {
				like.setText(Constants.LIKE);
			} else {
				like.setText(Constants.UNLIKE);
			}
		}
		like.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if (user != null && perm != null) {
					HttpPermUtils httpPermUtils = new HttpPermUtils();
					List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
					nameValuePairs.add(new BasicNameValuePair("pid", String.valueOf(perm.getId())));
					nameValuePairs.add(new BasicNameValuePair("uid", String.valueOf(user.getId()))); 
					httpPermUtils.sendPostRequest(API.likeURL, nameValuePairs);
					if (v instanceof Button) {
						String label = ((Button) v).getText().toString();
						int likeCount = Integer.parseInt(perm.getPermLikeCount());
						if (label != null && label.equals(Constants.LIKE)) { // Like
							// Update the count
							likeCount++;
	    					perm.setPermLikeCount(String.valueOf(likeCount));
	    					// Change the text to "Unlike"
	    					like.setText(Constants.UNLIKE);
						} else { // Unlike
							likeCount = likeCount - 1;
							if (likeCount < 0) 
								likeCount = 0;
							perm.setPermLikeCount(String.valueOf(likeCount));
							like.setText(Constants.LIKE);
						}
					}
					String permStatus = "Like: " + perm.getPermLikeCount() + " - Repin: " + perm.getPermRepinCount() + " - Comment: " + perm.getPermCommentCount();
		            TextView txtStatus = (TextView) view.findViewById(R.id.permStatus);
		            txtStatus.setText(permStatus);
				} else {
					Toast.makeText(v.getContext(), Constants.NOT_LOGIN, Toast.LENGTH_LONG).show();
				}
			}
		});
		
		rePerm.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// Get the id of perm
				if (perm != null) {
					
					Intent myIntent = new Intent(view.getContext(), NewPermActivity.class);
					myIntent.putExtra("permID", (String) perm.getId() );
					View repermView = ProfileActivityGroup.group.getLocalActivityManager() .startActivity("RepermActivity", myIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
					ProfileActivityGroup.group.replaceView( repermView );
					
					
					
					/*
					String permId = perm.getId();
					String permDesc = perm.getDescription();
					PermBoard currentBoard = perm.getBoard();
					
					// Go to the Reperm screen
					Intent i = new Intent(view.getContext(), RepermActivity.class);
					i.putExtra(Constants.PERM_ID, permId);
					i.putExtra(Constants.PERM_DESCRIPTION, permDesc);
					i.putExtra(Constants.CURRENT_BOARD, currentBoard);
					View rePermView = ProfileActivityGroup.group.getLocalActivityManager().startActivity("RepermActivity", i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)).getDecorView();
					ProfileActivityGroup.group.replaceView(rePermView);
					*/
				}
			}
		});
		
		if (perm != null) {
			// The Board Name
			TextView txtBoardName = (TextView) view.findViewById(R.id.boardName);
			if (boardName != null) {
				txtBoardName.setText(boardName);
			} else {
				PermBoard board = perm.getBoard();
				if (board != null) {
					txtBoardName.setText(board.getName());
				} else {
					txtBoardName.setText("N/A");
				}
			}
			
			// The image of perm
			final ImageView permImage = (ImageView) view.findViewById(R.id.permImage);
			UrlImageViewHelper.setUrlDrawable(permImage, perm.getImage().getUrl());
			//PermUtils.scale(permImage, screenWidth, screenHeight);
			
			// Perm Description
			TextView txtPermDescription = (TextView) view.findViewById(R.id.permDescription);
			txtPermDescription.setText(perm.getDescription());
			
			// Perm Information
			TextView txtPermInfo = (TextView) view.findViewById(R.id.permInfo);
			txtPermInfo.setText("via " + perm.getAuthor().getName() + " on to " + boardName);
			
			// Status
			String permStatus = "Like: " + perm.getPermLikeCount() + " - Repin: " + perm.getPermRepinCount() + " - Comment: " + perm.getPermCommentCount();
            TextView txtStatus = (TextView) view.findViewById(R.id.permStatus );
            txtStatus.setText(permStatus);
            
            LinearLayout comments = (LinearLayout) view.findViewById(R.id.comments);
            for(int i = 0; i < perm.getComments().size(); i ++){
                View cm = inflater.inflate(R.layout.comment_item, null );
                Comment comment = perm.getComments().get(i);
                if(comment != null && comment.getAuthor() != null) {
                   
             		   ImageView cma = (ImageView) cm.findViewById(R.id.commentAvatar);
             		   UrlImageViewHelper.setUrlDrawable(cma, comment.getAuthor().getAvatar().getUrl());
             	   
	                   
	               TextView cmt = (TextView) cm.findViewById(R.id.commentContent);
	               cmt.setText(comment.getContent());
	                   
	               if( i == (perm.getComments().size() -1)){
	            	   View sp = (View) cm.findViewById(R.id.separator);
	            	   sp.setVisibility(View.INVISIBLE);
	               }
	               comments.addView(cm);
                }
            }

    		
		}
		return view;
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return perms.size();
	}
	
	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return perms.get(position);
	}
	
	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}
	
	
}
