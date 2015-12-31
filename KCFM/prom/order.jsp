<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="prom.dao.deliveryDao" %>
<%@ page import="prom.dao.orderDao" %>
<%@ page import="prom.beans.deliveryBean" %>
<%@ page import="prom.beans.orderBean" %>
<%@ include file="/com/common.jsp"%>

<%
	String root = request.getContextPath();

	paramData.put("기업코드"		, (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"		, (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드"	, (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드"		, (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("홍보물코드"	, JSPUtil.chkNull(request.getParameter("PromoCd")));
	paramData.put("홍보물번호"	, JSPUtil.chkNull(request.getParameter("PromoNo")));
	paramData.put("주문수량"		, JSPUtil.chkNull(request.getParameter("OrdQty")));
	paramData.put("인쇄사용문구"	, JSPUtil.chkNull(request.getParameter("PrintMsg")));
	paramData.put("추가요청사항"	, JSPUtil.chkNull(request.getParameter("AddRequst")));
	paramData.put("주문상태"		, JSPUtil.chkNull(request.getParameter("OrdStd")));
	paramData.put("등록자"		, (String)session.getAttribute("sseCustNm"));
	
	System.out.println("==============================================");
	System.out.println("주문하기(order.jsp) >>>>>>>>>>>>>>>>>>>>>>>>>>>");
	System.out.println("기업코드		: "+paramData.get("기업코드"));
	System.out.println("법인코드		: "+paramData.get("법인코드"));
	System.out.println("브랜드코드	: "+paramData.get("브랜드코드"));
	System.out.println("매장코드		: "+paramData.get("매장코드"));
	System.out.println("주문번호		: "+paramData.get("주문번호"));
	System.out.println("홍보물코드	: "+paramData.get("홍보물코드"));
	System.out.println("홍보물번호	: "+paramData.get("홍보물번호"));
	System.out.println("주문수량		: "+paramData.get("주문수량"));
	System.out.println("인쇄사용문구	: "+URLDecoder.decode(paramData.get("인쇄사용문구").toString() , "UTF-8"));
	System.out.println("추가요청사항	: "+URLDecoder.decode(paramData.get("추가요청사항").toString() , "UTF-8"));
	System.out.println("주문상태		: "+paramData.get("주문상태"));
	System.out.println("등록자		: "+paramData.get("등록자"));
	System.out.println("==============================================");

	orderBean orderBean  = new orderBean(); //내용보기 에서 담을 빈
	orderDao  orderDao   = new orderDao();
	
	ArrayList<orderBean> orderList = null;
	if("01".equals(paramData.get("주문상태").toString())){// 바로구매
		orderList = orderDao.selectOrder01(paramData); 
	} else { // 장바구니
		
		String orderSeq = request.getParameter("OrdSeq");
		System.out.println("주문번호		: ["+orderSeq+"]");
		
		String ordArray[] = orderSeq.split("\\|");
		orderSeq = "";
		for(int i=0; i < ordArray.length; i++){
			orderSeq = orderSeq + "'" + ordArray[i] + "',";
		}
		
		paramData.put("주문번호", orderSeq.substring(0, orderSeq.length()-1));
		orderList = orderDao.selectOrder00(paramData);
	}
	
	deliveryBean deliveryBean  = new deliveryBean(); //내용보기 에서 담을 빈
	deliveryDao  deliveryDao   = new deliveryDao();
	
	deliveryBean = deliveryDao.selectDefaultAddr(paramData);
	
	String zip1 = "";
	String zip2 = "";

	String zipAddr = "";
	String detAddr = "";
	String rcvName = "";
	String rcvMPNum = "";
	String rcvPHNum = "";
	
	if(deliveryBean != null){
		System.out.println("deliveryBean is null");
		zip1 = deliveryBean.get우편번호().substring(0, 3);
		zip2 = deliveryBean.get우편번호().substring(3);
		zipAddr  = deliveryBean.get우편주소();
		detAddr  = deliveryBean.get상세주소();
		rcvName  = deliveryBean.get수취인이름();
		rcvMPNum = deliveryBean.get수취인휴대전화번호();
		rcvPHNum = deliveryBean.get수취인전화번호();
	}
%>

<!DOCTYPE html>
<html>
<head>
<!-- 공용정의파일 -->
<%@ include file="/include/common_file.inc" %>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	
	<title>홍보물신청</title>  
    <script type="text/javascript">

    // 최종주문하기
    function fnOrder(){
		var frm = document.getElementById("formdata");
		
		frm.OrdComment.value  = encodeURIComponent(frm.order_comment.value);

		// 배송지 정보
		frm.OrderZip.value    	 = frm.order_zip_1.value+frm.order_zip_2.value;
		frm.OrderBase.value   	 = encodeURIComponent(frm.order_base.value);
		frm.OrderDetail.value 	 = encodeURIComponent(frm.order_detail.value);
		frm.OrderName.value 	 = encodeURIComponent(frm.order_name.value);
		frm.OrderCellPhone.value = frm.order_cellPhone.value;
		frm.OrderPhoneNum.value  = frm.order_phoneNum.value;
		
		//jQuery('input:radio[name="addr_type"]:checked').val();

    	frm.action = "<%=root%>/prom/order-ok.jsp";
    	frm.target = "iWorker";
    	frm.submit();
    }
    
    // 최종주문 처리결과받기
    function fnOrderRet(result){
    	var frm = document.getElementById("formdata");
    	
		if(result > 0){
			alert("주문이 정상적으로 접수되었습니다.");
			frm.action = "<%=root%>/prom/prom-ord-list.jsp";
			frm.target = "_self";
	    	frm.submit();
		} else {
			alert("작업중 오류가 발생하였습니다.");
			return;
		}
    }

    //주소찾기 팝업
    function fnAddrPop(){
    	<%-- var popUrl = "<%=root%>/address/searchAddressPop.jsp";	
    	var popOption = "width=600, height=500, menubar=no, resizable=no, scrollbars=no, status=no, titlebar=no, tollbar=no";
    		window.open(popUrl,"searchAddressPop",popOption); --%>
    		fnSearchAddr("new");
    }
    //최근배송지 팝업
    function fnPastAddrPop(obj){
    	<%-- fnSelectAddr(obj);
    	var popUrl = "<%=root%>/prom/delivery_select.jsp";	
    	var popOption = "width=900, height=500, menubar=no, resizable=no, scrollbars=yes, status=no, titlebar=no, tollbar=no";
    		window.open(popUrl,"delivery_select_pop",popOption);
    		    	 --%>
    		    	 fnSearchAddr("history");
    }
    //주소지 선택
    function fnSelectAddr(obj){
    	var chkBox = document.getElementsByName("addr_type");
    	
		if(obj == chkBox[0]){ // 기본배송지
		
			document.getElementById("order_zip_1" ).value  = document.getElementById("hid_order_zip1"  ).value;
			document.getElementById("order_zip_2" ).value  = document.getElementById("hid_order_zip2"  ).value;
			document.getElementById("order_base"  ).value  = document.getElementById("hid_order_base"  ).value;
			document.getElementById("order_detail").value  = document.getElementById("hid_order_detail").value;
			
			document.getElementById("order_name"     ).value = document.getElementById("hid_order_name"     ).value;
			document.getElementById("order_cellPhone").value = document.getElementById("hid_order_cellPhone").value;
			document.getElementById("order_phoneNum" ).value = document.getElementById("hid_order_phoneNum" ).value;
		} else { // 새로운배송지, 최근배송지
			document.getElementById("order_zip_1" ).value = "";
			document.getElementById("order_zip_2" ).value = "";
			document.getElementById("order_base"  ).value = "";
			document.getElementById("order_detail").value = "";
			
			document.getElementById("order_name"     ).value = "";
			document.getElementById("order_cellPhone").value = "";
			document.getElementById("order_phoneNum" ).value = "";

		} 
		
		fnSelectAddrSet(obj);
    }

    //주소지 선택에 따라 입력가능여부 처리 
    function fnSelectAddrSet(obj){
    	var chkBox = document.getElementsByName("addr_type");
		if(obj == chkBox[1]){ // 새로운배송지
			
			document.getElementById("btn_addr_sch").disabled = false;
			document.getElementById("order_name").readOnly = false;
			document.getElementById("order_cellPhone").readOnly = false;
			document.getElementById("order_phoneNum").readOnly = false;
			
		} else { // 기본배송지, 최근배송지
		  	
			document.getElementById("btn_addr_sch").disabled = true;
			document.getElementById("order_name").readOnly = true;
			document.getElementById("order_cellPhone").readOnly= true;
			document.getElementById("order_phoneNum").readOnly = true;
			
		}
    }
    
    //숫자만 입력(정규식)
    function onlyNumber(val){
    	//return val.replace(/[^0-9-]/gi, ""); 
    	return val.replace(/[^0-9]/gi, ""); 
    }
    
    
 // 홍보물 목록보기
    function fnShowList(code,no){
    	var frm = document.getElementById("formdata");
    	
    	frm.PromoCd.value = code;
    	frm.action = "<%=root%>/prom/list.jsp";
    	frm.target = "iWorker";
    	frm.submit();
    	
    	fnShowListDetail(no);
    }
    // 홍보물 상세보기
    function fnShowListDetail(no){
    	fnShowDetail();

    	var frm = document.getElementById("formdata");
    	
    	frm.PromoNo.value = no;
    	frm.action = "<%=root%>/prom/detail.jsp";
    	frm.target = "iWorker";
    	frm.submit();
    }
    
    // 조회내역 화면에 출력
    function fnRetSetting(id, out){
    	document.getElementById(id).innerHTML = out;
    }
    
    function fnSearchAddr(keyWord){
        var de = document.documentElement;
        var body = document.body; 
		var browserHeight = body.scrollHeight;
		var browserWidth = de.offsetWidth;
		
		// 현재 Y 좌표 
		var ScrollY = document.all ? (!de.scrollTop ? body.scrollTop : de.scrollTop) : (window.pageYOffset ? window.pageYOffset : window.scrollY);
		
		$(".overlay-bg8").height(browserHeight);
		//$(".dtl-pop").css("left",browserWidth/2 -300);//image size = 40*40

		if(keyWord == "new"){
			$("#pop-history-addr").hide();
			$("#pop-search-addr").show();
			$("#pop-search-addr").css("left",browserWidth/2 -300);
		}else if(keyWord == "history"){
			$("#pop-search-addr").hide();
			$("#pop-history-addr").show();
			$("#pop-history-addr").css("left",browserWidth/2 -450);
		}
		$(".dtl-pop").css("top",ScrollY + 130);// 현재 화면에  맞게 팝업 위치 조절 조절 
		$(".overlay-bg8").show();
		
		//$(".dtl-pop").show(); 
    }
    
    //1. 새주소 검색 후 주소 받기
    function fnInputAddr(){
		var addr2 = document.getElementById("addr2");
		
		if (addr2.value == "") {
			alert("상세주소를 입력해 주세요!");
			addr2.focus();
			return;
		}

		document.getElementById("order_zip_1" ).value = document.getElementById("zip_1").value;
		document.getElementById("order_zip_2" ).value = document.getElementById("zip_2").value;
		document.getElementById("order_base"  ).value = document.getElementById("addr1").value;
		document.getElementById("order_detail").value = document.getElementById("addr2").value;

		popupHide("new");
	}
    
    //2. 기존 배송지 선택 후 주소 받기
    function send(post_seq, name, zipcode1, zipcode2, address1, address2, cellPhone, phoneNum){
		// 배송지번호. 수취인이름, 우편번호1,우편번호2, 우편주소, 상세주소, 수취인휴대전화번호, 수취인전화번호
		// post_seq, name, zipcode1, zipcode2, address1, address2, cellPhone, phoneNum

    	var frm = document.getElementById("formdata");

		frm.OrderAddrSeq.value 		= post_seq;
		frm.order_name.value 		= name;
		frm.order_zip_1.value 		= zipcode1;
		frm.order_zip_2.value 		= zipcode2;
		frm.order_base.value  		= address1;
		frm.order_detail.value		= address2;
		frm.order_cellPhone.value 	= cellPhone;
		frm.order_phoneNum.value 	= phoneNum;
		
		popupHide("history");
    }
    
    function popupHide(keyWord){

    	if(keyWord == "new"){
			//팝업화면 초기화
	 	   	var step01 = document.getElementById("step01");
		   	var step02 = document.getElementById("step02");
		   	var step03 = document.getElementById("step03");
		   	
		   	document.getElementById("search_word").value = "";
		   	document.getElementById("addr2").value = "";
			step01.style.display = "block";
			step02.style.display = "none";
			step03.style.display = "none";
    	}		   
		$(".overlay-bg8").hide();
    }
    </script>
</head>

<body>
<form id="formdata" name="formdata" method="post">
	<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>
	<input type="hidden" name="PromoCd"     value="<%=paramData.get("홍보물코드")%>"/>
	<input type="hidden" name="PromoNo"     value="<%=paramData.get("홍보물번호")%>"/>
	<input type="hidden" name="PrintMsg"    value="<%=paramData.get("인쇄사용문구")%>"/>
	<input type="hidden" name="AddRequst"   value="<%=paramData.get("추가요청사항")%>"/>
	<input type="hidden" name="OrdQty"      value="<%=paramData.get("주문수량")%>"/>
	<input type="hidden" name="OrdStd"      value="<%=paramData.get("주문상태")%>"/>
	<input type="hidden" name="OrdSeq"      value="<%=paramData.get("주문번호")%>"/>
	<input type="hidden" name="OrdComment"  value=""/> <!-- 배송요청사항 -->
	<input type="hidden" name="OrderZip"       value=""/>  <!-- 우편번호 -->
	<input type="hidden" name="OrderBase"      value=""/>  <!-- 우편주소 -->
	<input type="hidden" name="OrderDetail"    value=""/>  <!-- 상세주소 -->
	<input type="hidden" name="OrderName"      value=""/>  <!-- 수취인이름 -->
	<input type="hidden" name="OrderCellPhone" value=""/>  <!-- 수취인휴대전화번호 -->
	<input type="hidden" name="OrderPhoneNum"  value=""/>  <!-- 수취인전화번호 -->
	<input type="hidden" name="OrderAddrSeq"  value=""/>  <!-- 수취인전화번호 -->

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
	 	
 		 <section class="contents">
 		 	<header> 
 		 		<h1>◎ <span>홍보물 신청  ☞  주문하기</span></h1>
 		 	</header>
 		 	
			 <article class="" id="material-menus">
			 	
		        <!-- 화면 오른쪽 페이지 영역 -->
		        <div class="cart-div">
	        		<div id="cart-data" class="table">
	        			<table id="order-list" width="900" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1"> 
			  				<caption> ▶ 주문상품</caption>
			  				<tr bgcolor="#b2b19c" align="center" height="40">
								<th width="260"><b>상품명</b></th>
								<th width="120"><b>판매가</b></th>
								<th width="100"><b>옵션가</b></th>
								<th width="100"><b>할인</b></th>
								<th width="100"><b>수량</b></th> 
								<th width="120"><b>합계</b></th>
								<th width="100"><b>배송비</b></th>
							</tr>
						  <%
						  int amt = 0;
						  int ordLen = orderList.size();
						  if(orderList != null && ordLen > 0){
							  for(int i=0; i<ordLen; i++){
								  orderBean = (orderBean)orderList.get(i);
								  amt = amt + Integer.parseInt(orderBean.get주문가격()); 
						  %>
							<tr class="data" align="center" bgcolor="#ffffff" height="40">
								<td>
									<a href="javascript:fnShowList('<%=orderBean.get홍보물코드()%>','<%=orderBean.get홍보물번호()%>')"><span><%=orderBean.get홍보물명()%></span></a>
									<br>
									<span><font color="#696969"><%=orderBean.get주문단위()%></font></span>
								</td>
								<td><%=CommUtil.getNumericString(orderBean.get단위가격())%></td>
								<td><font color="#999999">없음</font></td>
								<td><font color="#FF0000">0</font></td>
								<td class="item-count"><%=orderBean.get주문수량()%></td>
								<td><%=CommUtil.getNumericString(orderBean.get주문가격())%>원</td>
								<td>무료</td>
							</tr>
						  <%
							  }
						  }
						  %>
						</table>
						
	        			<table id="order-info" width="900" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" > 
			  				<caption> ▶ 결제금액</caption>
							<tr bgcolor="#b2b19c" align="center" height="40">
								<th width="225"><b>상품 가격</b></th>
								<th width="225"><b>총 할인 금액</b></th>
								<th width="225"><b>총 배송비</b></th>
								<th width="225"><b>총 결제 금액</b></th>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff" height="40">
								<td><span><font size="3"><b><%=CommUtil.getNumericString(amt)%></b></font></span>원</td>
								<td><span><font size="3" color="#D74040"><b>0</b></font></span>원</td>
								<td><span><font size="3"><b>0</b></font></span>원</td>
								<td bgcolor="#FCFBD9"><span><font size="4" color="#D74040"><b><%=CommUtil.getNumericString(amt)%></b></font></span> 원</td>
							</tr>
						</table>

	        			<table id="order-address" width="900" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" > 
			  				<caption> ▶ 배송지정보</caption>
							<tr height="40" bgcolor="#FFFFFF" align="center">
								<th rowspan="2" bgcolor="#b2b19c">배송지 주소</th>
								<td class="addr-check"  align="left" >
									<input type="hidden" id="hid_order_zip1"   name="hid_order_zip1"   value="<%=zip1%>"> <!--주소 체크박스 선택할때 값 입력용-->
									<input type="hidden" id="hid_order_zip2"   name="hid_order_zip2"   value="<%=zip2%>">
									<input type="hidden" id="hid_order_base"   name="hid_order_base"   value="<%=zipAddr%>">
									<input type="hidden" id="hid_order_detail" name="hid_order_detail" value="<%=detAddr%>">
									<input type="hidden" id="hid_order_name"   name="hid_order_name"   value="<%=rcvName%>">
									<input type="hidden" id="hid_order_cellPhone" name="hid_order_cellPhone" value="<%=rcvMPNum%>">
									<input type="hidden" id="hid_order_phoneNum"  name="hid_order_phoneNum"  value="<%=rcvPHNum%>">

									<input type="radio" id="addr_type" name="addr_type" value="0" checked="checked" onclick="fnSelectAddr(this)"/><label for="addr_type">&nbsp;기본 배송지</label>
									<input type="radio" id="addr_type" name="addr_type" value="new" onclick="fnSelectAddr(this)"/><label for="addr_type">&nbsp;새로운 배송지</label>
									<input type="radio" id="addr_type" name="addr_type" value="past" onclick="fnPastAddrPop(this)"/><label for="addr_type">&nbsp;최근 배송지</label>
								</td>
							</tr>
							<tr height="40" bgcolor="#FFFFFF" align="center">
								<td align="left">
									<input type="text" id="order_zip_1" name="order_zip_1" value="<%=zip1%>" maxlength="3" style="width: 40px;" readonly="readonly"/> -
									<input type="text" id="order_zip_2" name="order_zip_2" value="<%=zip2%>" maxlength="3" style="width: 40px;" readonly="readonly"/>
									<input type="button" id="btn_addr_sch" name="btn_addr_sch"  value="주소찾기" onclick="fnAddrPop();" disabled="disabled"/>
									<br>
									<input type="text" id="order_base" name="order_base" value="<%=zipAddr%>" style="width: 590px;" readonly="readonly"/>
									<br>
									<input type="text" id="order_detail" name="order_detail" value="<%=detAddr%>" style="width: 590px;" readonly="readonly"/>
								</td>
							</tr>
							<tr height="40" bgcolor="#FFFFFF" align="center">
								<th bgcolor="#b2b19c">수취인 이름</th>
								<td align="left">
									<input type="text" id="order_name" name="order_name" value="<%=rcvName%>" readonly="readonly"/>
								</td>
							</tr>
							<tr height="40" bgcolor="#FFFFFF" align="center">
								<th bgcolor="#b2b19c">수취인 휴대전화</th>
								<td align="left">
									<input type="text" id="order_cellPhone" name="order_cellPhone" onkeyup="this.value=onlyNumber(this.value);" value="<%=rcvMPNum%>" maxlength="15" readonly="readonly"/>
								 ('-'없이 입력)
								</td>
							</tr>
							<tr height="40" bgcolor="#FFFFFF" align="center">
								<th bgcolor="#b2b19c">수취인 전화번호</th>
								<td align="left">
									<input type="text" id="order_phoneNum" name="order_phoneNum" onkeyup="this.value=onlyNumber(this.value);" value="<%=rcvPHNum%>" maxlength="15" readonly="readonly"/>
								 ('-'없이 입력)
								</td>
							</tr>
							<tr height="40" bgcolor="#FFFFFF" align="center">
								<th bgcolor="#b2b19c">배송시 요청사항</th>
								<td align="left">
									<input type="text" id="order_comment" name="order_comment" value="" style="width: 590px;"/>
								</td>
							</tr>
						</table>
	        			<table id="" width="900"border="0" cellpadding="1" cellspacing="1" > 
							<tr height="90" bgcolor="#FFFFFF" align="center">
								<td>
									<button class="redBtn" id="btnOrd" type="button" onclick="fnOrder()" >최종 주문하기</button>
								</td>
							</tr>
						</table>
	        		</div>
	        		
	        	</div>
	        	
	        	
	        </article>
		 </section> 
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg8" >
	 		<div class='dtl-pop' id='pop-history-addr'>
	 			<div id="pop-order-dtl-tit">배송지 선택</div>
 				<img src="../assets/images/close.png" id="btnCloseLayer" onclick="popupHide('history');" alt="닫기 버튼">
	 			<div id="pop-con2"></div>
				<script type="text/javascript">$("#pop-con2").load("<%=root%>/prom/delivery_select.jsp");</script>
	 		</div>
	 		<div class='dtl-pop' id='pop-search-addr'>
	 			<div id="pop-order-dtl-tit">배송지 검색</div>
 				<img src="../assets/images/close.png" id="btnCloseLayer" onclick="popupHide('new');" alt="닫기 버튼">
	 			<div id="pop-con"></div>
				<script type="text/javascript">$("#pop-con").load("<%=root%>/address/searchAddressPop.jsp");</script>
	 		</div>
	 		
	 	</div>
	 	
 		<!-- modal popup -->
	 	<div class="overlay-bg-half">
	 	</div>
	</div><!-- end of wrap -->
</form>
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>