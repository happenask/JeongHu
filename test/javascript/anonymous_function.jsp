<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>


<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script type="text/javascript">

(function(){
	var foo = "Hello";
	var bar = " World";
	
	function baz(){
		return foo+''+bar;
	}
	
	window.baz = baz;
})();

	
	console.log(baz());
 	console.log(foo); // exception
 	console.log(bar); //exception
 	
 	
 	
 	
 	(function(a){
 		 console.log(a===window); //return true
 		 })(window);
 	
 	
 	(function(mark, loves, drinking, coffee){
 		  mark.open('http://www.google.com'); //window
 		  loves.getElementById('menu'); //document
 		  drinking('#menu').hide(); //jQuery
 		  var foo;
 		  console.log(foo === coffee); //undefined
 		})(window, document, jQuery);
</script>
</head>
<body>
</body>
</html>