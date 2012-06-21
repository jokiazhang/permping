package com.permping.interfaces;

import java.util.List;

import org.w3c.dom.Document;

public interface MyDiary_Delegate {
	void onSuccess( List<String> thumbList, String id);
	void onError();
}
