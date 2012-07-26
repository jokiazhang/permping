package com.permpings.interfaces;

import com.permpings.model.User;

public interface JoinPerm_Delegate {
	void onSuccess(User user);
	void onError();
}
