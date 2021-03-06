<%
/** ############################################################### */
/** Program ID   : address.jsp                                      */
/** Program Name : 배송지 주소                                      */
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

<%@ page import="address.beans.addressBean" %>
<%@ page import="address.dao.addressDao" %>


<%@ page import="com.util.BoardConstant" %>
<%@ include file="/com/common.jsp"%>

<%

	String root = request.getContextPath();

    addressBean bean = null; 
	addressDao  dao  = new addressDao();
	
	ArrayList<addressBean> baseAddrlist   = null;
	ArrayList<addressBean> recentAddrlist = null;
	
	String zip1       = "";
	String zip2       = "";
	String addrBase   = "";
	String addrDetail = "";
	
	String groupCd = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ), ""); //기업코드
	String corpCd  = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ), ""); //법인코드
	String brandCd = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ), ""); //브랜드코드
	String storeCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"), ""); //매장코드
	
	paramData.put("groupCd" , groupCd);
	paramData.put("corpCd"  , corpCd);
	paramData.put("brandCd" , brandCd);
	paramData.put("storeCd" , storeCd);
	
	//기본배송지 조회#########################
	baseAddrlist = dao.selectBaseAddr(paramData); 

	if(baseAddrlist != null && baseAddrlist.size() >0){
		for(int i=0; i< baseAddrlist.size(); i++){
			bean = (addressBean)baseAddrlist.get(i);
			
			zip1       = JSPUtil.chkNull(bean.get우편번호1(), "");
			zip2       = JSPUtil.chkNull(bean.get우편번호2(), "");
			addrBase   = JSPUtil.chkNull(bean.get우편주소(),  "");
			addrDetail = JSPUtil.chkNull(bean.get상세주소(),  "");
			
		} 	
	}
	//기본배송지 조회 끝####################
	
	//회원정보주소지 조회###################
	
	
	//회원정보주소지 조회 끝################

%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=9" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	<meta name="keywords" content="" /><!-- 검색용 키워드 -->
 	<meta name="description" content="스쿨푸드 PRM 서비스입니다." /><!-- 페이지 설명 -->
	<title>배송지정보</title>  
	
	<link href="<%=root%>/assets/css/common.css" rel="stylesheet" type="text/css" />
	<!-- IE8 이하에서 미디어 쿼리(Media Query) 사용 지원 -->
	<!--[if lt IE 9]><script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
    <!-- IE 8 이하에서 HTML5 태그 지원하도록 스크립트 링크 -->
    <!-- 참고 글 : http://www.cmsfactory.net/node -->
    <!--[if lt IE 9]><script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script><![endif]-->
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="<%=root%>/assets/js/style.js"></script>
     
    <script type="text/javascript">
    
    //숫자 입력만
    function onlyNumber(val){
    	//onkeyup="this.value=onlyNumber(this.value);"
    	return val.replace(/[^0-9]/gi, ""); 
    }
    
    //주소찾기 팝업
    function fnAddrPop(){
    	var popUrl = "<%=root%>/address/searchAddressPop.jsp";	
    	var popOption = "width=600, height=500, menubar=no, resizable=no, scrollbars=no, status=no, titlebar=no, tollbar=no";
    		window.open(popUrl,"searchAddressPop",popOption);
    }
    
    //주소지 선택
    function fnSelectAddr(obj){
    	var chkBox = document.getElementsByName("addr_type");
    	
		if(obj == chkBox[1]){//새로운배송지
			document.getElementById("order_zip_1" ).value = "";
			document.getElementById("order_zip_2" ).value = "";
			document.getElementById("order_base"  ).value = "";
			document.getElementById("order_detail").value = "";
			
		}else if(obj == chkBox[0]){//기본배송지
		
			document.getElementById("order_zip_1" ).value  = document.getElementById("hid_order_zip1"  ).value;
			document.getElementById("order_zip_2" ).value  = document.getElementById("hid_order_zip2"  ).value;
			document.getElementById("order_base"  ).value  = document.getElementById("hid_order_base"  ).value;
			document.getElementById("order_detail").value  = document.getElementById("hid_order_detail").value;
			
		}

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
	 				<input type="button" id="logout-btn" class="rd-bord-btn" value="로그아웃" class="button" onclick="location.href='<%=root%>/index.html'">
	 				<input type="button" id="main-btn" class="nv-bord-btn" value="MAIN" class="button" onclick="location.href='<%=root%>/main.html';">
	 				</span>
	 			
	 			<nav class="gnb">
	 				<ul class="topmenu">
	 					<li class="disable"><a href="#">전자계약</a></li>
	 					<li><a href="<%=root%>/transactional-info.html">거래내역</a>
	 						<ul class="submenu">
								<li><a href="<%=root%>/transactional-info.html?tabNo=1">매입 현황</a></li>
								<li><a href="<%=root%>/transactional-info.html?tabNo=2">여신 현황</a></li>
								<li><a href="<%=root%>/transactional-info.html?tabNo=3">재고 현황</a></li>
								<li><a href="<%=root%>/transactional-info.html?tabNo=4">카드 승인 내역</a></li>
								<li><a href="<%=root%>/transactional-info.html?tabNo=5">매출 현황</a></li>
							</ul>
						</li>
	 					<li><a href="<%=root%>/prom-material.html">홍보물신청</a>
	 						<ul class="submenu">
								<li><a href="<%=root%>/prom-material.html?tabNo=1">인쇄사용문구</a></li>
								<li><a href="<%=root%>/prom-material.html?tabNo=2">전단지종류</a></li>
								<li><a href="<%=root%>/prom-material.html?tabNo=3">전단지선택</a></li>
							</ul>
	 					</li>
	 					<li class="disable"><a href="#">메세지전송</a></li>
	 					<li><a href="tax-bill.html ">세금계산서</a>
	 						<ul class="submenu">
								<li><a href="<%=root%>/tax-bill.html?tabNo=A">스쿨푸드</a></li>
								<li><a href="<%=root%>/tax-bill.html?tabNo=B">Z.POS</a></li>
								
							</ul>
	 					</li>
	 					<li><a href="<%=root%>/cust-comment.html">고객의소리</a></li>
	 					<li><a href="<%=root%>/call-center.html">콜센터</a>
	 						<ul class="submenu">
								<li><a href="<%=root%>/call-center.html?tabNo=A">매출통계</a> </li>
								<li><a href="<%=root%>/call-center.html?tabNo=B">배달시간관리</a></li>
								<li><a href="<%=root%>/call-center.html?tabNo=C">판매상품관리</a></li>
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
		<!--#### 메뉴 끝 ####-->	 	
	 	
 		 <section class="contents">
 		 	<header> 
 		 		<h1>◎ <span>배송지정보</span></h1>
 		 	</header>
 		 	<div id="noti-section" class="list">
				<form id="form1" name="form1" method="post">
					<input type="hidden" id="hid_order_zip1"   name="hid_order_zip1"   value="<%= zip1 %>"> <!--주소 체크박스 선택할때 값 입력용-->
					<input type="hidden" id="hid_order_zip2"   name="hid_order_zip2"   value="<%= zip2 %>">
					<input type="hidden" id="hid_order_base"   name="hid_order_base"   value="<%= addrBase %>">
					<input type="hidden" id="hid_order_detail" name="hid_order_detail" value="<%= addrDetail %>">
					
			  		<table>
			  				<tr>
			      				<th rowspan="2">배송지 주소</th>
			      				<td>
			      					<div style="text-align: left;">
			      						<input type="radio" id="addr_type_1" name="addr_type" checked="checked" onclick="fnSelectAddr(this)"/><label for = "addr_type_1" >기본배송지</label>&nbsp;&nbsp;
			      						<input type="radio" id="addr_type_2" name="addr_type" onclick="fnSelectAddr(this)" /><label for = "addr_type_2" >새로운배송지</label>&nbsp;&nbsp;
			      						<input type="radio" id="addr_type_3" name="addr_type" onclick="fnSelectAddr(this)"/><label for = "addr_type_3" >회원정보주소지</label>
			      					</div>
			      				</td>
			      			<tr>	
			      				<td>
			      					<div style="padding-bottom: 5px; text-align: left;">
				      					<input type="text"   id="order_zip_1"      name="order_zip_1"       value="<%=zip1%>"   maxlength="3"  readonly="readonly"  style="width: 50px;"> - <!-- 우편번호1 -->
				      					<input type="text"   id="order_zip_2"      name="order_zip_2"       value="<%=zip2%>"   maxlength="3"  readonly="readonly"  style="width: 50px;">   <!-- 우편번호2 -->
				      					<input type="button" id="btn_order_search" name="btn_order_search"  value="주소찾기" onclick="fnAddrPop();"/>
			      					</div>
			      					
			      					<div style="padding-bottom: 5px; text-align: left;">
			      						<input type="text" id="order_base"   name="order_base" value="<%=addrBase%>"   style="width: 400px;" readonly="readonly"/><!-- 주소1 -->
			      					</div>
			      					
			      					<div style="padding-bottom: 5px; text-align: left;" >
										<input type="text" id="order_detail" name="order_detail" value="<%= addrDetail %>" style="width: 400px;" readonly="readonly"/><!-- 상세주소 1 -->
									</div>
			      				</td>
			      			</tr>
			      			<tr>
			      				<th>수취인 이름</th>
			      				<td>
			      					<input type="text" id="order_name" name="order_name" value="" style="width: 100px; float: left;" />
			      				</td>
			      			</tr>
			      			<tr>
			      				<th>수취인 휴대폰</th>
			      				<td>
			      					<div style="text-align: left;">
			      						<input type="text" id="order_cellPhone_1" name="order_phoneNum_1" maxlength="3"  onkeyup="this.value=onlyNumber(this.value);">-
			      						<input type="text" id="order_cellPhone_2" name="order_phoneNum_2" maxlength="4"  onkeyup="this.value=onlyNumber(this.value);">- 
			      						<input type="text" id="order_cellPhone_3" name="order_phoneNum_3" maxlength="4"  onkeyup="this.value=onlyNumber(this.value);">
			      					</div>
			      				</td>
			      			</tr>
			      			<tr>
			      				<th>수취인 연락처</th>
			      				<td>
			      					<div style="text-align: left;">
			      						<input type="text" id="order_phoneNum_1" name="order_phoneNum_1" maxlength="3"  onkeyup="this.value=onlyNumber(this.value);">-
			      						<input type="text" id="order_phoneNum_2" name="order_phoneNum_2" maxlength="4"  onkeyup="this.value=onlyNumber(this.value);">- 
			      						<input type="text" id="order_phoneNum_3" name="order_phoneNum_3" maxlength="4"  onkeyup="this.value=onlyNumber(this.value);">
			      					</div>
			      				</td>
			      			</tr>
			      			<tr>
			      				<th rowspan="2">배송지요청사항</th>
			      				<td>
			      					<div style="text-align: left;">
			      						<label><font color="red">주의!</font> : 판매자와 사전에 협의되지 않은 선택정보 변경 기재는 반영되지 않을 수 있습니다.</label>
			      					</div>
			      				</td>
			      			</tr>
			      			<tr>
			      				<td>
			      					<div style="text-align: left;">
			      						<input type="text" id="order_comment" name="order_comment"  size="80px;" />
		      						</div>
			      				</td>
			      			</tr>
			      			
			    	</table>
			  		
<!-- 			  		<div id="search-option"> -->
<!-- 			    		<label for="select_search" class="hidden">검색구분</label> -->
<!-- 			    		<select id="select_search" name="select_search" style="height:20px; width:80px;"> -->
<!-- 			    			<option value="">전체</option> -->
<!-- 			    			<option value="title">제목</option> -->
<!-- 			    			<option value="content">내용</option> -->
<!-- 			    		</select> -->
<!-- 			    		<label for="search_word" class="hidden">검색어</label> -->
<!-- 			    		<input type="text" id="search_word" name="search_word" value="" style="width:180px;" /> -->
<!-- 			    		<button type="button" class="searchBtn"  onclick="search_list();">검색</button> -->
<!-- 			    		<button  type="button"  class="gowriteBtn" onclick="goWrite()">글쓰기</button> -->
<!-- 			  		</div> -->
		  		</form>
	  		</div>
 		 </section>
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div><!-- end of wrap -->
</body>
</html>