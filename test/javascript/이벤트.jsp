<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script type="text/javascript">

	 window.onload = function(){
		 
		

		 var aaa =function(e){
			 var count = 0;
		     alert(count++);
		     var event = e;
		     
		     for(var key in event){
		         document.body.innerHTML += '<p>'+'keys:'+event[key]+'</p>';
		     }
		 };



		 function aaa2(e){
			 var count = 0;
		     alert(count++);
		     var event = e;
		     
		     for(var key in event){
		         document.body.innerHTML += '<p>'+'keys:'+event[key]+'</p>';
		     }
		 }
		 
		 var id = setInterval(aaa(this.event),1000);
		 
		 setTimeout(function(){
			
			 clearInterval(id);
		 },3000);
		 
	 };
	
	

</script>
</head>
<body>
<button id = 'b1' name = 'b1' value = 'button' onclick="alert('sfaf');aaa(this.event);">버튼</button>
</body>
</html>