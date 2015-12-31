
<!-- 
/** ############################################################### */
/** Program ID   : main.jsp                                         */
/** Program Name :  home	       						            */
/** Program Desc :  프로그램 메인 									*/
/** Create Date  :   2015.02.10						              	*/
/** Update Date  :                                                  */
/** Programmer   :   s.h.e                                          */
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
<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());
%>

<!DOCTYPE html>
<html>
<head>
<!-- 공용정의파일 -->
<%@ include file="/include/common_file.inc" %>
	<title>KCFM</title>  
    
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
</head>

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
	 	
	 	<section id="main">
	 	<div style="width:100%;height:100%;text-align: center;">
	 		<img alt="" src="/KCFM/assets/images/dashboard_example.png"  style="width:100%;height:100%;">
	 	</div>
	 	</section>
<%--  		 <section id="main">
 		 	<div class="up-stairs">
	         	<article class="left">
	         		<header id="h-menu-1">공지 사항
	         			<input type="button" id="" class="nv-bord-btn more-btn" value="more" class="button" onclick="location.href= '<%=root%>/board/list.jsp?pageGb=01'">
	 				</header>
	         		<div style="scroll">
						<ol>
	
							<li>
								<span class="summary">조회된 내용이 없습니다.</span>
							</li>
						</ol>
	         		</div>
	 			</article>
	 			
	         	<article class="right">
	         		<header id="h-menu-2">교육 자료
	         			<input type="button" id="" class="nv-bord-btn more-btn" value="more" class="button" onclick="location.href= '<%=root%>/board/list.jsp?pageGb=02'">
	         		</header>
	         		<div>
						<ul>
							<li><span class="title"></span>&nbsp;<a href="<%=root%>/board/detail_view.jsp?pageGb=02&listNum=""><img src="assets/images/view.gif" width="56" height="24" align="bottom" alt="영상보기"/></a></li>
							<li><span class="title">조회된 내용이 없습니다.</span></li>
				</ul>
	         		</div>
	 			</article>
			 	<!-- 동영상재생
			  	<div id="public_tv" class="overlay-player">
	 				<img src="assets/images/close.png" id="btnCloseLayer" 
										style="cursor:pointer;position:absolute;right:-1px;top:-1px; z-index: 1000;" onclick="$('#public_tv').hide();" alt="닫기 버튼">
					<iframe name="mv2" title='ppj1' width='352px' height='265px' src='http://videofarm.daum.net/controller/video/viewer/Video.html?vid=veeaaIh2i6sDTQQIsspphs2&play_loc=undefined' frameborder='0' scrolling='no' allowfullscreen></iframe>
				</div> -->
	
 			</div>
 		 	<div class="dw-stairs">
	         	<article class="left">
	         		<header id="h-menu-3">매장 건의 사항
	         			<input type="button" id="" class="nv-bord-btn more-btn" value="more" class="button" onclick="location.href= '<%=root%>/board/list.jsp?pageGb=11'">
	         			<input type="button" id="" class="nv-bord-btn write-btn" value="write" class="button" onclick="location.href= '<%=root%>/board/detail_write.jsp?pageGb=11&no=00'">
	         		</header>
	         		<div>
	         			<ol>
							<li>
							
								<span class="title"><a href="<%=root%>/board/detail_view.jsp?pageGb=11&listNum=">[]</a></span><br>
								<span class="summary"></span>
								<span class="date">[]</span>
							</li>
							<li>
								<span class="summary">조회된 내용이 없습니다.</span>
							</li>
						</ol>
	         		</div>
	 			</article>
	 			
	         	<article class="right">
	         		<header id="h-menu-4">매장 요청 사항 & FAQ</header>
	         		<ul id="ic-box-menu2">
	         			<li id="btn-left">
	         				<ul id="ic-box-menu2-sub" class="hidden bd1">
								<li><button type="button" id="btn-1" value="tab1" onclick="location.href= '<%=root%>/board/detail_write.jsp?pageGb=12&no=01'"></button></li>
								<li><button type="button" id="btn-2" value="tab2" onclick="location.href= '<%=root%>/board/detail_write.jsp?pageGb=12&no=02'"></button></li>
								<li><button type="button" id="btn-3" value="tab3" onclick="location.href= '<%=root%>/board/detail_write.jsp?pageGb=12&no=03'"></button></li>
							</ul>
	         				<button type="button" id="btn-r" value="tab1" onclick="location.href= '<%=root%>/board/list.jsp?pageGb=12'"></button>
	         			</li>
	         			<li>
	         				<button type="button" id="btn-f" value="tab2" onclick="location.href= '<%=root%>/board/faq_list.jsp'"></button>
	         			</li>
	         		</ul>
	 			</article>
 			</div>
 		</section> --%>
 	
 		<!-- modal popup -->
	 	<div class="overlay-bg-half">
	 	</div>
	 	
	 	<div class="overlay-bg">
	 		<img id="loadingImage" src="http://i1.daumcdn.net/cfs.tistory/resource/315/blog/plugins/lightbox/images/loading.gif" style="position: relative; cursor: pointer; top: 340px; left: 477px;display: none; ">
	 	</div>
 	</div><!-- wrap end -->
 
</body>
</html>