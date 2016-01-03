<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Product Infomation</title>
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#close").on("click", function(){
		window.close();
	});
});
</script>
<style type="text/css">
  .line{border-top:1px solid #D5D5D5; font-size:8pt; color:#8C8C8C;font-style:normal;padding-left:50px; },
  .topline{border-top:2px solid #D5D5D5;}

</style>
</head>
<body>
 	<font color="#353535"><h2><i><u>Order Infomation</u></i></h2></font>
 	<p></p>
	<table border="0" bordercolorlight="#D5D5D5" bordercolordark="white" cellspacing="0" width="450" height="300" class="topline">
		<thead></thead>
		<tbody>
			<tr>
				<th class="line" width="120">Heel 정보</th>
				<td class="line">${requestScope.heel.name } - ${requestScope.heel.spec }</td>
			</tr>
			<tr>
				<th class="line" width="120">Leather 정보</th>
				<td class="line">${requestScope.leather.name } - ${requestScope.leather.spec }</td>
			</tr>
			<tr>
				<th class="line" width="120">Acce 정보1</th>
				<td class="line">${requestScope.acc1.name } - ${requestScope.acc1.spec }</td>
			</tr>
			<tr>
				<th class="line" width="120">Acce 정보2</th>
				<td class="line">${requestScope.acc2.name } - ${requestScope.acc2.spec }</td>
			</tr>
			<tr>
				<th class="line" width="120">Size</th>
				<td class="line">${requestScope.pto.size } mm</td>
			</tr>
			<tr>
				<th class="line" width="120">가격</th>
				<td class="line">${requestScope.pto.price } 원</td>
			</tr>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="2" align="center">
					<button id="close">닫기</button>
				</td>	
			</tr>
		</tfoot>
	</table>
</body>
</html>