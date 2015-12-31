<%
/** ############################################################### */
/** Program ID   : changeCorpCd.jsp                                 */
/** Program Name : 기업,법인코드로 브랜드코드 조회                         */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="prom_mnt.beans.promBean" %> 
<%@ page import="prom_mnt.dao.promDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>

<% 
	
	com.util.Log4u log4u = new com.util.Log4u();

	String root = request.getContextPath();

	promBean bean = null; 
	promDao  dao  = new promDao();
	ArrayList<promBean> list = null;
	
	
	String sseCustAuth  = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth"),  ""); //권한코드
	String hSelectGubun = JSPUtil.chkNull((String)request.getParameter("hSelectGubun"), ""); //select box 조회 구분값
	String groupCd      = JSPUtil.chkNull((String)request.getParameter("inCompanyCd"),  ""); //기업코드
	String corpCd       = JSPUtil.chkNull((String)request.getParameter("inCorpCd"),     ""); //법인코드
	
// 	System.out.println("-----------------[홍보물코드관리 select box]------------------");
// 	System.out.println("#### sseCustAuth  : " + sseCustAuth);
// 	System.out.println("#### hSelectGubun : " + hSelectGubun);
// 	System.out.println("#### groupCd      : " + groupCd);
// 	System.out.println("#### corpCd       : " + corpCd);

	
	String msg      = "";
	String listCode = "";
	String listNm   = "";
	
	
	if("corp".equals(hSelectGubun)){ //법인조회
		list = dao.selectCorpCd(groupCd, sseCustAuth);
		
		String listGroupCd = "";
	
		if( list != null && list.size() > 0 ) 
		{
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (promBean) list.get(i);
			  
				listCode = JSPUtil.chkNull(bean.get법인코드());
				listNm = JSPUtil.chkNull(bean.get법인명());
				
				if("90".equals(sseCustAuth)){
					listGroupCd = JSPUtil.chkNull(bean.get기업코드());
					listCode = listCode+"-"+listGroupCd;
				}
				
			    msg += "<option value='"+listCode+"'>"+listNm+"</option>";
			}
		}else{
				msg += "<option value=''>조회데이타없음</option>";
		}
	}else if("brand".equals(hSelectGubun)){ //브랜드조회
		list = dao.selectBrandCd(groupCd, corpCd, sseCustAuth);
		
		if( list != null && list.size() > 0 ) 
		{
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (promBean) list.get(i);
			  
				listCode = JSPUtil.chkNull(bean.get브랜드코드());
				listNm = JSPUtil.chkNull(bean.get브랜드명());
				
			    msg += "<option value='"+listCode+"'>"+listNm+"</option>";
			}
		}else{
				msg += "<option value=''>조회데이타없음</option>";
		}
	}
	
	
	out.println(msg);
	
%>