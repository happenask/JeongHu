/** ############################################################### */
/** Program ID   : orderLogDBConnect.java                           */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.db;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class orderLogDBConnect 
{

	private static orderLogDBConnect instance = new orderLogDBConnect();
	
	DataSource ds = null;
	
	public static orderLogDBConnect getInstance()
	{
		return instance;
	}
	
	synchronized void setDs() throws Exception 
	{
		
		Context initContext = new InitialContext();
		Context envContext  = (Context)initContext.lookup("java:comp/env");
		ds = (DataSource)envContext.lookup("jdbc/PJIKdb");
		
	}
	
	public Connection getConnection() throws SQLException 
	{
		
		try 
		{
			if( this.ds == null ) 
			{
				setDs();
			}
			
			return this.ds.getConnection();
		} 
		catch (Exception e) 
		{
			throw new SQLException(e.getMessage());
		}
		
	}
	
}
