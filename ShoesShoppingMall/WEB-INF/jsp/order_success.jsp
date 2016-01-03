<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	alert("주문이 완료되었습니다.\n일주일 이내 입금 없을경우 주문이 취소 됩니다.");
});
</script>
 	<font color="#353535"><h2><i><u>Order Infomation</u></i></h2></font>
	<font color="#8C8C8C"><h3>상품 주문 완료</h3></font>

	<table border="0" bordercolorlight="#D5D5D5" bordercolordark="white" width="800" cellspacing="0" class="topline">
		<thead>
		</thead>
		<tbody>
			<tr height="40">
				<th class='line'>주문번호</th>
				<td class='line'>${requestScope.oto.orderId }<td>
			</tr>
			<tr height="40">
				<th class='line'>상품번호</th>
				<td class='line'>${requestScope.oto.orderProduct }<td>
			</tr>
			<tr height="40">
				<th class='line'>상품메세지</th>
				<td class='line'>${requestScope.pto.message }<td>
			</tr>
			<tr height="40">
				<th class='line'>금액</th>
				<td class='line'>${requestScope.pto.price } 원<td>
			</tr>
			<tr height="40">
				<th class='line'>입금계좌번호</th>
				<td class='line'>Kosta은행 1002-434055-261  예금주:김구두<td>
			</tr>
			<tr height="40">
				<th class='line'>배송지</th>
				<td class='line'>${requestScope.oto.orderAddress } ${requestScope.oto.orderZipcode }<td>
			</tr>
			<tr height="40">
				<th class='line'>주문메세지</th>
				<td class='line'>${requestScope.oto.orderMessage }<td>
			</tr>
		</tbody>
		<tfoot>
				<tr>
					<td colspan="7">
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
