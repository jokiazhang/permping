/**
 * 
 */
package com.permping.controller;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import android.content.Context;

import com.permping.PermpingApplication;
import com.permping.model.PermBoard;
import com.permping.model.PermImage;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.HttpPermUtils;
import com.permping.utils.XMLParser;

/**
 * @author Linh Nguyen
 *
 */
public class AuthorizeController {
	
	public AuthorizeController() {
		
	}
	
	public static boolean authorize(Context context, List<NameValuePair> nameValuePairs) {
		// Send to server to check if the account is created
		// If existed => back to Home page (Popular screen)
		// If not existed => go to Create Account screen.
		boolean ret = true;
		XMLParser parser = new XMLParser(API.authorizeURL, nameValuePairs);
		User user = parser.getUser();
		if (user != null) {
			// Store the user object to PermpingApplication
			PermpingApplication state = (PermpingApplication) context.getApplicationContext();
			state.setUser(user);
			ret = true;
		} else {
			ret = false;
		}
		
		
		return ret;
		// 1. Send POST request to server
		
		
		
		
		//XMLParser parser = new XMLParser(API.nonAuthorizeURL);
		/*Document document = parser.getDoc();
		NodeList nodes = document.getElementsByTagName("response");
		Element element = (Element) nodes.item(0);
		if (element != null) {
			String userId = null;
			String userName = null;
			PermImage userAvatar = null;
			int following = -1;
			int friend = -1;
			int pin = -1;
			int like = -1;
			int board = -1;
			List<PermBoard> boards = new ArrayList<PermBoard>();
			User user = null;
			
			NodeList error = element.getElementsByTagName(Constants.ERROR);
			if (error.getLength() == 0) {
				*//**
				 * Login success
				 *//*
				NodeList userInfo = element.getElementsByTagName(Constants.USER);
				if (userInfo != null) {
					Element userElement = (Element) userInfo.item(0);
					if (userElement != null) {
						// Get user Id
						userId = userElement.getElementsByTagName(Constants.USER_ID).item(0).
								getFirstChild().getNodeValue();
						// Get username
						userName = userElement.getElementsByTagName(Constants.USER_NAME).item(0).
								getFirstChild().getNodeValue();
						// Get user avatar
						userAvatar = new PermImage(userElement.getElementsByTagName(Constants.USER_AVATAR).item(0).
								getFirstChild().getNodeValue());
						// Get number of followings
						following = Integer.parseInt(userElement.getElementsByTagName(Constants.FOLLOWING_COUNT).item(0).
								getFirstChild().getNodeValue());
						// Get number of friends
						friend = Integer.parseInt(userElement.getElementsByTagName(Constants.FOLLOWER_COUNT).item(0).
								getFirstChild().getNodeValue());
						// Get number of pins
						pin = Integer.parseInt(userElement.getElementsByTagName(Constants.PIN_COUNT).item(0).
								getFirstChild().getNodeValue());
						// Get number of likes
						like = Integer.parseInt(userElement.getElementsByTagName(Constants.LIKE_COUNT).item(0).
								getFirstChild().getNodeValue());
						// Get number of boards
						board = Integer.parseInt(userElement.getElementsByTagName(Constants.BOARD_COUNT).item(0).
								getFirstChild().getNodeValue());
						// Get list of boards
						NodeList userBoards = userElement.getElementsByTagName(Constants.ITEM);
						if (userBoards != null) {
							PermBoard permBoard;
							for (int i = 0; i < userBoards.getLength(); i++) {
								Element boardElement = (Element) userBoards.item(i);
								if (boardElement != null) {
									permBoard = new PermBoard();
									permBoard.setName(boardElement.getElementsByTagName(Constants.NAME).
											item(0).getFirstChild().getNodeValue());
									permBoard.setId(boardElement.getElementsByTagName(Constants.ID).
											item(0).getFirstChild().getNodeValue());
									permBoard.setDescription(boardElement.getElementsByTagName(Constants.DESCRIPTION).
											item(0).getFirstChild().getNodeValue());
									permBoard.setFollowers(Integer.parseInt(boardElement.getElementsByTagName(Constants.FOLLOWERS).
											item(0).getFirstChild().getNodeValue()));
									permBoard.setPins(Integer.parseInt(boardElement.getElementsByTagName(Constants.PINS).
											item(0).getFirstChild().getNodeValue()));
									boards.add(permBoard);
								}
							}
						}
					}
				}
				// Initialize user object to store in the global app variable.
				user = new User(userId, userName, userAvatar, friend, following, pin, like, board, boards);
				// Store the user object to PermpingApplication
				PermpingApplication state = (PermpingApplication) context.getApplicationContext();
				state.setUser(user);
			} else {
				*//**
				 * Not created Permping account yet
				 *//*
				ret = false;
			}
		}	*/

	}
}