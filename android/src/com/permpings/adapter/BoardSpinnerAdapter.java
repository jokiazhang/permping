/**
 * 
 */
package com.permpings.adapter;

import java.util.List;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.SpinnerAdapter;
import android.widget.TextView;

import com.permpings.R;
import com.permpings.model.PermBoard;

/**
 * @author Linh Nguyen
 *
 */
public class BoardSpinnerAdapter extends BaseAdapter implements
		SpinnerAdapter {
	
	private final List<PermBoard> boards;
	private Activity activity;
	
	public BoardSpinnerAdapter(Activity activity, List<PermBoard> boards) {
		this.boards = boards;
		this.activity = activity;
	}

	/**
	 * Returns the total of categories binding in the Spinner
	 */
	public int getCount() {
		return boards.size();
	}

	/**
	 * Returns the Category object at current position
	 */
	public Object getItem(int position) {
		return boards.get(position);
	}

	/**
	 * Returns the row id of current position
	 */
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	/**
	 * Returns a View which represents this position.
	 */
	public View getView(int position, View convertView, ViewGroup parent) {
		final LayoutInflater inflater = activity.getLayoutInflater();
		View view = inflater.inflate(R.layout.category_spinner_entry, null);
		
		PermBoard board = boards.get(position);
		if (board != null) {
			final TextView categoryName = (TextView) view.findViewById(R.id.spinner_category_name);
			categoryName.setText(board.getName());
		}
		
		return view;
	}
}
