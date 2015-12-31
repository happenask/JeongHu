<%
/** ############################################################### */
/** Program ID   : transactional-info.jsp                           */
/** Program Name : 거래내역 > 카드승인내역 > 상세보기               */
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
	log4u.log("CALL /transaction-info-include-detail.jsp");

	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("사용자ID"  , (String)session.getAttribute("sseCustId"));
	paramData.put("사용자명"  , (String)session.getAttribute("sseCustNm"));
	paramData.put("권한코드"  , (String)session.getAttribute("sseCustAuth"));
	paramData.put("매장코드"  , (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("매장명"    , (String)session.getAttribute("sseCustStoreNm"));
	
	String sseCustNm = (String)session.getAttribute("sseCustNm");      //사용자명
	
	String iTranGb     = JSPUtil.chkNull((String)request.getParameter("iTranGb"  ),"");   //거래구분
	String iTranCd     = JSPUtil.chkNull((String)request.getParameter("iTranCd"  ),"");   //카드발급사코드
	String inDate      = JSPUtil.chkNull((String)request.getParameter("iIndate"  ),"");   //조회월
	String corpNum     = JSPUtil.chkNull((String)request.getParameter("corpNum"  ),"");   //사업자번호
	
	System.out.println("transactional-info-include-detail==============================");
	System.out.println("iTranGb 구분 : " + iTranGb);
	System.out.println("iTranCd 코드 : " + iTranCd);
	System.out.println("include 일자 : " + inDate);
	System.out.println("사업자번호   : " + corpNum);
	System.out.println("========================================================");
	
	paramData.put("iTranGb", iTranGb); //거래구분
	paramData.put("iTranCd", iTranCd); //카드발급사코드
	paramData.put("inDate" , inDate);  //조회월
	paramData.put("corpNum" , corpNum);//조회월
	
	tranBean bean = null; 			   //리스트 목록용
	tranDao  dao  = new tranDao();
	ArrayList<tranBean> list = null;
	String sYear  = "";
	String sMonth = "";
	
	if("테스트".equals(sseCustNm)){
		list   = dao.selectCardDetailListTest(paramData); //카드내역 상세조회 테스트용
	}else{
		list   = dao.selectCardDetailList(paramData);     //카드내역 상세조회
	}
	
	
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/common_file.inc" %>
	<title>상세승인내역</title>  
    
</head>

<body>
<form id="formdata" name="formdata" method="post">
	<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>
 	
			  		
	<!-- 4. 카드내역-->
	<!-- <div id="tab-4-data" class="table hidden" style="margin-top:5px;"> -->
	
	<table id="data-t4" width="780" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px;">
	<%
		if( list != null && list.size() > 0 )
		{
			bean = (tranBean) list.get(0);
	%> 
			<h1> <span> <font color="#800000">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp ◎ 상세승인내역 </font> </span>   
				<font size="2"> &nbsp&nbsp( 
	<%
					if("테스트".equals(sseCustNm)){
	%>
						테스트
	<%
					}else{
	%>
						<%=bean.get가맹점명()%> 
	<%
					}
	%>
					- <%=bean.get카드사명() %> - <%=bean.get승인년월() %> ) 
				</font>
			</h1>
	<%
		}else{
	%>	
			<h1>◎ <span>거래내역</span></h1>
	<%
		}
	%>
	</table>
	<!-- <table id="data-t4" width="780" height="420" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px;"> -->
	<table id="data-t4" width="900" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="font-size: 11px;" align="center">
				<caption style="text-align: right;">단위 : 건,원 </caption> 
		<tr bgcolor="#b2b19c" align="center">
			<th style="border-bottom: 1px solid #797979;" width="100" height="20px"><font color="#ffffff"><b>승인일자</b></font></th>
			<th style="border-bottom: 1px solid #797979;" width="100" height="20px"><font color="#ffffff"><b>카드번호</b></font></th>
			<th style="border-bottom: 1px solid #797979;" width="100" height="20px"><font color="#ffffff"><b>승인시간</b></font></th>
			<th style="border-bottom: 1px solid #797979;" width="100" height="20px"><font color="#ffffff"><b>승인번호</b></font></th>
			<th style="border-bottom: 1px solid #797979;" width="100" height="20px"><font color="#ffffff"><b>공급가액</b></font></th>
			<th style="border-bottom: 1px solid #797979;" width="100" height="20px"><font color="#ffffff"><b>부가세</b></font></th>
			<th style="border-bottom: 1px solid #797979;" width="100" height="20px"><font color="#ffffff"><b>매출액</b></font></th>
			<th style="border-bottom: 1px solid #797979;" width="100" height="20px"><font color="#ffffff"><b>매입일자</b></font></th>
			<th style="border-bottom: 1px solid #797979;" width="100" height="20px"><font color="#ffffff"><b>매입취소일자</b></font></th>
		</tr>
		
		<%
		if( list != null && list.size() > 0 ) 
		{
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (tranBean) list.get(i);
				
				
		%>
				<tr class="data" align="center" bgcolor="#ffffff">
					<td align="center" height="20px"><%=JSPUtil.chkNull((String)bean.get승인일자(),"")    %> </td>
					<td align="center" height="20px"><%=JSPUtil.chkNull((String)bean.get카드번호(),"")    %> </td>
					<td align="center" height="20px"><%=JSPUtil.chkNull((String)bean.get승인시간(),"")    %> </td>
					<td align="center" height="20px"><%=JSPUtil.chkNull((String)bean.get승인번호(),"")    %> </td>
					<td align="right"  height="20px"><%=JSPUtil.chkNull((String)bean.get공급가액(),"")    %> </td>
					<td align="right"  height="20px"><%=JSPUtil.chkNull((String)bean.get부가세(),"")      %> </td>
					<td align="right"  height="20px"><%=JSPUtil.chkNull((String)bean.get매출액(),"")      %> </td>
					<td align="center" height="20px"><%=JSPUtil.chkNull((String)bean.get매입일자(),"")    %> </td>
					<td align="center" height="20px"><%=JSPUtil.chkNull((String)bean.get매입취소일자(),"")%> </td>
				</tr>
		<%
			}
		}
		%>
	</table>
		<!-- </div> -->
		<!-- 탭4 화면 끝 -->
</form>		  	
</body>
</html>