/**
 * 
 */
package com.permping.handler;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.permping.model.Perm;
import com.permping.model.Comment;
import com.permping.model.PermImage;
import com.permping.model.User;
import com.permping.utils.Constants;

/**
 * @author Linh Nguyen
 *
 */
public class BoardHandler extends DefaultHandler {

	private final Stack<String> tagsStack = new Stack<String>();
	private StringBuffer buffer = new StringBuffer();
	
	private List<Perm> perms;
	
	private Perm perm;
	
	private User user;
	
	private List<Comment> comments;
	
	private Comment comment;
	
	private User commentAuthor;
	
	@Override
	public void characters(char[] ch, int start, int length)
			throws SAXException {
		buffer.append(ch, start, length); 
	}
	
	@Override
	public void endElement(String uri, String localName, String qName)
			throws SAXException {
		String tag = peekTag();
		if (!localName.equals(tag)) {
			throw new InternalError();
		}
		
		popTag();
		String parentTag = peekTag();
		
		if (localName != null && localName.equals(Constants.ITEM)) {
			perms.add(perm);
		} else if (localName != null && localName.equals(Constants.PERM_ID)) {
			perm.setId(buffer.toString());
		} else if (localName != null && localName.equals(Constants.PERM_DESCRIPTION)) {
			perm.setDescription(buffer.toString());
		} else if (localName != null && localName.equals(Constants.PERM_CATEGORY)) {
			perm.setCategory(buffer.toString());
		} else if (localName != null && localName.equals(Constants.PERM_COMMENTS)) {
			perm.setComments(comments);
		} else if (localName != null && localName.equals(Constants.COMMENT)) {
			comments.add(comment);
		} else if (localName != null && localName.equals(Constants.ID)) {
			comment.setId(buffer.toString());
		} else if (localName != null && localName.equals(Constants.USER)) {
			if (parentTag.equals(Constants.COMMENT)) {
				comment.setAuthor(commentAuthor);
			} else if (parentTag.equals(Constants.ITEM)) {
				perm.setAuthor(user);
			}
		} else if (localName != null && localName.equals(Constants.USER_ID)) {
			if (parentTag.equals(Constants.COMMENT)) {
				commentAuthor.setId(buffer.toString());
			} else if (parentTag.equals(Constants.ITEM)) {
				user.setId(buffer.toString());
			}
		} else if (localName != null && localName.equals(Constants.USER_NAME)) {
			if (parentTag.equals(Constants.COMMENT)) {
				commentAuthor.setName(buffer.toString());
			} else if (parentTag.equals(Constants.ITEM)) {
				user.setName(buffer.toString());
			}			
		} else if (localName != null && localName.equals(Constants.STATUS)) {
			if (parentTag.equals(Constants.COMMENT)) {
				commentAuthor.setStatus(buffer.toString());
			} else if (parentTag.equals(Constants.ITEM)) {
				user.setStatus(buffer.toString());
			}
		} else if (localName != null && localName.equals(Constants.USER_AVATAR)) {
			PermImage avatar = new PermImage(buffer.toString());
			if (parentTag.equals(Constants.COMMENT)) {
				commentAuthor.setAvatar(avatar);
			} else if (parentTag.equals(Constants.ITEM)) {
				user.setAvatar(avatar);
			}
		} else if (localName != null && localName.equals(Constants.CONTENT)) {
			comment.setContent(buffer.toString());
		} else if (localName != null && localName.equals(Constants.IS_MORE)) {
			comment.setIsMore(buffer.toString());
		} else if (localName != null && localName.equals(Constants.PERM_REPINCOUNT)) {
			perm.setPermRepinCount(buffer.toString());
		} else if (localName != null && localName.equals(Constants.PERM_LIKECOUNT)) {
			perm.setPermLikeCount(buffer.toString());
		} else if (localName != null && localName.equals(Constants.PERM_COMMENTCOUNT)) {
			perm.setPermCommentCount(buffer.toString());
		} else if (localName != null && localName.equals(Constants.NEXT_ITEM)) {
			perm.setNextItem(buffer.toString());
		}
	}

	@Override
	public void startElement(String uri, String localName, String qName,
			Attributes attributes) throws SAXException {
		pushTag(localName);
		buffer.setLength(0);
		
		if (localName != null && localName.equals(Constants.PERMS)) {
			perms = new ArrayList<Perm>();
		} else if (localName != null && localName.equals(Constants.ITEM)) {
			perm = new Perm();
		} else if (localName != null && localName.equals(Constants.USER)) {
			user = new User();
		} else if (localName != null && localName.equals(Constants.PERM_COMMENTS)) {
			comments = new ArrayList<Comment>();
		} else if (localName != null && localName.equals(Constants.COMMENT)) {
			comment = new Comment();			
		} else if (localName != null && localName.equals(Constants.USER)) {
			commentAuthor = new User();
		}
	}
	
	public List<Perm> getPerms() {
		return perms;
	}

	@Override
	public void startDocument() throws SAXException {
		pushTag("");
	}
	
	private void pushTag(String tag) {
		tagsStack.push(tag);
	}
	
	private String popTag() {
        return tagsStack.pop();
    }

    private String peekTag() {
        return tagsStack.peek();
    }
}