package com.permping.controller;

import java.util.ArrayList;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.permping.model.Category;
import com.permping.model.PermBoard;
import com.permping.utils.API;
import com.permping.utils.XMLParser;

public class BoardController {

	public BoardController() {
		
	}
	
	public ArrayList<PermBoard> getBoardList( String categoryId){
		
		ArrayList<PermBoard> boards = new ArrayList<PermBoard>();
		
		XMLParser parser = new XMLParser( API.boardListFromCategoryUrl + categoryId, true );
		Document doc  = parser.getDoc();
		NodeList boardNodeList = doc.getElementsByTagName("item");
		
		for( int i = 0; i < boardNodeList.getLength(); i ++ ){
			Element boardElement = (Element) boardNodeList.item(i);
			
			String boardId = boardElement.getElementsByTagName("id").item(0).getFirstChild().getNodeValue();
			String boardName = boardElement.getElementsByTagName("title").item(0).getFirstChild().getNodeValue();
			
			PermBoard board = new PermBoard(boardId, boardName);
			boards.add(board);
		}
		
		return boards;
	}
	
	
	public ArrayList<PermBoard> getUserBoads(){
		ArrayList<PermBoard> boards = new ArrayList<PermBoard>();
		
		XMLParser parser = new XMLParser( API.userBoardUrl, true );
		Document doc  = parser.getDoc();
		NodeList boardNodeList = doc.getElementsByTagName("item");
		
		for( int i = 0; i < boardNodeList.getLength(); i ++ ){
			Element boardElement = (Element) boardNodeList.item(i);
			
			String boardId = boardElement.getElementsByTagName("id").item(0).getFirstChild().getNodeValue();
			String boardName = boardElement.getElementsByTagName("title").item(0).getFirstChild().getNodeValue();
			
			PermBoard board = new PermBoard(boardId, boardName);
			boards.add(board);
		}
		
		return boards;
	}
}
