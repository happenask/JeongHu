<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core" %>
	<img alt="" src="/kostaWebS/images/decoration/mypageLogo.jpg"><p>
	<div style="padding-left: 50px;font-size:9pt;color:#5F00FF;background-image:url(/kostaWebS/images/decoration/background01.jpg);width:700px;height:400px" >	
		<c:if test="${sessionScope.login_info!=null }">
			<c:if test="${sessionScope.login_info.memberLevel==9 }">
				<a href="/kostaWebS/material/getMaterialsByType.do?url=model_insert_form"><img alt="" src="/kostaWebS/images/decoration/model1.jpg" border="0"></a><br>
				관리자 - Model 등록<p>
				<a href="/kostaWebS/model/modelList.do"><img alt="" src="/kostaWebS/images/decoration/model2.jpg" border="0"></a><br>
				관리자 - Model 조회 및 수정<p>
			</c:if>
		</c:if>
	</div>
