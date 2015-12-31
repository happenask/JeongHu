<%-- <%
/** ############################################################### */
/** Program ID   : detail_view.jsp                                  */
/** Program Name : 게시판 상세보기                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %> 
<%@ page import="board.beans.listBean" %> 
<%@ page import="board.dao.listDao" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.beans.listBean"%>

<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>


<%
	String listNum    = JSPUtil.chkNull((String)paramData.get("listNum"),   "" ); //게시판 번호
	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb"),    "" ); //게시판 구분
	
	System.out.println("detail.jsp================================================");
	System.out.println("listNum : " + listNum);
	System.out.println("========================================================");
	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),"");  //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),"");  //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),"");  //브랜드코드
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),"");  //매장코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),"");  //등록자명
	
	String hit            = JSPUtil.chkNull((String)request.getParameter("hit"           ),"");  //조회수 증가//&hit=no
	String readChkList    = JSPUtil.chkNull((String)request.getParameter("readChkList"   ),"");  //긴급공지조회확인여부
	String srch_key       = JSPUtil.chkNull((String)request.getParameter("srch_key"      ),"");  //검색어
	String srch_type      = JSPUtil.chkNull((String)request.getParameter("srch_type"     ),"0"); //검색종류
	String decodeYn       = JSPUtil.chkNull((String)request.getParameter("decodeYn"      ),"");  //디코드유무
	
 	if("n".equals(decodeYn)){
 		//no work
	}else{
		System.out.println("decodeYn2   : " + decodeYn);
		srch_key =  URLDecoder.decode(srch_key , "UTF-8");
	} 
	
	//상세보기에서 보고있던 목록으로 이동하기 위해서
	int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1")); // 현재 페이지
	int inCurBlock   = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1")); // 현재 블럭
	
	
	listBean bean                    = null; //리스트 목록용
	listBean commBean                = null; // 댓글리스트 목록용
	listDao  dao                     = new listDao();
	ArrayList<listBean> list         = null;
	ArrayList<listBean> listTemp     = null;
	ArrayList<listBean> listComm     = null;
	ArrayList<listBean> listDownload = null;
	int listCommCnt                  = 0;
	int fileCnt                      = 0;
	
	String pageTitle   = "공지 사항 상세";
	String writeYn     = "N";
	String fileYn      = "N"; //Y:파일존재 N:파일없음
	String fileName    = "";
	String fileName1   = "";
	String orgFileName = "";
	String storeNm     = "";
	String custStoreCd = "";
	
	paramData.put("sseGroupCd"    ,   sseGroupCd     );
	paramData.put("sseCorpCd"     ,   sseCorpCd      );
	paramData.put("sseBrandCd"    ,   sseBrandCd     );
	paramData.put("sseCustStoreCd",   sseCustStoreCd );
	paramData.put("sseCustNm"     ,   sseCustNm      );
	paramData.put("listNum"       ,   listNum        );
	paramData.put("pageGb"        ,   pageGb         );
	paramData.put("inCurPage"     ,   inCurPage      );
	paramData.put("inCurBlock"    ,   inCurBlock     );
	paramData.put("srch_key"      ,   srch_key       );
	paramData.put("srch_type"     ,   srch_type      );
	
	if("01".equals(pageGb) || "02".equals(pageGb)){
		
		fileCnt = dao.selectNoticeDownloadCnt(paramData); //첨부파일 개수
		
		if(fileCnt > 0 )
		{
			fileYn    = "Y"; //Y:파일존재 N:파일없음
			listDownload = dao.selectNoticeDownloadList(paramData); //첨부파일 리스트
			
		}
	}else if("11".equals(pageGb) || "12".equals(pageGb)){
		
		fileCnt = dao.selectRequestDownloadCnt(paramData);	//첨부파일 갯수
		
		if(fileCnt > 0 )
		{
			fileYn    = "Y"; //Y:파일존재 N:파일없음
			listDownload = dao.selectRequestDownloadList(paramData); //첨부파일 리스트
			
		}
	}
	
	String cRead     = dao.selectReadConFirm(paramData);   //게시배포정보 확인하기
	String reqStatus = dao.selectRequestStatus(paramData); //건의요청등록정보 요청상태코드
	
	//게시판 구분값에 따라 목록 조회
	/*
	* 각 게시판에 맞게 추가해서 정보 조회
	*/
	String name    = ""; //작성자
	
	if(pageGb.equals("01")){
		pageTitle = "공지 사항";
		writeYn = "N";
		
		if ("".equals(hit)){
			dao.updateNoticeReadCount(paramData); //조회수 업데이트
		}
		
 		list        = dao.selectNoticeDetail(paramData); //상세보기 정보 조회 
 		listComm    = dao.selectCommList(paramData);     //댓글 정보 조회
 		listCommCnt = dao.selectCommListCount(paramData);//댓글 갯수
 		 		 			
 				
	}else if(pageGb.equals("02")){
		pageTitle = "교육 자료";
		writeYn = "N";
		
		if("".equals(hit)){
			dao.updateNoticeReadCount(paramData); //조회수 업데이트
		}
		
 		list        = dao.selectNoticeDetail(paramData); //상세보기 정보 조회 
		listComm    = dao.selectCommList(paramData);     //댓글 정보 조회
 		listCommCnt = dao.selectCommListCount(paramData);//댓글 갯수
 		 		
	}else if(pageGb.equals("11")){
		pageTitle = "매장 건의 사항";
		writeYn = "Y";
 		
 		listTemp     = dao.selectProposalDetail(paramData);        //상세보기 정보 조회
 		
 		if(listTemp != null && listTemp.size() > 0){
 			bean        = (listBean)listTemp.get(0);		
 			name        = bean.get등록자();
 			custStoreCd = bean.get매장코드();
			
			paramData.put("sseCustStoreCd",   custStoreCd );      //조회글의 매장코드정보
 			
 			if("11".equals(pageGb)){
 				if("".equals(hit) && (!custStoreCd.equals(sseCustStoreCd)) ){
 		 			dao.updateProposalReadCount(paramData);       //조회수 업데이트
 				}
 			}
 		}
 		paramData.put("sseCustStoreCd",   sseCustStoreCd );       //세션이 가진 매장코드정보
 		
 		list        = dao.selectProposalDetail(paramData);        //상세보기 정보 조회
 		storeNm     = dao.selectRequestStoreName(paramData);      //매장명 가져오기
 		listComm    = dao.selectProposalCommList(paramData);      //댓글 정보 조회
 		listCommCnt = dao.selectProposalCommListCount(paramData); //댓글 갯수
 		
	}else if(pageGb.equals("12")){
		pageTitle = "매장 요청 사항";
		writeYn = "Y";
		
		listTemp     = dao.selectProposalDetail(paramData);        //상세보기 정보 조회
 		
 		if(listTemp != null && listTemp.size() > 0){
 			bean     = (listBean)listTemp.get(0);		
 			name     = bean.get등록자();
			custStoreCd = bean.get매장코드();
			
			paramData.put("sseCustStoreCd",   custStoreCd );      //조회글의 매장코드정보
			
 			if("12".equals(pageGb)){
 				if("".equals(hit) && (!custStoreCd.equals(sseCustStoreCd)) ){
 		 			dao.updateProposalReadCount(paramData);     //조회수 업데이트
 				}
 			}
 		}
 		paramData.put("sseCustStoreCd",   sseCustStoreCd );       //세션이 가진 매장코드정보
 		
 		list        = dao.selectProposalDetail(paramData);        //상세보기 정보 조회
 		storeNm     = dao.selectRequestStoreName(paramData);      //매장명 가져오기
 		listComm    = dao.selectProposalCommList(paramData);      //댓글 정보 조회
 		listCommCnt = dao.selectProposalCommListCount(paramData); //댓글 갯수
		
	}
	
	
//	String name    = ""; //작성자
	String title   = ""; //제목
	String comment = ""; //내용
	String addDate = ""; //등록일
	String readCnt = ""; //조회수
	
	String commName    = ""; //작성자
	String commComment = ""; //내용
	String commAddDate = ""; //등록일
	String commNum     = "";
	String noticeGb    = ""; //공지구분
	String noticeGbCd  = ""; //공지구분코드값
	
	String sTitle = "";
	//상세 정보
	if(list != null && list.size() > 0){
		bean     = (listBean)list.get(0);		
		name     = bean.get등록자();
		title    = bean.get제목();
		comment  = bean.get내용();
		addDate  = bean.get등록일자();
		readCnt  = bean.get조회수();
		
		if("01".equals(pageGb)){
			
			noticeGb = bean.get공지구분();
			noticeGbCd = noticeGb ;
			
			if("1".equals(noticeGb)){
				noticeGb = "일반";
			}else if("2".equals(noticeGb)){
				noticeGb = "긴급";
			}
		}else if("02".equals(pageGb)){
			
			noticeGb = bean.get공지구분();
			noticeGbCd = noticeGb ;
			noticeGb = "교육";
			
		}else if("11".equals(pageGb) || "12".equals(pageGb)){
		
			noticeGb = bean.get요청구분();
			noticeGbCd = noticeGb ;
			
			if("00".equals(bean.get요청구분())){
				noticeGb = "건의";
			}else if("01".equals(bean.get요청구분())){
				noticeGb = "물류";
			}else if("02".equals(bean.get요청구분())){
				noticeGb = "POS";
			}else if("03".equals(bean.get요청구분())){
				noticeGb = "인테리어";
			}
		}
	}
		
	//댓글 정보
	if(listComm != null && listComm.size() > 0){
		
		commBean    = (listBean)listComm.get(0);		
		commName    = commBean.get등록자();
		commComment = commBean.get내용();
		commAddDate = commBean.get등록일자();
		commNum     = commBean.get게시번호(); 
		
	}

	
%>

<!DOCTYPE html>
<html>
<head>
	<!-- 공용정의파일 -->
	<%@ include file="/include/common_file.inc" %>
     
     <script type="text/javascript">
    $(document).ready(function()
	{  
   	    if("<%=writeYn%>" == "N"){
   	    	//$("#wrBtn").hide(); //임시 주석처리 권한에 따라 글쓰기 권한 부여
   	    }
   	    
   	    $("#header .gnb>ul").find("li#"+"<%=pageGb %>").addClass("active");
    });
   
    
    function showComment(){
    	//alert("▼ 총 덧글");	
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
    
    
    function goWrite()
	{  
    	var frm = document.getElementById("form1");
		
 		frm.action = "<%=root%>/board/detail_write.jsp?modify=modify&listNum="+<%=listNum%>;
		frm.submit();	 
	}
    
    function goDelete()
    {
		var frm = document.getElementById("form1");
		
		if(!confirm("삭제하시겠습니까?")){
			return;
		}else{
	 		frm.action = "<%=root%>/board/delete_ok.jsp?listNum="+<%=listNum%>+"&pageGb="+<%=pageGb%>;
			frm.submit();
	    }
    }
    
    function goCommWrite(num)
	{  
    	
    	var viewObj = $('#list_'+num+' #comm_text'); //현 댓글
    	var txtObj  = $('#list_'+num+' #txt'+num);	 //수정입력칸
    	var frmObj  = $('#list_'+num+' #frm'+num);   //수정데이터 폼
    	var delObj  = $('#list_'+num+' #deleteBtn'); //삭제 버튼
    	var wrObj   = $('#list_'+num+' #wrBtn');     //수정 버튼
    	var saveObj = $('#list_'+num+' #saveBtn');   //저장 버튼
    	var closeObj = $('#list_'+num+' #closeBtn'); //취소 버튼
    	
    	txtObj.val(viewObj.html());
    	    	
    	viewObj.hide();
    	delObj.hide();
    	wrObj.hide();
    	
    	frmObj.show();
    	saveObj.show();
    	closeObj.show();
    	
	}
    
    function closeComm(num)
	{  
    	
    	var viewObj = $('#list_'+num+' #comm_text'); //현 댓글
    	var txtObj  = $('#list_'+num+' #txt'+num);	 //수정입력칸
    	var frmObj  = $('#list_'+num+' #frm'+num);   //수정데이터 폼
    	var delObj  = $('#list_'+num+' #deleteBtn'); //삭제 버튼
    	var wrObj   = $('#list_'+num+' #wrBtn');     //수정 버튼
    	var saveObj = $('#list_'+num+' #saveBtn');   //저장 버튼
    	var closeObj = $('#list_'+num+' #closeBtn'); //취소 버튼
    	
    	viewObj.show();
    	delObj.show();
    	wrObj.show();
    	
    	frmObj.hide();
    	saveObj.hide();
    	closeObj.hide();
    	
	}
    
    function goCommConfirm(num)
    {
    	var viewObj = $('#list_'+num+' #comm_text'); //현 댓글
    	var txtObj  = $('#list_'+num+' #txt'+num);	 //수정입력칸
    	
    	var frm = document.getElementById("frm"+num);
    	var writeYN = document.getElementById("txt"+num).value;//comm_write
    	var no = "no";
		if (!trim(writeYN)){
			alert("댓글을 입력해주세요~!");
			<%-- frm.action = "<%=root%>/board/detail_view.jsp?hit="+no;
			frm.submit(); --%>
			return;
		}else if(txtObj.val() == viewObj.html()){
			alert("변경사항이 없습니다.");
			return;
		}else{
			frm.action = "<%=root%>/board/comm_write_ok.jsp?mode=m&cNum="+num;
			frm.submit();
		}
    	
    }
    
    function goCommDelete(num)
    {
    	var frm = document.getElementById("frm"+num);
    	
    	if(!confirm("삭제하시겠습니까?")){
			return;
		}else{
	    	frm.action = "<%=root%>/board/comm_write_ok.jsp?mode=d&cNum="+num;
			frm.submit();
		}
    }
    
    function goWriteComment()
	{  
    	var frm = document.getElementById("form2");
    	var writeYN = document.getElementById("comm_write").value;//comm_write
    	var no = "no";
    	
		if (writeYN == ''){
			alert("댓글을 입력해주세요~!");
			frm.action = "<%=root%>/board/detail_view.jsp?hit="+no;
			frm.submit();
		}else{
 			frm.action = "<%=root%>/board/comm_write_ok.jsp";
			/* frm.submit(); */
		}
	}
    
    function fnComRead()
    {
    	var frm = document.getElementById("form1");
    	frm.action = "<%=root%>/board/delete_ok.jsp?mode=read";
		/* frm.submit(); */
    	
    }
    
	function fnFileDown()
    {
		var vfile = encodeURIComponent("<%=fileName%>");
    	location.href= "<%=root%>/board/filedown.jsp?fname="+vfile+"&gubn=1";	
    	
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
			<script type="text/javascript">	$(".header-bg").load("../include/header.jsp"); </script> 
		</section>
		
	 	<section id="info-panel">
		<!-- info-panel include-->
			<script type="text/javascript">	$("#info-panel").load("../include/edit-info.jsp"); </script> 
		</section>
		
	<!--#### 메뉴 끝 ####--> 	
	 	
 		 <section class="contents">
 		 	<header>
 		 		<h1>◎ <span><%=pageTitle %></span></h1>
 		 	</header>
 		 	
				<div id="dtl_section" class="view">
					<form id="form1" name="form1" method="post">
						<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		   >  <!-- 검색어 -->
						<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		   >  <!-- 검색타입 -->
						<input type="hidden" name="inCurPage"      id="inCurPage"      value="<%=inCurPage %>"         >  <!-- 현재 페이지 -->
						<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		   >  <!-- 현재 블럭 -->
						<input type="hidden" name="listNum"        id="listNum"        value="<%=listNum %>"           >  <!-- 게시판 번호 -->
					    <input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb %>"            >  <!-- 게시판 종류 구분 값 -->
					    <input type="hidden" name="sseCustNm"      id="sseCustNm"      value="<%=sseCustNm %>"         >  <!-- 등록자명 -->
						<input type="hidden" name="no"             id="no"             value="<%=noticeGbCd%>" 		   >  <!-- 요청 구분 값 -->
						
				 		<p class="btn above">
			    			<%
			    				if (custStoreCd.equals(sseCustStoreCd)){
			    			%>
			    					<button  type="button" class="deleteBtn" id="deleteBtn" onclick="goDelete()"></button> <!-- 글 삭제 -->
			    					<button  type="button" class="modifyBtn" id="wrBtn"     onclick="goWrite()"></button>  <!-- 글 수정 -->
			    					
			    			<%
			    				}
			    				if ("no".equals(readChkList)){
			    			%>
				 					<button type="button" class="golistBtn" onclick="goUnList('<%=pageGb %>');"></button> <!-- 목록이동 -->
				 			<%
			    				}else{
				 			%>
				 					<button type="button" class="golistBtn" onclick="goList('<%=pageGb %>');"></button> <!-- 목록이동 불가 -->
				 			<%
			    				}
				 			%>
				 		</p>
				  		<table>
				  			<col width="15%"/>
				    		<col width="20%"/>
				    		<col width="15%"/>
				    		<col width="20%"/>
				    		<col width="15%"/>
				    		<col width="10%"/>
				    		<thead>
				    			<tr>
				      				<th>제목</th>
				      				<td colspan="4"><b>[<%=noticeGb%>]</b>&nbsp;<%=title %></td>
				      			<%
				        			//if( "01".equals(pageGb))
				      				if( "01".equals(pageGb) || "02".equals(pageGb))
				      				{
				      					
				      					if("N".equals(cRead))
				      					{
				      			%>
						      				<td > <button class="btn_search_ok" id="btn_ok" name="btn_ok" onclick="fnComRead();"></button> <!-- 공지확인버튼  --></td>
				      			<%
				      					}else if("Y".equals(cRead))
				      					{
				      			%>
						      				<td> <button class="btn_search_ok2" id="" name="" disabled="disabled" ></button> <!-- 공지확인버튼  --> </td>
				      			<%
				      					}else{
							    %>
					      					<td> </td>
					      		<%		
					      				}
					      		
				      				}else if ("12".equals(pageGb) ){
				      					if(name.equals(sseCustNm)){
					      					if("1".equals(reqStatus))
					      					{
					      			%>
							      				<td align="right" style="color: red"> * 답변 대기중 *</td>
					      			<%
					      					}else if("9".equals(reqStatus))
					      					{
					      			%>
							      				<td align="right" style="color: blue"> * 답변 완료 *</td>
					      			<%
					      					}else{
								      			%>
						      					<td> </td>
						      		<%		
						      				}
				      					}
				      				}else{
				      			%>
				      					<td> </td>
				      			<%		
				      				}
				      			%>
				      			</tr>
				      			
				    			<tr>
				      			<%
				      				if("11".equals(pageGb) || "12".equals(pageGb)){
				      			%>	
				      				<th>매장</th><td><%=storeNm %></td>
				      			<%
				      				}else if ("01".equals(pageGb) || "02".equals(pageGb)){
				      			%>
				      				<th>작성자</th><td><%=name %></td>
				      			<%
				      				}
				      			%>
				        			<th>등록일</th><td><%=addDate%></td>
				        			<th>조회수</th><td><%=readCnt %></td>
				      			</tr>
				      			
				    		</thead>
				    		<tbody>
				    			<tr>
				      				<td colspan="5">
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
				      						bean = (listBean) listDownload.get(i);
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
					 <!-- 덧글영역 -->
					 <form id="form2" name="form2" method="post">
					 <div id="write_comm">
					      <p>덧글입력</p> 
					      
					      <input type="hidden" name="listNum"    id="listNum"    value="<%=listNum %>"        >  <!-- 게시판 번호 -->
					      <input type="hidden" name="pageGb"     id="pageGb"     value="<%=pageGb %>"         >  <!-- 게시판 종류 구분 값 -->
					      <input type="hidden" name="srch_key"   id="srch_key"   value="<%=srch_key %>"       >  <!-- 검색어 -->
						  <input type="hidden" name="srch_type"  id="srch_type"  value="<%=srch_type %>"      >  <!-- 검색타입 -->
						  <input type="hidden" name="inCurPage"  id="inCurPage"  value="<%=inCurPage %>"      >  <!-- 현재 페이지 -->
						  <input type="hidden" name="inCurBlock" id="inCurBlock" value="<%=inCurBlock %>"	  >  <!-- 현재 블럭 -->
					       
					      <textarea cols="90" rows="4" id="comm_write" name="comm_write" ></textarea>
					      <!-- <button class="btn_blank gray" id="btn_input" name="btn_input" onclick="input();">확인</button> -->
					      <button class="btn_blank" id="btn_input" name="btn_input" onclick="goWriteComment();"></button> <!-- 댓글 입력버튼  --> 
				     </div>
    				 </form>
    
					<%-- <!-- <div id="comment"> -->
					<div style="overflow-y:auto; width:*; height:150px; border:1 solid #000000;"  id="comment">
						<p  class="count" onclick="showComment();"><span class="mark">▶</span> 총 덧글 (<span class="num"> <%=listCommCnt %> </span>)</p>  
						<ul class="comm_list hidden">     --%> 
					<div id="comment">
					<!--2015.5.7 댓글 스크롤바 추가 hjChoi -->
					<p  class="count" onclick="showComment();"><span class="mark">▶</span> 총 댓글 (<span class="num"> <%=listCommCnt %> </span>)</p>  
						<div class="count_all" style="width:*; height:*px; display:none;">
							<div style="overflow-y:auto; width:*; height:300px; border:1 solid #000000;"  >
							<ul class="comm_list hidden">
								
							<%
								
									for( int i = 0; i < listComm.size(); i++ ) 
						            {
											commBean = (listBean) listComm.get(i);
											if ( listNum.equals(commBean.get게시번호()) )
											{
							%>
										<li id = 'list_<%=commBean.get댓글번호()%>'>
							  				<p><span class="writer"><%=commBean.get등록자()%> </span><span class="date"> <%=commBean.get등록일자() %> </span></p>
					          				<span id="comm_btn">											
												<%
							    					if (sseCustNm.equals(commBean.get등록자())){
						    					%>
						    						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="goCommDelete('<%=commBean.get댓글번호()%>')"></button> <!-- 글 삭제 -->
		    										<button  type="button" class="modifyBtn" id="wrBtn"     name="wrBtn"     onclick="goCommWrite('<%=commBean.get댓글번호()%>')"></button>  <!-- 글 수정 -->
		    										
						    					<%
						    						}
						    					%>
						    				</span>
						    				<div>
						          				<pre><div id="comm_text" class="comm" value="<%=commBean.get내용() %>"><%=commBean.get내용() %></div></pre>	
																		    			
								    			<form id="frm<%=commBean.get댓글번호()%>" name="frm<%=commBean.get댓글번호()%>" style="display: none;" method="post">
													<input type="hidden" name="listNum"   id="listNum"    value="<%=commBean.get게시번호() %>"  >  <!-- 게시판 번호 -->
					      							<input type="hidden" name="pageGb"    id="pageGb"     value="<%=commBean.get게시구분() %>"  >  <!-- 게시판 구분 -->
					      							<input type="hidden" name="commGb"    id="commGb"     value="<%=commBean.get댓글번호() %>"  >  <!-- 게시판 댓글 번호 -->
					      							<input type="hidden" name="mode"      id="mode"       value="m"                             >  <!-- 모드 -->
					      							<input type="hidden" name="srch_key"  id="srch_key"   value="<%=srch_key %>"                >  <!-- 검색어 -->
													<input type="hidden" name="srch_type" id="srch_type"  value="<%=srch_type %>"               >  <!-- 검색타입 -->
													<input type="hidden" name="inCurPage" id="inCurPage"  value="<%=inCurPage %>"               >  <!-- 현재 페이지 -->
													<input type="hidden" name="inCurBlock"id="inCurBlock" value="<%=inCurBlock %>"		        >  <!-- 현재 블럭 -->
												    <input type="hidden" name="pageGb"    id="pageGb"     value="<%=pageGb %>"                  >  <!-- 게시 구분 -->
												    <input type="hidden" name="sseCustNm" id="sseCustNm"  value="<%=sseCustNm %>"               >  <!-- 등록자명 -->
																				
													<textarea cols="90" id="txt<%=commBean.get댓글번호()%>" name="txt<%=commBean.get댓글번호()%>" class="txt" ></textarea>
													<button  type="button" class="saveBtn"   id="saveBtn"   name="wrBtn"  style="display: none;"   onclick="goCommConfirm('<%=commBean.get댓글번호()%>')"></button>  <!-- 수정 등록 -->
													<button  type="button" class="closeBtn"   id="closeBtn"   name="closeBtn"  style="display: none; border-radius:10px" onclick="closeComm('<%=commBean.get댓글번호()%>')"></button>  <!-- 취소 -->
												</form>
												
											</div>
										</li>
										
							<%
											}
									}
								
							%>
							<!-- <li>
					  			<p><span class="writer">unitas </span><span class="date"> 2015-03-02</span></p>
			          			<div id="comm_text" class="comm">덧글덧글덧글덧글덧글덧글덧글..</div> 
							</li>
							<li>
					  			<p><span class="writer">unitas </span><span class="date"> 2015-03-01</span></p> 
			          			<div id="comm_text" class="comm" style="padding-left:50px; color:#bbb;"> - 비밀 덧글입니다.</div> 
							</li>
							-->
								</ul>
							</div> 
						</div>
					</div>
				</div>
			</section>

	 		<!-- modal popup -->
		 	<div class="overlay-bg-half"></div>
	</div>

<script type="text/javascript">
	//$("table thead th").last().css("background","none");
	
	function goList(pageGb)
	{	
		var frm = document.getElementById("form1");
    	frm.action = "<%=root%>/board/list.jsp";
    	frm.submit();
		
	}
	
	function goUnList(pageGb)
	{	
		alert("조회확인 버튼을 눌러주세요!");
		return;
		
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

</body>
</html>