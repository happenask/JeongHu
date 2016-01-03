<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h2>검색한 거래처 : ${sessionScope.supplier.name}</h2>
<table border='1' cellspacing="0" width="600px" cellpadding="5px"> 
    <tr>
        <th width="200px" align="left">거래처 이름 : </th>
        <td>${sessionScope.supplier.name }</td>
    </tr>
    <tr>
        <th  align="left">거래처 주소 : </th>
        <td>${sessionScope.supplier.address}</td>
    </tr>
    <tr>
        <th align="left">거래처 전화번호 : </th>
        <td>${sessionScope.supplier.tel}</td>
    </tr>
    <tr>
        <th align="left">메모</th>
        <td>${sessionScope.supplier.message}</td>
    </tr>
    <tr>
        <td colspan="2" align="center">
            <a href="/kostaWebS/supplier/supplierModifyForm.do">거래처 수정</a>
             <a href="/kostaWebS/supplier/supplierDeleteSuccess.do?name=${sessionScope.supplier.name }" style="background-color: buttonhighlight;">공급처 삭제</a>
        </td>
</table>
