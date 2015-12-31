<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="prom.dao.deliveryDao" %>
<%@ page import="prom.dao.orderDao" %>
<%@ page import="prom.beans.deliveryBean" %>
<%@ page import="prom.beans.orderBean" %>
<%@ include file="/com/common.jsp"%>

<%
	String root = request.getContextPath();

	paramData.put("기업코드"		, (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"		, (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드"	, (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드"		, (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("홍보물코드"	, JSPUtil.chkNull(request.getParameter("PromoCd")));
	paramData.put("홍보물번호"	, JSPUtil.chkNull(request.getParameter("PromoNo")));
	paramData.put("주문수량"		, JSPUtil.chkNull(request.getParameter("OrdQty")));
	paramData.put("인쇄사용문구"	, JSPUtil.chkNull(request.getParameter("PrintMsg")));
	paramData.put("추가요청사항"	, JSPUtil.chkNull(request.getParameter("AddRequst")));
	paramData.put("주문상태"		, JSPUtil.chkNull(request.getParameter("OrdStd")));
	paramData.put("배송지번호"	, "");//request.getParameter("addr_type")
	paramData.put("배송요청사항"	, "");//request.getParameter("OrdComment")
	paramData.put("등록자"		, (String)session.getAttribute("sseCustNm"));
	
	System.out.println("==============================================");
	System.out.println("장바구니 담기(cart-ok.jsp) >>>>>>>>>>>>>>>>>>>>>");
	System.out.println("기업코드		: "+paramData.get("기업코드"));
	System.out.println("법인코드		: "+paramData.get("법인코드"));
	System.out.println("브랜드코드	: "+paramData.get("브랜드코드"));
	System.out.println("매장코드		: "+paramData.get("매장코드"));
	System.out.println("홍보물코드	: "+paramData.get("홍보물코드"));
	System.out.println("홍보물번호	: "+paramData.get("홍보물번호"));
	System.out.println("주문수량		: "+paramData.get("주문수량"));
	System.out.println("인쇄사용문구	: "+URLDecoder.decode(paramData.get("인쇄사용문구").toString() , "UTF-8"));
	System.out.println("추가요청사항	: "+URLDecoder.decode(paramData.get("추가요청사항").toString() , "UTF-8"));
	//System.out.println("배송지번호	: "+paramData.get("배송지번호"));
	//System.out.println("배송요청사항	: "+URLDecoder.decode(paramData.get("배송요청사항").toString() , "UTF-8"));
	System.out.println("주문상태		: "+paramData.get("주문상태"));
	System.out.println("등록자		: "+paramData.get("등록자"));
	System.out.println("---------------------------------------------");

	orderBean orderBean  = new orderBean(); //내용보기 에서 담을 빈
	orderDao  orderDao   = new orderDao();

	String orderSeq = "";
	int result = 0;
	String flag = request.getParameter("flag");

	if("I".equals(flag)){
		orderSeq = orderDao.selectOrderSeq(paramData);// 주문번호 채번
		paramData.put("주문번호", orderSeq);

		result = orderDao.insertOrder(paramData);
		if(result > 0){
			result = orderDao.insertCart(paramData);
		}
	} else if("U".equals(flag)){
		orderSeq = request.getParameter("OrdSeq");
		paramData.put("주문번호", orderSeq);
		paramData.put("단위가격", request.getParameter("UnitAmt"));
		
		result = orderDao.updateOrder(paramData);
	} else if("D".equals(flag)){
		orderSeq = request.getParameter("OrdSeq");
		System.out.println("주문번호		: ["+orderSeq+"]");
		
		String ordArray[] = orderSeq.split("\\|");
		for(int i=0; i < ordArray.length; i++){
			paramData.put("주문번호", ordArray[i]);
			
			result = orderDao.deleteOrder(paramData);
			if(result > 0){
				result = orderDao.deleteCart(paramData);
			}
		}
	}
	
	System.out.println("주문번호		: "+paramData.get("주문번호"));
	System.out.println("==============================================");

	out.print("<script>");
	out.print("  parent.fnCartRet('"+result+"');");
	out.print("</script>");
%>