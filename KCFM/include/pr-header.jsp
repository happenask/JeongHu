<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/com/sessionchk.jsp"%>

<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /include/pr-header.jsp");

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
			</span>
		

		<nav class="gnb">
			<ul class="topmenu">
				<li><a href="<%=root%>/promotion/prom-ord-list.jsp">매장주문내역</a></li>
				<li><a href="<%=root%>/promotion/prom-dtl.jsp">홍보물관리</a></li>
			</ul>
		</nav>
		
	</header>
	
</div>

<div id="info-bg">
	<div id="info">
		<div id="account">
			<span><%=CustStoreNm%></span>
			<span id="btn"><input type="button" id="mody-btn" class="nv-bord-btn" value="정보변경" class="button" onclick="fnShowPanel();"></span>
		</div>
		<div id="account-info">
			<span id="ph-no">전화번호 : <%=CustTelNo%> /</span> 
			<span id="mb-no">휴대전화 : <%=CustHpNo %> </span> 
		</div>
	</div><!-- info end -->
</div>