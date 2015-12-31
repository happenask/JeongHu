<%
/** ############################################################### */
/** Program ID   : admin-store-select-combo.jsp                     */
/** Program Name : 매장선택 > 콤보박스 처리(기업, 법인, 브랜드)            */
/** Program Desc :                                                  */
/** Create Date  : 2015-05-13                                       */
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
	log4u.log("CALL /admin-store-select-combo.jsp");
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
	String sseCustAuth  = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth"));
	//-------------------------------------------------------------------------------------------------------
	//  조회를 위한 DATA INTERFACE (배열처리시 사용 : request.getParameterValues("pMEST_CD"))
	//-------------------------------------------------------------------------------------------------------
	String   comboGb    = JSPUtil.chkNull((String)request.getParameter("comboGb")  , "");   //콤보구분(기업,법인,브랜드)
	String   pCORP_CD  = JSPUtil.chkNull((String)request.getParameter("pCORP_CD"), "");     //기업코드 
	String   pCRPN_CD  = JSPUtil.chkNull((String)request.getParameter("pCRPN_CD"), "");     //법인코드 
	
	//-------------------------------------------------------------------------------------------------------
	//  Bean 및 Dao 처리
	//-------------------------------------------------------------------------------------------------------
	storeBean comboBean = null;                                                             // 대상점포선택 Bean
	storeDao  comboDao  = new storeDao();
	ArrayList<storeBean> comboList = null;
	
	String   msg  = "";
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	//System.out.println(">>>>> [jsp] comboGb  [" + comboGb  + "]" );
	//System.out.println(">>>>> [jsp] 기업코드     [" + pCORP_CD + "]" );
	//System.out.println(">>>>> [jsp] 법인코드     [" + pCRPN_CD + "]" );
	//System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );

	//-------------------------------------------------------------------------------------------------------
	//  팝업 (재)기동시 데이터 삭제처리 (확인이 되지 않은 자료에 대하여 삭제처리)
	//-------------------------------------------------------------------------------------------------------
	paramData.put("기업코드",    pCORP_CD);
	paramData.put("법인코드",    pCRPN_CD);
	paramData.put("권한코드",    sseCustAuth);

	//-------------------------------------------------------------------------------------------------------
	//  업무별 데이터 처리
	//-------------------------------------------------------------------------------------------------------
   	if(comboGb.equals("CORP")){
   	comboList  = comboDao.selectCORP_ComboList(paramData);                      // 조회조건에 맞는 기업정보 조회
	   	if( comboList != null && comboList.size() > 0 ) 
		{
	   		if(sseCustAuth.equals("90")){
	   			msg += "<option value='%'>전체</option>";	
	   		}
	    	for( int i = 0; i < comboList.size(); i++ ) 
	    	{
	    		comboBean = (storeBean) comboList.get(i);
	            msg = msg + "    <option value=" + comboBean.get기업코드() + ">" + comboBean.get기업명() + "</option>";
	    	}
		}else{
			msg += "<option value=''>조회데이타없음</option>";
		}
    } else if(comboGb.equals("CRPN")){
    	comboList  = comboDao.selectCRPN_ComboList(paramData);                      // 조회조건에 맞는 법인정보 조회
    	if( comboList != null && comboList.size() > 0 ) 
		{
	   		if(sseCustAuth.equals("90")){
	   			msg += "<option value='%'>전체</option>";	
	   		}
	    	for( int i = 0; i < comboList.size(); i++ ) 
	    	{
	    		comboBean = (storeBean) comboList.get(i);
	            msg = msg + "    <option value=" + comboBean.get법인코드() + ">" + comboBean.get법인명() + "</option>";
	    	}
		}else{
			msg += "<option value=''>조회데이타없음</option>";
		}
    } else if(comboGb.equals("BRND")){
    	comboList  = comboDao.selectBRND_ComboList(paramData);                      // 조회조건에 맞는 브랜드정보 조회
    	if( comboList != null && comboList.size() > 0 ) 
		{
	   		if(sseCustAuth.equals("90")){
	   			msg += "<option value='%'>전체</option>";	
	   		}
	    	for( int i = 0; i < comboList.size(); i++ ) 
	    	{
	    		comboBean = (storeBean) comboList.get(i);
	            msg = msg + "    <option value=" + comboBean.get브랜드코드() + ">" + comboBean.get브랜드명() + "</option>";
	    	}
		}else{
			msg += "<option value=''>조회데이타없음</option>";
		}
    }
	//System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );
	//System.out.println(">>>>> (콤보)처리문장 [" + msg + "]");
	//System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );

	out.print("<script>");
	out.print("  parent.fnCombo_Return(\"" + msg + "\")");
	out.print("</script>");
%>