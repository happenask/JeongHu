
<%
/** ############################################################### */
/** Program ID   : maintain-prom-regist.jsp                         */
/** Program Name :  maintain-prom-registl	       					*/
/** Program Desc :  관리자-홍보물신규등록							*/
/** Create Date  :   2015.04.30					              		*/
/** Update Date  :                                                  */
/** Programmer   :                                          		*/
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/com/common.jsp"%> 
<%@ page import="com.util.CreateCombo" %>
<%@ page import="prom_mnt.dao.promMntDao" %>
<%@ page import="prom_mnt.beans.promMntBean" %>

<%
	
	String root = request.getContextPath();
	
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드"  , (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("권한코드"  , (String)session.getAttribute("sseCustAuth"));
	
    
	//-------------------------------------------------------------------------------------------------------
	// Parameter 정보
	//-------------------------------------------------------------------------------------------------------
	
    String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
    String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
    String sseCustAuth   = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth"  ),""); //권한코드
	String StartDate  = JSPUtil.chkNull((String)paramData.get("sDate")    , ""); //조회시작일자
	String EndDate    = JSPUtil.chkNull((String)paramData.get("eDate")    , ""); //조회종료일자
	
	paramData.put("조회시작일자", request.getParameter("sDate"));
	paramData.put("조회종료일자", request.getParameter("eDate"));
	
	paramData.put("inCurPage", request.getParameter("inCurPage"));
	paramData.put("inCurBlock", request.getParameter("inCurBlock"));
	
     
	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull(request.getParameter("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull(request.getParameter("inCurBlock"), "1"));  // 현재 블럭
	//####################################################################################################페이징 관련 변수 끝

	//-------------------------------------------------------------------------------------------------------
	// 초기값 초기화
	//-------------------------------------------------------------------------------------------------------
	String fileName1     = ""; //첨부파일이름1
	String fileName2     = ""; //첨부파일이름2
	String fileName3     = ""; //첨부파일이름3
	String fileUrl       = ""; //이미지경로
	
  	String sOptGroup	= ""; //기업코드
	String sOptCorp		= ""; //법인코드
	String sOptBrand	= ""; //브랜드코드
	String sOptBigClass	= ""; //대분류코드
	String sOptMidClass	= ""; //중분류코드
	String sPromNo		= ""; //홍보물번호
	String sPromNm		= ""; //홍보물명
	String sPromType	= ""; //홍보물타입
	String sPromSize    = ""; //홍보물사이즈
	String sOrdCoun		= ""; //주문수량
	String sOptOrdUnit	= ""; //주문단위
	String sOrdPrice	= ""; //단가
	String sOptPromotion = ""; //홍보물업체,홍보물업체전화번호

	String inEvent	     = ""; //이벤트구분(수정)
	String inCompanyCd   = ""; //기업코드
	String inCorpCd      = ""; //법인코드
	String inBrandCd	 = ""; //브랜드코드
	String inBigClass	 = ""; //대분류(홍보물대분류)
	String inMidClass	 = ""; //중분류(홍보물코드)
	String inPromNo	     = ""; //홍보물번호

	
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 법인,브랜드,대분류,중분류에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	if ("".equals(inCompanyCd) || inCompanyCd == null)
	{
		if(sseCustAuth.equals("90")){ //모든권한
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
	
	if ("".equals(sOptGroup) || sOptGroup == null)
	{	
		sOptGroup = "%";
		
	}
	if ("".equals(sOptCorp) || sOptCorp == null)
	{	
		sOptCorp = "%";
		
	}
	if ("".equals(sOptBrand) || sOptBrand == null)
	{	
		sOptBrand = "%";
		
	}
	if ("".equals(sOptBigClass) || sOptBigClass == null)
	{	
		sOptBigClass = "%";
		
	}
	if ("".equals(sOptMidClass) || sOptMidClass == null)
	{	
		sOptMidClass = "%";
		
	}
	
	//--------------------------------------------------------------------------------------------------
	// Parameter 입력
	//--------------------------------------------------------------------------------------------------	
	paramData.put("기업코드"  		, inCompanyCd);
	paramData.put("법인코드"  		, inCorpCd);
	paramData.put("브랜드코드"		, inBrandCd);
	paramData.put("홍보물대분류"	, inBigClass);
	paramData.put("홍보물코드"		, inMidClass);
	paramData.put("홍보물번호"		, inPromNo);
	
	//-------------------------------------------------------------------------------------------------------
	//  Bean 및 Dao 처리
	//-------------------------------------------------------------------------------------------------------
	
	promMntBean promMntBean = null;     // 내용보기에서 담을 빈
	promMntDao  promMntDao  = new promMntDao();
	
	//-------------------------------------------------------------------------------------------------------
	//  콤보자료 조회처리
	//-------------------------------------------------------------------------------------------------------
	ArrayList<promMntBean> comboList = null;
	ArrayList<promMntBean> comboList1 = null;
	ArrayList<promMntBean> comboList2 = null;

	int comboTotalCnt   = 0;                                               // 전체 레코드 수

	//comboList     = promMntDao.selectComboList(paramData);       	 // 조회조건에 맞는 기업,법인,브랜드정보 조회
	//comboTotalCnt = promMntDao.selectComboListCount(paramData);  	 // 전체레코드 수
	
	comboList1   =  promMntDao.selectCompanyCd(paramData);           //법인정보 조회
	comboList2   =  promMntDao.selectBrandCd(paramData);             //브랜드조회
	
	ArrayList<promMntBean> comboPromList = null;
	ArrayList<promMntBean> comboPromMiddleList = null;
	
	
	comboPromList = promMntDao.selectPromList(paramData);		 		 // 조회조건에 맞는 대분류 조회
	comboPromMiddleList = promMntDao.selectPromMiddleList(paramData);	 // 조회조건에 맞는 중분류 조회
	

	//-------------------------------------------------------------------------------------------------------
	//  [홍보물 수정]
	//-------------------------------------------------------------------------------------------------------
	
	//-------------------------------------------------------------------------------------------------------
	// Parameter 정보
	//-------------------------------------------------------------------------------------------------------
	inCompanyCd  = JSPUtil.chkNull((String)paramData.get("inCompanyCd")    , ""); //기업코드
	inCorpCd     = JSPUtil.chkNull((String)paramData.get("inCorpCd")       , ""); //법인코드
	inBrandCd	 = JSPUtil.chkNull((String)paramData.get("inBrandCd")      , ""); //브랜드코드
	inBigClass	 = JSPUtil.chkNull((String)paramData.get("inBigClass")     , ""); //대분류(홍보물대분류)
	inMidClass	 = JSPUtil.chkNull((String)paramData.get("inMidClass")     , ""); //중분류(홍보물코드)
	inPromNo	 = JSPUtil.chkNull((String)paramData.get("inPromNo")       , ""); //홍보물번호
	inEvent	     = JSPUtil.chkNull((String)paramData.get("inEvent")        , ""); //수정
	
	System.out.println(">>>> maintain-prom-regist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	System.out.println("inCompanyCd : "+JSPUtil.chkNull((String)paramData.get("inCompanyCd")    	, ""));
	System.out.println("inCorpCd : "+JSPUtil.chkNull((String)paramData.get("inCorpCd")    			, ""));
	System.out.println("inBrandCd : "+JSPUtil.chkNull((String)paramData.get("inBrandCd")      		, ""));
	System.out.println("inBigClass : "+JSPUtil.chkNull((String)paramData.get("inBigClass")     		, ""));
	System.out.println("inMidClass : "+JSPUtil.chkNull((String)paramData.get("inMidClass")     		, ""));
	System.out.println("inPromNo : "+JSPUtil.chkNull((String)paramData.get("inPromNo")     			, ""));
	System.out.println("inEvent : "+JSPUtil.chkNull((String)paramData.get("inEvent")     			, ""));
	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	
	//--------------------------------------------------------------------------------------------------
	// Parameter 입력
	//--------------------------------------------------------------------------------------------------	
	paramData.put("기업코드"  		, inCompanyCd);
	paramData.put("법인코드"  		, inCorpCd);
	paramData.put("브랜드코드"		, inBrandCd);
	paramData.put("홍보물대분류"	, inBigClass);
	paramData.put("홍보물코드"		, inMidClass);
	paramData.put("홍보물번호"		, inPromNo);
	
	System.out.println(">>>> "+inEvent+" >>>>>>>>>>>>>>>>>>>>>>>>>");
	System.out.println("기업코드 :  "+inCompanyCd);
	System.out.println("법인코드 :  "+inCorpCd);
	System.out.println("브랜드코드 :  "+inBrandCd);
	System.out.println("홍보물대분류 : "+inBigClass);
	System.out.println("홍보물코드 : "+inMidClass);
	System.out.println("홍보물번호 : "+inPromNo);
	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	
    //[수정] 홍보물 조회
	if(inEvent.equals("mod")){

		promMntBean = promMntDao.selectDetail(paramData); // 조회조건에 맞는 이벤트 리스트
		
		if(promMntBean !=null){
			sOptGroup   = promMntBean.get기업코드(); 						//기업코드
			sOptCorp    = promMntBean.get법인코드(); 						//법인코드
			sOptBrand	= promMntBean.get브랜드코드(); 						//브랜드코드
			sOptBigClass = promMntBean.get대분류코드(); 					//대분류(홍보물대분류)
			sOptMidClass = promMntBean.get중분류코드(); 					//중분류(홍보물코드)
			sPromNo	     = promMntBean.get홍보물번호(); 					//홍보물번호
			sPromNm		 = promMntBean.get홍보물명(); 						//홍보물명
			sPromType	 = promMntBean.get인쇄사용문구포함여부(); 			//홍보물타입
			sPromSize    = promMntBean.get사이즈(); 						//홍보물사이즈
			sOrdCoun	 = promMntBean.get수량(); 							//주문수량
			sOptOrdUnit	 = promMntBean.get단위(); 							//주문단위
			sOrdPrice	 = promMntBean.get매출단가(); 						//매출단가
			sOptPromotion = promMntBean.get홍보물업체코드()+","+promMntBean.get홍보물업체전화번호(); //홍보물업체,홍보물업체전화번호
			
			fileUrl 	  = promMntBean.get이미지경로();							//첨부파일경로
			fileName1     = JSPUtil.chkNull(promMntBean.get이미지표지파일명(), ""); //첨부파일이름1
			fileName2     = JSPUtil.chkNull(promMntBean.get이미지앞면파일명(), ""); //첨부파일이름2
			fileName3     = JSPUtil.chkNull(promMntBean.get이미지뒷면파일명(), ""); //첨부파일이름3
			
			System.out.println("sOptGroup :"+sOptGroup);
			System.out.println("sOptCorp :"+sOptCorp);
			System.out.println("sOptBrand :"+sOptBrand);
			System.out.println("sOptBigClass :"+sOptBigClass);
			System.out.println("sOptMidClass :"+sOptMidClass);
			System.out.println("sPromNo :"+sPromNo);
			System.out.println("sPromNm :"+sPromNm);
			System.out.println("sPromType :"+sPromType);
			System.out.println("sPromSize :"+sPromSize);
			System.out.println("sOrdCoun :"+sOrdCoun);
			System.out.println("sOptOrdUnit :"+sOptOrdUnit);
			System.out.println("sOrdPrice :"+sOrdPrice);
			System.out.println("sOptPromotion :"+sOptPromotion);
			System.out.println("fileUrl  : " + fileUrl  );
			System.out.println("fileName1  : " + fileName1  );
			System.out.println("fileName2  : " + fileName2  );
			System.out.println("fileName3  : " + fileName3  );
		}
	}
    
	
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/include/common_file.inc" %>
	<title>KCFM 관리자</title>  
	<%@ include file="/com/fileUpload.jsp"%>
    
    <script type="text/javascript">
	$(document).ready(function()
	{ 
		getCurrent();
		fnCalendar();
	});
	
	function fnStartLoad(){

		//첨부파일 추가
    	var frm = document.formdata;
    		
    	document.getElementById("s첨부파일1").innerHTML = '<%=fileName1%>';
    	document.getElementById("s첨부파일2").innerHTML = '<%=fileName2%>';
    	document.getElementById("s첨부파일3").innerHTML = '<%=fileName3%>';
    	
    	
    	//수정시
    	if("mod" == "<%=inEvent%>"){
    		$("#opt-corp").val("<%=sOptCorp%>").attr("disabled","disabled");
    		$("#opt-brand").val("<%=sOptBrand%>").attr("disabled","disabled");
    		$("#opt-bigClass").val("<%=sOptBigClass%>").attr("disabled","disabled");
    		$("#opt-midClass").val("<%=sOptMidClass%>").attr("disabled","disabled");
    		
    	}else{
    		$("#opt-corp").val("<%=sOptCorp%>").attr("disabled",false);
    		$("#opt-brand").val("<%=sOptBrand%>").attr("disabled","disabled");
    		$("#opt-bigClass").val("<%=sOptBigClass%>").attr("disabled","disabled");
    		$("#opt-midClass").val("<%=sOptMidClass%>").attr("disabled","disabled");
    		
    	}
    	fnPromType();  
    	fnOrderUnit();
    	fnPromotion();
	}
	
	function chgGroup(val){
		//alert("그룹조회");
		$("#gubun").attr("value","group");
		$("#inCorpCd").attr("value", val);
		
		$.ajax(
				{
					url      : "<%=root%>/prom_mnt/maintain-prom-regist-combo.jsp",
					type     : "POST",
					data     : $("#formdata").serialize(),
					dataType : "html", 
					success  : function(data)
							   {  
						    		
									$("#opt-group").attr("value", trim(data));
							    	fnPromType();  
							    	fnOrderUnit();
									chgCorp(val);
					           }
				});
	}
	
	//법인 selectbox 선택때 브랜드코드 조회
    function chgCorp(val){
    	//alert("브랜드조회");
    	//alert($("#opt-group").val());
    	
    	$("#gubun").attr("value","brand");
    	$("#inCompanyCd").attr("value",$("#opt-group").val());
    	$("#inCorpCd").attr("value", val);
    	
		
		$.ajax(
			{
				url      : "<%=root%>/prom_mnt/maintain-prom-regist-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#opt-brand option").remove();
								$("#opt-brand").append(trim(data));
					    		$("#opt-brand").val("<%=sOptBrand%>").attr("disabled",false);
								chgLargeList(); //대분류코드 조회
				           }
			});
    }
	
    //브랜드코드 selectbox 선택때 대분류 조회
    function chgLargeList(){

    	$("#gubun").attr("value","large");
    	$("#inCompanyCd").attr("value",$("#opt-group").val());
    	$("#inCorpCd").attr("value", $("#opt-corp").val());
    	$("#inBrandCd").attr("value",$("#opt-brand").val());
    	
    	$.ajax({
    				url      : "<%=root%>/prom_mnt/maintain-prom-regist-combo.jsp",
    				type     : "POST",
    				data     : $("#formdata").serialize(),
    				dataType : "html", 
    				success  : function(data)
    						   {  
    								
   								$("#opt-bigClass option").remove();
   								$("#opt-bigClass").append(trim(data));
					    		$("#opt-bigClass").val("<%=sOptBigClass%>").attr("disabled",false);

   								fnViewMiddleCd($("#opt-bigClass").val());//중분류 코드 조회

   				          	 	}
   			 });

    }
  
    //대분류코드 selectbox 선택때 중분류 조회
	function fnViewMiddleCd(val){
   		$("#gubun").attr("value", "middle");
    	$("#inCompanyCd").attr("value", $("#opt-group").val());
    	$("#inCorpCd").attr("value", $("#opt-corp").val());
    	$("#inBrandCd").attr("value",$("#opt-brand").val());
    	$("#inBigClass").attr("value",val);
    	
		$.ajax(
			{
				url      : "<%=root%>/prom_mnt/maintain-prom-regist-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#opt-midClass option").remove();
								$("#opt-midClass").append(trim(data));
					    		$("#opt-midClass").val("<%=sOptMidClass%>").attr("disabled",false);
						    	$("#inMidClass").attr("value",$("#opt-midClass").val());
				           }
			});
				
	}
    
    //홍보물번호 조회
	function fnPromNo(val){
		
   		$("#gubun").attr("value", "promSeq");
    	$("#inCompanyCd").attr("value", $("#opt-group").val());
    	$("#inCorpCd").attr("value", $("#opt-corp").val());
    	$("#inBrandCd").attr("value",$("#opt-brand").val());
    	$("#inBigClass").attr("value",$("#opt-bigClass").val());
    	$("#inMidClass").attr("value",val);
    	
		$.ajax(
			{
				url      : "<%=root%>/prom_mnt/maintain-prom-regist-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								
								document.getElementById("promNo").innerHTML = trim(data);
								$("#opt-promNo").attr("value", trim(data));
								
				           }
			});
    }
	
    //홍보물타입 조회
	function fnPromType(){
		
   		$("#gubun").attr("value", "promType");
   		$("#inCompanyCd").attr("value", $("#opt-group").val());
    	
		$.ajax(
			{
				url      : "<%=root%>/prom_mnt/maintain-prom-regist-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#opt-prom-type option").remove();
								$("#opt-prom-type").append(trim(data));
								if("<%=inEvent%>" == "mod"){
									$("#opt-prom-type").val("<%=sPromType%>").attr("selected","selected");
								}
				           }
			});
	}
    
	//홍보물주문단위 조회
	function fnOrderUnit(){
		//alert("홍보물주문단위");
		
   		$("#gubun").attr("value", "unit");
   		$("#inCompanyCd").attr("value", $("#opt-group").val());
    	
		$.ajax(
			{
				url      : "<%=root%>/prom_mnt/maintain-prom-regist-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#opt-ord-unit option").remove();
								$("#opt-ord-unit").append(trim(data));
								if("<%=inEvent%>" == "mod"){
									$("#opt-ord-unit").val("<%=sOptOrdUnit%>").attr("selected","selected");
								}
				           }
			});
	}
    
	//홍보물업체 조회
	function fnPromotion(){

   		$("#gubun").attr("value", "promtion");
   		//$("#inCompanyCd").attr("value", $("#opt-group").val());
    	//$("#inCorpCd").attr("value", val);
    	
    	
		$.ajax(
			{
				url      : "<%=root%>/prom_mnt/maintain-prom-regist-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#opt-promotion option").remove();
								$("#opt-promotion").append(trim(data));
								if("<%=inEvent%>" == "mod"){
									$("#opt-promotion").val("<%=sOptPromotion%>").attr("selected","selected");
								}
				           }
			});
	}
	
	//목록이동
    function goList()
	{	

		var frm = document.formdata;
 		frm.action = "<%=root%>/prom_mnt/maintain-prom-dtl.jsp";
		frm.submit();

	}
	
	
	
	//저장
	 function goRegist()
	{
		var frm = document.getElementById("formdata");
		
		
		var pOptGroup       = $("#opt-group").val();
		var pOptCorp 		= $("#opt-corp").val();
		var pOptBrand 		= $("#opt-brand").val();
		var pOptBigClass 	= $("#opt-bigClass").val();
		var pOptMidClass 	= $("#opt-midClass").val();
		var pPromNm 		= $("#promNm").val();
		var pPromSize 		= $("#promSize").val();
		var pOrdCount 		= $("#ord-count").val();
		var pOrdPricet 		= $("#ord-price").val();
		var pPromNo 		= $("#opt-promNo").val();
		var pPromType 		= $("#opt-prom-type").val();
		var pOptOrdUnit 	= $("#opt-ord-unit").val();
		var pOptPromotion 	= $("#opt-promotion").val();
		
 		var vModYn1   = document.getElementById("modYn1").value;
 		var vModYn2   = document.getElementById("modYn2").value;
 		var vModYn3   = document.getElementById("modYn3").value;
		
		if (pOptCorp == "" || pOptCorp == "%" || pOptCorp == null)
		{
			alert("법인을 선택해주세요");
			
			$("#opt-corp").attr("value", "");
			document.getElementById("opt-corp").focus();
			 
			return;
		}
		
		if (pOptBrand == "" || pOptBrand == "%" || pOptBrand == null)
		{
			alert("브랜드를 선택해주세요");
			
			$("#opt-brand").attr("value", "");
			document.getElementById("opt-brand").focus();
			 
			return;
		}
		
		if (pOptBigClass == "" || pOptBigClass == "%" || pOptBigClass == null)
		{
			alert("대분류를 선택해주세요");
			
			$("#opt-bigClass").attr("value", "");
			document.getElementById("opt-bigClass").focus();
			 
			return;
		}
		
		if (pOptMidClass == "" || pOptMidClass == "%" || pOptMidClass == null)
		{
			alert("중분류를 선택해주세요");
			
			$("#opt-midClass").attr("value", "");
			document.getElementById("opt-midClass").focus();
			 
			return;
		}
		
		if (pPromNm == "" || pPromNm == null)
		{
			alert("홍보물명을 입력해주세요");
			
			$("#promNm").attr("value", "");
			document.getElementById("promNm").focus();
			 
			return;
		}
		
		if (pPromSize == "" || pPromSize == null)
		{
			alert("규격을 입력해주세요");
			
			$("#promSize").attr("value", "");
			document.getElementById("promSize").focus();
			 
			return;
		}
		
		if (pPromSize == "" || pPromSize == null)
		{
			alert("규격을 입력해주세요");
			
			$("#promSize").attr("value", "");
			document.getElementById("promSize").focus();
			 
			return;
		}
		
		if (pOrdCount == "" || pOrdCount == null)
		{
			alert("주문수량을 입력해주세요");
			
			$("#ord-count").attr("value", "");
			document.getElementById("ord-count").focus();
			 
			return;
		}
		
		if (pOrdPricet == "" || pOrdPricet == null)
		{
			alert("단가를 입력해주세요");
			
			$("#ord-price").attr("value", "");
			document.getElementById("ord-price").focus();
			 
			return;
		}
		
		// 홍보물 정보 
		frm.inEvent.value           = "<%=inEvent%>"; 
		frm.inCompanyCd.value         = pOptGroup;
		frm.inCorpCd.value    		= pOptCorp;
		frm.inBrandCd.value   		= pOptBrand;
		frm.inBigClass.value  		= pOptBigClass;
		frm.inMidClass.value  		= pOptMidClass;
		frm.inPromNo.value    		= pPromNo;
		frm.inPromNm.value    		= encodeURIComponent(pPromNm);
		frm.inPromType.value    	= pPromType;
		frm.inPromSize.value    	= pPromSize;
		frm.inOrdCoun.value    		= pOrdCount;
		frm.inOptOrdUnit.value    	= pOptOrdUnit;
		frm.inOrdPrice.value    	= pOrdPricet;
		frm.inOptPromotion.value  	= encodeURIComponent(pOptPromotion);
		frm.action = "<%=root%>/prom_mnt/prom-regist-ok.jsp?mode1=" + vModYn1 + "&mode2=" + vModYn2 + "&mode3="+ vModYn3;
		
		frm.submit();
		
    }
 	
    //숫자만 입력(정규식)
    function onlyNumber(val){
    	//return val.replace(/[^0-9-]/gi, ""); 
    	return val.replace(/[^0-9]/gi, ""); 
    }
    
    //파일첨부 이름 변경
	function fnChgFname(obj)
	{
		var oName = obj.name ;
		var vGubn = oName.substr(oName.length-1,1);		//구분값

		if (vGubn == "1") {
			document.getElementById("s첨부파일1").innerHTML = "";
		} else if(vGubn == "2") {
			document.getElementById("s첨부파일2").innerHTML = "";
		} else {
			document.getElementById("s첨부파일3").innerHTML = "";
		}

			
	}
    
	//파일첨부삭제
	function fnDeleteFile(obj)
	{
		
		var aFile1 = document.getElementById("attachFile1").value;
		var aFile2 = document.getElementById("attachFile2").value;
		var aFile3 = document.getElementById("attachFile3").value;
		
		if(obj == "s첨부파일1"){
			
			if(aFile1 == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if (!confirm("삭제하시겠습니까?")){
				return;
			}else{
				var input = $("#attachFile1");
				input.replaceWith(input.val('').clone(true));
			}
		}else if(obj == "s첨부파일2"){
			
			if(aFile2 == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if (!confirm("삭제하시겠습니까?")){
				return;
			}else{
				var input = $("#attachFile2");
				input.replaceWith(input.val('').clone(true));
			}
		}else if(obj == "s첨부파일3"){
			
			if(aFile3 == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if (!confirm("삭제하시겠습니까?")){
				return;
			}else{
				var input = $("#attachFile3");
				input.replaceWith(input.val('').clone(true));
			}
		}
		
	}
	
	//----------------------------------------------------------------------------------------------
	//  파일 첨부 초기화
	//----------------------------------------------------------------------------------------------

	function fnIniFile(obj)
	{
		
		var frm    = document.getElementById("formdata");
		var aFile1 = document.getElementById("attachFile1");
		var aFile2 = document.getElementById("attachFile2");
		var aFile3 = document.getElementById("attachFile3");
		var sFile1 = document.getElementById("s첨부파일1");
		var sFile2 = document.getElementById("s첨부파일2");
		var sFile3 = document.getElementById("s첨부파일3");

		
		if(obj == "s첨부파일1"){
			
			if(aFile1.value == "" && sFile1.value == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if(!confirm("삭제하시겠습니까?")){
				return;
			}else {
				sFile1.value = "";
				sFile1.style.display = 'none';
				aFile1.style.display = '';
				var input = $("#attachFile1");
				input.replaceWith(input.val('').clone(true));
				frm.modYn1.value='Y';
			}
				 		
		}else if(obj == "s첨부파일2"){
			
			if(aFile2.value == "" && sFile2.value == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if(!confirm("삭제하시겠습니까?")){
				return;
			}else {
				sFile2.value = "";
				sFile2.style.display = 'none';
				aFile2.style.display = '';
				var input = $("#attachFile2");
				input.replaceWith(input.val('').clone(true));
				frm.modYn2.value='Y';
			}
			
		}else if(obj == "s첨부파일3"){
			
			if(aFile3.value == "" && sFile3.value == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if(!confirm("삭제하시겠습니까?")){
				return;
			}else{
				sFile3.value = "";
				sFile3.style.display = 'none';
				aFile3.style.display = '';
				var input = $("#attachFile3");
				input.replaceWith(input.val('').clone(true));
				frm.modYn3.value='Y';
			}
		}
		
	}
	
	//----------------------------------------------------------------------------------------------
	//  수정시 첨부파일의 변화 감지
	//----------------------------------------------------------------------------------------------

	function fnModYn(strYn, obj){
			
			var frm = document.formdata;
			
			if (obj == 's첨부파일1'){
				frm.modYn1.value=strYn;	
			}else if (obj == 's첨부파일2'){
				frm.modYn2.value=strYn;	
			}else if (obj == 's첨부파일3'){
				frm.modYn3.value=strYn;	
			}
			
	}
	
    
    </script>
</head>

<body onload="fnStartLoad();">
<form id="formdata" name="formdata" method="post" enctype="multipart/form-data">
	<input type="hidden" name="gubun"          id="gubun"           value=""	> 
	<input type="hidden" name="inEvent" 	   id="inEvent"         value=""	>  <!-- 홍보물이벤트(신규,수정)   --> 
	<input type="hidden" name="inCompanyCd"    id="inCompanyCd"     value=""	>  <!-- 기업코드   -->  
	<input type="hidden" name="inCorpCd" 	   id="inCorpCd"        value=""	>  <!-- 법인코드   -->  
	<input type="hidden" name="inBrandCd" 	   id="inBrandCd"       value=""	>  <!-- 브랜드코드 -->
	<input type="hidden" name="inBigClass" 	   id="inBigClass"      value=""	>  <!-- 대분류코드   -->  
	<input type="hidden" name="inMidClass" 	   id="inMidClass"      value=""	>  <!-- 중분류코드   -->  
	<input type="hidden" name="inPromNo" 	   id="inPromNo"        value=""	>  <!-- 홍보물번호   --> 
	<input type="hidden" name="inPromNm"       id="inPromNm"        value=""	>  <!-- 홍보물명   -->  
	<input type="hidden" name="inPromType" 	   id="inPromType"      value=""	>  <!-- 홍보물타입   -->  
	<input type="hidden" name="inPromSize" 	   id="inPromSize"      value=""	>  <!-- 사이즈 -->
	<input type="hidden" name="inOrdCoun" 	   id="inOrdCoun"       value=""	>  <!-- 수량   -->  
	<input type="hidden" name="inOptOrdUnit"   id="inOptOrdUnit"    value=""	>  <!-- 단위   -->  
	<input type="hidden" name="inOrdPrice" 	   id="inOrdPrice"      value=""	>  <!-- 매출단가   --> 
	<input type="hidden" name="inOptPromotion" id="inOptPromotion"  value=""	>  <!-- 홍보물업체(업체코드,전화번호) --> 
	<input type="hidden" name="inFileUrl"      id="inFileUrl"       value=""	>  <!-- 이미지경로 --> 
	<input type="hidden" name="fileName1"      id="fileName1"       value=""	>  <!-- 이미지표지파일명 --> 
	<input type="hidden" name="fileName2"      id="fileName2"       value=""	>  <!-- 이미지앞면파일명 --> 
	<input type="hidden" name="fileName3"      id="fileName3"       value=""	>  <!-- 이미지뒷면파일명--> 
  	<input type="hidden" name="modYn1"  	   id="modYn1"          value=""    > <!-- 첨부파일수정여부    -->
	<input type="hidden" name="modYn2"     	   id="modYn2"          value=""    > <!-- 첨부파일수정여부    -->
	<input type="hidden" name="modYn3"     	   id="modYn3"          value=""    > <!-- 첨부파일수정여부    -->
	
	<input type="hidden" name="sDate"  		   id="sDate"          value="<%=StartDate %>"	> 
	<input type="hidden" name="eDate"  		   id="eDate"          value="<%=EndDate%>"		>  
	
	<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>
	
	
	
 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("<%=root%>/include/admin-header.jsp"); </script> 
	 	</section> 
	 	
 		<section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>홍보물 관리 &gt; 홍보물 상세 관리 &gt; 신규 등록</span></h1>
 		 	</header>
 		 	
 		 	<div id="cont-admin">
 		 		<div class="cont-nav">
 		 			<ul class="admin-menu">
 		 				<li ><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=01">공지사항관리</a></li>
 		 				<li ><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=02">교육자료관리</a></li>
 		 				<li ><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=11">건의사항관리</a></li>
 		 				<li ><a href="<%=root%>/admin-page/admin-main.jsp?pageGb=12">요청사항관리</a></li>
 		 				<li ><a href="<%=root%>/admin-page/maintain-faq.jsp?pageGb=faq">FAQ관리</a></li>
 		 				<li ><a href="<%=root%>/admin-page/maintain-comment.jsp?pageGb=comment">댓글관리</a></li>
 		 				<li ><a href="<%=root%>/prom_mnt/maintain-prom-cd.jsp?pageGb=prom">홍보물관리</a>
 		 					<ul class="submenu">
								<li><a href="<%=root%>/prom_mnt/maintain-prom-cd.jsp?pageGb=prom">홍보물코드관리</a></li>
								<li><a href="<%=root%>/prom_mnt/maintain-prom-dtl.jsp?pageGb=prom">홍보물상세관리</a></li>
								<li><a href="<%=root%>/prom_mnt/maintain-prom-ord-list.jsp?pageGb=prom">주문내역확인</a></li>
							</ul>
 		 				</li>
 		 			</ul>
 		 		</div>

 		 		<div id="" class="list-wide ad-tbl">
				  		<table width="920">
				  		<%if(inEvent.equals("mod")){ %>
				  			<caption>▶ 홍보물 정보 수정</caption>
				  		<%} else{ %>	
				  			<caption>▶ 홍보물 정보 입력</caption>
				  		<% }%>
				  			<colgroup>
					  			<col width="120" >
					  			<col width="180" >
					  			<col width="120" >
					  			<col width="180" >
					  			<col width="120" >
					  			<col width="200" >
				  			</colgroup>
				    		<thead>
				    			<tr>
				      				<th>법인명</th>
				        			<td colspan="2" class="txt-left">
				        				<input type="hidden" name="opt-group"      id="opt-group"      value="<%=sOptGroup%>" >
				        				<select id="opt-corp" name="opt-corp" onchange="chgGroup(this.value);">
				        					<option value="%">선택</option>
				        		<%  if(comboList1 !=null && comboList1.size() > 0){
				    					for(int i=0; i<comboList1.size(); i++){
				    						promMntBean = (promMntBean) comboList1.get(i);
				    			%>	
		    								<option value="<%=promMntBean.get법인코드()%>"<% if(promMntBean.get법인코드().equals(sOptCorp)){%> selected = "selected" <%}else{}%>><%=promMntBean.get법인명() %></option>
		    					<% 		
				      				}
				    			} %>
				        					<!-- option -->
				        				</select>	
									</td>
									<th>브랜드명</th>			        			
				        			<td colspan="2" class="txt-left">
				        				<select id="opt-brand" name="opt-brand" onchange="chgLargeList();">
							    			<option value="%">선택</option>
							    <%  if(comboList2 !=null && comboList2.size() > 0){
						    			for(int i=0; i<comboList2.size(); i++){
						    				promMntBean = (promMntBean) comboList2.get(i);
						    	%>
				    						<option value="<%=promMntBean.get브랜드코드()%>" <% if(promMntBean.get브랜드코드().equals(sOptBrand)){%> selected = "selected" <%}else{}%>><%=promMntBean.get브랜드명() %></option>
				    			<% 		
						      		}
						    	} %>
							    			<!-- option -->
							    		</select>
			    					</td>
				      			</tr>
				    			<tr>
				      				<th>대분류명</th>
				        			<td class="txt-left">
							    		<select id="opt-bigClass" name="opt-bigClass" onchange='fnViewMiddleCd(this.value)'>
							    			<option value="%">선택</option>
							    <%  if(comboPromList !=null && comboPromList.size() > 0){
							    		for(int i=0; i<comboPromList.size(); i++){
							    			promMntBean = (promMntBean) comboPromList.get(i);
							    %>
					    					<option value="<%=promMntBean.get메뉴코드()%>" <% if(promMntBean.get메뉴코드().equals(sOptBigClass)){%> selected = "selected" <%}else{}%>><%=promMntBean.get메뉴코드명() %></option>
					    				
					    		<% 		
							      	}
							    } %>
							    			<!-- option -->
							    		</select>
			    					</td>
				        			<th>중분류명</th>
				        			<td class="txt-left">
							    		<select id="opt-midClass" name="opt-midClass" onchange="fnPromNo(this.value);">
							    			<option value="%">선택</option>
							    <%  if(comboPromMiddleList !=null && comboPromMiddleList.size() > 0){
							    		for(int i=0; i<comboPromMiddleList.size(); i++){
							    			promMntBean = (promMntBean) comboPromMiddleList.get(i);
							    %>	
					    					<option value="<%=promMntBean.get메뉴코드()%>" <% if(promMntBean.get메뉴코드().equals(sOptMidClass)){%> selected = "selected" <%}else{}%>><%=promMntBean.get메뉴코드명() %></option>
					    			
					    		<% 		
							      	}
							    } %>
							    			<!-- option -->
							    		</select>
									</td>
				      				<th>홍보물번호</th>
				        			<td >
				        				<span id="promNo" name="promNo"><%=sPromNo%></span>
				        				<input type="hidden" name="opt-promNo" id="opt-promNo" value="<%=sPromNo%>" >
				        				
				        			</td>
				      			</tr>
				    			<tr>
				      				<th>홍보물명</th>
				        			<td><input type="text" id="promNm" name ="promNm" value="<%=sPromNm%>"></td>
				        			<th>홍보물타입</th>
				        			<td>
				        				<select id="opt-prom-type" name="opt-prom-type">
				        						<!-- option -->
				        				</select>
				        			</td>
				      				<th>규격</th>
				        			<td><input type='text' id='promSize' name='promSize' value="<%=sPromSize%>"></td>
				      			</tr>
				    			<tr>
				      				<th>주문단위</th>
				        			<td>
				        				<input type='text' id="ord-count" name="ord-count" value="<%=sOrdCoun%>" size="8" maxlength="12" onkeyup="this.value=onlyNumber(this.value);">&nbsp;&nbsp;&nbsp;
				        				<select id="opt-ord-unit" name="opt-ord-unit">
				        					<!-- option -->
				        				</select>
				        				
				        			</td>
				        			<th>단가</th>
				        			<td><input type='text' id="ord-price" name ="ord-price" value="<%=sOrdPrice%>" onkeyup="this.value=onlyNumber(this.value);"></td>
				      				<th>제작업체</th>
				        			<td >
				        				<select id="opt-promotion" name="opt-promotion">
				        					<!-- option -->
				        				</select>
				        			</td>
				      			</tr>
				    		</thead>
			    		</table>
			    		
				  		<table width="920">  
				  			<caption>▶ 홍보물 정보 추가 입력</caption>
				    		<tbody>
				    		<tr>
			      				<th>표지 이미지</th>
		        				<td width="800">
		        					<div id="fileDiv1" >
		        					
		        						<%
		        						if ("".equals(fileName1)){
		        						%>
		        							<span style="position:absolute; style:none;" id="s첨부파일1" ></span>
		        							<input type="file" class="file" id="attachFile1" name="attachFile1" onchange="fnChgFname(this); if(checkFileSize(this,2)) {fnModYn('Y','s첨부파일1');} else {fnModYn('N','s첨부파일1');};" value=""/>&nbsp;
		        							<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnDeleteFile('s첨부파일1');"></button> <!-- 글 삭제 -->
		        						<%	
		        						}else{
		        						%>
			        						<span style="position:absolute;" id="s첨부파일1" ></span>
			        						<input style="display: none" type="file" class="file" id="attachFile1" name="attachFile1" onchange="fnChgFname(this); if(checkFileSize(this,2)) {fnModYn('Y','s첨부파일1');} else {fnModYn('N','s첨부파일1');};" value=""/>&nbsp;
			        						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnIniFile('s첨부파일1');"></button> <!-- 글 삭제 -->
		        						<%
		        						}
		        						%>
		        							
		        					</div>
		        				</td>
		        			</tr>
			      			<tr>
			      				<th>앞면 이미지</th>
		      					<td width="800">
		      						<div id="fileDiv2">
		      						
		      							<%
		        						if ("".equals(fileName2)){
		        						%>
		        							<span style="position:absolute; style:none;" id="s첨부파일2" ></span>
		        							<input type="file" class="file" id="attachFile2" name="attachFile2" onchange="fnChgFname(this); if(checkFileSize(this,2)) {fnModYn('Y','s첨부파일2');} else {fnModYn('N','s첨부파일2');};" value=""/>&nbsp;
		        							<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnDeleteFile('s첨부파일2');"></button> <!-- 글 삭제 -->
		        						<%	
		        						}else{
		        						%>
			        						<span style="position:absolute;" id="s첨부파일2" ></span>
			        						<input style="display: none" type="file" class="file" id="attachFile2" name="attachFile2" onchange="fnChgFname(this); if(checkFileSize(this,2)) {fnModYn('Y','s첨부파일2');} else {fnModYn('N','s첨부파일2');};" value=""/>&nbsp;
			        						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnIniFile('s첨부파일2');"></button> <!-- 글 삭제 -->
		        						<%
		        						}
		        						%>
		      						
		      						</div>
		      					</td>
		        			</tr>
			      			<tr>
			      				<th>뒷면이미지</th>
			      				<td>
			      					<div id="fileDiv3">
			      					
			      						<%
	        						if ("".equals(fileName3)){
	        						%>
	        							<span style="position:absolute; style:none;" id="s첨부파일3" ></span>
	        							<input type="file" class="file" id="attachFile3" name="attachFile3" onchange="fnChgFname(this); if(checkFileSize(this,2)) {fnModYn('Y','s첨부파일3');} else {fnModYn('N','s첨부파일3');};" value=""/>&nbsp;
	        							<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnDeleteFile('s첨부파일3');"></button> <!-- 글 삭제 -->
	        						<%	
	        						}else{
	        						%>
		        						<span style="position:absolute;" id="s첨부파일3" ></span>
		        						<input style="display: none" type="file" class="file" id="attachFile3" name="attachFile3" onchange="fnChgFname(this); if(checkFileSize(this,2)) {fnModYn('Y','s첨부파일3');} else {fnModYn('N','s첨부파일3');};" value=""/>&nbsp;
		        						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnIniFile('s첨부파일3');"></button> <!-- 글 삭제 -->
	        						<%
	        						}
	        						%>
	        						
			      					</div>
			      				</td>
		        			</tr>
				      		</tbody>
			    		</table>
			    		
			 		<p class="btn">
			 			<button type="button" class="golistBtn" onclick="goList();">목록</button>
			 			<button type="button" class="saveBtn" onclick="goRegist();">저장</button>
			 		</p>
 		 		</div>
 		 	</div><!-- end of cont-admin -->
 		 	
 		</section>
 	

	 	<div class="overlay-bg">
	 		<img id="loadingImage" src="http://i1.daumcdn.net/cfs.tistory/resource/315/blog/plugins/lightbox/images/loading.gif" style="position: relative; cursor: pointer; top: 340px; left: 477px;display: none; ">
	 	</div>
 	</div><!-- wrap end -->

</form>
</body>
</html>