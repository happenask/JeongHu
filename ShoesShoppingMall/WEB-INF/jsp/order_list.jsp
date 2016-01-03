<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
});
function searchProduct(productId){
	window.open("/kostaWebS/product/getProductById.do?productId="+productId,"Product_Infomation","width=450,height=400");
}
</script>
	<img alt="" src="/kostaWebS/images/decoration/mypageLogo.jpg"><p>
 	<font color="#353535"><h2><i><u>Order Infomation</u></i></h2></font>
 	
	<table border="0" bordercolorlight="#D5D5D5" bordercolordark="white" width="800" cellspacing="0" class="topline">
		<thead>
			<tr height="50">
				<td class="line">주문 날짜</td>
				<td class="line">주문 번호</td>
				<td class="line">상품 정보</td>
				<td class="line">주문 단계</td>
			</tr>
		<thead>
		<tbody id="tbody">
			<core:choose>
				<core:when test="${requestScope.list != null }">
					<core:forEach items="${requestScope.list}" var="order">
						<tr height="40">
							<td class="line">${order.orderDate }</td>
							<td class="line">${order.orderId }</td>
							<td class="line" onClick="searchProduct('${order.orderProduct }');">${order.orderProduct }</td>
							<td class="line">
								<core:choose>
									<core:when test="${order.orderLevel == 0}">입금 확인중</core:when>
									<core:when test="${order.orderLevel == 1}">입금 확인 완료</core:when>
									<core:when test="${order.orderLevel == 2}">제품 준비중</core:when>
									<core:when test="${order.orderLevel == 3}">배송 준비중</core:when>
									<core:when test="${order.orderLevel == 4}">배송 완료</core:when>
									<core:when test="${order.orderLevel == 5}">거래 완료</core:when>
									<core:otherwise>주문 취소</core:otherwise>
								</core:choose>
							</td>
						</tr>
					</core:forEach>
				</core:when>
				<core:otherwise>
					<tr height="40">
						<td colspan="3">
							주문사항이 없습니다.	
						</td>	
					</tr>
				</core:otherwise>
			</core:choose>
		</tbody>
		<tfoot>
				<tr>
					<td colspan="3">
							<span style="padding-left:250px;text-decoration:none ">
								<a href = "/kostaWebS/mainPage.do"><button>메인 페이지로</button></a>
								<a href = "/kostaWebS/mypageForm.do" ><button>마이 페이지로</button></a>
							</span>
					</td>	
				</tr>
				<tr>		
				</tr>
		</tfoot>
	</table>