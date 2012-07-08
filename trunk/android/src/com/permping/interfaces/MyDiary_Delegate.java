package com.permping.interfaces;

import java.util.HashMap;
import java.util.List;

public interface MyDiary_Delegate {
	void onSuccess( List<String[]> thumbList, String id);
	void onError();
}
