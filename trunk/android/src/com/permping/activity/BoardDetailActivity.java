package com.permping.activity;

import java.util.List;

import com.permping.R;
import com.permping.adapter.BoardDetailAdapter;
import com.permping.model.Perm;
import com.permping.model.Transporter;
import com.permping.utils.Constants;

import android.app.Activity;
import android.os.Bundle;
import android.widget.ListView;

public class BoardDetailActivity extends Activity {

	private ListView permList;
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.profile_permlist_layout);
		
		Bundle extras = getIntent().getExtras();
		Transporter transporter = (Transporter) extras.get(Constants.TRANSPORTER);
		List<Perm> perms = transporter.getPerms();
		String boardName = transporter.getBoardName();
		
		permList = (ListView) findViewById(R.id.permList);
		BoardDetailAdapter boardDetailAdapter = new BoardDetailAdapter(this, perms, boardName);
		permList.setAdapter(boardDetailAdapter);
		
	}
}
