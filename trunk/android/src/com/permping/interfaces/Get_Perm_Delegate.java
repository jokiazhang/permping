package com.permping.interfaces;

import java.util.List;

import com.permping.model.Perm;

public interface Get_Perm_Delegate {
	void onSuccess(List<Perm> perms);
	void onError();
}
