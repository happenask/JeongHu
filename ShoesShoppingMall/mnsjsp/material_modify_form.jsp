<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
$(document).ready(function(){
	$("#submit").on("click",function(){
		
		if($("#type").val()=="none"){
			alert("type를 입력하세요.");
			$("#type").focus();
			return false;
		}
		if($("#name").val()==""){
			alert("재료이름을 입력하세요.");
			$("#name").focus();
			return false;
		}
		if($("#spec").val()==""){
			alert("재료스펙을 입력하세요.");
			$("#spec").focus();
			return false;
		}
		if($("#supplier").val()=="none"){
			alert("거래처를 입력하세요.");
			$("#supplier").focus();
			return false;
		}
		if($("#quantity").val()==""){
			alert("수량를 입력하세요.");
			$("#quantity").focus();
			return false;
		}
		if($("#price").val()==""){
			alert("가격을 입력하세요.");
			$("#price").focus();
			return false;
		}
		
	});
	
	if("${requestScope.error_message}"){
		
		alert("${requestScope.error_message}");
	}
	

});
</script>
<form name="mr" action="/kostaWebS/material/materialModifySuccess.do" method="post" id="mr">
<h2>재료 수정</h2><br>
    <table width='500'>
        <tr>
            <td width="150">재료 ID</td>
            <td><input type="text" name="materialId" id="materialId" value="${sessionScope.material.materialId }" readonly></td>
        </tr>
        <tr>
            <td>재료 카테고리</td>
            <td>
                <select name="type" id="type">
                    <option value="none">타입 선택</option>
                    <option value="none">============</option>
                    <option value="LEATHER">LEATHER</option>
                    <option value="HEEL">HEEL</option>
                    <option value="ACC">ACC</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>재료 이름</td>
            <td>
                <input type="text" name="name" id="name">
            </td>
        </tr>
        <tr>
            <td>재료 스펙</td>
            <td>
                <input type="text" name="spec" id="spec">
            </td>
        </tr>
        <tr>
            <td>재료 거래처</td>
            <td>
                <select name="supplier" id="supplier">
                    <option value="none">재료 거래처</option>
                    <option value="none">===============</option>
                    <c:forEach items="${requestScope.supplier }" var="supplier">
                       <option  value="${supplier.name }">${supplier.name }</option>
                    </c:forEach>
                </select>
            </td>
        </tr>
        <tr>
            <td>재료 수량</td>
            <td>
                <input type="text" name="quantity" id="quantity">
            </td>
        </tr>
        <tr>
            <td>재료 가격</td>
            <td>
                <input type="text" name="price" id="price">
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" id="submit" value="등록" style="background-color: buttonhighlight; ">
                <input type="reset" value="다시작성" style="background-color: buttonhighlight;">
            </td>
        </tr>
</table>
</form>