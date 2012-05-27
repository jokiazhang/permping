package com.permping.model;

import java.io.Serializable;

public class PermComment implements Serializable{

	private String id;
	private String content;
	private User author;
	private static final long serialVersionUID = 3234423477L;
	
	public PermComment(){
		
	}
	
	public PermComment(String id){
		
	}
	
	public PermComment( String id, String content ){
		this.id = id;
		this.content = content;
	}
	
	public void setAuthor( User author ){
		this.author = author;
	}
	
	public User getAuthor(){
		return this.author;
	}
	
	
	public String getId(){
		return this.id;
	}
	
	public String getContent(){
		return this.content;
	}

}
