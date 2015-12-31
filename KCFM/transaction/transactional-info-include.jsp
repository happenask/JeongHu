<%
/** ############################################################### */
/** Program ID   : transactional-info.jsp                           */
/** Program Name : 거래내역 > 카드승인내역 > 집계내역 (include)     */
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
	log4u.log("CALL /transaction-info-include.jsp");

	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("사용자ID"  , (String)session.getAttribute("sseCustId"));
	paramData.put("사용자명"  , (String)session.getAttribute("sseCustNm"));
	paramData.put("권한코드"  , (String)session.getAttribute("sseCustAuth"));
	paramData.put("매장코드"  , (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("매장명"    , (String)session.getAttribute("sseCustStoreNm"));
	
	String sseCustNm = (String)session.getAttribute("sseCustNm");      //사용자명
	
	String inDate     = JSPUtil.chkNull((String)request.getParameter("includeDate"  ),"");    //시작일자
	
	System.out.println("transactional-info-include==============================");
	System.out.println("include 일자 : " + inDate);
	System.out.println("기업코드 : " + (String)session.getAttribute("sseGroupCd"));
	System.out.println("법인코드 : " + (String)session.getAttribute("sseCorpCd"));
	System.out.println("브랜드코드 : " + (String)session.getAttribute("sseBrandCd"));
	System.out.println("매장코드 : " + (String)session.getAttribute("sseCustStoreCd"));
	System.out.println("========================================================");
	
	paramData.put("inDate", inDate);
	
	tranBean bean = null; 					//리스트 목록용
	tranDao  dao  = new tranDao();
	ArrayList<tranBean> list1 = null;
	ArrayList<tranBean> list2 = null;
	ArrayList<tranBean> list3 = null;
	ArrayList<tranBean> listSum = null;
	String sYear  = "";
	String sMonth = "";
	
	if(!"".equals(inDate)){
		sYear  = inDate.substring(0, 4);
		sMonth = inDate.substring(4);
	}
	
	if(!"".equals(inDate)){
		if("테스트".equals(sseCustNm)){
			list1   = dao.selectTranMonthList1Test(paramData);   //카드 거래내역 해당월 조회 테스트용
			//list2   = dao.selectTranMonthList2Test(paramData);   //현금 거래내역 해당월 조회 테스트용
			list3   = dao.selectTranMonthList3Test(paramData);   //현금영수증 거래내역 해당월 조회 테스트용
			listSum = dao.selectTranMonthListSumTest(paramData); //합계 거래내역 해당월 조회 테스트용
		}else{
			list1   = dao.selectTranMonthList1(paramData);   //카드 거래내역 해당월 조회
			//list2   = dao.selectTranMonthList2(paramData);   //현금 거래내역 해당월 조회
			list3   = dao.selectTranMonthList3(paramData);   //현금영수증 거래내역 해당월 조회
			listSum = dao.selectTranMonthListSum(paramData); //합계 거래내역 해당월 조회
		}
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/common_file.inc" %>
	<title>거래내역</title>  
     
    <script type="text/javascript">
	
    function go_pop(tranGb, tranCd){
    	/* window.open("transactional-info-include-detail.jsp","new","width=370, height=360"); */
    	var frm      = document.getElementById("formdata");
    	var v_iTranGb = document.getElementById("iTranGb");
    	var v_iTranCd = document.getElementById("iTranCd");
    	var v_iIndate = document.getElementById("iIndate");
    	
    	v_iTranGb.value = tranGb;
    	v_iTranCd.value = tranCd;
    	v_iIndate.value = '<%=inDate%>';
    	
    	/* window.showModalDialog("transactional-info-include-detail.jsp", obj, "dialogWidth:980px;dialogHeight:600px;status:no;help:no;location:no"); */
    	window.open("about:blank","card_detail","width=980, height=600, scrollbars=yes, location=yes, resizeble=yes"); 
    	frm.action = "<%=root%>/transaction/transactional-info-include-detail.jsp";
    	frm,method ="POST";
    	frm.target ="card_detail";
		frm.submit();
    }
    
    </script>

    
</head>

<body>
<form id="formdata" name="formdata" method="post">
	<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>
	<input type="hidden"   name="iTranGb"     id="iTranGb" value=""/>
	<input type="hidden"   name="iTranCd"     id="iTranCd" value=""/>
	<input type="hidden"   name="iIndate"     id="iIndate" value=""/>
 	
			  		
	<!-- 4. 카드내역-->
	<!-- <div id="tab-4-data" class="table hidden" style="margin-top:5px;"> -->
	
	
		    		
	<!-- <table id="data-t4" width="780" height="420" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px;"> -->
	<table id="data-t4" width="750" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="float: left; font-size: 11px;">
		<caption style="text-align: right;">단위 : 건,원 </caption>
		
		<tr bgcolor="#b2b19c" align="center">
			<th height="20px" style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>구분</b></font></th>
			<th height="20px" style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>카드사</b></font></th>
			<th height="20px" style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>건수</b></font></th>
			<th height="20px" style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>공급가액</b></font></th>
			<th height="20px" style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>세액</b></font></th>
			<th height="20px" style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>봉사료</b></font></th>
			<th height="20px" style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>매출액</b></font></th>
		</tr>
		
		<%
		if( list1 != null && list1.size() > 0 ) 
		{
			for( int i = 0; i < list1.size(); i++ ) 
			{
				bean = (tranBean) list1.get(i);
				if(i==0){
		%>
				<input type="hidden"  name="corpNum"  id="corpNum"  value="<%=bean.get사업자번호()%>"/> <!-- 사업자번호 -->
				
				<tr class="data" align="center" bgcolor="#ffffff">
					<td height="20px" rowspan="<%=list1.size()%>"><b>[카드]</b></td>
					<td height="20px"><a href ="javascript:go_pop('<%=bean.get거래구분()%>','<%=bean.get카드발급사코드()%>');"> <%=bean.get카드발급사명() %></a></td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get승인건수(),"")%> </td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get공급가액(),"")%> </td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get부가세(),"")%>   </td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get봉사료(),"")%>   </td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get매출액(),"")%>   </td>
				</tr>
		<%
				}else{
		%>
				<tr class="data" align="center" bgcolor="#ffffff">
					<td><a href ="javascript:go_pop('<%=bean.get거래구분()%>','<%=bean.get카드발급사코드()%>');"> <%=bean.get카드발급사명() %></a></td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get승인건수(),"")%> </td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get공급가액(),"")%> </td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get부가세(),"")%>   </td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get봉사료(),"")%>   </td>
					<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get매출액(),"")%>   </td>
				</tr>
		<%
				}
			}
		}else{
		%>
			 <tr>
			 	<td height="20px" align="center" colspan="7"> 조회된 내역이 없습니다. </td>
			 </tr>
		<%
		}
		
		if( list3 != null && list3.size() > 0 ) 
		{
			for( int i = 0; i < list3.size(); i++ ) 
			{
				bean = (tranBean) list3.get(i);
		%>
		<tr class="data" align="center" bgcolor="#daf1fd">
			<td><b>[현금영수증]</b></td>
			<td></td>
			<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get승인건수(),"")%> </td>
			<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get공급가액(),"")%> </td>
			<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get부가세(),"")%>   </td>
			<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get봉사료(),"")%>   </td>
			<td height="20px" align='right'> <%=JSPUtil.chkNull((String)bean.get매출액(),"")%>   </td>
		</tr>
		<%
			}
		}else{
			
		}
		
		if( listSum != null && listSum.size() > 0 ) 
		{
			for( int i = 0; i < listSum.size(); i++ ) 
			{
				bean = (tranBean) listSum.get(i);
				if( bean.get승인건수() == null ){
									
				}else{
		%>
					<tr class="data" align="center" bgcolor="#fcb8b8">
						<td height="20px" style="border-top: 1px solid #797979;"><b>[합계]</b></td>
						<td height="20px" style="border-top: 1px solid #797979;"></td>
						<td height="20px" align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b><%=JSPUtil.chkNull((String)bean.get승인건수(),"")%></b></font></td>
						<td height="20px" align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b><%=JSPUtil.chkNull((String)bean.get공급가액(),"")%></b></font></td>
						<td height="20px" align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b><%=JSPUtil.chkNull((String)bean.get부가세(),"")%>  </b></font></td>
						<td height="20px" align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b><%=JSPUtil.chkNull((String)bean.get봉사료(),"")%>  </b></font></td>
						<td height="20px" align="right" style="border-top: 1px solid #797979;"><font color="#fb2a2a"><b><%=JSPUtil.chkNull((String)bean.get매출액(),"")%>  </b></font></td>
					</tr>
		<%
				}
			}
		}else{
			
		}
		%>
	</table>
		<!-- </div> -->
		<!-- 탭4 화면 끝 -->
</form>		  	
</body>
</html>