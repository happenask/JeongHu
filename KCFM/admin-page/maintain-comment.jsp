
<!-- 
/** ############################################################### */
/** Program ID   : maintain-comment.jsp                             */
/** Program Name : maintain-comment	       						    */
/** Program Desc : 관리자 - 댓글 관리 									*/
/** Create Date  : 2015.04.14						              	*/
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

<%@ page import="admin.beans.commentBean" %> 
<%@ page import="admin.dao.commentDao" %>

<%@ include file="/com/common.jsp"%>

<%

	String root = request.getContextPath();

	String QryGubun   = JSPUtil.chkNull((String)paramData.get("inqGubun"), "%");            //조회구분
	
	String listNum    = JSPUtil.chkNull((String)paramData.get("listNum")  , "");            //게시판 번호
	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb")   , "faq");         //게시판 구분
	String srch_key   = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("srch_key") , ""), "UTF-8"); //검색어
	String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type"), "0");           //검색종류
	String StartDate  = JSPUtil.chkNull((String)paramData.get("sDate"), "");                //조회시작일자
	String EndDate    = JSPUtil.chkNull((String)paramData.get("eDate"), "");                //조회종료일자
	
// 	String pageGb = new String(request.getParameter("pageGb").getBytes("8859_1"),"UTF-8");
	// Session 정보
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sseStoreCd   = JSPUtil.chkNull((String)session.getAttribute("sseStoreCd")  ,""); //매장코드
	String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm")   ,""); //등록자명
	String sseCustId    = JSPUtil.chkNull((String)session.getAttribute("sseCustId")   ,""); //등록자ID
	String sseStroeNm   = JSPUtil.chkNull((String)session.getAttribute("sseStroeNm")  ,""); //매장명

	int    v_MainPage  = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inMainPage"),  "1"));        // 이동된 현재 페이지
	
	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 6;      //10                                                                  // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 10;      //10                                                                  // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝
	
	String pageTitle = "자주하는질문내역";
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

	System.out.println(">>>>> [jsp] QryGubun [" + QryGubun + ']' );
	System.out.println(">>>>> [jsp] inCurPage [" + inCurPage + ']' );
	
	paramData.put("기업코드",       sseGroupCd   );
	paramData.put("법인코드",       sseCorpCd    );
	paramData.put("조회구분",       QryGubun    );
	paramData.put("조회시작일자",    StartDate   );
	paramData.put("조회종료일자" ,   EndDate    );
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 자료에 대한 처리
	//-------------------------------------------------------------------------------------------------------
	commentBean bean = null;                                                                //댓글관리
	commentDao  dao  = new commentDao();
	ArrayList<commentBean> list = null;
	
	list       = dao.selectCommentList(paramData);                      //조회조건에 맞는 이벤트 리스트
	inTotalCnt = dao.selectCommentListCount(paramData);                 //전체레코드 수
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
	    f.srch_type.value = f.search_type.value;
	    f.srch_key.value  = encodeURIComponent(f.search_word.value);

	    f.submit(); 
	}

    //--------------------------------------------------------------------------------------------
    //  파라미터 : 기업코드, 법인코드, 브랜드코드, 매장코드, 게시구분, 게시번호, 댓글번호
    //--------------------------------------------------------------------------------------------
	function goDetail(v_CORP_CD, v_CRPN_CD, v_BRND_CD, v_MEST_CD, v_GESI_GB, v_GESI_NO, v_DAGL_NO)
	{
        var url = "<%=root%>/admin-page/maintain-comment-detail.jsp?pCORP_CD=" + v_CORP_CD
                                                                + "&pCRPN_CD=" + v_CRPN_CD
                                                                + "&pBRND_CD=" + v_BRND_CD
                                                                + "&pMEST_CD=" + v_MEST_CD
                                                                + "&pGESI_GB=" + v_GESI_GB
                                                                + "&pGESI_NO=" + v_GESI_NO
                                                                + "&pDAGL_NO=" + v_DAGL_NO;  
        var objectName = new Object();
        var style = "dialogWidth:980px;dialogHeight:550px;location:yes;toolbar=no;center:yes;menubar:no;status:no;scrollbars:yes;resizable:no";

        //objectName.pCORP_CD = v_CORP_CD;
        //objectName.pCRPN_CD = v_CRPN_CD;
        //objectName.pBRND_CD = v_BRND_CD;
        //objectName.pMEST_CD = v_MEST_CD;
        //objectName.pGESI_GB = v_GESI_GB;
        //objectName.pGESI_NO = v_GESI_NO;
        //objectName.pDAGL_NO = v_DAGL_NO;

        //alert(objectName.pCORP_CD);
            
       	window.showModalDialog(url, objectName, style);

       	//document.form1.storeCount.value = objectName.storeCount;          // 모달 팝업과의 interface
	}
	//--------------------------------------------------------------------------------------------
    //  파라미터 : 기업코드, 법인코드, 브랜드코드, 매장코드, 게시구분, 게시번호, 댓글번호
    //--------------------------------------------------------------------------------------------
	function goWrite(v_CORP_CD, v_CRPN_CD, v_BRND_CD, v_MEST_CD, v_GESI_GB, v_GESI_NO, v_DAGL_NO)
	{
		//------------------------------------------------------------------------------------
		//  등록된 댓글에 대한 확인 (없는 경우 Return 처리)
		//------------------------------------------------------------------------------------
        if( v_DAGL_NO == 0 ) 
        {
            alert("등록된 댓글이 없습니다.");
            return;
        }
        //------------------------------------------------------------------------------------
        document.formdata.inMainPage.value = document.formdata.inCurPage.value;  // 이동된 페이지

        document.formdata.inCurPage.value  = 1;                    // 첫페이지 처리
        document.formdata.pCORP_CD.value   = v_CORP_CD;            // 기업코드
        document.formdata.pCRPN_CD.value   = v_CRPN_CD;            // 법인코드
        document.formdata.pBRND_CD.value   = v_BRND_CD;            // 브랜드코드
        document.formdata.pMEST_CD.value   = v_MEST_CD;            // 매장코드
        document.formdata.pGESI_GB.value   = v_GESI_GB;            // 게시구분
        document.formdata.pGESI_NO.value   = v_GESI_NO;            // 게시번호
        document.formdata.pDAGL_NO.value   = v_DAGL_NO;            // 댓글번호

        //alert(document.formdata.pCORP_CD.value);
        //alert(document.formdata.pCRPN_CD.value);
        //alert(document.formdata.pBRND_CD.value);
        //alert(document.formdata.pMEST_CD.value);
        //alert(document.formdata.pGESI_GB.value);
        //alert(document.formdata.pDAGL_NO.value);
                    
		var f=document.formdata;

		f.action = "<%=root%>/admin-page/maintain-comment-edit.jsp";
		f.submit;
	}

	function search_list() 
	{
		var f = document.formdata;
		var v_searchWord = 	f.search_word.value;
		
		f.srch_type.value  = f.search_type.value;
		f.srch_key.value   = encodeURIComponent(v_searchWord);
	    f.inCurPage.value  = "1";
	    f.inCurBlock.value = "1"; 
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
	
	
    </script>
</head>

<script for=window event=onload>
	document.formdata.inqGubun.value = "<%=QryGubun%>";
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
		<input type="hidden" name="inMainPage" 	   id="inMainPage"      value="<%=v_MainPage%>"		>  <!-- 이동된 현재 페이지 -->
	    <input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb%>">   
	    <input type="hidden" name="pCORP_CD"       id="pCORP_CD"       value="<%=sseGroupCd%>">  
		<input type="hidden" name="pCRPN_CD"       id="pCRPN_CD"       value="<%=sseCorpCd%>">  
		<input type="hidden" name="pBRND_CD"       id="pBRND_CD"       value="<%=sseBrandCd%>"> 
		<input type="hidden" name="pMEST_CD"       id="pMEST_CD"       value="<%=sseStoreCd%>"> 
	    <input type="hidden" name="pGESI_GB"       id="pGESI_GB"       value="">
	    <input type="hidden" name="pGESI_NO"       id="pGESI_NO"       value="">
	    <input type="hidden" name="pDAGL_NO"       id="pDAGL_NO"       value="">
		<input type="hidden" name="pCONFIRM_YN"    id="pCONFIRM_YN"    value="%">
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("<%=root%>/include/admin-header.jsp");</script> 
	 	</section> 

		<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
	 	</section>
	 	
 		  <section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>admistrator service &gt; 댓글 관리</span></h1>
 		 	
	        	<div class="search-d">
		    		<label for="condition" > ▶ 구분 : </label>
		    		<select id="inqGubun" name="inqGubun" style="height:20px; width:100px;">
		    			<option value="%">전체</option>
		    			<option value="01">공지사항</option>
		    			<option value="02">교육자료</option>
		    			<option value="11">건의사항</option>
		    			<option value="12">요청사항</option>
		    		</select>
		    		
		    		<label for="start_search" > ▶ 등록 기간 : </label>
		    		<input class="big_0" name="sDate" type="text" value="<%=StartDate%>"/> ~ 
					<input class="big_0" name="eDate" type="text" value="<%=EndDate%>"/> 
		    		<span><button class="searchDateBtn" onclick="search_list();">조회</button></span>
		  		</div>
 		 	</header>
 		 	
 		 	<div id="cont-admin">
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
 		 		<!-- <img alt="ex" src="assets/images/admin-ex.png" width="960" height="500" align="middle"> -->
 		 		<div id="cont-list" class="list list-wide">
 		 			<p>▶ 검색 된 글 <span><%=inTotalCnt%></span>개</p>
 		 			<table>
			  			<col width="6%" />
			    		<col width="10%"/>
			    		<col width="*"/>
			    		<col width="10%"/>
			    		<col width="10%"/>
			    		<col width="10%"/>
			    		<col width="6%"/>
			    		<thead>
			    			<tr>
			      				<th>번호</th>
			      				<th>구분</th>
			        			<th>제목</th>
			        			<th>작성자</th>
			        			<th>등록일</th>
			        			<th>상태</th>
			        			<th>기능</th>
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
			      				<td><%=bean.get게시번호()%></td>       
			      				<td><%=bean.get게시구분()%></td>       
			        			<td  class="subject"><a href="JavaScript:goDetail('<%=bean.get기업코드()%>'
			        				                                        	 ,'<%=bean.get법인코드()%>'
			        				                                      		 ,'<%=bean.get브랜드코드()%>'
			        				                                             ,'<%=bean.get매장코드()%>'
			        				                                         	 ,'<%=bean.get게시구분코드()%>'
			        				                                         	 ,'<%=bean.get게시번호()%>'
			        				                                         	 ,'<%=bean.get댓글번호()%>')"><%=bean.get제목()%><br>
			        						<% if(bean.get댓글번호().equals("0"))
			        						   {
			        					    %>
			        					    		<br>
			        					    		<br>
			        			            <% } else 
			        			               { 
			        			            %>
			        			                     <span id="last-comment-title">마지막 등록 댓글입니다..</span><br>
			        			                     <span class="list_textLine" id="last-comment" >(<%=bean.get댓글등록일자()%> - <%=bean.get댓글등록자()%>) <%=bean.get댓글내용()%></span>		        			            
			        			            <% }
			        						%>         
			        			                     </a>
			        			</td>
			        			<td><%=bean.get등록자()%></td>
			        			<td><%=bean.get등록일자()%></td>
		        			<% if(bean.get상태().equals("답변대기")) { %>
			        			<td><font color="ff0000"><%=bean.get상태()%></font></td>
		        			<%} else if(bean.get상태().substring(0,4).equals("확인대기")){ %>
			        			<td><a href="JavaScript:fnShowStoreList('<%=bean.get게시구분코드()%>'
			        			                                       ,'<%=bean.get게시번호()%>');"><font color="ff0000"><%=bean.get상태()%></font></a></td>
		        			<%} else if(bean.get상태().substring(0,4).equals("확인완료")){ %>
			        			<td><a href="JavaScript:fnShowStoreList('<%=bean.get게시구분코드()%>'
			        			                                       ,'<%=bean.get게시번호()%>');"><font color="000000"><%=bean.get상태()%></font></a></td>
		        			<%} else { %>
			        			<td><%=bean.get상태()%></td>
		        			<%} %>
			        			<td>
			        				<button class="editBtn" onclick="goDetail('<%=bean.get기업코드()%>'
			        				                                         ,'<%=bean.get법인코드()%>'
			        				                                         ,'<%=bean.get브랜드코드()%>'
			        				                                         ,'<%=bean.get매장코드()%>'
			        				                                         ,'<%=bean.get게시구분코드()%>'
			        				                                         ,'<%=bean.get게시번호()%>'
			        				                                         ,'<%=bean.get댓글번호()%>');">관리</button>
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
			  		
			  		<!-- 글검색 -->
			  		<div id="search-option">
			    		<label for="select_search" class="hidden">검색구분</label>
			    		<select id="search_type" name="search_type" style="height:20px; width:80px;">
			    			<option value="0">전체</option>
			    			<option value="title">제목</option>
			    			<option value="content">내용</option>
			    			<option value="writer">작성자</option>
			    		</select>
			    		<label for="search_word" class="hidden">검색어</label>
			    		<input type="text" id="search_word" name="search_word" value="" style="width:180px;" />
			    		<span><button class="searchBtn" onclick="search_list();">검색</button></span>
			  		</div>
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
</html>