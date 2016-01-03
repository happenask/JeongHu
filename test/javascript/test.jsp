<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html5/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="/test/jquery.js"></script>
<style type="text/css">
input.invalid {background:#fa0;}
input.valid {background:#afa;}
</style>
</head>

<body>
<script type="text/javascript">

var ask = window.location.search;

var ask2 = window.decodeURIComponent(ask);	

//alert(document.cookie);
$(document).ready(function(){
	
$("#aaa").click(function(event){
	
	
	
	$(this).val(event.target.disabled );
	alert(event.target);
	alert(event.type);
	alert(event.timeStamp);
	operate2("add",10,10);
});
	
var operators = {
	add: function(x,y){return x+y;},
	subtract: function(x,y){return x-y;}
};
function operate2(name,op1,op2)
{
//	if(typeof operators[name]=="function"){
		var result =  operators[name](10,10);
		
		alert("aaa"+result);
//	}	
}
});

</script>
<form>

<input type = "text" id = "" value=""  required/>
<input type = "submit" id = "aaa" value="aaaa"  />
</form>
<button >링크</button>
<a href = "pop.jsp" target = "mainwind">링크2</a>


</body>
</html>
