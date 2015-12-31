<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.BoardConstant" %>
<%@ page import="prom.dao.orderDao" %>
<%@ page import="prom.beans.orderBean" %>
<%@ include file="/com/common.jsp"%>

<%
String root = request.getContextPath();

	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드", (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("조회시작일자", request.getParameter("sDate"));
	paramData.put("조회종료일자", request.getParameter("eDate"));
	paramData.put("srch_key", request.getParameter("srch_key"));
	paramData.put("srch_type", request.getParameter("srch_type"));
	paramData.put("inCurPage", request.getParameter("inCurPage"));
	paramData.put("inCurBlock", request.getParameter("inCurBlock"));
	//-------------------------------------------------------------------
	paramData.put("excelGbn",request.getParameter("gbn"));
	//-------------------------------------------------------------------

	orderBean orderBean  = new orderBean(); //내용보기 에서 담을 빈
	orderDao  orderDao   = new orderDao();
	
	ArrayList<orderBean> list = null;
	list = orderDao.selectList(paramData);        //조회조건에 맞는 이벤트 리스트

	String sOut = "";
	sOut = sOut + "<table id='ord-list-data' width='1140' height='320' bgcolor='#c6c6c6' border='1' cellpadding='1' cellspacing='1' style=''>";
	sOut = sOut + "  <tr bgcolor='#b2b19c' align='center'>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='50'><font color='#ffffff'><b>순번</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='80'><font color='#ffffff'><b>주문일자</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='120'><font color='#ffffff'><b>주문번호</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='100'><font color='#ffffff'><b>품목구분</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='150'><font color='#ffffff'><b>홍보물명</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='60'><font color='#ffffff'><b>작업유형</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='80'><font color='#ffffff'><b>주문단위</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='60'><font color='#ffffff'><b>주문수량</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='80'><font color='#ffffff'><b>주문금액</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='60'><font color='#ffffff'><b>주문상태</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='80'><font color='#ffffff'><b>최종시안</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='60'><font color='#ffffff'><b>배송상태</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='80'><font color='#ffffff'><b>택배사</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979;' width='80'><font color='#ffffff'><b>송장번호</b></font></th>";
	sOut = sOut + "  </tr>";

	if(list != null && list.size() > 0){
		for(int i=0; i<list.size(); i++){
			orderBean = (orderBean) list.get(i);

			sOut = sOut + "  <tr class='data' align='center' bgcolor='#ffffff'>";
			sOut = sOut + "    <td>"+orderBean.get순번()+"</td>";
			sOut = sOut + "    <td>"+orderBean.get주문일자()+"</td>";
			sOut = sOut + "    <td>"+orderBean.get주문번호()+"</td>";
			sOut = sOut + "    <td>"+orderBean.get홍보물코드명()+"</td>";
			sOut = sOut + "    <td>"+orderBean.get홍보물명()+"</td>";
			sOut = sOut + "    <td>"+orderBean.get작업유형()+"</td>";
			sOut = sOut + "    <td>"+orderBean.get주문단위()+"</td>";
			sOut = sOut + "    <td>"+orderBean.get주문수량()+"</td>";
			sOut = sOut + "    <td>"+orderBean.get주문가격()+"원</td>";
			sOut = sOut + "    <td>"+JSPUtil.chkNull(orderBean.get주문상태())+"</td>";
			sOut = sOut + "    <td><font color='#fb2a2a'>시안확인("+orderBean.get시안번호()+")</font></td>";
			sOut = sOut + "    <td>"+orderBean.get제작상태()+"</td>";
			sOut = sOut + "    <td>"+JSPUtil.chkNull(orderBean.get택배사코드명())+"</td>";
			sOut = sOut + "    <td>"+JSPUtil.chkNull(orderBean.get송장번호())+"</td>";
			sOut = sOut + "  </tr>";
		}
	} else {
		sOut = sOut + "  <tr class='data' align='center' bgcolor='#ffffff'><td colspan='14'>조회된 내용이 없습니다.</td></tr>";
	}

	sOut = sOut + "</table>";

	out.print("<script>");
	out.print("  parent.fnSaveExcel(\""+sOut+"\");");
	out.print("</script>");
%>
