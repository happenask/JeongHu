<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <script type="text/javascript">
$(document).ready(function(){
	$("#submit").on("click",function(){
		if($("#name").val()==""){
			alert("거래처 이름을 입력하세요.");
			$("#name").focus();
			return false;
		}
	});
	if("${requestScope.error_message}"){
		alert("${requestScope.error_message}");
	}
	$("#total").on("click",function(){
		$.ajax({
			type : "POST",
			url  : "/kostaWebS/supplier/totalSupplier.do",
			dataType : "JSON",
			success : function(jsonData){
				var total = jsonData.totalList;
				$("#tbody").empty();
				for ( var i = 0; i < total.length; i++) {
					$("#tbody").append("<tr><td>"+total[i].name+"</td><td>"+total[i].address+"</td><td>"+total[i].tel+"</td><td>"+total[i].message);		
				}
			}
		});
	});
	
	
});
</script>
<form name="sr" action="/kostaWebS/supplier/supplierSearchSuccess.do">
공급처이름 : <input type="text" name="name" id="name" style="background-color: buttonhighlight";>
<input type="submit" id="submit" value="검색" style="background-color: buttonhighlight";>&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" id="total" value="TOTAL SEARCH" style="background-color: white;font-weight: bold;">

<table border='1' cellspacing="0" width="600px" cellpadding="5px"> 
    <thead>
        <tr>
            <td>이름</td>
            <td>주소</td>
            <td>전화번호</td>
            <td>메모</td>
        </tr>
    </thead>
    <tbody id ="tbody">  
    </tbody>   
</table>
