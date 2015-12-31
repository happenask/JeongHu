<%
/** ############################################################### */
/** Program ID   : common.jsp                                       */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%-- <%@ page contentType="text/html; charset=UTF-8" %>  --%>
<%@ page import="java.util.*"%>
<%@ page import="com.util.JSPUtil" %>
<%
	//System.out.println("Program Trace LOG >> Program_ID [ common ] " + JSPUtil.getDateTimeHypen());

	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache"); 
	response.setDateHeader("Expires",0);

	HashMap  paramData = new HashMap();
	Map      map       = request.getParameterMap();
	Iterator it        = map.keySet().iterator();
	Object   key       = null;
	String[] value     = null;			 
	String   parameter = ""; 

	while(it.hasNext()) 
	{
		key   = it.next(); 
		value = (String[]) map.get(key);

		if( key.equals("selected_seq") )  
		{
		 	String[] chk = null;	    	   
		 	chk = (String[]) map.get(key);
		 	paramData.put("SELECTED_SEQ",chk);
		}
		else 
		{
	   		value = (String[]) map.get(key);
		  
	   		for(int i = 0 ; i < value.length; i++) 
	   		{
		  		paramData.put(key, JSPUtil.chkNull(JSPUtil.ko(value[i])).trim());
		  		
		  		if( !key.equals("mode") )  // mode는 별개로 지정을 해줘야 한다. 
		  		{
		      		parameter = parameter + key + "=" + JSPUtil.chkNull(JSPUtil.ko(value[i])).trim() + "&";
		  		}
	   		}
		}

	} // the end of while
%>