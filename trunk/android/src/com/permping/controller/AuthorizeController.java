/**
 * 
 */
package com.permping.controller;

import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import android.content.Context;

import com.permping.PermpingApplication;
import com.permping.model.PermBoard;
import com.permping.model.PermImage;
import com.permping.model.User;
import com.permping.utils.API;
import com.permping.utils.XMLParser;

/**
 * @author Linh Nguyen
 *
 */
public class AuthorizeController {
	
	public AuthorizeController() {
		
	}
	
	public static boolean authorize(Context context) {
		// Send to server to check if the account is created
		// If existed => back to Home page (Popular screen)
		// If not existed => go to Create Account screen.
		boolean ret = true;
		XMLParser parser = new XMLParser(API.authorizeURL);
		Document document = parser.getDoc();
		NodeList nodes = document.getElementsByTagName("response");
		Element element = (Element) nodes.item(0);
		if (element != null) {
			String userId = null;
			String userName = null;
			PermImage userAvatar = null;
			int followings = -1;
			int friends = -1;
			List<PermBoard> boards = new ArrayList<PermBoard>();
			User user = null;
			
			String nodeName = element.getNodeName();
			if (nodeName != null && !nodeName.equals("error")) {
				/**
				 * Login success
				 */
				NodeList userInfo = element.getElementsByTagName("user");
				if (userInfo != null) {
					Element userElement = (Element) userInfo.item(0);
					if (userElement != null) {
						// Get user Id
						userId = userElement.getElementsByTagName("userId").item(0).
								getFirstChild().getNodeValue();
						// Get username
						userName = userElement.getElementsByTagName("userName").item(0).
								getFirstChild().getNodeValue();
						// Get user avatar
						userAvatar = new PermImage(userElement.getElementsByTagName("userAvatar").item(0).
								getFirstChild().getNodeValue());
						// Get number of followings
						followings = Integer.parseInt(userElement.getElementsByTagName("followings").item(0).
								getFirstChild().getNodeValue());
						// Get number of friends
						friends = Integer.parseInt(userElement.getElementsByTagName("friends").item(0).
								getFirstChild().getNodeValue());
						// Get list of boards
						NodeList userBoards = userElement.getElementsByTagName("boards");
						if (userBoards != null) {
							PermBoard permBoard;
							for (int i = 0; i < userBoards.getLength(); i++) {
								Element boardElement = (Element) userBoards.item(i);
								if (boardElement != null) {
									permBoard = new PermBoard();
									permBoard.setName(boardElement.getElementsByTagName("name").
											item(0).getFirstChild().getNodeValue());
									permBoard.setId(boardElement.getElementsByTagName("id").
											item(0).getFirstChild().getNodeValue());
									permBoard.setDescription(boardElement.getElementsByTagName("description").
											item(0).getFirstChild().getNodeValue());
									permBoard.setFollowers(Integer.parseInt(boardElement.getElementsByTagName("followers").
											item(0).getFirstChild().getNodeValue()));
									permBoard.setPins(Integer.parseInt(boardElement.getElementsByTagName("pins").
											item(0).getFirstChild().getNodeValue()));
									boards.add(permBoard);
								}
							}
						}
					}
				}
				user = new User(userId, userName, userAvatar, friends, followings, boards);
			} else {
				/**
				 * Login fail
				 */
				ret = false;
			}
			
			// Store the user object to PermpingApplication
			PermpingApplication state = (PermpingApplication) context;
			state.setUser(user);
		}	
		return ret;
	}
}