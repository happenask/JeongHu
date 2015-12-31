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
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="admin.beans.adminBean" %> 
<%@ page import="admin.dao.adminDao" %>
<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.net.URLDecoder" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/com/common.jsp"%> 
<%@ include file="/com/fileUpload.jsp"%> 




<%

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-writing-modify.jsp");
	
	//----------------------------------------------------------------------------------------------
	//  Session 정보
	//----------------------------------------------------------------------------------------------
	String root           = request.getContextPath();	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),""); //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),""); //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),""); //브랜드코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),""); //등록자명
	String sSeqNum  	  = JSPUtil.chkNull((String)request.getParameter("listNum"       ),""); //글목록 번호
	
	//----------------------------------------------------------------------------------------------
	//  Parameter 정보
	//----------------------------------------------------------------------------------------------
	String listNum    	  = JSPUtil.chkNull((String)paramData.get("listNum"  ),  ""); //게시판 번호
	String pageGb         = JSPUtil.chkNull((String)paramData.get("pageGb"   ),  ""); //게시판 구분
	String srch_key       = JSPUtil.chkNull((String)paramData.get("srch_key" ),  ""); //검색어
	String srch_type      = JSPUtil.chkNull((String)paramData.get("srch_type"), "0"); //검색종류
	String QryGubun   	  = JSPUtil.chkNull((String)paramData.get("inqGubun" ), "%"); //조회구분
	String StartDate  	  = JSPUtil.chkNull((String)paramData.get("sDate"    ),  ""); //조회시작일자
	String EndDate    	  = JSPUtil.chkNull((String)paramData.get("eDate"    ),  ""); //조회종료일자
	
	int    inCurPage   	  = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurPage"),  "1"));
	int    inCurBlock     = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurBlock"),  "1")); 
	
	
	paramData.put("sseGroupCd",   sseGroupCd   );
	paramData.put("sseCorpCd" ,   sseCorpCd    );
	paramData.put("sseBrandCd",   sseBrandCd   );
	
	String BoardStartDate = "";
	String BoardEndDate   = "";
	
	
	//--------------------------------------------------------------------------------------------------
	// 게시글 수정처리
	//--------------------------------------------------------------------------------------------------
	adminBean bean = null; 
	adminDao  dao  = new adminDao();
	
	ArrayList<adminBean> list = null;
	ArrayList<adminBean> listDownload = null;

	String sName         = ""; //작성자
	String sTitle        = ""; //제목
	String sComment      = ""; //내용
	String fileName1     = ""; //첨부파일이름1
	String fileName2     = ""; //첨부파일이름2
	String fileName3     = ""; //첨부파일이름3
	String sWriteDate    = ""; //작성일
	String snoticeKind   = ""; //긴급여부
	String fileOrderNum1 = ""; //첨부파일순번1
	String fileOrderNum2 = ""; //첨부파일순번2
	String fileOrderNum3 = ""; //첨부파일순번3
	
	String fileYn     =   "Y";	//첨부파일 유무
	String writeYn    =   "Y";
	String pageTitle  = "N/A";
	String storeCount =    "";
	
	
	//--------------------------------------------------------------------------------------------------
	// Page 구분자
	//--------------------------------------------------------------------------------------------------
 	if(pageGb.equals("01")){		
		pageTitle = "공지사항 수정";
		writeYn = "Y";
		listDownload = dao.selectNoticeRequestDownloadList(paramData);
	}else if(pageGb.equals("02")){		
		pageTitle = "교육자료 수정";
		writeYn = "Y";
		listDownload = dao.selectNoticeRequestDownloadList(paramData);
	}
	else if(pageGb.equals("12")){		
		pageTitle = "답변";
		writeYn = "Y";
	}
 	
 	//--------------------------------------------------------------------------------------------------
 	// 수정용 정보 조회
 	//--------------------------------------------------------------------------------------------------
	 if(!"".equals(sSeqNum)){
		if("12".equals(pageGb))
			{
				list = dao.selectProposalDetail(paramData);
			}
		else
			{
				list = dao.selectNoticeDetail(paramData);
			}
		if(list != null && list.size() > 0){
			bean = (adminBean)list.get(0);
			
			sTitle         = bean.get제목();
			sComment       = bean.get내용();
			sName	       = bean.get등록자();
			sWriteDate     = bean.get등록일자();
			snoticeKind    = bean.get공지구분();
			BoardStartDate = bean.get게시시작일자();
			BoardEndDate   = bean.get게시종료일자();
			storeCount     = bean.get매장선택건수();
			System.out.println("sComment : " + sComment);
		}
		
	}
 	
	//------------------------------------------------------------------------------------------
	//  다운로드 파일 체크
	//------------------------------------------------------------------------------------------ 	
 	
	 if (listDownload != null && listDownload.size() > 0) {
			for( int i = 0; i < listDownload.size(); i++ ) 
			{
				bean = (adminBean) listDownload.get(i);
				
				if (i==0){
					
					fileName1     = bean.get파일명();
					fileOrderNum1 = bean.get파일순번();
					
				} else if (i==1){
					
					fileName2     = bean.get파일명();
					fileOrderNum2 = bean.get파일순번();
					
				} else {
					
					fileName3     = bean.get파일명();
					fileOrderNum3 = bean.get파일순번();
					
				}
					
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
	
	System.out.println("admin-writing-modify=====================================");
	System.out.println("기업코드   : " + sseGroupCd );
	System.out.println("법인코드   : " + sseCorpCd  );
	System.out.println("브랜드코드 : " + sseBrandCd );
	System.out.println("게시번호   : " + listNum    );
	System.out.println("게시구분   : " + pageGb     );
	System.out.println("inCurPage  : " + inCurPage  );
	System.out.println("inCurBlock : " + inCurBlock );
	System.out.println("srch_key   : " + srch_key   );
	System.out.println("srch_type  : " + srch_type  );
	System.out.println("fileName1  : " + fileName1  );
	System.out.println("fileName2  : " + fileName2  );
	System.out.println("fileName3  : " + fileName3  );
	System.out.println("==========================================================");
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
	//  Page 구동시 첨부파일 읽어오기
	//----------------------------------------------------------------------------------------------
    
	function fnStartLoad(){
    	var f = document.form1 ;
    	document.getElementById("s첨부파일1").innerHTML = '<%=fileName1%>';
    	document.getElementById("s첨부파일2").innerHTML = '<%=fileName2%>';
    	document.getElementById("s첨부파일3").innerHTML = '<%=fileName3%>';
    	
    }
    
	//----------------------------------------------------------------------------------------------
	//  목록으로 이동
	//----------------------------------------------------------------------------------------------

    function goList()
	{	
		var frm = document.form2;
		var v_searchWord = 	frm.srch_key.value;
 		frm.action = "<%=root%>/admin-page/admin-main.jsp";
		frm.submit();

	}

	//----------------------------------------------------------------------------------------------
	//  글 저장
	//----------------------------------------------------------------------------------------------

	function goSave()
    {
	 		var frm       = document.getElementById("form1");
	 		var frm2	  = document.form2;
	 		var srch_key  = encodeURIComponent(frm2.srch_key.value);
	 		var srch_type = frm2.srch_type.value;	 		
	 		var vTitle    = document.getElementById("title").value;
	 		var vComment  = document.getElementById("comment").value;
	 		var vModYn1   = document.getElementById("modYn1").value;
	 		var vModYn2   = document.getElementById("modYn2").value;
	 		var vModYn3   = document.getElementById("modYn3").value;
	 		var aFile1    = document.getElementById("attachFile1").value;
			var aFile2    = document.getElementById("attachFile2").value;
			var aFile3    = document.getElementById("attachFile3").value;
			var storeChk  = document.getElementById("storeChk").value;
			var vBsdate   = document.getElementById("bsDate").value;
			var vBedate   = document.getElementById("beDate").value;
			var sFile1    = "";
			var sFile2    = "";
			var sFile3    = "";
	 		var del1      = "";
			var del2      = "";
			var del3      = "";
			
			var vOldComment  = document.getElementById("oldcomment").value;
			
	 		if (confirm("수정하시겠습니까?")) 
			{
	 			//------------------------------------------------------------------------------------------
	 			//  첨부 파일 이름 비교
	 			//------------------------------------------------------------------------------------------	 			
	 			if ('<%=fileName1%>' != ''){
	 			
	 				sFile1 = document.getElementById("s첨부파일1").value;
	 			}
	 			if ('<%=fileName2%>' != ''){
	 						
	 				sFile2 = document.getElementById("s첨부파일2").value;
	 			}
	 			if ('<%=fileName3%>' != ''){
	 			
	 			    sFile3 = document.getElementById("s첨부파일3").value;
	 			}
	 	 			 			
	 			
				if (trim(document.form1.title.value) == "" || trim(document.form1.title.value) == "null") 
				{
				    alert("제목을 입력해 주세요");
				    document.getElementById("title").focus();
						return;
				} 
				
				if (trim(document.form1.comment.value) == "" || trim(document.form1.comment.value) == "null") 
				{
					alert("내용을 입력해 주세요");
					document.getElementById("comment").focus();
					return;
				} 

				if (document.form1.storeCount.value == "0" || document.form1.storeCount.value == "") 
				{
					alert("적용매장을 선택해 주세요");
					 
					return;
			    }
				 if( 
				      ((vModYn1 != 'Y') && (vModYn2 != 'Y') && (vModYn3 != 'Y'))&& 
				      ((vBsdate == '<%=BoardStartDate%>') && (vBedate == '<%=BoardEndDate%>')) && 
				      (vTitle == '<%=sTitle%>') && (vComment == vOldComment) && (storeChk != 'Y')
				   )
				{
					 alert("변경된 내용이 없습니다.");
		 			return;
		 		} 
				
				if(aFile1 == '' && sFile1 == '') 
				{
		 			del1 = '<%=fileOrderNum1%>';
		 		}
		 		if(aFile2 == '' && sFile2 == '') 
		 		{
		 			del2 = '<%=fileOrderNum2%>';
		 		}
		 		if(aFile3 == '' && sFile3 == '') 
		 		{
		 			del3 = '<%=fileOrderNum3%>';
		 		}		 		
	 		frm.action = "<%=root%>/admin-page/admin-writing_ok.jsp?mode1=" + del1 + "&mode2=" + del2 + "&mode3="+ del3 + "&srch_key=" + srch_key + "&srch_type=" + srch_type;
	 		frm.submit();
	 		
			} 
    }

	//----------------------------------------------------------------------------------------------
	//  파일첨부 이름 변경
	//----------------------------------------------------------------------------------------------
	
	function fnChgFname(obj){
		var oName = obj.name ;
		var vGubn = oName.substr(oName.length-1,1);		//구분값
		 
		if (vGubn == "1") {
			document.getElementById("s첨부파일1").innerHTML = "";
		} else if(vGubn == "2") {
			document.getElementById("s첨부파일2").innerHTML = "";
		} else {
			document.getElementById("s첨부파일3").innerHTML = "";
		}
	}
   
	//공백제거
    function trim(s) 
    { 
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }

    //----------------------------------------------------------------------------------------
    //  매장선택 MODAL 팝업처리
    //----------------------------------------------------------------------------------------
	function fnShowStoreList(){
        var url = "<%=root%>/admin-page/admin-store-select.jsp?pageGb=<%=pageGb%>&dataGb=modify&pBOARD_NO=<%=sSeqNum%>"
        var objectName = new Object();
        var style = "dialogWidth:980px;dialogHeight:550px;location:no;toolbar=no;center:yes;menubar:no;status:no;scrollbars:no;resizable:yes";
        document.form1.storeChk.value = 'Y';
        objectName.storeCount = "<%=storeCount%>";
        
       	window.showModalDialog(url, objectName, style);

       	document.form1.storeCount.value = objectName.storeCount;          // 모달 팝업과의 interface
    }

    //----------------------------------------------------------------------------------------------
	//  파일 첨부 초기화
	//----------------------------------------------------------------------------------------------

	function fnIniFile(obj)
	{
		
		var frm    = document.getElementById("form1");
		var aFile1 = document.getElementById("attachFile1");
		var aFile2 = document.getElementById("attachFile2");
		var aFile3 = document.getElementById("attachFile3");
		var sFile1 = document.getElementById("s첨부파일1");
		var sFile2 = document.getElementById("s첨부파일2");
		var sFile3 = document.getElementById("s첨부파일3");

		
		if(obj == "s첨부파일1"){
			
			if(aFile1.value == "" && sFile1.value == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if(!confirm("삭제하시겠습니까?")){
				return;
			}else {
				sFile1.value = "";
				sFile1.style.display = 'none';
				aFile1.style.display = '';
				var input = $("#attachFile1");
				input.replaceWith(input.val('').clone(true));
				frm.modYn1.value='Y';
			}
				 		
		}else if(obj == "s첨부파일2"){
			
			if(aFile2.value == "" && sFile2.value == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if(!confirm("삭제하시겠습니까?")){
				return;
			}else {
				sFile2.value = "";
				sFile2.style.display = 'none';
				aFile2.style.display = '';
				var input = $("#attachFile2");
				input.replaceWith(input.val('').clone(true));
				frm.modYn2.value='Y';
			}
			
		}else if(obj == "s첨부파일3"){
			
			if(aFile3.value == "" && sFile3.value == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if(!confirm("삭제하시겠습니까?")){
				return;
			}else{
				sFile3.value = "";
				sFile3.style.display = 'none';
				aFile3.style.display = '';
				var input = $("#attachFile3");
				input.replaceWith(input.val('').clone(true));
				frm.modYn3.value='Y';
			}
		}
		
	}

	//----------------------------------------------------------------------------------------------
	//  글 수정시 첨부파일의 변화 감지
	//----------------------------------------------------------------------------------------------

	function fnModYn(strYn, obj){
			
			var frm = document.form1;
			
			if (obj == 's첨부파일1'){
				frm.modYn1.value=strYn;	
			}else if (obj == 's첨부파일2'){
				frm.modYn2.value=strYn;	
			}else if (obj == 's첨부파일3'){
				frm.modYn3.value=strYn;	
			}
			
			
	}
	
	//----------------------------------------------------------------------------------------------
	//  첨부파일 삭제
	//----------------------------------------------------------------------------------------------

	function fnDeleteFile(obj)
	{
		
		var aFile1 = document.getElementById("attachFile1").value;
		var aFile2 = document.getElementById("attachFile2").value;
		var aFile3 = document.getElementById("attachFile3").value;
		
		if(obj == "s첨부파일1"){
			
			if(aFile1 == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if (!confirm("삭제하시겠습니까?")){
				return;
			}else{
				var input = $("#attachFile3");
				input.replaceWith(input.val('').clone(true));
			}
		}else if(obj == "s첨부파일2"){
			
			if(aFile2 == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if (!confirm("삭제하시겠습니까?")){
				return;
			}else{
				var input = $("#attachFile2");
				input.replaceWith(input.val('').clone(true));
			}
		}else if(obj == "s첨부파일3"){
			
			if(aFile3 == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if (!confirm("삭제하시겠습니까?")){
				return;
			}else{
				var input = $("#attachFile1");
				input.replaceWith(input.val('').clone(true));
			}
		}
		
	}
    </script>
</head>

<body onload="fnStartLoad();">
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
 		 		
				<div id="cont-list" class="write list-wide">
				<p>▶ <%=pageTitle%> 등록</p>
					<form id= "form1" name="form1" method="post" enctype="multipart/form-data">
					<input type="hidden" id ="seqNum" 			 name="seqNum" 	       value="<%=sSeqNum%>"   > <!-- 목록순번    		 -->
					<input type="hidden" id ="pageGb" 			 name="pageGb" 		   value="<%=pageGb%>"    > <!-- 게시구분    		 -->
					<input type="hidden" id ="inCurPage" 		 name="inCurPage" 	   value="<%=inCurPage%>" > <!-- 현재 페이지		 -->
				  	<input type="hidden" id="modYn1"  			 name="modYn1"         value=""               > <!-- 첨부파일수정여부    -->
					<input type="hidden" id="modYn2"     		 name="modYn2"         value=""               > <!-- 첨부파일수정여부    -->
					<input type="hidden" id="modYn3"     		 name="modYn3"         value=""               > <!-- 첨부파일수정여부    -->
					<input type="hidden" id="storeChk"     		 name="storeChk"       value=""               > <!-- 적용매장수정여부    -->	
				  	<input type="hidden" id="sDate"     		 name="sDate"          value="<%=StartDate %>" >  <!-- 조회시작날짜 -->
					<input type="hidden" id="eDate" 			 name="eDate"          value="<%=EndDate %>"	>  <!-- 조회종료날짜 -->
				  	<input type="hidden" id="oldcomment"         name="oldcomment"     value="<%=sComment%>"       > <!-- 이전내용    -->	
				  		<table>
				  			<col width="15%"/>
				    		<col width="15%"/>
				    		<col width="15%"/>
				    		<col width="*"/>
				    		<col width="15%"/>
				    		<col width="15%"/>
				    		<thead>
				    			<tr >
				      				<%
 		 						if (pageGb.equals("01"))
 		 							{
 		 							%>
				      				<th>작성자</th>
				      				<td width="200px" align="center"><%=sseCustNm %></td>				      				
					      			<th>공지구분</th>
							      			<%
		 		 						if (snoticeKind.equals("1"))
		 		 							{
		 		 							%>
			 					        		<td> 
			 					        			<input type="radio" name="noticeKind" value="1" checked="checked">일반
			   										<input type="radio" name="noticeKind" value="2"> 긴급
			 					      			</td>		
						      				<%
		 		 							} else {
		 		 							%>
		 		 								<td> 
			 					        			<input type="radio" name="noticeKind" value="1">일반
			   										<input type="radio" name="noticeKind" value="2" checked="checked"> 긴급
			 					      			</td>
		 		 							<%
		 		 							}
		 		 							%>
				      				<%
 		 							} else {
 		 							%>
				      				<th>작성자</th>
				      				<td colspan="3" width="200" align="center"><%=sseCustNm %></td>				      				
 		 							<%
 		 							}
 		 							%>
				      				
 		 							<th>적용매장</th>
				      				<td>
				      					<button type="button" class="saveBtn" id="store-part" value="" name="store-part" onclick="fnShowStoreList();">저장</button>
				      					매장선택&nbsp;&nbsp;<input type="text" id="storeCount" name="storeCount" value="<%=storeCount%>" readonly style="width:30px;text-align:center">&nbsp;개 
				      				</td>
				      			</tr>
	 							
							</thead>
				    		<tbody>
				    			<tr>
				        			<th>제목</th>
				        			<td colspan="3"><input type="text" id="title" name="title"  value="<%=sTitle%>"/></td>
				        			<th>게시기간</th>
				      				<td>&nbsp;
										<input type="text"  class="big_0" id="bsDate" name="bsDate" value="<%=BoardStartDate%>" style="width:75px"/> ~ 
										<input type="text"  class="big_0" id="beDate" name="beDate"  value="<%=BoardEndDate%>" style="width:75px"/>
								    </td>
				        			<!-- <td style="text-align: right;"><span style="font-weight:bold; text-align: right;">작성일 :</span>2015-02-14</td> -->
				      			</tr>
				    			<tr>
				      				<td colspan="6">
						        		<textarea class="org-text" id="comment" name="comment" cols="105" rows="20" ><%=sComment%></textarea>						        		
							      	</td>
				      			</tr>
				      			<tr>
 					      				<th>첨부1</th>
				        				<td colspan="6">
				        					<div id="fileDiv1">
				        					
				        						<%
				        						if ("".equals(fileName1)){
				        						%>
				        							<span style="position:absolute; display:none;" id="s첨부파일1" ></span>
				        							<input type="file" id="attachFile1" name="attachFile1" onchange="fnChgFname(this);if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일1');} else {fnModYn('N','s첨부파일1');};" value=""/>&nbsp;
				        							<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnDeleteFile('s첨부파일1');"></button> <!-- 글 삭제 -->
				        						<%	
				        						}else{
				        						%>
					        						<span style="position:absolute;" id="s첨부파일1" ></span>
					        						<input style="display: none;" style="" type="file" id="attachFile1" name="attachFile1" onchange="fnChgFname(this);if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일1');} else {fnModYn('N','s첨부파일1');};" value=""/>&nbsp;
					        						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnIniFile('s첨부파일1');"></button> <!-- 글 삭제 -->
				        						<%
				        						}
				        						%>
				        							
				        					</div>
				        				</td>
 				        			</tr>
 					      			<tr>
 					      				<th>첨부2</th>
				      					<td colspan="6">
				      						<div id="fileDiv2">
				      						
				      							<%
				        						if ("".equals(fileName2)){
				        						%>
				        							<span style="position:absolute; display:none;" id="s첨부파일2" ></span>
				        							<input type="file" id="attachFile2" name="attachFile2" onchange="fnChgFname(this); if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일2');} else {fnModYn('N','s첨부파일2');};" value=""/>&nbsp;
				        							<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnDeleteFile('s첨부파일2');"></button> <!-- 글 삭제 -->
				        						<%	
				        						}else{
				        						%>
					        						<span style="position:absolute;" id="s첨부파일2" ></span>
					        						<input style="display: none;"  type="file" id="attachFile2" name="attachFile2" onchange="fnChgFname(this); if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일2');} else {fnModYn('N','s첨부파일2');};" value=""/>&nbsp;
					        						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnIniFile('s첨부파일2');"></button> <!-- 글 삭제 -->
				        						<%
				        						}
				        						%>
				      						
				      						</div>
				      					</td>
 				        			</tr>
 					      			<tr>
 					      				<th>첨부3</th>
 					      				<td colspan="6">
 					      					<div id="fileDiv3">
 					      					
 					      						<%
				        						if ("".equals(fileName3)){
				        						%>
				        							<span style="position:absolute; display:none;" id="s첨부파일3" ></span>
				        							<input type="file" id="attachFile3" name="attachFile3" onchange="fnChgFname(this); if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일3');} else {fnModYn('N','s첨부파일3');};" value=""/>&nbsp;
				        							<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnDeleteFile('s첨부파일3');"></button> <!-- 글 삭제 -->
				        						<%	
				        						}else{
				        						%>
					        						<span style="position:absolute;" id="s첨부파일3" ></span>
					        						<input style="display: none" type="file" id="attachFile3" name="attachFile3" onchange="fnChgFname(this);if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일3');} else {fnModYn('N','s첨부파일3');};" value=""/>&nbsp;
					        						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnIniFile('s첨부파일3');"></button> <!-- 글 삭제 -->
				        						<%
				        						}
				        						%>
				        						
 					      					</div>
 					      				</td>
 				        			</tr>
				    		</tbody>
				  		</table>
				 		<p class="btn">
				 			<button type="button" class="golistBtn" onclick="goList();">목록</button>
				 			<button type="button" class="saveBtn" onclick="goSave();">저장</button>
				 			<!-- <button type="button" class="saveBtn" onclick="goSave();">저장</button> -->
				 		</p>
					</form> 
					<form id="form2" name="form2" method="post">
						<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
						<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
						<input type="hidden" name="inCurPage"      id="inCurPage"      value="<%=inCurPage %>"      >  <!-- 현재 페이지 -->
						<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
					    <input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb %>"         >  <!-- 게시판 종류 구분 값 -->
						<input type="hidden" name="sDate"          id="sDate"          value="<%=StartDate %>"         >  <!-- 조회시작날짜 -->
						<input type="hidden" name="eDate"    	   id="eDate"          value="<%=EndDate %>"		>  <!-- 조회종료날짜 -->
						<input type="hidden" name="inqGubun"       id="inqGubun"       value="<%=QryGubun %>"		>  <!-- 검색구분자 -->
						</form> 
				</div>
			</div>
		</section>

	 		<!-- modal popup -->
		 	<div class="overlay-bg-half"></div>
	</div>

</body>
</html>