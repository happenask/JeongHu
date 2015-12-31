<%
/** ############################################################### */
/** Program ID   : admin-writing_ok.jsp                             */
/** Program Name : 게시글 삭제 		                     			*/
/** Program Desc : 공지사항,교육자료 게시글 삭제                    */
/** Create Date  : 2015.04.10                                       */
/** Programmer   : hojun.choi                                       */
/** Update Date  : 2015.04.28                                       */
/** ############################################################### */
%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="admin.beans.adminBean" %> 
<%@ page import="admin.dao.adminDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="/com/common.jsp"%>

<% 	
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-delete-ok.jsp");
	
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	
	String sGroupCode   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sCorpCode    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sBrandCode   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sCustLoginNm = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"   ),""); //등록자명
	
	//--------------------------------------------------------------------------------------------------
  	// 파라미터 인코딩
  	//--------------------------------------------------------------------------------------------------

  	request.setCharacterEncoding("UTF-8");
  	String encType = "UTF-8";
	
	//--------------------------------------------------------------------------------------------------
	// Parameter 정보
	//--------------------------------------------------------------------------------------------------
	
	String sTitle       = JSPUtil.chkNull((String)request.getParameter("title"       ), "" ); //제목
	String sComment     = JSPUtil.chkNull((String)request.getParameter("comment"     ), "" ); //글내용
	String sSeqNum      = JSPUtil.chkNull((String)request.getParameter("seqNum"      ), "" ); //글 순번//
	String spageGb      = JSPUtil.chkNull((String)request.getParameter("pageGb"      ), "" ); //게시구분//
	String srch_key     = JSPUtil.chkNull((String)request.getParameter("srch_key"    ), "" ); //검색어
	String srch_type    = JSPUtil.chkNull((String)request.getParameter("srch_type"   ), "0"); //검색종류
	String StartDate 	= JSPUtil.chkNull((String)request.getParameter("sDate"       ), "" ); //조회시작일자
	String EndDate   	= JSPUtil.chkNull((String)request.getParameter("eDate"       ), "" ); //조회종료일자
	String listNum      = JSPUtil.chkNull((String)request.getParameter("listNum"     ), "" ); //글 순번//
	int    inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurPage"),  "1"));
	
	srch_key = URLEncoder.encode(srch_key);
	//--------------------------------------------------------------------------------------------------
	// 초기값 초기화
	//--------------------------------------------------------------------------------------------------

	String    root = request.getContextPath();
	adminBean bean = null; 
	adminDao  dao  = new adminDao();
	String    msg  = "";
	int 	  rtn  = 0;	
	
	paramData.put("title",          sTitle       );
	paramData.put("comment",        sComment     );
	paramData.put("sseGroupCode",   sGroupCode   );
	paramData.put("sseCorpCode",    sCorpCode    );
	paramData.put("sseBrandCode",   sBrandCode   );
	paramData.put("sseCustNm",      sCustLoginNm );
	paramData.put("listNum",        listNum      );
	paramData.put("pageGb",         spageGb      );
	paramData.put("srch_type", 		srch_type    );
    paramData.put("srch_key", 		srch_key     );
    paramData.put("sDate", 	    	StartDate    );
    paramData.put("eDate", 	    	EndDate      );
	
	System.out.println("paramData : " +paramData);
	//--------------------------------------------------------------------------------------------------
	// 게시구분의 따른 삭제 
	//--------------------------------------------------------------------------------------------------

	 if(spageGb.equals("11")||spageGb.equals("12"))
	 {
		 rtn = dao.deleteProposalWrite(paramData);		
	 }
	 else if (spageGb.equals("01")||spageGb.equals("02"))
	 {
		 rtn = dao.deleteWrite(paramData);
 	 }
	
	 response.sendRedirect(root+"/admin-page/admin-main.jsp?listNum="+ listNum + "&pageGb=" + spageGb + "&srch_key=" + srch_key + "&srch_type=" + srch_type + "&inCurPage=" + inCurPage+ "&sDate=" + StartDate+ "&eDate=" + EndDate);
	 
	 if(rtn > 0  )
		{
			msg = "Admin_Delete_Ok";
		}
		else
		{	
			msg = "Admin_Delete_Err";	
		}

		out.println(msg);
%>
