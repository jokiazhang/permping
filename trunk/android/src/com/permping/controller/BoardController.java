
package com.permping.controller;

import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.permping.model.Perm;
import com.permping.model.PermBoard;
import com.permping.utils.API;
import com.permping.utils.XMLParser;

public class BoardController {

	public BoardController() {
		
	}
	
	public ArrayList<PermBoard> getBoardList( String userId){
		
		ArrayList<PermBoard> boards = new ArrayList<PermBoard>();
		
		XMLParser parser = new XMLParser( API.userBoardUrl + userId, true );
		Document doc  = parser.getDoc();
		NodeList boardNodeList = doc.getElementsByTagName("item");
		
		for( int i = 0; i < boardNodeList.getLength(); i ++ ){
			Element boardElement = (Element) boardNodeList.item(i);
			
			String boardId = getValue(boardElement, "id");
			String boardName = getValue(boardElement, "name");
			
			PermBoard board = new PermBoard(boardId, boardName);
			boards.add(board);
		}
		
		return boards;
	}
	
	
	public String getValue( Element e, String tag ){
		if( e != null )
		{
			Node node = e.getElementsByTagName(tag).item(0).getFirstChild();
			if( node != null ){
				return node.getNodeValue();
			}
		}
		return "";
	}
	
	
	
	/**
	 * Return the list of perms of selected board.
	 * @param boardId the board id.
	 * @return the list of perms.
	 */
	public List<Perm> getPermsByBoardId(String boardId) {
		if (boardId == null || "".equals(boardId))
			return null;
		XMLParser parser = new XMLParser(API.permListFromBoardUrl + boardId);
		return parser.getPerms();
	}
}