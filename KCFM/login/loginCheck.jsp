<%
/** ############################################################### */
/** Program ID   : loginCheck.jsp                                   */
/** Program Name : 로그인                                           */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.login.dao.loginCheckDao" %>
<%@ page import="com.login.beans.loginCheckBean" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>

<% 
	
	com.util.Log4u log4u = new com.util.Log4u();

	String root = request.getContextPath();

	loginCheckBean userBean = null; 
	loginCheckDao  userDao  = new loginCheckDao();
	
	ArrayList<loginCheckBean> list = null;
	
	String msg = "";
	
	
	String userId   = JSPUtil.chkNull((String)request.getParameter("userId")  ,"");
	String passWord = JSPUtil.chkNull((String)request.getParameter("password"),"");
	String chkAuth  = JSPUtil.chkNull((String)request.getParameter("chkAuth") ,"");
	
	//사용자ID(사업자번호), Password, 권한체크(매장,전단지업체,관리자)
	String loginStatus = userDao.checkUserLogin(request,userId, passWord, chkAuth);
	
	if( "".equals(loginStatus) )
	{
		msg = "no";
	}
	else
	{
		if ( chkAuth.equals("10") )
		{
			msg = "10";	//매장 페이지
		}
		else if (chkAuth.equals("41"))
		{
			msg = "30"; //홍보물 페이지
		}
		else
		{
			msg = "20"; //관리자 페이지
		}
	}

	out.println(msg);
	
%>