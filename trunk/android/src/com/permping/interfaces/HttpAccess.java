package com.permping.interfaces;

public interface HttpAccess {
	void onSeccess(String result, String myDiaryThumbId); 
	void onError();
}
