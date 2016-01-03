<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core" %>
	<img alt="" src="/kostaWebS/images/decoration/mypageLogo.jpg"><p>
	<div style="padding-left: 50px;font-size:9pt;color:#5F00FF;background-image:url(/kostaWebS/images/decoration/background01.jpg);width:700px;height:400px" >	
		<c:if test="${sessionScope.login_info!=null }">
			<c:if test="${sessionScope.login_info.memberLevel==9 }">
				<a href="/kostaWebS/material/materialForm.do"><img alt="" src="/kostaWebS/images/decoration/material1.jpg" border="0"></a><br>
				관리자 - Material 등록<p>
				<a href="/kostaWebS/material/materialSearchForm.do"><img alt="" src="/kostaWebS/images/decoration/material2.jpg" border="0"></a><br>
				관리자 - Material 조회<p>
				<a href="/kostaWebS/supplier/supplierForm.do"><img alt="" src="/kostaWebS/images/decoration/material3.jpg" border="0"></a><br>
				관리자 - Supplier 등록<p>
				<a href="/kostaWebS/supplier/supplierSearchForm.do"><img alt="" src="/kostaWebS/images/decoration/material4.jpg" border="0"></a><br>
				관리자 - Supplier 검색<p>
			</c:if>
		</c:if>
	</div>