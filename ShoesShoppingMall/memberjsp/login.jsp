<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix ="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">

 $(document).ready(function(){
		$("#loginBtn").on("click",function(){
			if($("#id").val()==""){
				alert("아이디를 입력하세요.");
				$("#id").focus();
				return false;
			}
			if($("#password").val()==""){
				alert("password를 입력하세요.");
				$("#password").focus();
				return false;
			}
			
		});
		
		if("${requestScope.error_message}"){
			
			alert("${requestScope.error_message}");
		}
		
  
 });
 
 

</script>


	<c:if test = "${requestScope.error_message!=null}">
	</c:if>
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
			
				<form action="/kostaWebS/loginMember.do" method="post" id="f1">
					<fieldset>
						<legend><font color="#666666">Member Login</font></legend>
						<p>ID <input type="text" name="id" size="20" maxlength="10" id="id"></p>
						   PW <input type="password" name="password" size="20" maxlength="20" id="password"><p>
						<input type = "image" src="/kostaWebS/images/decoration/loginSubmitLogo.jpg" border="0" id="loginBtn">
						
					</fieldset>
				</form>
			</td>
				
			<td>
				
			</td>
		</tr>
		
		<tr>
		</tr>
	</table>
	
