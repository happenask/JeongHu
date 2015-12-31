<%
/** ############################################################### */
/** Program ID   : searchAddress.jsp                                */
/** Program Name : 주소찾기                                         */
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
<%@ page import="com.util.BoardConstant" %>

<%

	String root = request.getContextPath();

	

%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" /> <!-- 문서모드 IE9 표준 호환 / content="IE=edge" 최신으로 렌덩링-->
 	<meta name="keywords" content="" /><!-- 검색용 키워드 -->
 	<meta name="description" content="스쿨푸드 PRM 서비스입니다." /><!-- 페이지 설명 -->
	<title>주소찾기</title>  
	
	<link href="<%=root%>/assets/css/common.css" rel="stylesheet" type="text/css" />
	<!-- IE8 이하에서 미디어 쿼리(Media Query) 사용 지원 -->
	<!--[if lt IE 9]><script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
    <!-- IE 8 이하에서 HTML5 태그 지원하도록 스크립트 링크 -->
    <!-- 참고 글 : http://www.cmsfactory.net/node -->
    <!--[if lt IE 9]><script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script><![endif]-->
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="<%=root%>/assets/js/style.js"></script>
     
    <script type="text/javascript">
     
	function fnPressEnter(){
	
	    if (event.keyCode == 13) //enter
	    {
	        goNextStep();
	    }
	}

   function goNextStep() {
       var searchWord = "";
       searchWord = document.getElementById("search_word").value;

       if (searchWord.toString().length < 2) {
           alert("검색어는 최소 2글자 이상 입력해 주세요.");
           searchWord.focus();
           return;
       }

       if (searchWord.toString().length > 100) {
           alert("입력하신 검색어가 너무 깁니다. 다시 입력해 주세요.");
           searchWord.value = "";
           searchWord.focus();
           return;
       }
       
       var step01 = document.getElementById("step01");
       var step02 = document.getElementById("step02");
       
       //주소 검사
       $.ajax(
    			{
    				url      : "<%=root%>/address/searchAddressPopSearch.jsp",
    				type     : "POST",
    				data     : $("#frm").serialize(),
    				dataType : "html", 
    				success  : function(data)
    						   {  
    					
    							   step01.style.display = "none";
    							   step02.style.display = "block";
    							   step02.innerHTML     = data;
    				           }
    			});
       
   	document.getElementById("back").style.display = "block";
   	document.getElementById("backNum").value = "2";
   	
    }
   
   	
	function fnBack(){
		var step01 = document.getElementById("step01");
		var step02 = document.getElementById("step02");
		var step03 = document.getElementById("step03");
		
		var btn_input = document.getElementById("addr_input");
		var btn_back  = document.getElementById("back");
		
		var num    = document.getElementById("backNum");
		
		if(num.value == "2"){
			//2단계에서 -> 1단계로
			step01.style.display = "block";
			step02.style.display = "none";
			step03.style.display = "none";
			
			btn_input.style.display = "none";
			btn_back.style.display  = "none";
			
			num.value = "1";
		}else if(num.value == "3"){
			//3단계에서 -> 2단계로
			step01.style.display = "none";
			step02.style.display = "block";
			step03.style.display = "none";
			
			btn_input.style.display = "none";
			
			num.value = "2";
		}

		//상세 주소를 이미 입력한 경우 입력창 초기화
	   	document.getElementById("addr2").value = "";
	}
	
	function goDetailStep(zip1, zip2, addr1){
		document.getElementById("backNum").value = "3";
		
		document.getElementById("step02").style.display = "none";
		document.getElementById("step03").style.display = "block";
		
		document.getElementById("zip_1").value = zip1;
		document.getElementById("zip_2").value = zip2;
		document.getElementById("addr1").value = addr1;
		
		
		var btn_input = document.getElementById("addr_input");
		btn_input.style.display = "block";
		
	}
	
	/*
	// 호출한 부모창에서 처리!!
	function fnInputAddr(){
		var addr2 = document.getElementById("addr2");
		
		if (addr2.value == "") {
			alert("상세주소를 입력해 주세요!");
			addr2.focus();
			return;
		}
		
		
		opener.document.getElementById("order_zip_1" ).value = document.getElementById("zip_1").value;
		opener.document.getElementById("order_zip_2" ).value = document.getElementById("zip_2").value;
		opener.document.getElementById("order_base"  ).value = document.getElementById("addr1").value;
		opener.document.getElementById("order_detail").value = document.getElementById("addr2").value;
		
		window.close();
		
	} */
    </script>
</head>

<body>
		<form id="frm" name="frm" method="post">
		
			<input type="hidden" id="hid_zip1" value="" ><br> <!-- 우편번호1 -->
			<input type="hidden" id="hid_zip2" value="" ><br> <!-- 우편번호2 -->
			<input type="hidden" id="hid_front_address" value="" ><br><!-- 기본주소 -->
			<input type="hidden" id="hid_back_address" value="" ><br> <!-- 상세주소 -->
			<input type="hidden" id="backNum" name="backNum" value="1" ><br> <!-- 뒤로가기 구분값 -->
 
			<div id="step01" class="seach-step">
			    <p class="bold">찾고자 하는 주소의 동(읍/면)명을 입력하신 후 검색을 누르세요.<br><span>예) 서울시 강동구 둔촌2동 이라면, ‘둔촌2’ 혹은 ‘둔촌2동’으로 입력해 주세요</span></p>
				<div class="zipcode_sch">
					<label for="search_word">검색어 입력</label>
					<input type="text" class="txt" name="search_word" id="search_word" value="" onkeydown="javascript:fnPressEnter();" />
					<a href="javascript:goNextStep();" class="grayBtn">검색</a>
				</div>
			</div>
			
			<div id="step02" class="seach-step">
			<!-- 검색된 주소 표시 -->
				<p class="bold">주소를 선택 해 주세요!</p>
			</div>
			
			<div id="step03"  class="seach-step">
				<!-- 상세 주소 입력 -->
				<table>
					<tr>
						<td>
							<input type="text"   id="zip_1"      name="zip_1"       value=""   maxlength="3"  readonly="readonly"  style="width: 50px;"/> - <!-- 우편번호1 -->
							<input type="text"   id="zip_2"      name="zip_2"       value=""   maxlength="3"  readonly="readonly"  style="width: 50px;"/>
						</td>
					</tr>
					<tr>
						<td>
							<input type="text"   id="addr1"      name="addr1"       value=""   readonly="readonly" class="addr-dtl"/>
						</td>
					</tr>
					<tr><td></td></tr>
					<tr>
						<td>
							<p class="bold">▼ 상세 주소를 입력하신 후 '확인' 버튼을 눌러주세요.</p>
							<input type="text"   id="addr2"      name="addr2"       value=""   class="addr-dtl"/>
							<span style=" float:right; margin: 0px 15px;"><a href="javascript:fnInputAddr();"  id="addr_input" class="hidden redBtn">확 인</a></span>
						</td>
					</tr>
				</table>
			</div>
		</form>	
	 
		<div class="btns">
			<a href="javascript:fnBack()"  id="back" class="hidden grayBtn">◁ 뒤로</a>
		</div> 
</body>
</html>