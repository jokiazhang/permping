package com.permpus.permping.interfaces;

import com.permpus.permping.model.User;

public interface JoinPerm_Delegate {
	void onSuccess(User user);
	void onError();
}
