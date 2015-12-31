<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.beans.CodeBean" %>
<%@ page import="prom.dao.menuDao" %>
<%@ page import="prom.dao.orderDao" %>
<%@ page import="prom.beans.menuBean" %>
<%@ page import="com.util.BoardConstant" %>
<%@ include file="/com/common.jsp"%>

<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	String root = request.getContextPath();
	
	//String srch_key   = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("srch_key") , ""), "UTF-8"); //검색어
	//String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type"), "0");//검색종류
	//String StartDate  = JSPUtil.chkNull((String)paramData.get("sDate")    , ""); //조회시작일자
	//String EndDate    = JSPUtil.chkNull((String)paramData.get("eDate")    , ""); //조회종료일자
	String StartDate  = ""; //조회시작일자
	String EndDate    = ""; //조회종료일자

	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	if ("".equals(StartDate) || StartDate == null)
	{
		StartDate = CommUtil.insDash(CommUtil.calDate(CommUtil.getDate(), "MONTH",-1));
	}
	if ("".equals(EndDate) || EndDate == null)
	{
		EndDate = JSPUtil.getYear() + "-" + JSPUtil.getMonth() + "-" + JSPUtil.getDay();
	}	
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 자료에 대한 처리
	//-------------------------------------------------------------------------------------------------------
	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드", (String)session.getAttribute("sseCustStoreCd"));
	
	menuBean menuBean  = new menuBean(); //내용보기 에서 담을 빈
	menuDao  menuDao   = new menuDao();
	
	ArrayList<menuBean> menuList = null;
	menuList = menuDao.selectList(paramData); //조회조건에 맞는 이벤트 리스트
	
	//-------------------------------------------------------------------------------------------------------
	//  콤보박스에 대한 처리
	//-------------------------------------------------------------------------------------------------------
	CodeBean codeBean  = new CodeBean();
	orderDao orderDao  = new orderDao();

	ArrayList<CodeBean> comboList = null;
	comboList = orderDao.getComboBox(paramData);
%>

<!DOCTYPE html>
<html>
<head>
<!-- 공용정의파일 -->
<%@ include file="/include/common_file.inc" %>
	<title>홍보물신청</title>  
     
    <script type="text/javascript">
    $(document).ready(function(){

    	var tabNo = getParameter("tabNo");
    	if(tabNo == "empty"){tabNo="1";}
    	 
		$("#tab"+tabNo).addClass("on"); 

		$(".main-li").click(function(){
			$(this).parent().find("li.main-li").each(function(){
	  	    	$(this).removeClass("on");
	  	    });
			$(this).addClass("on");
			//$(this).find("a").append("<span>▶</span>");
			fnMenuSelect($(this));
		});
		
		$(".sub-li").click(function(){

			$(".sub-li").each(function(){
	  	    	$(this).removeClass("on");
	  	    	$(this).find("a .icon").addClass("hidden");
	  	    });
			
			$(this).find("a .icon").removeClass("hidden");
			$(this).addClass("on");
			
        	$("#ord-list-area").hide();
        	$("#material-main").show();
		});
		
		// 처음 호출시 [Flyer>배달전단] 조회
		fnShowList("FLY010");
    });
    

    function fnShowAll(){
		//.slideToggle( [duration ] [, complete ] )
		//$(".menu-nav-sub").slideToggle("slow");
		$(".menu-nav-sub").each(function(){
	    	$(this).addClass("on");
	    });
	  	$("#ord-list-area").hide();
		$("#material-main").show();
    }
    
    function fnMenuSelect($this){
  	  	//.slideToggle( [duration ] [, complete ] )
  		//$this.find(".menu-nav-sub").slideToggle("slow");
  	    $this.parent().find(".menu-nav-sub").each(function(){
  	    	$(this).removeClass("on"); 
  	    });
  		$this.find(".menu-nav-sub").addClass("on");
    	$("#ord-list-area").hide();
    	$("#material-main").show();
	}
    
    function fnShowDetail(){

		var browserHeight = document.documentElement.height;
		var browserWidth = document.documentElement.offsetWidth;
		
		$(".overlay-bg8").height(browserHeight);
		$(".dtl-pop").css("left",browserWidth/2 - 450);//image size = 40*40
		$(".overlay-bg8").show();
		$(".dtl-pop").show(); 
    }
    
    // 홍보물 목록보기
    function fnShowList(code){
    	var frm = document.getElementById("formdata");
    	
    	frm.PromoCd.value = code;
    	frm.action = "<%=root%>/prom/list.jsp";
    	frm.target = "iWorker";
    	frm.submit();
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
    // 주문금액 계산
    function fnCalcAmt(ord_qty){
    	var OrdPrice = getNumber(document.getElementById("dOrdPrice").value); // 단가
    	var amt = parseInt(ord_qty) * OrdPrice; // 수량 * 단가
    	
    	document.getElementById("dOrdAmt").innerText = setComma(amt) + "원";
    }
    // 주문하기
    function fnOrder(){
    	var frm = document.getElementById("formdata");
		
    	$(".dtl-pop").hide(); 
		$(".overlay-bg8").hide();
		
		frm.PrintMsg.value  = encodeURIComponent(frm.dPrintMsg.value);
		frm.AddRequst.value = encodeURIComponent(frm.dAddRequst.value);
		frm.OrdQty.value = getNumber(frm.dOrdQty.value);
		frm.OrdStd.value = "01";
		
    	frm.action = "<%=root%>/prom/order.jsp";
    	frm.target = "_self";
    	frm.submit();
    }
    // 장바구니
    function fnCart(){
    	var frm = document.getElementById("formdata");
		
    	$(".dtl-pop").hide(); 
		$(".overlay-bg8").hide();

		frm.PrintMsg.value  = encodeURIComponent(frm.dPrintMsg.value);
		frm.AddRequst.value = encodeURIComponent(frm.dAddRequst.value);
		frm.OrdQty.value = getNumber(frm.dOrdQty.value);
		frm.OrdStd.value = "00";
		frm.flag.value = "I";
		
    	frm.action = "<%=root%>/prom/cart-ok.jsp";
    	frm.target = "iWorker";
    	frm.submit();
    }
    // 장바구니 처리결과받기
    function fnCartRet(result){
    	var frm = document.getElementById("formdata");
    	
		if(result > 0){
			if(confirm("장바구니에 상품을 담았습니다.\n"
					  +"장바구니로 이동하시겠습니까?")){
				frm.action = "<%=root%>/prom/cart.jsp";
				frm.target = "_self";
		    	frm.submit();
			} else {
				return;
			}
		} else {
			alert("작업중 오류가 발생하였습니다.");
			return;
		}
    }
   </script>
</head>

<body>
<form id="formdata" name="formdata" method="post">
	<input type="hidden" name="srch_key"       id="srch_key"       value=""/>  <!-- 검색어 -->
	<input type="hidden" name="srch_type"      id="srch_type"      value=""/>  <!-- 검색타입 -->
	<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="1"/>  <!-- 현재 페이지 -->
	<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="1"/>  <!-- 현재 블럭 -->
	<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value=""/>  <!-- 한 페이지당 표시할 레코드 수 -->
	<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value=""/>  <!-- 한 블럭당 할당된 페이지 수 -->

	<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>
	<input type="hidden" name="PromoCd"     value=""/><!-- 홍보물코드 -->
	<input type="hidden" name="PromoNo"     value=""/><!-- 홍보물번호 -->
	<input type="hidden" name="PrintMsg"    value=""/><!-- 인쇄사용문구 -->
	<input type="hidden" name="AddRequst"   value=""/><!-- 추가요청사항 -->
	<input type="hidden" name="OrdQty"      value=""/><!-- 주문수량 -->
	<input type="hidden" name="OrdStd"      value=""/><!-- 주문상태 -->
	<input type="hidden" name="flag"        value=""/><!-- 작업구분 -->
	
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
 		 		<h1>◎ <span>홍보물신청</span></h1>
 		 	</header>
 		 	
			 <article class="" id="material-menus">
			 	<!-- 화면 왼쪽 메뉴 영역 -->
		        <div id="menu-nav">
					<h3>MENU</h3>
					<p>
						<button class="menu-all" onclick="fnShowAll()">전체보기</button>
						<!-- <button class="my-ord-list" onclick="showOrdList($(this));">주문확인</button> -->
					</p>
					<ul class="menu-nav-main">
					<%
					String initCls = "";
					String initIcon = "";
					if(menuList != null && menuList.size() > 0){
						for(int i=0; i<menuList.size(); i++){
							menuBean = (menuBean) menuList.get(i);
							
							// 처음 호출시 jQuery에서 onclick 이벤트 발생시키는 부분으로 변경해야 함.
							// [Flyer>배달전단] 선택되도록 처리하는 부분
							if("FLY010".equals(menuBean.get메뉴코드())){
								initCls = " on";
								initIcon = "icon";
							} else {
								initCls = "";
								initIcon = "hidden icon";
							}
							
							if("1".equals(menuBean.get메뉴레벨())){
								initCls = ("FLY".equals(menuBean.get메뉴코드())?" on":"");
								if(i != 0){
					%>
							</ul>
						</li>
					<%			} %>
						<li class="main-li<%=initCls%>"><a href="#" onclick=""><%=menuBean.get메뉴코드명()%></a>
							<ul class="menu-nav-sub<%=initCls%>">
					<%		} else { %>
								<li class="sub-li<%=initCls%>" id="<%=menuBean.get메뉴코드()%>"><a href="javascript:fnShowList('<%=menuBean.get메뉴코드()%>');"><%=menuBean.get메뉴코드명()%><span class="<%=initIcon%>"> ▶</span></a></li>
					<%
							}
						}
					}
					%>
					</ul>
		        </div>
		        
		        <!-- 화면 오른쪽 페이지 영역 -->
		        <div class="menu-dtl-page">
		        	<!-- 1. 주문 확인 화면 -->
		        	<!-- 
		        	<div id="ord-list-area">
			        	▶ 주문확인 - 매장
			    		<span class="btns"><button class="excelBtn" onclick="javascript:fnExcelDown('excelDown');">엑셀</button></span>
			    		<span class="btns"><button class="excelAllBtn" onclick="javascript:fnExcelDown('excelAllDown');">전체엑셀</button></span>
						
						<%-- <div id="search-condition">
							<!-- 검색기간 -->
							<div class="search-d">
					    		<label for="start_search" > 검색 기간 : </label>
					    		<input class="big_0" name="sDate" type="text" value="<%=StartDate%>"/> ~ 
								<input class="big_0" name="eDate" type="text" value="<%=EndDate%>"/> 
					  		</div>
					  		<!-- 기타 검색 조건 -->
					  		<div class="search-d">
						  		<label for="conditions" > 진행 상황 : </label>
					    		<select id="conditions" name="conditions">
					    			<option value="0">전체</option>
					    		<%
					    			if(comboList != null && comboList.size() > 0){ 
					    				for(int i=0; i<comboList.size(); i++){
											codeBean = (CodeBean)comboList.get(i);
							    			out.print("<option value='"+codeBean.getStrCode()+"'>"+codeBean.getStrCodeName()+"</option>");
					    				}
					    			}
								%>
					    		</select>
					    		<label for="search_name" > 전단지명 : </label>
					    		<input type="text" id="search_name" name="search_name" value=""/>
					    		<span><button class="searchDateBtn" onclick="fnShowOrderList();">검색</button></span>	
					  		</div>
						</div> --%>		        
						
						-->
							
			        	<!-- 테이블 영역 -->
				  		<!-- <div id="ord-list-table" class="table"></div> -->
				  		<!-- 테이블 끝 -->
			  		
			  		<!-- </div> -->
			  		<!-- 1. 주문확인 끝 -->
			  		
			  		<!-- 2. 전단지 메인 -->
			  		<div id="material-main"></div>
			  		
		        </div>
	        </article>
		 </section>
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg8" >
	 		<div class='dtl-pop' id='pop-order-dtl'></div>
	 	</div>
	 	
 		<!-- modal popup -->
	 	<div class="overlay-bg-half">
	 	</div>
	</div><!-- end of wrap -->
</form>
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>
