package com.permping.interfaces;

import org.w3c.dom.Document;

public interface Create_Board_delegate {
	public void onSucess( Document doc);
	public void onError();
}
