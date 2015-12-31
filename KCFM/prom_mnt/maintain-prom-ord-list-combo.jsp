<%
/** ############################################################### */
/** Program ID   : maintain-prom-ord-list-combo.jsp                 */
/** Program Name : 법인코드로 브랜드코드, 매장코드 조회               */
/** Program Desc : 관리자용                                         */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="prom.beans.orderBean" %> 
<%@ page import="prom.dao.orderDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>

<% 
	
	com.util.Log4u log4u = new com.util.Log4u();

	String root = request.getContextPath();

	orderBean bean = null; 
	orderDao  dao  = new orderDao();
	
	ArrayList<orderBean> list = null;
	
	String msg     = ""; //return
	String corpCd  = ""; //법인코드
	String corpNm  = ""; //법인코드명
	String brandCd = ""; //브랜드코드
	String brandNm = ""; //브랜드코드명
	String storeCd = ""; //매장코드
	String storeNm = ""; //매장코드명
	String statusCd= ""; //매장상태코드
	String statusNm= ""; //매장상태코드명
	
	String hComboGubun  = JSPUtil.chkNull((String)request.getParameter("hComboGubun"),  ""); //조회구분
	
	String sseCustAuth  = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth"));
	String hGroupCd     = JSPUtil.chkNull((String)request.getParameter("hGroupCd"),     ""); //기업코드
	String hCorpCd      = JSPUtil.chkNull((String)request.getParameter("hCorpCd"),      ""); //법인코드
	String hBrandCd     = JSPUtil.chkNull((String)request.getParameter("hBrandCd"),     ""); //브랜드코드
	String hCustStoreCd = JSPUtil.chkNull((String)request.getParameter("hCustStoreCd"), ""); //매장코드
	String optProcess   = JSPUtil.chkNull((String)request.getParameter("hOptProcess"),  ""); //진행상황
	
	String hCorpCdIdx   = JSPUtil.chkNull((String)request.getParameter("hCorpCdIdx"),   ""); //법인 선택 인덱스
	String hBrandCdIdx  = JSPUtil.chkNull((String)request.getParameter("hBrandCdIdx"),  ""); //브랜드 선택 인덱스
	String hStoreCdIdx  = JSPUtil.chkNull((String)request.getParameter("hStoreCdIdx"),  ""); //매장 선택 인덱스
	
	String sseGroupCd = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"), ""); //기업코드
	
// 	System.out.println("----------------------[관리자 : SELECT BOX]-------------------------");
// 	System.out.println("구분       >>>>>>>>>>>>>>>>>>>> " + hComboGubun);
// 	System.out.println("권한코드   >>>>>>>>>>>>>>>>>>>> " + sseCustAuth);
// 	System.out.println("기업코드   >>>>>>>>>>>>>>>>>>>> " + hGroupCd);
// 	System.out.println("법인코드   >>>>>>>>>>>>>>>>>>>> " + hCorpCd);
// 	System.out.println("브랜드코드 >>>>>>>>>>>>>>>>>>>> " + hBrandCd);
// 	System.out.println("매장코드   >>>>>>>>>>>>>>>>>>>> " + hCustStoreCd);
// 	System.out.println("진행상황   >>>>>>>>>>>>>>>>>>>> " + optProcess);
	
// 	System.out.println("법인코드 인덱스   >>>>>>>>>>>>>>>>>>>> " + hCorpCdIdx);
// 	System.out.println("브랜드코드 인덱스 >>>>>>>>>>>>>>>>>>>> " + hBrandCdIdx);
// 	System.out.println("매장코드 인덱스   >>>>>>>>>>>>>>>>>>>> " + hStoreCdIdx);
	
	
	if("corpCombo".equals(hComboGubun)){ //법인조회
	
		list = dao.selectGroupCdList(hGroupCd, sseCustAuth);
	
		String listGroupCd = "";
		
		if( list != null && list.size() > 0 ) 
		{
		    msg += "<option value=''>전체</option>";
		    
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (orderBean) list.get(i);
			  
				corpCd = JSPUtil.chkNull(bean.get법인코드());
				corpNm = JSPUtil.chkNull(bean.get법인명());	
				
				if("90".equals(sseCustAuth)){
					listGroupCd = JSPUtil.chkNull(bean.get기업코드());
					corpCd      = corpCd+"-"+listGroupCd;
				}
			    
				  if(!"".equals(hCorpCdIdx)){
					   int compareIdx = i+1;
					   
				    	if(Integer.parseInt(hCorpCdIdx) == compareIdx ){
				    		msg += "<option value='"+ corpCd +"' selected='selected'>" + corpNm + "</option>";
				    		
				    	}else{
				    		msg += "<option value='"+ corpCd +"'>" + corpNm + "</option>";
				    	}
				    	
				    }else{
				    	msg += "<option value='"+ corpCd +"'>" + corpNm + "</option>";
				    }
			}
		}else{
				msg += "<option value=''>조회데이타없음</option>";
		}
		
	}else if("brandCombo".equals(hComboGubun)){ //브랜드조회
		list = dao.selectBrandCdList(hGroupCd, hCorpCd);
		
		if( list != null && list.size() > 0 ) 
		{
			
			msg += "<option value=''>전체</option>";
			
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (orderBean) list.get(i);
			  
				brandCd = JSPUtil.chkNull(bean.get브랜드코드());
				brandNm = JSPUtil.chkNull(bean.get브랜드명());
				
			    if(!"".equals(hBrandCdIdx)){
			    	int compareIdx = i+1;
			    	
			    	if(Integer.parseInt(hBrandCdIdx) == compareIdx ){
			    		msg += "<option value='"+ brandCd +"' selected='selected'>" + brandNm + "</option>";
			    	}else{
			    		msg += "<option value='"+ brandCd +"'>" + brandNm + "</option>";
			    	}
			    }else{
			    	msg += "<option value='"+ brandCd +"'>" + brandNm + "</option>";	
			    }
			    
			}
		}else{
				msg += "<option value=''>조회데이타없음</option>";
		}
		
	}else if("storeCombo".equals(hComboGubun)){ //매장조회
		list = dao.selectStoreCdList(hGroupCd, hCorpCd, hBrandCd);
		
		if( list != null && list.size() > 0 ) 
		{
			msg += "<option value=''>전체</option>";
			
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (orderBean) list.get(i);
			  
				storeCd = JSPUtil.chkNull(bean.get매장코드());
				storeNm = JSPUtil.chkNull(bean.get매장명());
				
				if(!"".equals(hStoreCdIdx)){
					int compareIdx = i+1;
			    	
			    	if(Integer.parseInt(hStoreCdIdx) == compareIdx ){
						msg += "<option value='"+ storeCd +"'  selected='selected' >" + storeNm + "</option>";
					}else{
						msg += "<option value='"+ storeCd +"'>" + storeNm + "</option>";
					}
				}else{
				    msg += "<option value='"+ storeCd +"'>" + storeNm + "</option>";
				}
			    
			}
		}else{
				msg += "<option value=''>조회데이타없음</option>";
		}
		
	}else if("orderStatus".equals(hComboGubun)){//진행상횡조회
		list = dao.selectStatusList(sseGroupCd);
		
		if( list != null && list.size() > 0 ) 
		{
			
			msg += "<option value=''>전체</option>";
			
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (orderBean) list.get(i);
			  
				statusCd = JSPUtil.chkNull(bean.get주문상태());
				statusNm = JSPUtil.chkNull(bean.get주문상태명());
				
				if(!"".equals(optProcess)){
					if(optProcess.equals(statusCd)){
						msg += "<option value='"+ statusCd +"'   selected='selected' >" + statusNm + "</option>";
					}else{
						msg += "<option value='"+ statusCd +"'>" + statusNm + "</option>";
					}
				}else{
				    msg += "<option value='"+ statusCd +"'>" + statusNm + "</option>";
				}
			    
			}
		}else{
				msg += "<option value=''>조회데이타없음</option>";
		}
		
	}
	
		
	out.println(msg);
	
%>