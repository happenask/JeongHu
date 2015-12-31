<%
/** ############################################################### */
/** Program ID   : faq_list_ok.jsp                                  */
/** Program Name : FAQ 조회수 수정                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="admin.beans.faqBean" %>
<%@ page import="admin.dao.faqDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ include file="/com/common.jsp"%>

<% 

	String root = request.getContextPath();

	faqBean bean = null; 
	faqDao  dao  = new faqDao();
	String   msg  = "";
	int rtn = 0;
	
	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	
	rtn = dao.updateFaqCnt(paramData);
	
	if(rtn > 0  )
	{
		msg = "Y";
	}
	else
	{
		msg = "N";
	}

	out.println(msg);
	
%>