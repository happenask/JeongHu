<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
	   if(opener.joinForm.id.value!=""){
		   var txt = opener.joinForm.id.value;
		   $("#id").val(txt);
		   
		   $.ajax({
				"url":"/kostaWebS/idCheck.do",
				"type":"POST",
				"data":"id="+$("#id").val(),
				"dataType":"JSON",
				"beforeSend":function(){
				},
				"success":function(data){
					var flag = data.flag;
					if(flag){
						$("#d1").html("해당 아이디는 이미 사용중입니다.");
					}else{
						$("#d1").html("사용 가능한 ID입니다.");
					}
				}
			
			});	
	   }
	   
	   $("#btn").click(function(){
		   $.ajax({
				"url":"/kostaWebS/idCheck.do",
				"type":"POST",
				"data":"id="+$("#id").val(),
				"dataType":"JSON",
				"beforeSend":function(){
				},
				"success":function(data){
					var flag = data.flag;
					if(flag){
						$("#d1").html("해당 아이디는 이미 사용중입니다.");
					}else{
						$("#d1").html("사용 가능한 ID입니다.");
					}
				}
			
			});	
		   
	   });
	   
	  $("#btn2").click(function(){
			
		  var txt = $("#id").val();
		  opener.joinForm.id.value= txt;
		  
	   	var flag = window.confirm("창을 닫겠습니까?");
		if(flag){
			window.close(flag);
		}
	  });
	});
</script>
</head>
<div style="background-color:#B2CCFF;width:400px;height:80px;padding-top:50px">
<h2><u>아이디 중복 체크</u></h2>
</div>
<p>
<body>
	<font size ="2" color="#FF5E00" style="고딕체">아이디는 영문(소문자),숫자로 4-16자 이내로 입력해 주세요.</font><p>
	<input type = "text" name = "id" maxlength="10" id="id"> <button id="btn">중복확인</button><p>
	
	<div style="color:red;font-size:7 " id = "d1"></div>  <button id="btn2" style="background-color:yellow ">닫기</button>
</body>
</html>