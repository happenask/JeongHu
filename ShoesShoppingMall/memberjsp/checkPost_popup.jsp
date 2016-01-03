<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
	
function showAddress(zipcode,address){
	//opener : 팝업을 띄운 window,document: HTML문서
	opener.joinForm.zipcode.value = zipcode;
	opener.joinForm.address1.value = address;
	
	
	var flag = window.confirm("창을 닫겠습니까?");
	if(flag){
		window.close(flag);
	}
}
	
$(document).ready(function(){
	
	$("#d1").html("아래의 검색 결과중 해당되는 주소를 클릭하세요<p>").css({"color":"#8C8C8C","font-size":"9pt"});
	
		$("#search").click(function(){
			
		   $.ajax({
				"url":"/kostaWebS/postCheck.do",
				"type":"POST",
				"data":"dong="+$("#dong").val(),
				"dataType":"JSON",
				"beforeSend":function(){
				},
				"success":function(data){
					var list = data.list;
					if(list.length!=0){
						$("#d1").empty();
						for(var i=0;i<list.length;i++){
						$("#d1").append("<a href =\"javascript:showAddress('"+list[i].zipcode+"','"+list[i].sido+list[i].gugun+list[i].dong+"')\">"+list[i].zipcode+list[i].sido+list[i].gugun+list[i].dong+list[i].bunji+list[i].seq+"</a><p>");
						$("a").css({
							"font-style":"none",
							"font-size":"10pt",
							"text-decoration":"none",
							"color":"#212121"
						});
						}
					}else{
						$("#d1").html("검색된 결과 값이 없습니다.");
					}
				}
			
			});	
	   
		});	   
	
		
		$("#cancel").click(function(){
			window.close();
		});
	   
	});

</script>
</head>
<body>

<div style="border-bottom-width: 10px;border:#747474 solid 3px;border-bottom:#747474 solid 20px; width:auto;height:auto;padding-left:10px">
	<p>
	<div  style="padding-left:300px;">
	<img alt="" src="/kostaWebS/images/decoration/postCancel.jpg" id="cancel">
	</div>
	<b>우편번호 찾기</b>
	<div style="border-top:#8C8C8C solid 3px;font-size:9pt;color:#8C8C8C;padding-top:10px;width:400px;">
		찾고자하는 지역의 동/읍/면/리/건물명을 입력하세요.<br>
		서울시 강남구 삼성동이라면 <font color="blue">"삼성"</font> 또는 <font color="blue">"삼성동"</font> 이라고 입력하세요.
	</div>
	<p>
	<div style="border:#D5D5D5 solid 1px;width:400px;font-size:10pt;padding-top:10px;padding-bottom: 10px;padding-left: 10px;">
	&nbsp;&nbsp;&nbsp;&nbsp; <b>지역명<b></b> <input type="text" name ="dong" id="dong" />&nbsp;&nbsp;&nbsp;&nbsp;
	 <img alt="search" src="/kostaWebS/images/decoration/postSearchBtn.jpg" id="search" >
	</div>
	<p>
	

	<div id = "d1">
	</div>
	
	
</div>
</body>
</html>