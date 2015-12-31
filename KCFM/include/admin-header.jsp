<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="main.dao.mainDao" %>
<%@ page import="main.beans.mainBean" %>
<%@ page import="com.util.BoardConstant" %>
<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /header.jsp");

	String CustPassWd         = (String)session.getAttribute("sseCustPassWd");
	String CustStoreNm        = (String)session.getAttribute("sseCustStoreNm");
	String CustTelNo          = (String)session.getAttribute("sseCustTelNo");
	String CustHpNo           = (String)session.getAttribute("sseCustHpNo");
	String SvCustNm           = (String)session.getAttribute("sseSvCustNm");
	String SvTelNo            = (String)session.getAttribute("sseSvTelNo");
	String CustAuth           = (String)session.getAttribute("sseCustAuth");
	
	
%>
		<!-- 관리자 헤더 영역  -->
	    <script type="text/javascript" src="<%=root%>/assets/js/style.js"></script>
	    <script type="text/javascript">
		$(document).ready(function(){ 
			getCurrent();
		});
		</script>
	 	<div id="header">
	 		<header>
	 			<h1 onclick="location.href='<%=root%>/admin-page/admin-main.jsp?pageGb=01'">헤더-타이틀</h1>
	 			<span id="logo">유니포스-로고</span>
	 			<span id="btns">
	 				<input type="button" id="logout-btn" class="rd-bord-btn" value="로그아웃" class="button" onclick="location.href='<%=root%>/index.jsp'">
<%-- 	 				<input type="button" id="main-btn" class="nv-bord-btn" value="MAIN" class="button" onclick="location.href='<%=root%>/main.jsp'"> --%>
	 				<input type="button" id="mody-btn" class="rd-bord-btn" value="정보수정 ▶" class="button" onclick="fnShowPaneladmin();">
	 				</span>
	 			
	 				<div class="gnb">
	 					<div id="currentTime">...<span></span></div>
	 				</div>
	 		</header>
	 		</div>