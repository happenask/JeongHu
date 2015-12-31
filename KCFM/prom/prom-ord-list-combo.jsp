<%
/** ############################################################### */
/** Program ID   : prom-ord-list-combo.jsp                 */
/** Program Name : 법인코드로 브랜드코드, 매장코드 조회             */
/** Program Desc :                                                  */
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
	
	String msg       = ""; //return
	String processCd = ""; //진행상황코드
	String processNm = ""; //진행상황명
			
	String groupCd     = JSPUtil.chkNull((String)request.getParameter("GroupCd"),     ""); //기업코드
	String corpCd      = JSPUtil.chkNull((String)request.getParameter("CorpCd"),      ""); //법인코드
	String brandCd     = JSPUtil.chkNull((String)request.getParameter("BrandCd"),     ""); //브랜드코드
	String custStoreCd = JSPUtil.chkNull((String)request.getParameter("CustStoreCd"), ""); //매장코드
	String optProcess  = JSPUtil.chkNull((String)request.getParameter("hOptProcess"), ""); //진행상황
	
	String sseGroupCd = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"), ""); //기업코드
	
// 	System.out.println("---------------------------[매장 : 주문관리 : 주문상태 selectbox]-----------------------------------");
//  	System.out.println("기업코드   >>>>>>>>>>>>>>>>>>>> " + groupCd     );
//  	System.out.println("법인코드   >>>>>>>>>>>>>>>>>>>> " + corpCd      );
//  	System.out.println("브랜드코드 >>>>>>>>>>>>>>>>>>>> " + brandCd     );
//  	System.out.println("매장코드   >>>>>>>>>>>>>>>>>>>> " + custStoreCd );
//  	System.out.println("진행상황   >>>>>>>>>>>>>>>>>>>> " + optProcess  );
//  	System.out.println("--------------------------------------------------------------");
	
	
	try{
		list = dao.selectStatusList(sseGroupCd);
		
		if( list != null && list.size() > 0 ) 
		{
			
			msg += "<option value=''>전체</option>";
			
			for( int i = 0; i < list.size(); i++ ) 
			{
				bean = (orderBean) list.get(i);
			  
				processCd = JSPUtil.chkNull(bean.get주문상태());
				processNm = JSPUtil.chkNull(bean.get주문상태명());
				
				if(!"".equals(optProcess)){
					if(optProcess.equals(processCd)){
						msg += "<option value='"+ processCd +"'   selected='selected' >" + processNm + "</option>";
					}else{
						msg += "<option value='"+ processCd +"'>" + processNm + "</option>";
					}
				}else{
				    msg += "<option value='"+ processCd +"'>" + processNm + "</option>";
				}
			    
			}
		}else{
				msg += "<option value=''>조회데이타없음</option>";
		}
		
	}catch(Exception e){
		log4u.log("#err [prom/prom-ord-list-combo.jsp] : 진행상황 SELECT BOX");
	}
	
		
	out.println(msg);
	
%>