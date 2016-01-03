<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 인클루드 되므로 보여질 부분만 넣는다. -->

	<c:choose>
	<c:when test="${sessionScope.login_info!=null }">
		
		 <a href="/kostaWebS/logOutMember.do"><img src="/kostaWebS/images/log_out1.jpg"  border="0" onmouseover="this.src='/kostaWebS/images/log_out2.jpg'" onmouseout="this.src='/kostaWebS/images/log_out1.jpg'"/></a>
	</c:when>
	
	<c:otherwise>
	<a href="/kostaWebS/loginForm.do"><img src="/kostaWebS/images/login_menu1.jpg"  border="0" onmouseover="this.src='/kostaWebS/images/login_menu1_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu1.jpg'"/></a>
	</c:otherwise>	
	</c:choose>

 <a href="/kostaWebS/joinForm.do"><img src="/kostaWebS/images/login_menu2.jpg"  border="0" onmouseover="this.src='/kostaWebS/images/login_menu2_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu2.jpg'"/></a>
 <a href="/product/list.html?cate_no=46"><img src="/kostaWebS/images/login_menu3.jpg" border="0"  onmouseover="this.src='/kostaWebS/images/login_menu3_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu3.jpg'"/></a>
<c:if test="${sessionScope.login_info!=null }">
	 <a href="/kostaWebS/order/orderList.do?memberNum=${sessionScope.login_info.memberNum }"><img src="/kostaWebS/images/login_menu4.jpg"  border="0" onmouseover="this.src='/kostaWebS/images/login_menu4_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu4.jpg'"/></a>	
</c:if>
 <a href="/kostaWebS/mypageForm.do"><img src="/kostaWebS/images/login_menu5.jpg"  border="0" onmouseover="this.src='/kostaWebS/images/login_menu5_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu5.jpg'"/></a>

 
 