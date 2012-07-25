package com.permpus.permping.interfaces;

import java.util.ArrayList;

import com.permpus.permping.model.Category;

public interface get_category_delegate {
	public void onCompletedGetCategory( ArrayList<Category> categories);
}
