<%
/** ############################################################### */
/** Program ID   : listwrite_ok.jsp                                   */
/** Program Name : 글저장                                           */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.testDao" %>
<%@ page import="test.beans.testBean" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ include file="/com/common.jsp"%>

<% 
	

	String root = request.getContextPath();

	testBean bean = null; 
	testDao  dao  = new testDao();
	String   msg  = "";
	int rtn = 0;
	
	//ArrayList<testBean> list = null;
	
	String sTitle       = JSPUtil.chkNull((String)request.getParameter("title"),  ""); //제목
	String sComment     = JSPUtil.chkNull((String)request.getParameter("comment"),""); //글내용
	
	String sGroupCode   = JSPUtil.chkNull((String)session.getAttribute("groupCode"  ),""); //기업코드
	String sCorpCode    = JSPUtil.chkNull((String)session.getAttribute("corpCode"   ),""); //법인코드
	String sBrandCode   = JSPUtil.chkNull((String)session.getAttribute("brandCode"  ),""); //브랜드코드
	String sCustLoginNm = JSPUtil.chkNull((String)session.getAttribute("custLoginNm"),""); //등록자명 
	
	String sSeqNum      = JSPUtil.chkNull((String)request.getParameter("seqNum"),""); //글 순번
	
	
	paramData.put("title",       sTitle       );
	paramData.put("comment",     sComment     );
	paramData.put("groupCode",   sGroupCode   );
	paramData.put("corpCode",    sCorpCode    );
	paramData.put("brandCode",   sBrandCode   );
	paramData.put("custLoginNm", sCustLoginNm );
	paramData.put("seqNum",      sSeqNum      );

	if("".equals(sSeqNum)){
		rtn = dao.insertWrite(paramData);
	}else {
		rtn = dao.updateWrite(paramData);
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