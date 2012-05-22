/**
 * 
 */
package com.permping.handler;

import java.util.ArrayList;
import java.util.List;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.permping.model.PermBoard;
import com.permping.model.PermImage;
import com.permping.model.User;
import com.permping.utils.Constants;

/**
 * @author Linh Nguyen
 *
 */
public class UserHandler extends DefaultHandler {
	
	private User user;
	private List<PermBoard> boards;
	private PermBoard permBoard;
	
	private String currentTag;
	
	@Override
	public void characters(char[] ch, int start, int length)
			throws SAXException {
		String value = new String(ch, start, length).trim();
		
		if (currentTag != null && currentTag.equals(Constants.USER_ID)) {
			user.setId(value);
		} else if (currentTag != null && currentTag.equals(Constants.USER_NAME)) {
			user.setName(value);
		} else if (currentTag != null && currentTag.equals(Constants.USER_AVATAR)) {
			PermImage avatar = new PermImage(value);
			user.setAvatar(avatar);
		} else if (currentTag != null && currentTag.equals(Constants.FOLLOWING_COUNT)) {
			user.setFollowings(Integer.parseInt(value));
		} else if (currentTag != null && currentTag.equals(Constants.FOLLOWER_COUNT)) {
			user.setFriends(Integer.parseInt(value));
		} else if (currentTag != null && currentTag.equals(Constants.PIN_COUNT)) {
			user.setPin(Integer.parseInt(value));
		} else if (currentTag != null && currentTag.equals(Constants.LIKE_COUNT)) {
			user.setLike(Integer.parseInt(value));
		} else if (currentTag != null && currentTag.equals(Constants.BOARD_COUNT)) {
			user.setBoard(Integer.parseInt(value));
		} 
	}

	@Override
	public void endElement(String uri, String localName, String qName)
			throws SAXException {
		if (localName.equals(Constants.ITEM)) {
			boards.add(permBoard);
		} else if (localName.equals(Constants.BOARDS)) {
			user.setBoards(boards);
		}
	}

	@Override
	public void startElement(String uri, String localName, String qName,
			Attributes attributes) throws SAXException {
		currentTag = localName;
		if (localName.equals(Constants.USER)) {
			user = new User();
		} else if (localName.equals(Constants.BOARDS)) {
			boards = new ArrayList<PermBoard>();
		} else if (localName.equals(Constants.ITEM)) {
			permBoard = new PermBoard();
		}
	}
	
	public User getUser() {
		return user;
	}
}
