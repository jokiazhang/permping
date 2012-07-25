package com.permpus.interfaces;

import java.util.ArrayList;

import com.permpus.model.Perm;

public interface Get_Perm_Delegate {
	void onSuccess(ArrayList<Perm> perms);
	void onError();
}
