<%
/** ############################################################### */
/** Program ID   : prom-dtl-view.jsp                                */
/** Program Name : prom-dtl-view	       					        */
/** Program Desc : 관리자-홍보물 상세정보 보기					    */
/** Create Date  :   2015.05.08					              		*/
/** Update Date  :                                                  */
/** Programmer   :                                          		*/
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="prom_mnt.dao.promMntDao" %>
<%@ page import="prom_mnt.beans.promMntBean" %>
<%@ page import="com.util.BoardConstant" %>
<%@ include file="/com/common.jsp"%>

<%
	
	String root = request.getContextPath();
	
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	
	String sGroupCode      = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sCorpCode       = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sBrandCode      = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sCustLoginNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"   ),""); //등록자명

	

	//--------------------------------------------------------------------------------------------------
	// Parameter 입력
	//--------------------------------------------------------------------------------------------------		
	paramData.put("기업코드"  , request.getParameter("vGroupCd"));
	paramData.put("법인코드"  , request.getParameter("vCorpCd"));
	paramData.put("브랜드코드", request.getParameter("vBrandCd"));
	paramData.put("홍보물코드", request.getParameter("vPromoCd"));
	paramData.put("홍보물번호", request.getParameter("vPromoNo"));

	System.out.println ("prom-dtl-view========================================");
	System.out.println("기업코드   : "+request.getParameter("vGroupCd"));
	System.out.println("법인코드   : "+request.getParameter("vCorpCd"));
	System.out.println("브랜드코드 : "+request.getParameter("vBrandCd"));
	System.out.println("홍보물코드 : "+request.getParameter("vPromoCd"));
	System.out.println("홍보물번호 : "+request.getParameter("vPromoNo"));
	System.out.println ("=======================================================");

	//--------------------------------------------------------------------------------------------------
	// 파라미터 인코딩
	//--------------------------------------------------------------------------------------------------
	
	request.setCharacterEncoding("UTF-8");
	String encType = "UTF-8";
	
	//-------------------------------------------------------------------------------------------------------
	//  Bean 및 Dao 처리
	//-------------------------------------------------------------------------------------------------------
	promMntBean promMntBean = new promMntBean();     // 내용보기에서 담을 빈
	promMntDao promMntDao 	= new promMntDao();
	
	
	promMntBean = promMntDao.selectDetail(paramData); // 조회조건에 맞는 이벤트 리스트
	
	String sOut = "";
	if(promMntBean != null){
		
		sOut = sOut + "<div id='pop-order-dtl-tit'>홍보물 상세보기</div>";
		sOut = sOut + "<img src='../assets/images/close.png' id='btnCloseLayer' onclick=$('.overlay-bg8').hide() alt='닫기 버튼'>";
		sOut = sOut + "<table width='870'>";
		sOut = sOut + "<caption>▶ 홍보물 정보 상세</caption>";
		sOut = sOut + "   <col width='110' >";
		sOut = sOut + "   <col width='180' >";
		sOut = sOut + "   <col width='110' >";
		sOut = sOut + "   <col width='180' >";
		sOut = sOut + "   <col width='110' >";
		sOut = sOut + "   <col width='180' >";
		sOut = sOut + "   <thead>";
		sOut = sOut + "      <tr>";
		sOut = sOut + "         <th>법인명</th>";
		sOut = sOut + "         <td colspan='2' class='txt-left'>"+promMntBean.get법인명()+"</td>";
		sOut = sOut + "         <th>브랜드명</th>";
		sOut = sOut + "         <td colspan='2' class='txt-left'>"+promMntBean.get브랜드명()+"</td>";
		sOut = sOut + "      </tr>";
		sOut = sOut + "      <tr>";
		sOut = sOut + "         <th>대분류명</th>";
		sOut = sOut + "         <td class='txt-left'>"+promMntBean.get대분류명()+"</td>";
		sOut = sOut + "         <th>중분류명</th>";
		sOut = sOut + "         <td class='txt-left'>"+promMntBean.get중분류명()+"</td>";
		sOut = sOut + "	        <th>홍보물번호</th>";
		sOut = sOut + "         <td>"+promMntBean.get홍보물번호()+"</td>";
		sOut = sOut + "      </tr>";
		sOut = sOut + "      <tr>";
		sOut = sOut + "	        <th>홍보물명</th>";
		sOut = sOut + "         <td>"+promMntBean.get홍보물명()+"</td>";
		sOut = sOut + "         <th>홍보물타입</th>";
		sOut = sOut + "         <td>"+promMntBean.get홍보물타입()+"</td>";
		sOut = sOut + "	        <th>규격</th>";
		sOut = sOut + "         <td>"+promMntBean.get사이즈()+"</td>";
		sOut = sOut + "      </tr>";
		sOut = sOut + "      <tr>";
		sOut = sOut + "         <th>주문단위</th>";
		sOut = sOut + "         <td>"+promMntBean.get주문단위()+"</td>";
		sOut = sOut + "         <th>단가</th>";
		sOut = sOut + "         <td>"+promMntBean.get단가()+"</td>";
		sOut = sOut + "	        <th>제작업체</th>";
		sOut = sOut + "         <td>"+promMntBean.get홍보물업체명()+"</td>";
		sOut = sOut + "      </tr>";
		sOut = sOut + "   </thead>";
		sOut = sOut + "</table>";
		sOut = sOut + "<div id='ord-img'>";
		if(!"".equals(promMntBean.get이미지앞면파일명()) && promMntBean.get이미지앞면파일명() != null){
			sOut = sOut + "<img src='"+root+"/"+promMntBean.get이미지경로()+promMntBean.get이미지앞면파일명()+"' width='220' id='' onclick='' alt='전단지 앞뒤' align='middle'/>";
		}
		if(!"".equals(promMntBean.get이미지뒷면파일명()) && promMntBean.get이미지뒷면파일명() != null){
			sOut = sOut + "<img  src='"+root+"/"+promMntBean.get이미지경로()+promMntBean.get이미지뒷면파일명()+"' width='220' id='' onclick='' alt='전단지 앞뒤' align='middle'/>";
		}
		sOut = sOut + "<p class='btn'>";
		sOut = sOut + "</div>";
		
		
	}
	

	System.out.println("promMntBean.get등록자() : "+promMntBean.get등록자());
	System.out.println("sCustLoginNm : "+sCustLoginNm);
	
	out.print("<script>");
	out.print("  parent.fnRetSetting(\"pop-order-dtl\", \""+sOut+"\")");
	out.print("</script>");
	
%>
