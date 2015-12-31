package com.corp.controller;

import com.corp.jsp.b.b1101;
import com.corp.jsp.b.b1001;
public class ControllerMapping {
	
	
	public static ControllerInterface getController(String command){
		ControllerInterface ctr = null;
		
		
		if(command.equals("b1101.do"))
		{
			ctr = new b1101();
		}else if(command.equals("b1001.do"))
		{
			ctr = new b1001();
		}else if(command.equals(""))
		{
		}else if(command.equals(""))
		{
		}
		
		 return ctr;
	}
}
