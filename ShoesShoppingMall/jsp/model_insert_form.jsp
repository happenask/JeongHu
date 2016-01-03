<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
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
	return chkName();
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
	var p1 = 0;
	var p2 = 0;
	var heel = document.getElementById("HEEL");
	var leather = document.getElementById("LEATHER");
	if(!(heel.selectedIndex==0||heel.selectedIndex==1)){
		p1 = parseInt($(heel.options[heel.selectedIndex]).text());
	};
	if(!(leather.selectedIndex==0||leather.selectedIndex==1)){
		p2 = parseInt($(leather.options[leather.selectedIndex]).text());
	};
	if(p1!=0){
		p1 = (p1+(p1/100)*15);
	}
	if(p2!=0){
		p2 = (p2+(p2/100)*15);
	}
	result = p1+p2;
	insertComma(result);
};

function chkName(){
	var name = document.getElementById("name");
	var str = name.value;
	if(str==""||str==" "){
		alert("제품의 이름을 입력 하세요.");
		return false;
	}
	return true;
};
</script>
 	<font color="#353535"><h2><i><u>Model Infomation</u></i></h2></font>
	<font color="#8C8C8C"><h3>모델 정보 입력</h3></font>
	<form id="product" action="/kostaWebS/model/insertModel.do" method="post" onSubmit="next();">
	<table border="0" bordercolorlight="#D5D5D5" bordercolordark="white" cellspacing="0" width="800" height="350" class="topline">
		<thead></thead>
		<tbody>
			<tr>
				<th class="line">HEEL</th>
				<td class="line"><select id="HEEL" onchange="money();" name="modelHeel">
									<option label="HEEL">0</option>
									<option label="----------------------------------------">0</option>
									<core:forEach items="${requestScope.heels}" var="heel">
										<option value="${heel.materialId }" label="${heel.name } - ${heel.spec }     : (${heel.price})원" >${heel.price }</option>
									</core:forEach>
								</select>
				</td>
			</tr>
			<tr>
				<th class="line">LEATHER</th>
				<td class="line"><select id="LEATHER" onchange="money()" name="modelLeather">
									<option label="LEATHER">0</option>
									<option label="----------------------------------------">0</option>
									<core:forEach items="${requestScope.leathers}" var="leather">
										<option value="${leather.materialId }" label="${leather.name } - ${leather.spec }     : (${leather.price})원" >${leather.price }</option>
									</core:forEach>
								</select>
				</td>
			</tr>
			<tr>
				<th class="line">PRICE</th>
				<td class="line"><input type="text" name="modelPrice" id="price" readonly="readonly" value="0" style="text-align: right;" >원
					<input type="hidden" name="price2" id="price2">
				</td>
			</tr>
			<tr>
				<th class="line">name</th>
				<td class="line"><input type="text" name="modelName" id="name" onblur="chkName()"></td>
			</tr>
			<tr>
				<th class="line">Type</th>
				<td class="line">
					<select name="modelType" id="modelType">
						<option value="00">ModelType</option>
						<option value="00">=================</option>
						<option value="01"></option>
						<option value="02"></option>
						<option value="03"></option>
						<option value="04"></option>
					</select>
				</td>
			</tr>
		</tbody>
		<tfoot>
				<tr>
					<td colspan="3">
							<span style="padding-left:250px;text-decoration:none ">
							<a href = "/kostaWebS/mainPage.do"><img alt="주문 취소" src="/kostaWebS/images/decoration/goHome.jpg" border="0"></a>
							<input type="image" src="/kostaWebS/images/decoration/nextOrder.jpg" >
							</span>
					</td>	
				</tr>
				<tr>		
				</tr>
		</tfoot>
	</table>
	</form>
