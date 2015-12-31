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
	paramData.put("홍보물번호", request.getParameter("PromoNo"));
	
	listBean listBean  = new listBean(); //내용보기 에서 담을 빈
	listDao  listDao   = new listDao();
	
	listBean = listDao.selectDetail(paramData); //조회조건에 맞는 이벤트 리스트

	String sOut = "";
	if(listBean != null){
		sOut = sOut + "<div id='pop-order-dtl-tit'>"+listBean.get홍보물명()+"</div>";
		sOut = sOut + "<section id='left-img'>";
		sOut = sOut + "  <table>";
		sOut = sOut + "    <tr>";
		sOut = sOut + "      <td align='center'><img src='"+root+"/"+listBean.get이미지경로()+listBean.get이미지앞면파일명()+"' width='250' height='352' id='' onclick='' alt='전단지 앞뒤'/></td>";
		sOut = sOut + "      <td width='5'></td>";
		if("".equals(listBean.get이미지뒷면파일명()) || listBean.get이미지뒷면파일명() == null){
			sOut = sOut + "      <td width='250' align='center'>이미지가 존재하지 않습니다.</td>";
		} else {
			sOut = sOut + "      <td align='center'><img src='"+root+"/"+listBean.get이미지경로()+listBean.get이미지뒷면파일명()+"' width='250' height='352' id='' onclick='' alt='전단지 앞뒤'/></td>";
		}
		sOut = sOut + "    </tr>";
		sOut = sOut + "    <tr>";
		sOut = sOut + "      <td align='center'>[앞면]</td>";
		sOut = sOut + "      <td></td>";
		sOut = sOut + "      <td align='center'>[뒷면]</td>";
		sOut = sOut + "    </tr>";
		sOut = sOut + "  </table>";
		sOut = sOut + "</section>";
		sOut = sOut + "<section id='right-info'>";
		sOut = sOut + "<img src='../assets/images/close.png' id='btnCloseLayer' onclick=$('.overlay-bg8').hide() alt='닫기 버튼'>";
		sOut = sOut + "  <p>사이즈 : "+listBean.get사이즈()+"</p>";
		sOut = sOut + "  <p>주문단위 : "+listBean.get수량()+"</p>";
		sOut = sOut + "  <p>가격 : ￦"+listBean.get매출단가()+"</p>";
		sOut = sOut + "  <hr>";
		sOut = sOut + "  <p>▷ 인쇄사용문구</p>";
		sOut = sOut + "  <textarea id='dPrintMsg' name='dPrintMsg' rows='6' cols='40' "+("N".equals(listBean.get인쇄사용문구포함여부())?"disabled":"")+"></textarea>";
		sOut = sOut + "  <p>▷ 추가요청사항</p>";
		sOut = sOut + "  <textarea id='dAddRequst' name='dAddRequst' rows='4' cols='40'></textarea>";
		sOut = sOut + "  <hr><br>";
		sOut = sOut + "  <p style='font-weight: bold;'>주문수량 : ";
		sOut = sOut + "    <input type='text' id='dOrdQty' name='dOrdQty' value='1' size='3' style='text-align: right;' maxlength='6' onkeydown='onlynumber();' onkeyup='fnCalcAmt(this.value);'/>";
		sOut = sOut + "    <input type='hidden' id='dOrdPrice' name='dOrdPrice' value='"+listBean.get매출단가()+"'/> ";
		sOut = sOut + "    주문금액 : <span id='dOrdAmt'>"+listBean.get매출단가()+"원</span>";
		sOut = sOut + "  </p>";
		sOut = sOut + "  <p style=' text-align: center; margin-top: 50px;'>";
		sOut = sOut + "    <button class='grayBtn' id='btnOrd' type='button' onclick='fnCart();' >장바구니</button>";
		sOut = sOut + "    <button class='redBtn' id='btnOrd' type='button' onclick='fnOrder();' >주문하기</button>";
		sOut = sOut + "  </p>";
		sOut = sOut + "</section>";
	}
	out.print("<script>");
	out.print("  parent.fnRetSetting(\"pop-order-dtl\", \""+sOut+"\")");
	out.print("</script>");
%>
