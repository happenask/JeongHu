<%
/** ############################################################### */
/** Program ID   : view.jsp                                         */
/** Program Name : 고객센터 / 공지사항                              */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>  

<%
	String no     = (String)request.getParameter("no");
	//String pageGb     = (String)request.getParameter("pageGb"); 
	String pageGb = new String(request.getParameter("pageGb").getBytes("8859_1"),"UTF-8");
	String fileYn ="Y";	//첨부파일 유무
	
	String pageTitle = "공지 사항 상세";
	String writeYn = "N";
	if(pageGb.equals("proposal")){
		pageTitle = "매장 건의 사항 상세";
		writeYn = "Y";
	}else if(pageGb.equals("request")){
		pageTitle = "매장 요청 사항 상세";
		writeYn = "Y";
	}else if(pageGb.equals("customer")){
		pageTitle = "고객의 소리 상세";
		writeYn = "N";
	}else if(pageGb.equals("video")){
		pageTitle = "교육 자료 상세";
		writeYn = "N";
	}
	
%>


<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=9" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	<meta name="keywords" content="" /><!-- 검색용 키워드 -->
 	<meta name="description" content="스쿨푸드 PRM 서비스입니다." /><!-- 페이지 설명 -->
	<title>KCFM 상세보기</title>  
	
	<link href="assets/css/common.css" rel="stylesheet" type="text/css" />
	<!-- IE8 이하에서 미디어 쿼리(Media Query) 사용 지원 -->
	<!--[if lt IE 9]><script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
    <!-- IE 8 이하에서 HTML5 태그 지원하도록 스크립트 링크 -->
    <!-- 참고 글 : http://www.cmsfactory.net/node -->
    <!--[if lt IE 9]><script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script><![endif]-->
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="assets/js/style.js"></script>
     
    <script type="text/javascript">
    $(document).ready(function()
	{  
   	    if("<%=writeYn%>" == "N"){
   	    	$("#wrBtn").hide();
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
    
    
    function goWrite(pageGb)
	{  
		location.href= "<%=pageGb %>-write.jsp?no=0&pageGb="+ pageGb;
	}
    </script>
</head>

<body>
 	<div id="wrap" >
	 	<section class="header-bg">
	 	<div id="header">
	 		<header>
	 			<h1>헤더-타이틀</h1>
	 			<span id="logo">유니포스-로고</span>
	 			<span id="btns">
	 				<input type="button" id="logout-btn" class="rd-bord-btn" value="로그아웃" class="button" onclick="location.href='index.html'">
	 				<input type="button" id="main-btn" class="nv-bord-btn" value="MAIN" class="button" onclick="location.href='main.html';">
 				</span>
	 			
	 			<nav class="gnb">
	 				<ul class="topmenu">
	 					<li class="disable"><a href="#">전자계약</a></li>
	 					<li><a href="transactional-info.html">거래내역</a>
	 						<ul class="submenu">
								<li><a href="transactional-info.html?tabNo=1">매입 현황</a></li>
								<li><a href="transactional-info.html?tabNo=2">여신 현황</a></li>
								<li><a href="transactional-info.html?tabNo=3">재고 현황</a></li>
								<li><a href="transactional-info.html?tabNo=4">카드 승인 내역</a></li>
								<li><a href="transactional-info.html?tabNo=5">매출 현황</a></li>
							</ul>
						</li>
	 					<li><a href="prom-material.html">홍보물신청</a>
	 						<!-- <ul class="submenu">
								<li><a href="prom-material.html?tabNo=1">인쇄사용문구</a></li>
								<li><a href="prom-material.html?tabNo=2">전단지종류</a></li>
								<li><a href="prom-material.html?tabNo=3">전단지선택</a></li>
							</ul> -->
	 					</li>
	 					<li class="disable"><a href="#">메세지전송</a></li>
	 					<li><a href="tax-bill.html ">세금계산서</a>
	 						<ul class="submenu">
								<li><a href="tax-bill.html?tabNo=A">스쿨푸드</a></li>
								<li><a href="tax-bill.html?tabNo=B">Z.POS</a></li>
								
							</ul>
	 					</li>
	 					<li id="customer"><a href="cust-comment.html">고객의소리</a></li>
	 					<li><a href="call-center.html">콜센터</a>
	 						<ul class="submenu">
								<li><a href="call-center.html?tabNo=A">매출통계</a> </li>
								<li><a href="call-center.html?tabNo=B">배달시간관리</a></li>
								<li><a href="call-center.html?tabNo=C">판매상품관리</a></li>
							</ul>
	 					</li>
	 					<li class="disable"><a href="#">상품권</a></li>
	 				</ul>
	 			</nav>
	 		</header>
	 		</div>
	 		
	 		<div id="info-bg">
		 		<div id="info">
		 			<div id="account">
		 				<span>스쿨푸드 유니타스 1호점</span>
		 				<span id="btn"><input type="button" id="mody-btn" class="nv-bord-btn" value="정보변경" class="button" onclick="fnShowPanel();"></span>
		 			</div>
		 			<div id="account-info">
		 				<span id="ph-no">전화번호 : 02-1234-5678 /</span> 
		 				<span id="mb-no">휴대전화 : 010-1234-5678 /</span> 
		 				<span id="charge-man">담당SV : 홍길동(010-5678-1234)</span>
		 			</div>
		 		</div><!-- info end -->
	 		</div>
	 	</section>
	 	
	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
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
	 	
	 	
 		 <section class="contents">
 		 	<header>
 		 		<h1>◎ <span><%=pageTitle %></span></h1>
 		 	</header>
 		 	
				<div id="dtl_section" class="view">
					<form name="form1" method="post">
						<%-- <input type="hidden" name="srch_key"   id="srch_key"   value="<%=srch_key %>"  >  <!-- 검색어 -->
						<input type="hidden" name="srch_type"  id="srch_type"  value="<%=srch_type %>" >  <!-- 검색타입 -->
						<input type="hidden" name="inCurPage"  id="inCurPage"  value="<%=inCurPage %>" >  <!-- 현재 페이지 -->
						<input type="hidden" name="inCurBlock" id="inCurBlock" value="<%=inCurBlock %>">  <!-- 현재 블럭 -->	
						<input type="hidden" name="menuGb"     id="menuGb"     value="customer"        >
						<input type="hidden" name="menuId"     id="menuId"     value="pj_5001"         >
						<input type="hidden" name="tab"        id="tab"        value="1"               > --%>
				
				 		<p class="btn above">
			    			<button  type="button" class="gowriteBtn" id="wrBtn" onclick="goWrite('<%=pageGb %>')"></button>
				 			<button type="button" class="golistBtn" onclick="goList('<%=pageGb %>');"></button> 
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
				      				<td colspan="5"><%=no %> 글</td>
				        			<!-- <td style="text-align: right;"><span style="font-weight:bold; text-align: right;">작성일 :</span>2015-02-14</td> -->
				      			</tr>
				    			<tr>
				      				<th>작성자</th><td>홍길동</td>
				        			<th>등록일</th><td>2015-03-25</td>
				        			<th>조회수</th><td>96</td>
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
					      					}
				      					else{
				      				%>
				        				<div class="comm"> 선택 글 상세 내용 입니다..</div>
			        				<%
				      					}
				      					/* 첨부파일이 있는 경우 다운로드 링크 */
				      					if(fileYn.equals("Y")){
				      				%>
							 			<p class="attached-file">첨부 파일 : <span id="file-name">KCFM-design.pptx 
							 				<a id="download-link" href="assets/res/KCFM-design.pptx">
							 					<img class="mg-auto5" src="assets/images/btns/btn_download.png"  width="110" height="32" id="Image44" align="middle">
							 				</a></span>
							 			</p>
						 			<%}%>
			        				</td>
				      			</tr>
				    		</tbody>
				  		</table>
					</form>
					 <!-- 덧글영역 -->
					 <div id="write_comm">
					      <p>덧글입력</p>  
					      <textarea cols="90" rows="4" id="comm_write" name="comm_write" ></textarea>
					      <!-- <button class="btn_blank gray" id="btn_input" name="btn_input" onclick="input();">확인</button> -->
					      <button class="btn_blank" id="btn_input" name="btn_input" onclick="input();"></button> <!-- 댓글 입력버튼  --> 
				     </div>
    
    
					<div id="comment">
						<p  class="count" onclick="showComment();"><span class="mark">▶</span> 총 덧글 (<span class="num">2</span>)</p>  
						<ul class="comm_list hidden">     
							<li>
					  			<p><span class="writer">unitas </span><span class="date"> 2015-03-02</span></p>
			          			<div id="comm_text" class="comm">덧글덧글덧글덧글덧글덧글덧글..</div> 
							</li>
							<li>
					  			<p><span class="writer">unitas </span><span class="date"> 2015-03-01</span></p> 
			          			<div id="comm_text" class="comm" style="padding-left:50px; color:#bbb;"> - 비밀 덧글입니다.</div>
							</li>
						</ul>
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

    	var url = "notice.html"; 
    	if(pageGb == "proposal"){
    		url = "proposal-list.html";
    	}else if(pageGb == "request"){
    		url = "request-list.jsp";
    	}else if(pageGb == "customer"){
    		url = "cust-comment.html";
    	}else if(pageGb == "video"){
    		url = "training-manual.html";
    	}
		location.href= url; 
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