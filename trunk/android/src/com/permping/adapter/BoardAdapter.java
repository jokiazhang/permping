package com.permping.adapter;

import java.sql.Array;
import java.util.ArrayList;
import com.permping.R;
import com.permping.model.PermBoard;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.TextView;

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
				String str = "Perms " + String.valueOf(o.getPins()) + " followers " + String.valueOf(o.getFollowers());
				boardStat.setText(str);
			}
		}
		
		return v;
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return items.size();
	}

	@Override
	public PermBoard getItem(int position) {
		// TODO Auto-generated method stub
		return items.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

}