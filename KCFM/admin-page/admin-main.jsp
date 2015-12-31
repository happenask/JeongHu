<!-- 
/** ############################################################### */
/** Program ID   :   admin-main.jsp      							*/
/** Program Name :   admin home	       						        */
/** Program Desc :   관리자 페이지 메인 							*/
/** Create Date  :   2015.03.24						              	*/
/** Programmer   :   Hojun.Choi                                     */
/** Update Date  :   2015.05.15                                     */
/** ############################################################### */
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.BoardConstant" %>
<%@ page import="admin.beans.adminBean" %> 
<%@ page import="admin.dao.adminDao" %>
<%@ include file="/com/common.jsp"%>
<%@ page import="java.net.URLDecoder" %>
<%@ include file="/com/sessionchk.jsp"%>

<%
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-main.jsp");
	
	
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("권한코드", 	(String)session.getAttribute("sseCustAuth"));	//90:Super User 권한 체크	

	//--------------------------------------------------------------------------------------------------
	// Parameter 정보
	//--------------------------------------------------------------------------------------------------

	String QryGubun    = JSPUtil.chkNull((String)paramData.get("inqGubun"   ),  "%"); //조회구분
	String StatusGubun = JSPUtil.chkNull((String)paramData.get("statusGubun"),  "%"); //조회구분
	String listNum     = JSPUtil.chkNull((String)paramData.get("listNum"    ),  "0"); //게시판 번호
	String pageGb      = JSPUtil.chkNull((String)paramData.get("pageGb"     ), "01"); //게시판 구분(없으면 공지사항관리)
	String srch_type   = JSPUtil.chkNull((String)paramData.get("srch_type"  ),  "0"); //검색종류
	String StartDate   = JSPUtil.chkNull((String)paramData.get("sDate"      ),   ""); //조회시작일자
	String EndDate     = JSPUtil.chkNull((String)paramData.get("eDate"      ),   ""); //조회종료일자
	String srch_key    = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("srch_key") , ""), "UTF-8"); //검색어
	
	//--------------------------------------------------------------------------------------------------
	// 초기값 입력
	//--------------------------------------------------------------------------------------------------

    adminBean bean = null; //리스트 목록용
	adminDao  dao  = new adminDao();
	ArrayList<adminBean> list = null;
	ArrayList<adminBean> list2 = null;
	
	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 10;                                                                           // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 10;                                                                           // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝
	String pageTitle = "N/A";
	String writeYn = "";
	
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	if ("".equals(StartDate) || StartDate == null)
	{
		StartDate = CommUtil.insDash(CommUtil.calDate(CommUtil.getDate(), "MONTH",-1));
	}
	if ("".equals(EndDate) || EndDate == null)
	{
		EndDate = JSPUtil.getYear() + "-" + JSPUtil.getMonth() + "-" + JSPUtil.getDay();
	}	
	
	paramData.put("조회시작일자",    StartDate      );
	paramData.put("조회종료일자" ,   EndDate        );
	paramData.put("조회구분",       QryGubun        );
	paramData.put("상태구분",       StatusGubun        );
	
	if ("".equals(srch_key))
	{
		paramData.put("srch_key",    srch_key       );
		paramData.put("srch_type" ,   srch_type     );
	}

	//--------------------------------------------------------------------------------------------------
	// 게시판 구분값에 따라 목록 조회
	//--------------------------------------------------------------------------------------------------
	if (pageGb.equals("01") || pageGb.equals("02")){
		if (pageGb.equals("01")) {
			pageTitle = "공지 사항";	
		} else {
			pageTitle = "교육 자료";	
		}

		writeYn = "N";
		
 		list       = dao.selectNoticeList(paramData); //조회조건에 맞는 이벤트 리스트
 		inTotalCnt = dao.selectNoticeListCount(paramData); //전체 레코드 수
		
	} else if (pageGb.equals("11") || pageGb.equals("12")){
		if (pageGb.equals("11")) {
			pageTitle = "매장 건의 사항";	
		} else {
			pageTitle = "매장 요청 사항";	
		}
		
		writeYn = "Y";
		
 		list       = dao.selectClaimList(paramData); 		//조회조건에 맞는 이벤트 리스트
 		inTotalCnt = dao.selectClaimListCount(paramData); 	//전체 레코드 수
	}
	
	//수정[X]
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
	/* 	System.out.println("data: "+paramData); */// 파라미터 보기
	//######################################################관리자 메뉴 pageGb에 따라 active 상태
	String active1 = pageGb.equals("01")      ? "active" : ""; //공지사항
	String active2 = pageGb.equals("02")      ? "active" : ""; //교육자료
	String active3 = pageGb.equals("11")      ? "active" : ""; //건의사항
	String active4 = pageGb.equals("12")      ? "active" : ""; //요청사항
	String active5 = pageGb.equals("faq")     ? "active" : ""; //FAQ
	String active6 = pageGb.equals("comment") ? "active" : ""; //댓글
	String active7 = pageGb.equals("prom")    ? "active" : ""; //홍보물
	//######################################################
	
			
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/common_file.inc" %>
	<title>KCFM 관리자</title>  
    
    <script type="text/javascript">
    //페이지 이동을 위한 파라미터 동기화
	$(document).ready(function()
	{ 
		getCurrent();
		fnCalendar();
	});
	
	$(function(){
		$("#btn-left").hover(function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		},function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		});
	});
    
	//--------------------------------------------------------------------------------------------------
	// 신규 글 입력
	//--------------------------------------------------------------------------------------------------
	function fnNewWriting(pageGb)	
	{ 	
		var frm = document.getElementById("form1");	
		frm.srch_key.value  = encodeURIComponent(frm.search_word.value);  // 검색어
 		frm.action = "<%=root%>/admin-page/admin-writing.jsp";
		//frm.submit();
		
	}

	//--------------------------------------------------------------------------------------------------
	// 공지사항,교육자료 관리 글 수정
	//--------------------------------------------------------------------------------------------------
	function fnModiWriting(eventcd)	
	{	
		var frm = document.getElementById("form1");		
		frm.srch_key.value  = encodeURIComponent(frm.search_word.value);  // 검색어
 		document.getElementById("listNum" ).value = eventcd; //게시판 번호
 		frm.action = "<%=root%>/admin-page/admin-writing-modify.jsp";
		//frm.submit();
	}
	
	//--------------------------------------------------------------------------------------------------
	// 건의, 요청사항 글 수정
	//--------------------------------------------------------------------------------------------------
	function fnClaimModiWriting(eventcd,StoreCd)	
	{	
		var frm = document.getElementById("form1");		
		frm.srch_key.value  = encodeURIComponent(frm.search_word.value);  // 검색어
 		document.getElementById("listNum" ).value = eventcd; //게시판 번호
 		document.getElementById("sseStoreCd" ).value = StoreCd; //게시판 번호
 		frm.action = "<%=root%>/admin-page/admin-answer-request.jsp";
		frm.submit();
	}

	//--------------------------------------------------------------------------------------------------
	// 글 삭제
	//--------------------------------------------------------------------------------------------------
	function fnDeleteWriting(eventcd)
	{
		if (confirm("삭제하시겠습니까?")) 
		{	
		 	var frm = document.getElementById("form1");
		 	frm.srch_key.value  = encodeURIComponent(frm.search_word.value);  // 검색어
	 		document.getElementById("listNum" ).value = eventcd; //게시판 번호 	
	 		frm.action = "<%=root%>/admin-page/admin-delete-ok.jsp";
			frm.submit();
		}
		else
			{
			var frm = document.getElementById("form1");
		 	frm.srch_key.value  = encodeURIComponent(frm.search_word.value);  // 검색어
	 		document.getElementById("listNum" ).value = eventcd; //게시판 번호 	
	 		frm.action = "<%=root%>/admin-page/admin-main.jsp";
			frm.submit();
			}
    }	

	//--------------------------------------------------------------------------------------------------
	// 글 상세보기
	//--------------------------------------------------------------------------------------------------
	function goView(eventcd)
	{		
		var f = document.form1;
	    f.srch_key.value  = encodeURIComponent(f.search_word.value);  // 검색어  
 		document.getElementById("listNum" ).value = eventcd; //게시판 번호		
 		f.action = "<%=root%>/admin-page/admin-detail-view.jsp";
		f.submit();	 
	}
	//--------------------------------------------------------------------------------------------------
	// 글 상세보기
	//--------------------------------------------------------------------------------------------------
	function goView2(eventcd,StoreCd)
	{		
		var f = document.form1;
	    f.srch_key.value  = encodeURIComponent(f.search_word.value);  // 검색어  
 		document.getElementById("listNum" ).value = eventcd; //게시판 번호
 		document.getElementById("sseStoreCd" ).value = StoreCd; //게시판 번호	
 		f.action = "<%=root%>/admin-page/admin-detail-view.jsp";
		f.submit();	 
	}
	//--------------------------------------------------------------------------------------------------
	// Page 이동
	//--------------------------------------------------------------------------------------------------
	function goPage(page, block) 
 	{
 	    var f = document.form1;
	    f.inCurPage.value  = page;        
	    f.inCurBlock.value = block;
	    f.srch_key.value   = encodeURIComponent(f.search_word.value);  // 검색어  
 	    f.submit();
	}
	
	//--------------------------------------------------------------------------------------------------
	// 조회
	//--------------------------------------------------------------------------------------------------
	function search_list() 
 	{
		var f = document.form1;
		var v_searchWord = 	f.search_word.value;
		f.srch_type.value  = f.search_type.value;
		f.srch_key.value   = encodeURIComponent(v_searchWord);
		f.inCurPage.value  = "1";
		f.inCurBlock.value = "1";
		f.submit();
		
	}
	//공백제거
    function trim(s) 
    {
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }

	//--------------------------------------------------------------------------------------------------
	// 확인점포 팝업
	//--------------------------------------------------------------------------------------------------

    function fnShowStoreList(v_GESI_GB, v_GESI_NO){
        var url = "<%=root%>/admin-page/admin-store-confirm.jsp?pageGb="+v_GESI_GB+"&pBOARD_NO="+v_GESI_NO;
            var objectName = new Object();
            var style = "dialogWidth:980px;dialogHeight:550px;location:no;toolbar=no;center:yes;menubar:no;status:no;scrollbars:no;resizable:no";

            //objectName.storeCount = 0;
            
           	window.showModalDialog(url, objectName, style);

           	//document.form1.storeCount.value = objectName.storeCount;          // 모달 팝업과의 interface
    }
	
    //확인점포 팝업
	function fnShowConfirmList(){
		var browserHeight = document.documentElement.scrollHeight ;
		var browserWidth = document.documentElement.clientWidth;
		var halfWidth = browserWidth/2;
		$(".overlay-bg8").height(browserHeight);
		$("#store-list").css("left", halfWidth -300); 
		$(".overlay-bg8").show();
		$("#store-list").show();
		}
		
	</script>
</head>

<script for=window event=onload>
	document.form1.search_type.value = "<%=srch_type%>";            						// 검색타입
	document.form1.search_word.value = decodeURIComponent(document.form1.srch_key.value) ;  // 검색어
	document.form1.inqGubun.value = "<%=QryGubun%>";
	document.form1.statusGubun.value = "<%=StatusGubun%>";
	document.form1.sDate.value = "<%=StartDate%>";
	document.form1.eDate.value = "<%=EndDate%>";
	document.form1.listNum.value = "<%=listNum%>";
</script>


<body>
 	<div id="wrap">
		<section class="header-bg">
			<!-- header include-->
			<script type="text/javascript">	$(".header-bg").load("<%=root%>/include/admin-header.jsp"); </script>
		</section>
		
		<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
	 	</section>
	 	
		<section class="contents admin">
			<form id="form1" name="form1" method="post">		
					<header>
						<h1> ◎ <span>administrator service &gt; <%=pageTitle%></span></h1>
					<%
						if (pageGb.equals("11")) {
					%>
							<div class="search-d">
								<label for="start_search"> ▶ 등록 기간 : </label> 
								<input class="big_0" id="sDate" name="sDate" type="text" value="<%=StartDate%>"/> ~ 
								<input class="big_0" name="eDate" type="text" value="<%=EndDate%>"/>
								<span>
									<button	class="searchDateBtn" onclick="search_list();">조회</button>
								</span>
							</div>
							<input type = "hidden" id="inqGubun" name="inqGubun" value="%" >
					<%
						} else if (pageGb.equals("12")) {
					%>
							<div class="search-d">
					    		<label for="start_search" > ▶ 구분 : </label>
					    		<select id="inqGubun" name="inqGubun" style="height:20px; width:100px;">
					    			<option value="%" selected="selected" onclick="search_list();">전체</option>					    			
					    			<option value="01" >물류클레임</option>
					    			<option value="02" >포스</option>
					    			<option value="03" >인테리어</option>
					    		</select>
					    		<label for="start_search" > ▶ 등록 기간 : </label>
					    		<input class="big_0" id="sDate" name="sDate" type="text" value="<%=StartDate%>"/> ~ 
								<input class="big_0" name="eDate" type="text" value="<%=EndDate%>"/>
					    		<span><button class="searchDateBtn" onclick="search_list();">조회</button></span>
					  		</div>
					<%
						} else {
					%>
						<div class="search-d">
						<input type = "hidden" id="inqGubun" name="inqGubun" value="%" >
							<label for="start_search"> ▶ 게시 기간 : </label> 
							<input class="big_0" id="sDate" name="sDate" type="text" value="<%=StartDate%>"/> ~ 
						<input class="big_0" name="eDate" type="text" value="<%=EndDate%>"/>
							<span>
								  <button class="searchDateBtn" onclick="search_list();">조회</button>
							</span>
							<span>
								  <button class="newSubmitBtn" onclick="fnNewWriting(<%=pageGb%>);">신규</button>
							</span>
						</div>						
					<%
						}
					%>
					</header>
				<!-- </form> -->
 		 	<div id="cont-admin"><!-- end of cont-admin  여백상관 없다-->
 		 		<div class="cont-nav">
 		 			<ul class="admin-menu">
 		 				<li class="<%=active1%>"><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=01">공지사항관리</a></li>
 		 				<li class="<%=active2%>"><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=02">교육자료관리</a></li>
 		 				<li class="<%=active3%>"><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=11">건의사항관리</a></li>
 		 				<li class="<%=active4%>"><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=12">요청사항관리</a></li>
 		 				<li class="<%=active5%>"><a href="<%=root%>/admin-page/maintain-faq.jsp?pageGb=faq">FAQ관리</a></li>
 		 				<li class="<%=active6%>"><a href="<%=root%>/admin-page/maintain-comment.jsp?pageGb=comment">댓글관리</a></li>
 		 				<li class="<%=active7%>"><a href="<%=root%>/prom_mnt/maintain-prom-cd.jsp?pageGb=prom">홍보물관리</a>
 		 					<ul class="submenu">
								<li><a href="<%=root%>/prom_mnt/maintain-prom-cd.jsp?pageGb=prom">홍보물코드관리</a></li>
								<li><a href="<%=root%>/prom_mnt/maintain-prom-dtl.jsp?pageGb=prom">홍보물상세관리</a></li>
								<li><a href="<%=root%>/prom_mnt/maintain-prom-ord-list.jsp?pageGb=prom">주문내역확인</a></li>
							</ul>
 		 				</li>
 		 			</ul>
 		 		</div>

 		 		<div id="cont-list" class="list list-wide">
 		 			<%
						if (pageGb.equals("11")) {
					%>
					<div class="search-d">
					
					    		<label for="start_search" > ▶ 상태 구분 : </label>
					    		<select id="statusGubun" name="statusGubun" style="height:20px; width:100px;" >
					    			<option value="%" selected="selected"     onclick="search_list();">전체</option>					    			
					    			<option style="color: #f35959;" value="1" onclick="search_list();">답변대기</option>
					    			<option 						value="9" onclick="search_list();">답변완료</option>
					    		</select>
					  		</div>
					<p>
						▶ 검색 된 건의사항 <span><%=inTotalCnt%></span>개
					</p>
					<%
						} else if (pageGb.equals("12")) {
					%>
					<div class="search-d">
					    		<label for="start_search" > ▶ 상태 구분 : </label>
					    		<select id="statusGubun" name="statusGubun" style="height:20px; width:100px;" >
					    			<option value="%" selected="selected"     onclick="search_list();">전체</option>					    			
					    			<option style="color: #f35959;" value="1" onclick="search_list();">답변대기</option>
					    			<option 						value="9" onclick="search_list();">답변완료</option>
					    		</select>
					  		</div>
					<p>
						▶ 검색 된 요청 <span><%=inTotalCnt%></span>개
					</p>
					<%
						} else {
					%>
					<input type = "hidden" id="statusGubun" name="statusGubun" value="%" >
					<p>
						▶ 검색 된 게시물 <span><%=inTotalCnt%></span>개
					</p>
					
					<%
						}
					%>

					<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"			>  <!-- 검색어 -->
					<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"			>  <!-- 검색타입 -->
					<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"			>  <!-- 현재 페이지 -->
					<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"			>  <!-- 현재 블럭 -->
					<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"		>  <!-- 한 페이지당 표시할 레코드 수 -->
					<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"		>  <!-- 한 블럭당 할당된 페이지 수 -->
					<input type="hidden" name="listNum"        id="listNum"        value="<%=listNum %>"        	>  <!-- 게시판 번호 -->
					<input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb %>"             >  <!-- 게시판 종류 구분 값 -->
					
				<table>
					<col width="6%" />											<!-- 01.게시번호 -->
					<% if("01".equals(pageGb)) { %>
						<col width="6%" />										<!-- 02.공지구분 -->
						<col width="*"/>										<!-- 03.제    목 -->
				    	<col width="13%"/>										<!-- 04.작 성 자 -->
				    	<col width="12%"/>										<!-- 05.등 록 일 -->
				    	<col width="8%"/>										<!-- 06.조 회 수 -->
				    	<col width="11%"/>										<!-- 07.편    집 -->
				    	<col width="8%"/>										<!-- 08.확인점포 -->
			    	<% } else if ("02".equals(pageGb)) { %>
			    		<col width="*"/>										<!-- 02.제    목 -->
			    		<col width="13%"/>										<!-- 03.작 성 자 -->
			    		<col width="12%"/>										<!-- 04.등 록 일 -->
			    		<col width="8%"/>										<!-- 05.조 회 수 -->
			    		<col width="11%"/>										<!-- 06.편    집 -->
			    		<col width="8%"/>										<!-- 07.확인점포 -->
			    	<% } else if ("11".equals(pageGb)) { %>
			    		<col width="9%"/>										<!-- 02.매 장 명 -->
			    		<col width="*"/>										<!-- 03.제    목 -->
			    		<col width="9%"/>										<!-- 04.작 성 자 -->
			    		<col width="11%"/>										<!-- 05.등 록 일 -->
			    		<col width="6%"/>										<!-- 06.조 회 수 -->
			    		<col width="8%"/>										<!-- 07.상    태 -->
			    		<col width="11%"/>										<!-- 08.편    집 -->
			    	<% } else if ("12".equals(pageGb)) { %>
			    		<col width="6%" />										<!-- 02.구    분 -->
    					<col width="9%" />										<!-- 03.매 장 명 -->
			    		<col width="*"/>										<!-- 04.제    목 -->
			    		<col width="9%"/>										<!-- 05.작 성 자 -->
			    		<col width="10%"/>										<!-- 06.등 록 일 -->
			    		<col width="6%"/>										<!-- 06.조 회 수 -->
			    		<col width="8%"/>										<!-- 07.상    태 -->
			    		<col width="11%"/>										<!-- 08.편    집 -->
					<% }  %>			    	
	    		<thead>
		    		<tr>
		    			<th>번호</th>
		    	<% if("01".equals(pageGb)) { %>
						<th>공지구분</th>
						<th>제목</th>
			        	<th>작성자</th>
			        	<th>등록일</th>
			        	<th>조회수</th>
			        	<th>편집</th>
			        	<th>확인점포</th>
		    	<% } else if ("02".equals(pageGb)) { %>
			    		<th>제목</th>
			        	<th>작성자</th>
			        	<th>등록일</th>
			        	<th>조회수</th>
			        	<th>편집</th>
			        	<th>확인점포</th>
		    	<% } else if ("11".equals(pageGb)) { %>
			    		<th>매장명</th>
			    		<th>제목</th>
			        	<th>작성자</th>
			        	<th>등록일</th>
			        	<th>조회수</th>
			        	<th>상태</th>
			        	<th>편집</th>
		    	<% } else if ("12".equals(pageGb)) { %>
			    		<th>구분</th>
			        	<th>매장명</th>
			        	<th>제목</th>
			        	<th>작성자</th>
			        	<th>등록일</th>
			        	<th>조회수</th>
			        	<th>상태</th>
			        	<th>편집</th>
				<% }  %>
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
					bean = (adminBean) list.get(i);
					
					inSeq = inTotalCnt - ((inCurPage-1)*inRowPerPage);
		%>
		      				<tr>
		      					<td><%=bean.get게시번호()%></td>
		      				<% if("01".equals(pageGb)) { %>
								<% if("긴급".equals(bean.get공지구분())) {%>
				      					<td style="color: #f35959;"><%=bean.get공지구분()%></td>
				      					<% } else {  %>
				      					<td><%=bean.get공지구분()%></td>
				      					<% } %>
									<td class="subject"><a href="JavaScript:goView('<%=bean.get게시번호()%>');"><%=JSPUtil.chkNull(bean.get제목())%></a></td>
        							<td><%=bean.get등록자()%></td>
        							<td><%=bean.get등록일자()%></td>
				        			<td><%=bean.get조회수()%></td>
				        			<td>
				        				<button class="deleteBtn" onclick="fnDeleteWriting('<%=bean.get게시번호()%>');">삭제</button>
										<button class="modifyBtn" onclick="fnModiWriting('<%=bean.get게시번호()%>');">수정</button>
									</td>
									<%if(bean.get상태().substring(0,4).equals("확인대기")){ %>
				        			<td>
				        				<button class=confirmingBtn id="store-part" value="" name="store-part" onclick="fnShowStoreList('<%=bean.get게시구분코드()%>','<%=bean.get게시번호()%>');"></button>
				        			</td>
			        				<%} else { %>
				        			<td>
				        				<button class=confirm_okBtn id="store-part" value="" name="store-part" onclick="fnShowStoreList('<%=bean.get게시구분코드()%>','<%=bean.get게시번호()%>');"></button>
				        			</td>
			        				<%} %>
			        				<%-- <td>
										<button type="button" class=searchRederBtn id="store-part" value="" name="store-part" onclick="fnShowStoreList('<%=bean.get게시번호()%>');">확인점포</button>
									</td> --%>
					    	<% } else if ("02".equals(pageGb)) { %>
						    		<td class="subject"><a href="JavaScript:goView('<%=bean.get게시번호()%>');"><%=JSPUtil.chkNull(bean.get제목())%></a></td>
						        	<td><%=bean.get등록자()%></td>
		        					<td><%=bean.get등록일자()%></td>
						        	<td><%=bean.get조회수()%></td>
						        	<td>
						        		<button class="deleteBtn" onclick="fnDeleteWriting('<%=bean.get게시번호()%>');">삭제</button>
										<button class="modifyBtn" onclick="fnModiWriting('<%=bean.get게시번호()%>');">수정</button>
									</td>
			        				<%if(bean.get상태().substring(0,4).equals("확인대기")){ %>
				        			<td>
				        				<button type="button" class=confirmingBtn id="store-part" value="" name="store-part" onclick="fnShowStoreList('<%=bean.get게시구분코드()%>','<%=bean.get게시번호()%>');"></button>
				        			</td>
			        				<%} else { %>
				        			<td>
				        				<button type="button" class=confirm_okBtn id="store-part" value="" name="store-part" onclick="fnShowStoreList('<%=bean.get게시구분코드()%>','<%=bean.get게시번호()%>');"></button>
				        			</td>
			        				<%} %>
   									<%-- <td>
										<button type="button" class=searchRederBtn id="store-part" value="" name="store-part" onclick="fnShowStoreList('<%=bean.get게시번호()%>');">확인점포</button>
									</td> --%>
					    	<% } else if ("11".equals(pageGb)) { %>
				    				<td><dvi class="Store_textLine" ><%=bean.get매장명()%></dvi></td>
      								<input type="hidden" name="sseStoreCd"     id="sseStoreCd"     value="<%=bean.get매장코드() %>" >  <!-- 매장코드 구분 값 -->
				    				<td class="subject"><a href="JavaScript:goView2('<%=bean.get게시번호()%>','<%=bean.get매장코드() %>');"><%=JSPUtil.chkNull(bean.get제목())%></a></td>
						        	<td><%=bean.get등록자()%></td>
		        					<td><%=bean.get등록일자()%></td>
						        	<td><%=bean.get조회수()%></td>
						        	<% if("답변대기".equals(bean.get요청상태())) { %>
      								<td style="color: #f35959;"><%=bean.get요청상태()%></td>
      								<% } else {  %>
      								<td>답변완료</td>
      								<% } %>	
						        	<% if("답변대기".equals(bean.get요청상태())) { %>
										<td>
											<button class="deleteBtn" onclick="fnDeleteWriting('<%=bean.get게시번호()%>');">삭제</button>
											<button class="answerBtn" onclick="fnClaimModiWriting('<%=bean.get게시번호()%>','<%=bean.get매장코드() %>');">답하기</button>
										</td> 
		      						<% } else {  %>
										<td>
											<button class="deleteBtn" onclick="fnDeleteWriting('<%=bean.get게시번호()%>');">삭제</button>
										</td>
      								<% } %>	  
					    	<% } else if ("12".equals(pageGb)) { %>
						    		<td><%=bean.get요청구분()%></td>
						        	<td><dvi class="Store_textLine" ><%=bean.get매장명()%></dvi></td>
    								<input type="hidden" name="sseStoreCd"     id="sseStoreCd"     value="<%=bean.get매장코드() %>" >  <!-- 매장코드 구분 값 -->
						        	<td class="subject"><a href="JavaScript:goView('<%=bean.get게시번호()%>');"><%=JSPUtil.chkNull(bean.get제목())%></a></td>
		        					<td><%=bean.get등록자()%></td>
		        					<td><%=bean.get등록일자()%></td>
		        					<td><%=bean.get조회수()%></td>
						        	<% if("답변대기".equals(bean.get요청상태())) { %>
		      								<td style="color: #f35959;"><%=bean.get요청상태()%></td>
		      								<% } else {  %>
		      								<td>답변완료</td>
		      								<% } %>	
								        	<% if("답변대기".equals(bean.get요청상태())) { %>
												<td>
													<button class="deleteBtn" onclick="fnDeleteWriting('<%=bean.get게시번호()%>');">삭제</button>
													<button class="answerBtn" onclick="fnClaimModiWriting('<%=bean.get게시번호()%>','<%=bean.get매장코드() %>');">답하기</button>
												</td> 
				      						<% } else {  %>
												<td>
													<button class="deleteBtn" onclick="fnDeleteWriting('<%=bean.get게시번호()%>');">삭제</button>
												</td>
		      								<% } %>	  
								<% }  %>
								</tr>							
			<%
						inSeq--;
					}
				} 
				else 
				{
			%>
	      			<tr>
	      				<td colspan="9">조회된 내용이 없습니다.</td>
	      			</tr>
			<%
				}
			%>
   				</tbody>
  			</table>
		<!-- 페이징 표시 -->
		<div class="paging">
		   	 <ul class="numbering">
							        
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
			  		<!-- 글검색 -->
			  		<div id="search-option">
			    		<label for="select_search" class="hidden">검색구분</label>
			    		<select id="search_type" name="search_type" style="height:20px; width:80px;">
			    			<option value="0">전체</option>
			    			<option value="title">제목</option>
			    			<option value="content">내용</option>
			    			<option value="writer">작성자</option>
			    			<% if("01".equals(pageGb)) { %>
			    			<option value="notice">공지구분</option>
			    			<% }else if("11".equals(pageGb)||"12".equals(pageGb)) {%>
			    			<option value="storeCd">매장명</option>
			    			<% } %>
			    		</select>			    		 		
			    		<label for="search_word" class="hidden">검색어</label>
			    		<input type="text" id="search_word" name="search_word" value="" style="width:180px; " onKeyDown="if(event.keyCode==13){ searchBtn.focus(); search_list(); }"/>
			    		<span><button id = "searchBtn"class="searchBtn" onclick="search_list();">검색</button></span>
			  		</div>
 		 		</div> 		 		
 		 	</div><!-- end of cont-admin  여백상관 없다--> 	
	 	</form>	 	
	</section>
 	
 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
		 	<!-- 확인점포 popup -->
		 	<div class="overlay-bg8">
		 		<div class="dtl-pop" id="store-list">
		 			<section class="contents admin">
		 				<iframe src="<%=root%>/admin-page/admin-comfrim-ok.jsp" width = "500" height="500"></iframe>
						</section>
					<!-- 페이징 표시 -->
		 		<p>
		 		<button class="redBtn" id="btnOrd" type="button" onclick="$('.overlay-bg8').hide()">적 용</button></p>
		 	</div>
		 	<div class="overlay-bg">
		 		<img id="loadingImage" src="http://i1.daumcdn.net/cfs.tistory/resource/315/blog/plugins/lightbox/images/loading.gif" style="position: relative; cursor: pointer; top: 340px; left: 477px;display: none; ">
		 	</div>
		 </div>
 	</div><!-- wrap end -->
 
</body>
</html>