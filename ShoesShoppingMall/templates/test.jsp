<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그인 페이지</title>
<style type="text/css">

#container{
	width:1221px;
	border: 1px solid black;
	margin:auto; 
}
#header{
	padding: 5px;
	border-bottom: 1px solid black;
}
#left{
	padding: 5px;
	height:500px;width:200px; 
	float:left;
}
#content{
	padding: 5px;
	width:600px;
	float:left;
	 CURSOR: pointer;
}
#footer{
	padding-top:5px;
	border-top: 1px solid black;
	clear:left;  
	text-align:center;
	height:100px;
}
</style>
</head>
<body>
<a href = "/kostaWebS/mainPage.do"><img src = "/kostaWebS/images/decoration/Logo.jpg" border="0"></a>
<div id="container" >

	<div id="header" align="right">
		
<!-- 인클루드 되므로 보여질 부분만 넣는다. -->



 <a href="/kostaWebS/loginForm.do"><img src="/kostaWebS/images/login_menu1.jpg"  border="0" onmouseover="this.src='/webFinalprojectExam/images/login_menu1_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu1.jpg'"/></a>
 <a href="/product/list.html?cate_no=39"><img src="/kostaWebS/images/login_menu2.jpg"  border="0" onmouseover="this.src='/webFinalprojectExam/images/login_menu2_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu2.jpg'"/></a>
 <a href="/product/list.html?cate_no=46"><img src="/kostaWebS/images/login_menu3.jpg" border="0"  onmouseover="this.src='/webFinalprojectExam/images/login_menu3_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu3.jpg'"/></a>
 <a href="/product/list.html?cate_no=44"><img src="/kostaWebS/images/login_menu4.jpg"  border="0" onmouseover="this.src='/webFinalprojectExam/images/login_menu4_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu4.jpg'"/></a>
 <a href="/product/list.html?cate_no=28"><img src="/kostaWebS/images/login_menu5.jpg"  border="0" onmouseover="this.src='/webFinalprojectExam/images/login_menu5_02.jpg'" onmouseout="this.src='/kostaWebS/images/login_menu5.jpg'"/></a>

 
 
	</div>

	<div id="left" >
		
 <ul>
                <li class="pst6 xans-record-"><a href="/product/list.html?cate_no=27"><img src="/kostaWebS/images/cate_images/cate_menu1.jpg"  border="0" alt="opentoes" onmouseover="this.src='/kostaWebS/images/cate_images/cate_menu1_02.jpg'" onmouseout="this.src='/webFinalprojectExam/images/cate_images/cate_menu1.jpg'"/></a></li><br>
                <li class="pst7 xans-record-"><a href="/product/list.html?cate_no=39"><img src="/kostaWebS/images/cate_images/cate_menu2.jpg"  border="0" alt="sandals" onmouseover="this.src='/kostaWebS/images/cate_images/cate_menu2_02.jpg'"  onmouseout="this.src='/webFinalprojectExam/images/cate_images/cate_menu2.jpg'"/></a></li><br>
                <li class="pst10 xans-record-"><a href="/product/list.html?cate_no=46"><img src="/kostaWebS/images/cate_images/cate_menu3.jpg" border="0" alt="flatshoes" onmouseover="this.src='/kostaWebS/images/cate_images/cate_menu3_02.jpg'" onmouseout="this.src='/webFinalprojectExam/images/cate_images/cate_menu3.jpg'"/></a></li><br>
                <li class="pst8 xans-record-"><a href="/product/list.html?cate_no=44"><img src="/kostaWebS/images/cate_images/cate_menu4.jpg"  border="0" alt="boots" onmouseover="this.src='/kostaWebS/images/cate_images/cate_menu4_02.jpg'" onmouseout="this.src='/webFinalprojectExam/images/cate_images/cate_menu4.jpg'"/></a></li><br>
                <li class="pst9 xans-record-"><a href="/product/list.html?cate_no=28"><img src="/kostaWebS/images/cate_images/cate_menu5.jpg"  border="0" alt="shoesaccesary" onmouseover="this.src='/kostaWebS/images/cate_images/cate_menu5_02.jpg'" onmouseout="this.src='/webFinalprojectExam/images/cate_images/cate_menu5.jpg'"/></a></li>
</ul>

            <!--설정 불러오기  -->
	</div>

	<div id="content" >
		

<title>Insert title here</title>
<script type="text/javascript" src ="./jquery.js"></script>
<script type="text/javascript">
 
 $(document).ready(function(){
	 $("#loginSubmit").on("click",function(){
		 
		 $.ajax({
			 "url":"/loginMember.do",
			 "type":"POST",
			 "data":"id="+$("#id").val()+"&password="+$("#password").val(),
			 "dataType":"JSON",
			 "success":function(data){
				 alert(data);
			 },
			 "error":errorMethod
		 });
	 });
 });
 
 
 function errorMethod(xhr,status,msg){
		alert("오류발생"+xhr.readyState+","+status+","+msg);
	}
</script>

		<table border="0" bordercolor="black" width="800" height="300" >
		<tr>
			<td></td>
			
			<td align="center">
				<img alt="" src="/kostaWebS/images/decoration/loginLogo.jpg"  border="0">
			</td>
			
			<td></td>
		</tr>
		
		<tr>
			<td align ="center" >
					
			</td>
			
			<td align ="center" width="200" height ="200" bgcolor="#B2EBF4">
				<form action="/kostaWebS/loginForm.do" method = "post">
					<fieldset>
						<legend><font color="#666666">Member Login</font></legend>
						<p>ID <input type="text" name="id" size="20" maxlength="10" id="id"></p>
						   PW <input type="text" name="password" size="20" maxlength="20" id="password"><p>
						<input type="image" src="/kostaWebS/images/decoration/loginSubmitLogo.jpg" border="0" id ="loginSubmit">
					</fieldset>
				</form>	
			</td>
				
			<td>
				
			</td>
		</tr>
		
		<tr>
		</tr>
	</table>
	

	</div>

	<div id="footer" >
		<!-- 딱 붙일 내용만 보여야 한다. -->

<!-- 인클루드 되므로 보여질 부분만 넣는다. -->
<img src = "/kostaWebS/images/decoration/cooperation_info1.jpg">

<img src = "/kostaWebS/images/decoration/cooperation_info2.jpg">

	</div>
</div>

</body>
</html>