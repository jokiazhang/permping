package com.permping.interfaces;

import org.w3c.dom.Document;

import com.permping.model.User;

public interface JoinPerm_Delegate {
	void onSuccess(User user);
	void onError();
}
