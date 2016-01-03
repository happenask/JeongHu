<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	readAddress();
	insertComma('${requestScope.pto.price }');
	$("#orderDate").val(getTodayDate());
	$("#postCheck").click(function(){
		var chk = $("#postCheck").attr("chkAdd");
		if(chk=="0"){
			$("#addr2").val("");
			$("#postCheck").attr("chkAdd", "1");
			$("#postCheck").val("내 주소 사용");
			window.open("/kostaWebS/memberjsp/checkPost_popup.jsp","address","width=500,height=300,scrollbars=yes");	
		}else {
			readAddress();
			$("#postCheck").attr("chkAdd", "0");
			$("#postCheck").val("새 주소 사용");
		}
	});
	$("#submitBtn").on("click",function(){
		$("#address").val($("#addr1").val()+" "+$("#addr2").val());
		$("#zip").val($("#postcode1").val());
		$("#joinForm").submit();
	});
	$("#mainPageBtn").on("click",function(){
		var flag = window.confirm("페이지에서 벗어 납니다.\n메인페이지로 가시겠습니까?");
		if(flag){
			$("#mainPageDo").submit();
		}
	});
	$("#info").on("click", function(){
		window.open("/kostaWebS/material/getMaterialById.do?"+
				"heel="+$("#heel").val()+"&leather="+$("#leather").val()+
				"&acc1="+$("#acc1").val()+"&acc2="+$("#acc2").val()+
				"&size="+$("#size").val()+"&price=${requestScope.pto.price }"
				,"Product_Infomation","width=450,height=400,scrollbars=yes");	
	});
});
function readAddress(){
	$("#postcode1").val("${sessionScope.login_info.zipcode}");
	var subS = "${sessionScope.login_info.address}";
	var len = subS.length;
	$("#addr1").val(subS.slice(0, subS.indexOf(' ', subS.indexOf(' ', subS.indexOf(' ')+1)+1)));	
	$("#addr2").val(subS.slice(subS.indexOf(' ', subS.indexOf(' ', subS.indexOf(' ')+1)+1)+1, len));
}
function getTodayDate(){
	var date = new Date();
	var year = date.getFullYear();
	var month = (date.getMonth() + 1);
	var day = date.getDate();
	if(month>=1 && month<=9)month = "0"+month;
	if(day>=1 && day<=9)day = "0"+day;
	var tmp = ""+year+"-"+month+"-"+day;
	return tmp;
};
function insertComma(number){
	 var txt = document.getElementById("price");
	 var num = numberFormat(number+"");
	 txt.value = num;
}
function numberFormat(num) {
	 var pattern = /(-?[0-9]+)([0-9]{3})/;
	 while(pattern.test(num)) {
	  num = num.replace(pattern,"$1,$2");
	 }
	 return num;
}
</script>
 	<font color="#353535"><h2><i><u>Order Infomation</u></i></h2></font>
	<font color="#8C8C8C"><h3>상세 주문 정보 입력</h3></font>
	<form id="joinForm" action="/kostaWebS/order/orderInsert.do" method="post" name="form">
	<table border="0" bordercolorlight="#D5D5D5" bordercolordark="white" cellspacing="0" width="800" height="350" class="topline">
		<thead></thead>
		<tbody>
			<tr>
				<th class="line">주문자</th>
				<td class="line"><input type="text" name="orderName" value="${sessionScope.login_info.name }" disabled="disabled"/>
								<input type="hidden" name="orderMember" value="${sessionScope.login_info.memberNum }"/>
				</td>
			</tr>
			<tr>
				<th class="line">제품정보</th>
				<td class="line"><input type="text" id="info" name="orderProduct" value="${requestScope.pto.productId }" readonly="readonly"></td>
			</tr>
			<tr>
				<th class="line">주문날짜</th>
				<td class="line"><input type="text" name="orderDate" id="orderDate" readonly="readonly"/></td>
			</tr>
			<tr>
				<th class="line">주소입력</th>
				 <td class="line">
				 	<input type="button" id="postCheck" value="새 주소 사용" chkAdd="0"><br>
					<!-- <img src="/kostaWebS/images/decoration/checkPostNum.jpg" alt="우편번호 검색" border="0" id="postCheck"/></a><br> -->
                    <input id="postcode1" name="zipcode" value="" type="text" readonly="readonly" size="5" disabled="disabled"/><br>
                    <input id="addr1" name="address1" type="text" maxlength="100" size="50" readonly="readonly" disabled="disabled"/><br/>
                    <input id="addr2" type="text" maxlength="100" size="50"/>
                    <input id="zip" type="hidden" name="orderZipcode"/>
                    <input id="address" type="hidden" name="orderAddress" />
                </td>
			</tr>
			<tr>
				<th class="line">PRICE</th>
				<td class="line">
					<input type="text" id="price" value="" style="text-align: right;" readonly="readonly">원
					<input type="hidden" name="price" value="${requestScope.pto.price }">
				</td>
			</tr>
			<tr>
				<th class="line">SIZE</th>
				<td class="line"><input type="text" name="size" id="size" value="${requestScope.pto.size }" style="text-align: right;" readonly="readonly">mm</td>
			</tr>
			<tr>
				<th class="line">주문 요청사항</th>
				<td class="line"><input type="text" name="orderMessage" id="msg" size="60"></td>
			</tr>
		</tbody>
		<tfoot>
				<tr>
					<td colspan="3">
							<span style="padding-left:250px;text-decoration:none ">
							<img id="mainPageBtn" alt="주문 취소" src="/kostaWebS/images/decoration/goHome.jpg" border="0">
							<img id="submitBtn" alt="다음단계" src="/kostaWebS/images/decoration/nextOrder.jpg" border="0" >
							
							</span>
					</td>	
				</tr>
				<tr>		
				</tr>
		</tfoot>
	</table>
	<div id="hide">
	<input type="hidden" name="productId" value="${requestScope.pto.productId }"/>
	<input type="hidden" id="heel" name="heel" value="${requestScope.pto.heel }"/>
	<input type="hidden" id="leather" name="leather" value="${requestScope.pto.leather }"/>
	<input type="hidden" id="acc1" name="acc1" value="${requestScope.pto.acc1 }"/>
	<input type="hidden" id="acc2" name="acc2" value="${requestScope.pto.acc2 }"/>
	<input type="hidden" name="message" value="${requestScope.pto.message }"/>
	</div>
	</form>
 	<form id="mainPageDo" action="/kostaWebS/mainPage.do" method="post">
	</form>
