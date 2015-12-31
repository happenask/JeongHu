<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.CreateCombo" %>
<%@ include file="/com/common.jsp"%>
<%@ page import="java.net.URLDecoder" %>
<%@ include file="/com/sessionchk.jsp"%>

<%
	response.setContentType("text/xml");
	response.setCharacterEncoding("utf-8");

	String selGroupCd   = JSPUtil.chkNull((String)request.getParameter("selGroupCd"),""); //기업코드
	String selCorpCd    = JSPUtil.chkNull((String)request.getParameter("selCorpCd"),""); //법인코드
	String selBrandCd   = JSPUtil.chkNull((String)request.getParameter("selBrandCd"),""); //브랜드코드
	String selStoreCd   = JSPUtil.chkNull((String)request.getParameter("selStoreCd")  ,""); //매장코드
	String selType      = JSPUtil.chkNull((String)request.getParameter("selType")  ,"");
	String selCustAuth  = JSPUtil.chkNull((String)request.getParameter("selCustAuth")  ,"");
	
	//System.out.println("기업>>>>>>>>>>>>>>>"+selGroupCd);
	//System.out.println("법인>>>>>>>>>>>>>>>"+selCorpCd);
	//System.out.println("브랜드>>>>>>>>>>>>>>>"+selBrandCd);
	//System.out.println("매장>>>>>>>>>>>>>>>"+selStoreCd);
	//System.out.println("구분>>>>>>>>>>>>>>>"+selType);
	//System.out.println("권한>>>>>>>>>>>>>>>"+selCustAuth);
	
	paramData.put("selGroupCd"  ,selGroupCd);
	paramData.put("selCorpCd"   ,selCorpCd);
	paramData.put("selBrandCd"  ,selBrandCd);
	paramData.put("selStoreCd"  ,selStoreCd);
	paramData.put("selType"     ,selType);
	paramData.put("selCustAuth" ,selCustAuth);
	
	
	CreateCombo ComboDao = new CreateCombo();
	
	if ("G".equals(selType))
	{
		paramData.put("select_tag_id","sel_GroupCd");
		paramData.put("stype","전체");
	}
	else if ("C".equals(selType))
	{
		paramData.put("select_tag_id","sel_CorpCd");
		paramData.put("stype","전체");
	}
	else if ("B".equals(selType))
	{
		paramData.put("select_tag_id","sel_BrandCd");
		paramData.put("stype","전체");
	}
	else if ("S".equals(selType))
	{
		paramData.put("select_tag_id","sel_StoreCd");
		paramData.put("stype","전체");
	}
	
	String combo     = ComboDao.doAction(paramData);
	//System.out.println("combo["+selType+"]>>>>>>>>>>>>>>>"+combo);
	
	out.println(combo);
%>

