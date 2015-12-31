<%
/** ############################################################### */
/** Program ID   : loginCheck.jsp                                   */
/** Program Name : 로그인                                           */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ page import="address.beans.addressBean" %>
<%@ page import="address.dao.addressDao" %>
<%@ include file="/com/common.jsp"%>

<% 
	

	String root = request.getContextPath();

    addressBean bean = null; 
	addressDao  dao  = new addressDao();
	
	ArrayList<addressBean> list = null;
	
	
	String searchWord = JSPUtil.chkNull((String)request.getParameter("search_word"),  "");
	
	paramData.put("search_word", searchWord);
	
	
	
	list = dao.searchAddress(paramData);
	
	
	String zip1 = "";
	String zip2 = "";
	String addr = "";
	String msg = "";
	
	if( list != null && list.size() > 0 ) 
	{
		msg += "<ul>";
		for(int i=0; i<list.size(); i++){
			
			bean = (addressBean)list.get(i);
			
			zip1  = JSPUtil.chkNull(bean.get우편번호1(),""  );
			zip2  = JSPUtil.chkNull(bean.get우편번호2(),""  );
			addr  = JSPUtil.chkNull(bean.get주소(), "");
			
			msg += "<li><a href=\"javascript:goDetailStep('" + zip1 +"','"+zip2+"','" + addr + "')\">["+zip1+"-"+zip2+"]"+addr+"</a></li>";
			
		}
		msg += "</ul>";
	}else{
		
		
		msg += "검색된 주소가 없습니다.";
		
		
	}

	
	out.println(msg);
	
%>