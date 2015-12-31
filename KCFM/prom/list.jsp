<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="prom.dao.listDao" %>
<%@ page import="prom.beans.listBean" %>
<%@ page import="com.util.BoardConstant" %>
<%@ include file="/com/common.jsp"%>

<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	String root = request.getContextPath();

	paramData.put("기업코드"  , request.getParameter("GroupCd"));
	paramData.put("법인코드"  , request.getParameter("CorpCd"));
	paramData.put("브랜드코드", request.getParameter("BrandCd"));
	paramData.put("홍보물코드", request.getParameter("PromoCd"));
	
	listBean listBean  = new listBean(); //내용보기 에서 담을 빈
	listDao  listDao   = new listDao();
	
	ArrayList<listBean> list = null;
	list = listDao.selectList(paramData); //조회조건에 맞는 이벤트 리스트

	String sOut = "";
	if(list != null && list.size() > 0){
		for(int i=0; i<list.size(); i++){
			listBean = (listBean) list.get(i);
			
			sOut = sOut + "<section>";
			sOut = sOut + "  <img src='"+root+"/"+listBean.get이미지경로()+listBean.get이미지표지파일명()+"' width='200' height='280' alt='전단지 이미지' align='middle'>";
			sOut = sOut + "  <p class='p-title'>"+listBean.get홍보물명()+"</p>";
			sOut = sOut + "  <p>사이즈 : "+listBean.get사이즈()+"</p>";
			sOut = sOut + "  <p>수량 : "+listBean.get수량()+"</p>";
			sOut = sOut + "  <p>가격 : ￦"+listBean.get매출단가()+"</p>";
			sOut = sOut + "  <button class='redBtn' type='button' onclick='fnShowListDetail("+listBean.get홍보물번호()+");' >상세보기</button>";
			sOut = sOut + "</section>";
		}
	}
	out.print("<script>");
	out.print("  parent.fnRetSetting(\"material-main\", \""+sOut+"\")");
	out.print("</script>");
%>