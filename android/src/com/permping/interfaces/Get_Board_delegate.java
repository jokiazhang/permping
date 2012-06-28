package com.permping.interfaces;

import java.util.List;

import com.permping.model.Perm;

public interface Get_Board_delegate {
	void onSuccess(List<Perm> perms);
	void onError();
}
