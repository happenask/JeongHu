<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h2>검색한 재료ID : ${sessionScope.material.materialId}</h2>
<table border='1' cellspacing="0" width="600px" cellpadding="5px"> 
    <tr>
        <th width="200px" align="left">재료 타입 : </th>
        <td>${sessionScope.material.type }</td>
    </tr>
    <tr>
        <th  align="left">재료 이름 : </th>
        <td>${sessionScope.material.name}</td>
    </tr>
    <tr>
        <th align="left">재료 스펙 : </th>
        <td>${sessionScope.material.spec}</td>
    </tr>
    <tr>
        <th align="left">재료 거래처 : </th>
        <td>${sessionScope.material.supplier}</td>   
    </tr>
    <tr>
        <th align="left">재료 수량 : </th>
        <td>${sessionScope.material.quantity}</td>
    </tr>
    <tr>
        <th align="left">재료 가격 : </th>
        <td>${sessionScope.material.price}</td>
    </tr>
    <tr>
        <td colspan="2" align="center">
            <a href="/kostaWebS/material/materialModifyForm.do" style="background-color: buttonhighlight;">재료 수정</a>
            <a href="/kostaWebS/material/materialDeleteSuccess.do?materialId=${sessionScope.material.materialId }" style="background-color: buttonhighlight;">재료 삭제</a>    
        </td>
</table>


    
  




