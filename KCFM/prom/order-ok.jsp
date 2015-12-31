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
	paramData.put("홍보물코드"	, request.getParameter("PromoCd"));
	paramData.put("홍보물번호"	, request.getParameter("PromoNo"));
	paramData.put("주문수량"		, request.getParameter("OrdQty"));
	paramData.put("인쇄사용문구"	, request.getParameter("PrintMsg"));
	paramData.put("추가요청사항"	, request.getParameter("AddRequst"));
	paramData.put("주문상태"		, request.getParameter("OrdStd"));
	paramData.put("배송지번호"	, request.getParameter("addr_type"));
	paramData.put("배송요청사항"	, request.getParameter("OrdComment"));
	paramData.put("등록자"		, (String)session.getAttribute("sseCustNm"));
	paramData.put("우편번호"			, request.getParameter("OrderZip"));
	paramData.put("우편주소"			, URLDecoder.decode(request.getParameter("OrderBase").toString() , "UTF-8"));
	paramData.put("상세주소"			, URLDecoder.decode(request.getParameter("OrderDetail").toString() , "UTF-8"));
	paramData.put("수취인이름"			, URLDecoder.decode(request.getParameter("OrderName").toString() , "UTF-8"));
	paramData.put("수취인휴대전화번호"	, request.getParameter("OrderCellPhone"));
	paramData.put("수취인전화번호"		, request.getParameter("OrderPhoneNum"));
	paramData.put("최근배송지번호"		, request.getParameter("OrderAddrSeq"));
	
	System.out.println("==============================================");
	System.out.println("최종 주문하기(order-ok.jsp) >>>>>>>>>>>>>>>>>>>>");
	System.out.println("기업코드		: "+paramData.get("기업코드"));
	System.out.println("법인코드		: "+paramData.get("법인코드"));
	System.out.println("브랜드코드	: "+paramData.get("브랜드코드"));
	System.out.println("매장코드		: "+paramData.get("매장코드"));
	System.out.println("홍보물코드	: "+paramData.get("홍보물코드"));
	System.out.println("홍보물번호	: "+paramData.get("홍보물번호"));
	System.out.println("주문수량		: "+paramData.get("주문수량"));
	System.out.println("인쇄사용문구	: "+URLDecoder.decode(paramData.get("인쇄사용문구").toString() , "UTF-8"));
	System.out.println("추가요청사항	: "+URLDecoder.decode(paramData.get("추가요청사항").toString() , "UTF-8"));
	System.out.println("배송지번호	: "+paramData.get("배송지번호"));
	System.out.println("배송요청사항	: "+URLDecoder.decode(paramData.get("배송요청사항").toString() , "UTF-8"));
	System.out.println("주문상태	: "+paramData.get("주문상태"));
	System.out.println("등록자		: "+paramData.get("등록자"));
	System.out.println("최근배송지번호 : "+paramData.get("최근배송지번호"));
	System.out.println("---------------------------------------------");

	orderBean orderBean  = new orderBean(); //내용보기 에서 담을 빈
	orderDao  orderDao   = new orderDao();

	// 새로운 배송지인 경우 [홍보물배송지정보] 테이블에 INSERT 처리 및 [홍보물주문정보] 테이블의 배송지번호 UPDATE
	// 배송지 채번
	String addrSeq = "";
	
	int result = 0;
	if ("new".equals(paramData.get("배송지번호").toString())){// 새로운 배송지		

		System.out.println("==============================================");
		System.out.println("새로운 배송지 정보 >>>>>>>>>>>>>>>>>>>>");
		System.out.println("배송지번호	: "+paramData.get("배송지번호"));
		System.out.println("우편주소	: "+paramData.get("우편주소"));
		System.out.println("상세주소	: "+paramData.get("상세주소"));
		System.out.println("수취인이름	: "+paramData.get("수취인이름"));
		System.out.println("수취인휴대전화번호	: "+paramData.get("수취인휴대전화번호"));
		System.out.println("수취인전화번호	    : "+paramData.get("수취인전화번호"));
		System.out.println("==============================================");
		
		deliveryBean deliveryBean  = new deliveryBean(); //내용보기 에서 담을 빈
		deliveryDao  deliveryDao   = new deliveryDao();
		
		addrSeq = deliveryDao.selectAddrSeq(paramData);

		paramData.put("배송지번호", addrSeq);
		
		
		
		result = deliveryDao.insertNewAddr(paramData);
	}
	if ("past".equals(paramData.get("배송지번호").toString())){// 새로운 배송지		
		System.out.println("==============================================");
		System.out.println("최근 배송지 정보 >>>>>>>>>>>>>>>>>>>>");
		System.out.println("최근배송지번호 : "+paramData.get("최근배송지번호"));
		System.out.println("==============================================");
		
		paramData.put("배송지번호", paramData.get("최근배송지번호"));
	}
		
	// 주문번호 채번
	String orderSeq = "";

	if("01".equals(paramData.get("주문상태").toString())){// 바로구매
		orderSeq = orderDao.selectOrderSeq(paramData);
		paramData.put("주문번호", orderSeq);
		
		
		result = orderDao.insertOrder(paramData);
	} else { // 장바구니
		orderSeq = request.getParameter("OrdSeq");
		paramData.put("주문번호", orderSeq);
		paramData.put("주문상태", "01");

		System.out.println("배송지번호		: "+paramData.get("배송지번호"));
		System.out.println("==============================================");
			
		result = orderDao.updateOrder01(paramData);//주문정보
		if(result > 0){
			result = orderDao.updateCart01(paramData); //장바구니
		}
	}
	System.out.println("주문번호		: "+paramData.get("주문번호"));
	System.out.println("==============================================");
	

	
	out.print("<script>");
	out.print("  parent.fnOrderRet('"+result+"')");
	out.print("</script>");

%>