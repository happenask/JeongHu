<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
        
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>글수정폼</title>

</head>
<body>
<b>${requestScope.bto.no }번 글 수정</b><p/>
<form action="/board_spring_ann_ibatis/modifyContent.do" method="post" enctype="multipart/form-data">
<input type='hidden' name="no" value="${requestScope.bto.no }">
<input type="hidden" name="viewcount" value="${requestScope.bto.viewcount }">

<input type="hidden" name="page" value="${param.page }">

<table width="550px" class="board">
 <tr>
	<td width="100px" class="writeline">제목</td>
	<td class="writeline"><input type="text" name="title" maxlength="200" size="50" 
				value="${requestScope.bto.title }"></td>
 </tr>
 <tr>
	<td class="writeline">작성자</td>
	<td><input type="text" name="writer" value="${requestScope.bto.writer }"></td>
 </tr>
 
  <tr>
	<td class="writeline">파일첨부</td>
	<td class="writeline">
		
		comment : <input type="text" name="comment"><br><!-- 일반 입력 폼 -->
		파일 : <input type="file" name="upfile"><br>
		
	
	</td> 
 
 </tr>
 
 <tr>
	<td colspan=2>
		<img alt="" src="/board_spring_ann_ibatis/upload/${requestScope.bto.fileName }"><p>
	<textarea cols="75" rows="15" name="content" style="border-style:inset;border-width:2";>
		${requestScope.bto.content }
	</textarea>
</td>
 </tr>
 <tr>
 	
 	<td align="left">
 		<a href ="/kostaWebS/list.do" style="background-color:#F6F6F6;font-weight:bold;text-decoration: none;color: black;">GO LIST</a>
 	</td>
 	
 	<td colspan="2" align="center">
	 	<input type="submit" value="MODIFY" style="background-color:#F6F6F6;font-weight:bold;">
	 	<input type="reset" value="CANCEL" style="background-color:#F6F6F6;font-weight:bold;">
	 </td>
 </tr>
 </table>
 </form>
</body>
</html>







