
<!-- 
/** ############################################################### */
/** Program ID   : maintain-comment-edit.jsp                        */
/** Program Name : maintain-comment-edit                            */
/** Program Desc : 관리자 - 덧글 관리 상세		                        */
/** Create Date  : 2015.04.14						              	*/
/** Update Date  :                                                  */
/** Programmer   : JHYOUN                                           */
/** ############################################################### */
 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.BoardConstant" %>

<%@ page import="admin.beans.commentBean" %> 
<%@ page import="admin.dao.commentDao" %>

<%@ include file="/com/common.jsp"%>

<%

	String root = request.getContextPath();

	String listNum    = JSPUtil.chkNull((String)paramData.get("listNum"),   ""); //게시판 번호
	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb"),    ""); //게시판 구분
	String srch_key   = JSPUtil.chkNull((String)paramData.get("srch_key") , ""); //검색어
	String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type"), ""); //검색종류
	
	// Session 정보
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sseStoreCd   = JSPUtil.chkNull((String)session.getAttribute("sseStoreCd")  ,""); //매장코드
	String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm")   ,""); //등록자명
	String sseCustId    = JSPUtil.chkNull((String)session.getAttribute("sseCustId")   ,""); //등록자ID
	String sseStroeNm   = JSPUtil.chkNull((String)session.getAttribute("sseStroeNm")  ,""); //매장명


	// Parameter 인터페이스 (화면간 데이터 Interface-영문으로 사용해야 함)
	String v_INQ_GB    = JSPUtil.chkNull((String)paramData.get("inqGubun"  ),"%"); //조회구분 (목록으로 갈때 사용)
	String StartDate   = JSPUtil.chkNull((String)paramData.get("sDate"), "");      //조회시작일자
	String EndDate     = JSPUtil.chkNull((String)paramData.get("eDate"), "");      //조회종료일자
	String v_CORP_CD   = JSPUtil.chkNull((String)paramData.get("pCORP_CD"  ),"");  //기업코드
	String v_CRPN_CD   = JSPUtil.chkNull((String)paramData.get("pCRPN_CD"  ),"");  //법인코드
	String v_BRND_CD   = JSPUtil.chkNull((String)paramData.get("pBRND_CD"  ),"");  //브랜드코드
	String v_MEST_CD   = JSPUtil.chkNull((String)paramData.get("pMEST_CD"  ),"");  //매장코드
	String v_GESI_GB   = JSPUtil.chkNull((String)paramData.get("pGESI_GB"  ),"");  //게시구분
	String v_GESI_NO   = JSPUtil.chkNull((String)paramData.get("pGESI_NO"  ),"");  //게시번호
	
	int    v_MainPage  = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inMainPage"),  "1"));  // 이동된 현재 페이지
	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 6;      //10                                                                  // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 6;      //10                                                                  // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝
	
	//String pageTitle = "자주하는질문내역";
	//String writeYn = "Y";

	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	System.out.println(">>>>> inqGubun [" + v_INQ_GB + "]");
	
	//System.out.println(">>>>> [jsp] 기업코드   [" + v_CORP_CD + "]" );
	//System.out.println(">>>>> [jsp] 법인코드   [" + v_CRPN_CD + "]" );
	//System.out.println(">>>>> [jsp] 브랜드코드 [" + v_BRND_CD + "]" );
	//System.out.println(">>>>> [jsp] 매장코드   [" + v_MEST_CD + "]" );
	//System.out.println(">>>>> [jsp] 게시구분   [" + v_GESI_GB + "]" );
	//System.out.println(">>>>> [jsp] 게시번호   [" + v_GESI_NO + "]" );
	
	paramData.put("기업코드",       v_CORP_CD   );
	paramData.put("법인코드",       v_CRPN_CD    );
	paramData.put("브랜드코드",     v_BRND_CD   );
	paramData.put("매장코드",       v_MEST_CD   );
	paramData.put("게시구분",       v_GESI_GB     );
	paramData.put("게시번호",       v_GESI_NO     );
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 자료에 대한 처리
	//-------------------------------------------------------------------------------------------------------
	commentBean bean = null;                                            //댓글관리
	commentDao  dao  = new commentDao();
	ArrayList<commentBean> list = null;
	
	list       = dao.selectCommentDetail(paramData);                    //조회조건에 맞는 댓글상세내역 조회
	inTotalCnt = dao.selectCommentDetailCount(paramData);               //전체레코드 수
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
%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=9" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	<meta name="keywords" content="" /><!-- 검색용 키워드 -->
 	<meta name="description" content="스쿨푸드 PRM 서비스입니다." /><!-- 페이지 설명 -->
    
	<title>KCFM 관리자</title>  
		
	<link href="../assets/css/common.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.9.2/themes/base/jquery-ui.css" />
	
	<!-- IE8 이하에서 미디어 쿼리(Media Query) 사용 지원 -->
	<!--[if lt IE 9]><script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
    <!-- IE 8 이하에서 HTML5 태그 지원하도록 스크립트 링크 -->
    <!--[if lt IE 9]><script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script><![endif]-->
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
	<script type="text/javascript" src="http://code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
	<script type="text/javascript" src="../assets/js/jquery.ui.datepicker-ko.js"></script>
	<script type="text/javascript" src="../assets/js/calendar.js"></script><!-- 달력 시작일, 종료일 세팅 -->
    <script type="text/javascript" src="../assets/js/style.js"></script>
    
    <script type="text/javascript">
	$(document).ready(function()
	{ 
		getCurrent();
		//fnCalendar();
		
		//리스트에서 선택한 글 넘버 
		var no = getParameter("inqSeqno");
		//var gb = getParameter("Gb");
		console.log(no);
		
		$(".no").text(no);
	});
	
	$(function(){
		$("#btn-left").hover(function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		},function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		});
	});
    
	//html 파라미터 전달
	getNo = function(no){
		
	}

	//글 목차이동
	function goPage(page, block) 
 	{
 	    var f = document.formdata;	
	    f.inCurPage.value  = page;        
	    f.inCurBlock.value = block; 
 	    f.submit();
	}
	
    //--------------------------------------------------------------------------------------------
    //  댓글관리 목록으로 이동 
    //--------------------------------------------------------------------------------------------
	function goList()
	{
		var inqGubun = document.formdata.inqGubun.value;

		location.href= "<%=root%>/admin-page/maintain-comment.jsp?pageGb=comment"
                                                              + "&inqGubun=" + inqGubun
                                                              + "&sDate=<%=StartDate%>"
                                                              + "&eDate=<%=EndDate%>"
                                                              + "&inCurPage=<%=v_MainPage%>";
	}

    //--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 수정처리 ▷ 파라미터 : 댓글번호, 댓글내용 
    //--------------------------------------------------------------------------------------------
	function goSave(v_MEST_CD, v_DAGL_NO)
	{
    	//------------------------------------------------------------------------------------------
		//  입력항목 체크
		//------------------------------------------------------------------------------------------
		if (trim(document.getElementById("댓글내용"+v_DAGL_NO).value) == "" 
		||  trim(document.getElementById("댓글내용"+v_DAGL_NO).value) == "null") {
			alert("댓글내용을 입력해 주세요");
			
			document.getElementById("댓글내용"+v_DAGL_NO).focus();
			 
			return;
		} 
		//------------------------------------------------------------------------------------------
		//  처리대상 댓글번호 및 댓글내용 조립 (Interface 영역)
		//------------------------------------------------------------------------------------------
		document.formdata.dataGb.value     = "modify";
		document.formdata.pMEST_CD.value   = v_MEST_CD;
		document.formdata.pDAGL_NO.value   = v_DAGL_NO;
		document.formdata.pDAGL_STMT.value = trim(document.getElementById("댓글내용"+v_DAGL_NO).value); 
		//------------------------------------------------------------------------------------------
		//  댓글관리 상세내역에 대한 수정 및 삭제처리 함수 호출 (수정처리)
		//------------------------------------------------------------------------------------------
		fn_update_delete_proc();
		//------------------------------------------------------------------------------------------
	}
	
    //--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 삭제처리 ▷  파라미터 : 댓글번호 
    //--------------------------------------------------------------------------------------------
	function goDelete(v_MEST_CD, v_DAGL_NO)
	{
		var msg;
		
		if (confirm("삭제하시겠습니까?")) {
			//------------------------------------------------------------------------------------------
			//  처리대상 댓글번호 및 댓글내용 조립 (Interface 영역)
			//------------------------------------------------------------------------------------------
			document.formdata.dataGb.value   = "delete";
			document.formdata.pMEST_CD.value = v_MEST_CD;
			document.formdata.pDAGL_NO.value = v_DAGL_NO;
			//------------------------------------------------------------------------------------------
			//  댓글관리 상세내역에 대한 수정 및 삭제처리 함수 호출 (삭제처리)
			//------------------------------------------------------------------------------------------
			fn_update_delete_proc();
			//------------------------------------------------------------------------------------------
		} else {
			return;
			//alert("else >>>>>>>> 1111");
		}
	}

	//--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 수정 및 삭제처리 
    //--------------------------------------------------------------------------------------------
	function fn_update_delete_proc() 
	{
		var f=document.formdata;

		f.action = "<%=root%>/admin-page/maintain-comment-edit-ok.jsp";
		f.target = "iWorker";
		f.submit;
	}

    //--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 수정 및 삭제 처리 결과 확인 (maintain-comment_edit-ok.jsp 에서 호출됨)
    //--------------------------------------------------------------------------------------------
	function fn_update_delete_return(inqGubun, msg) 
	{
		if (msg == "Y") {
			alert("정상적으로 처리되었습니다.");

			location.href= "<%=root%>/admin-page/maintain-comment-edit.jsp?inqGubun=<%=v_INQ_GB%>"
													                   + "&sDate=<%=StartDate%>"
														               + "&eDate=<%=EndDate%>"
				                                                       + "&inMainPage=<%=v_MainPage%>"
					                                                   + "&pCORP_CD=<%=v_CORP_CD%>"
																       + "&pCRPN_CD=<%=v_CRPN_CD%>"
																       + "&pBRND_CD=<%=v_BRND_CD%>"
																       + "&pMEST_CD=<%=v_MEST_CD%>"
																       + "&pGESI_GB=<%=v_GESI_GB%>"
																       + "&pGESI_NO=<%=v_GESI_NO%>";
		} else {
			alert("저장실패");
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
	document.formdata.inqGubun.value = "<%=v_INQ_GB%>";
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

		<input type="hidden" name="inMainPage" 	   id="inMainPage"      value="<%=v_MainPage%>"		>  <!-- 이동된 현재 페이지 -->

	    <input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb%>">   
	    <input type="hidden" name="dataGb"         id="dataGb"         value="">   
	    <input type="hidden" name="inqGubun"       id="inqGubun"       value="<%=v_INQ_GB%>">  
	    <input type="hidden" name="pCORP_CD"       id="pCORP_CD"       value="<%=v_CORP_CD%>">  
		<input type="hidden" name="pCRPN_CD"       id="pCRPN_CD"       value="<%=v_CRPN_CD%>">  
		<input type="hidden" name="pBRND_CD"       id="pBRND_CD"       value="<%=v_BRND_CD%>"> 
		<input type="hidden" name="pMEST_CD"       id="pMEST_CD"       value="<%=v_MEST_CD%>"> 
	    <input type="hidden" name="pGESI_GB"       id="pGESI_GB"       value="<%=v_GESI_GB%>">
	    <input type="hidden" name="pGESI_NO"       id="pGESI_NO"       value="<%=v_GESI_NO%>">
	    <input type="hidden" name="pDAGL_NO"       id="pDAGL_NO"       value="">
	    <input type="hidden" name="pDAGL_STMT"     id="pDAGL_STMT"     value="">
	 	<section class="header-bg">
	 	<div id="header">
	 		<header>
	 			<h1>헤더-타이틀</h1>
	 			<span id="logo">유니포스-로고</span>
	 			<span id="btns">
	 				<input type="button" id="logout-btn" class="rd-bord-btn" value="로그아웃" class="button" onclick="location.href='../index.jsp'">
	 				<input type="button" id="main-btn" class="nv-bord-btn" value="메인으로 이동" class="button" onclick="location.href='../main.html'">
	 				<input type="button" id="account" class="rd-bord-btn" value="정보수정 ▶" class="button" onclick="">
	 				</span>
	 			
	 				<div class="gnb">
	 					<div id="currentTime">현재 날짜<span> 현재 시간</span></div>
	 				</div>
	 		</header>
	 		</div>
	 	</section>
	 	
 		  <section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>admistrator service &gt; 댓글 관리</span></h1>
 		 	</header>
 		 	
 		 	<div id="cont-admin">
 		 		<div class="cont-nav">
 		 			<ul class="admin-menu">
 		 				<li><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=01">공지사항관리</a></li>
 		 				<li><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=02">교육자료관리</a></li>
 		 				<li><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=11">건의사항관리</a></li>
 		 				<li><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=12">요청사항관리</a></li>
 		 				<li><a href="<%=root%>/admin-page/maintain-faq.jsp?pageGb=faq">FAQ관리</a></li>
 		 				<li class="active"><a href=<%=root%>/admin-page/maintain-comment.jsp?pageGb=comment&inqGubun=<%=v_INQ_GB%>>댓글관리</a></li>
 		 				<li><a href="#">홍보물관리</a>
 		 					<ul class="submenu">
								<li><a href="<%=root%>/admin-page/maintain-prom-cd.jsp?pageGb=prom">홍보물코드관리</a></li>
								<li><a href="<%=root%>/admin-page/maintain-prom-detail.jsp?pageGb=prom">홍보물상세관리</a></li>
								<li><a href="<%=root%>/admin-page/maintain-prom-list.jsp?pageGb=prom">주문내역확인</a></li>
							</ul>
 		 				</li>
 		 			</ul>
 		 		</div>
 		 		<!-- <img alt="ex" src="assets/images/admin-ex.png" width="960" height="500" align="middle"> -->
 		 		<div id="cont-list" class="list list-wide">
 		 			<p>▶ <span class="no"></span><%=v_GESI_NO%>번 <span style="font-weight: bold;">"게시된 원문의 제목입니다!! "</span> 글에 대한 댓글 총 <%=inTotalCnt%>건<span style="float: right;"><button class="originalBtn" onclick="alert('해당 원문 조회하여 보여주기');">원문조회</button></span></p>
 		 			<table>
			  			<col width="15%"/>
			  			<col width="15%"/>
			    		<col width="*"/>
			    		<col width="15%"/>
			    		<col width="18%"/>
			    		<thead>
			    			<tr>
			        			<th>매장</th>
			        			<th>작성자</th>
			        			<th>댓글</th>
			        			<th>등록일</th>
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
					bean = (commentBean) list.get(i);
					
					inSeq = inTotalCnt - ((inCurPage-1)*inRowPerPage);
		%>
		      				<tr>
        						<% if(bean.get댓글등록자().equals(sseCustNm))
        						   {
        					    %>
			      				<td><%=bean.get매장명()%></td>       
			      				<td><%=bean.get댓글등록자()%></td>       
			      				<td class="subject"><textarea  class="edit admin-text" id="댓글내용<%=bean.get댓글번호()%>" name="댓글내용<%=bean.get댓글번호()%>"><%=bean.get댓글내용()%></textarea></td>
			        			<td><%=bean.get댓글등록일자()%></td>
			        			<td align="center">
			        				<button class="deleteBtn" onclick="goDelete('<%=bean.get매장코드()%>','<%=bean.get댓글번호()%>');">삭제</button>
			        				<button class="modifyBtn" onclick="goSave('<%=bean.get매장코드()%>','<%=bean.get댓글번호()%>');">수정</button>
			        			</td>
        			            <% } else 
        			               { 
        			            %>
			      				<td><%=bean.get매장명()%></td>       
			      				<td><%=bean.get댓글등록자()%></td>       
			      				<td  class="subject"><%=bean.get댓글내용()%></td>
			        			<td><%=bean.get댓글등록일자()%></td>
			        			<td align="center">
			        				<button class="deleteBtn" onclick="goDelete('<%=bean.get매장코드()%>','<%=bean.get댓글번호()%>');">삭제</button>
			        			</td>
        			            <% }
        						%>         
		      				</tr>
		<%
					inSeq--;
				}
			} 
			else 
			{
		%>
			      			<tr>
			      				<td colspan="4">조회된 내용이 없습니다.</td>
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
			  		
					   	
				 		<p class="btn">
				 			<button type="button" class="golistBtn" onclick="goList();">목록</button>
				 			<!-- button type="button" class="saveBtn" onclick=";">저장</button -->
				 		</p>
 		 		</div>
 		 	</div><!-- end of cont-admin -->
 		 	
 		</section>
 	
 		<!-- modal popup -->
	 	<div class="overlay-bg-half">
	 			 	<!-- 정보 변경 패널 -->
	 	<!-- <section id="info-panel">
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
	 	 -->
	 	
	 	</div>
	 	<div class="overlay-bg">
	 		<img id="loadingImage" src="http://i1.daumcdn.net/cfs.tistory/resource/315/blog/plugins/lightbox/images/loading.gif" style="position: relative; cursor: pointer; top: 340px; left: 477px;display: none; ">
	 	</div>
 	</div><!-- wrap end -->
 </form>
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>