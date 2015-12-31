<%
/** ############################################################### */
/** Program ID   : maintain-faq-del-ok.jsp                          */
/** Program Name : 자주하는질문내역 삭제 (삭제여부=Y 처리)                 */
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
	
	String pageGb     = JSPUtil.chkNull((String)request.getParameter("pageGb") ,   ""); 
	String s기업코드      = JSPUtil.chkNull((String)request.getParameter("pCORP_CD"),   ""); 
	String s법인코드      = JSPUtil.chkNull((String)request.getParameter("pCRPN_CD"),   ""); 
	String s브랜드코드   = JSPUtil.chkNull((String)request.getParameter("pBRND_CD"), ""); 
	String s질문번호      = JSPUtil.chkNull((String)request.getParameter("pFAQ_NO") ,   ""); 
	
	
	paramData.put("기업코드",       s기업코드       );
	paramData.put("법인코드",       s법인코드       );
	paramData.put("브랜드코드",     s브랜드코드     );
	paramData.put("질문번호",       s질문번호      );
	
	System.out.println("##### pageGb ###### [" + pageGb.toString() + "] \n" );
	System.out.println("##### 기업코드 ###### [" + s기업코드.toString() + "] \n" );
	System.out.println("##### 법인코드 ###### [" + s법인코드.toString() + "] \n" );
	System.out.println("##### 브랜드코드 ###### [" + s브랜드코드.toString() + "] \n" );
	System.out.println("##### 질문번호 ###### [" + s질문번호.toString() + "] \n" );

	rtn = dao.deleteFaq(paramData);
	
	if(rtn > 0  )
	{
		msg = "Y";
	}
	else
	{
		msg = "N";
	}

//	out.println(msg);
	
	out.print("<script>");
	out.print("  parent.fn_update_delete_return(\"" + msg + "\")");
	out.print("</script>");
	
%>