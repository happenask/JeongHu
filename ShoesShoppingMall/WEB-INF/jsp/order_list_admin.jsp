<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %> 
<link type="text/css" href="../css/jquery-ui.css" rel="stylesheet">
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript" src="../jquery-ui.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#dialog_layer").on("click","#downLv", function(){
		submitFunction("/kostaWebS/order/orderLevelDown.do");
	});
	$("#dialog_layer").on("click","#upLv", function(){
		submitFunction("/kostaWebS/order/orderLevelUp.do");
	});
	$("#dialog_layer").on("click","#holdLv", function(){
		$("#dialog_layer").dialog("close");
	});
	$("#btnA").on("click", function(){
		ajax("/kostaWebS/order/getOrderListAll.do", null);
	});
	$("#btnB").on("click", function(){
		ajax("/kostaWebS/order/getOrderListIng.do", null);
	});
	$("#btnI").on("click", function(){
		ajax("/kostaWebS/order/getOrderListById.do", "orderId="+$("#orderId").val());
	});
	$("#btnD").on("click", function(){
		var sDate = $('#sDate').val();
		var eDate = $('#eDate').val();
		if(!(sDate==""||eDate=="")){
			if(chkDate(sDate, eDate)){
				ajax("/kostaWebS/order/getOrderListByDate.do", "sDate="+sDate+"&eDate="+eDate);
				return;
			}
		}
		alert("날자가 정확히 선택되지 않았습니다.");
	});
	
	$(".datepicker").datepicker({"changeYear":true, 
								"changeMonth":true,
								"yearRange":"2011:2016",
								"dateFormat":"yy-mm-dd",
								"dayNames":["일요일", "월요일","화요일","수요일","목요일","금요일","토요일"],
								"dayNamesMin":["일","월","화","수","목","금","토"]
	});
});
function ajax(url, dateType){
	$.ajax({
		"url":url,
		"type":"POST",
		"data":dateType,
		"dataType":"JSON",
		"beforeSend":function(){
		},
		"success":function(data){
			var list = data.list;
			alert(list.length+" 건 조회되었습니다.");
			if((list.length!=0)&&(list[0]!=null)){
				var msg = null;
				$("#tbody").empty();
				for(var i=0;i<list.length;i++){
					if(list[i].orderLevel==0){
						msg="입금 확인중";
					}else if(list[i].orderLevel==1){
						msg="입금 확인 완료";
					}else if(list[i].orderLevel==2){
						msg="제품 준비중";
					}else if(list[i].orderLevel==3){
						msg="배송 준비중";
					}else if(list[i].orderLevel==4){
						msg="배송 완료";
					}else if(list[i].orderLevel==5){
						msg="거래 완료";
					}else{
						msg="주문 취소";
					}
				$("#tbody").append("<tr height='40'><td class='line'>주문번호</td><td class='line' align='left' onClick='searchProduct(\""+list[i].orderProduct+"\");'>"+list[i].orderId+"</td>"
						+"<td class='line'>회원번호</td><td class='line' align='left'>"+list[i].orderMember+"</td>"
						+"<td class='line'>주문날짜</td><td class='line' align='left'>"+list[i].orderDate+"</td>"
						+"<td class='line'>주문단계</td></tr>"
						+"<tr height='40'><td class='line'>주소</td><td class='line' align='left' colspan='3'>"+list[i].orderAddress+"</td>"
						+"<td class='line'>우편번호</td><td class='line' align='left'>"+list[i].orderZipcode+"</td>"
						+"<td class='line' rowspan='2' onclick='orderLevelChange(\""+list[i].orderId+"\", \""+list[i].orderLevel+"\")'>"
						+msg+"</td></tr><tr height='40'><td class='line'>Message</td><td class='line' colspan='5'>"+list[i].orderMessage+"</td></tr>");
				}
			}else{
				$("#tbody").empty();
				$("#tbody").append("<tr><td colspan='7' class='line' style='text-align: center;'>조회정보가 없습니다.</td></tr>");
			}
		
		}
	});
}
function chkDate(sDate, eDate){
	var sString = sDate.split("-");
	var eString = eDate.split("-");
	if(sString<=eString){
		return true;
	}
	return false;
}
function submitFunction(url){
	$("#dialog_layer").dialog("close");
	if($("#orderLevelc").val()>='5'){
		var flag = window.confirm("거래 완료된 Order입니다.\n변경 하시겠습니까?");
		if(!flag)
			return;
	}
	ajax(url, "orderId="+$('#diaTextId').text()+"&orderLevel="+$("#orderLevelc").val());
}
function searchProduct(productId){
	window.open("/kostaWebS/product/getProductById.do?productId="+productId,"Product_Infomation","width=450,height=400");
}
function orderLevelChange(orderId, orderLevel){
	$("#diaTextId").text(orderId);
	btnCheck(orderLevel);
	if($("#dialog_layer").dialog()){
		$("#dialog_layer").dialog("destroy");
	}	
	$("#dialog_layer").dialog({
						"modal":true,
						"width":330,
						"height":150
					});
	
}
function btnCheck(orderLevel){
	$("#orderLevelc").val(orderLevel);
	if(orderLevel=='0'){
		$("#diaTextLevel").text("입금대기중");
		$("#btnArea").html("<button id='downLv'>주문취소</button> <button id='holdLv'>유 지</button> <button id='upLv'>입금확인</button>");
	}else if(orderLevel=='1'){
		$("#diaTextLevel").text("입금확인완료");
		$("#btnArea").html("<button id='downLv'>입금확인중</button> <button id='holdLv'>유 지</button> <button id='upLv'>재료준비중</button>");
	}else if(orderLevel=='2'){
		$("#diaTextLevel").text("재료준비중");
		$("#btnArea").html("<button id='downLv'>입금확인</button> <button id='holdLv'>유 지</button> <button id='upLv'>배송준비중</button>");
	}else if(orderLevel=='3'){
		$("#diaTextLevel").text("배송준비중");
		$("#btnArea").html("<button id='downLv'>재료준비중</button> <button id='holdLv'>유 지</button> <button id='upLv'>배송완료</button>");
	}else if(orderLevel=='4'){
		$("#diaTextLevel").text("배송완료");
		$("#btnArea").html("<button id='downLv'>배송준비중</button> <button id='holdLv'>유 지</button> <button id='upLv'>거래완료</button>");
	}else if(orderLevel=='5'){
		$("#diaTextLevel").text("거래완료");
		$("#btnArea").html("<button id='downLv'>배송완료</button> <button id='holdLv'>유 지</button> <button id='upLv'>주문취소</button>");
	}else {
		alert("거래 취소된 Order입니다.");
		$("#diaTextLevel").text("거래취소");
		$("#btnArea").html("<button id='holdLv'>유 지</button> <button id='upLv'>입금대기상태로</button>");
	}
}
</script>
	<img alt="" src="/kostaWebS/images/decoration/mypageLogo.jpg"><p>
 	<font color="#353535"><h2><i><u>Order Infomation</u></i></h2></font>
 	
 	<input type="text" id="orderId">
 	<button id="btnI">주문번호로 검색</button>
 	<button id="btnB" style="position: relative; left: 455px;">진행주문</button><p>
	<input type="text" name="sDate" id="sDate" class="datepicker" style="width:13%" readonly="readonly"> ~ 
	<input type="text" name="eDate" id="eDate" class="datepicker" style="width:13%" readonly="readonly">
	<button id="btnD">날자로 검색</button>
	<button id="btnA" style="position: relative; left: 450px;">전체주문</button><p>
	
	<table border="0" bordercolorlight="#D5D5D5" bordercolordark="white" width="800" cellspacing="0" class="topline">
		<thead>
		<thead>
		<tbody id="tbody">
			<tr height="40">
				<td colspan='7' class='line' style='text-align: center;'>
					조회정보가 없습니다.	
				</td>	
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
	<div id="dialog_layer" style="display:none" title="Order Level Change">
		선택한 Order는 '<span id="diaTextId"></span>' 입니다.<br>
		현재 단계는 '<span id="diaTextLevel"></span>' 입니다.<br>
		<span id="btnArea"></span><br>
	</div>
	
	<form id="submitForm" method="post">
		<input type="hidden" id="orderIdc">
		<input type="hidden" id="orderLevelc">
	</form>