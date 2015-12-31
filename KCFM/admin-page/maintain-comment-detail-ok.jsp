<%
/** ############################################################### */
/** Program ID   : maintain-comment-detail-ok.jsp                   */
/** Program Name : 댓글관리 > 상세화면 > 수정  및 삭제                                           */
/** Program Desc :                                                  */
/** Create Date  : 2015-05-08                                       */
/** Programmer   : JHYOUN                                           */
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

<%@ page import="admin.beans.commentBean" %>
<%@ page import="admin.dao.commentDao" %>

<%@ include file="/com/common.jsp"%>
<%
	String root = request.getContextPath();

	// Session 정보
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sseStoreCd   = JSPUtil.chkNull((String)session.getAttribute("sseStoreCd")  ,""); //매장코드
	String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm")   ,""); //등록자명
	String sseCustId    = JSPUtil.chkNull((String)session.getAttribute("sseCustId")   ,""); //등록자ID
	String sseStroeNm   = JSPUtil.chkNull((String)session.getAttribute("sseStroeNm")  ,""); //매장명
	
	//  Bean 및 Dao 처리
	commentBean bean = null; 
	commentDao  dao  = new commentDao();
	String   msg  = "";
	int rtn = 0;

	String inqGubun   = JSPUtil.chkNull((String)paramData.get("inqGubun"  ),""); //조회구분 (목록으로 갈때 사용)
	String pageGb     = JSPUtil.chkNull((String)request.getParameter("pageGb"), "");     //구분(faq)
	String dataGb     = JSPUtil.chkNull((String)request.getParameter("dataGb"), "");     //구분(new, modify)
	String s기업코드      = JSPUtil.chkNull((String)request.getParameter("pCORP_CD"),  ""); 
	String s법인코드      = JSPUtil.chkNull((String)request.getParameter("pCRPN_CD"),  ""); 
	String s브랜드코드   = JSPUtil.chkNull((String)request.getParameter("pBRND_CD"),  ""); 
	String s매장코드      = JSPUtil.chkNull((String)request.getParameter("pMEST_CD"),  ""); 
	String s게시구분      = JSPUtil.chkNull((String)request.getParameter("pGESI_GB"),  ""); 
	String s게시번호      = JSPUtil.chkNull((String)request.getParameter("pGESI_NO"),  ""); 
	String s댓글번호      = JSPUtil.chkNull((String)request.getParameter("pDAGL_NO"),  "");
	String s댓글내용     = new String(request.getParameter("pDAGL_STMT").getBytes("8859_1"),"UTF-8");  // 한글처리
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	System.out.println(">>>>> [jsp] inqGubun   [" + inqGubun + "]" );
	System.out.println(">>>>> [jsp] dataGb   [" + dataGb + "]" );
	System.out.println(">>>>> [jsp] 기업코드   [" + s기업코드 + "]" );
	System.out.println(">>>>> [jsp] 법인코드   [" + s법인코드 + "]" );
	System.out.println(">>>>> [jsp] 브랜드코드 [" + s브랜드코드 + "]" );
	System.out.println(">>>>> [jsp] 매장코드   [" + s매장코드 + "]" );
	System.out.println(">>>>> [jsp] 게시구분   [" + s게시구분 + "]" );
	System.out.println(">>>>> [jsp] 게시번호   [" + s게시번호 + "]" );
	System.out.println(">>>>> [jsp] 댓글번호   [" + s댓글번호 + "]" );
	System.out.println(">>>>> [jsp] 댓글내용   [" + s댓글내용 + "]" );
	
	paramData.put("기업코드",      s기업코드       );
	paramData.put("법인코드",       s법인코드       );
	paramData.put("브랜드코드",     s브랜드코드     );
	paramData.put("매장코드",       s매장코드       );
	paramData.put("게시구분",       s게시구분       );
	paramData.put("게시번호",       s게시번호       );
	paramData.put("댓글번호",       s댓글번호       );
	paramData.put("댓글내용",       s댓글내용       );
	paramData.put("등록자",         sseCustNm  );
	paramData.put("수정자",         sseCustNm  );
	
	if(dataGb.equals("insert")){	
		rtn = dao.insertComment(paramData);
	}else if(dataGb.equals("modify")) {
		rtn = dao.updateComment(paramData);
	}else {
		rtn = dao.deleteComment(paramData);
	}
	
	if(rtn > 0  )
	{
		msg = "Y";
	}
	else
	{
		msg = "N";
	}

	out.print("<script>");
//	out.print("  parent.fn_update_delete_return(\"" + msg + "\")");
	out.print("  parent.fn_update_delete_return(\"" + inqGubun + "\",\"" + msg + "\")");
	out.print("</script>");
%>