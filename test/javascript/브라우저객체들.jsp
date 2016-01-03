<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script type="text/javascript">
//브라우저 객체 모델 DOM
/* 
					window 객체
	---------------------------------------------------
    |          |         |         |         |
   location   history   navigator  screen    document */
   
   // window 객체 window 객체는 무지 하게 많다.
   //1. window 객체의 타이머 메서드
   //setTimeout(function,millisecond) 일정 시간 후에 함수를 한번 실행한다.
   //setInterval(function,millisecond) 일정시간 마다 함수를 반복해서 실행한다.
   //clearTimeout(id);
   //clearInterval(id);
   
     var time = function(){
	document.body.innerHTML +="<p>"+new Date()+"</p>";
   };
   
   var id = setInterval(time,100);


	setTimeout(function(){
	    clearInterval(id);
	
	},1000);
	   
	//2.screen 객체 (브라우저의 화면이 아니라 운영체제 화면의 속성을 가지는 객체이다.브라우저마다 다를 수 있다.)
	
	var child = window.open('','','width=300,height=200');
	var width = screen.width;
	var height = screen.height;
	
	child.moveTo(0,0);
	child.resizeTo(width,height);
	
	//2초마다 함수를 실행한다.
	setInterval(function(){
	    child.resizeBy(-20,-20);
	    child.moveBy(10,10);
	
	
	},2000);
	
	//3.location 객체 속성(href -문서의 URL주소 
		/* 				 host-호스트이름과 포트 번호 - localhost:30763
						 hostname - localhost
						 port - 30763
						 pathname - 디렉토리 경로 -/location.html
						 hash - 앵커 이름(#~) #beta
						 search - 요청매개변수 - ?param = 10
						 protocol - 프로토콜 종류 - http
						)
				 메서드 (
						 assign(link) 현재위치를 이둉합니다.
						 reload()     새로고칩니다.
						 replace(link) 현재 위치를 이동합니다.(assign과의 차이점은 뒤로가기 사용 할 수 없음)
						 ) 
		*/
		//페이지 이동 4가지 방법
		location = "http://www.naver.com";
		
		location.assign("http://www.naver.com");
		location.replace("http://www.naver.com");
		
		
		//4.navigator 객체 속성(appCodeName,appName,appVersion,appVersion,platform,userAgent)
		// 
		
		
		

		
   </script>
</head>
<body>

	<div></div>
</html>