<%
/** ############################################################### */
/** Program ID   : sessionchk.jsp                                   */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap"%>
<% 
	String root = request.getContextPath();
	
	HashMap userInfo = (HashMap)session.getAttribute("userInfo");

	if( (String)userInfo.get("user_id") == null)  
	{
%>
		<script type="text/JavaScript" >
			alert("연결이 종료 되었습니다.\n 다시 로그인 하세요");
			top.document.location.href = "<%=root%>/index.jsp"; 
		</script>
<% 
	} 
%>