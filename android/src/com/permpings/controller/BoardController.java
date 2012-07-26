
package com.permpings.controller;

import java.util.ArrayList;
import java.util.List;

import com.permpings.interfaces.Get_Board_delegate;
import com.permpings.model.Perm;
import com.permpings.model.PermBoard;
import com.permpings.utils.API;
import com.permpings.utils.XMLParser;

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