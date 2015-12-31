/** ############################################################### */
/** Program ID   : CodeBean.java                                    */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.beans;

import com.util.JSPUtil;

/**
 * 코드 빈
 * 코드빈은 ClassCode, Code, Name으로 구성됩니다.
 *  
 * 
 * @author Administrator 
 */
public class CodeBean 
{
	
	//Init
	private String strCode      = null;
	private String strCodeName  = null;
	private String strClassCode = null;
	
	//Get
	public String getStrCode     () { return strCode     ; }
	public String getStrCodeName () { return strCodeName ; }
	public String getStrClassCode() { return strClassCode; }
	// ADV Get 
	
	//Set
	public void setStrCode     (String strTemp) { strCode      = strTemp; }
	public void setStrCodeName (String strTemp) { strCodeName  = strTemp; }
	public void setStrClassCode(String strTemp) { strClassCode = strTemp; }
	
}
