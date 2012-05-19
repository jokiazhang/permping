package com.permping.model;

import java.io.Serializable;

public class User implements Serializable {

	private String id;
	private String name;
	private PermImage avatar;
	private int friendCounts;
	private int followingCounts;
	
	/**
	 * @return the friendCounts
	 */
	public int getFriendCounts() {
		return friendCounts;
	}


	/**
	 * @param friendCounts the friendCounts to set
	 */
	public void setFriendCounts(int friendCounts) {
		this.friendCounts = friendCounts;
	}


	/**
	 * @return the followingCounts
	 */
	public int getFollowingCounts() {
		return followingCounts;
	}


	/**
	 * @param followingCounts the followingCounts to set
	 */
	public void setFollowingCounts(int followingCounts) {
		this.followingCounts = followingCounts;
	}


	/**
	 *Constructor 
	 */
	public User( String id){
		this.setId(id);
	}
	
	
	public User( String id, String name ){
		this.setId(id);
		this.setName(name);
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getId() {
		return id;
	}


	public void setId(String id) {
		this.id = id;
	}


	public PermImage getAvatar() {
		return avatar;
	}


	public void setAvatar(PermImage avatar) {
		this.avatar = avatar;
	}
}
