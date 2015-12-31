<%
/** ############################################################### */
/** Program ID   : admin-store-select.jsp                           */
/** Program Name : 매장선택 > 처리                                                                         */
/** Program Desc :                                                  */
/** Create Date  : 2015-04-22                                       */
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

<%@ page import="admin.beans.storeBean" %>
<%@ page import="admin.dao.storeDao" %>

<%@ include file="/com/common.jsp"%>
<%
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-store-select-ok.jsp");
	String root = request.getContextPath();

	//-------------------------------------------------------------------------------------------------------
	//  Session 정보
	//-------------------------------------------------------------------------------------------------------
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sseStoreCd   = JSPUtil.chkNull((String)session.getAttribute("sseStoreCd")  ,""); //매장코드
	String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm")   ,""); //등록자명
	String sseCustId    = JSPUtil.chkNull((String)session.getAttribute("sseCustId")   ,""); //등록자ID
	String sseStroeNm   = JSPUtil.chkNull((String)session.getAttribute("sseStroeNm")  ,""); //매장명

	//-------------------------------------------------------------------------------------------------------
	//  조회를 위한 DATA INTERFACE (배열처리시 사용 : request.getParameterValues("pMEST_CD"))
	//-------------------------------------------------------------------------------------------------------
	String   pageGb    = JSPUtil.chkNull((String)paramData.get("pageGb"),    "");           //게시판 구분
	String   dataGb    = JSPUtil.chkNull((String)request.getParameter("dataGb")  , "");     //데이터구분
	String   pBOARD_NO = JSPUtil.chkNull((String)request.getParameter("pBOARD_NO"), "");    //게시번호

	String   vCORP_CD  = JSPUtil.chkNull((String)request.getParameter("pCORP_CD"), "");     //기업코드 
	String   vCRPN_CD  = JSPUtil.chkNull((String)request.getParameter("pCRPN_CD"), "");     //법인코드 
	String   vBRND_CD  = JSPUtil.chkNull((String)request.getParameter("pBRND_CD"), "");     //브랜드코드 
	String   vMEST_CD  = JSPUtil.chkNull((String)request.getParameter("pMEST_CD"), "");     //매장코드(구분자포함)

	String[] pCORP_CD  = vCORP_CD.split(",");                                               //기업코드(배열처리)
	String[] pCRPN_CD  = vCRPN_CD.split(",");                                               //법인코드(배열처리)
	String[] pBRND_CD  = vBRND_CD.split(",");                                               //브랜드코드(배열처리)
	String[] pMEST_CD  = vMEST_CD.split(",");                                               //매장코드(배열처리)
	
	//-------------------------------------------------------------------------------------------------------
	//  Bean 및 Dao 처리
	//-------------------------------------------------------------------------------------------------------
	storeBean bean = null; 
	storeDao  dao  = new storeDao();
	String   msg  = "";
	int rtn = 0;
	int rowCount = 0;
	
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	//System.out.println(">>>>> [jsp] pageGb   [" + pageGb   + "]" );
	//System.out.println(">>>>> [jsp] dataGb   [" + dataGb   + "]" );
	//System.out.println(">>>>> [jsp] 기업코드     [" + pCORP_CD + "]" );
	//System.out.println(">>>>> [jsp] 법인코드     [" + pCRPN_CD + "]" );
	//System.out.println(">>>>> [jsp] 브랜드코드   [" + pBRND_CD + "]" );
	//System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );

	//-------------------------------------------------------------------------------------------------------
	//  팝업 (재)기동시 데이터 삭제처리 (확인이 되지 않은 자료에 대하여 삭제처리)
	//-------------------------------------------------------------------------------------------------------
	//paramData.put("기업코드",    pCORP_CD);
	//paramData.put("법인코드",    pCRPN_CD);
	//paramData.put("브랜드코드",  pBRND_CD);
	paramData.put("게시구분",    pageGb );
	paramData.put("게시번호",    pBOARD_NO );


	for (int i=0; i< pMEST_CD.length; i++)
	{
		paramData.put("기업코드",    pCORP_CD[i]);
		paramData.put("법인코드",    pCRPN_CD[i]);
		paramData.put("브랜드코드",  pBRND_CD[i]);

    	//삭제를 먼저 실행
    	rtn = dao.deleteStore(paramData);
    	System.out.println("rtn 리스트 삭제 했습니다. : "+ rtn);
	}	

	//rtn = dao.deleteStoreSelect(paramData);
	//System.out.println("rtn 리스트 삭제 했습니다. : "+ rtn);
	//-------------------------------------------------------------------------------------------------------
	//  게시배포정보에 대한 INSERT 처리
	//-------------------------------------------------------------------------------------------------------
	for (int i=0; i< pMEST_CD.length; i++)
	{
		paramData.put("기업코드",    pCORP_CD[i]);
		paramData.put("법인코드",    pCRPN_CD[i]);
		paramData.put("브랜드코드",  pBRND_CD[i]);
		paramData.put("매장코드",    pMEST_CD[i]);
		
		//---------------------------------------------------------------------------------------------------
		//  신규등록인 경우의 처리
		//---------------------------------------------------------------------------------------------------
	    if(dataGb.equals("new")){
			rtn = dao.insertStoreSelect(paramData);
			rowCount = rowCount + rtn;             
			System.out.println(">>>>> 처리점포 new 일 경우[" + rowCount + "]");
	    } 	

		//---------------------------------------------------------------------------------------------------
		//  수정등록인 경우의 처리 (삭제시 확인된 자료는 삭제처리를 안함, merge 문에 의한 처리)
		//---------------------------------------------------------------------------------------------------
	    if(dataGb.equals("modify")){	
	    	
			rtn = dao.updateStoreSelect(paramData); 
			rowCount = rowCount + rtn;             
	    } 	
	}
	
	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );
	System.out.println(">>>>> 처리점포 [" + rowCount + "]");
	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );

//	System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );
	
//    if(dataGb.equals("new")){	
//		rtn = dao.insertStoreSelect(paramData);
//	}else {
//		rtn = dao.deleteComment(paramData);
//	}
	
//	if(rtn > 0  )
//	{
//		msg = "Y";
//	}
//	else
//	{
//		msg = "N";
//	}

	out.print("<script>");
	out.print("  parent.goSave_return(\"" + rowCount + "\")");
//	out.print("  parent.goSave_return(\"" + rowCount + "\",\"" + msg + "\")");
	out.print("</script>");
%>