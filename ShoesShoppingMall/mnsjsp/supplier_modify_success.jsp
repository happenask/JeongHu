<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<h2>거래처 수정 완료</h2>
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
</table>