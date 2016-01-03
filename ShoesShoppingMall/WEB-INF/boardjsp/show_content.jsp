<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>글내용</title>
<style type="text/css">
#title{
font-weight: bold;
border-top:2px solid gray;
padding-top: 10px;
padding-bottom: 10px;

}
#info{
font-size: 13px;
border-top:1px solid #D5D5D5;
padding-top: 10px;
padding-bottom: 10px;

}
#content{
min-height:300px; 
height:auto;
color: gray;
}
</style>

 


</head>
<body >
<div style="margin-left: 50px;margin-top: 100px;">
<strong><b>CONTENT</b></strong>
<div id="title">
제목 : ${requestScope.bto.no }.${requestScope.bto.title }
</div>
<div id="info">
작성자 : ${requestScope.bto.writer } | 조회수 : ${ requestScope.bto.viewcount} | 작성일시 : ${requestScope.bto.writedate}
</div>
<div id="content">
<img alt="" src="/kostaWebS/upload/${bto.fileName }" width="300px" height="300px"><p>
${requestScope.bto.content }
</div>

</div>
<p>
<a href="/kostaWebS/writeForm.do" style="font-weight:bold;text-decoration: none;color: black;">WRITE</a>&nbsp;&nbsp;
<a href="/kostaWebS/list.do?page=${param.page }" style="font-weight:bold;text-decoration: none;color: black;">LIST</a>&nbsp;&nbsp;

  <c:if test="${sessionScope.login_info.name eq requestScope.bto.writer }">
<a href="/kostaWebS/modifyForm.do?no=${requestScope.bto.no }&page=${param.page }" style="font-weight:bold;text-decoration: none;color: black;">MODIFY</a>&nbsp;&nbsp;
	</c:if>
<a href="/kostaWebS/deleteContent.do?no=${requestScope.bto.no }&page=${param.page }" style="font-weight:bold;text-decoration: none;color: black;">DELETE</a>&nbsp;&nbsp;
<a href="/kostaWebS/replyForm.do?no=${requestScope.bto.no }&page=${param.page }" style="font-weight:bold;text-decoration: none;color: black;">REPLY</a>
</p>
</body>
</html>














