
<!-- 
/** ############################################################### */
/** Program ID   : maintain-faq.jsp                                 */
/** Program Name : maintain-faq	       						        */
/** Program Desc : 자주하는 질문 관리		                            */
/** Create Date  : 2015.04.13                                       */
/** Update Date  :                                                  */
/** Programmer   : JHYOUN                                           */
/** ############################################################### */
 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.BoardConstant" %>

<%@ page import="admin.beans.faqBean" %> 
<%@ page import="admin.dao.faqDao" %>

<%@ include file="/com/common.jsp"%>

<%

	String root = request.getContextPath();

	String listNum    = JSPUtil.chkNull((String)paramData.get("listNum")  , "");            //게시판 번호
	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb")   , "faq");         //게시판 구분
	String srch_key   = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("srch_key") , ""), "UTF-8"); //검색어
	String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type"), "0");           //검색종류
	String StartDate  = JSPUtil.chkNull((String)paramData.get("sDate")    , "");            //조회시작일자
	String EndDate    = JSPUtil.chkNull((String)paramData.get("eDate")    , "");            //조회종료일자
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sseStoreCd   = JSPUtil.chkNull((String)session.getAttribute("sseStoreCd")  ,""); //매장코드
	String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm")   ,""); //등록자명
	String sseCustId    = JSPUtil.chkNull((String)session.getAttribute("sseCustId")   ,""); //등록자ID
	String sseStroeNm   = JSPUtil.chkNull((String)session.getAttribute("sseStroeNm")  ,""); //매장명

	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 7;                                                                            // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 10;                                                                            // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝
	
	String pageTitle = "FAQ(자주하는 질문) 관리";
	String writeYn = "Y";

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

	paramData.put("기업코드",       sseGroupCd   );
	paramData.put("법인코드",       sseCorpCd   ); 
	paramData.put("브랜드코드",       sseBrandCd   );
	paramData.put("조회시작일자",    StartDate   );
	paramData.put("조회종료일자" ,   EndDate    );
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 자료에 대한 처리
	//-------------------------------------------------------------------------------------------------------
	faqBean bean = null;                                                         //자주하는질문내역 목록용
	faqDao  dao  = new faqDao();
	ArrayList<faqBean> list = null;
	
	list       = dao.selectFaqList(paramData);                      //조회조건에 맞는 이벤트 리스트
	inTotalCnt = dao.selectFaqListCount(paramData);                 //전체레코드 수
	//-------------------------------------------------------------------------------------------------------

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
	$(document).ready(function()
	{ 
		getCurrent();
		fnCalendar();

		var f = document.formdata;
 		var v_searchWord = 	f.search_word.value;		    
		f.srch_type.value  = f.search_type.value;
		f.srch_key.value   = encodeURIComponent(v_searchWord);
		//f.inCurPage.value  = "1";
		//f.inCurBlock.value = "1";		
	});
	
	$(function(){
		$("#btn-left").hover(function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		},function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		});
	});

	//글 목차이동
	function goPage(page, block) 
 	{
 	    var f = document.formdata;	

 	    f.inCurPage.value  = page;        
	    f.inCurBlock.value = block; 
	    f.srch_type.value = f.search_type.value;                      // 검색타입
	    f.srch_key.value  = encodeURIComponent(f.search_word.value);  // 검색어  
 	    f.submit();                                                   // submit() 로 처리를 해야 한다.....
	}
	
    function search_list() {
		var f = document.formdata;
		var v_searchWord = 	f.search_word.value;
		
		f.srch_type.value  = f.search_type.value;
		f.srch_key.value   = encodeURIComponent(v_searchWord);
	    f.inCurPage.value  = "1";
	    f.inCurBlock.value = "1"; 
    }
    
    function goView(pageGb, dataGb, seqNo)
	{
		var f=document.formdata;
		f.action = "maintain-faq-new.jsp?pageGb=" + pageGb 
		                             + "&dataGb=" + dataGb 
		                             + "&seqNo="  + seqNo;
		f.submit();
	}
    
	function fnWriteFaq(pageGb, dataGb, seqNo)
	{
		var f=document.formdata;

		f.action = "<%=root%>/admin-page/maintain-faq-new.jsp?pageGb=" + pageGb 
		                             + "&dataGb=" + dataGb 
		                             + "&seqNo="  + seqNo;
		f.submit;
	}

	function fnDeleteFaq(pageGb, dataGb, seqNo)
	{
		if (confirm("삭제하시겠습니까?")) {
			//------------------------------------------------------------------------------------------
			//  질문번호 조립 (Interface 영역)
			//------------------------------------------------------------------------------------------
			document.formdata.pFAQ_NO.value = seqNo;

			//------------------------------------------------------------------------------------------
			//  FAQ관리에 대한  삭제처리 함수 호출 (삭제처리)
			//------------------------------------------------------------------------------------------
			fn_update_delete_proc();
			//------------------------------------------------------------------------------------------
		}
		
	}

	//--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 수정 및 삭제처리 
    //--------------------------------------------------------------------------------------------
	function fn_update_delete_proc() 
	{
		var f=document.formdata;

		f.action = "<%=root%>/admin-page/maintain-faq-del-ok.jsp";
		f.target = "iWorker";
		f.submit;
	}

    //--------------------------------------------------------------------------------------------
    //  FAQ관리 삭제 처리 결과 확인 (maintain-faq-del-ok.jsp 에서 호출됨)
    //--------------------------------------------------------------------------------------------
	function fn_update_delete_return(msg) 
	{
		if (msg == "Y") {
			alert("정상적으로 처리되었습니다.");

		  	location.href= "<%=root%>/admin-page/maintain-faq.jsp?pageGb=faq"
												              + "&sDate=<%=StartDate%>"
												              + "&eDate=<%=EndDate%>"
												              + "&inCurPage=<%=inCurPage%>";
		} else {
			alert("저장실패");
		}
	}
	

	function xxx() 
	{ 
		// fnDeleteFaq (이전버전)
		if (confirm("삭제하시겠습니까?")) {
			document.formdata.질문번호.value = seqNo;
			
			$.ajax(
					{
						url      : "<%=root%>/admin-page/maintain-faq-del-ok.jsp", 
						type     : "POST",
						data     : $("#formdata").serialize(), 
						dataType : "html", 
						success  : function(data)
								   {  
									   if( trim(data) == "Y" )
									   { 
										    alert("정상적으로 처리가 되었습니다...");
										  	location.href= "<%=root%>/admin-page/maintain-faq.jsp";
						           	   }else if( trim(data) == "N" ){
								   
											alert("삭제 실패!!!!"); 
						           	   }
					               }
				    });
		}
	}
	
	//공백제거
	function trim(s) 
	{
		s += ''; // 숫자라도 문자열로 변환
		return s.replace(/^\s*|\s*$/g, '');
	}

    </script>
</head>

<script for=window event=onload>
	document.formdata.search_type.value = "<%=srch_type%>";            // 검색타입
	document.formdata.search_word.value = "<%=srch_key%>";             // 검색어
</script>

<body>
	<form id="formdata" name="formdata" method="POST">
 	<div id="wrap" >
		<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
		<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
		<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
		<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
		<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
		<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->
		<input type="hidden" name="listNum"        id="listNum"        value="<%=listNum %>"        >  <!-- 게시판 번호 -->

	    <input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb%>">  
	    <input type="hidden" name="pCORP_CD"       id="pCORP_CD"       value="<%=sseGroupCd%>">  
		<input type="hidden" name="pCRPN_CD"       id="pCRPN_CD"       value="<%=sseCorpCd%>"	>  
		<input type="hidden" name="pBRND_CD"       id="pBRND_CD"       value="<%=sseBrandCd%>" > 
	    <input type="hidden" name="pFAQ_NO"        id="pFAQ_NO"        value="">
	      
		<section class="header-bg">
			<!-- header include-->
			<script type="text/javascript">	$(".header-bg").load("../include/admin-header.jsp"); </script>
		</section>
		<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
	 	</section>
 		  <section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>admistrator service &gt; <%=pageTitle%></span></h1>
 		 		<div class="search-d">
		    		<span><button class="newSubmitBtn" onclick="fnWriteFaq('<%=pageGb%>','new',0);">신규</button></span>
		  		</div>
 		 	</header>
 		 	
 		 	<div id="cont-admin">
 		 		<div class="cont-nav">
 		 			<ul class="admin-menu">
 		 				<li ><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=01">공지사항관리</a></li>
 		 				<li ><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=02">교육자료관리</a></li>
 		 				<li ><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=11">건의사항관리</a></li>
 		 				<li ><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=12">요청사항관리</a></li>
 		 				<li class="<%=active5%>"><a href="<%=root%>/admin-page/maintain-faq.jsp?pageGb=faq">FAQ관리</a></li>
 		 				<li ><a href="<%=root%>/admin-page/maintain-comment.jsp?pageGb=comment">댓글관리</a></li>
 		 				<li ><a href="<%=root%>/prom_mnt/maintain-prom-cd.jsp?pageGb=prom">홍보물관리</a>
 		 					<ul class="submenu">
								<li><a href="<%=root%>/prom_mnt/maintain-prom-cd.jsp?pageGb=prom">홍보물코드관리</a></li>
								<li><a href="<%=root%>/prom_mnt/maintain-prom-dtl.jsp?pageGb=prom">홍보물상세관리</a></li>
								<li><a href="<%=root%>/prom_mnt/maintain-prom-ord-list.jsp?pageGb=prom">주문내역확인</a></li>
							</ul>
 		 				</li>
 		 			</ul>
 		 		</div>
 		 		<!-- <img alt="ex" src="assets/images/admin-ex.png" width="960" height="500" align="middle"> -->
 		 		<div id="cont-list" class="list list-wide">
 		 			<p>▶ 검색 된 게시물 <span><%=inTotalCnt%></span>개</p>
 		 			<table>
			  			<col width="6%" />
			    		<col width="*"/>
			    		<col width="13%"/>
			    		<col width="12%"/>
			    		<col width="8%"/>
			    		<col width="11%"/>
			    		<thead>
			    			<tr>
			      				<th>번호</th>
			        			<th>질문 및 답변내용</th>
			        			<th>작성자</th>
			        			<th>등록일</th>
			        			<th>조회수</th>
			        			<th>편집</th>
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
					bean = (faqBean) list.get(i);
					
					inSeq = inTotalCnt - ((inCurPage-1)*inRowPerPage);
		%>
		      				<tr>
		      					<td><%=bean.get질문번호()%></td>
		      					<td class="subject"><a href="JavaScript:goView('<%=pageGb%>','modify','<%=bean.get질문번호()%>');">Q:<%=JSPUtil.chkNull(bean.get질문내용())%><br>
		      					                    A:<span id="faq-answer"><%=JSPUtil.chkNull(bean.get답변내용())%></span></a></td>
		        				<td><%=bean.get등록자()%></td>
		        				<td><%=bean.get등록일자()%></td>
		        				<td><%=bean.get조회수()%></td>
			        			<td>
			        				<button class="deleteBtn" onclick="fnDeleteFaq('<%=pageGb%>','delete','<%=bean.get질문번호()%>');">삭제</button>
			        				<button class="modifyBtn" onclick="fnWriteFaq('<%=pageGb%>','modify','<%=bean.get질문번호()%>');">수정</button>
			        			</td>
		      				</tr>
		<%
					inSeq--;
				}
			} 
			else 
			{
		%>
			      			<tr>
			      				<td colspan="6">조회된 내용이 없습니다.</td>
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
					        <li class="last"><a href="#">2</a></li>
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
			  		
			  		<!-- 글검색 -->
			  		<div id="search-option">
			    		<label for="select_search" class="hidden">검색구분</label>
			    		<select id="search_type" name="search_type" style="height:20px; width:80px;">
			    			<option value="0">전체</option>
			    			<option value="title">질문내용</option>
			    			<option value="content">답변내용</option>
			    			<option value="writer">작성자</option>
			    		</select>
			    		<label for="search_word" class="hidden">검색어</label>
			    		<input type="text" id="search_word" name="search_word" value="" style="width:180px;" />
			    		<span><button class="searchBtn" onclick="search_list();">검색</button></span>
			  		</div>
 		 		</div>
 		 	</div><!-- end of cont-admin -->
 		 	
 		</section>

	 	
	 	</div>
	 	<div class="overlay-bg">
	 		<img id="loadingImage" src="http://i1.daumcdn.net/cfs.tistory/resource/315/blog/plugins/lightbox/images/loading.gif" style="position: relative; cursor: pointer; top: 340px; left: 477px;display: none; ">
	 	</div>
	</form>
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>