/** ############################################################### */
/** Program ID   : DAOException.java                                */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.exception;

/**
 * DAO에서 발생하는 오류.
 * @author 
 *
 */

public class DAOException extends Exception 
{
    
	/**
	 * Construstor !
	 */
	public DAOException() 
	{
		super();
	}
	
	/**
	 * Construstor !
	 * @param message
	 */
	public DAOException(String message) 
	{
		super(message);
	}
	
	/**
	 * Construstor !
	 * @param message
	 * @param cause
	 */
	public DAOException(String message, Throwable cause) 
	{
		super(message, cause);
	}
	
	/**
	 * Construstor !
	 * @param cause
	 */
	public DAOException(Throwable cause) 
	{
		super(cause);
	}
  
}
