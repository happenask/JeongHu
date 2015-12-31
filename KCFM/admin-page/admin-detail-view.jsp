<!-- 
/** ############################################################### */
/** Program ID   : admin-detail-view.jsp                            */
/** Program Name : 게시판 상세보기                                  */
/** Program Desc : 게시글 상세보기                                  */
/** Create Date  : 2015.04.10                                       */
/** Programmer   : Hojun.Choi                                       */
/** Update Date  : 2015.05.15                                       */
/** ############################################################### */
 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %> 
<%@ page import="admin.beans.adminBean" %> 
<%@ page import="admin.dao.adminDao" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>
<%@ page import="java.util.Calendar,  java.util.Date, java.text.SimpleDateFormat"%>
<%
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-detail-view.jsp");
	
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),""); //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),""); //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),""); //브랜드코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),""); //등록자명
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),""); //매장코드
	
	//--------------------------------------------------------------------------------------------------
	// Parameter 정보
	//--------------------------------------------------------------------------------------------------

	String listNum    = JSPUtil.chkNull((String)paramData.get("listNum"   ),  ""); //게시판 번호
	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb"    ),  ""); //게시판 구분
	String srch_key   = JSPUtil.chkNull((String)paramData.get("srch_key"  ),  ""); //검색어
	String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type" ), "0"); //검색종류
	String sseStoreCd = JSPUtil.chkNull((String)paramData.get("sseStoreCd"),  ""); //매장코드
	//--------------------------------------------------------------------------------------------------
	// 이전 검색조건 저장 Parameter 정보
	//--------------------------------------------------------------------------------------------------

	String inCurPage    = JSPUtil.chkNull((String)paramData.get("inCurPage"  ), "1"); // 현재 페이지
	String inCurBlock   = JSPUtil.chkNull((String)paramData.get("inCurBlock" ), "1"); // 현재 블럭
	String QryGubun     = JSPUtil.chkNull((String)paramData.get("inqGubun"   ), "%"); //조회구분
	String statusGubun  = JSPUtil.chkNull((String)paramData.get("statusGubun"), "%"); //조회구분
	String StartDate    = JSPUtil.chkNull((String)paramData.get("sDate"      ),  ""); //조회시작일자
	String EndDate      = JSPUtil.chkNull((String)paramData.get("eDate"      ),  ""); //조회종료일자

	//--------------------------------------------------------------------------------------------------
	// 초기값 초기화
	//--------------------------------------------------------------------------------------------------

	adminDao  dao      = new adminDao();
    adminBean bean     = null; //리스트 목록용
	adminBean commBean = null; // 댓글리스트 목록용
	ArrayList<adminBean> list = null;
	ArrayList<adminBean> listComm = null;
	ArrayList<adminBean> listDownload = null;
	
	int    listCommCnt = 0;
	String fileYn      = "";
	String fileName    = "";
	String fileName1   = "";
	String orgFileName = "";
	String writeYn     = "N";
	String pageTitle   = "공지 사항 상세";
	
	System.out.println ("=======================================================");
	System.out.println ("sseGroupCd     : " + sseGroupCd     );
	System.out.println ("sseCorpCd      : " + sseCorpCd      );
	System.out.println ("sseBrandCd     : " + sseBrandCd     );
	System.out.println ("sseCustStoreCd : " + sseCustStoreCd );
	System.out.println ("sseCustNm      : " + sseCustNm      );
	System.out.println ("sseCustStoreCd : " + sseCustStoreCd );
	System.out.println ("pageGb         : " + pageGb 		 );
	System.out.println ("inCurPage      : " + inCurPage      );
	System.out.println ("inCurBlock     : " + inCurBlock     );
	System.out.println ("srch_key       : " + srch_key       );
	System.out.println ("srch_type      : " + srch_type      );
	System.out.println ("sDate          : " + StartDate      );
	System.out.println ("eDate          : " + EndDate        );
	System.out.println ("inqGubun       : " + QryGubun       );
	System.out.println ("statusGubun    : " + statusGubun    );
	System.out.println ("sseStoreCd     : " + sseStoreCd     );
	System.out.println ("=======================================================");
	
	paramData.put("sseGroupCd"    ,   sseGroupCd       );
	paramData.put("sseCorpCd"     ,   sseCorpCd        );
	paramData.put("sseBrandCd"    ,   sseBrandCd   	   );
	paramData.put("sseCustStoreCd",   sseCustStoreCd   );
	paramData.put("sseStoreCd"    ,   sseStoreCd       );
	paramData.put("sseCustNm"     ,   sseCustNm    	   );
	paramData.put("listNum"       ,   listNum          );
	paramData.put("pageGb"		  ,   pageGb           );
    paramData.put("srch_type"     ,   srch_type	  	   );
    paramData.put("srch_key"  	  ,   srch_key		   );
	paramData.put("권한코드"      ,   (String)session.getAttribute("sseCustAuth"));	//90:Super User 권한 체크	
    
    int fileCnt = 0;

 	//--------------------------------------------------------------------------------------------------
 	// 게시구분자의 따른 Page 변화 
 	//--------------------------------------------------------------------------------------------------

	if(pageGb.equals("01") || pageGb.equals("02")){
		if(pageGb.equals("01")) {
			pageTitle = "공지 사항";	
		} else {
			pageTitle = "교육 자료";
		}
		
		writeYn = "N";
		    
		fileCnt = dao.selectNoticeRequestDownloadCnt(paramData);
			if(fileCnt > 0 )
			{
				System.out.println("fileCnt:" +fileCnt);
				fileYn    = "Y"; //Y:파일존재 N:파일없음
				listDownload = dao.selectNoticeRequestDownloadList(paramData);
				
			}
		
 		list 		= dao.selectNoticeDetail(paramData); 	//상세보기 정보 조회 
 		listComm 	= dao.selectCommList(paramData); 		//댓글 정보 조회
 		listCommCnt = dao.selectCommListCount(paramData);
 		
	} else if(pageGb.equals("11") || pageGb.equals("12")){
		
		if(pageGb.equals("11")) {
			pageTitle = "매장 건의 사항";	
		} else {
			pageTitle = "매장 요청 사항";
		}
		
		writeYn = "Y";
		fileCnt = dao.selectRequestDownloadCnt(paramData);
		
			if(fileCnt > 0 )
			{
				fileYn    = "Y"; //Y:파일존재 N:파일없음
				listDownload = dao.selectRequestDownloadList(paramData);
				
			}
 		dao.updateProposalReadCount(paramData);     //조회수 업데이트
 		
 		list 		= dao.selectProposalDetail(paramData); 		//상세보기 정보 조회
 		listComm 	= dao.selectProposalCommList(paramData); 	//댓글 정보 조회
 		listCommCnt = dao.selectProposalCommListCount(paramData);
	}
	
	String name            = ""; //작성자
	String title           = ""; //제목
	String comment         = ""; //내용
	String addDate         = ""; //등록일
	String readCnt         = ""; //조회수
	String commName        = ""; //작성자
	String commComment     = ""; //댓글내용
	String commAddDate     = ""; //등록일
	String commNum         = "";
	String snoticeKind     = "";
	String BoardStartDate  = "";
	String BoardEndDate    = "";
	String tempTime        = "";
	int    nowTime         = 0;
	int    test1           = 0; 
	//--------------------------------------------------------------------------------------------------
	// 게시글 내용 List에 입력
	//--------------------------------------------------------------------------------------------------
		
	if(list != null && list.size() > 0){
		
		bean = (adminBean)list.get(0);		
		name           = bean.get등록자();
		title          = bean.get제목();
		comment        = bean.get내용();
		addDate        = bean.get등록일자();
		readCnt        = bean.get조회수();		
		snoticeKind    = bean.get공지구분();
		BoardStartDate = bean.get게시시작일자();
		BoardEndDate   = bean.get게시종료일자();
		
	}
	if(pageGb.equals("01") || pageGb.equals("02")){
		tempTime       = BoardEndDate.replace("-", "");		
		test1 = Integer.parseInt((new SimpleDateFormat("yyyyMMdd")).format( new Date() ));
		nowTime        = Integer.parseInt(tempTime);
	}
	
	//--------------------------------------------------------------------------------------------------
	// 게시 댓글 내용 List에 입력
	//--------------------------------------------------------------------------------------------------
	if(listComm != null && listComm.size() > 0){
		
		commBean = (adminBean)listComm.get(0);		
		commName    = bean.get등록자();
		commComment = bean.get내용();
		commAddDate = bean.get등록일자();
		commNum     = bean.get게시번호(); 
		
	}
	

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
	   	    if("<%=writeYn%>" == "N"){
	   	    	//$("#wrBtn").hide(); //임시 주석처리 권한에 따라 글쓰기 권한 부여
	   	    }
	   	    
	   	    $("#header .gnb>ul").find("li#"+"<%=pageGb %>").addClass("active");
	    });
	   
	    
	    function showComment(){
	    	//alert("▼ 총 댓글");	
	    	if($(".comm_list").hasClass("show")== true ){
	        	$(".mark").text("▶");
	    		$(".comm_list").removeClass("show").addClass("hidden");
	    	}
	    	else{
	        	$(".mark").text("▼");
	    		$(".comm_list").removeClass("hidden").addClass("show");
	    		window.scrollTo(0, document.body.scrollHeight);
	    	}
	    }
	
		//--------------------------------------------------------------------------------------------------
		// 공지사항,교육자료 관리 글 수정
		//--------------------------------------------------------------------------------------------------    
	    
	    function fnModiWriting(eventcd)	//수정
		{	
			var frm = document.getElementById("form1");
	 		document.getElementById("listNum" ).value = eventcd; //게시판 번호 				
	 		frm.action = "<%=root%>/admin-page/admin-writing-modify.jsp";
		}   
	
		//--------------------------------------------------------------------------------------------------
		// 댓글 삽입.
		//--------------------------------------------------------------------------------------------------
	    function goWriteComment()
		{      	
	    	var frm = document.getElementById("form2");
			var checkNull = document.getElementById("comm_write").value;
			if (checkNull == null || checkNull =="" || checkNull =="<undefined>" ){
				alert("댓글이 비어있습니다.");
				return;
			}else{
				frm.action = "<%=root%>/admin-page/admin-comm-write-ok.jsp";
			}
	 			 
		}
		//--------------------------------------------------------------------------------------------------
		// FileDown 경로 설정
		//--------------------------------------------------------------------------------------------------
	    function fnFileDown()
	    {
			var vfile = encodeURIComponent("<%=fileName%>");
	    	location.href= "<%=root%>/com/filedown.jsp?fname="+vfile+"&gubn=1";	
	    	
	    }
	 	//--------------------------------------------------------------------------------------------------
		// 목록으로 이동
		//--------------------------------------------------------------------------------------------------
	    function goList(pageGb)
		{	
	
			var frm = document.form1;
	 		frm.action = "<%=root%>/admin-page/admin-main.jsp";
			frm.submit();
	
		}
		
	  	//--------------------------------------------------------------------------------------------------
		//다운로드 버튼 오버 이미지 링크
		//--------------------------------------------------------------------------------------------------
		var $container = $("#dtl_section").find("table tbody");
		var $key=$container.find(".attached-file>a");
		var $item=$key.find("img");
		var link = "assets/images/btns/" ;
		
	  	//--------------------------------------------------------------------------------------------------
		// 마우스 이벤트
		//--------------------------------------------------------------------------------------------------
		$key.bind("mouseover", over);
		$key.bind("mouseleave", out);
		$key.bind("mouseenter", action);
		
		function over(){
			 var img = link + "btn_download_over.png";
			 $item.attr("src", img);
		}
		function action(){
			 var img = link + "btn_download_act.png";
			 $item.attr("src", img);
		}
		function out(){
			 var img = link + "btn_download.png";
			 $item.attr("src", img);
		}
		
		$(function(){
			  $(".count").click(function(){
			        $(".count_all").slideToggle(400);
			  });
			 });
		//댓글 크기 변경
	    </script>
	</head>

	<body>
	 	<div id="wrap" >
		 	<section class="header-bg">
				<!-- header include-->
				<script type="text/javascript">	$(".header-bg").load("../include/admin-header.jsp"); </script> 
			</section>
			
			<!-- 정보 변경 패널 -->
		 	<section id="info-panel">
	  			<!-- info-panel include-->
		 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
		 	</section>
			<!--#### 메뉴 끝 ####--> 	
		 	
	 		 <section class="contents admin">
				<header>
					<h1> ◎ <span>administrator service &gt; <%=pageTitle%></span></h1>
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
					</div><!-- end of cont-admin -->
					<div id="#dtl_section_admin" class="view list-wide">
						<form id="form1" name="form1" method="post">
							<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
							<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
							<input type="hidden" name="inCurPage"      id="inCurPage"      value="<%=inCurPage %>"      >  <!-- 현재 페이지 -->
							<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
							<input type="hidden" name="listNum"        id="listNum"        value="<%=listNum %>"        >  <!-- 게시판 번호 -->
						    <input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb %>"         >  <!-- 게시판 종류 구분 값 -->
							<%-- <input type="hidden" name="search_word"    id="search_word"    value="<%=search_word %>"	>  <!-- 검색어 --> --%>
							<input type="hidden" name="sDate"          id="sDate"          value="<%=StartDate %>"      >  <!-- 조회시작날짜 -->
							<input type="hidden" name="eDate"          id="eDate"          value="<%=EndDate %>"		>  <!-- 조회종료날짜 -->
							<input type="hidden" name="inqGubun"       id="inqGubun"       value="<%=QryGubun %>"		>  <!-- 검색구분자 -->
							<input type="hidden" name="statusGubun"    id="statusGubun"    value="<%=statusGubun %>"	>  <!-- 상태구분자 -->
					 		<p class="btn above">
				    			<%
				    				if (sseCustNm.equals(name)){
				    			%>
				    					<button class="modifyBtn" onclick="fnModiWriting('<%=bean.get게시번호()%>');">수정</button> <!-- 글 수정 -->
				    			<%
				    				}
				    			%>
					 			<button type="button" class="golistBtn" onclick="goList('<%=pageGb %>');"></button> <!-- 목록이동 -->
					 		</p>
					  		<table>
					  			<col width="10%"/>
					    		<col width="40%"/>
					    		<col width="10%"/>
					    		<col width="20%"/>
					    		<col width="10%"/>
					    		<col width="10%"/>
					  			
					  	   <!-- <col width="15%"/>
					    		<col width="20%"/>
					    		<col width="15%"/>
					    		<col width="20%"/>
					    		<col width="15%"/>
					    		<col width="10%"/>   이전 화면-->
					    		<thead>
		<% if("01".equals(pageGb)) { %>
					    			<tr>
					      				<th>제목</th>
					      					<td colspan="1"><%=title %></td>
										<th >게시기간</th>
										<% if((nowTime-test1)<5){	%>
						      					<td style="color: #f35959;"><%=BoardStartDate%> ~ <%=BoardEndDate%></td> <!-- 2015-05-13 hjchoi: 게시기간 추가 입력 -->
						      					<% } else {  %>
						      					<td ><%=BoardStartDate%> ~ <%=BoardEndDate%></td> <!-- 2015-05-13 hjchoi: 게시기간 추가 입력 -->
						      					<% } %>             <!-- 게시종료가 5일 안이면 게시기간 text 색 변경 HJCHOI 15-05-14 -->
					        			<th>공지구분</th>					        			
					        			<% if("2".equals(bean.get공지구분())){	%>
						      					<td style="color: #f35959;">긴급</td>
						      					<% } else {  %>
						      					<td>일반</td>
						      					<% } %>
					      			</tr>
		<% }else if("02".equals(pageGb)) { %>
									<tr>
					      				<th>제목</th>
					      					<td colspan="1"><%=title %></td>
					        			<!-- <td style="text-align: right;"><span style="font-weight:bold; text-align: right;">작성일 :</span>2015-02-14</td> -->
		 					        	<th >게시기간</th>
										 <% if((nowTime-test1)<5){	%>
						      					<td style="color: #f35959;"><%=BoardStartDate%> ~ <%=BoardEndDate%></td> <!-- 2015-05-13 hjchoi: 게시기간 추가 입력 -->
						      					<% } else {  %>
						      					<td ><%=BoardStartDate%> ~ <%=BoardEndDate%></td> <!-- 2015-05-13 hjchoi: 게시기간 추가 입력 -->
						      					<% } %>             <!-- 게시종료가 5일 안이면 게시기간 text 색 변경 HJCHOI 15-05-14 --> 
		 					        	<td > </td> <!-- 공백 -->
		 					      		<td > </td> 
					      			</tr>
		<% }  %>	
					    			<tr>
					      				<th>작성자</th><td><%=name %>   </td>
					        			<th>등록일</th><td><%=addDate %></td>
					        			<th>조회수</th><td><%=readCnt %></td>
					      			</tr>
					    		</thead>
					    		<tbody>
					    			<tr>
					      				<td colspan="6">
					      				<%
					      				if(pageGb.equals("video")){
					      						
			      						%>
						        		<p> 본문입니다</p>		
									 	<!-- 동영상재생 : 다음 tv팟 -->
									  	<div id="public_tv" class="overlay-player"><!-- width='840px' height='480px'  -->
							 				<!-- <iframe name="mv2" title='sf-manual' src="http://videofarm.daum.net/controller/player/VodPlayer.swf" width="680px" height="385px" allowscriptaccess="always" type="application/x-shockwave-flash" allowfullscreen="true" bgcolor="#000000" flashvars="vid=vbd6aqNcyNbc7hXyb0X0yp7&amp;playLoc=undefined&amp;alert=true"></iframe> -->
							 				<embed src='http://videofarm.daum.net/controller/player/VodPlayer.swf' width="680px" height="385px" allowScriptAccess='always' type='application/x-shockwave-flash' allowFullScreen='true' bgcolor='#000000' flashvars='vid=v6adcWiMGWFcFFmXi1AG1PG&playLoc=undefined&profileName=HIGH&showPreAD=false&showPostAD=false&autoPlay=true&frameborder='0' scrolling='no'>  </embed>
										</div>
										<%
										
					      				}else{
					      					
					      				%>
					        				<div class="comm"> <PRE><%=comment %></PRE> </div><!-- 글 내용 -->
				        				<%
					      				}
					      				/* 첨부파일이 있는 경우 다운로드 링크 */
					      				if(fileYn.equals("Y")){
					      				%>	
					      					
					      				<%	
					      					for( int i = 0; i < listDownload.size(); i++ ) 
					      					{
					      						bean = (adminBean) listDownload.get(i);
					      						fileName = bean.get파일명(); 
					      						orgFileName = bean.get원본파일명(); 
					      						fileName1 = URLEncoder.encode(fileName,"UTF-8");
					      				%>
								 			<!-- 첨부 파일 :<p class="attached-file"> --> 
				        					<p class="">첨부 파일 :
								 				<span id="<%=fileName1 %>" class="file-name">
									 				<a id="download-link" href="<%=root%>/com/fileDown.jsp?fname=<%=fileName1 %>&gubn=1" ><%=orgFileName %> 
									 					<%-- <img class="mg-auto5" src="<%=root%>/assets/images/btns/btn_download.png"  width="110" height="32" id="Image44" align="middle"> --%>
									 				</a>
								 				</span>
								 			</p>
							 			<%
					      					}
					      				%>
					      					
					      				<%
							 			}
							 			%>				      				
				        				</td>
					      			</tr>
					    		</tbody>
					  		</table>
						</form>
						 <!-- 댓글영역 -->
						 <form id="form2" name="form2" method="post">
							 <div id="write_comm_admin">
							 
							      <p>댓글입력</p> 
							      <input type="hidden" name="listNum"     id="listNum"     value="<%=listNum %>"        >  <!-- 게시판 번호 -->
							      <input type="hidden" name="pageGb"      id="pageGb"      value="<%=pageGb %>"         >  <!-- 게시판 종류 구분 값 -->
							      <input type="hidden" name="srch_key"    id="srch_key"    value="<%=srch_key %>"       >  <!-- 검색어 -->
								  <input type="hidden" name="srch_type"   id="srch_type"   value="<%=srch_type %>"      >  <!-- 검색타입 -->
								  <input type="hidden" name="inCurPage"   id="inCurPage"   value="<%=inCurPage %>"      >  <!-- 현재 페이지 -->
								  <input type="hidden" name="inCurBlock"  id="inCurBlock"  value="<%=inCurBlock %>"	    >  <!-- 현재 블럭 -->
								  <input type="hidden" name="inqGubun"    id="inqGubun"    value="<%=QryGubun %>"		>  <!-- 검색구분자 -->
							      <input type="hidden" name="statusGubun" id="statusGubun" value="<%=statusGubun %>"	>  <!-- 상태구분자 -->
							      <input type="hidden" name="sseStoreCd"  id="sseStoreCd"  value="<%=sseStoreCd %>"     >  <!-- 매장코드 구분 값 -->
							      <input type="hidden" name="sDate"       id="sDate"       value="<%=StartDate %>"      >  <!-- 조회시작날짜 -->
							      <input type="hidden" name="eDate"       id="eDate"       value="<%=EndDate %>"		>  <!-- 조회종료날짜 -->
							      <textarea cols="90" rows="4" id="comm_write" name="comm_write" ></textarea>
							      <!-- <button class="btn_blank gray" id="btn_input" name="btn_input" onclick="input();">확인</button> -->
							      <button class="btn_blank" id="btn_input" name="btn_input" onclick="goWriteComment();"></button> <!-- 댓글 입력버튼  --> 
						     </div>
					     </form>
						<div id="comment">
							<!-- <div id="comment">  -->
							<!--2015.5.7 댓글 스크롤바 추가 hjChoi -->
							<p  class="count" onclick="showComment();"><span class="mark">▶</span> 총 댓글 (<span class="num"> <%=listCommCnt %> </span>)</p>  
 							<%
								if (0>=listComm.size()) 
					            {
									%>
		 							<div class="count_all" style="width:*; height:*px; display:none;">
			 							<div style="overflow-y:auto; width:*; height:100px; border:1 solid #000000;"  >
				 							 <% } else{ %>
				 							 <div class="count_all" style="width:*; height:*px; display:none;">
			 									 <div style="overflow-y:auto; width:*; height:300px; border:1 solid #000000;"  >
			 									 <% } %>
													<ul class="comm_list hidden">     
														<%
															
															for(int i = 0; i < listComm.size(); i++ ) 
																
												            {
																commBean = (adminBean) listComm.get(i);
														%>
																<li>
													  				<p><span class="writer"><%=commBean.get등록자()%> </span><span class="date"> <%=commBean.get등록일자() %> </span></p>
											          				<div id="comm_text" class="comm"><PRE><%=commBean.get내용() %></PRE></div> 
																</li>
														<%
															}
															
														%>
													</ul>
												</div>
											</div>
											</div>
											</div>
											</div>
						</div> 
					</div>
				</section>
		 		<!-- modal popup -->
			 	<div class="overlay-bg-half">
			 	</div>
	</body>
</html>