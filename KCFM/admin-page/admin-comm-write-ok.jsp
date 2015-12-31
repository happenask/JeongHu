<%
/** ############################################################### */
/** Program ID   : admin-comm-write-ok.jsp                          */
/** Program Name : 관리자 - 각 게시글 > 댓글 입력                   */
/** Program Desc : 각 게시글 댓글 입력                              */
/** Create Date  : 2015.04.16                                       */
/** Programmer   : HJCHOI                                           */
/** Programmer   : Hojun.Choi                                       */
/** Update Date  : 2015.05.15                                       */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="admin.beans.adminBean" %>
<%@ page import="admin.dao.adminDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ include file="/com/common.jsp"%>
<%@ page import="java.net.URLEncoder" %>
<% 
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-comm-write-ok.jsp");
	String root = request.getContextPath();
	
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),""); //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),""); //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),""); //브랜드코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),""); //등록자명
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),""); //매장코드명
	
	//--------------------------------------------------------------------------------------------------
	// Parameter 정보
	//--------------------------------------------------------------------------------------------------
	String comment 		  = new String(request.getParameter("comm_write").getBytes("8859_1"),"UTF-8");   //글내용
	String listNum        = JSPUtil.chkNull((String)request.getParameter("listNum"), "");                //게시번호
	String pageGb         = JSPUtil.chkNull((String)request.getParameter("pageGb" ), "");                //게시구분
	String StartDate 	  = JSPUtil.chkNull((String)request.getParameter("sDate")  , ""); 				 //조회시작일자
	String EndDate   	  = JSPUtil.chkNull((String)request.getParameter("eDate")  , "");                //조회종료일자
	String srch_key       = JSPUtil.chkNull((String)paramData.get("srch_key"   )   , "");                //검색어
	String srch_type      = JSPUtil.chkNull((String)paramData.get("srch_type"  )   ,"0");                //검색종류
	String QryGubun   	  = JSPUtil.chkNull((String)paramData.get("inqGubun"   )   ,"%");                //조회구분
	String statusGubun    = JSPUtil.chkNull((String)paramData.get("statusGubun")   ,"%");            	 //조회구분
	String sseStoreCd     = JSPUtil.chkNull((String)paramData.get("sseStoreCd" )   , ""); 				 //매장코드
	int    inCurPage      = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1")); // 현재 페이지
	int    inCurBlock     = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1")); // 현재 블럭
		
	
	//--------------------------------------------------------------------------------------------------
	// admin 리스트 생성
	//--------------------------------------------------------------------------------------------------
    adminBean bean = null; 
	adminDao  dao  = new adminDao();
	String   msg   = "";
	int rtn = 0;
	
	srch_key = URLEncoder.encode(srch_key);
	
	
	int check = Integer.parseInt(pageGb);
	System.out.println ("=======================================================");
	System.out.println ("comment        : " + comment        );
	System.out.println ("sseGroupCd     : " + sseGroupCd     );
	System.out.println ("sseCorpCd      : " + sseCorpCd      );
	System.out.println ("sseBrandCd     : " + sseBrandCd     );
	System.out.println ("sseCustStoreCd : " + sseCustStoreCd );
	System.out.println ("sseCustNm      : " + sseCustNm      );
	System.out.println ("sseCustStoreCd : " + sseCustStoreCd );
	System.out.println ("pageGb         : " + pageGb 		 );
	System.out.println ("inCurPage      : " + inCurPage      );
	System.out.println ("inCurBlock     : " + inCurBlock     );
	System.out.println ("srch_key       : " + srch_key       );
	System.out.println ("srch_type      : " + srch_type      );
	System.out.println ("sDate          : " + StartDate      );
	System.out.println ("eDate          : " + EndDate        );
	System.out.println ("inqGubun       : " + QryGubun       );
	System.out.println ("statusGubun    : " + statusGubun    );
	System.out.println ("sseStoreCd     : " + sseStoreCd     );
	System.out.println ("=======================================================");

	//--------------------------------------------------------------------------------------------------
	// Parameter 값 입력
	//--------------------------------------------------------------------------------------------------
	paramData.put("comment"       ,  comment       );
	paramData.put("sseGroupCd"    ,  sseGroupCd    );
	paramData.put("sseCorpCd"     ,  sseCorpCd     );
	paramData.put("sseBrandCd"    ,  sseBrandCd    );
	paramData.put("sseCustNm"     ,  sseCustNm     );
	paramData.put("sseCustStoreCd",  sseCustStoreCd);
	paramData.put("listNum"       ,  listNum       );
	paramData.put("pageGb"		  ,  pageGb		   );
	paramData.put("inCurPage"     ,  inCurPage     );
	paramData.put("inCurBlock"    ,  inCurBlock    );
	paramData.put("srch_key"      ,  srch_key      );
	paramData.put("srch_type"     ,  srch_type     );
	paramData.put("sDate"		  ,  StartDate     );
    paramData.put("eDate"		  ,  EndDate       );
    paramData.put("inqGubun"	  ,  QryGubun      );
    paramData.put("statusGubun"   ,  statusGubun   );
    paramData.put("sseStoreCd"    ,  sseStoreCd    );
	
    //--------------------------------------------------------------------------------------------------
	// Page 구분
	//--------------------------------------------------------------------------------------------------
	if(pageGb.equals("01"))
	{
		System.out.println("1");
		rtn = dao.insertCommWrite(paramData);
		System.out.println ("INSERT_insertCommWrite1  : "+rtn);
		response.sendRedirect(root+"/admin-page/admin-main.jsp?listNum="+ listNum + "&pageGb=" + pageGb + "&srch_key=" + srch_key + "&srch_type=" + srch_type + "&sDate=" + StartDate + "&eDate=" + EndDate+ "&statusGubun=" + statusGubun );
	}else if(pageGb.equals("02") )
	{
		System.out.println("2");
		rtn = dao.insertCommWrite(paramData);
		System.out.println ("INSERT_insertCommWrite2  : "+rtn);
		response.sendRedirect(root+"/admin-page/admin-main.jsp?listNum="+ listNum + "&pageGb=" + pageGb + "&srch_key=" + srch_key + "&srch_type=" + srch_type + "&sDate=" + StartDate + "&eDate=" + EndDate+ "&statusGubun=" + statusGubun );
	}else if(pageGb.equals("11"))
	{
		System.out.println("3");
		rtn = dao.reUpdateProposalCommWrite(paramData);
		rtn = dao.insertProposalCommWrite(paramData);
		System.out.println ("INSERT_insertProposalCommWrite1  : "+rtn);
		response.sendRedirect(root+"/admin-page/admin-main.jsp?listNum="+ listNum + "&pageGb=" + pageGb + "&srch_key=" + srch_key + "&srch_type=" + srch_type + "&sDate=" + StartDate + "&eDate=" + EndDate+ "&statusGubun=" + statusGubun + "&inqGubun=" + QryGubun);
	}else if(pageGb.equals("12") )
	{
		System.out.println("4");
		rtn = dao.reUpdateProposalCommWrite(paramData);
		rtn = dao.insertProposalCommWrite(paramData);
		System.out.println ("INSERT_insertProposalCommWrite2  : "+rtn);
		System.out.println ("INSERT_insertProposalCommWrite2  : "+rtn);
		response.sendRedirect(root+"/admin-page/admin-main.jsp?listNum="+ listNum + "&pageGb=" + pageGb + "&srch_key=" + srch_key + "&srch_type=" + srch_type + "&sDate=" + StartDate + "&eDate=" + EndDate+ "&statusGubun=" + statusGubun + "&inqGubun=" + QryGubun);
	}
	
	out.println(msg);
	
%>