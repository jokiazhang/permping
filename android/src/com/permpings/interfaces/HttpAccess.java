package com.permpings.interfaces;

public interface HttpAccess {
	void onSeccess(String result, String myDiaryThumbId); 
	void onError();
}
