<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script type="text/javascript" src = "/test/jquery.js"></script>
<script type="text/javascript">


$(document).ready(function(){

	$("#b1").click(function(){
	
	$("input:checked").each(function(i){
		var result = $(this).next().val();
		
		$("#div ul").append("<li>"+result+"</li>");
		
	});
	
	

	});
	
});

</script>

</head>
<body>
수학
<input type = "checkbox"  id = "chk" value="수학"/>
과학
<input type = "checkbox"  id = "chk" value="과학"/>
영어
<input type = "checkbox"  id = "chk" value="영어"/>

<button id="b1">선택사항 출력</button>

<div id = "div" ><ul></ul></div>
</body>
</html>