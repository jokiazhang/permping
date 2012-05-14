package com.permping.controller;

import com.permping.model.*;
import java.util.ArrayList;
public class PermListController {

	/**
	 * Constructor
	 */
	public PermListController(){
		
	}
	
	/**
	 * @TODO simulate perm list
	 */
	public ArrayList<Perm> getPermList(){
		
		ArrayList <Perm> permList = new ArrayList<Perm>();
		for( int i = 0; i < 9 ; i++ ){
			Perm permObject = new Perm( "ID-" + String.valueOf( i + 1 ));
			//Set attributes
			String name = "Perm number " + String.valueOf( i + 1 );
			permObject.setName(name);
			
			PermImage imageObject = new PermImage("http://static.adzerk.net/Advertisers/d18eea9d28f3490b8dcbfa9e38f8336e.jpg");
			permObject.setImage( imageObject );
			
			//Add to list
			permList.add( permObject );
		}
		return permList;
	}
}
