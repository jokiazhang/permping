/**
 * 
 */
package com.permping.model;

import java.io.Serializable;
import java.util.ArrayList;
public class Perm implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	private String id;
	private String name;
	private String description;
	private PermImage image;
	private ArrayList<PermComment> comments;
	private User author;
	private PermBoard board;
	
	
	/**
	 * Constructor
	 */
	
	public Perm(){
		
	}
	
	
	public Perm( String id){
		this.setId(id);
	}
	
	public Perm( String id, String name, String description, PermImage image ){
		this.setId(id);
		this.setName(name);
		this.setDescription(description);
		this.setImage(image);
	}
	
	
	public Perm( String id, PermBoard board, String description, PermImage image , ArrayList<PermComment> comments){
		this.setId(id);
		this.setBoard(board);
		this.setDescription(description);
		this.setImage(image);
		this.setComments( comments );
	}
	
	
	
	public String toString(){
		return this.id;
	}
	
	/**
	 * Getters / Setters
	 */
	
	public void setComments( ArrayList<PermComment> comments){
		this.comments = comments;
	}
	
	public ArrayList<PermComment> getComments(){
		return this.comments;
	}

	public PermImage getImage() {
		return image;
	}

	public void setImage(PermImage image) {
		this.image = image;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public User getAuthor() {
		return author;
	}

	public void setAuthor(User author) {
		this.author = author;
	}

	public PermBoard getBoard() {
		return board;
	}

	public void setBoard(PermBoard board) {
		this.board = board;
	}
	
}
