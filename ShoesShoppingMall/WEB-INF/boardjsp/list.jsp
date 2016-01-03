<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>글목록</title>

</head>
<body>
<p>
<p>
<strong>&#9824;RANK</strong>
<div style="border: 1px solid #BDBDBD">
	<strong>1</strong><img alt="" src="/kostaWebS/images/board_deco/medal01.jpg" width="20px"><img alt="" src="/kostaWebS/upload/${image[0]}" width="150px">
	<strong>2</strong><img alt="" src="/kostaWebS/images/board_deco/medal02.jpg" width="20px"><img alt="" src="/kostaWebS/upload/${image[1]}" width="150px">
	<strong>3</strong><img alt="" src="/kostaWebS/images/board_deco/medal03.jpg" width="20px"><img alt="" src="/kostaWebS/upload/${image[2]}" width="150px">
</div>

<img alt="" src="/kostaWebS/images/board_deco/board_deco5.jpg">
<table id="content"  class="board" cellspacing="0" >
	<tr>
		<td align="center" class="boardline1"><img alt="" src="/kostaWebS/images/board_deco/board_deco1.jpg"></td>
		<td width="300px" align="center" class="boardline1"><img alt="" src="/kostaWebS/images/board_deco/board_deco2.jpg"></td>
		<td class="boardline1"><img alt="" src="/kostaWebS/images/board_deco/board_deco3.jpg"></td>
		<td class="boardline1"><img alt="" src="/kostaWebS/images/board_deco/board_deco4.jpg"></td>
		<td class="boardline1"><b>HITS</b></td>
	</tr>
	<c:forEach items="${requestScope.lto.list }" var="bto">
		<tr>
			<td class="boardline2">${bto.no }</td>
			<td class="boardline2">
				<c:forEach begin="1" end="${bto.relevel }" step="1">
					&nbsp;&nbsp;
				</c:forEach>
				<c:if test="${bto.relevel== 0 }">
					
				<img alt="" src="/kostaWebS/upload/${bto.fileName }" width="50px" height="50px">
				</c:if>
				<c:if test="${bto.relevel != 0 }">
					→
				</c:if>
				<a href="/kostaWebS/getContent.do?no=${bto.no }&page=${requestScope.lto.pagingTO.currentPage}" style="text-decoration: none;color: #5D5D5D">
					${bto.title }
				</a>
			</td>
			<td class="boardline2">${bto.writer }</td>
			<td class="boardline2">${bto.writedate }</td>
			<td class="boardline2">${bto.viewcount }</td>
		</tr>	
	</c:forEach>
	
</table>

<p>
<table>
	<tr>
		<td>		
		<c:choose>
			<c:when test="${requestScope.lto.pagingTO.previousPageGroup }">
				<a href="/kostaWebS/list.do?page=${requestScope.lto.pagingTO.startPageOfPageGroup -1 }">
				◀
				</a>
			</c:when>
			<c:otherwise>
				◀
			</c:otherwise>
		</c:choose>
		<c:forEach begin="${requestScope.lto.pagingTO.startPageOfPageGroup }"
							   end="${requestScope.lto.pagingTO.endPageOfPageGroup }"
							   step="1"
							   var ="i">
			<c:choose>
				<c:when test="${i == requestScope.lto.pagingTO.currentPage }">
					${i }
				</c:when>
				<c:otherwise>
					<a href="/kostaWebS/list.do?page=${i }">${i }</a>
				</c:otherwise>
			</c:choose>			
		</c:forEach>
		<c:choose>
			<c:when test="${requestScope.lto.pagingTO.nextPageGroup }">
				<a href="/kostaWebS/list.do?page=${requestScope.lto.pagingTO.endPageOfPageGroup + 1 }">
					▶
				</a>
			</c:when>
			<c:otherwise>
				▶
			</c:otherwise>
		</c:choose>
		
		<td>
	</tr>
</table>

<c:if test="${sessionScope.login_info!=null }">
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="/kostaWebS/writeForm.do" style="font-weight:bold;text-decoration: none;color: black;">WRITE</a>
</c:if>
<br>

</body>
</html>















