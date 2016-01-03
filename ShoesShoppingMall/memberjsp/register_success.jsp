<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<div style="border:1px solid #B2CCFF ;padding-left:100px;padding-top: 50px;width:400px;height:400px;color:#747474;font-style:normal;font-family:fantasy;">

		<p align="center">회원가입이<br/>완료 되었습니다.</p>

		
				<img alt="" src="/kostaWebS/images/decoration/reg_successLogo.jpg" width="80px">
		<p>
			
			<span>
				<strong>아이디</strong>${requestScope.mto.id }<br/><strong>이름</strong>${requestScope.mto.name}<br/>
			</span>
		</p>

		        <div>
		        <p>
		        
		                저희 쇼핑몰을 이용해 주셔서 감사합니다. <strong>${requestScope.mto.id }</strong>
		              <c:choose>  
		              	<c:when test="${requestScope.mto.memberLevel=='A' }">
		                은 [일반회원] 회원이십니다.
		              	</c:when>
		              	<c:when test="${requestScope.mto.memberLevel=='B' }">
		              	은 [준회원] 회원이십니다.
		              	</c:when>
		              
		              </c:choose>
		              <p>
		              	<a href = "/kostaWebS/loginForm.do"><img alt="로그인" src="/kostaWebS/images/decoration/mypageLoginBtn.jpg" border="0"></a>
		              	&nbsp;&nbsp;&nbsp;
		              	<a href = "/kostaWebS/mainPage.do"><img alt="메인" src="/kostaWebS/images/decoration/mypageMainBtn.jpg" border="0"></a>	
				</div>
        
		</div>
</body>
</html>