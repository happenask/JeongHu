<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#btnT").on("click", function(){
		$("#modelNum").val("모델 번호를 입력하세요");
		if($("#modelType").val()=="00"){
			alert("조회 정보가 잘못되었습니다");
			selectRemover();
		}else{
			ajax('/kostaWebS/model/modelList.do', "modelType="+$("#modelType").val());
		}
	});
	$("#btnN").on("click", function(){
		selectRemover();
		var modelNum = document.getElementById("modelNum");
		if(isNaN(modelNum.value)){
			alert("모델번호를 \n숫자형태만 입력 하세요.");
			modelNum.value = "모델 번호를 입력하세요";
		}else{
			ajax('/kostaWebS/model/modelList.do', "modelNum="+$("#modelNum").val());
		}
	});
		
	$("#modelNum").on("click", function(){
		if($("#modelNum").val()=="모델 번호를 입력하세요"){
			$("#modelNum").val("");
		}
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
			if((list.length!=0)&&(list[0]!=null)){
				$("#tbody").empty();
				for(var i=0;i<list.length;i++){
					if(list[i].modelType==1){
						var str = "P.P&O.T";
					}else if(list[i].modelType==2){
						var str = "Sandals";
					}else if(list[i].modelType==3){
						var str = "F.S";
					}else{
						var str = "Boots";
					}
				$("#tbody").append("<tr height='25'><td class='line'>"+list[i].modelNum+"</td><td class='line'>"+list[i].modelName+"</td><td class='line'>"+list[i].modelHeel
						+"</td><td class='line'>"+list[i].modelLeather+"</td><td class='line'>"+list[i].modelPrice+"</td><td class='line'>"+str
						+"</td><td class='line' id='delete' onclick='deleteModel("+list[i].modelNum+")'>category_"+list[i].modelType+"_"+list[i].modelNum+".jpg</td></tr>");
				}
			}else{
				alert("조회정보가 없습니다.");
				$("#tbody").empty();
				$("#tbody").append("<tr><td colspan='7' class='line' style='text-align: center;'>조회정보가 없습니다.</td></tr>");
			}
		
		}
	});
}
function selectRemover(){
	var sel = document.getElementById("modelType");
	sel.selectedIndex = 0;
}
function deleteModel(modelNum){
	var flag = window.confirm(modelNum+"번 모델을\n삭제 하시겠습니까?");
	if(flag){
		$("#mNum").val(modelNum);
		$("#submitForm").submit();
	}
}
</script>
	<img alt="" src="/kostaWebS/images/decoration/mypageLogo.jpg"><p>
 	<font color="#353535"><h2><i><u>Model List</u></i></h2></font>
 	
 	<select id="modelType">
 		<option value="00">모델 타입으로 조회</option>
 		<option value="00">==================</option>
 		<option value="01">PUMPS&OPENTOE</option>
 		<option value="02">SANDALS</option>
 		<option value="03">FLAT SHOES</option>
 		<option value="04">BOOTS</option>
 	</select>
 	<input type="button" id="btnT" value="조회"><p>
 	<input type="text" id="modelNum" value="모델 번호를 입력하세요">
 	<input type="button" id="btnN" value="조회">
	<table border="0" bordercolorlight="#D5D5D5" bordercolordark="white" width="800" cellspacing="0" class="topline">
		<thead>
			<tr height="50">
				<td class="line" width="80">M-번호</td>
				<td class="line" width="190">M-이름</td>
				<td class="line" width="95">M-Heel</td>
				<td class="line" width="95">M-Leather</td>
				<td class="line" width="80">M-가격</td>
				<td class="line" width="90">M-Type</td>
				<td class="line" width="150">Image-name</td>
			</tr>
		<thead>
		<tbody id="tbody">
			<core:forEach items="${requestScope.list}" var="model">
				<tr height="25">
					<td class="line">${model.modelNum }</td>
					<td class="line">${model.modelName }</td>
					<td class="line">${model.modelHeel }</td>
					<td class="line">${model.modelLeather }</td>
					<td class="line">${model.modelPrice }</td>
					<td class="line">
						<core:if test="${model.modelType == 1}">P.P&O.T</core:if>
						<core:if test="${model.modelType == 2}">Sandals</core:if>
						<core:if test="${model.modelType == 3}">F.S</core:if>
						<core:if test="${model.modelType == 4}">Boots</core:if>
					</td>
					<td class="line">
						<p id="delete" onclick="deleteModel(${model.modelNum })">category_${model.modelType }_${model.modelNum }.jpg</p>
					</td>
				</tr>
			</core:forEach>
		</tbody>
		<tfoot>
				<tr>
					<td colspan="7" style='text-align: center;'>
							<a href = "/kostaWebS/mypageForm.do" ><button>마이 페이지로</button></a>
					</td>	
				</tr>
				
		</tfoot>
	</table>
	<form id="submitForm" action="/kostaWebS/model/deleteModel.do" method="post">
		<input type="hidden" id="mNum" name="modelNum">
	</form>