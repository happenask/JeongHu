<%
/** ############################################################### */
/** Program ID   : maintain-prom-regist-combo.jsp                   */
/** Program Name : 기업,법인코드로 브랜드코드 조회                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="prom_mnt.beans.promMntBean" %> 
<%@ page import="prom_mnt.dao.promMntDao" %>
<%@ include file="/com/common.jsp"%>

<% 
	com.util.Log4u log4u = new com.util.Log4u();
	
	String root = request.getContextPath();
	
	promMntBean bean = null; 
	promMntDao  dao  = new promMntDao();
	
	ArrayList<promMntBean> list = null;
	
	String gubun     = JSPUtil.chkNull((String)request.getParameter("gubun"),       "");
	String pGroupCd = JSPUtil.chkNull((String)request.getParameter("inCompanyCd"), "");
	String pCorpCd    = JSPUtil.chkNull((String)request.getParameter("inCorpCd"),    "");
	String pBrandCd   = JSPUtil.chkNull((String)request.getParameter("inBrandCd"),   "");
	String pMenuCd    = JSPUtil.chkNull((String)request.getParameter("inBigClass"),  "");
	String pMidMenuCd    = JSPUtil.chkNull((String)request.getParameter("inMidClass"),  "");

	paramData.put("gubun"			, gubun);
	paramData.put("기업코드"		, pGroupCd);
	paramData.put("법인코드"		, pCorpCd);
	paramData.put("브랜드코드"		, pBrandCd);
	paramData.put("홍보물대분류"	, pMenuCd);
	paramData.put("홍보물코드"		, pMidMenuCd);
	
	
	System.out.println(request.getParameter("gubun"));
	
	if("group".equals(gubun)){
		
		String msg = "";
		
		String groupCd = ""; 
		
		groupCd = dao.selectGropCd(paramData);
		
		msg += groupCd;
		
		out.println(msg);
		System.out.println("groupCd : "+msg);
		 
	}
	else if("corp".equals(gubun)){
		
		list = dao.selectCompanyCd(paramData);

		String msg     = "";
		
		String corpCd = "";
		String corpNm = "";
		
		if( list != null && list.size() > 0 ) 
		{
			msg += "<option value='%'>선택</option>";
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (promMntBean) list.get(i);
			  
				corpCd = JSPUtil.chkNull(bean.get법인코드());
				corpNm = JSPUtil.chkNull(bean.get법인명());
				
			    msg += "<option value='"+corpCd+"'>"+corpNm+"</option>";
			}
		}else{
				msg += "<option value='' selected = 'selected'>조회데이타없음</option>";
		}
		
		out.println(msg);
		//System.out.println("company : "+msg);
		
	}else if("brand".equals(gubun)){
		
		list = dao.selectBrandCd(paramData);

		String msg     = "";
		
		String brandCd = "";
		String brandNm = "";
		
		if( list != null && list.size() > 0 ) 
		{
			msg += "<option value='%'>선택</option>";
			
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (promMntBean) list.get(i);
			  
				brandCd = JSPUtil.chkNull(bean.get브랜드코드());
				brandNm = JSPUtil.chkNull(bean.get브랜드명());
				
			    msg += "<option value='"+brandCd+"'>"+brandNm+"</option>";
			}
		}else{
				msg += "<option value='' selected = 'selected'>조회데이타없음</option>";
		}
		
		out.println(msg);
		//System.out.println("brand : "+msg);
		
	}else if("middle".equals(gubun)){
		list = dao.selectPromMiddleList(paramData);
	
		String msg      = "";
		String middleCd = "";
		String middleNm = "";
		
		if( list != null && list.size() > 0 ) 
		{
			msg += "<option value='%'>선택</option>";
			
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (promMntBean) list.get(i);
			  
				middleCd = JSPUtil.chkNull(bean.get메뉴코드());
				middleNm = JSPUtil.chkNull(bean.get메뉴코드명());
					  
						
			 	msg += "<option value='"+middleCd+"'>"+middleNm+"</option>";
			}
		}else{
						msg += "<option value='' selected = 'selected'>조회데이타없음</option>";
		}
		
		out.println(msg);
		//System.out.println("middle : "+msg);
		
	}else if("large".equals(gubun)){
		
		list = dao.selectPromList(paramData); //조회조건에 맞는 이벤트 리스트
		
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
				msg += "<option value='%'>선택</option>";
				for( int i = 0; i < list.size(); i++ ) 
				{
					bean = (promMntBean) list.get(i);
					
					listCompanyCd    = JSPUtil.chkNull(bean.get기업코드(),     "");
					listCompanyNm    = JSPUtil.chkNull(bean.get기업명(),       "");
					listCorpCd       = JSPUtil.chkNull(bean.get법인코드(),     "");
					listCorpNm       = JSPUtil.chkNull(bean.get법인명(),       "");
					listBrandCd      = JSPUtil.chkNull(bean.get브랜드코드(),   "");
					listBrandNm      = JSPUtil.chkNull(bean.get브랜드명(),     "");
					listMenuCd       = JSPUtil.chkNull(bean.get메뉴코드(),     "");
					listMenuNm       = JSPUtil.chkNull(bean.get메뉴코드명(),   "");
					listParentMenuCd = JSPUtil.chkNull(bean.get상위메뉴코드(), "");
					
					
					msg += "<option value='"+listMenuCd+"'>"+listMenuNm+"</option>";
			
				}
			}else{
				msg += "<option value='' selected = 'selected'>조회데이타없음</option>";
			}
			
			
			out.println(msg);
			//System.out.println("large : "+msg);
			
	}else if("promtion".equals(gubun)){
		
		list = dao.selectPromtion(paramData); //조회조건에 맞는 이벤트 리스트
		
		String msg = "";
		
		String promCd = "";
		String promNm = "";
		String promPhoneNum = "";
		
		if(list != null && list.size() > 0){
		    
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (promMntBean) list.get(i);
				promCd 		 = JSPUtil.chkNull(bean.get홍보물업체코드(),     "");
				promNm 		 = JSPUtil.chkNull(bean.get홍보물업체명(),     "");
				promPhoneNum = JSPUtil.chkNull(bean.get홍보물업체전화번호(),     "");
				
				msg += "<option value='"+promCd+","+promPhoneNum+"'>"+promNm+"</option>";
			
			}
		}else{
			msg += "<option value='' selected = 'selected'>조회데이타없음</option>";
		}
		
		
		out.println(msg);
		//System.out.println("promtion : "+msg);
		
	}else if("promType".equals(gubun)){
		
		String pGubun = "인쇄사용문구포함여부";
		
		paramData.put("분류코드", pGubun);
		
		list = dao.selectCode(paramData ); //조회조건에 맞는 이벤트 리스트
		
		String msg = "";
		
		String promTypeCd = "";
		String promTypeNm = "";
		
		if(list != null && list.size() > 0){
		    
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (promMntBean) list.get(i);
				promTypeCd 		 = JSPUtil.chkNull(bean.get세부코드(),     "");
				promTypeNm 		 = JSPUtil.chkNull(bean.get세부코드명(),     "");
				
				msg += "<option value='"+promTypeCd+"'>"+promTypeNm+"</option>";
			
			
			}
		}else{
			msg += "<option value='' selected = 'selected'>조회데이타없음</option>";
		}
		
		out.println(msg);
		//System.out.println("promType : "+msg);
		
		
	}else if("unit".equals(gubun)){

		String pGubun = "단위";
		
		paramData.put("분류코드", pGubun);
		
		list = dao.selectCode(paramData); //조회조건에 맞는 이벤트 리스트
		
		String msg = "";
		
		String unitCd = "";
		String unitNm = "";
		
		if(list != null && list.size() > 0){
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (promMntBean) list.get(i);
				unitCd 		 = JSPUtil.chkNull(bean.get세부코드(),     "");
				unitNm 		 = JSPUtil.chkNull(bean.get세부코드명(),     "");
				
				msg += "<option value='"+unitCd+"'>"+unitNm+"</option>";
			
			
			}
		}else{
			msg += "<option value='' selected = 'selected'>조회데이타없음</option>";
		}
		
		out.println(msg);
		//System.out.println("promType : "+msg);
		
		
	}else if("promSeq".equals(gubun)){
		
		String msg = "";
		
		String promSeq = ""; 
		
		promSeq = dao.selectPromSeq(paramData);
		
		msg += promSeq;
		
		out.println(msg);
		//System.out.println("promSeq : "+msg);
		
		
	}
	
%>