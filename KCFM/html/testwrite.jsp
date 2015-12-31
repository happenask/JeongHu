<%
/** ############################################################### */
/** Program ID   : write.jsp										*/
/** Program Name : 글쓰기                              							*/
/** Program Desc : 건의글, 문의글 작성                                        			*/
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.testDao" %>
<%@ page import="test.beans.testBean" %>
<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %> 
<%@ include file="/com/common.jsp"%> 

<%
	String root     = request.getContextPath();	
	String sSeqNum  = JSPUtil.chkNull((String)request.getParameter("seqNum"),     ""); //글목록 번호
	int inCurPage   = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurPage"),  "1"));
	int inCurBlock   = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurBlock"),  "1")); 
	
	
	testBean bean = null; 
	testDao  dao  = new testDao();
	
	ArrayList<testBean> list = null;
	String sTitle   = "";
	String sComment = "";
	
	
	//수정용 정보 조회
	if(!"".equals(sSeqNum)){
		paramData.put("seqNum", sSeqNum);
		
		list = dao.selectBoardInfo(paramData);
		
		if(list != null && list.size() > 0){
			bean = (testBean)list.get(0);
			
			sTitle   = bean.get제목();
			sComment = bean.get내용();
		}
		
	}
	
%>


<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=9" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	<meta name="keywords" content="" /><!-- 검색용 키워드 -->
 	<meta name="description" content="스쿨푸드 PRM 서비스입니다." /><!-- 페이지 설명 -->
	<title>글쓰기</title>  
	
	<link href="assets/css/common.css" rel="stylesheet" type="text/css" />
	<!-- IE8 이하에서 미디어 쿼리(Media Query) 사용 지원 -->
	<!--[if lt IE 9]><script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
    <!-- IE 8 이하에서 HTML5 태그 지원하도록 스크립트 링크 -->
    <!-- 참고 글 : http://www.cmsfactory.net/node -->
    <!--[if lt IE 9]><script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script><![endif]-->
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="assets/js/style.js"></script>
     
    <script type="text/javascript">
    function fnChangeAttachFile(img)
    {
    	
    	var attachFile     = "";
    	var attachFilePath = "";
    	var attachFileName = "";
    	
    	document.inquiry_form.attachFileVal.value = "";

    	img.select();
    	
     	if( img.value.match(/\.(gif|jpg|jpeg|png)$/i) ) 
     	{
     		attachFile     = document.selection.createRangeCollection()[0].text.toString();
    		attachFileName = (attachFile).split("\\")[(attachFile).split("\\").length - 1];  // 파일명만 남김
    		document.inquiry_form.attachFileVal.value = attachFile;
    		
//    		alert("attachFile [ "+attachFile+" ]");
//    		alert("attachFileName [ "+attachFileName+" ]");
       	} 
     	else 
     	{
        	img.outerHTML = img.outerHTML;
        	alert('이미지 파일만 올릴수 있습니다.');
       	}
       	
    }

    //목록이동
	function goList(root)
	{	
		var inCurPage = document.getElementById("inCurPage");
		var inCurBlock = document.getElementById("inCurBlock");

		location.href= "testlist.jsp?inCurPage="+inCurPage.value+"&inCurBlock="+inCurBlock.value; 
	}
	
	
    //글저장
	 function goSave(){
		 
			$.ajax(
			{
				url      : "<%=root%>/testwrite_ok.jsp", 
				type     : "POST",
				data     : $("#form1").serialize(), 
				dataType : "html", 
				success  : function(data)
						   {  
							   if( trim(data) == "Y" )
							   { 
								   var num = document.getElementById("inCurPage");
								   location.href= "testlist.jsp?inCurPage="+num; //글 저장 후 목록 이동
							   
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
	 						<ul class="submenu">
								<li><a href="prom-material.html?tabNo=1">인쇄사용문구</a></li>
								<li><a href="prom-material.html?tabNo=2">전단지종류</a></li>
								<li><a href="prom-material.html?tabNo=3">전단지선택</a></li>
							</ul>
	 					</li>
	 					<li class="disable"><a href="#">메세지전송</a></li>
	 					<li><a href="tax-bill.html ">세금계산서</a>
	 						<ul class="submenu">
								<li><a href="tax-bill.html?tabNo=A">스쿨푸드</a></li>
								<li><a href="tax-bill.html?tabNo=B">Z.POS</a></li>
								
							</ul>
	 					</li>
	 					<li><a href="cust-comment.html">고객의소리</a></li>
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
 		 		<h1>◎ <span>매장 건의 글쓰기</span></h1>
 		 	</header>
 		 	
				<div id="dtl_section" class="write">
					<form id="form1" name="form1" method="post">
						<%-- <input type="hidden" name="srch_key"   id="srch_key"   value="<%=srch_key %>"  >  <!-- 검색어 -->
						<input type="hidden" name="srch_type"  id="srch_type"  value="<%=srch_type %>" >  <!-- 검색타입 -->
						<input type="hidden" name="inCurPage"  id="inCurPage"  value="<%=inCurPage %>" >  <!-- 현재 페이지 -->
						<input type="hidden" name="inCurBlock" id="inCurBlock" value="<%=inCurBlock %>">  <!-- 현재 블럭 -->--%>	
						<input type="hidden" name="menuGb"     id="menuGb"     value="customer"        >
						<input type="hidden" name="menuId"     id="menuId"     value="pj_5001"         >
						<input type="hidden" name="tab"        id="tab"        value="1"               > 
						<input type="hidden" name="inCurPage"  id="inCurPage"  value="<%=inCurPage %>" >  <!-- 현재 페이지 -->
						<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
						<input type="hidden" name="seqNum"     id="seqNum"     value="<%=sSeqNum%>" >  <!-- 목록순번 -->
				
				  		<table>
				  			<col width="16%"/>
				    		<col width="*"/>
				    		<tbody>
				    			<tr>
				      				<th>작성자</th>
				        			<td>유니타스 1호점</td>
				      			</tr>
				    			<tr>
				      				<th>제목</th>
				        			<td><input type="text" id="title" name="title"  value="<%=sTitle%>"/></td>
				      			</tr>
				    			<tr>
				      				<td colspan="2">
				        				<p> 
							        		<textarea id="comment" name="comment" cols="105" rows="20" ><%=sComment%></textarea>
							      		</p>
						 			</td>
				      			</tr>
				      			<tr>
				      				<th>첨부</th>
				        			<td><input type="file" id="attachFile" name="attachFile" onchange="fnChangeAttachFile(this);"/>&nbsp;</td>
			        			</tr>
				    		</tbody>
				  		</table>
				 		<p class="btn">
				 			<button type="button" class="golistBtn" onclick="goList('root');">목록</button>
				 			<button type="button" class="saveBtn" onclick="goSave();">저장</button>
				 		</p>
					</form>
					
				</div>
			</section>

	 		<!-- modal popup -->
		 	<div class="overlay-bg-half"></div>
	</div>

</body>
</html>