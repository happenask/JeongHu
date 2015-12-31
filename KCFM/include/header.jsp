<!-- 
/** ############################################################### */
/** Program ID   : header.jsp                                         														 */
/** Program Name :  home	       						                   													 */
/** Program Desc :  프로그램 메인 																						 */
/** Create Date  :   2015.04.13						              														 */
/** Update Date  :                                                  															 */
/** Programmer   :   s.h.e                                           														 */
/** ############################################################### */
 -->

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

	String user_nm         = (String)session.getAttribute("user_nm");
	String CustStoreNm        = (String)session.getAttribute("sseCustStoreNm");
	String CustTelNo          = (String)session.getAttribute("sseCustTelNo");
	String CustHpNo           = (String)session.getAttribute("sseCustHpNo");
	String SvCustNm           = (String)session.getAttribute("sseSvCustNm");
	String SvTelNo            = (String)session.getAttribute("sseSvTelNo");
	String CustAuth           = (String)session.getAttribute("sseCustAuth");
	
	
%>

<div id="header">
	<header>
		<h1 >헤더-타이틀</h1>
		<span id="logo">유니포스-로고</span>
		<span id="btns">
			<input type="button" id="logout-btn" class="rd-bord-btn" value="로그아웃" class="button" onclick="location.href='<%=root%>/index.jsp'">
			<input type="button" id="main-btn" class="nv-bord-btn" value="MAIN" class="button" onclick="location.href='<%=root%>/main.jsp'">
		</span>
		<nav class="gnb">
			<ul class="topmenu">
				<li><a href="<%=root%>/jsp/b1101.jsp?tabNo=1">영업관리</a>
					<ul class="submenu">
					<li><a href="<%=root%>/jsp/b1101.jsp?tabNo=1">가맹점 현황</a></li>
					<li><a href="<%=root%>/jsp/b1001.jsp?tabNo=1">JQX그리드테스트</a></li>
					</ul>
				</li>
			</ul>
		</nav>
	</header>	
</div>
	 		
<div id="info-bg">
	<div id="info">
		<div id="account">
			<span><%=user_nm%></span>
			<span id="btn"><input type="button" id="mody-btn" class="nv-bord-btn" value="정보변경" class="button" onclick="fnShowPanel();"></span>
		</div>
		<div id="account-info">
			<span id="ph-no">전화번호 : <%=CustTelNo%> /</span> 
			<span id="mb-no">휴대전화 : <%=CustHpNo %> /</span> 
			<span id="charge-man">담당SV : <%=SvCustNm%>(<%=SvTelNo%>)</span>
		</div>
	</div><!-- info end -->
</div>