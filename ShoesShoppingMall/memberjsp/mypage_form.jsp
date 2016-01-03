<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
	<p>
	<img alt="" src="/kostaWebS/images/decoration/mypageLogo.jpg"><p>
	<div style="padding-left: 50px;font-size:9pt;color:#5F00FF;background-image:url(/kostaWebS/images/decoration/background01.jpg);width:700px;height:400px" >	
		<c:if test="${sessionScope.login_info!=null }">
			<a href="/kostaWebS/order/orderList.do?memberNum=${sessionScope.login_info.memberNum }"><img alt="" src="/kostaWebS/images/decoration/orderlist.jpg" border="0"></a><br>
			고객님께서 주문하신 상품의 주문내역을 확인<p>
			<a href="/kostaWebS/updateForm.do"><img alt="" src="/kostaWebS/images/decoration/members.jpg" border="0"></a><br>
			회원이신 고객님의 개인정보 수정<p>
		</c:if>
		<c:if test="${sessionScope.login_info==null}">
			<a href="/kostaWebS/loginForm.do"><img alt="" src="/kostaWebS/images/decoration/orderlist.jpg" border="0"></a><br>
			고객님께서 주문하신 상품의 주문내역을 확인<p>
			<a href="/kostaWebS/loginForm.do"><img alt="" src="/kostaWebS/images/decoration/members.jpg" border="0"></a><br>
			회원이신 고객님의 개인정보 수정<p>
		</c:if>
			<a href=""><img alt="" src="/kostaWebS/images/decoration/wishlist.jpg" border="0"></a><br>
			관심상품으로 등록하실 상품의 목록<p>
			<a href=""><img alt="" src="/kostaWebS/images/decoration/mileage.jpg" border="0"></a><br>
			고객님의 마일리지 확인<p>
		<c:if test="${sessionScope.login_info!=null }">
			<c:if test="${sessionScope.login_info.memberLevel==9 }">
				<a href="/kostaWebS/managementForm.do"><img alt="" src="/kostaWebS/images/decoration/management.jpg" border="0"></a><br>
				재료 및 상품관리<p>
			
			</c:if>
		</c:if>
	</div>
