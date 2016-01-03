<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h2>재료 등록 완료</h2><br>
    <table width='500'>
        <tr>
            <td width="150">재료 ID</td>
            <td>
               ${sessionScope.material.materialId}
            </td>
        </tr>
        <tr>
            <td>재료 카테고리</td>
            <td>
                ${sessionScope.material.type}
            </td>
        </tr>
        <tr>
            <td>재료 이름</td>
            <td>
                ${sessionScope.material.name}
            </td>
        </tr>
        <tr>
            <td>재료 스펙</td>
            <td>
                ${sessionScope.material.spec}
            </td>
        </tr>
        <tr>
            <td>재료 거래처</td>
            <td>${sessionScope.material.supplier}</td>
        </tr>
        <tr>
            <td>재료 수량</td>
            <td>
                ${sessionScope.material.quantity}
            </td>
        </tr>
        <tr>
            <td>재료 가격</td>
            <td>
                ${sessionScope.material.price}
            </td>
        </tr>
</table>
