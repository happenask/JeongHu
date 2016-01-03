<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 
<!-- 인클루드 되므로 보여질 부분만 넣는다. -->
<script type="text/javascript">

	if("${requestScope.success}"){
		alert("${requestScope.success}");
	}
	
</script>


	
	<div style="margin-left: 200px;margin-top: 50px;">
		<embed src="/kostaWebS/images/slide_show.gif" width="700" height="400" />
	</div>
	
	<strong><font color="#000">&#9824;NEW SHOES</font></strong>
	<div style="margin-left: 50px;margin-top: 50px;">
	
				<c:set var = "k" scope="request" value="${requestScope.pto.currentPage}"/>
			<c:set var = "totalContent" scope ="request" value="${requestScope.pto.totalContent }"/>
			<c:set var = "num" scope = "request" value="${requestScope.cateNumber }"/>
	
		<p>
		<div style="border-bottom:1px solid #000000;border-bottom-width:2px;">
		<strong>
		<c:choose>
			<c:when test="${num==01 }">
			<font color="#000">&#9824;PUMPS & OPENTOE</font>
			</c:when>
			
			<c:when test="${num==02 }">
			<font color="#000">&#9824;SANDALS</font>
			</c:when>
			<c:when test="${num==03 }">
			<font color="#000">&#9824;FALAT SHOES</font>
			</c:when>
			<c:when test="${num==04 }">
			<font color="#000">&#9824;BOOTS</font>
			</c:when>
			
		</c:choose>
		</strong>
		</div>
		<table border="0"  width="800" height="300" cellspacing="30" class ="productTable">
		
			<c:forEach var="i" begin="1"  end="2" step="1">
				<tr>
					<c:forEach var="j" begin="1" end="3" step="1">
						
						<td align ="center" >
							<c:if test="${((i-1)*3+j+(k-1)*6)<=totalContent}">	
							  <a href="/kostaWebS/model/getModelInfo.do?modelNum=${list[((i-1)*3+j+(k-1)*6)-1].modelNum}" title="" class="prdImg"><img src="/kostaWebS/images/products/category_${list[((i-1)*3+j+(k-1)*6)-1].modelType}_${list[((i-1)*3+j+(k-1)*6)-1].modelNum}.jpg" alt="" width="200" height="200" border="0"/></a><br>
							            <a href="/kostaWebS/product_insert_form.do" class="link"><font size="2">${list[((i-1)*3+j+(k-1)*6)-1].modelName}</font></a><br>
							            <strong class="price"><font size="2">${list[((i-1)*3+j+(k-1)*6)-1].modelPrice}원</font></strong> 
							           
							       ${list[((i-1)*3+j+(k-1)*6)-1].modelType}_${list[((i-1)*3+j+(k-1)*6)-1].modelNum}
							            
							</c:if>
						
						</td>
					
					
					</c:forEach>
				
				</tr>
				
			</c:forEach>
		</table>
		
	
			<div style="text-decoration: none;text-align: left;padding-left: 50px;">
				<c:choose>
					<c:when test= "${requestScope.pto.previousPageGroup}">
						<a href ="/kostaWebS/cate_list.do?page=${requestScope.pto.startPageOfPageGroup-1 }&cateNumber=${num}" class="link">[이전]</a>
					</c:when>
				</c:choose>
			<c:forEach var="i" begin="${requestScope.pto.startPageOfPageGroup}"  end="${requestScope.pto.endPageOfPageGroup}" step="1">
				<c:choose>
					<c:when test="${requestScope.pto.currentPage==i }">
						<font color="#bbbbbb">[${i}]</font>
					</c:when>
					<c:otherwise>
							<a href = "/kostaWebS/model/cate_list.do?page=${i}" class="link"><font color="#191919">[${i}]</font></a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
				<c:if test= "${requestScope.pto.nextPageGroup}">
				<a href ="/kostaWebS/model/cate_list.do?page=${requestScope.pto.endPageOfPageGroup+1 }" class="link">[다음]</a>
				</c:if>
			</div>
	
	</div>
<p>