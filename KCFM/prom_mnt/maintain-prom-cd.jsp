<%
/** ############################################################### */
/** Program ID   : maintain-material-code.jsp                       */
/** Program Name : maintain-material-code	       					*/
/** Program Desc : 관리자-홍보물코드관리							    */
/** Create Date  : 2015.04.28					              		*/
/** Update Date  :                                                  */
/** Programmer   :                                          		*/
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>  

<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="com.util.BoardConstant" %>

<%@ page import="prom_mnt.beans.promBean" %> 
<%@ page import="prom_mnt.dao.promDao" %>

<%@ page import="admin.beans.storeBean" %> 
<%@ page import="admin.dao.storeDao" %>


<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /prom_mnt/maintain-prom-cd.jsp");
	
	promBean bean = null; //리스트 목록용
	promDao  dao  = new promDao();
	ArrayList<promBean> list = null;

	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb")   , "prom");

	String sseCustAuth  = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth" ),""); //권한코드
    String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
    String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
    
    //선택항목 SELECT BOX 
  	String sel_CorpCd  = JSPUtil.chkNull((String)paramData.get("sel_CorpCd"), ""  ); //법인   SELECT BOX
  	String sel_BrandCd = JSPUtil.chkNull((String)paramData.get("sel_BrandCd"), "" ); //브랜드 SELECT BOX
    
	
	String middleCompanyCd = "";
	String middleCorpCd    = "";
	String middleBrandCd   = "";
	String middleCd        = "";    //중분류코드
	String middleNm        = "";    //대분류명
	String parentCd        = "";    //상위메뉴코드
	String middleMsg       = "";    //등록결과
	String[] cdMiddleList  = null;
	String[] nmMiddleList  = null;
	int rtnNum = 0;
	
	String checkCRUD = (String)paramData.get("inCheckCRUD");
	
	
	//---------------------------------------[중분류 저장]-----------------------------------------------
	
	//중분류코드 추가 저장
	//값이 있을 때만 저장
	if("1".equals(checkCRUD)){
		
		 try{
	        	
			//middleCompanyCd = (String)session.getAttribute("sseGroupCd");
			middleCompanyCd = (String)paramData.get("inCompanyCd"   );
			middleCorpCd    = (String)paramData.get("inCorpCd"      );
			middleBrandCd   = (String)paramData.get("inBrandCd"     );
			middleCd        = (String)paramData.get("inMiddleMenuCd");
			middleNm        = (String)paramData.get("inMiddleMenuNm");
			parentCd        = (String)paramData.get("inMenuCd"      ); //상위메뉴코드
			
			if(middleCd != null){
				for(int i=0;i<middleCd.split(",").length;i++){
					cdMiddleList = middleCd.split(",");
					nmMiddleList = middleNm.split(",");
					
					paramData.put("groupCd" , middleCompanyCd);                             //기업코드 
					paramData.put("corpCd"  , middleCorpCd);                                //법인코드 
					paramData.put("brandCd" , middleBrandCd);                               //브랜드코드
					paramData.put("custId"  , session.getAttribute("sseCustId"));           //사용자ID
					paramData.put("parentCd", parentCd);                                    //상위메뉴코드
					paramData.put("menuCd"  , URLDecoder.decode(cdMiddleList[i],"UTF-8"));  //메뉴코드
					paramData.put("menuNm"  , URLDecoder.decode(nmMiddleList[i],"UTF-8"));  //메뉴명
					
					rtnNum = dao.addMiddleCd(paramData);
				}
				
				if(rtnNum == 1){
					middleMsg = "코드가 저장되었습니다.";
				}
				
			}
				
		
		 }catch(Exception e){
			 middleMsg = "코드저장에 실패 했습니다.!";
	 	}
	}
	//---------------------------------------[중분류 저장]-----------------------------------------------
	
	//---------------------------------------[중분류 삭제]-----------------------------------------------
	if("2".equals(checkCRUD)){
		
		try{
			
			middleCompanyCd = (String)paramData.get("inCompanyCd"   );
			middleCorpCd    = (String)paramData.get("inCorpCd"      );    //법인코드
			middleBrandCd   = (String)paramData.get("inBrandCd"     );    //브랜드코드
			middleCd        = (String)paramData.get("inMiddleMenuCd");    //메뉴코드
			
			if(middleCd != null){
				for(int i=0;i<middleCd.split(",").length;i++){
					cdMiddleList = middleCd.split(",");
					
					paramData.put("groupCd" , middleCompanyCd);                             //기업코드 
					paramData.put("corpCd"  , middleCorpCd);                                //법인코드 
					paramData.put("brandCd" , middleBrandCd);                               //브랜드코드
					paramData.put("menuCd"  , URLDecoder.decode(cdMiddleList[i],"UTF-8"));  //메뉴코드
					
					rtnNum = dao.delMiddleCd(paramData);
				}
				
				if(rtnNum == 1){
					middleMsg = "코드를 삭제 하였습니다.";
				}
				
			}
			
		}catch(Exception e){
			middleMsg = "코드삭제 실패하였습니다.!.";
		}
	}
	//---------------------------------------[중분류 삭제]-----------------------------------------------
	//######################################################관리자 메뉴 pageGb에 따라 active 상태
	String active1 = pageGb.equals("01")      ? "active" : ""; //공지사항
	String active2 = pageGb.equals("02")      ? "active" : ""; //교육자료
	String active3 = pageGb.equals("11")      ? "active" : ""; //건의사항
	String active4 = pageGb.equals("12")      ? "active" : ""; //요청사항
	String active5 = pageGb.equals("faq")     ? "active" : ""; //FAQ
	String active6 = pageGb.equals("comment") ? "active" : ""; //댓글
	String active7 = pageGb.equals("prom")    ? "active" : ""; //홍보물
	//######################################################

%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌더링 -->
 	<meta name="keywords" content="" /> <!-- 검색용 키워드 -->
 	<meta name="description" content="스쿨푸드 PRM 서비스입니다." /><!-- 페이지 설명 -->
	
	<link href="<%=root%>/assets/css/common.css" rel="stylesheet" type="text/css" />
	<link href="<%=root%>/assets/css/style.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="http://code.jquery.com/ui/1.9.2/themes/base/jquery-ui.css" />
	
	<!-- IE8 이하에서 미디어 쿼리(Media Query) 사용 지원 -->
	<!--[if lt IE 9]><script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
    <!-- IE 8 이하에서 HTML5 태그 지원하도록 스크립트 링크-->
    <!-- 참고 글 : http://www.cmsfactory.net/node -->
    <!--[if lt IE 9]><script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script><![endif]-->
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
	<script type="text/javascript" src="http://code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
	<script type="text/javascript" src="<%=root%>/assets/js/jquery.ui.datepicker-ko.js"></script>
	<script type="text/javascript" src="<%=root%>/assets/js/calendar.js"></script>
    <script type="text/javascript" src="<%=root%>/assets/js/style.js"></script>
    <script type="text/javascript" src="<%=root%>/assets/js/common.js"></script>

	<title>KCFM 관리자</title>  
    
    <script type="text/javascript">
	$(document).ready(function()
	{ 
		getCurrent();
		fnCalendar();
        
	});
	

	//새로고침 했을 때 저장,수정이 계속 발생되어 페이지 이동시킴
	document.onkeydown = function(e){
		try{
			var code = (e.which) ? e.which : event.keyCode;
	 		if (code === 116) { //F5
	            	code = 0;
	                window.location.replace("<%=root%>/prom_mnt/maintain-prom-cd.jsp?pageGb=prom");
	            return false;
	        } else if (code === 82 && e.ctrlKey) { //Ctrl + R
	            return false;
	        }
		}catch(e){
			
		}
	};
 	
	window.onload = function(){
		
       //중분류 저장,수정, 삭제 메세지
       if( ("<%=checkCRUD%>" == "1" || "<%=checkCRUD%>" == "2") && "<%=middleMsg%>" != ""){ 
 			alert("<%=middleMsg%>");	  		
 	   }	       
		
	    chgGroup();                        //법인코드 조회
	    
	};
	
	
	//대분류 선택, 중분류 보기
	//기업코드, 법인코드, 브랜드코드, 메뉴코드
	function fnViewMiddleCd(companyCd, corpCd, brandCd, menuCd ){
		
		document.getElementById("inCompanyCd").value = companyCd;
	    document.getElementById("inCorpCd"   ).value = corpCd;
    	document.getElementById("inBrandCd"  ).value = brandCd;
   		document.getElementById("inMenuCd"   ).value = menuCd;
		
   		$("#gubun").attr("value", "middle");
   		
   		$("#middleTable > tbody > tr").remove();
   		
		$.ajax(
			{
				url      : "<%=root%>/prom_mnt/listView.jsp",
				type     : "POST",
				data     : $("#form1").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
							  $("#middleTable > tbody").append( trim(data) );
				           }
			});
	}
	    

    function trim(s) 
    {
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }
    
    
    
    //------[중분류 관련 function]----------------------
    
    //중분류 코드 변경되면 체크박스 선택
    function fnMiddleCdCheck(obj){
     	$("input[name=middleMenuCd]").each(function(i){
    		if(this == obj){
    			$("input[name=middleChk]")[i].checked = true;
    		}
    	});
    }
    
    //중분류 명 변경되면 체크박스 선택
    function fnMiddleNmCheck(obj){
     	$("input[name=middleMenuNm]").each(function(i){
    		if(this == obj){
    			$("input[name=middleChk]")[i].checked = true;
    		}
    	});
    }
    
    //중분류 Row추가
    function fnMiddleAddRow(){
    	var html = "";
    	
    	html += "<tr>";
		html += "<td width='30' ><input type='checkbox' name='middleChk' checked='checked'></td>"; 
		html += "<td width='130'><input type='text' name='middleMenuCd' style='width: 120px;'></td>"; 
		html += "<td width='210'><input type='text' name='middleMenuNm' style='width: 200px;'></td>";
	    html += "</tr>";
    			
	    $('#middleTable > tbody').append(html);    
	    
	    //추가된 항목에 포커스 주기
	    $('input[name=middleMenuCd]').eq( $('input[name=middleMenuCd]').length-1 ).focus();
	    
    }
    
    //중분류 저장
    function fnMiddleSaveRow(){
		var cdList = "";
		var nmList = "";
		var chkFlag = true;
		var chkBox  = false;
		
		var cd = $("input[name=middleMenuCd]");
		var nm = $("input[name=middleMenuNm]");
		
		//선택항목 확인
		$('input[name=middleChk]').each(function(i){ 
   	        if(this.checked == true){
   	        	chkBox = true;
   	        }
    	});
		
		if(chkBox == false){
			alert("저장할 중분류를 선택해 주십시오.!");
			return false;
		}
		
		//Null값 검사
		$('input[name=middleMenuCd]').each(function(i) { 
   	        if(this.value == ""){
   	        	alert("중분류코드를 입력해주십시오.!");
   	        	cdList = "";
   	        	chkFlag = false;	
   	        }
   	     });
				
		 $('input[name=middleMenuNm]').each(function(i) {
  	        if(this.value == ""){
  	        	alert("대분류명을 입력해주십시오.!");
  	        	nmList = "";
  	        	chkFlag = false;
  	        }
  	     });
		 
		//체크박스 선택된것만 배열로 생성
    	$('input[name=middleChk]').each(function(i){ 
   	        if(this.checked == true){
   	        	cdList += cd[i].value + ",";
   	        	nmList += nm[i].value + ",";
   	        }
    	});
    	
		
    	if(chkFlag && chkBox){
  		  	document.getElementById("inMiddleMenuCd").value = encodeURI(cdList);
  		  	document.getElementById("inMiddleMenuNm").value = encodeURI(nmList);
  		    document.getElementById("inCheckCRUD"   ).value = "1"; //저장,수정
  		  
  		  	document.form1.submit();
      	}
    
    }
    
    //홍보물 중분류코드 삭제
    function fnMiddleDelRow(){
    	var cdList = "";
		var nmList = "";
		var chkBox = false;
		
		var cd = $("input[name=middleMenuCd]");
		
		if(confirm("중분류 코드를 삭제 하시겠습니까?")){
			
			$('input[name=middleChk]').each(function(i){ 
	   	        if(this.checked == true){
	   	        	chkBox = true;
	   	        }
	    	});
			
			if(chkBox == false){
				alert("삭제할 중분류코드를 선택해 주십시오.!");
				return false;
			}
		
	    	//체크박스 선택된것만 배열로 생성
	    	if(chkBox == true){
		    	$('input[name=middleChk]').each(function(i){ 
		   	        if(this.checked == true){
		   	        	cdList += cd[i].value + ",";
		   	        }
		    	});    	
		    	
		 	  	document.getElementById("inMiddleMenuCd").value = encodeURI(cdList);
		  	    document.getElementById("inCheckCRUD"   ).value = "2"; //삭제
		  	  
		  	  	document.form1.submit();
	    	}
	  	    
		}
  	    
    }
    //------[중분류 관련 function]----------------------
    
    
    //법인 select box list 조회
    function chgGroup(){
    	
    	$("#inCompanyCd").attr("value","<%=sseGroupCd%>"); //기업코드
    	$("#hSelectGubun").attr("value", "corp");          //selectbox 조회 구분값
    	
		$.ajax(
			{
				url      : "<%=root%>/prom_mnt/changeCd.jsp",
				type     : "POST",
				data     : $("#form1").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#sel_CorpCd option").remove();
								$("#sel_CorpCd").append(trim(data));
								
								chgCorp( $("#sel_CorpCd").val() );
				           }
			});
		
		
    }
    
    
    //법인 selectbox 선택 때 브랜드코드 조회
    function chgCorp(val){
    	
    	$("#inCompanyCd").attr("value","<%=sseGroupCd%>"); //기업코드
    	$("#inCorpCd").attr("value", val);                 //법인코드
    	$("#hSelectGubun").attr("value", "brand");         //selectbox 조회 구분값
    	
    	var selGroupCd = "";
    	var selCorpCd  = "";
    	
    	//권한이 90일때 초기 기업코드가 없어서 법인코드 조회 할때 같이 갖고옴
    	if("<%=sseCustAuth%>" == "90"){
    		selGroupCd = val.split("-")[1];
    		selCorpCd  = val.split("-")[0];
    		$("#inCompanyCd").attr("value", selGroupCd); //기업코드
    		$("#inCorpCd"   ).attr("value", selCorpCd);   //법인코드
    	}
    	
		$.ajax(
			{
				url      : "<%=root%>/prom_mnt/changeCd.jsp",
				type     : "POST",
				data     : $("#form1").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#sel_BrandCd option").remove();
								$("#sel_BrandCd").append(trim(data));
								
								chgLargeList(); //대분류 리스트 조회
				           }
			});
    }
    
    //대분류 리스트 조회
    function chgLargeList(){
    	
    	$("#gubun").attr("value","large");
    	$("#inCompanyCd").attr("value", "<%=sseGroupCd%>");
    	$("#inCorpCd").attr("value", document.getElementById("sel_CorpCd").value);
    	$("#inBrandCd").attr("value",document.getElementById("sel_BrandCd").value);
    	
    	//권한이 90일때 초기 기업코드가 없어서 법인코드 조회 할때 같이 갖고옴
    	var selGroupCd = "";
    	var selCorpCd  = "";
    	if("<%=sseCustAuth%>" == "90"){
    		selGroupCd = (document.getElementById("sel_CorpCd").value).split("-")[1];
    		selCorpCd  = (document.getElementById("sel_CorpCd").value).split("-")[0];
    		
    		$("#inCompanyCd").attr("value", selGroupCd); //기업코드
    		$("#inCorpCd"   ).attr("value", selCorpCd);   //법인코드
    	}
    	
    	
    	$("#largeTable > tbody > tr").remove();
    	
    	$.ajax({
    				url      : "<%=root%>/prom_mnt/listView.jsp",
    				type     : "POST",
    				data     : $("#form1").serialize(),
    				dataType : "html", 
    				success  : function(data)
    						   {  
    					
    								$("#largeTable > tbody").append( trim(data) );
    								    				
    								//중분류 코드 조회
    								fnViewMiddleCd( $("#inCompanyCd").val(), $("#inCorpCd").val(), $("#inBrandCd").val(), $("#largeTable > tbody .lblLargeMenuCd:first").text());
    				           }
    			});
    }
   
    
    </script>
</head>

<body>
<form id="form1" name="form1" method="post">
	<input type="hidden" name="gubun"          id="gubun"          value=""		                > 
	<input type="hidden" name="inCompanyCd"    id="inCompanyCd"    value=""		                >  <!-- 기업코드   -->  
	<input type="hidden" name="inCorpCd" 	   id="inCorpCd"       value=""	                  	>  <!-- 법인코드   -->  
	<input type="hidden" name="inBrandCd" 	   id="inBrandCd"      value=""	                  	>  <!-- 브랜드코드 -->
	<input type="hidden" name="inMenuCd" 	   id="inMenuCd"       value=""		                >  <!-- 메뉴코드   -->  

    <!-- 중분류 저장용 -->	
    <input type="hidden" name="inCheckCRUD"     id="inCheckCRUD"    value="0"                   >  <!-- 저장,수정 확인 -->
	<input type="hidden" name="inMiddleMenuCd"  id="inMiddleMenuCd" value=""		            >  <!-- 중분류 코드 -->  
	<input type="hidden" name="inMiddleMenuNm"  id="inMiddleMenuNm" value=""		            >  <!-- 중분류 명   -->   
	
	<input type="hidden" name="hSelectGubun"    id="hSelectGubun"   value=""		            >  <!-- select box 조회 구분   -->

 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("../include/admin-header.jsp"); </script> 
	 	</section> 
	 	
 		  <section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>administrator service &gt; 홍보물 코드 관리</span></h1>
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
 		 				<li class="<%=active7%>"><a href="<%=root%>/prom_mnt/maintain-prom-cd.jsp?pageGb=prom">홍보물관리</a>
 		 					<ul class="submenu">
								<li><a href="<%=root%>/prom_mnt/maintain-prom-cd.jsp?pageGb=prom">홍보물코드관리</a></li>
								<li><a href="<%=root%>/prom_mnt/maintain-prom-dtl.jsp?pageGb=prom">홍보물상세관리</a></li>
								<li><a href="<%=root%>/prom_mnt/maintain-prom-ord-list.jsp?pageGb=prom">주문내역확인</a></li>
							</ul>
 		 				</li>
 		 			</ul>
 		 		</div>
 		 		<!-- <img alt="ex" src="assets/images/admin-ex.png" width="960" height="500" align="middle"> -->
 		 		
 		 		
		        	<div class="admin-search-o" style="width:525px; ">
<!-- 	        			<label for="opt-corp" > ▶ 법인 : </label> -->
<!-- 						<span id="opt-corp" >&nbsp;</span>&nbsp;&nbsp;&nbsp; -->
<!-- 						<label for="opt-brand" > ▶ 브랜드 : </label> -->
<!-- 						<span id="opt-brand" >&nbsp;</span>&nbsp;&nbsp;&nbsp; -->

						<label for="sel_CorpCd" > ▶ 법인 : </label>
			    		<select id="sel_CorpCd" name="sel_CorpCd" onchange="chgCorp(this.value);" class="con">
			    			<!-- option -->
			    		</select>
			    		<label for="sel_BrandCd" > ▶ 브랜드 : </label>
			    		<select id="sel_BrandCd" name="sel_BrandCd" onchange="chgLargeList();" class="con">
			    			<!-- option -->
			    		</select>
		        				    		
			    		<!-- 중분류코드 기능 버튼 -->
			    		<button class="addBtn"    onclick="fnMiddleAddRow();  return false;">추가</button>			    		
			    		<button class="saveBtn"   onclick="fnMiddleSaveRow(); return false;">저장</button>
			    		<button class="deleteBtn" onclick="fnMiddleDelRow();  return false;">삭제</button>
			  		</div>
			  		
 		 		<div class="list-wide ad-tbl"   >
				  		<table class="scroll-y" style="margin-right: 10px;"  id="largeTable">
				    		<thead>
				    			<tr>
				      				<th width="110" >법인명</th>
				        			<th width="110" >브랜드명</th>
				        			<th width="120" >대분류코드</th>
				        			<th width="120" >대분류명</th>
				      			</tr>
				    		</thead>
				    		<tbody>
	               				<!-- 대분류리스트 -->
				      		</tbody>
			    		</table>
			    		<table class="scroll-y" style="margin-left:10px; " id="middleTable">
				    		<thead>
				    			<tr>
				      				<th width="30"  >선택</th>
				        			<th width="130" >중분류코드</th>
				        			<th width="210" >중분류명</th>
				      			</tr>
				    		</thead>
				    		<tbody style="overflow-y: scroll">
				    			<!-- 중분류리스트 -->
				      		</tbody>
			    		</table>
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