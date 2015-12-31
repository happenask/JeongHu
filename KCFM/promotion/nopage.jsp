<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %>

<%
	com.util.Log4u log4u = new com.util.Log4u();

	String root = request.getContextPath();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=9" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	<meta name="keywords" content="" /><!-- 검색용 키워드 -->
 	<meta name="description" content="스쿨푸드 PRM 서비스입니다." /><!-- 페이지 설명 -->
	<title>KCFM 로그인</title>  
	
	<link href="assets/css/common.css" rel="stylesheet" type="text/css" />
	<!-- IE8 이하에서 미디어 쿼리(Media Query) 사용 지원 -->
	<!--[if lt IE 9]><script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
    <!-- IE 8 이하에서 HTML5 태그 지원하도록 스크립트 링크 -->
    <!-- 참고 글 : http://www.cmsfactory.net/node -->
    <!--[if lt IE 9]><script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script><![endif]-->
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="assets/js/style.js"></script>
    
    <script type="text/javascript">
	$(document).ready(function(){
		$("#login-box").slideDown(1);
    });
	
	function pageback()
	{
		history.back();
	}
    </script>
    
</head>
<body>
 <!-- 웹디자인 psd 참고 자료 블로그  http://blog.naver.com/783s?Redirect=Log&logNo=220028664313-->
 	<div id="wrap" >
	 	<section class="header-bg" id="index-title">
	 		<div>타이틀</div>
	 	</section>
	 	<table border="0" width='100%'>
	 		<tr>
	 			<td align="center">&nbsp;</td>
	 		</tr>
	 		<tr>
	 			<td align="center"><h1>공사중인 페이지 입니다.</h1></td>
	 		</tr>
	 		<tr>
	 			<td align="center"><button class="redBtn" type="button" onclick="pageback();" >이전페이지</button></td>
	 		</tr>
	 	</table>
	 	<!-- 로딩이미지 -->
	 	<div class="overlay-bg">
	 		<!--<img id="loadingImage" src="assets/images/viewLoading.gif" style="position: relative; cursor: pointer; top: 340px; left: 477px;display: none; "> -->
	 	 	<img id="loadingImage" src="http://i1.daumcdn.net/cfs.tistory/resource/315/blog/plugins/lightbox/images/loading.gif" style="position: relative; cursor: pointer; top: 340px; display: none; ">
	 	</div>
 	</div>
</body>
</html>