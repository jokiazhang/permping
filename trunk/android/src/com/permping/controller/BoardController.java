
package com.permping.controller;

import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.permping.interfaces.Get_Board_delegate;
import com.permping.model.Perm;
import com.permping.model.PermBoard;
import com.permping.utils.API;
import com.permping.utils.XMLParser;

public class BoardController {

	public BoardController() {
		
	}
	
	public ArrayList<PermBoard> getBoardList( String userId){
		
		ArrayList<PermBoard> boards = new ArrayList<PermBoard>();
		
		XMLParser parser = new XMLParser( API.getProfileURL + userId, true );	
		return boards;
	}
	
		
	/**
	 * Return the list of perms of selected board.
	 * @param boardId the board id.
	 * @return the list of perms.
	 */
	public List<Perm> getPermsByBoardId(String boardId, Get_Board_delegate delegate) {
		if (boardId == null || "".equals(boardId))
			return null;
		XMLParser parser = new XMLParser(API.permListFromBoardUrl + boardId, delegate, XMLParser.GET_BOARD);
		return parser.getPerms();
	}
}