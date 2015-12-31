<%
/** ############################################################### */
/** Program ID   : request-list.jsp                           */
/** Program Name : 매장 요청사항			                    */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>  
<%
	String tabNo     = (String)request.getParameter("tabNo");
%>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=9" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	<meta name="keywords" content="" /><!-- 검색용 키워드 -->
 	<meta name="description" content="스쿨푸드 PRM 서비스입니다." /><!-- 페이지 설명 -->
	<title>매장 요청 사항</title>  
	
	<link href="assets/css/common.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.css" rel="stylesheet" type="text/css" />
	<!-- IE8 이하에서 미디어 쿼리(Media Query) 사용 지원 -->
	<!--[if lt IE 9]><script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
    <!-- IE 8 이하에서 HTML5 태그 지원하도록 스크립트 링크 -->
    <!-- 참고 글 : http://www.cmsfactory.net/node -->
    <!--[if lt IE 9]><script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script><![endif]-->
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="assets/js/style.js"></script>
     
    <script type="text/javascript">
		$(document).ready(function(){
			<%-- $("#tab"+<%=tabNo%>).addClass("on"); --%>
	    });
		function goView(no)
    	{
    		var inCurPage  = $("#inCurPage").val();
    		var inCurBlock = $("#inCurBlock").val();
    		
    		var f = document.form1;
    		location.href= "detail-view.jsp?pageGb=request&no="+ no; 
    	}
    	function goWrite(no)
    	{ 
    		location.href= "request-write.jsp?pageGb=request&no="+ no; 
    	}
    </script>
</head>

<body>
 	<div id="wrap" >
	 	<section class="header-bg">
	 	<div id="header">
	 		<header>
	 			<h1>헤더-타이틀</h1>
	 			<span id="logo">유니포스-로고</span>
	 			<span id="btns">
	 				<input type="button" id="logout-btn" class="rd-bord-btn" value="로그아웃" class="button" onclick="location.href='index.html'">
	 				<input type="button" id="main-btn" class="nv-bord-btn" value="MAIN" class="button" onclick="location.href='main.html';">
	 				</span>
	 			
	 			<nav class="gnb">
	 				<ul class="topmenu">
	 					<li class="disable"><a href="#">전자계약</a></li>
	 					<li><a href="transactional-info.html">거래내역</a>
	 						<ul class="submenu">
								<li><a href="transactional-info.html?tabNo=1">매입 현황</a></li>
								<li><a href="transactional-info.html?tabNo=2">여신 현황</a></li>
								<li><a href="transactional-info.html?tabNo=3">재고 현황</a></li>
								<li><a href="transactional-info.html?tabNo=4">카드 승인 내역</a></li>
								<li><a href="transactional-info.html?tabNo=5">매출 현황</a></li>
							</ul>
						</li>
	 					<li><a href="prom-material.html">홍보물신청</a>
	 						<!-- <ul class="submenu">
								<li><a href="prom-material.html?tabNo=1">인쇄사용문구</a></li>
								<li><a href="prom-material.html?tabNo=2">전단지종류</a></li>
								<li><a href="prom-material.html?tabNo=3">전단지선택</a></li>
							</ul> -->
	 					</li>
	 					<li class="disable"><a href="#">메세지전송</a></li>
	 					<li><a href="tax-bill.html ">세금계산서</a>
	 						<ul class="submenu">
								<li><a href="tax-bill.html?tabNo=A">스쿨푸드</a></li>
								<li><a href="tax-bill.html?tabNo=B">Z.POS</a></li>
								
							</ul>
	 					</li>
	 					<li><a href="cust-comment.html">고객의소리</a></li>
	 					<li><a href="call-center.html">콜센터</a>
	 						<ul class="submenu">
								<li><a href="call-center.html?tabNo=A">매출통계</a> </li>
								<li><a href="call-center.html?tabNo=B">배달시간관리</a></li>
								<li><a href="call-center.html?tabNo=C">판매상품관리</a></li>
							</ul>
	 					</li>
	 					<li class="disable"><a href="#">상품권</a></li>
	 				</ul>
	 			</nav>
	 		</header>
	 		</div>
	 		
	 		<div id="info-bg">
		 		<div id="info">
		 			<div id="account">
		 				<span>스쿨푸드 유니타스 1호점</span>
		 				<span id="btn"><input type="button" id="mody-btn" class="nv-bord-btn" value="정보변경" class="button" onclick="fnShowPanel();"></span>
		 			</div>
		 			<div id="account-info">
		 				<span id="ph-no">전화번호 : 02-1234-5678 /</span> 
		 				<span id="mb-no">휴대전화 : 010-1234-5678 /</span> 
		 				<span id="charge-man">담당SV : 홍길동(010-5678-1234)</span>
		 			</div>
		 		</div><!-- info end -->
	 		</div>
	 	</section>
	 	
	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
	 		<div id="mody-pw">
	 			<header class="nv-bord-tit">비밀번호 변경</header>
	 			<div><p>현재 비밀번호 </p> <input type="password" value="unitas0917"></div>
	 			<div><p>새 비밀번호 </p> <input type="password" ></div>
	 			<div><p>새 비밀번호 확인 </p> <input type="password" ></div>
	 		</div>
	 		<div id="mody-ph-no">
	 			<header class="nv-bord-tit">전화번호 변경</header>
	 			<div><p>현재 전화번호 </p> <input type="text" value="02-786-7838"></div>
	 			<div><p>새 전화번호 </p> 
	 					<input type="tel" class="ph-no first" maxlength="3">-
	 					<input type="tel" class="ph-no" maxlength="4">-
	 					<input type="tel"class="ph-no" maxlength="4">
	 			</div>
	 		</div>
	 	</section>
	 	
	 	
 		 <section class="contents">
 		 	<header> 
 		 		<h1>◎ <span>매장 요청 사항</span></h1>
 		 	</header>
 		 	<div id="noti-section" class="list">
				<form name="form1" method="post">
<%-- 					<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
					<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
					<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
					<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
					<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
					<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->
					<input type="hidden" name="menuGb"         id="menuGb"         value="customer"             >
					<input type="hidden" name="menuId"         id="menuId"         value="pj_5001"              >
					<input type="hidden" name="tab"            id="tab"            value="1"                    >
					<input type="hidden" name="listnum"        id="listnum"        value=""                     > --%>
					
			  		<table>
			  			<col width="10%" />
			  			<col width="10%" />
			    		<col width="*"/>
			    		<col width="15%"/>
			    		<col width="15%"/>
			    		<col width="10%"/>
			    		<thead>
			    			<tr>
			      				<th>분류</th>
			      				<th>번호</th>
			        			<th>제목</th>
			        			<th>작성자</th>
			        			<th>등록일</th>
			        			<th>조회수</th>
			      			</tr>
			    		</thead>
			    
			    		<tbody>
			      			<tr>
			      				<td>물류</td> 
			      				<td>1</td>       
			        			<td  class="subject"><a href="JavaScript:goView('1');">글제목 요약1... </a></td>
			        			<td>unitas</td>
			        			<td>2015-02-14</td>
			        			<td>59</td>
			      			</tr>
				  			<tr>
			      				<td>물류</td>
			      				<td>2</td>       
			        			<td  class="subject"><a href="JavaScript:goView('2');">글제목 요약2... </a></td>
			        			<td>unitas</td>
			        			<td>2015-02-10</td>
			        			<td>22</td>
			      			</tr>
			      			<tr>
			      				<td>포스</td>
			      				<td>3</td>       
			        			<td  class="subject"><a href="JavaScript:goView('3');">글제목 요약3... </a></td>
			        			<td>unitas</td>
			        			<td>2015-02-02</td>
			        			<td>88</td>
			      			</tr>
			      			<tr><td>인테리어</td><td colspan="5">-</td></tr>
			      			<tr><td>포스</td><td colspan="5">-</td></tr>
			      			<tr><td>물류</td><td colspan="5">-</td></tr>
			      			<tr><td>물류</td><td colspan="5">-</td></tr>
			      			<tr><td>인테리어</td><td colspan="5">-</td></tr>
			      			<tr><td>포스</td><td colspan="5">-</td></tr>
			      			<tr><td>물류</td><td colspan="5">-</td></tr>
			    		</tbody>
			  		</table>
			  		
			  		<!-- 페이징 표시 -->
			  		<div class="paging">
					    <ul class="numbering">
					        <li class="f"><a href="#">◁</a></li>
					        <li class="p"><a href="#">PREV</a></li>
					        <li><a class="now" href="#">1</a></li>
					        <li><a href="#">2</a></li>
					        <li><a href="#">3</a></li>
					        <li><a href="#">4</a></li>
					        <li><a href="#">5</a></li>
					        <li><a href="#">6</a></li>
					        <li><a href="#">7</a></li>
					        <li class="last"><a href="#">8</a></li>
					        <li class="n"><a href="#">NEXT</a></li>
					        <li class="l"><a href="#">▷</a></li>
					   	</ul>
					</div>
			  		<!-- 페이징 표시 끝 -->
			  		
			  		<div id="search-option">
			    		<label for="select_search" class="hidden">검색구분</label>
			    		<select id="select_search" name="select_search" style="height:20px; width:80px;">
			    			<option value="">전체</option>
			    			<option value="title">제목</option>
			    			<option value="content">내용</option>
			    		</select>
			    		<label for="search_word" class="hidden">검색어</label>
			    		<input type="text" id="search_word" name="search_word" value="" style="width:180px;" />
			    		<button type="button" class="searchBtn" onclick="search_list();">검색</button>
			    		<button  type="button"  class="gowriteBtn" onclick="goWrite('0')">글쓰기</button>
			  		</div>
		  		</form>
	  		</div>
 		 </section>
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div><!-- end of wrap -->
</body>
</html>