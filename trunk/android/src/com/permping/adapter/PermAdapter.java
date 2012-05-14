package com.permping.adapter;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;

import com.permping.R;
import com.permping.model.Perm;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import com.koushikdutta.urlimageviewhelper.*;

public class PermAdapter extends ArrayAdapter<Perm> {

    private ArrayList<Perm> items;

    public PermAdapter(Context context, int textViewResourceId, ArrayList<Perm> items) {
            super(context, textViewResourceId, items);
            this.items = items;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
            View v = convertView;
            if (v == null) {
                LayoutInflater vi = (LayoutInflater)this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                v = vi.inflate(R.layout.perm_item_1, null);
            }
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
            return v;
    }

}