<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script type="text/javascript">


//Number 객체 
	var n  = 273.5210332;
	
	alert(n.toFixed(1));
	alert(n.toFixed(4));
	
//String 객체 


//Array 객체
 
 	var array = [52,273,103,32];
 	array.sort(); //자동정렬
 	
 	alert(array);


	array.sort(function(left,right){
	    return left - right;
	});

    alert(array); //숫자 오름 차순 
    
    array.sort(function(left,right){
	    return left - right;
	});

    alert(array); //숫자 내림 차순
 
//ECMAScript5 Array 객체


    
    
    
    
//Date 객체 (D-Day 구하기)
    
    var now = new Date();
    
	var before = new Date('jun 4,2014');
	
	var interval = now.getTime()-before.getTime();
	
	interval 	=  Math.floor(interval/(1000*60*60*24));
	
	
	alert(interval);
	
	
	interval    = before.getDate()-now.getDate();
	
	alert(interval);
    
//Json 객체와 Date객체


var object={
	name:"안정후",
	age: "32",
	sex: "man"
	
			
};

var json = JSON.stringfy(object);
JSON.parse(json);


//Audio 객체
 var audio = new Audio('music.mp3');
 var audio2 = new Audio();
 
 audio2.src = 'music.mp3';
 audio2.volume = '10';
 audio2.currentTime ='10';
 
 audio2.play();
 audio2.pause();

 



</script>
</head>
<body>

</body>
</html>