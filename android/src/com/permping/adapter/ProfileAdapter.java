/**
 * 
 */
package com.permping.adapter;

import java.util.ArrayList;

import com.permping.model.PermBoard;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;

/**
 * @author Linh Nguyen
 * The boards of user are shown in the Profile tab as list.
 */
public class ProfileAdapter extends ArrayAdapter<PermBoard> {

	public ProfileAdapter(Context context, int resourceId, ArrayList<PermBoard> boards) {
		super(context, resourceId, boards);
	}
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public PermBoard getItem(int arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		return null;
	}

}
