package com.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class Log4u {

	public String sID = "";
    
    public void log(String str)
    {
    	try
    	{
    		System.out.println(logtime() + str);
    	}
    	catch(Exception e)
    	{
    		
    	}
    	
    	return;
    }

    public void debug(String str)
    {
    	try
    	{
    		System.out.println(logtime() + str);
    	}
    	catch(Exception e)
    	{
    		
    	}
    	
    	return;
    }
    
    
    public void error(String str)
    {
    	try
    	{
    		System.out.println(logtime() + str);
    	}
    	catch(Exception e)
    	{
    		
    	}
    	
    	return;
    }
    
    
    
    public String logtime() 
    throws Exception
    {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.KOREA);
		return format.format(new Date()) + "-" +sID+"> ";
	}	
	
}
