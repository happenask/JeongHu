<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javascript" src="/force/jquery.js"></script>
<script type="text/javascript" src="/force/jquery-ui.js"></script>
<script type="text/javascript" src="/force/jsapi.js"></script>
<link rel="stylesheet" type="text/css" href="/force/jquery-ui.css">

<style type="text/css">
	.line{border-top:1px solid #D5D5D5; font-size:10pt; color:#8C8C8C;font-style:normal;padding-left:50px; }
  .table1{border-top:2px solid #D5D5D5;}
	.sumLine{font-weight:bold;color: black;}
	.nameline{border-top:1px solid #D5D5D5; font-size:10pt; color:#353535;font-style:normal;padding-left:50px; }
</style>
<script type="text/javascript">
	$(document).ready(function(){

		
			$("#foodDate").datepicker({"dateFormat":"yy/mm/dd","showButtonPanel":"true","maxDate":"0"});

	});
		
</script>
</head>
<body>
	<div style="background-color: #5D5D5D;width:800px; font-weight:bold;color:#FF0000;">
	<form action="/force/totalCalculate.do">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	 DATE: <input type ="text" name="foodDate" id="foodDate" style="background-color:#FAED7D;" readonly="readonly"/>
	<input type="submit" value="전송">
	
	</form>
	</div>
	
	<table class="table1" border="0" bordercolorlight="#D5D5D5" bordercolordark="white" cellspacing="0" width="800" height="500" >
		<thead>
			<th>FOOD</th>
			<th>PRICE</th>
			<th>TABLE</th>
			<th>COUNT</th>
			<th>DATE</th>
		</thead>
		<tbody class="tbody">
			<c:forEach var="list" items="${requestScope.list }">
					<tr>
						<td class="nameline">${list.name }</td>
						<td class="line">${list.price }</td>
						<td class="line">${list.tableNum }</td>
						<td class="line" align="right">${list.foodNum }</td>
						<td class="line">${list.foodDate }</td>
					</tr>				
			</c:forEach>
		</tbody>
		<tfoot>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td class="sumLine">총합계</td>
				<td class="sumLine">${requestScope.sum }</td>
			</tr>
		</tfoot>
	</table>
</body>
</html>