<%
/** ############################################################### */
/** Program ID   : list.jsp                                         */
/** Program Name : 게시판 리스트                                    */
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
<%@ page import="com.util.BoardConstant" %>

<%@ page import="board.beans.listBean" %> 
<%@ page import="board.dao.listDao" %>

<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /list.jsp");

	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("사용자ID"  , (String)session.getAttribute("sseCustId"));
	paramData.put("사용자명"  , (String)session.getAttribute("sseCustNm"));
	paramData.put("권한코드"  , (String)session.getAttribute("sseCustAuth"));
	paramData.put("매장코드"  , (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("매장명"    , (String)session.getAttribute("sseCustStoreNm"));

	String listNum    = JSPUtil.chkNull((String)paramData.get("listNum"),   ""); //게시판 번호
	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb"),    ""); //게시판 구분
	String srch_key   = JSPUtil.chkNull((String)paramData.get("srch_key") , ""); //검색어
	String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type"), "0"); //검색종류
	
// 	String pageGb = new String(request.getParameter("pageGb").getBytes("8859_1"),"UTF-8");

	listBean bean = null; //리스트 목록용
	listDao  dao  = new listDao();
	ArrayList<listBean> list = null;
	ArrayList<listBean> listEmerg = null;
	
	//수정[X]
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
	
	String pageTitle   = "";
	String writeYn     = "";
	String noticeGb    = "";
	String hit         = "";
	String readChkList = "";
	
	//게시판 구분값에 따라 목록 조회
	if(pageGb.equals("01")){
		pageTitle = "공지 사항";
		writeYn = "N";
		
		listEmerg  = dao.selectEmergNoticeList(paramData);
		
		if( listEmerg != null && listEmerg.size() > 0 ) {
			
			bean = (listBean) listEmerg.get(0);
			listNum = bean.get게시번호();
			
			System.out.println("list.jsp================================================");
			System.out.println("listNum : " + listNum);
			System.out.println("========================================================");
			
			paramData.put("listNum", listNum);
			readChkList = "no";
			out.println("<script> alert('긴급공지에 대해 조회확인 버튼을 눌러주세요!'); </script>");
			out.println("<script>location.href='"+ root +"/board/detail_view.jsp?listNum="+ listNum + "&pageGb=" + pageGb+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&srch_key="+srch_key+"&srch_type="+srch_type+"&readChkList="+readChkList+"'</script>");
			
		}
		
 		list       = dao.selectNoticeList(paramData); //조회조건에 맞는 이벤트 리스트
 		inTotalCnt = dao.selectNoticeListCount(paramData); //전체 레코드 수
		
	}else if(pageGb.equals("02")){
		pageTitle = "교육 자료";
		writeYn = "N";
		
 		list       = dao.selectNoticeList(paramData); //조회조건에 맞는 이벤트 리스트
 		inTotalCnt = dao.selectNoticeListCount(paramData); //전체 레코드 수

	}else if(pageGb.equals("11")){
		pageTitle = "매장 건의 사항";
		writeYn = "Y";
		
 		list       = dao.selectClaimList(paramData); //조회조건에 맞는 이벤트 리스트
 		inTotalCnt = dao.selectClaimListCount(paramData); //전체 레코드 수
	}else if(pageGb.equals("12")){
		pageTitle = "매장 요청 사항";
		writeYn = "Y";

 		list       = dao.selectClaimList(paramData); //조회조건에 맞는 이벤트 리스트
 		inTotalCnt = dao.selectClaimListCount(paramData); //전체 레코드 수

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

%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/common_file.inc" %>
	<title><%=pageTitle %></title>  
	
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
    </script>

    <script type="text/javascript">
    
    	//글 상세보기
    	function goView(eventcd)
    	{
    		var frm = document.getElementById("form1");
    		
     		document.getElementById("srch_key").value = encodeURIComponent(document.getElementById("srch_key").value); //검색어 
     		document.getElementById("listNum" ).value = eventcd; //게시판 번호
    		
     		frm.action = "<%=root%>/board/detail_view.jsp";
    		frm.submit();	 
    	}
    	
    	function goWrite()
    	{
/*     		var inCurPage  = $("#inCurPage").val();
    		var inCurBlock = $("#inCurBlock").val();
    		
    		var f = document.form1; */
    		
    		if('<%=pageGb%>' == '01' || '<%=pageGb%>' == '02' ){
        		location.href= "<%=root%>/board/list_write.jsp?pageGb="+ <%=pageGb %>;
    		}else if('<%=pageGb%>' == '11' || '<%=pageGb%>' == '12' ) {
    			location.href= "<%=root%>/board/detail_write.jsp?pageGb="+ <%=pageGb %>;
    		}
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
    		var v_searchWord = 	f.search_word.value;

    		f.srch_type.value  = f.search_type.value;
    		f.srch_key.value   = encodeURIComponent(v_searchWord);
    		f.inCurPage.value  = "1";
    		f.inCurBlock.value = "1";
    		
    		f.submit();
    		
    	}
     	
     	function sleep(milliseconds) {
     	    var start = new Date().getTime();
     	    for (var i = 0; i < 1e7; i++) {
     	        if ((new Date().getTime() - start) > milliseconds) {
     	            break;
     	        }
     	    }
     	}

     	
     	function onLoadWindow()
     	{
     		var f = document.form1;

    		if ("N"=="<%=writeYn%>" ) {
         		f.writeBt.style.display = "none";
    		}
    		
    		f.search_word.value = decodeURIComponent(f.srch_key.value) ;
    		f.search_type.value = f.srch_type.value ;
    		
     	}
     	
    </script>
</head>

<script for=window event=onload>
	onLoadWindow();
</script>

<body>
 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("<%=root%>/include/header.jsp"); </script> 
	 	</section>
	 	
	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
	 	</section>
	 	
 		 <section class="contents">
 		 	<header> 
 		 		<h1>◎ <span><%=pageTitle %></span></h1>
 		 		<br><br><br>
 		 		<%
					if (pageGb.equals("11")) {
				%>
				<p>
					▶ 검색 된 글 <span><%=inTotalCnt%></span>개
				</p>
				
				<%
					} else if (pageGb.equals("12")) {
				%>
				<p>
					▶ 검색 된 요청 <span><%=inTotalCnt%></span>개
				</p>
				<%
					} else {
				%>
				<p>
					▶ 검색 된 게시물 <span><%=inTotalCnt%></span>개
				</p>
				<%
					}
				%>
 		 	</header>

	 		 	<div id="noti-section" class="list">
					
					<form id="form1" name="form1" method="post">
					<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  				   <!-- 검색어 -->
					<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
					<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
					<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
					<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
					<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->
					<input type="hidden" name="listNum"        id="listNum"        value="<%=listNum %>"        >  <!-- 게시판 번호 -->
					<input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb %>"         >  <!-- 게시판 종류 구분 값 -->

			  		<table>
    <% if("12".equals(pageGb)) { %>
    					<col width="10%" />
    <% } %>					
    					
	<% if("01".equals(pageGb)) { %>
			    		<col width="7%" />
			    		<col width="*"/>
			    		<col width="10%"/>
			    		<col width="15%"/>
			    		<col width="10%"/>
			    		<col width="10%"/>
			    		<col width="7%"/>
	<% }else{ %>
			    		<col width="10%" />
			    		<col width="*"/>
			    		<col width="15%"/>
			    		<col width="15%"/>
			    		<col width="10%"/>
	<%} %>
			    		<thead>
			    			<tr>
    <% if("12".equals(pageGb)) { %>
			      				<th>분류</th>
    <% } %>					
			      				
	<% if("01".equals(pageGb)) { %>		        			
			        			<th>번호</th>
			        			<th>제목</th>
			        			<th>작성자</th>
			        			<th>등록일</th>
			        			<th>확인여부</th>
			        			<th>확인일자</th>
			        			<th>조회수</th>
	<% }else{ %>		        			
			        			<th>번호</th>
			        			<th>제목</th>
			        			<th>작성자</th>
			        			<th>등록일</th>
			        			<th>조회수</th>
	<%} %>			        			
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
					bean = (listBean) list.get(i);
					
					inSeq = inTotalCnt - ((inCurPage-1)*inRowPerPage);
		%>
		      				<tr>
    	<% if("12".equals(pageGb)) { %>
		      					<td><%=bean.get요청구분()%></td>
		<% } %>      					
		      					<td><%=bean.get게시번호()%></td>
		      					
		<%
			// 공지사항일 경우에만 긴급/일반 구분
			if ("01".equals(pageGb)) {
				if("1".equals(bean.get공지구분()) ){
					noticeGb = "일반";
				}else if("2".equals(bean.get공지구분())){
					noticeGb = "긴급";
				}
		%>
		      					<td class="subject"><a href="JavaScript:goView('<%=bean.get게시번호()%>');">[<%=noticeGb %>] <%=JSPUtil.chkNull(bean.get제목())%></a></td>
		<%	
			} else {
		%>
		      					<td class="subject"><a href="JavaScript:goView('<%=bean.get게시번호()%>');"><%=JSPUtil.chkNull(bean.get제목())%></a></td>
		<%	
			}
		%>
		        				<td><%=bean.get등록자()%></td>
		        				<td><%=bean.get등록일자()%></td>
		<%
						if("01".equals(pageGb)){
							if("N".equals(bean.get확인여부()) ){
		%>
								<td style="color: red;"><%=bean.get확인여부() %></td>
		<%
							}else {
		%>
								<td><%=bean.get확인여부() %></td>
		<%
							}
								
								if(bean.get확인일자() == null ){
		%>
								<td></td>
		<%
								}else{
		%>
								<td><%=bean.get확인일자() %></td>
		<%
								}
							}
		%>
		        				<td><%=bean.get조회수()%></td>
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
			  		<!--#### 페이징 표시 끝 ####-->
			  		
			  		
			  		
			  		
			  		<div id="search-option">
			    		<label for="select_search" class="hidden">검색구분</label>
			    		<select id="search_type" name="search_type" style="height:20px; width:80px;">
			    			<option value="0">전체</option>
			    			<option value="title">제목</option>
			    			<option value="content">내용</option>
			    		</select>
			    		<label for="search_word" class="hidden">검색어</label>
			    		<input type="text" id="search_word" name="search_word" style="ime-mode:active" value="" style="width:180px;" onKeyDown="if(event.keyCode==13) { searchBtn.focus();  }"/>
			    		<button type="button" id = "searchBtn" class="searchBtn"  onclick="search_list();">검색</button>
			    		<button type="button" class="gowriteBtn" id="writeBt" style="visibility:show" onclick="goWrite()">글쓰기</button>
			  		</div>
		  		</form>
	  		</div>
 		 </section>
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div><!-- end of wrap -->
</body>
</html>