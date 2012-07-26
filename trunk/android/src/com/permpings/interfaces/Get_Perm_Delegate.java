package com.permpings.interfaces;

import java.util.ArrayList;

import com.permpings.model.Perm;

public interface Get_Perm_Delegate {
	void onSuccess(ArrayList<Perm> perms);
	void onError();
}
