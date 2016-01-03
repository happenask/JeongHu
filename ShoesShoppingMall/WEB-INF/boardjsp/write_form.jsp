<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 글 입력 후 refresh 하면 글이 다시 입력 되는 것을 막기 위해 session scope에 write_form.jsp에서 특정한 값을 속성으로 넣어 보낸다. -->
<c:set var="from_form" scope="session" value="no_refresh"/>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>새글 작성 폼</title>

</head>
<body>
<!-- 
1. 입력 폼 - 글제목, 작성자, 글내용
2. javascript 이용해서 입력폼에 글이 입력되었는지 체크
 -->
 <p/>
<form action="/kostaWebS/writeContent.do" method="post" enctype="multipart/form-data">
<table width="550px" class="board">
<strong><b>WRITE</b></strong>
 <tr>
	<td width="100px" class="writeline">제목</td>
	<td class="writeline"><input type="text" name="title" size="50" border="0"></td>
 </tr>
 <tr>
	<td class="writeline">작성자</td>
	<td class="writeline"><input type="text" name="writer" border="0"></td>
 </tr>
 
 <tr>
	<td class="writeline">파일첨부</td>
	<td class="writeline">
		
		comment : <input type="text" name="comment"><br><!-- 일반 입력 폼 -->
		파일 : <input type="file" name="upfile" border="0"><br>
		
	
	</td> 
 
 </tr>
 
 
 <tr>
	<td colspan=2>
		<textarea cols="95" rows="15" name="content" style="border-style:inset;border-width:2";></textarea>
	</td>
 </tr>
 <tr>
 	<td align="left">
 		<a href ="/kostaWebS/list.do" style="background-color:#F6F6F6;font-weight:bold;text-decoration: none;color: black;">GO LIST</a>
 	</td>
 
 	<td  align="center">
	 	<input type="submit" value="OK" style="background-color:#F6F6F6;font-weight:bold;">
	 	<input type="reset" value="CANCEL" style="background-color:#F6F6F6;font-weight:bold;">
	 </td>
 </tr>
 </table>
 </form>
</body>
</html>












