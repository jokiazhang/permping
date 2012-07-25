
package com.permpus.permping.controller;

import java.util.ArrayList;
import java.util.List;

import com.permpus.permping.interfaces.Get_Board_delegate;
import com.permpus.permping.model.Perm;
import com.permpus.permping.model.PermBoard;
import com.permpus.permping.utils.API;
import com.permpus.permping.utils.XMLParser;

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