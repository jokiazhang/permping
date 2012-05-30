/**
 * 
 */
package com.permping.model;

import java.io.Serializable;
import java.util.List;

/**
 * @author Linh Nguyen
 * This class is only for passing the contents between intents in Android.
 */
public class Transporter implements Serializable {
	/**
	 * Default serial version UID
	 */
	private static final long serialVersionUID = 1L;
	
	private String boardName;
	
	private List<Perm> perms;
	
	/**
	 * Default constructor
	 */
	public Transporter() {
		
	}
	
	
	/**
	 * @return the boardName
	 */
	public String getBoardName() {
		return boardName;
	}


	/**
	 * @param boardName the boardName to set
	 */
	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}


	/**
	 * Constructor which initializes the list of perms
	 * @param perms the list of perms
	 */
	public Transporter(List<Perm> perms) {
		this.perms = perms;
	}

	public List<Perm> getPerms() {
		return perms;
	}

	public void setPerms(List<Perm> perms) {
		this.perms = perms;
	}
}
