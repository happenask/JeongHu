<%@page import="java.net.URLEncoder"%>
<%
/** ############################################################### */
/** Program ID   :  prom-ord-list.jsp                       		*/
/** Program Name :  prom-ord-list       							*/
/** Program Desc :  매장-홍보물 주문내역							    */
/** Create Date  :   2015.05.04					              		*/
/** Update Date  :                                                  */
/** Programmer   :                                          		*/
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="prom.beans.orderBean" %> 
<%@ page import="prom.dao.orderDao" %>

<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /prom-ord-list.jsp");
	
	/* adminBean dataBean = null;
	dataBean = new adminBean(); */
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드", 	(String)session.getAttribute("sseCustStoreCd"));
	paramData.put("권한코드",   (String)session.getAttribute("sseCustAuth"));		//권한구분
	paramData.put("조회시작일자", request.getParameter("sDate"));
	paramData.put("조회종료일자", request.getParameter("eDate"));
	paramData.put("inCurPage", request.getParameter("inCurPage"));

	//--------------------------------------------------------------------------------------------------
	// Parameter 정보
	//--------------------------------------------------------------------------------------------------
	String StartDate   = JSPUtil.chkNull((String)paramData.get("sDate"), "");      //주문기간시작
	String EndDate     = JSPUtil.chkNull((String)paramData.get("eDate"), "");      //주문기간종료
	
	String optProcess   = JSPUtil.chkNull((String)request.getParameter("hOptProcess"  ), ""); //진행상황
	
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
	
	paramData.put("조회시작일자",    StartDate      );
	paramData.put("조회종료일자" ,   EndDate        );

	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 10;                                                                            // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 10;                                                                            // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝

	paramData.put("inRowPerPage", Integer.toString(inRowPerPage));

	orderBean orderBean  = new orderBean(); //내용보기 에서 담을 빈
	orderDao  orderDao   = new orderDao();
	
	ArrayList<orderBean> list = null;
	list       = orderDao.selectList(paramData);        //조회조건에 맞는 이벤트 리스트
	inTotalCnt = orderDao.selectListCount(paramData);   //전체레코드 수
	
	
	//수정[X]
	//#################################################################################################### 페이지 구하기 시작
	//현재 블럭의 페이지수구하기
	if( inTotalCnt % inRowPerPage == 0 ) { inTotalPageCount = inTotalCnt / inRowPerPage; } 
	else    	 						 { inTotalPageCount = inTotalCnt / inRowPerPage + 1; }
	
	//페이지 블럭 구하기
	if( inTotalPageCount % inPagePerBlock == 0 ) { inTotalPageBlockCount = (int)Math.round((double)(inTotalPageCount/inPagePerBlock)); }
	else                                		 {inTotalPageBlockCount = (int)Math.round((double)(inTotalPageCount/inPagePerBlock) + 0.5); }
	
	//이전 블럭 구하기
	if( inCurBlock > 1 ) { inPrevBlock = inCurBlock - 1; }
	else             	 {inPrevBlock = inCurBlock; }
	
	inPrevPage = inPrevBlock * inPagePerBlock - inPagePerBlock + 1;
	
	//다음 블럭 구하기 
	if( inCurBlock < inTotalPageBlockCount ) { inNextBlock = inCurBlock + 1; }
	else                            		 { inNextBlock = inCurBlock; }
	
	//다음 페이지 구하기
	inNextPage = inNextBlock * inPagePerBlock - inPagePerBlock + 1;
	//#################################################################################################### 페이지 구하기 끝
	
	
%>
<!DOCTYPE html>
<html>
<head>
	
	<%@ include file="/include/common_file.inc" %>
	
	<title>홍보물신청</title>  
		
	
    <script type="text/javascript">
	$(document).ready(function()
	{ 
		getCurrent();
		fnCalendar();
		
		var proTdWidth = 0;
		$(".productionTh").each(function(){
			proTdWidth += $(this).width();
		});

		//2015.05.04
		//if(매장에서 로그인 한 경우 업체관련 항목 숨기고 사이즈 조절)
		//브랜드, 매장명, 전화번호, 시안등록 hide 
		//매장 로그인 시 - 아래 4줄 주석 풀기!!
		
		//var tableWidth = $("#ord-list-tb").width() - proTdWidth;
		//$("#ord-list-tb").width(tableWidth);
		//$(".productionTh").hide();
		//$(".production").hide();
		
		//////////////////////////////////////////////////////
	});
	
	//엔터 이벤트 조회
    document.onkeyup = function(evt){
    	try{
    		var charCode = (evt.which) ? evt.which : event.keyCode;
	    	if (charCode == 13) { //엔터
		        	//fnShowOrderList();
	    			return false;
		    }
    	}catch(e){
    		return false;
    	}
    }
	
	window.onload = function(){
		//진행상황 select box 조회
		comboStatusCd();
	}
	
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
    
    // 주문확인 보기
    function fnShowOrderList(){
		var frm = document.getElementById("formdata");
		
		$("input[name=hOptProcess]"  ).attr("value", $("#opt-process").val() ); //진행상황
		$("input[name=hoOptPromName]").attr("value", encodeURI( $("#opt-prom-name").val()) ); //전단지명
		
    	frm.action = "<%=root%>/prom/prom-ord-list.jsp";
    	frm.target = "_self";
    	frm.submit();
    }

	// 목차이동
	function goPage(page, block){
		var frm = document.getElementById("formdata");
		
 	    frm.inCurPage.value  = page;        
 	  	frm.inCurBlock.value = block; 
 	  	fnShowOrderList();
	}
	
	
	//진행상황 조회 SELECT BOX
	function comboStatusCd(){
    	
    	if("<%=optProcess%>" != null && "<%=optProcess%>" != ""){
    		$("input[name=hOptProcess]").attr("value", "<%=optProcess%>");
    	}
    	
		$.ajax(
			{
				url      : "<%=root%>/prom/prom-ord-list-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {   
								$("#opt-process option").remove();
								$("#opt-process").append(data);
				           }
			});
    }
	
	
	//주문내역 상세보기
	function fnShowListDetail(ordNo, insertUserId){

		fnShowDetail();

		var $frm = $("#formdata");
		
		$("input[name=hOrderNo]"     ).attr("value", ordNo  );
		$("input[name=hInsertUserId]").attr("value", insertUserId  );//등록자ID
		
    	$frm.attr("action",   "<%=root%>/prom/prom_ord-dtl-view.jsp");
    	$frm.attr("target",   "iWorker");
    	$frm.attr("method",   "post");
        
    	$frm.submit();
    	
    }
	
	//팝업화면 화면에 생성
	function fnRetSetting(id, out, prom_flyer_no){
    	
    	document.getElementById(id).innerHTML = decodeURIComponent(out);
    	$("input[name=hPromFlyerNo]").attr("value", prom_flyer_no); //홍보물 시안번호
    	
    	//fnProgressChecxk();
    }
	
	//주문상세 저장
	function fnSavePopUpInfo(){

		var printTxt   = encodeURIComponent($("#printTxt"  ).val()); //인쇄문구
		var requestTxt = encodeURIComponent($("#requestTxt").val()); //요구사항
		
		var $frm = $("#formdata");
		
		//진행상황 
		$("input[name=progression1]").each(function(i){
			if(this.checked == true){
				$("#hProgression1").attr("value", this.value);
			}
		});
		
		$("#hPrintTxt"  ).attr("value", printTxt  ); //한글깨짐처리
		$("#hRequestTxt").attr("value", requestTxt); //요구사항
		
		$frm.attr("action",   "<%=root%>/prom/prom-ord-list-write-ok.jsp" );
		$frm.attr("target",   "iWorker");
        $frm.attr("method",   "post");
        
        $frm.submit();
		
	}
	
	//주문상세 저장결과
	function fnSavePopUpResult(msg){
		alert(msg);
		setTimeout(fnShowOrderList, 500);
		
	}
	
	
	
	//진행상태 확인
	function fnCheckProcess(obj){
		//선택한 상태
		var val    = obj.value;
		var flag   = val.substring(0,1);
		var status = val.substring(1,3);
		
		//현 상태
		var proStatus = $("#progressStatus").val();
		var nowFlag   = proStatus.substring(0,1);
		var nowStatus = proStatus.substring(1,3);
		
		//제작, 배송, 주문완료상태에서 주문취소 못함.
		if( proStatus == "M01" || proStatus == "M02" || proStatus == "S99"){
			if(val == "S92"){
				alert("제작, 배송, 주문완료 상태에서는 주문취소를 할 수 없습니다.");
				return;
			}
		}
		
		//주문취소에서는 상태변경 안됨.
		if( proStatus == "S92" ){
			alert("주문취소 상태에서는 상태변경을 할 수 없습니다.");
			
			$("input[name=progression1]").each(function(i){
				this.checked = false;
			});

			return;
			
		}

		//현상태 보다 하위 단계로 못가게 막음.
		if(nowFlag == "M"){

			alert("제작/배송 상태에서는 상태변경을 할 수 없습니다.");
			
			$("input[name=progression1]").each(function(i){
				this.checked = false;
			});
			
			return;
			
		}else{//S
			if(flag == "S"){
				if( parseInt(nowStatus,10) > parseInt(status, 10)){
					alert("진행 중 하위단계 선택은 할 수 없습니다.");
					
					$("input[name=progression1]").each(function(i){
						this.checked = false;
					});
				}
			}
		}
	}


	//-----------------------[주문상세 댓글]----------------------
	//댓글정보 조회
	function fnSelectComment(){
		 
		$.ajax(
			{
				url      : "<%=root%>/prom/prom-ord-list-comment.jsp?gubun=select",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {   
								$("#comment").html("");
								$("#comment").html( trim(data));
								
				           }
			});
	 }
	
	 //댓글 저장.
	function fnWriteComment(num){

		 //num[0번 신규입력, 0 이외 수정]
		$("input[name=hCommNum]").attr("value", num);
		 
		 if(num == "0"){
			//신규입력
			$("input[name=hCommTxt]").attr("value", encodeURIComponent($("#comm_write").val()));
		 }else{
			 //수정
			$("input[name=hCommTxt]").attr("value", encodeURIComponent( document.getElementById("txt"+num).value ));
		 }
				
		$.ajax(
			{
				url      : "<%=root%>/prom/prom-ord-list-comment.jsp?gubun=insert",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {   
								if(trim(data) == "Y"){
									alert("등록 되었습니다.");
									
									//등록 후 화면 댓글 새로고침
									fnSelectComment();
						   		}else{
						   			alert("등록 실패 하였습니다.");
						   		}
				           }
			});
	 }
	 
	 
	 
	 //댓글 > 수정 후 저장 버튼 클릭
    function goCommConfirm(num)
    {
    	var viewObj = $('#list_'+num+' #comm_text'); //현 댓글
    	var txtObj  = $('#list_'+num+' #txt'+num);	 //수정입력칸
    	
    	var writeYN = document.getElementById("txt"+num).value;//comm_write
    	var no = "no";
		if (!trim(writeYN)){
			alert("댓글을 입력해주세요~!");
			return;
			
		}else if(txtObj.val() == viewObj.html()){
			alert("변경사항이 없습니다.");
			return;
			
		}else{
			//저장
			fnWriteComment(num); 
		}
    	
    }
    
    //댓글 > 수정버튼 클릭 후 종료버튼 클릭
    function closeComm(num)
	{  
    	
    	var viewObj  = $('#list_'+num+' #comm_text'); //현 댓글
    	var txtObj   = $('#list_'+num+' #txt'+num);	 //수정입력칸
    	var wrObj    = $('#list_'+num+' #wrBtn');     //수정 버튼
    	var saveObj  = $('#list_'+num+' #saveBtn');   //저장 버튼
    	var closeObj = $('#list_'+num+' #closeBtn'); //취소 버튼
    	
    	viewObj.show();    	
    	wrObj.show();
    	
    	txtObj.hide();
    	saveObj.hide();
    	closeObj.hide();
    	
	}


	 
	 //댓글 > 수정버튼 클릭
	function goCommWrite(num)
	{  
		 
    	var viewObj  = $('#list_'+num+' #comm_text'); //현 댓글
    	var txtObj   = $('#list_'+num+' #txt'+num);	 //수정입력칸
    	var wrObj    = $('#list_'+num+' #wrBtn');     //수정 버튼
    	var saveObj  = $('#list_'+num+' #saveBtn');   //저장 버튼
    	var closeObj = $('#list_'+num+' #closeBtn'); //취소 버튼
    	
    	txtObj.val(viewObj.html());
    	    	
    	viewObj.hide();
    	wrObj.hide();
    	
    	txtObj.show();
    	saveObj.show();
    	closeObj.show();
    	
	}
	 
	//-----------------------[주문상세 댓글]----------------------

	
	//홍보물 시안 이미지 보기
	 function ImgPopup(imgFileNm){
	    	
		 	var imgPath = "<%=root%>/filestorage/prom/"+imgFileNm;
		 
	 		var popOption = "width=600, height=800, menubar=no, resizable=yes, scrollbars=yes, status=no, titlebar=no, tollbar=no";
	 	    var pop = window.open('',"ImgPopup",popOption);

	 	    pop.document.write('<html><head><title>이미지팝업보기</title></head>');
	 	    pop.document.write('<body style="margin:0px;">'); // margin는 여백조절
	 	    pop.document.write('<img src="'+ imgPath +'">');
	 	    pop.document.write('</body></html>');

	 }
	
	
	//페이지 초기화
	function fnPagingInit(){
		$("#inCurPage" ).attr("value","1"); //현재 페이지
		$("#inCurBlock").attr("value","1"); //현재 블럭
	}

	</script>
</head>

<body>
<form id="formdata" name="formdata" method="post">
	<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
	<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
	<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
	<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->
	<input type="hidden" name="srch_type"      id="srch_type"      value="1"><!-- 주문상태,제작상태 구분 -->

	<input type="hidden" name="GroupCd"        id="GroupCd"        value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"         id="CorpCd"         value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"        id="BrandCd"        value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd"    id="CustStoreCd"    value="<%=paramData.get("매장코드")%>"/>
	
	<input type="hidden" name="hoOptPromName"  id="hoOptPromName"  value=""/><!-- 전단지명 -->
	<input type="hidden" name="hInsertUserId"  id="hInsertUserId"  value=""/><!-- 등록자   -->
	<input type="hidden" name="hOrderNo"       id="hOrderNo"       value=""/><!-- 주문번호 -->
	<input type="hidden" name="hOptProcess"    id="hOptProcess"    value=""/><!-- 진행상황 -->
	<input type='hidden' name='hPromFlyerNo'   id='hPromFlyerNo'   value="" ><!-- 홍보물 시안번호 -->
	<input type='hidden' name='hProgression1'  id='hProgression1'  value="" ><!-- 홍보물 진행상황 -->
	<input type='hidden' name='hPrintTxt'      id='hPrintTxt'      value="" ><!-- 홍보물 인쇄문구 -->
	<input type='hidden' name='hRequestTxt'    id='hRequestTxt'    value="" ><!-- 홍보물 요구사항 -->
	<input type='hidden' name='hCommTxt'       id='hCommTxt'       value="" ><!-- 댓글내용 -->
	<input type='hidden' name='hCommNum'       id='hCommNum'       value="" ><!-- 댓글번호 -->
	
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
 		 		<h1>◎ <span>홍보물 신청 &gt; 주문내역</span></h1>
 		 	</header>
 		 	
	        	<div class="admin-search-o">
		    		<label for="sDate" > ▶ 주문 기간 : </label>
		    		<input class="big_0" name="sDate" type="text" value="<%=StartDate%>" onchange="fnPagingInit();"/> ~ 
					<input class="big_0" name="eDate" type="text" value="<%=EndDate%>" onchange="fnPagingInit();"/> 
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    		<label for="opt-process" > ▶ 진행상황 : </label>
		    		<select id="opt-process" name="opt-process" onchange="fnPagingInit();">
							<!-- 진행상황 -->
		    		</select>
		    		<label for="opt-prom-name" > ▶ 전단지명 : </label>
		    		<input id="opt-prom-name" name="opt-prom-name" value="" style="width: 100px;" onchange="fnPagingInit();">
		    		<span><button class="searchDateBtn" onclick="fnShowOrderList();" style="cursor: pointer;">조회</button></span>
		  		</div>
			  		
 		 		<div id="" class="list-wide ad-tbl">
 		 			<div class="long-tbl-box">
				  		<table style="width: 1370px;" class="scroll-y" id="ord-list-tb">
				    		<thead>
				    			<tr>
				      				<th width="50" >순번</th>
				        			<th width="100" >주문일자</th>
				        			<th width="130" >주문번호</th>
				        			<th width="100">홍보물코드</th>
				        			<th width="100">홍보물명</th>
				      				<th width="100" >작업유형</th>
				        			<th width="60">주문단위</th>
				        			<th width="60">주문수량</th>
				        			<th width="120">주문금액</th>
				        			<th width="100">주문상태</th>
<!-- 				        			<th width="80" class="productionTh">시안등록</th> -->
				      				<th width="100" >최종시안</th>
				        			<th width="60">배송상태</th>
				        			<th width="80">택배사</th>
				        			<th width="210">송장번호</th>
				      			</tr>
				    		</thead>
				    		<tbody>
		<%
			int inSeq = 0;
				
			if( list != null && list.size() > 0 ) 
			{
				for( int i = 0; i < list.size(); i++ ) 
				{
					orderBean = (orderBean) list.get(i);
					inSeq = inTotalCnt - ((inCurPage-1)*inRowPerPage);
		%>
			    			<tr>
				      				<td width="50" class="txt-cnt"><%=orderBean.get순번()%></td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get주문일자()%></td> 
				      				<td width="130" class="txt-cnt">
				      					<a href="javascript:void(0);" class="bold" onclick="fnShowListDetail('<%=orderBean.get주문번호()%>', '<%=orderBean.get등록자()%>')"><%=orderBean.get주문번호()%></a>
				      				</td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get홍보물코드()%></td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get홍보물코드명()%></td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get작업유형()%></td> 
				      				<td width="60" class="txt-cnt"><%=orderBean.get주문단위()%></td>
				      				<td width="60" class="txt-cnt"><%=orderBean.get주문수량()%></td> 
				      				<td width="120" class="txt-prc"><%=orderBean.get주문가격()%></td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get주문상태()%></td> 
<%-- 				      				<td width="80" class="txt-cnt production"><button class="fileBtn" onclick="fnShowListDetail('<%=orderBean.get주문번호()%>' , '<%=orderBean.get등록자()%>')" style="cursor: pointer;">등록</button></td>  --%>
				      				<td width="100" class="txt-cnt">
<!-- 										<button class="confirmBtn" onclick="">확인</button> -->
				      				<%
				      					String promFile = JSPUtil.chkNull((String)orderBean.get시안파일명() , "");
				      					if(!"".equals(promFile)){
				      				%>
<%-- 				      					<button style="cursor:pointer;" class="confirmBtn" onclick="self.location='<%=root%>/com/fileDown.jsp?fname=<%=promFile %>&gubn=2'; return false;">확인</button> --%>
											<button style="cursor:pointer;" class="confirmBtn" onclick="ImgPopup('<%=promFile%>'); return false;">확인</button>
				      				<%	}else{ %>
<!-- 				      					<button class="confirmBtn" onclick="return false;">확인</button> -->
				      				<%  } %>
				      				</td> 
				      				<td width="60" class="txt-cnt"><%=orderBean.get제작상태()%></td> 
				      				<td width="80" class="txt-cnt"><%=orderBean.get택배사코드명()%></td> 
				      				<td width="194" class="txt-cnt"><%=orderBean.get송장번호()%></td>
				      			</tr>
			<%
						inSeq--;
					}
				} 
				else 
				{
			%>
	      			<tr>
	      				<td colspan="9">조회된 내용이 없습니다.</td>
	      			</tr>
			<%
				}
			%>
				      			
				      		</tbody>
			    		</table>
		    		</div>

				<!-- 페이징 표시 -->
				<div class="paging">
				   	 <ul class="numbering">
									        
						<%	
							if( inTotalPageCount > 0 ) 
							{
								if( inCurBlock == 1 ) 
								{
						%>
									<li class="f"><a href="#">◁</a></li>
						<%	
								} 
								else 
								{
						%>
									<li class="f"><a href="JavaScript:goPage('1','1');" onFocus='this.blur()'>◁</a></li>  
						<%	
								}
								
								if( inPrevBlock == inCurBlock ) 
								{
						%>
						  		 	<li class="p"><a href="#">PREV</a></li>
						<% 
								
								} 
								else 
								{
						%>
									<li class="p"><a href="JavaScript:goPage('<%=inPrevPage %>','<%=inPrevBlock %>');" onFocus='this.blur()'>PREV</a></li>
						<%
								}
							
								int nPageIndex = 0;
								
								for( int i = 0; i < inPagePerBlock; i++ ) 
								{
									nPageIndex = inCurBlock * inPagePerBlock  - inPagePerBlock  + (i+1);
									
									if( nPageIndex <= inTotalPageCount ) 
									{
										if( nPageIndex == inCurPage ) 
										{
						%>   
						   					<li><%=nPageIndex %></li>
						<%
										} 
										else 
										{
						%>
						   			<li><a href="JavaScript:goPage('<%=nPageIndex %>','<%=inCurBlock %>');" onFocus='this.blur()'><%=nPageIndex %></a></li>
						<%
										}
									}
								}
								
								if( inNextBlock == inCurBlock ) 
								{
						%>
						    		<li class="n"><a href="#">NEXT</a></li>
						<%
								} 
								else 
								{
						%>
						    		<li class="n"><a href="JavaScript:goPage('<%=inNextPage %>','<%=inNextBlock %>');"  onFocus='this.blur()'>NEXT</a></li>
						<%
								}
								
								if( inTotalPageBlockCount == inCurBlock ) 
								{
						%>
									<li class="l"><a href="#">▷</a></li>
						<%	
								} 
								else 
								{
						%>
									<li class="l"><a href="JavaScript:goPage('<%=inTotalPageCount%>','<%=inTotalPageBlockCount%>');" onFocus='this.blur()'>▷</a></li>			
						<%	
								}
							}
						%>
				   	</ul>
				</div>
		
 		 		</div>
 		 	</div><!-- end of cont-admin -->
 		 	
 		</section>
 	
	 	<!-- 주문 상세 보기 : 주문번호 클릭 시 -->
	 	<!-- modal popup -->
	 	<div class="overlay-bg8" >
	 		<div class="dtl-pop view-pop" id="pop-order-dtl"> </div>
	 	</div>
 	</div><!-- wrap end -->
 
</form> 
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>