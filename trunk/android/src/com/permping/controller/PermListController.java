package com.permping.controller;

import com.permping.model.*;
import com.permping.utils.API;
import com.permping.utils.Constants;
import com.permping.utils.XMLParser;

import java.util.ArrayList;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class PermListController {

	/**
	 * Constructor
	 */
	public PermListController(){
		
	}
	
	/**
	 * @TODO simulate perm lists
	 */
	public ArrayList<Perm> getPermList( String url ){

		
		ArrayList<Perm> permList = new ArrayList<Perm>();
		
		if( url == "" ){
			url = API.popularPermsURL;
			permList.add(new Perm());
		}
		XMLParser parser = new XMLParser( url , true );
		Document doc = parser.getDoc();
		NodeList permNodeList =  doc.getElementsByTagName("item");
		
		for( int i = 0; i< permNodeList.getLength(); i++ ){
			
			//Create perm
			Element permElement = (Element ) permNodeList.item(i);
			String permId = getValue(permElement, "permId");
			String permDesc = getValue(permElement, "permDesc");
			String permBoard = getValue(permElement, "permCategory");
			String permImage = getValue(permElement, "permImage");
			
			//User 
			Element permUser = (Element) permElement.getElementsByTagName("user").item(0);
			String userId  = getValue(permUser, "userId");
			String userName  = getValue(permUser, "userName");
			String userAvatar  = getValue(permUser, "userAvatar");
			
			//user avatar
			PermImage userAvatarImage = new PermImage(userAvatar);
			//user object
			User permAuthor = new User(userId);
			permAuthor.setName(userName);
			permAuthor.setAvatar(userAvatarImage);
			
			
			//Comment
			NodeList permComments = permElement.getElementsByTagName("comment");
			
			ArrayList<Comment> comments = new ArrayList<Comment>();
			for( int j = 0; j < permComments.getLength(); j ++ ){
				Element comment = (Element) permComments.item(i);
				String commentId = getValue(comment, "id");
				String commentContent = getValue(comment, "content");
				
				Comment permComment = new Comment( commentId, commentContent );
				
				//Comment user
				if( comment != null ){
					Element commentUser = (Element) comment.getElementsByTagName("l_user").item(0);
					String commentUserId = getValue(commentUser, "l_userId");
					String commentUserName = getValue(commentUser, "l_userName");
					String commentUserAvatar = getValue(commentUser, "l_userAvatar");
					//commentUserAvatar = "http://www.lahiguera.net/cinemania/actores/jackie_chan/fotos/5635/jackie_chan.jpg";
					
					PermImage commentAvatar = new PermImage( commentUserAvatar );
					User commentAuthor = new User(commentUserId );
					commentAuthor.setName(commentUserName);
					commentAuthor.setAvatar( commentAvatar );
					
					permComment.setAuthor( commentAuthor );
				}
				
				comments.add(permComment);
				
			}
			
			
			//Perm Stat
			String permRepinCount  = getValue(permElement, "permRepinCount");
			String permLikeCount  = getValue(permElement, "permLikeCount");
			String permCommentCount  = getValue(permElement, "permCommentCount");
			String permUserLikeCount = getValue(permElement, Constants.PERM_USERLIKECOUNT);
			
			Perm perm = new Perm(permId, new PermBoard("BoardID", permBoard), permDesc, new PermImage(permImage), comments);
			perm.setAuthor(permAuthor);
			perm.setPermRepinCount(permRepinCount);
			perm.setPermLikeCount(permLikeCount);
			perm.setPermCommentCount(permCommentCount);
			perm.setPermUserLikeCount(permUserLikeCount);
			
			permList.add(perm);
			
			
			
		}
		
		//ArrayList <Perm> permList = parser.permListFromNodeList("popularPerms");
		return permList;
		
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
}
