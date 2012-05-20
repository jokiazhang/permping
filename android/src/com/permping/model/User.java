package com.permping.model;

import java.io.Serializable;
import java.util.List;

public class User implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4778518614772031293L;
	private String id;
	private String name;
	private PermImage avatar;
	private int friends;
	private int followings;
	List<PermBoard> boards;

	/**
	 * Default constructor
	 */
	public User() {
		
	}
	
	/**
	 * 
	 * @param id
	 */
	public User( String id){
		this.setId(id);
	}
	
	/**
	 * 
	 * @param id
	 * @param name
	 * @param avatar
	 * @param friends
	 * @param followings
	 * @param boards
	 */
	public User(String id, String name, PermImage avatar, int friends, int followings, List<PermBoard> boards) {
		this.setId(id);
		this.setName(name);
		this.setAvatar(avatar);
		this.setFriends(friends);
		this.setFollowings(followings);
		this.setBoards(boards);
	}


	/**
	 * @return the boards
	 */
	public List<PermBoard> getBoards() {
		return boards;
	}

	/**
	 * @param boards the boards to set
	 */
	public void setBoards(List<PermBoard> boards) {
		this.boards = boards;
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

	/**
	 * @return the friends
	 */
	public int getFriends() {
		return friends;
	}

	/**
	 * @param friends the friends to set
	 */
	public void setFriends(int friends) {
		this.friends = friends;
	}

	/**
	 * @return the followings
	 */
	public int getFollowings() {
		return followings;
	}

	/**
	 * @param followings the followings to set
	 */
	public void setFollowings(int followings) {
		this.followings = followings;
	}
}
