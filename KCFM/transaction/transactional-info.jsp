<%
/** ############################################################### */
/** Program ID   : transactional-info.jsp                           */
/** Program Name : 거래내역 > 카드승인내역                          */
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

<%@ page import="transaction.beans.tranBean" %> 
<%@ page import="transaction.dao.tranDao" %>

<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /transaction-info.jsp");

	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("사용자ID"  , (String)session.getAttribute("sseCustId"));
	paramData.put("사용자명"  , (String)session.getAttribute("sseCustNm"));
	paramData.put("권한코드"  , (String)session.getAttribute("sseCustAuth"));
	paramData.put("매장코드"  , (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("매장명"    , (String)session.getAttribute("sseCustStoreNm"));
	
	String sseCustNm = (String)session.getAttribute("sseCustNm");      //사용자명
	
	String sDate     = JSPUtil.chkNull((String)request.getParameter("sDate"   ),"");    //시작일자
	String eDate     = JSPUtil.chkNull((String)request.getParameter("eDate"   ),"");    //종료일자
	String tabNo     = JSPUtil.chkNull((String)request.getParameter("tabNo"   ),"");    //탭번호
	String inDate    = JSPUtil.chkNull((String)request.getParameter("i_inDate"),"");    //include변수
	String fColor    = JSPUtil.chkNull((String)request.getParameter("fColor"  ),"");    //선택된 폰트컬러
	
	tranBean bean = null; 					//리스트 목록용
	tranDao  dao  = new tranDao();
	ArrayList<tranBean> list = null;
	ArrayList<tranBean> iniList = null;
	ArrayList<tranBean> iniList2 = null;
	String sYear  = "";
	String sMonth = "";
	
	iniList = dao.selectMonthInit();
	if( iniList != null && iniList.size() > 0 ) 
	{
		bean = (tranBean) iniList.get(0);
		
		if ("".equals(sDate)){
			sDate = bean.get초기시작월();
		}
		if ("".equals(eDate)){
			eDate = bean.get초기전월();
		}
	}

	if(!"".equals(sDate)){
		list = dao.selectTranMonth(paramData); //거래내역 해당월 조회
	}
	
	System.out.println("transactional-info11======================================");
	System.out.println("시작일자     : " + sDate    );
	System.out.println("종료일자     : " + eDate    );
	System.out.println("탭번호       : " + tabNo    );
	System.out.println("include변수  : " + inDate   );
	System.out.println("색깔변경년월 : " + fColor   );
	System.out.println("사용자명     : " + sseCustNm);
	System.out.println("========================================================");
	
	paramData.put("시작일자", sDate);
	paramData.put("종료일자", eDate);
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/common_file.inc" %>
	<title>거래내역</title>  
     
    <script type="text/javascript">

    $(document).ready(function(){

    	var tabNo = getParameter("tabNo");
    	if(tabNo == "empty"){
    		tabNo="1";
    	} 
		$("#tab-"+tabNo).addClass("on"); 
		$(".tab-pages").find("#tab-"+tabNo+"-data").removeClass("hidden").addClass("show");

		
		/* $("#sDate").append("<option>2015-03-02</option>");
		$("#eDate").append("<option>2015-03-08</option>"); */
		
		
		var v_font   = document.getElementById("f"+'<%=fColor%>');
		if(v_font != "f" && v_font != null){
			v_font.color = "red";
		}

    });
    
    $(function(){
	    $("#data-t1").find(".data").hover(function(){
			$(this).css("background","#fdfbc9");
		},function(){
			$(this).css("background","#ffffff");
		});
    });
    
    /* 콤보박스의 초기값 설정 */
	function fnStartLoad(){
		var v_sDate    = document.getElementById("sDate");
    	var v_eDate    = document.getElementById("eDate");
	    	
	    v_sDate.value = '<%=sDate%>';
	    v_eDate.value = '<%=eDate%>';
	    
	}
    
	/* 종료일자가 시작일자보다 작은 경우 예외처리 */
    function fnChkMon(){
    	var v_sDate    = document.getElementById("sDate").value;
    	var v_eDate    = document.getElementById("eDate").value;
    	
		if(v_sDate == '' || v_eDate == ''){
    		
    		alert("날짜를 선택해주세요!");
    		v_sDate = '';
    		v_eDate = '';
    		return;
    		
    	}else if(v_sDate > v_eDate){
    		
    		alert("시작일자보다 큰 날짜를 선택해주세요!");
    		v_eDate = '';
    		return;
    		
    	}else if(v_sDate == v_eDate){
    		
    		alert("시작일자보다 큰 날짜를 선택해주세요!");
    		v_eDate = '';
    		return;
    		
    	}
    }
    /* 해당기간 조회 */
    function search_list(){
    	var frm          = document.getElementById("form1");
    	var v_sDate      = document.getElementById("sDate").value;
    	var v_eDate      = document.getElementById("eDate").value;
    	var v_sDateExcel = document.getElementById("sDateExcel");
    	var v_eDateExcel = document.getElementById("eDateExcel");
    	var v_inDate     = document.getElementById("i_inDate");
    	var v_tabNo      = '<%=tabNo%>';
    	
		if(v_sDate == "" && v_eDate == ""){
    		
    		alert("날짜를 선택해주세요!");
    		v_sDate = '';
    		v_eDate = '';
    		return;
    		
    	}else if(v_sDate > v_eDate){
    		
    		alert("시작일자보다 큰 날짜를 선택해주세요!");
    		v_eDate = '';
    		return;
    		
    	}else if(v_sDate == v_eDate){
    		
    		alert("시작일자보다 큰 날짜를 선택해주세요!");
    		v_eDate = '';
    		return;
    		
    	}else{
    		v_sDateExcel.value = v_sDate;
    		v_eDateExcel.value = v_eDate;
    		v_inDate.value = "";
    		frm.action = "<%=root%>/transaction/transactional-info.jsp?tabNo="+v_tabNo;
    		frm.target = "_self";
    		frm.submit();
    	}
    	
    }
    /* 해당월의 내역집계 테이블 조회 */
    function fnDataLoad(obj){
    	var frm      = document.getElementById("form1");
    	var v_inDate = document.getElementById("i_inDate");
    	var v_tabNo  = '<%=tabNo%>';
    	var v_font   = document.getElementById("fColor");
    	
    	if('<%=tabNo%>' == 4){
	    	v_inDate.value = obj;
	    	v_font.value = obj;
	    	
	    	frm.action = "<%=root%>/transaction/transactional-info.jsp?tabNo="+v_tabNo;
	    	frm.target = "_self";
			frm.submit();
    	}else{
    		return;
    	}
    }
    
 	// 엑셀데이터 추출
    function fnExcelDown(gbn){
    	var frm = document.getElementById("form1");
    	var v_inDate = document.getElementById("i_inDate");	//include 변수
    	
    	if('<%=tabNo%>' == 4){
    	
	    	v_inDate.value = '<%=sDate%>';
	    	
	    	frm.action = "<%=root%>/transaction/excel_down.jsp";
		    frm.target = "iWorker";
		    frm.submit();
		    
    	}else{
    		return;
    	}
    	
    }
	
    // 엑셀저장
    function fnSaveExcel(out){
    	saveExcel("src", "", out, "카드승인내역.xls");
    }
    
    </script>

    
</head>

<body onload="fnStartLoad();">
 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("../include/header.jsp"); </script> 
	 	</section>
	 	
	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("../include/edit-info.jsp"); </script> 
	 	</section>
	 	
	 	
 		 <section class="contents">
 		 	<header> 
 		 		<h1>◎ <span>거래내역</span></h1>
 		 	</header>
 		 	
			 <article class="tabs" id="transactional-menus">
		        <div id="tab-nav">
				    <nav>
						<ul id="tabMenu2" class="topmenu reqmenu">
							<li class="topfirst transactional" id="tab-1"><a href="transactional-info.jsp?tabNo=1" onclick="fnResetTab2($(this));">매입현황</a></li>
							<li class="transactional" id="tab-2">         <a href="transactional-info.jsp?tabNo=2" onclick="fnResetTab2($(this));">여신현황</a></li>
							<li class="transactional" id="tab-3">         <a href="transactional-info.jsp?tabNo=3" onclick="fnResetTab2($(this));">재고현황</a></li>
							<li class="transactional" id="tab-4">         <a href="transactional-info.jsp?tabNo=4" onclick="fnResetTab2($(this));">카드승인내역</a></li>
							<li class="toplast transactional" id="tab-5"> <a href="transactional-info.jsp?tabNo=5" onclick="fnResetTab2($(this));">매출현황</a></li>
						</ul>
					</nav>
		        </div>
		        <div class="tab-pages" style="height: 520px;">
		        	<div id="search-option">
		        		<form id="form1" name="form1" method="post" >
		        			<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"  />
							<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"  />
							<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
							<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"  />
		        			<input type="hidden" name="tabNo"       id="tabNo"       value="4"		        />  <!-- 탭번호 -->
		        			<input type="hidden" name="i_inDate"    id="i_inDate"    value="<%=inDate%>"	/>  <!-- include 변수 -->
		        			<input type="hidden" name="fColor"      id="fColor"      value=""	            />  <!-- 선택된 폰트컬러 -->
		        			<input type="hidden" name="sDateExcel"  id="sDateExcel"  value="<%=sDate %>"	/>  <!-- 시작일자 엑셀용 -->
		        			<input type="hidden" name="eDateExcel"  id="eDateExcel"  value="<%=eDate %>"	/>  <!-- 종료일자 엑셀용 -->
		        			
			    		<label for="sDate" > ▶ 기간 : </label>
			    		<select id="sDate" name="sDate" style="height:20px; width:100px;">
				    		<option value="">시작일자</option>
				    		<%
				    		//SYSDATE의 기준으로 콤보박스를 가져옴 (sDate:해당년 1월 , eDate:현재 해당월)
				    		iniList2 = dao.selectMonthInit();
				    		int i_sYear = 0;
				    		
				    		if( iniList2 != null && iniList2.size() > 0 ) 
				    		{
				    			bean = (tranBean) iniList2.get(0);
				    			
				    			sYear = bean.get초기시작월().substring(0, 4);
				    			i_sYear = Integer.parseInt(sYear);
				    			
				    			for (int i=i_sYear; i<=(i_sYear+5); i++){
					    			for (int j=1; j<=12; j++){
					    				if(j < 10){
					    		%>
					    				<option value="<%=i%>0<%=j%>"><%=i %>-0<%=j %></option>
					    				
					    		<%
					    				}else{
					    		%>
					    				<option value="<%=i%><%=j%>"><%=i %>-<%=j %></option>
					    		<%			
					    				}
					    			}
					    		}
				    		}
				    		%>
			    		</select>
			    		~ 
			    		<select id="eDate" name="eDate" style="height:20px; width:100px;" onchange="fnChkMon(this.selectedIndex)">
			    			<option value="">종료일자</option>
			    			<%
			    			
			    			if( iniList2 != null && iniList2.size() > 0 ) 
				    		{
				    			bean = (tranBean) iniList2.get(0);
				    			
				    			sYear = bean.get초기시작월().substring(0, 4);
				    			i_sYear = Integer.parseInt(sYear);
				    			
					    		for (int i=i_sYear; i<=(i_sYear+5); i++){
					    			for (int j=1; j<=12; j++){
					    				if(j < 10){
					    		%>
					    				<option value="<%=i%>0<%=j%>"><%=i %>-0<%=j %></option>
					    				
					    		<%
					    				}else{
					    		%>
					    				<option value="<%=i%><%=j%>"><%=i %>-<%=j %></option>
					    		<%			
					    				}
					    			}
					    		}
				    		}
				    		%>
			    		</select>

			    		<span><button class="searchDateBtn" onclick="search_list();">조회</button></span>
			    		<span class="btns"><button class="excelBtn" onclick="javascript:fnExcelDown('excelDown');">엑셀</button></span>
			  			</form>
<!-- 			  			<input class="big_0" name="sDate" type="text" value="${param.sDate}"/> ~ 
							<input class="big_0" name="eDate" type="text" value="${param.eDate}"/> 
-->
			  		
			  		</div>
			  		
			  		<!-- 1. 매입현황  - 목록 개수는 맥시멈 10줄 입니다 -->
			  		<div id="tab-1-data" class="tableT hidden" style="margin-top:5px;">
				  		<table width="100" height="240"  bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px; margin-right: 5px;">
			  				<caption style="text-align: right;">&nbsp;</caption>
				  			<tr bgcolor="#b2b19c" align="center" style="border-bottom: 1px solid #797979;">
						         <th style="border-bottom: 1px solid #797979;"><font color="#ffffff"><b>NO</b></font></th>
						         <th style="border-bottom: 1px solid #797979;"><font color="#ffffff"><b>매입일자</b></font></th>
						    </tr>
						   <tr align="center" bgcolor="#fdfbc9">
						         <td bgcolor="#daf1fd"><font color="#474747"><b>1</b></font></td>
						         <td><font color="#474747"><b>2015-03-02</b></font></td>
						    </tr>
						   <tr align="center" bgcolor="#ffffff">
						         <td bgcolor="#daf1fd">2</td>
						         <td>2015-03-03</td>
						    </tr>
						   <tr align="center" bgcolor="#ffffff">
						         <td bgcolor="#daf1fd">3</td>
						         <td>2015-03-04</td>
						    </tr>
						   <tr align="center" bgcolor="#ffffff">
						         <td bgcolor="#daf1fd">4</td>
						         <td>2015-03-05</td>
						    </tr>
						   <tr align="center" bgcolor="#ffffff">
						         <td bgcolor="#daf1fd">5</td>
						         <td>2015-03-06</td>
						    </tr>
						   <tr align="center" bgcolor="#ffffff">
						         <td bgcolor="#daf1fd">6</td>
						         <td>2015-03-07</td>
						    </tr>
						   <tr align="center" bgcolor="#ffffff">
						         <td bgcolor="#daf1fd">7</td>
						         <td>2015-03-08</td>
						    </tr>
						</table>
			  		
			  			<table id="data-t1" width="795" height="420" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px;"> 
			  				<caption style="text-align: right;">금액 : 원</caption>
							<tr bgcolor="#b2b19c" align="center">
								<th style="border-bottom: 1px solid #797979;" width="20"><font color="#ffffff"><b>NO</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="70"><font color="#ffffff"><b>매입번호</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="60"><font color="#ffffff"><b>매입구분</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="60"><font color="#ffffff"><b>품목코드</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>품목명</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="50"><font color="#ffffff"><b>규격</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="30"><font color="#ffffff"><b>단위</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="60"><font color="#ffffff"><b>과세여부</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="50"><font color="#ffffff"><b>단가</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="30"><font color="#ffffff"><b>수량</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="60"><font color="#ffffff"><b>공급가</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="50"><font color="#ffffff"><b>부가세</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="60"><font color="#ffffff"><b>매입금액</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="80"><font color="#ffffff"><b>발주일자</b></font></th>
							</tr>

							<tr class="data" align="center" bgcolor="#ffffff">
							<td bgcolor="#daf1fd">1</td>
							<td>110-7788</td>
							<td>입고</td>
							<td><font color="#999999">58123</font></td>
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							</tr>

							 <tr class="data" align="center" bgcolor="#ffffff">
							 <td bgcolor="#daf1fd">2</td>
							<td>1111-111</td>
							<td>입고</td>
							<td>79111</td>
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							 </tr >

							<tr class="data" align="center" bgcolor="#ffffff">
							 <td bgcolor="#daf1fd">3</td>
							<td>1111-222</td>
							<td>입고</td>
							<td>51456</td> 
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							  </tr>

							<tr class="data" align="center" bgcolor="#ffffff">
							 <td bgcolor="#daf1fd">4</td>
							<td>1111-119</td>
							<td>입고</td>
							<td><font color="#999999">없음</font></td> 
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							 </tr>

							<tr class="data" align="center" bgcolor="#ffffff">
							<td bgcolor="#daf1fd">5</td>
							<td>1111-200</td>
							<td ><font color="#6ba7c7">출고</font></td>
							 <td>12345</td>
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							  </tr>   
							   
							<tr class="data" align="center" bgcolor="#ffffff">
							<td bgcolor="#daf1fd">6</td>
							<td>7700-111</td>
							<td ><font color="#6ba7c7">출고</font></td>
							<td><font color="#999999">없음</font></td>
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							 </tr>

							<tr class="data" align="center" bgcolor="#ffffff">
							 <td bgcolor="#daf1fd">7</td>
							<td>1111-111</td>
							<td>입고</td>
							<td>99841</td>
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							 </tr >

							<tr class="data" align="center" bgcolor="#ffffff">
							 <td bgcolor="#daf1fd">8</td>
							<td>7711-201</td>
							<td ><font color="#6ba7c7">출고</font></td>
							<td>55129</td> 
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							  </tr>

							<tr class="data" align="center" bgcolor="#ffffff">
							 <td bgcolor="#daf1fd">9</td>
							<td>1111-111</td>
							<td>입고</td>
							<td><font color="#999999">없음</font></td> 
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							 </tr>

							<tr class="data" align="center" bgcolor="#ffffff">
							 <td bgcolor="#daf1fd">10</td>
							<td>1111-111</td>
							<td>입고</td>
							<td><font color="#999999">없음</font></td> 
							<td>품목명</td>
							<td >110*20g</td>
							<td>BX</td>
							<td>과세</td>
							<td><font color="#999999">12,000</font></td>
							<td>1 </td>
							 <td align="right">77,000</td>
							<td align="right">2,500</td>
							<td align="right"><font color="#fb2a2a">15,000</font></td>
							<td>2015-02-20</td>
							 </tr>
     
							<tr align="center" bgcolor="#fcb8b8">
								<td  style="border-top: 1px solid #797979;" ></td>
								<td  style="border-top: 1px solid #797979;" ></td>
								<td  style="border-top: 1px solid #797979;" ><font color="#999999"></font></td>
								<td  style="border-top: 1px solid #797979;" ></td>
								<td  style="border-top: 1px solid #797979;" ></td>
								<td  style="border-top: 1px solid #797979;" ></td>
								<td  style="border-top: 1px solid #797979;" ></td>
								<td  style="border-top: 1px solid #797979;" ></td>
								<td  style="border-top: 1px solid #797979;" ><font color="#999999"></font></td>
								<td  style="border-top: 1px solid #797979;" ></td>
								<td  style="border-top: 1px solid #797979;" align="right">975,782</td>
								<td  style="border-top: 1px solid #797979;" align="right">83,694</td>
								<td  style="border-top: 1px solid #797979;" align="right"><font color="#ff0000"><b>1,204,690</b></font></td>
								<td  style="border-top: 1px solid #797979;" ></td>
						    </tr>  
						</table>
						
				  		<!-- 페이징 표시 -->
				  		<div class="paging">
						    <ul class="numbering">
						        <li class="f"><a href="#">◁</a></li>
						        <li class="p"><a href="#">PREV</a></li>
						        <li><a class="now" href="#">1</a></li>
						        <li class="last"><a href="#">2</a></li>
						        <li class="n"><a href="#">NEXT</a></li>
						        <li class="l"><a href="#">▷</a></li>
						   	</ul>
						</div>
				  		<!-- 페이징 표시 끝 -->
				  		
			  		</div>
			  		<!-- 탭1 화면 끝 -->
			  		
			  		<!-- 2. 여신현황 -->
			  		<div id="tab-2-data" class="tableT hidden" style="margin-top:5px;">
			  		<table id="data-t2" width="900" height="320" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px;"> 
			  				<caption style="text-align: right;">금액 : 원</caption>
							<tr bgcolor="#b2b19c" align="center">
								<th style="border-bottom: 1px solid #797979;" width="90"><font color="#ffffff"><b>거래일자</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>전미수금액</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>면세금액</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>과세금액</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>부가세액</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="110"><font color="#ffffff"><b>합계금액</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>수금금액</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>미수잔고</b></font></th>
							</tr>

							<tr class="data" align="center" bgcolor="#ffffff">
								<td>2015-03-02</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right"><font color="#fb2a2a">15,000</font></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>2015-03-03</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right"><font color="#fb2a2a">15,000</font></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>2015-03-04</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right"><font color="#fb2a2a">15,000</font></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>2015-03-05</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right"><font color="#fb2a2a">15,000</font></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>2015-03-06</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right"><font color="#fb2a2a">15,000</font></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>2015-03-07</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right"><font color="#fb2a2a">15,000</font></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>2015-03-08</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right">77,000</td>
								<td align="right">2,500</td>
								<td align="right"><font color="#fb2a2a">15,000</font></td>
							</tr>
							<tr class="data" align="center" bgcolor="#fcb8b8">
								<td style="border-top: 1px solid #797979;"><b>합계</b></td>
								<td align="right" style="border-top: 1px solid #797979;">77,000</td>
								<td align="right" style="border-top: 1px solid #797979;">2,500</td>
								<td align="right" style="border-top: 1px solid #797979;">77,000</td>
								<td align="right" style="border-top: 1px solid #797979;">2,500</td>
								<td align="right" style="border-top: 1px solid #797979;">77,000</td>
								<td align="right" style="border-top: 1px solid #797979;">2,500</td>
								<td align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b>15,000</b></font></td>
							</tr>
			  			</table>	
			  		</div>
			  		<!-- 탭2 화면 끝 -->
			  		
			  		<!-- 3. 재고현황 - 목록 개수는 맥시멈 10줄 입니다 -->
			  		<div id="tab-3-data" class="tableT hidden" style="margin-top:5px;">
			  		<table id="data-t3" width="900" height="420" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px;"> 
			  				<caption style="text-align: right;">금액 : 원</caption>
							<tr bgcolor="#b2b19c" align="center">
								<th style="border-bottom: 1px solid #797979;" width="110"><font color="#ffffff"><b>품목코드</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="220"><font color="#ffffff"><b>품목명</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>규격</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="80"><font color="#ffffff"><b>단위</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="90"><font color="#ffffff"><b>BOX입수</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="80"><font color="#ffffff"><b>과세</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>표준임고단가</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>현재고수량</b></font></th>
							</tr>

							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>50071</td>
								<td align="left">키친타올</td>
								<td>1kg*10</td>
								<td>ea</td>
								<td>100</td>
								<td>Y</td>
								<td align="right">2,500</td>
								<td align="right"><b>95</b></td>
							</tr>
							
							<tr class="data" align="center" bgcolor="#fcb8b8">
								<td style="border-top: 1px solid #797979;"><b>합계</b></td>
								<td align="right" style="border-top: 1px solid #797979;"></td>
								<td align="right" style="border-top: 1px solid #797979;"></td>
								<td align="right" style="border-top: 1px solid #797979;"></td>
								<td align="right" style="border-top: 1px solid #797979;"></td>
								<td align="right" style="border-top: 1px solid #797979;"></td>
								<td align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b>2,500</b></font></td>
								<td align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b>15,000</b></font></td>
							</tr>
			  			</table>	
				  		<!-- 페이징 표시 -->
				  		<div class="paging">
						    <ul class="numbering">
						        <li class="f"><a href="#">◁</a></li>
						        <li class="p"><a href="#">PREV</a></li>
						        <li><a class="now" href="#">1</a></li>
						        <li><a href="#">2</a></li>
						        <li class="last"><a href="#">3</a></li>
						        <li class="n"><a href="#">NEXT</a></li>
						        <li class="l"><a href="#">▷</a></li>
						   	</ul>
						</div>
				  		<!-- 페이징 표시 끝 -->
			  		</div>
			  		<!-- 탭3 화면 끝 -->
			  		
			  		<!-- 4. 카드내역-->
			  		<div id="tab-4-data" class="tableT hidden" style="margin-top:5px; overflow: scroll; height: 500px" >
				  		<form id="form4" name="form4" method="post" >
				  			<input type="hidden" name="i_sDate"       id="i_sDate"       value=""		   >  <!-- 시작일자 -->
				  			<input type="hidden" name="i_eDate"       id="i_eDate"       value=""		   >  <!-- 종료일자 -->
				  			
				  		</form>
				  		
				  		<!-- <table width="110" height="220"  bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px; margin-right: 5px;"> -->
				  		<table width="110" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px; margin-right: 5px;">
			  				<caption style="text-align: right;">&nbsp;</caption>
				  			<tr bgcolor="#b2b19c" align="center" style="border-bottom: 1px solid #797979;">
						         <th height="20px" style="border-bottom: 1px solid #797979;"><font color="#ffffff"><b>NO</b></font></th>
						         <th height="20px" style="border-bottom: 1px solid #797979;"><font color="#ffffff"><b>거래년월</b></font></th>
						    </tr>
						   
						   <%
						   
						   int i_sDate = 0;
						   int i_eDate = 0;
						   int no = 0;
						   String sYearMon = "";
						   
						   i_sDate = Integer.parseInt(sDate);
						   i_eDate = Integer.parseInt(eDate);
						   
						  
						   for( int i = i_sDate; i <= i_eDate; i++ ) 
						   {
							   no++;
							   sYearMon = Integer.toString(i);
							   sYear = sYearMon.substring(0, 4);
							   sMonth = sYearMon.substring(4);
						   %>
						   		<a href="#" onclick="fnDataLoad(<%=sYearMon%>)">	   
								   <tr align="center" bgcolor="#fdfbc9">
								         <td height="20px" bgcolor="#daf1fd"><font color="#474747"><b><%=no %></b></font></td>
								         <td height="20px"><font color="#474747" id="f<%=sYearMon%>"><b><%=sYear %>년 <%=sMonth %>월</b></font></td>
								    </tr>
								</a>
						   <%
							 	//12월이 되면 다음해 1월로 가도록 추가함. 
								String s_loop = Integer.toString(i);
								s_loop = s_loop.substring(4);
								if("12".equals(s_loop)){
									i = i + 100 - 12;
								}
						   }
						   %>
						   
						   						    
						</table>
							<!-- 집계내역 테이블을 include 시킴  -->
							<jsp:include page="/transaction/transactional-info-include.jsp" flush="false" > 
								<jsp:param name="includeDate" value="<%=inDate %>" />
							</jsp:include>
					</div>
						<!-- 
						<table id="data-t4" width="780" height="420" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px;">
			  				<caption style="text-align: right;">단위 : 건,원</caption> 
							<tr bgcolor="#b2b19c" align="center">
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>구분</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>카드사</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>건수</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>공급가액</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>세액</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>봉사료</b></font></th>
								<th style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>매출액</b></font></th>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td rowspan="9"><b>[카드]</b></td>
								<td>국민</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>신한</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>비씨</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>삼성</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>롯데</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>외환</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>현대</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>기타</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#ffffff">
								<td>-</td>
								<td align="right">-</td>
								<td align="right">-</td>
								<td align="right">-</td>
								<td align="right">-</td>
								<td align="right">-</td>
							</tr>
							<tr class="data" align="center" bgcolor="#daf1fd">
								<td><b>[현금]</b></td>
								<td></td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#daf1fd">
								<td><b>[현금영수증]</b></td>
								<td></td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
								<td align="right">99,999,000</td>
							</tr>
							<tr class="data" align="center" bgcolor="#fcb8b8">
								<td  style="border-top: 1px solid #797979;"><b>[합계]</b></td>
								<td style="border-top: 1px solid #797979;"></td>
								<td align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b>320,000</b></font></td>
								<td align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b>15,000,000</b></font></td>
								<td align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b>2,500,500</b></font></td>
								<td align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b>15,000,000</b></font></td>
								<td align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b>2,500,000</b></font></td>
							</tr>
						</table> -->
			  		
			  		<!-- 탭4 화면 끝 -->
			  		
		        </div>
	        </article>
		 </section>
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div><!-- end of wrap -->
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>