<%
/** ############################################################### */
/** Program ID   : maintain-faq-new.jsp                             */
/** Program Name : 관리자 - FAQ관리 >> faq 신규 및 수정                                      */
/** Program Desc : FAQ 관리 신규 및 수정처리                                                          */
/** Create Date  : 2015.04.16                                       */
/** Programmer   : JHYOUN                                           */
/** Update Date  : 2015.04.28                                       */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="admin.beans.faqBean" %>
<%@ page import="admin.dao.faqDao" %>
<%@ page import="java.util.ArrayList"%>

<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>  
<%@ include file="/com/common.jsp"%>

<%
    String root   = request.getContextPath();	

	String no     = (String)request.getParameter("no");
	int    inCurPage  = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1"));  // 현재 페이지
	String pageGb     = new String(request.getParameter("pageGb").getBytes("8859_1"),"UTF-8");
	String dataGb     = new String(request.getParameter("dataGb").getBytes("8859_1"),"UTF-8");
	String seqNo      = new String(request.getParameter("seqNo").getBytes("8859_1"),"UTF-8");
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

	//--------------------------------------------------------------------------------------------------
	// FAQ 관리 신규 및 수정처리
	//--------------------------------------------------------------------------------------------------
 	faqBean bean = null; //리스트 목록용
	faqDao  dao  = new faqDao();
	ArrayList<faqBean> list = null;
	
	String pageTitle = "신규 등록";
    String s질문내용     = "";
    String s답변내용     = "";
	
 	if(dataGb.equals("modify")){
		pageTitle = "수정하기";

		paramData.put("기업코드",    sseGroupCd   );
		paramData.put("법인코드" ,   sseCorpCd    );
		paramData.put("브랜드코드",  sseBrandCd   );
		paramData.put("질문번호" ,   seqNo        );
		
 		list = dao.selectFaqData(paramData);            //Faq 상세정보 조회 

 		/*
 		* 자주하는질문내역 테이블에서 해당 질문번호에 해당되는 정보조회
 		*/
 		if(list != null && list.size() > 0){
 			bean = (faqBean)list.get(0);
 			
 			s질문내용    = bean.get질문내용();
 			s답변내용  = bean.get답변내용();
 		}
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
		fnCalendar(); 
		
		if("<%=dataGb%>" == "new"){
			$(".faq").text("");
		}
    });
   
	//----------------------------------------------------------------------------------------------
	//  목록으로 이동
	//----------------------------------------------------------------------------------------------
	function goList(root)
	{
	  	location.href= "<%=root%>/admin-page/maintain-faq.jsp?pageGb=faq"
	                                                      + "&sDate=<%=StartDate%>"
	                                                      + "&eDate=<%=EndDate%>"
	                                                      + "&inCurPage=<%=inCurPage%>";
	}
	
	//----------------------------------------------------------------------------------------------
	//  FAQ관리 수정처리
	//----------------------------------------------------------------------------------------------
	function goSave(dataGb, seqNo){
		//------------------------------------------------------------------------------------------
		//  입력항목 체크
		//------------------------------------------------------------------------------------------
		if (trim(document.form1.질문내용.value) == "" || trim(document.form1.질문내용.value) == "null") {
			alert("질문내용을 입력해 주세요");
			
			document.form1.질문내용.value = "";
			document.getElementById("질문내용").focus();
			 
			return;
		} 
		
		if (trim(document.form1.답변내용.value) == "" || trim(document.form1.답변내용.value) == "null") {
			alert("답변내용을 입력해 주세요");
			
			document.form1.답변내용.value = "";
			document.getElementById("답변내용").focus();
			 
			return;
		} 
		//------------------------------------------------------------------------------------------
	
		document.form1.질문번호.value = seqNo;
		
		$.ajax(
		{
			url      : "<%=root%>/admin-page/maintain-faq-new-ok.jsp", 
			type     : "POST",
			data     : $("#form1").serialize(), 
			dataType : "html", 
			success  : function(data)
					   {  
						   if( trim(data) == "Y" )
						   { 
							    alert("정상적으로 처리가 되었습니다.");
							  	location.href= "<%=root%>/admin-page/maintain-faq.jsp?pageGb=faq"
								  	                                              + "&sDate=<%=StartDate%>"
								  	                                              + "&eDate=<%=EndDate%>"
								  	                                              + "&inCurPage=<%=inCurPage%>";
			           	   }else if( trim(data) == "N" ){
					   
								alert("저장 실패!!!!"); 
			           	   }
		               }
	    });
	}
	
	//공백제거
	function trim(s) 
	{
		s += ''; // 숫자라도 문자열로 변환
		return s.replace(/^\s*|\s*$/g, '');
	}
	
	//다운로드 버튼 오버 이미지 링크
	var $container = $("#dtl_section").find("table tbody");
	var $key=$container.find(".attached-file>a");
	var $item=$key.find("img");
	var link = "assets/images/btns/" ;
	
	// 이벤트
	$key.bind("mouseover", over);
	$key.bind("mouseleave", out);
	$key.bind("mouseenter", action);
	
	function over(){
		 //alert( $item.attr("src") );
		 var img = link + "btn_download_over.png";
		 $item.attr("src", img);
	}
	function action(){
		 //alert( $item.attr("src") );
		 var img = link + "btn_download_act.png";
		 $item.attr("src", img);
	}
	function out(){
		 //alert( $item.attr("src") );
		 var img = link + "btn_download.png";
		 $item.attr("src", img);
	}
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
 		 		<h1>◎ <span>administrator service &gt; FAQ(자주하는 질문) 관리</span></h1>
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
 		 		
				<div id="cont-list" class="write list-wide">
				<p>▶ faq <%=pageTitle %></p>
					<form id="form1" name="form1" method="POST">
					    <input type="hidden" name="pageGb"   id="pageGb"   value="<%=pageGb%>">  
					    <input type="hidden" name="dataGb"   id="dataGb"   value="<%=dataGb%>">  
					    <input type="hidden" name="기업코드"   id="기업코드"   value="<%=sseGroupCd%>">  
						<input type="hidden" name="법인코드"   id="법인코드"   value="<%=sseCorpCd%>"	>  
						<input type="hidden" name="브랜드코드" id="브랜드코드"  value="<%=sseBrandCd%>" > 
					    <input type="hidden" name="질문번호"   id="질문번호"   value="<%=seqNo%>">  
						<input type="hidden" name="매장코드"   id="매장코드"  value="<%=sseStoreCd%>" > 
						<input type="hidden" name="등록자"     id="등록자"     value="<%=sseCustNm%>" > 
				  		<table>
				  			<col width="16%"/>
				    		<col width="34%"/>
				    		<col width="16%"/>
				    		<col width="34%"/>
				    		<thead>
				      			<tr>
				      				<th rowspan="7">질문</th>
				        			<td colspan="3"><textarea class="faq" id="질문내용" name="질문내용" cols="105" rows="7"><%=s질문내용%></textarea></td>
			        			</tr>
				    		</thead>
				    		<tbody>
				      			<tr>
				      				<th rowspan="15">답변</th>
				        			<td colspan="3"><textarea class="faq" id="답변내용" name="답변내용" cols="105" rows="15"><%=s답변내용%></textarea></td>
			        			</tr>
				    		</tbody>
				  		</table>
				 		<p class="btn">
				 			<button type="button" class="golistBtn" onclick="goList('<%=dataGb%>');">목록</button>
				 			<button type="button" class="saveBtn" onclick="goSave('<%=dataGb%>','<%=seqNo%>');">저장</button>
				 		</p>
					</form> 
				</div>
			</div>
		</section>

 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div>


</body>
</html>