<%
/** ############################################################### */
/** Program ID   : prom-dtl.jsp                            */
/** Program Name :  prom-detail	       					*/
/** Program Desc :  관리자-홍보물상세관리							*/
/** Create Date  :   2015.04.30					              		*/
/** Update Date  :                                                  */
/** Programmer   :                                          		*/
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CreateCombo" %>
<%@ page import="com.beans.CodeBean" %>

<%@ page import="admin.beans.storeBean" %> 
<%@ page import="admin.dao.storeDao" %>

<%@ page import="prom_mnt.dao.promMntDao" %>
<%@ page import="prom_mnt.beans.promMntBean" %>
<%@ page import="com.util.BoardConstant" %>
<%@ include file="/com/common.jsp"%>

<%

	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	String root = request.getContextPath();

	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	paramData.put("기업코드"  	, (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  	, (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드"	, (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드"	, (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("권한코드"    , (String)session.getAttribute("sseCustAuth"));
	paramData.put("등록자ID"	, (String)session.getAttribute("sseCustId"));
	paramData.put("등록자명"	, (String)session.getAttribute("sseCustNm"));
	
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sseCustAuth  = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth" ),""); //권한코드	
	String sseCustId    = JSPUtil.chkNull((String)session.getAttribute("sseCustId"   ),""); //등록자ID
	String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"   ),""); //등록자명
	
	System.out.println(">>>> Session 정보 >>>>>>>");
	System.out.println("기업코드 : "+JSPUtil.chkNull((String)paramData.get("기업코드")    	, ""));
	System.out.println("법인코드 : "+JSPUtil.chkNull((String)paramData.get("법인코드")      , ""));
	System.out.println("브랜드코드 : "+JSPUtil.chkNull((String)paramData.get("브랜드코드")  , ""));
	System.out.println("권한코드 :" +JSPUtil.chkNull((String)paramData.get("권한코드")     	, ""));
	System.out.println("등록자ID : "+JSPUtil.chkNull((String)paramData.get("등록자ID")  , ""));
	System.out.println("등록자명 : "+JSPUtil.chkNull((String)paramData.get("등록자명")  , ""));

	//-------------------------------------------------------------------------------------------------------
	// Parameter 정보
	//-------------------------------------------------------------------------------------------------------
	String StartDate  = JSPUtil.chkNull((String)paramData.get("sDate")    , ""); //조회시작일자
	String EndDate    = JSPUtil.chkNull((String)paramData.get("eDate")    , ""); //조회종료일자
	paramData.put("조회시작일자", request.getParameter("sDate"));
	paramData.put("조회종료일자", request.getParameter("eDate"));
	paramData.put("inCurPage"	, request.getParameter("inCurPage"));
	paramData.put("inCurBlock"	, request.getParameter("inCurBlock"));
	
	System.out.println("inCurPage : "+request.getParameter("inCurPage"));
	System.out.println("inCurBlock : "+request.getParameter("inCurBlock"));
	
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
	
	paramData.put("조회시작일자",    StartDate   );
	paramData.put("조회종료일자" ,   EndDate    );
	

	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull(request.getParameter("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull(request.getParameter("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 7;                                                                            // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 7;                                                                            // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝

	//-------------------------------------------------------------------------------------------------------
	//  콤보자료 조회처리 (법인, 브랜드, 대분류, 중분류)
	//----------------------------------------------------------------------------------------------------
	
	//-------------------------------------------------------------------------------------------------------
	// Parameter 정보
	//-------------------------------------------------------------------------------------------------------
	String inCompanyCd  = JSPUtil.chkNull((String)paramData.get("inCompanyCd")      , ""); //기업코드
	String inCorpCd     = JSPUtil.chkNull((String)paramData.get("inCorpCd")       , ""); //법인코드
	String inBrandCd	= JSPUtil.chkNull((String)paramData.get("inBrandCd")      , ""); //브랜드코드
	String inBigClass	= JSPUtil.chkNull((String)paramData.get("inBigClass")     , ""); //대분류
	String inMidClass	= JSPUtil.chkNull((String)paramData.get("inMidClass")     , ""); //중분류

	System.out.println(">>>> Parameter정보 >>>>>>>");
	System.out.println("inCompanyCd : "+JSPUtil.chkNull((String)paramData.get("inCompanyCd"), ""));
	System.out.println("inCorpCd : "+JSPUtil.chkNull((String)paramData.get("inCorpCd"), ""));
	System.out.println("inBrandCd : "+JSPUtil.chkNull((String)paramData.get("inBrandCd"), ""));
	System.out.println("inBigClass : "+JSPUtil.chkNull((String)paramData.get("inBigClass"), ""));
	System.out.println("inMidClass : "+JSPUtil.chkNull((String)paramData.get("inMidClass"), ""));
	
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 법인,브랜드,대분류,중분류에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	if ("".equals(inCompanyCd) || inCompanyCd == null || sseCustAuth.equals("41"))
	{
		if(sseCustAuth.equals("41")){ //모든권한
			inCompanyCd = "%";
		}else{
			inCompanyCd = sseGroupCd;
		}
	}
	
	if ("".equals(inCorpCd) || inCorpCd == null)
	{
		inCorpCd = "%";
	}
	if ("".equals(inBrandCd) || inBrandCd == null)
	{
		inBrandCd = "%";
	}	
	if ("".equals(inBigClass) || inBigClass == null)
	{
		inBigClass = "%";
	}
	if ("".equals(inMidClass) || inMidClass == null)
	{
		inMidClass = "%";
	}
	
	paramData.put("기업코드"  		, inCompanyCd);
	paramData.put("법인코드"  		, inCorpCd);
	paramData.put("브랜드코드"		, inBrandCd);
	paramData.put("홍보물대분류"	, inBigClass);
	paramData.put("홍보물코드"		, inMidClass);
	
	System.out.println(">>>> 재셋팅 Parameter정보 >>>>>>>");
	System.out.println("기업코드 : "+JSPUtil.chkNull((String)paramData.get("기업코드")    	  	, ""));
	System.out.println("법인코드 : "+JSPUtil.chkNull((String)paramData.get("법인코드")    	  	, ""));
	System.out.println("브랜드코드 : "+JSPUtil.chkNull((String)paramData.get("브랜드코드")      , ""));
	System.out.println("홍보물대분류 : "+JSPUtil.chkNull((String)paramData.get("홍보물대분류")  , ""));
	System.out.println("홍보물코드 : "+JSPUtil.chkNull((String)paramData.get("홍보물코드")     	, ""));
	
	//-------------------------------------------------------------------------------------------------------
	//  Bean 및 Dao 처리
	//-------------------------------------------------------------------------------------------------------
	promMntBean promMntBean = null; 
	promMntDao  promMntDao  = new promMntDao();
	
	ArrayList<promMntBean> comboList = null;
	ArrayList<promMntBean> comboList1 = null;
	ArrayList<promMntBean> comboList2 = null;
	ArrayList<promMntBean> comboPromList = null;
	ArrayList<promMntBean> comboPromMiddleList = null;
	
	int comboTotalCnt   = 0; // 전체 레코드 수
	
	//comboList     = promMntDao.selectComboList(paramData);       	 // 조회조건에 맞는 기업,법인,브랜드조회
	//comboTotalCnt = promMntDao.selectComboListCount(paramData);  	 // 전체레코드 수
	
	comboList1   =  promMntDao.selectCompanyCd(paramData);           //법인정보 조회
	comboList2   =  promMntDao.selectBrandCd(paramData);             //브랜드조회
	
	comboPromList = promMntDao.selectPromList(paramData);		 		 // 조회조건에 맞는 대분류 조회
	comboPromMiddleList = promMntDao.selectPromMiddleList(paramData);	 // 조회조건에 맞는 중분류 조회

	
	//-------------------------------------------------------------------------------------------------------
	//  홍보물 정보 리스트 조회처리
	//-------------------------------------------------------------------------------------------------------
	
	ArrayList<promMntBean> list = null;
	
	list       = promMntDao.selectList(paramData);        //조회조건에 맞는 이벤트 리스트
	inTotalCnt = promMntDao.selectListCount(paramData);   //전체레코드 수
	
	//수정[X]
	//####################################################################################################페이지 구하기 시작
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
	//####################################################################################################페이지 구하기 끝
	
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/include/common_file.inc" %>
	<title>KCFM 관리자</title>  
    
    <script type="text/javascript">
	$(document).ready(function()
	{ 
		getCurrent();
		fnCalendar();
	});
	
	window.onload = function(){
		
	};

	
	//법인 selectbox 선택때 브랜드코드 조회
    function chgCorp(val){
    	$("#gubun").attr("value","brand");
    	$("#inCompanyCd").attr("value","<%=inCompanyCd%>");
    	$("#inCorpCd").attr("value", val);
		
		$.ajax(
			{
				url      : "<%=root%>/promotion/prom-dtl-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#opt-brand option").remove();
								$("#opt-brand").append(trim(data));

								chgLargeList(); //대분류코드 조회
				           }
			});
    }
	
    //브랜드코드 selectbox 선택때 대분류 조회
    function chgLargeList(){

    	$("#gubun").attr("value","large");
    	$("#inCompanyCd").attr("value", "<%=inCompanyCd%>");
    	$("#inCorpCd").attr("value", $("#opt-corp").val());
    	$("#inBrandCd").attr("value",$("#opt-brand").val());
    	
    	$.ajax({
    				url      : "<%=root%>/promotion/prom-dtl-combo.jsp",
    				type     : "POST",
    				data     : $("#formdata").serialize(),
    				dataType : "html", 
    				success  : function(data)
    						   {  
    								
   								$("#opt-bigClass option").remove();
   								$("#opt-bigClass").append(trim(data));

   								fnViewMiddleCd($("#opt-bigClass").val());//중분류 코드 조회

   				          	 	}
   			 });

    }
  
    //대분류코드 selectbox 선택때 중분류 조회
	function fnViewMiddleCd(val){
   		$("#gubun").attr("value", "middle");
    	$("#inCompanyCd").attr("value", "<%=inCompanyCd%>");
    	$("#inCorpCd").attr("value", $("#opt-corp").val());
    	$("#inBrandCd").attr("value",$("#opt-brand").val());
    	$("#inBigClass").attr("value",val);
    	
		$.ajax(
			{
				url      : "<%=root%>/promotion/prom-dtl-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#opt-midClass option").remove();
								$("#opt-midClass").append(trim(data));

						    	$("#inMidClass").attr("value",$("#opt-midClass").val());
				           }
			});
				
	}
    
	//홍보물정보 조회
	function search_list()
	{
	    var frm = document.getElementById("formdata");
	    
	    frm.inCorpCd.value   = document.getElementById("opt-corp").value;
	    frm.inBrandCd.value  = document.getElementById("opt-brand").value;
	    frm.inBigClass.value = document.getElementById("opt-bigClass").value;
	    frm.inMidClass.value = document.getElementById("opt-midClass").value;
	    frm.inCurPage.value  = "1";    
	    frm.action = "<%=root%>/promotion/prom-dtl.jsp";
	    frm.target = "_self";
	    frm.submit();
	    
	}
    
	
	//페이징 목록보기
	function goPage(page, block) 
 	{
		var frm = document.getElementById("formdata");
		
		frm.inCurPage.value  = page;        
		frm.inCurBlock.value = block; 
		frm.inCorpCd.value   = document.getElementById("opt-corp").value;
		frm.inBrandCd.value  = document.getElementById("opt-brand").value;
	    frm.inBigClass.value = document.getElementById("opt-bigClass").value;
	    frm.inMidClass.value = document.getElementById("opt-midClass").value;
	    frm.action = "<%=root%>/promotion/prom-dtl.jsp";
	    frm.target = "_self";
	    frm.submit();
 	}
    
	// 조회내역 화면에 출력
    function fnRetSetting(id, out){
    	document.getElementById(id).innerHTML = out;
    	
    }
    
	//홍보물 이미지 보기
    function ImgPopup(theURL){
 		var popOption = "width=400, height=400, menubar=no, resizable=yes, scrollbars=yes, status=no, titlebar=no, tollbar=no";
 	    var pop = window.open(theURL,"ImgPopup",popOption);

 	    pop.document.write('<html><head><title>이미지팝업보기</title></head>');
 	    pop.document.write('<body style="margin:0px;">'); // margin는 여백조절
 	    pop.document.write('<img src="'+ theURL +'">');
 	    pop.document.write('</body></html>');

    }
	

	// 홍보물 상세보기
    function fnShowListDetail(group, corp, brand, code, no){
    	fnShowDetail();
    	
    	var frm = document.getElementById("formdata");
  
    	frm.vGroupCd.value  = group;
    	frm.vCorpCd.value  	= corp;
    	frm.vBrandCd.value 	= brand;
    	frm.vPromoCd.value 	= code;
    	frm.vPromoNo.value 	= no;
    	frm.action = "<%=root%>/promotion/prom-dtl-view.jsp";
    	frm.target = "iWorker";
    	frm.submit();
    	
    	
    }
    
	// 홍보물 신규등록
	function goRegist()	
	{ 	
		var frm = document.getElementById("formdata");	
		frm.inEvent.value = "new";
 		frm.action = "<%=root%>/promotion/prom-regist.jsp";
 		frm.target = "_self";
		frm.submit();
		
	}
	
	// 홍보물 수정
	function fnModiWriting(group, corp, brand, menu, code, no)	
	{	
		if (confirm("수정하시겠습니까?")) 
		{
			var frm = document.getElementById("formdata");		
			
			frm.inCompanyCd.value   = group;
		    frm.inCorpCd.value    = corp;
		    frm.inBrandCd.value   = brand;
		    frm.inBigClass.value  = menu;
		    frm.inMidClass.value  = code;
		    frm.inPromNo.value    = no;
		    frm.inEvent.value     = "mod";
			frm.action = "<%=root%>/promotion/prom-regist.jsp";
			frm.target = "_self";
			frm.submit();
		}
	}
	
	// 홍보물 삭제
	function fnDeleteWriting(group, corp, brand,menu ,code, no)
	{
		if (confirm("삭제하시겠습니까?")) 
		{	
		 	var frm = document.getElementById("formdata");
		 	
		 	
		 	alert(frm.inCompanyCd.value);
		 	
			frm.inCompanyCd.value  = group;
		    frm.inCorpCd.value    = corp;
		    frm.inBrandCd.value   = brand;
		    frm.inBigClass.value  = menu;
		    frm.inMidClass.value  = code;
		    frm.inPromNo.value    = no;
		    frm.inEvent.value     = "del";
	 		frm.action = "<%=root%>/promotion/prom-delete-ok.jsp";
	 		frm.target = "_self";
			frm.submit();
		}
    }	
	 
    </script>
</head>

<body>
<form id="formdata" name="formdata" method="post">
	<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>
	
	<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
	<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
	<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
	<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->
	
	<!-- 조회, 수정, 삭제 -->
	<input type="hidden" name="gubun"          id="gubun"          value=""> 
	<input type="hidden" name="inCompanyCd"      id="inCompanyCd"      value="">  <!-- 기업코드   -->
	<input type="hidden" name="inCorpCd" 	   id="inCorpCd"       value="">  <!-- 법인코드   -->  
	<input type="hidden" name="inBrandCd" 	   id="inBrandCd"      value="">  <!-- 브랜드코드 -->
	<input type="hidden" name="inBigClass" 	   id="inBigClass"     value="">  <!-- 대분류코드 -->  
	<input type="hidden" name="inMidClass" 	   id="inMidClass"     value="">  <!-- 중분류코드 -->  
	<input type="hidden" name="inPromNo"       id="inPromNo"	   value="">  <!-- 홍보물번호 -->
	<input type="hidden" name="inEvent" 	   id="inEvent"        value="">  <!-- 홍보물이벤트(수정)   --> 

	<!-- 상세보기  -->
	<input type="hidden" name="vGroupCd"     value=""/><!-- 기업코드   -->
	<input type="hidden" name="vCorpCd"      value=""/><!-- 법인코드   -->
	<input type="hidden" name="vBrandCd"     value=""/><!-- 브랜드코드 -->
	<input type="hidden" name="vCustStoreCd" value=""/><!-- 매장번호   -->
	<input type="hidden" name="vPromoCd"     value=""/><!-- 홍보물코드 -->
	<input type="hidden" name="vPromoNo"     value=""/><!-- 홍보물번호 -->
	
 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("<%=root%>/include/pr-header.jsp"); </script> 
	 	</section> 
	 	
	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
	 	</section>
	 	
 		  <section class="contents admin" style="top: 25px">
 		 	<header>
 		 		<h1>◎ <span>홍보물 관리</span></h1>
 		 	
 		 	</header>
 		 	
 		 	<div id="cont-admin">

	        	<div class="admin-search-o">
		    		<label for="opt-corp" > ▶ 법인 : </label>
		    		<select id="opt-corp" name="opt-corp" onchange='chgCorp(this.value);'>
		    			<option value="%">전체</option>
		    			<%  if(comboList1 !=null && comboList1.size() > 0){
				    			for(int i=0; i<comboList1.size(); i++){
				    				promMntBean = (promMntBean) comboList1.get(i);
				    	%>	
		    			<option value=<%=promMntBean.get법인코드()%><%if(promMntBean.get법인코드().equals(inCorpCd)){%> selected="selected" <%}else{} %>><%=promMntBean.get법인명() %></option>
		    			<% 		
				      		}
				    	} %>
		    				<!-- option -->
		    		</select>
		    		<label for="opt-brand" > ▶ 브랜드 : </label>
		    		<select id="opt-brand" name="opt-brand" onchange='chgLargeList();'>
	    					<option value="%">전체</option>
		    			<%  if(comboList2 !=null && comboList2.size() > 0){
				    			for(int i=0; i<comboList2.size(); i++){
				    				promMntBean = (promMntBean) comboList2.get(i);
				    	%>
		    				<option value=<%=promMntBean.get브랜드코드() %><%if(promMntBean.get브랜드코드().equals(inBrandCd)){%> selected="selected" <%}else{} %>><%=promMntBean.get브랜드명() %></option>
		    			<% 		
				      		}
				    	} %>
		    		
		    				<!-- option -->
		    		</select>
				    	
		    		<label for="opt-bigClass" > ▶ 대분류 : </label>
		    		<select id="opt-bigClass" name="opt-bigClass" onchange='fnViewMiddleCd(this.value)'>
    					<option value="%">전체</option>
		    		<%  if(comboPromList !=null && comboPromList.size() > 0){
				    		for(int i=0; i<comboPromList.size(); i++){
				    				promMntBean = (promMntBean) comboPromList.get(i);
				    %>
		    				<option value=<%=promMntBean.get메뉴코드() %><%if(promMntBean.get메뉴코드().equals(inBigClass)){%> selected="selected" <%}else{} %>><%=promMntBean.get메뉴코드명() %></option>
		    				
		    		<% 		
				      	}
				    } %>
		    				<!-- option -->
		    		</select>
				    
		    		<label for="opt-midClass" > ▶ 중분류 : </label>
		    		<select id="opt-midClass" name="opt-midClass">
    					<option value="%">전체</option>
		    		<%  if(comboPromMiddleList !=null && comboPromMiddleList.size() > 0){
				    		for(int i=0; i<comboPromMiddleList.size(); i++){
				    				promMntBean = (promMntBean) comboPromMiddleList.get(i);
				    %>	
		    			<option value=<%=promMntBean.get메뉴코드() %><%if(promMntBean.get메뉴코드().equals(inMidClass)){%> selected="selected" <%}else{} %>><%=promMntBean.get메뉴코드명() %></option>
		    			
		    		<% 		
				      	}
				    } %>
		    				<!-- option -->
		    		</select>
		    		<span style="padding-left: 100px;">
		    			<button class="searchDateBtn" onclick="search_list();">조회</button>
		    			<button class="newSubmitBtn" onclick="goRegist();">신규</button>
		    		</span>
		  		</div>
			  		
 		 		<div id="" class="list-wide ad-tbl">
 		 			<div class="long-tbl-box">
				  		<table width="1370" class="scroll-y" id="listTable">
				    		<thead>
				    			<tr>
				      				<th width="130" >법인명</th>
				        			<th width="110" >브랜드명</th>
				        			<th width="130">대분류명</th>
				        			<th width="130">중분류명</th>
				      				<th width="80" >홍보물번호</th>
				        			<th width="155" >홍보물명</th>
				        			<th width="100">홍보물타입</th>
				        			<th width="80">주문단위</th>
				      				<th width="100" >단가</th>
				        			<th width="60">앞면img</th>
				        			<th width="60">뒷면img</th>
				        			<th width="130">제작업체</th>
				        			<th width="105">편집</th>
				      			</tr>
				    		</thead>
				    		<tbody>
				    	<%  if(list !=null && list.size() > 0){
				    			for(int i=0; i<list.size(); i++){
				    				promMntBean = (promMntBean) list.get(i);
				    	%>	
				    			<tr>
				    				<td width="110" class="txt-cnt"><%=promMntBean.get법인명()%></td>		
				    				<td width="110" class="txt-cnt"><%=promMntBean.get브랜드명()%></td> 
				      				<td width="130" class="txt-cnt"><%=promMntBean.get대분류명()%></td> 
				      				<td width="130" class="txt-cnt"><%=promMntBean.get중분류명()%></td>
				      				<td width="120" class="txt-cnt"><%=promMntBean.get홍보물번호()%></td> 
				      				<td width="150" class="txt-cnt">
				      					<a href="javascript:fnShowListDetail('<%=promMntBean.get기업코드()%>','<%=promMntBean.get법인코드()%>','<%=promMntBean.get브랜드코드()%>','<%=promMntBean.get중분류코드()%>','<%=promMntBean.get홍보물번호()%>');" class="bold"><%=promMntBean.get홍보물명()%></a>
				      				</td> 
				      				<td width="100" class="txt-cnt"><%=promMntBean.get홍보물타입()%></td> 
				      				<td width="80" class="txt-cnt"><%=promMntBean.get주문단위()%></td>
				      				<td width="100" class="txt-prc"><%=promMntBean.get단가()%></td> 
				      	<% 			if("".equals(promMntBean.get이미지앞면파일명()) || promMntBean.get이미지앞면파일명() == null){ 
				      	%>
				      				<td width="60" class="txt-cnt">없음</button></td> 
		      			<% 			}else{
		      			%>
				      				<td width="60" class="txt-cnt"><button class="confirmBtn" id='frn_img_bnt' name='frn_img_bnt' onclick="ImgPopup('<%=root%>/<%=promMntBean.get이미지경로()%><%=promMntBean.get이미지앞면파일명()%>')">확인<!-- 앞면이미지--></button></td>	
				      	<% 			}
				      	 			
				      				if("".equals(promMntBean.get이미지뒷면파일명()) || promMntBean.get이미지뒷면파일명() == null){
				      	%>
				      				<td width="60" class="txt-cnt">없음</button></td> 
		      			<% 			}else{
		      			%>
				      				<td width="60" class="txt-cnt"><button class="confirmBtn" id="bak_img_bnt" name="bak_img_bnt"  onclick="ImgPopup('<%=root%>/<%=promMntBean.get이미지경로()%><%=promMntBean.get이미지뒷면파일명()%>')">확인<!-- 뒷면이미지--></button></td>	
				      	<% 			}
				      	%>
				      				<td width="105" class="txt-cnt"><%=promMntBean.get홍보물업체명()%></td>
				      				<td width="105" class="txt-cnt" >
										<button class="deleteBtn" onclick="fnDeleteWriting('<%=promMntBean.get기업코드()%>','<%=promMntBean.get법인코드()%>','<%=promMntBean.get브랜드코드()%>','<%=promMntBean.get대분류명()%>','<%=promMntBean.get중분류코드()%>','<%=promMntBean.get홍보물번호()%>');">삭제</button>
										<button class="modifyBtn" onclick="fnModiWriting('<%=promMntBean.get기업코드()%>','<%=promMntBean.get법인코드()%>','<%=promMntBean.get브랜드코드()%>','<%=promMntBean.get대분류명()%>','<%=promMntBean.get중분류코드()%>','<%=promMntBean.get홍보물번호()%>');">수정</button>
									</td> 
				      			</tr>	
				      	<% 		
				      			}
				    		} else {
				      	%>     
				      			<tr class="data" align="center" bgcolor="#ffffff"><td colspan="14">조회된 내용이 없습니다.</td></tr>
				      	<% 
				      		}
				      	%>
				      		</tbody>
			    		</table>
		    		</div>
		    		
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
 	
	 	<!-- 전단지 상세 -->
	 	<!-- modal popup -->
	 	<div class="overlay-bg8" >
	 		<div class='dtl-pop view-pop' id='pop-order-dtl'></div>
	 	</div>
	 	
 	</div><!-- wrap end -->
 </form>
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>