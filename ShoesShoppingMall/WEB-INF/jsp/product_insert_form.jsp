<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){ 
	insertComma('${requestScope.modelTO.modelPrice }');
});
function insertComma(number){
	 var txt = document.getElementById("price");
	 var num = numberFormat(number+"");
	 txt.value = num;
}
function removeComma(){
	 var txt = document.getElementById("price");
	 var num = unNumberFormat(txt.value);
	 txt.value = parseInt(num);
}
function next(){
	removeComma();
	return chkSize();
}
function numberFormat(num) {
	 var pattern = /(-?[0-9]+)([0-9]{3})/;
	 while(pattern.test(num)) {
	  num = num.replace(pattern,"$1,$2");
	 }
	 return num;
}
function unNumberFormat(num) {
	 return (num.replace(/\,/g,""));
	}

function money(){
	var p1 = parseInt($("#HEEL").attr("price"));
	var p2 = parseInt($("#LEATHER").attr("price"));;
	var p3 = 0;
	var p4 = 0;
	var p5 = 0;
	var acc1 = document.getElementById("ACC1");
	var acc2 = document.getElementById("ACC2");
	if(!(acc1.selectedIndex==0||acc1.selectedIndex==1)){
		p3 = parseInt($(acc1.options[acc1.selectedIndex]).text());
	};
	if(!(acc2.selectedIndex==0||acc2.selectedIndex==1)){
		p4 = parseInt($(acc2.options[acc2.selectedIndex]).text());
	}
	p5 = parseInt((p1+p2+p3+p4)/5);
	result = (p1+p2+p3+p4+p5);
	insertComma(result);
};

function chkSize(){
	var size = document.getElementById("size");
	if(isNaN(size.options[size.selectedIndex].text)){
		alert("발 size를 입력해 주세요. \n예)230 또는 240.5");
		size.selectedIndex = 0;
		return false;
	}
};
</script>
	<core:set var="modelType" scope="request"value="${requestScope.modelTO.modelType }"/>
	<core:set var="modelNum" scope="request" value="${requestScope.modelTO.modelNum }"/>
	<core:set var="modelPrice" scope="request" value="${requestScope.modelTO.modelPrice }"/>
	<core:set var="modelName" scope="request" value="${requestScope.modelTO.modelName }"/>
	<core:set var="modelHeel" scope="request" value="${requestScope.modelTO.modelHeel }"/>
	<core:set var="modelLeather" scope="request" value="${requestScope.modelTO.modelLeather }"/>


 	<font color="#353535"><h2><i><u>Custom Making</u></i></h2></font>
 	<div style="margin-left:250px;margin-top:100px;">
 		<img alt="" src="/kostaWebS/images/products/category_${modelType }_${modelNum }.jpg" width="250" height="250"/><p>
	 	
 	</div>
	<div style="border-bottom:1px solid #000000;border-bottom-width:1px;font-size: 10pt">
		<strong>${requestScope.modelTO.modelName}</strong>
	</div>	 
	<p>	
	<font color="#000000"><strong>신발 정보 입력</strong></font>



	<form id="product" action="/kostaWebS/product/productMake.do" method="post" onSubmit="return next();">


	<table  border="0"  bordercolordark="dark" cellspacing="0" width="600" height="350" class="topline">
		<thead></thead>


		<tbody>
		
			<tr>
				<th>PRICE</th>
				<td align="right"><input type="text" name="price" id="price" readonly="readonly" value="${modelPrice }" style="text-align: right;border:0;color: #FF5E00" >
					<font color="#FF5E00">원</font>
					<input type="hidden" name="price2" id="price2">
				</td>
			</tr>
		
			<tr>
				<th>HEEL</th>
				<td align="right"><core:forEach items="${requestScope.heels}" var="heel">
									<core:if test="${heel.materialId == modelHeel }">
										<input type="text" id="HEEL" value="${heel.name } - ${heel.spec }" price="${heel.price }" readonly="readonly">
										<input type="hidden" name="heel" value="${heel.materialId }">
									</core:if>
								</core:forEach>
				</td>
			</tr>
			<tr>
				<th>LEATHER</th>
				<td align="right"><core:forEach items="${requestScope.leathers}" var="leather">
									<core:if test="${leather.materialId == modelLeather }">
										<input type="text" id="LEATHER" value="${leather.name } - ${leather.spec }" price="${leather.price }" readonly="readonly">
										<input type="hidden" name="leather" value="${leather.materialId }">
									</core:if>
								</core:forEach>
				</td>
			</tr>
			<tr>
				<th>ACC1</th>
				<td align="right"><select id="ACC1" onchange="money()" name="acc1">
									<option label="ACC">0</option>
									<option label="----------------------------------------">0</option>
									<core:forEach items="${requestScope.accs}" var="acc1">
										<option value="${acc1.materialId }" label="${acc1.name } - ${acc1.spec }     : (${acc1.price})원" >${acc1.price }</option>
									</core:forEach>
								</select>
				</td>
			</tr>
			<tr>
				<th>ACC2</th>
				<td align="right"><select id="ACC2" onchange="money()" name="acc2">
									<option label="ACC">0</option>
									<option label="----------------------------------------">0</option>
									<core:forEach items="${requestScope.accs}" var="acc2">
										<option value="${acc2.materialId }" label="${acc2.name } - ${acc2.spec }     : (${acc2.price})원" >${acc2.price }</option>
									</core:forEach>
								</select>
				</td>
			</tr>
			
			<tr>
				<th>SIZE</th>
				<td align="right">
				<select id="size" name="size" onchange="chkSize()">
						<option label="사이즈선택">none</option>
						<option label="----------------------------------------">none</option>
						<option>240</option>
						<option>245</option>
						<option>250</option>
						<option>255</option>
				</select>
				</td>
			</tr>
			<tr>
				<th>제품 요청사항</th>
				<td><input type="text" name="message" id="msg" size="60"></td>
			</tr>
	
		</tbody>
		<tfoot>
				<tr>
					<td colspan="3">
							<div style="border:1px solid black;bortext-decoration:none ">
							
							<a href = "/kostaWebS/mainPage.do"><img alt="주문 취소" src="/kostaWebS/images/decoration/goHome.jpg" border="0"></a>
							<input type="image" src="/kostaWebS/images/decoration/nextOrder.jpg" >
							<a href = "/kostaWebS/mainPage.do"><img alt="장바구니" src="/kostaWebS/images/decoration/productCart.jpg" border="0"></a>
							
							</div>
					</td>	
				</tr>
				<tr>		
				</tr>
		</tfoot>
	</table>
	</form>
	
