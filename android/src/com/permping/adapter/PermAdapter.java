package com.permping.adapter;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;

import com.permping.R;
import com.permping.model.Perm;


import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import com.koushikdutta.urlimageviewhelper.*;
import android.view.View.OnClickListener;



public class PermAdapter extends ArrayAdapter<Perm> {

    private ArrayList<Perm> items;
    
    public Button join;
    public Button login;
    private Activity a ;

    public PermAdapter(Context context, int textViewResourceId, ArrayList<Perm> items, Activity a ) {
            super(context, textViewResourceId, items);
            this.a = a;
            this.items = items;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
            View v = convertView;
            if( position == 0 )
            {
            	LayoutInflater vi = (LayoutInflater)this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                v = vi.inflate(R.layout.perm_item_2, null);
                
                //Process buttons
                join = (Button) v.findViewById(R.id.bt_join);
                login = (Button) v.findViewById(R.id.bt_login);
                
            }
            else 
            {
	            LayoutInflater vi = (LayoutInflater)this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	            v = vi.inflate(R.layout.perm_item_1, null);
	            
	            Perm o = items.get(position);
	            if (o != null) {
	            		ImageView av = (ImageView) v.findViewById(R.id.authorAvatar);
	            		UrlImageViewHelper.setUrlDrawable(av, o.getAuthor().getAvatar().getUrl() );
	            		
	            		
	            		TextView an = (TextView) v.findViewById(R.id.authorName);
	            		an.setText("name" + o.getAuthor().getName() );
	            		
	            		//Board name
	            		TextView bn = (TextView) v.findViewById(R.id.boardName );
	            		bn.setText(o.getBoard().getName() );
	            		
	            		
	                    ImageView pv = (ImageView) v.findViewById( R.id.permImage);
	                    UrlImageViewHelper.setUrlDrawable(pv, o.getImage().getUrl());
	                    
	            }
            }
            return v;
    }
    
}