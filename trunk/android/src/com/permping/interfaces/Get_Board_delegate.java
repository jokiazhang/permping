package com.permping.interfaces;

import java.util.ArrayList;
import java.util.List;

import com.permping.model.Perm;

public interface Get_Board_delegate {
	void onSuccess(ArrayList<Perm> perms);
	void onError();
}
