<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>답변폼</title>

</head>
<body>

<p/>
<form action="/kostaWebS/replyContent.do" method="post">
<input type="hidden" name="refamily" value="${requestScope.bto.refamily }">
<input type="hidden" name="restep" value="${requestScope.bto.restep }">
<input type="hidden" name="relevel" value="${requestScope.bto.relevel }">
<input type="hidden" name="fileName" value="${requestScope.bto.fileName }">

<input type="hidden" name="page" value="${param.page }">

<table width="550px" class="board" >
<strong><b>REPLY</b></strong>
 <tr>
	<td width="100px" class="writeline">제목</td>
	<td><input type="text" name="title" maxlength="200" size="50" 
				value="RE:${requestScope.bto.title }"  border="0"></td>
 </tr>
 <tr>
	<td class="writeline">작성자</td>
	<td class="writeline"><input type="text" name="writer" border="0"></td>
 </tr>
 <tr>
	<td colspan=2 >
		<textarea cols="75" rows="15" name="content"  style="border-style:inset;border-width:2;">
${requestScope.bto.content }
-----------------------답변-------------------------
</textarea>
	</td>
 </tr>
 <tr>
 	<td align="left">
 	    <a href ="/kostaWebS/list.do" style="background-color:#F6F6F6;font-weight:bold;text-decoration: none;color: black;">GO LIST</a>
 	</td>
 	
 	<td  align="center">
	 	&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" value="OK" style="background-color:#F6F6F6;font-weight:bold;">
	 	<input type="reset" value="CANCEL" style="background-color:#F6F6F6;font-weight:bold;">
	 </td>
 </tr>
 </table>
 </form>
</body>
</html>





