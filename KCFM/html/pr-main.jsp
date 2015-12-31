<!-- 
/** ############################################################### */
/** Program ID   :   pr-main.jsp      								*/
/** Program Name :   promotion home	   						        */
/** Program Desc :   홍보물 페이지 메인 (매장주문내역)				*/
/** Create Date  :   2015.04.22						              	*/
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="main.dao.mainDao" %>
<%@ page import="main.beans.mainBean" %>
<%@ page import="com.util.BoardConstant" %>
<%@ page import="java.net.URLDecoder" %>
<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /promotion/pr-main.jsp");

	//####################################################################################################Parameter 처리 시작
	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("사용자ID"  , (String)session.getAttribute("sseCustId"));
	paramData.put("사용자명"  , (String)session.getAttribute("sseCustNm"));
	paramData.put("권한코드"  , (String)session.getAttribute("sseCustAuth"));
	paramData.put("매장코드"  , (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("매장명"    , (String)session.getAttribute("sseCustStoreNm"));
	
	String CustPassWd         = (String)session.getAttribute("sseCustPassWd");
	String CustStoreNm        = (String)session.getAttribute("sseCustStoreNm");
	String CustNm             = (String)session.getAttribute("sseCustNm");
	String CustTelNo          = (String)session.getAttribute("sseCustTelNo");
	String CustHpNo           = (String)session.getAttribute("sseCustHpNo");
	String SvCustNm           = (String)session.getAttribute("sseSvCustNm");
	String SvTelNo            = (String)session.getAttribute("sseSvTelNo");
	
	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb"),   "01"); //게시판 구분(없으면 공지사항관리)
	
	String listNum    = JSPUtil.chkNull((String)paramData.get("listNum"),   "0"); //게시판 번호
	String srch_key   = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("srch_key") , ""), "UTF-8"); //검색어
	String srch_type  = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("srch_type"), "0"), "UTF-8"); //검색종류
	//####################################################################################################Parameter 처리 끝

	
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 10;                                                                            // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 10;                                                                            // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝

	
	//####################################################################################################java 처리 시작
	mainBean bean    = null; //리스트 데이타에서 담을 빈
	mainDao  mainDao = new mainDao();
	
	ArrayList<mainBean> list = null;

	list = mainDao.selectStoreOrderList(paramData); //매장주문내역
	inTotalCnt = mainDao.selectStoreOrderCount(paramData); //전체 레코드 수
	
	//####################################################################################################java 처리 끝
	
	
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
<!-- 공용정의파일 -->
<%@ include file="/include/common_file.inc" %>
	<title>KCFM 업체</title>  
    
    <script type="text/javascript">
	$(document).ready(function()
	{ 
	});
	
	$(function(){
		$("#btn-left").hover(function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		},function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		});
	});

	//글 상세보기
	function goView(eventcd)
	{		
		var f = document.form1;			
	    f.srch_key.value  = encodeURIComponent(f.search_key.value);  // 검색어  
 		document.getElementById("listNum" ).value = eventcd; //게시판 번호		
 		f.action = "<%=root%>/admin-page/admin-detail-view.jsp";
		f.submit();	 
	}
	
	//글 목차이동
	function goPage(page, block) 
 	{
 	    var f = document.form1;
	    f.inCurPage.value  = page;        
	    f.inCurBlock.value = block;
	    f.srch_key.value   = encodeURIComponent(f.search_key.value);  // 검색어  
 	    f.submit();
	}
	
	function search_list() 
 	{
		var f = document.form1;
		var v_searchWord = 	f.search_key.value;
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
	function goView()
	{
		var f = document.form1;
    	f.action = "<%=root%>/promotion/pr-view.jsp";
    	f.submit();
	}
    </script>
</head>

<script for=window event=onload>
	document.form1.search_type.value = "<%=srch_type%>";
	document.form1.search_key.value  = "<%=srch_key%>";
</script>

<body>
 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("<%=root%>/include/pr-header.jsp"); </script> 
	 	</section>

	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
	 	</section>

		<form id="form1" name="form1" method="post">
			<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
			<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
			<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
			<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
			<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
			<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->
			<input type="hidden" name="listNum"        id="listNum"        value="<%=listNum %>"        >  <!-- 게시판 번호 -->
			<input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb %>"         >  <!-- 게시판 종류 구분 값 -->
		
			<br><br>
			
			<section class="contents admin">
				<header><h1> ◎ <span>promotion service &gt; 매장주문내역</span></h1></header>
			
				<div id="cont-list" class="list list-wide">
					<p>▶ 매장주문내역 <span><%=inTotalCnt%></span>개</p>
					
					<table>
						<col width="5%" />
						<col width="5%" />
						<col width="15%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="15%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<col width="5%" />
						<thead>
							<tr>
								<th>주문일자</th>
								<th>매장코드</th>
								<th>매장명</th>
								<th>대표자명</th>
								<th>주문번호</th>
								<th>홍보물코드</th>
								<th>홍보물번호</th>
								<th>홍보물명</th>
								<th>주문사이즈</th>
								<th>주문수량</th>
								<th>주문가격</th>
								<th>주문상태</th>
								<th>제작상태</th>
								<th>시안번호</th>
								<th>택배사코드</th>
								<th>송장번호</th>
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
					bean = (mainBean) list.get(i);
					
					inSeq = inTotalCnt - ((inCurPage-1)*inRowPerPage);
		%>
		      				<tr>
								<td><%=bean.get주문일자()%></td>
								<td><%=bean.get매장코드()%></td>
								<td><%=bean.get매장명()%></td>
								<td><%=bean.get대표자명()%></td>
								<td><a href="javascript:goView()"><%=bean.get주문번호()%></a></td>
								<td><%=bean.get홍보물코드()%></td>
								<td><%=bean.get홍보물번호()%></td>
								<td><%=bean.get홍보물명()%></td>
								<td><%=bean.get주문사이즈()%></td>
								<td><%=bean.get주문수량()%></td>
								<td><%=bean.get주문가격()%></td>
								<td><%=bean.get주문상태()%></td>
								<td><%=bean.get제작상태()%></td>
								<td><%=bean.get시안번호()%></td>
								<td><%=JSPUtil.chkNull(bean.get택배사코드(),"")%></td>
								<td><%=JSPUtil.chkNull(bean.get송장번호(),"")%></td>

		      				</tr>
		<%
					inSeq--;
				}
			} 
			else 
			{
		%>
			      			<tr>
			      				<td colspan="16">조회된 내용이 없습니다.</td>
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
			    			<option value="">전체</option>
			    			<option value="1">매장</option>
			    			<option value="2">주문자</option>
			    		</select>			    		 		
			    		<label for="search_word" class="hidden">검색어</label>
			    		<input type="text" id="search_key" name="search_key" value="" style="width:180px; " onKeyDown="if(event.keyCode==13){ searchBtn.focus(); search_list(); }"/>
			    		<span><button id = "searchBtn"class="searchBtn" onclick="search_list();">검색</button></span>
			  		</div>
					
				</div>
			</section>
			
			
		
		</form>
	</div>
</body>
</html>