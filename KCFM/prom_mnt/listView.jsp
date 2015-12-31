<%
/** ############################################################### */
/** Program ID   : maintain-prom-cd-middleCdView.jsp                */
/** Program Name : 로그인                                           */
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
	
	String gubun     = JSPUtil.chkNull((String)request.getParameter("gubun"),       "");
	String companyCd = JSPUtil.chkNull((String)request.getParameter("inCompanyCd"), "");
	String corpCd    = JSPUtil.chkNull((String)request.getParameter("inCorpCd"),    "");
	String brandCd   = JSPUtil.chkNull((String)request.getParameter("inBrandCd"),   "");
	String menuCd    = JSPUtil.chkNull((String)request.getParameter("inMenuCd"),    "");
	
	
	if("middle".equals(gubun)){
		list = dao.selectPromMiddleList(companyCd, corpCd, brandCd, menuCd);
	
		String msg      = "";
		String middleCd = "";
		String middleNm = "";
		
		if( list != null && list.size() > 0 ) 
		{
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (promBean) list.get(i);
			  
				middleCd = JSPUtil.chkNull(bean.get메뉴코드());
				middleNm = JSPUtil.chkNull(bean.get메뉴코드명());
				
				msg += "<tr>";
				msg += "<td width='30' ><input type='checkbox' name='middleChk' ></td>"; 
				msg += "<td width='130'><input type='text' name='middleMenuCd' value='"+middleCd+"' style='width: 120px;' onchange='fnMiddleCdCheck(this);' disabled='disabled'></td>"; 
				msg += "<td width='210'><input type='text' name='middleMenuNm' value='"+middleNm+"' style='width: 200px;' onchange='fnMiddleNmCheck(this);'></td>";
			    msg += "</tr>";
			}
		}else{
				msg += "<tr>";
				msg += "<td colspan='3'>조회된 내용이 없습니다.</td>";
				msg += "</tr>";
		}
		
		out.println(msg);
		
	}else if("large".equals(gubun)){
		
		list = dao.selectPromList(companyCd, corpCd, brandCd); //조회조건에 맞는 이벤트 리스트
		
			String listCompanyCd    = ""; //기업코드
			String listCompanyNm    = ""; //기업명
			String listCorpCd       = ""; //법인코드
			String listCorpNm       = ""; //법인명
			String listBrandCd      = ""; //브랜드코드
			String listBrandNm      = ""; //브랜드명
			String listMenuCd       = ""; //메뉴코드
			String listMenuNm       = ""; //메뉴코드명
			String listParentMenuCd = ""; //상위메뉴코드명
			
			String msg = "";
			
			
			if(list != null && list.size() > 0){
				for( int i = 0; i < list.size(); i++ ) 
				{
					bean = (promBean) list.get(i);
					
					listCompanyCd    = JSPUtil.chkNull(bean.get기업코드(),     "");
					listCompanyNm    = JSPUtil.chkNull(bean.get기업명(),       "");
					listCorpCd       = JSPUtil.chkNull(bean.get법인코드(),     "");
					listCorpNm       = JSPUtil.chkNull(bean.get법인명(),       "");
					listBrandCd      = JSPUtil.chkNull(bean.get브랜드코드(),   "");
					listBrandNm      = JSPUtil.chkNull(bean.get브랜드명(),     "");
					listMenuCd       = JSPUtil.chkNull(bean.get메뉴코드(),     "");
					listMenuNm       = JSPUtil.chkNull(bean.get메뉴코드명(),   "");
					listParentMenuCd = JSPUtil.chkNull(bean.get상위메뉴코드(), "");
					
					msg += "<tr onclick=\"fnViewMiddleCd('"+ listCompanyCd+"', '"+ listCorpCd+"', '"+ listBrandCd+"', '"+ listMenuCd+"' );\" style=\"cursor: pointer;\">";
					msg += "<td width=\"110px;\" >"+ listCorpNm  +"</td>";
			      	msg += "<td width=\"110p;\"  >"+ listBrandNm +"</td>"; 
			      	msg += "<td width=\"120px;\" ><label class='lblLargeMenuCd'>"+ listMenuCd  +"</label></td>"; 
			      	msg += "<td width=\"120px;\" >"+ listMenuNm  +"</td>";
			      	msg += "</tr>";
			
				}
			}else{
				msg += "<tr>";
				msg += "<td colspan='4'>조회된 내용이 없습니다.</td>";
				msg += "</tr>";
			}
			
			out.println(msg);
	}
	
%>
	
