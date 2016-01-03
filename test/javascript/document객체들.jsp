<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>


<script type="text/javascript">

	//document 객체의 노드 생성하기
	window.onload = function(){
		
		var header = document.createElement('h1');
		var text   = document.createTextNode("Hello Dom");
		
		
		header.appendChild(text);
		document.body.appendChild(header);
	//텍스트 노드를 갖지 않는 노드 만들기
		var img = document.createElement('img');
	
		document.body.appendChild(img);
	};
	
	
</script>

</head>
<body>

</body>
</html>