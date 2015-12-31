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
	
	System.out.println("==============================================");
	System.out.println("장바구니(cart.jsp) >>>>>>>>>>>>>>>>>>>>>>>>>>>");
	System.out.println("기업코드		: "+paramData.get("기업코드"));
	System.out.println("법인코드		: "+paramData.get("법인코드"));
	System.out.println("브랜드코드	: "+paramData.get("브랜드코드"));
	System.out.println("매장코드		: "+paramData.get("매장코드"));
	System.out.println("==============================================");

	orderBean orderBean  = new orderBean(); //내용보기 에서 담을 빈
	orderDao  orderDao   = new orderDao();
	
	ArrayList<orderBean> orderList = null;
	orderList = orderDao.selectOrder00(paramData);
%>

<!DOCTYPE html>
<html>
<head>
<!-- 공용정의파일 -->
<%@ include file="/include/common_file.inc" %>
	<title>홍보물신청</title>  
     
    <script type="text/javascript">
    $(document).ready(function(){ 
        
    	// 전체선택
        $("#check-all").click(function(){
            if($("#check-all").prop("checked")){
                $("input[name=chk]").prop("checked",true);
            }else{
                $("input[name=chk]").prop("checked",false);
            }
            fnCalcAmt();
        });

    });
    
    // 주문하기
    function fnOrder(){
    	var frm = document.getElementById("formdata");
    	with(document.all){
	    	var ord_seq = "";
	    	if($('input[name=chk]:checked').length > 0){
	    		$('input[name=chk]:checked').each(function(){
	    			ord_seq = ord_seq + eval("OrdSeq"+$(this).val()).value + "|";
	    		});
	    	} else {
	    		alert("주문하실 상품을 선택해주세요.");
	    		return;
	    	}
	    	
	    	frm.OrdSeq.value  = ord_seq.substring(0, ord_seq.length-1);
	    	
	    	frm.action = "<%=root%>/prom/order.jsp";
	    	frm.target = "_self";
	    	frm.submit();
    	}
    }

    // 장바구니 수정
    function fnCartModify(idx){
		var frm = document.getElementById("formdata");
		
		with(document.all){
			frm.OrdSeq.value = eval("OrdSeq"+idx).value;
			frm.UnitAmt.value = eval("UnitAmt"+idx).value;
			frm.OrdQty.value = eval("OrdQty"+idx).value;
			frm.flag.value = "U";
			
	    	frm.action = "<%=root%>/prom/cart-ok.jsp";
	    	frm.target = "iWorker";
	    	frm.submit();
		}
    }
    
    // 장바구니 삭제
    function fnCartDelete(gbn){
		var frm = document.getElementById("formdata");
		
		with(document.all){
			var ord_seq = "";
			if(gbn == 'all'){
				if($('input[name=chk]').length > 0){
		    		$('input[name=chk]').each(function(){
		    			ord_seq = ord_seq + eval("OrdSeq"+$(this).val()).value + "|";
		    		});
		    	} else {
		    		return;
		    	}
			} else {
				if($('input[name=chk]:checked').length > 0){
		    		$('input[name=chk]:checked').each(function(){
		    			ord_seq = ord_seq + eval("OrdSeq"+$(this).val()).value + "|";
		    		});
		    	} else {
		    		alert("삭제하실 상품을 선택해주세요.");
		    		return;
		    	}
			}

			frm.OrdSeq.value  = ord_seq.substring(0, ord_seq.length-1);
			frm.flag.value = "D";
			
	    	frm.action = "<%=root%>/prom/cart-ok.jsp";
	    	frm.target = "iWorker";
	    	frm.submit();
		}
    }

    // 장바구니 처리결과받기
    function fnCartRet(result){
    	var frm = document.getElementById("formdata");

		if(result > 0){
			alert("정상적으로 처리되었습니다.");
			frm.action = "<%=root%>/prom/cart.jsp";
			frm.target = "_self";
	    	frm.submit();
		} else {
			alert("작업중 오류가 발생하였습니다.");
			return;
		}
    }
    
    // 주문금액 계산
    function fnCalcAmt(){
    	with(document.all){
	    	var amt = 0;
	    	var unit_amt = 0;
	    	var ord_qty = 0;
	   	
			if($('input[name=chk]:checked').length > 0){
	    		$('input[name=chk]:checked').each(function(){
	    			unit_amt = getNumber(eval("UnitAmt"+$(this).val()).value);
	    			ord_qty = getNumber(eval("OrdQty"+$(this).val()).value);
	    			amt = amt + (unit_amt * ord_qty);
	    		});
	    	}
			
			document.getElementById("CartCnt").innerText = $('input[name=chk]:checked').length;
	    	document.getElementById("OrdAmt").innerText = setComma(amt);
	    	document.getElementById("TotalOrdAmt").innerText = setComma(amt);
    	}
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
    
    function fnShowDetail(){

		var browserHeight = document.documentElement.height;
		var browserWidth = document.documentElement.offsetWidth;
		
		$(".overlay-bg8").height(browserHeight);
		$(".dtl-pop").css("left",browserWidth/2 - 450);//image size = 40*40
		$(".overlay-bg8").show();
		$(".dtl-pop").show(); 
    }
    
    </script>
</head>

<body>
<form id="formdata" name="formdata" method="post">
	<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>
	<input type="hidden" name="OrdSeq"      value=""/><!-- 주문번호 -->
	<input type="hidden" name="UnitAmt"     value=""/><!-- 단위가격 -->
	<input type="hidden" name="OrdQty"      value=""/><!-- 주문수량 -->
	<input type="hidden" name="flag"        value=""/><!-- 작업구분 -->
	<input type="hidden" name="PromoCd"     value=""/><!-- 홍보물코드 -->
	<input type="hidden" name="PromoNo"     value=""/><!-- 홍보물번호 -->
 	
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
 		 		<h1>◎ <span>홍보물 신청  ☞  장바구니</span></h1>
 		 	</header>
 		 	
			 <article class="" id="material-menus">
			 	
		        <!-- 화면 오른쪽 페이지 영역 -->
		        <div class="cart-div">
	        		<div id="cart-data" class="table">
	        			<table id="order-list" width="900" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1"> 
			  				<tr bgcolor="#b2b19c" align="center">
								<th width="40"><b>선택</b></th>
								<th width="220"><b>상품명</b></th>
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
								<td bgcolor="#E4F6FF">
									<input type="checkbox"  name="chk" class="check" value="<%=i%>" multiple="multiple" checked="checked" onclick="fnCalcAmt()"/>
									<input type="hidden" name="OrdSeq<%=i%>" name="OrdSeq<%=i%>" value="<%=orderBean.get주문번호()%>"/>
								</td>
								<td>
									<a href="javascript:fnShowList('<%=orderBean.get홍보물코드()%>','<%=orderBean.get홍보물번호()%>')"><span><%=orderBean.get홍보물명()%></span></a>
									<br>
									<span><font color="#696969"><%=orderBean.get주문단위()%></font></span>
								</td>
								<td><%=CommUtil.getNumericString(orderBean.get단위가격())%><input type="hidden" id="UnitAmt<%=i%>" name="UnitAmt<%=i%>" value="<%=orderBean.get단위가격()%>"/></td>
								<td><font color="#999999">없음</font></td>
								<td><font color="#FF0000">0</font></td>
								<td class="item-count">
									<input type="text" id='OrdQty<%=i%>' name='OrdQty<%=i%>' value="<%=orderBean.get주문수량()%>" maxlength='6' onkeydown='onlynumber();'><button class="modifyBtn" onclick="fnCartModify('<%=i%>');">수정</button>
								</td>
								<td><%=CommUtil.getNumericString(orderBean.get주문가격())%>원</td>
								<% if(i == 0){ %>
								<td rowspan="<%=ordLen%>">무료</td>
								<% } %>
							</tr>
						  <%
							  }
						  }
						  %>
							<tr class="bottom" bgcolor="#E3E6E6" align="center" height="40">
								<td colspan="2" >
									<input type="checkbox" class="check-all" id="check-all" checked="checked"/>
									<label for="check-all">&nbsp;전체선택</label>
						    		<span class="btns"><button class="deleteAllBtn" onclick="fnCartDelete('all')">전체삭제</button></span>
						    		<span class="btns"><button class="deleteSelBtn" onclick="fnCartDelete('sel')">선택삭제</button></span>
								</td>
								<td colspan="5" class="amount"><!-- TOTAL : <b> 801,000</b><span> - 20,000</span><font color="#474746"> + <span>0</span> (배송비)</font> --></td>
								<td> &nbsp;</td>
							</tr>
						</table>
	        			
	        			<table id="order-info" width="900" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" > 
							<tr bgcolor="#b2b19c" align="center" height="40">
								<th width="225"><b>상품 가격</b> <font color="#474746">(선택상품 : <span id="CartCnt" class="cart-count"><%=ordLen%></span>개)</font></th>
								<th width="225"><b>총 할인 금액</b></th>
								<th width="225"><b>총 배송비</b></th>
								<th width="225"><b>총 결제 금액</b></th>
							</tr>

							<tr class="data" align="center" bgcolor="#ffffff" height="40">
								<td><font size="3"><b><span id="OrdAmt"><%=CommUtil.getNumericString(amt)%></span></b></font>원</td>
								<td><span><font size="3" color="#D74040"><b>0</b></font></span>원</td>
								<td><span><font size="3"><b>0</b></font></span>원</td>
								<td bgcolor="#FCFBD9"><font size="4" color="#D74040"><b><span id="TotalOrdAmt"><%=CommUtil.getNumericString(amt)%></span></b></font>원</td>
							</tr>
						</table>
	        			
	        			<table id="" width="900" border="0" cellpadding="1" cellspacing="1" > 
							<tr height="90" bgcolor="#FFFFFF" align="center">
								<td>
									<button class="grayBtn" id="btnOrd" type="button" onclick="location.href='<%=root%>/prom/main.jsp'" >쇼핑 계속하기</button>
									<button class="redBtn" id="btnOrd" type="button" onclick="fnOrder()" >주문하기</button>
								</td>
							</tr>
						</table>
	        		</div>
	        		
	        	</div>
	        	
	        </article>
		 </section> 
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half">
	 	</div>
	 	<!-- modal popup -->
	 	<div class="overlay-bg8" >
	 		<div class='dtl-pop' id='pop-order-dtl'></div>
	 	</div>
	</div><!-- end of wrap -->
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>