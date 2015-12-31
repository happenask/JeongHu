<%@page import="javax.swing.text.Document"%>
<%@page import="java.awt.print.Printable"%>
<%
/** ############################################################### */
/** Program ID   : admin-writing.jsp								*/
/** Program Name : 글쓰기                              				*/
/** Program Desc : 공지사항을 작성한다.                  			*/
/** Create Date  : 2015.04.10                                       */
/** Programmer   : Hojun.Choi                                       */
/** Update Date  : 2015.05.15                                       */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="admin.beans.adminBean" %> 
<%@ page import="admin.dao.adminDao" %>
<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.net.URLDecoder" %> 
<%@ include file="/com/common.jsp"%> 

<%
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-answer-request.jsp");
	
	String root     = request.getContextPath();
	
	
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ), ""); //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ), ""); //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ), ""); //브랜드코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ), ""); //등록자명
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"), ""); //매장코드
	
	//--------------------------------------------------------------------------------------------------
	// Parameter 정보
	//--------------------------------------------------------------------------------------------------
	String listNum        = JSPUtil.chkNull((String)paramData.get("listNum"   ), ""); //게시판 번호
	String pageGb         = JSPUtil.chkNull((String)paramData.get("pageGb"    ), ""); //게시판 구분
	String srch_key       = JSPUtil.chkNull((String)paramData.get("srch_key"  ), ""); //검색어
	String sseStoreCd     = JSPUtil.chkNull((String)paramData.get("sseStoreCd"), ""); //매장코드
	String sSeqNum        = JSPUtil.chkNull((String)request.getParameter("listNum"), ""); //글목록 번호
	String srch_type      = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("srch_type"), "0" ), "UTF-8"); //검색종류
	String search_word    = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("search_word"), ""), "UTF-8"); //검색종류
	int inCurPage         = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurPage" ),    "1"));
	int inCurBlock        = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurBlock"),    "1"));

	//--------------------------------------------------------------------------------------------------
	// 조건검색을 유지하기위한 Parameter 초기화
	//--------------------------------------------------------------------------------------------------
	String QryGubun     = JSPUtil.chkNull((String)paramData.get("inqGubun"),    "%"); //조회구분
	String StartDate    = JSPUtil.chkNull((String)paramData.get("sDate"),        ""); //조회시작일자
	String EndDate      = JSPUtil.chkNull((String)paramData.get("eDate"),        ""); //조회종료일자
	String statusGubun  = JSPUtil.chkNull((String)paramData.get("statusGubun"), "%"); //조회구분
	
	paramData.put("sseGroupCd",   sseGroupCd   );
	paramData.put("sseCorpCd" ,   sseCorpCd    );
	paramData.put("sseBrandCd",   sseBrandCd   );
	paramData.put("sseStoreCd"    ,   sseStoreCd       );
	paramData.put("등록자", (String)session.getAttribute("sseCustNm"));
	paramData.put("sseCustNm", (String)session.getAttribute("sseCustNm")		);
	System.out.println("paramData : "+ paramData);
	
	//--------------------------------------------------------------------------------------------------
	// 파라미터 초기화
	//--------------------------------------------------------------------------------------------------
	
	adminBean bean     = null;
	adminBean bean2    = null; 
	adminDao  dao      = new adminDao();
	adminBean commBean = null; // 댓글리스트 목록용
	
	ArrayList<adminBean> list     = null;
	ArrayList<adminBean> list2 	  = null;
	ArrayList<adminBean> listComm = null;
	
	String sTitle     =  "";
	String sComment   =  "";
	String sMyComment =  "";
	String sName      =  "";
	String sWriteDate =  "";
	int listCommCnt   =   0;
	String fileYn     = "Y";	//첨부파일 유무
	String writeYn    = "Y";
	String pageTitle  = "N/A";
	
	//--------------------------------------------------------------------------------------------------
	// 게시구분의 따른 구분
	//--------------------------------------------------------------------------------------------------
	
	if(pageGb.equals("11")||pageGb.equals("12")){		
		pageTitle   = "답변";
		writeYn     = "Y";
		listComm    = dao.selectProposalCommList(paramData); //댓글 정보 조회
 		listCommCnt = dao.selectProposalCommListCount(paramData);
	}
 	paramData.put("pageGb", pageGb);

	//--------------------------------------------------------------------------------------------------
	// 수정용 정보 조회
	//--------------------------------------------------------------------------------------------------

	 if(!"".equals(sSeqNum)){
		paramData.put("seqNum", sSeqNum);
				list  = dao.selectProposalDetail(paramData);
				list2 = dao.selectMyCommList(paramData);
		if(list != null && list.size() > 0){
			bean = (adminBean)list.get(0);
			
			sTitle     = bean.get제목();
			sComment   = bean.get내용();
			sName	   = bean.get등록자();
			sWriteDate = bean.get등록일자();
		}
		
		if(list2 != null && list2.size() > 0){
			bean = (adminBean)list2.get(0);
			sMyComment = bean.get댓글내용();
		}
		
	}	
	System.out.println("list: "+paramData);
	System.out.println("sseCustNm: "+sseCustNm);

	
	

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

<html>
<head>
    <%@ include file="/include/common_file.inc" %>
	<title>KCFM 관리자</title>  
     
    <script type="text/javascript">
     
    $(document).ready(function()
    		{  
    			getCurrent();
    			fnCalendar();

    			$(".admin-menu").find("li").each(function(){
    				$(this).removeClass("active");
    			});
    			
    			if("<%=pageGb%>" == "01"){
    				$(".admin-menu").find("li").eq(0).addClass("active");
    			}else if("<%=pageGb%>" == "02"){
    				$(".admin-menu").find("li").eq(1).addClass("active");
    			}else if("<%=pageGb%>" == "11"){
    				$(".admin-menu").find("li").eq(2).addClass("active");
    			}else if("<%=pageGb%>" == "12"){
    				$(".admin-menu").find("li").eq(3).addClass("active");
    			}
    	    });
    
  //----------------------------------------------------------------------------------------------
  //  목록으로 이동
  //----------------------------------------------------------------------------------------------    
  function goList(pageGb)
	{	

		var frm = document.form3;
		var v_searchWord = 	frm.srch_key.value;
		/* var v_searcType = 	frm.srch_type.value;
		frm.srch_type.value  = encodeURIComponent(v_searcType); */
		frm.srch_key.value   = encodeURIComponent(v_searchWord);
 		frm.action = "<%=root%>/admin-page/admin-main.jsp";
		frm.submit();

	}
	
	//----------------------------------------------------------------------------------------------
	//  댓글 쓰기
	//----------------------------------------------------------------------------------------------  
	function goWriteComment()
		{  
		var frm = document.getElementById("form1");
		var checkNull = document.getElementById("comm_write").value;
			if (checkNull == null || checkNull =="" || checkNull =="<undefined>" ){
				alert("댓글이 비어있습니다.");
				return;
			}else{
				frm.action = "<%=root%>/admin-page/admin-comm-write-ok.jsp";
				frm.submit();
			}
	 			 
		}
    
	//----------------------------------------------------------------------------------------------
	//  공백제거
	//----------------------------------------------------------------------------------------------
    function trim(s) 
    {
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }
	
   //----------------------------------------------------------------------------------------------
   //  댓글 출력
   //----------------------------------------------------------------------------------------------
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
	$(function(){
		  $(".count").click(function(){
		        $(".count_all").slideToggle(400);
		  });
		 });                                           //댓글 크기 변경
	
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
	 	<section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>administrator service &gt; <%=pageTitle %> 관리</span></h1>
 		 	
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
 		 		
				<div id="cont-list" class="write list-wide">
				<p>▶ <%=pageTitle%> 등록</p>
					<form id= "form1" name="form1" method="post">
					<input type="hidden" id ="seqNum" 	  	  name="seqNum" 		value="<%=sSeqNum%>" 		>  <!-- 글 번호 -->
					<input type="hidden" id ="pageGb" 		  name="pageGb" 		value="<%=pageGb%>" 		>  <!-- 게시구분 -->
					<input type="hidden" id ="inCurPage" 	  name="inCurPage" 		value="<%=inCurPage%>" 		>  <!-- Page번호 -->
		  			<input type="hidden" id ="sseCustStoreCd" name="sseCustStoreCd" value="<%=sseCustStoreCd%>" >  <!-- 매장코드 -->
			  		<input type="hidden" id="srch_key"        name="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
					<input type="hidden" id="srch_type"       name="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
					<input type="hidden" id="inCurBlock"      name="inCurBlock"     value="<%=inCurBlock %>"	>  <!-- 현재 블럭 -->
					<input type="hidden" id="search_word"     name="search_word"    value="<%=search_word %>"	>  <!-- 검색어 -->
					<input type="hidden" id="sDate"           name="sDate"          value="<%=StartDate %>"     >  <!-- 조회시작날짜 -->
					<input type="hidden" id="eDate"           name="eDate"          value="<%=EndDate %>"		>  <!-- 조회종료날짜 -->
					<input type="hidden" id="inqGubun"        name="inqGubun"       value="<%=QryGubun %>"		>  <!-- 검색구분자 -->	
			  		<input type="hidden" id="statusGubun"	  name="statusGubun"    value="<%=statusGubun %>"	>  <!-- 상태구분자 -->
			  		<input type="hidden" id="sseStoreCd"      name="sseStoreCd"     value="<%=sseStoreCd %>"    >  <!-- 매장코드 구분 값 -->	
			  			<table>
			  			<col width="150"/>
			    		<col width="300"/>
			    		<col width="150"/>
			    		<col width="*"/>
				    		<thead>
				    			<tr>
				      				<th >작성자</th>
				      				<td width="" align="center"><%=sName %></td>
				      				<th >최초등록일</th>
				      				<td width="" align="center"><%=sWriteDate %></td>
				      			</tr>
				    			<tr>
				      				<th>제목</th>
				      				<td colspan="3">
				      				<input type="text" id="title" name="" readonly="readonly" value="<%=sTitle%>"/></td>
				        			<!-- <td style="text-align: right;"><span style="font-weight:bold; text-align: right;">작성일 :</span>2015-02-14</td> -->
				      			</tr>
				    		</thead>
				    		<tbody>
				    			<tr>
				      				<td colspan="4">
						        		<textarea class="org-text" id="org-tx-area" name="org-tx-area" readonly="readonly" cols="" rows="14" ><%=sComment%></textarea>						        		
							      	</td>
				      			</tr>
				      			<tr>
				      				<th rowspan="2">답변</th>
				        			<td colspan="3">
					        			<input type="hidden" 		name="listNum"        id="listNum"         value="<%=listNum %>"        >  <!-- 게시판 번호 -->
						      			<input type="hidden" 		name="pageGb"         id="pageGb"          value="<%=pageGb %>"         >  <!-- 게시판 종류 구분 값 -->
										<textarea  class="org-text"  name="comm_write"     id="comm_write"      cols="" rows="3" 			></textarea>
										<%-- <% } %> 15-04-22 hjchoi:	 수정 버튼 클릭 이전 댓글 삽입--%>					      			
					      			</td>
			        			</tr>
			      			</tbody>				      			
				  		</table>
				  		<p class="btn">
				 			<button type="button" class="golistBtn" onclick="goList('<%=pageGb%>');">목록</button>
				 			<button type="button" class="saveBtn" id="btn_input" name="btn_input" onclick="goWriteComment();">저장</button>
				 		</p>
			      	</form>
		      		<div id="comment">
						<!--2015.5.7 댓글 스크롤바 추가 hjChoi -->
						<p  class="count" onclick="showComment();"><span class="mark">▶</span> 총 댓글 (<span class="num"> <%=listCommCnt %> </span>)</p>  
							<div class="count_all" style="width:*; height:*px; display:none;">
 							<div style="overflow-y:auto; width:*; height:300px; border:1 solid #000000;"  >
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
		</section>

	 		<!-- modal popup -->
		 	<div class="overlay-bg-half"></div>
	</div>
					<form id="form3" name="form3" method="post">
						<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
						<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
						<input type="hidden" name="inCurPage"      id="inCurPage"      value="<%=inCurPage %>"      >  <!-- 현재 페이지 -->
						<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
					    <input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb %>"         >  <!-- 게시판 종류 구분 값 -->
						<input type="hidden" name="search_word"    id="search_word"    value="<%=search_word %>"	>  <!-- 검색어 -->
						<input type="hidden" name="sDate"          id="sDate"          value="<%=StartDate %>"      >  <!-- 조회시작날짜 -->
						<input type="hidden" name="eDate"    	   id="eDate"    	   value="<%=EndDate %>"		>  <!-- 조회종료날짜 -->
						<input type="hidden" name="inqGubun"       id="inqGubun"       value="<%=QryGubun %>"		>  <!-- 검색구분자 -->
						<input type="hidden" name="statusGubun"    id="statusGubun"    value="<%=statusGubun %>"	>  <!-- 상태구분자 -->
					</form>
</body>
</html>
