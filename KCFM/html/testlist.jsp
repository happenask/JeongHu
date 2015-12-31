<%
/** ############################################################### */
/** Program ID   : list.jsp                                         */
/** Program Name : 마이페이지 / 이전주문내역(주문내역)              */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="test.dao.testDao" %>
<%@ page import="test.beans.testBean" %>
<%@ page import="com.util.BoardConstant" %>
<%@ include file="/com/common.jsp"%>

<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	String root = request.getContextPath();

	String userNo = (String)session.getAttribute("sessCustNumber");  //고객번호
	String userId = (String)session.getAttribute("sessCustLoginId"); //아이디
	String srch_key  = JSPUtil.chkNull((String)paramData.get("srch_key")); //검색어
	String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type")); //검색종류
	
	testBean testBean    = null; //리스트 데이타에서 담을 빈
	testBean detailBean  = new testBean(); //내용보기 에서 담을 빈
	
	testDao testDao = new testDao();
	
	ArrayList<testBean> list = null;
	
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 5;                                                                            // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 3;                                                                            // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝
	
	paramData.put("userId", userId);
	//paramData.put("sdate",  sdate);
	//paramData.put("edate",  edate);
	
	list = testDao.selectList(paramData); //조회조건에 맞는 이벤트 리스트
	
	inTotalCnt = testDao.selectListCount(paramData); //전체 레코드 수
	
	//####################################################################################################페이지 구하기 시작
	//현재 블럭의 페이지수구하기
	if( inTotalCnt % inRowPerPage == 0 ) { inTotalPageCount = inTotalCnt / inRowPerPage; } 
	else    	 						 { inTotalPageCount = inTotalCnt / inRowPerPage + 1; }
	
	//페이지 블럭 구하기
	if( inTotalPageCount % inPagePerBlock == 0 ) { inTotalPageBlockCount = (int)Math.round((double)(inTotalPageCount/inPagePerBlock)); }
	else                                		 {inTotalPageBlockCount = (int)Math.round((double)(inTotalPageCount/inPagePerBlock) + 0.5); }
	
	//이전 블럭 구하기
	if( inCurBlock > 1 ) { inPrevBlock = inCurBlock - 1; }
	else             	 {inPrevBlock = inCurBlock; }
	
	inPrevPage = inPrevBlock * inPagePerBlock - inPagePerBlock + 1;
	
	//다음 블럭 구하기 
	if( inCurBlock < inTotalPageBlockCount ) { inNextBlock = inCurBlock + 1; }
	else                            		 { inNextBlock = inCurBlock; }
	
	//다음 페이지 구하기
	inNextPage = inNextBlock * inPagePerBlock - inPagePerBlock + 1;
	//####################################################################################################페이지 구하기 끝

	String toDay   = "";
	String weekDay = "";
	String month1  = "";
	String month3  = "";
	String month6  = "";
	String year    = "";

	toDay   = JSPUtil.getYear() + "-" + JSPUtil.getMonth() + "-" + JSPUtil.getDay();
	weekDay = CommUtil.insDash(CommUtil.calDate(CommUtil.getDate(), "DAY",-7  ));
	month1  = CommUtil.insDash(CommUtil.calDate(CommUtil.getDate(), "MONTH",-1));
	month3  = CommUtil.insDash(CommUtil.calDate(CommUtil.getDate(), "MONTH",-3));
	month6  = CommUtil.insDash(CommUtil.calDate(CommUtil.getDate(), "MONTH",-6));
	year    = CommUtil.insDash(CommUtil.calDate(CommUtil.getDate(), "YEAR",-1 ));
%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=9" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	<meta name="keywords" content="" /><!-- 검색용 키워드 -->
 	<meta name="description" content="스쿨푸드 PRM 서비스입니다." /><!-- 페이지 설명 -->
	<title>매장 건의 사항</title>  
	
	<link href="assets/css/common.css" rel="stylesheet" type="text/css" />
	<!-- IE8 이하에서 미디어 쿼리(Media Query) 사용 지원 -->
	<!--[if lt IE 9]><script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
    <!-- IE 8 이하에서 HTML5 태그 지원하도록 스크립트 링크 -->
    <!-- 참고 글 : http://www.cmsfactory.net/node -->
    <!--[if lt IE 9]><script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script><![endif]-->
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="assets/js/style.js"></script>
     
    <script type="text/javascript">
    
    	function goView(root,eventcd)
    	{
    		//var inCurPage  = $("#inCurPage").val();
    		//var inCurBlock = $("#inCurBlock").val();
    		//var srch_key   = $("#srch_key"  ).val();
    		
    		var f = document.form1;
    		//location.href= "testwrite.jsp?seqNum="+eventcd;
    		
     		//f.inCurPage.value  = inCurPage;
     		//f.inCurBlock.value = inCurBlock;             
    		//f.srch_key.value   = encodeURIComponent(srch_key);
    		//f.submit();
    		
     		f.srch_key.value = encodeURIComponent(f.srch_key.value);
     		f.seqNum.value   = eventcd;
    		f.action         = "testwrite.jsp";
    		f.submit();	 
    	}
    	function goWrite(pageGb)
    	{
/*     		var inCurPage  = $("#inCurPage").val();
    		var inCurBlock = $("#inCurBlock").val();
    		
    		var f = document.form1; */ 
    		location.href= "testwrite.jsp?pageGb="+ pageGb;
    	}
     	function goPage(page, block) 
     	{
     	    var f = document.form1;	
    	    f.inCurPage.value  = page;        
    	    f.inCurBlock.value = block; 
     	    f.submit();
    	}
     	function search_list() 
     	{
    		var f = document.form1;
/*    		
    		if( f.search_word.value == "" ) 
    		{
    			alertFrame.find("#alertText p").remove();
    			alertFrame.find("#alertText").append("<p>검색어를 입력하세요.</p>"); 
    			popAlert(alertFrame);
    			//event.preventDefault();
    			
    			f.search_word.focus();
    			return;
    		}
    		*/

    		location.href= "testlist.jsp";       
    		f.srch_key.value   = encodeURIComponent(f.search_word.value);
    		f.inCurPage.value  = "1";
    		f.inCurBlock.value = "1";
    		f.submit();
    		
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
	 						<ul class="submenu">
								<li><a href="prom-material.html?tabNo=1">인쇄사용문구</a></li>
								<li><a href="prom-material.html?tabNo=2">전단지종류</a></li>
								<li><a href="prom-material.html?tabNo=3">전단지선택</a></li>
							</ul>
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
 		 		<h1>◎ <span>매장 건의 사항</span></h1>
 		 	</header>
 		 	<div id="noti-section" class="list">
				<form id="form1" name="form1" method="post">
					<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
					<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
					<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
					<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
					<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
					<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->
					<input type="hidden" name="seqNum"         id="seqNum"         value=""                     >  <!-- 게시판 번호 -->
					<input type="hidden" name="menuGb"         id="menuGb"         value="customer"             >
					<input type="hidden" name="menuId"         id="menuId"         value="pj_5001"              >
					<input type="hidden" name="tab"            id="tab"            value="1"                    >
					<input type="hidden" name="listnum"        id="listnum"        value=""                     >
					
					
			  		<table>
			  			<col width="10%" />
			    		<col width="*"/>
			    		<col width="15%"/>
			    		<col width="15%"/>
			    		<col width="10%"/>
			    		<thead>
			    			<tr>
			      				<th>번호</th>
			        			<th>제목</th>
			        			<th>작성자</th>
			        			<th>등록일</th>
			        			<th>조회수</th>
			      			</tr>
			    		</thead>

		    			<tbody>
		<%
			int inSeq = 0;
		
			String title = "";
		
			if( list != null && list.size() > 0 ) 
			{
				for( int i = 0; i < list.size(); i++ ) 
				{
					testBean = (testBean) list.get(i);
					
					inSeq = inTotalCnt - ((inCurPage-1)*inRowPerPage); 
		%>
		      				<tr>
		      					<td><%=testBean.get게시번호()%></td>
		      					<td class="subject"><a href="JavaScript:goView('<%=root%>','<%=testBean.get게시번호()%>');"><%=JSPUtil.chkNull(testBean.get제목())%></a></td>
		        				<td><%=testBean.get등록자()%></td>
		        				<td><%=testBean.get등록일자()%></td>
		        				<td><%=testBean.get조회수()%></td>
		      				</tr>
		<%
					inSeq--;
				}
			} 
			else 
			{
		%>
			      			<tr>
			      				<td colspan="5">조회된 내용이 없습니다.</td>
			      			</tr>
		<%
			}
			
		%>
		    			</tbody>
			  		</table>
			  		
			  		<!-- 페이징 표시 -->
			  		<div class="paging">
					    <ul class="numbering">
					    	<!-- 
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
					         -->
					        
<%	
	if( inTotalPageCount > 0 ) 
	{
		if( inCurBlock == 1 ) 
		{
%>
			<li class="f"><a href="#">◁</a></li>
<%	
		} 
		else 
		{
%>
			<li class="f"><a href="JavaScript:goPage('1','1');" onFocus='this.blur()'>◁</a></li>  
<%	
		}
		
		if( inPrevBlock == inCurBlock ) 
		{
%>
  		 	<li class="p"><a href="#">PREV</a></li>
<% 
		
		} 
		else 
		{
%>
			<li class="p"><a href="JavaScript:goPage('<%=inPrevPage %>','<%=inPrevBlock %>');" onFocus='this.blur()'>PREV</a></li>
<%
		}
	
		int nPageIndex = 0;
		
		for( int i = 0; i < inPagePerBlock; i++ ) 
		{
			nPageIndex = inCurBlock * inPagePerBlock  - inPagePerBlock  + (i+1);
			
			if( nPageIndex <= inTotalPageCount ) 
			{
				if( nPageIndex == inCurPage ) 
				{
%>   
   			<li><%=nPageIndex %></li>
<%
				} 
				else 
				{
%>
   			<li><a href="JavaScript:goPage('<%=nPageIndex %>','<%=inCurBlock %>');" onFocus='this.blur()'><%=nPageIndex %></a></li>
<%
				}
			}
		}
		
		if( inNextBlock == inCurBlock ) 
		{
%>
    		<li class="n"><a href="#">NEXT</a></li>
<%
		} 
		else 
		{
%>
    		<li class="n"><a href="JavaScript:goPage('<%=inNextPage %>','<%=inNextBlock %>');"  onFocus='this.blur()'>NEXT</a></li>
<%
		}
		
		if( inTotalPageBlockCount == inCurBlock ) 
		{
%>
			<li class="l"><a href="#">▷</a></li>
<%	
		} 
		else 
		{
%>
			<li class="l"><a href="JavaScript:goPage('<%=inTotalPageCount%>','<%=inTotalPageBlockCount%>');" onFocus='this.blur()'>▷</a></li>			
<%	
		}
	}
%>
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
			    		<button type="button" class="searchBtn"  onclick="search_list();">검색</button>
			    		<button  type="button"  class="gowriteBtn" onclick="goWrite('매장 건의')">글쓰기</button>
			  		</div>
		  		</form>
	  		</div>
 		 </section>
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div><!-- end of wrap -->
</body>
</html>