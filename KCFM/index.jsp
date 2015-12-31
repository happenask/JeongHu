<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %>

<%
	com.util.Log4u log4u = new com.util.Log4u();
	String sID = session.getAttribute("sseCustId") == null ? "" : session.getAttribute("sseCustId").toString();
	log4u.sID = sID;		

	log4u.log("CALL /logout.jsp");

	try
	{
		log4u.log("* Session..........");
		java.util.Enumeration nm1 = session.getAttributeNames();
		while (nm1.hasMoreElements()) {
		    String name = (String)nm1.nextElement();
	    	log4u.log("   - " + name + " ["+session.getAttribute(name) + "]");
		}
	}
	catch(Exception e)
	{
		
	}

	String root = request.getContextPath();
	session.invalidate();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!-- <meta http-equiv="X-UA-Compatible" content="IE=9" /> -->	 <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	<meta name="keywords" content="" /><!-- 검색용 키워드 -->
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
		$("#login-box").slideDown(800);
    });
	
    function fnLogin(gb){
    	fnShowLoading();    	

   	   //var timer = setTimeout(goMain, 3000);
// 	   function goMain(){
//    	    	location.href= "main.html";
//    	   }
		
	 
		$.ajax(
		{
			url      : "<%=root%>/login/loginCheck.jsp?chkAuth="+gb,
			type     : "POST",
			data     : $("#signInForm").serialize(),
			dataType : "html", 
			success  : function(data)
					   {  
						   if( trim(data) == "10" )
						   { 
							   location.href= "main.jsp";
				           }
						   else if( trim(data) == "20" )
						   {
							   location.href= "<%=root%>/admin-page/admin-main.jsp?pageGb=01";
						   }
						   else if( trim(data) == "30" )
						   {
							   location.href= "<%=root%>/promotion/prom-ord-list.jsp?pageGb=prom";
						   }
						   else if( trim(data) == "no" )
						   {
								alert("아이디 및 비밀번호를 다시 입력해 주십시오.");
								$(".overlay-bg").hide();
								$("#loadingImage").hide();
				           }
			           }
		});
    }
    

    function trim(s) 
    {
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }
    </script>
    
</head>
<body>
 <!-- 웹디자인 psd 참고 자료 블로그  http://blog.naver.com/783s?Redirect=Log&logNo=220028664313-->
 	<div id="wrap" >
	 	<section class="header-bg" id="index-title">
	 		<div>타이틀</div>
	 	</section>
	 	<section id="login-box">
					<form id="signInForm" name="signInForm" method="POST"> 
							
						    <h1>Login</h1>
						    <p>
						        <label for="login">Username or email</label>
						        <input type="text" id="userId" name="userId" fieldrequired="required" type="email" placeholder="Username or email"  maxlength="20"/>
						    </p>
						    <p>
						        <label for="password">Password</label>
						        <input type="password"  id = "password" name="password" fieldrequired="required" type="password" placeholder="Password" > 
						    </p>
						
						    <p>
	 							<span id="f-logo">유니포스-로고</span>
								<button class="grayBtn" type="button" onclick="" >비밀번호찾기</button>
								<button class="redBtn" type="button" onclick="fnLogin('10');" >로그인</button>
						    </p> 


					</form>
	 	</section>
	 	<!-- 로딩이미지 -->
	 	<div class="overlay-bg">
	 		<!--<img id="loadingImage" src="assets/images/viewLoading.gif" style="position: relative; cursor: pointer; top: 340px; left: 477px;display: none; "> -->
	 	 	<img id="loadingImage" src="http://i1.daumcdn.net/cfs.tistory/resource/315/blog/plugins/lightbox/images/loading.gif" style="position: relative; cursor: pointer; top: 340px; display: none; ">
	 	</div>
 	</div>
</body>
</html>