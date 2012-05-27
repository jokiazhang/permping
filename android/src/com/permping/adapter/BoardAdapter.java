package com.permping.adapter;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;

import com.permping.PermpingMain;
import com.permping.R;
import com.permping.activity.JoinPermActivity;
import com.permping.activity.LoginPermActivity;
import com.permping.activity.PrepareRequestTokenActivity;
import com.permping.controller.AuthorizeController;
import com.permping.model.Category;
import com.permping.model.Perm;
import com.permping.model.PermBoard;
import com.permping.utils.Constants;
import com.permping.utils.UrlImageViewHelper;
import com.permping.utils.facebook.FacebookConnector;
import com.permping.utils.facebook.SessionEvents;
import com.permping.utils.facebook.SessionEvents.AuthListener;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.drawable.Drawable;
import android.preference.PreferenceManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.view.View.OnClickListener;

public class BoardAdapter extends ArrayAdapter<PermBoard> {

	private ArrayList<PermBoard> items;
	
	private int textViewResourceId ;

	public BoardAdapter(Context context, int textViewResourceId, ArrayList<PermBoard> items) {
		super(context, textViewResourceId, items);
		this.textViewResourceId = textViewResourceId;
		this.items = items;
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		View v = convertView;
		if( v == null ){
			LayoutInflater vi = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			v = vi.inflate(this.textViewResourceId, null);
		}
		
		if( position == 0 ){
			v.findViewById(R.id.categoryItemLayout).setBackgroundResource( R.drawable.explorer_item_bg_first );
			
		} else if( position == ( items.size() - 1 ) ) {
			v.findViewById(R.id.categoryItemLayout).setBackgroundResource( R.drawable.explorer_item_bg_end );
		} else {
			v.findViewById(R.id.categoryItemLayout).setBackgroundResource( R.drawable.explorer_item_bg );
		}
		
		PermBoard o = items.get(position);
		if (o != null) {
			TextView an = (TextView) v.findViewById(R.id.categoryName);
			an.setText(o.getName());
			
			TextView boardStat = (TextView) v.findViewById(R.id.boardStat);
			if( boardStat != null ){
				String str = "Perms " + String.valueOf( o.getPins() ) + " followers " + String.valueOf(o.getFollowers() );
				boardStat.setText( str );
			}
		}
		
		return v;
	}

}