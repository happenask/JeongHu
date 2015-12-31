<%
/** ############################################################### */
/** Program ID   : admin-new-faq.jsp                                         */
/** Program Name : 관리자 - faq 수정, 신규                        */
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
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-new-faq.jsp");
	String no     = (String)request.getParameter("no");
	//String pageGb     = (String)request.getParameter("pageGb"); 
	String pageGb = new String(request.getParameter("pageGb").getBytes("8859_1"),"UTF-8");
	String fileYn ="Y";	//첨부파일 유무
	
	String pageTitle = "신규 등록";
 	if(pageGb.equals("modify")){
		pageTitle = "수정하기";
	}
	
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
		fnCalendar(); 
		
		if("<%=pageGb%>" == "new"){
			$(".faq").text("");
		}
    });
   
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
	 				<input type="button" id="logout-btn" class="rd-bord-btn" value="로그아웃" class="button" onclick="location.href='../index.html'">
	 				<input type="button" id="main-btn" class="nv-bord-btn" value="MAIN" class="button" onclick="location.href='../main.html'">
	 				<input type="button" id="account" class="rd-bord-btn" value="정보수정 ▶" class="button" onclick="">
	 				</span>
	 			
	 				<div class="gnb">
	 					<div id="currentTime">현재 날짜<span> 현재 시간</span></div>
	 				</div>
	 		</header>
	 		</div>
	 	</section>
	 	
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
	 	</section> -->
	 	
	 	<section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>administrator service &gt; FAQ(자주하는 질문) 관리</span></h1>
 		 	
 		 	</header>
 		 	
 		 	<div id="cont-admin">
 		 		<div class="cont-nav">
 		 			<ul class="admin-menu">
 		 				<li><a href="admin-main.html">공지사항관리</a></li>
 		 				<li><a href="maintain-manual.html">교육자료관리</a></li>
 		 				<li><a href="maintain-proposal.html  ">건의사항관리</a></li>
 		 				<li><a href="maintain-request.html ">요청사항관리</a></li>
 		 				<li class="active"><a href="maintain-faq.html ">FAQ관리</a></li>
 		 				<li><a href="maintain-comment.html">댓글관리</a></li>
 		 			</ul>
 		 		</div>
 		 		
				<div id="cont-list" class="write list-wide">
				<p>▶ faq <%=pageTitle %></p>
					<form name="form1" method="post">
				  		<table>
				  			<col width="16%"/>
				    		<col width="34%"/>
				    		<col width="16%"/>
				    		<col width="34%"/>
				    		<thead>
				      			<tr>
				      				<th rowspan="7">질문</th>
				        			<td colspan="3"><textarea class="faq" id="" name="" cols="105" rows="7">매장에서 일하고 싶은데 어떻게 하면 되나요? 이미 등록 된 자주하는 질문입니다.</textarea></td>
			        			</tr>
				    		</thead>
				    		<tbody>
				      			<tr>
				      				<th rowspan="15">답변</th>
				        			<td colspan="3"><textarea class="faq" id="" name="" cols="105" rows="15">본사 교육 담당자에게 문의 또는 홈페이지 채용공고를 참조해 주세요. 이미 등록 된 자주하는 질문의 답변입니다.</textarea></td>
			        			</tr>
				    		</tbody>
				  		</table>
				 		<p class="btn">
				 			<button type="button" class="golistBtn" onclick="goList('<%=pageGb%>');">목록</button>
				 			<button type="button" class="saveBtn" onclick=";">저장</button>
				 		</p>
					</form> 
				</div>
			</div>
		</section>

 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div>

<script type="text/javascript">

function goList(root)
{
	location.href= "maintain-faq.html"; 
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