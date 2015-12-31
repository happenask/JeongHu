<%
/** ############################################################### */
/** Program ID   : maitain-faq-new-ok.jsp                           */
/** Program Name : FAQ 관리 >> 신규등록                                                               */
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
	
	String pageGb     = JSPUtil.chkNull((String)request.getParameter("pageGb"), "");     //구분(faq)
	String dataGb     = JSPUtil.chkNull((String)request.getParameter("dataGb"), "");     //구분(new, modify)
	String s기업코드      = JSPUtil.chkNull((String)request.getParameter("기업코드"),  ""); 
	String s법인코드      = JSPUtil.chkNull((String)request.getParameter("법인코드"),  ""); 
	String s브랜드코드   = JSPUtil.chkNull((String)request.getParameter("브랜드코드"),  ""); 
	String s질문번호      = JSPUtil.chkNull((String)request.getParameter("질문번호"),  ""); 
	String s질문내용      = JSPUtil.chkNull((String)request.getParameter("질문내용"),  ""); 
	String s답변내용      = JSPUtil.chkNull((String)request.getParameter("답변내용"),  ""); 
	String s등록자         = JSPUtil.chkNull((String)request.getParameter("등록자"),  ""); 
//	String sseGroupCd  = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
//	String sseCorpCd   = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
//	String sseBrandCd  = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
//	String sseCustNm   = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"),""); //등록자명
	
	
	paramData.put("기업코드",       s기업코드       );
	paramData.put("법인코드",       s법인코드       );
	paramData.put("브랜드코드",     s브랜드코드     );
	paramData.put("질문번호",       s질문번호      );
	paramData.put("질문내용",       s질문내용       );
	paramData.put("답변내용",       s답변내용       );
	paramData.put("등록자",         s등록자       );
	
//	paramData.put("sseGroupCd",  sseGroupCd   );
//	paramData.put("sseCorpCd",   sseCorpCd    );
//	paramData.put("sseBrandCd",  sseBrandCd   );
//	paramData.put("sseCustNm",   sseCustNm    );
//	paramData.put("listNum",     listNum      );

//	System.out.println("##### maintain-faq-new-ok dataGbxx###### [" + dataGb.toString() + "] \n" );
//	System.out.println("##### 질문번호 ###### [" + s질문번호.toString() + "] \n" );

	//if("".equals(dataGb)){
	if(dataGb.equals("new")){	
		rtn = dao.insertFaq(paramData);
	}else {
		rtn = dao.updateFaq(paramData);
	}
	
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