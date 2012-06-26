package com.permping.interfaces;

import java.util.ArrayList;

import com.permping.model.Category;

public interface get_category_delegate {
	public void onCompletedGetCategory( ArrayList<Category> categories);
}
