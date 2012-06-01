/**
 * 
 */
package com.permping.adapter;

import java.util.List;

import com.permping.R;
import com.permping.model.Comment;
import com.permping.model.Perm;
import com.permping.utils.PermUtils;
import com.permping.utils.UrlImageViewHelper;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.TextView;
import android.widget.ImageView.ScaleType;

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
	
	public BoardDetailAdapter(Activity activity, List<Perm> perms, String boardName, 
			int screenWidth, int screenHeight) {
		this.activity = activity;
		this.perms = perms;
		this.boardName = boardName;
		this.screenHeight = screenHeight;
		this.screenWidth = screenWidth;
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		final LayoutInflater inflater = activity.getLayoutInflater();
		View view = inflater.inflate(R.layout.profile_perm_layout, null);
		
		Perm perm = perms.get(position);
		if (perm != null) {
			// The Board Name
			TextView txtBoardName = (TextView) view.findViewById(R.id.boardName);
			txtBoardName.setText(boardName);
			
			// The image of perm
			final ImageView permImage = (ImageView) view.findViewById(R.id.permImage);
			UrlImageViewHelper.setUrlDrawable(permImage, perm.getImage().getUrl());
			PermUtils.scale(permImage, screenWidth, screenHeight);
			
			// Perm Description
			TextView txtPermDescription = (TextView) view.findViewById(R.id.permDescription);
			txtPermDescription.setText(perm.getDescription());
			
			// Perm Information
			TextView txtPermInfo = (TextView) view.findViewById(R.id.permInfo);
			txtPermInfo.setText("via " + perm.getAuthor().getName() + " on to " + boardName);
			
			String permStatus = "Like: " + perm.getPermLikeCount() + " - Repin: " + perm.getPermRepinCount() + " - Comment: " + perm.getPermCommentCount();
            TextView txtStatus = (TextView) view.findViewById(R.id.permStatus );
            txtStatus.setText(permStatus);
            
            LinearLayout comments = (LinearLayout) view.findViewById(R.id.comments);
            for(int i = 0; i < perm.getComments().size(); i ++){
                View cm = inflater.inflate(R.layout.comment_item, null );
                Comment comment = perm.getComments().get(i);
                if(comment != null) {
                   if(comment.getAuthor() != null ){
             		   ImageView cma = (ImageView) cm.findViewById(R.id.commentAvatar);
             		   UrlImageViewHelper.setUrlDrawable(cma, comment.getAuthor().getAvatar().getUrl());
             	   }
	                   
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
