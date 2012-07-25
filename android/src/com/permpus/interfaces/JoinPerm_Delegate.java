package com.permpus.interfaces;

import com.permpus.model.User;

public interface JoinPerm_Delegate {
	void onSuccess(User user);
	void onError();
}
