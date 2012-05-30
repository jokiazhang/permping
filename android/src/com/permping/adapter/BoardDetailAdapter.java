/**
 * 
 */
package com.permping.adapter;

import java.util.List;

import com.permping.R;
import com.permping.model.Perm;
import com.permping.utils.UrlImageViewHelper;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.TextView;

/**
 * @author Linh Nguyen
 *
 */
public class BoardDetailAdapter extends BaseAdapter implements ListAdapter {

	private Activity activity;
	private List<Perm> perms;
	private String boardName;
	
	public BoardDetailAdapter(Activity activity, List<Perm> perms, String boardName) {
		this.activity = activity;
		this.perms = perms;
		this.boardName = boardName;
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
			ImageView permImage = (ImageView) view.findViewById(R.id.permImage);
			UrlImageViewHelper.setUrlDrawable(permImage, perm.getImage().getUrl());
			
			// Perm Description
			TextView txtPermDescription = (TextView) view.findViewById(R.id.permDescription);
			txtPermDescription.setText(perm.getDescription());
			
			// Perm Information
			TextView txtPermInfo = (TextView) view.findViewById(R.id.permInfo);
			//txtPermInfo.
		}
		return null;
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
