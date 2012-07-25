package com.permpus.permping.interfaces;

import java.util.ArrayList;

import com.permpus.permping.model.Perm;

public interface Get_Perm_Delegate {
	void onSuccess(ArrayList<Perm> perms);
	void onError();
}
