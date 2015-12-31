<%
/** ############################################################### */
/** Program ID   : prom-ord-dtl-view.jsp                       		*/
/** Program Name :  prom-ord-dtl-view       						*/
/** Program Desc :  관리자-홍보물 주문내역 상세조회					*/
/** Create Date  :   2015.05.04					              		*/
/** Update Date  :                                                  */
/** Programmer   :                                          		*/
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"  %>
<%@ page import="java.net.*"  %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.JSPUtil"%> 	<%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil"%> 	<%//JSP 공통 유틸 %>
<%@ page import="prom.beans.orderBean"  %>
<%@ page import="prom.dao.orderDao" %>
<%@ include file="/com/fileUpload.jsp"%>
<%@ include file="/com/common.jsp"%>

<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	String root = request.getContextPath();
	
// 	System.out.println("기업코드 : "+request.getParameter("hGroupCd"));
// 	System.out.println("법인코드 : "+request.getParameter("hCorpCd"));
// 	System.out.println("브랜드코드 : "+request.getParameter("hBrandCd"));
// 	System.out.println("매장코드 : "+request.getParameter("hCustStoreCd"));
// 	System.out.println("주문번호 : "+request.getParameter("hOrderNo"));

	paramData.put("기업코드"  , request.getParameter("hGroupCd"));
	paramData.put("법인코드"  , request.getParameter("hCorpCd"));
	paramData.put("브랜드코드", request.getParameter("hBrandCd"));
	paramData.put("매장코드"  , request.getParameter("hCustStoreCd"));
	paramData.put("주문번호"  , request.getParameter("hOrderNo"));
	
	orderBean orderBean  = new orderBean(); //내용보기 에서 담을 빈
	orderDao  orderDao   = new orderDao();
	
	orderBean = orderDao.selectDetail(paramData); // 조회조건에 맞는 이벤트 리스트
	
	String sOut = "";
	if(orderBean != null){
	 	sOut += "	<div id='pop-order-dtl-tit'>주문 상세 확인</div>";
 		sOut += "	<img src='../assets/images/close.png' id='btnCloseLayer' onclick=$('.overlay-bg8').hide() alt='닫기 버튼'>";
		sOut += "	<table style='width:870px;'>";
		sOut += "		<caption>▶ 주문 정보</caption>";
		sOut += "		<col width='110' >";
		sOut += "		<col width='180' >";
		sOut += "		<col width='110' >";
		sOut += "		<col width='180' >";
		sOut += "		<col width='110' >";
		sOut += "		<col width='180' >";
		sOut += "	    <thead>";
		sOut += "		<tr>";
		sOut += "			<th>주문번호</th>";
		sOut += " 			<td class='txt-left'>"+ orderBean.get주문번호() +"</td>";
		sOut += "			<th>브랜드명</th>";
		sOut += " 			<td class='txt-left'>"+ orderBean.get브랜드명() +"</td>";
		sOut += "			<th>매장명</th>";
		sOut += " 			<td class='txt-left'>"+ orderBean.get매장명() +"</td>";
		sOut += "		</tr>";
		sOut += "		<tr>";
		sOut += "			<th>주문일자</th>";
		sOut += " 			<td>"+ orderBean.get주문일자() +"</td>";
		sOut += " 			<th>전단지명</th>";
		sOut += " 			<td>"+ orderBean.get홍보물코드명() +"</td>";
		sOut += "			<th>전단지유형</th>";
		sOut += " 			<td >"+ orderBean.get작업유형() +"</td>";
		sOut += "		</tr>";
		sOut += "		<tr>";
		sOut += "			<th>규격</th>";
		sOut += " 			<td>"+ orderBean.get주문사이즈() +"</td>";
		sOut += " 			<th>주문단위</th>";
		sOut += " 			<td>"+ orderBean.get주문단위() +"</td>";
		sOut += "			<th>주문수량</th>";
		sOut += " 			<td >"+ orderBean.get주문수량() +"</td>";
		sOut += "		</tr>";
		sOut += "		<tr>";
		sOut += "			<th>인쇄문구</th>";

		if("Y".equals(orderBean.get인쇄사용문구포함여부())){
			sOut += " 			<td colspan='2'><textarea cols='32' rows='4' id='printTxt'>"+ URLEncoder.encode(orderBean.get인쇄사용문구(), "UTF-8").replaceAll("\\+", "%20").replaceAll("\\%21", "!").replaceAll("\\%27", "'").replaceAll("\\%28", "(").replaceAll("\\%29", ")").replaceAll("\\%7E", "~") +"</textarea></td>";
		}else{ 
			sOut += " 			<td colspan='2'><textarea cols='32' rows='4' id='printTxt' disabled='disabled'>"+ URLEncoder.encode(orderBean.get인쇄사용문구(), "UTF-8").replaceAll("\\+", "%20").replaceAll("\\%21", "!").replaceAll("\\%27", "'").replaceAll("\\%28", "(").replaceAll("\\%29", ")").replaceAll("\\%7E", "~") +"</textarea></td>";						
		}

		sOut += " 			<th>추가요청사항</th>";
		sOut += " 			<td colspan='2'><textarea cols='32' rows='4' id='requestTxt'>"+ URLEncoder.encode(orderBean.get추가요청사항(), "UTF-8").replaceAll("\\+", "%20").replaceAll("\\%21", "!").replaceAll("\\%27", "'").replaceAll("\\%28", "(").replaceAll("\\%29", ")").replaceAll("\\%7E", "~") +"</textarea></td>";
		sOut += "		</tr>";
		sOut += "		";
		//sOut += "		<!-- 1. 전단지 업체인 경우 보이기 tr class=''-->";
		sOut += "		<tr class=''>";
		sOut += "			<th rowspan='2'>진행상태</th>";
		sOut += " 			<td colspan='5'>";
		sOut += "		    		주문상태 : <b>["+ orderBean.get주문상태명() +"]</b>";   
		sOut += " 			</td>";
		sOut += "		</tr>";
		
		sOut += "		<tr class=''>";
		sOut += " 			<td colspan='5'>";
		sOut += "		    		<input type='radio'  name='progression1'  value='S02' onclick='fnCheckProcess(this)'>주문확인&nbsp;&nbsp;";   
		sOut += "		    		<input type='radio'  name='progression1'  value='S04' onclick='fnCheckProcess(this)'>시안완료&nbsp;&nbsp;";
		sOut += "		    		<input type='radio'  name='progression1'  value='M01' onclick='fnCheckProcess(this)'>제 작 중&nbsp;&nbsp;";
		sOut += "		    		<input type='radio'  name='progression1'  value='M02' onclick='fnCheckProcess(this)'>배 송 중&nbsp;&nbsp;";
		sOut += "		    		<input type='hidden' name='progressStatus' id='progressStatus'  value='"+orderBean.get주문상태()+"' >";
		sOut += " 			</td>";
		sOut += "		</tr>";
		
		//파일 첨부
		sOut += "		<tr class=''>";
		sOut += " 			<th>시안첨부</th>";
		sOut += " 			<td colspan='3'> ";
		sOut += "               <div id='fileDiv1'> ";
								String promFile = JSPUtil.chkNull((String)orderBean.get시안파일명(), "" );
								if ("".equals(promFile)){
									sOut += " <span style='position:absolute; display:none;' id='s첨부파일1' ></span> ";
									sOut += " <input type='file' id='attachFile1' name='attachFile1' onchange='fnChgFname(this); checkFilesize(this);' value=''/>&nbsp; ";
									sOut += " <button  type='button' class='deleteBtn' id='deleteBtn' name='deleteBtn' onclick='fnDeleteFile(\\\"s첨부파일1\\\");'></button> ";
								}else{
									//sOut += " <span style='position:absolute;' id='s첨부파일1' >"+ promFile +"</span> ";
									sOut += " <span style='position:absolute;' id='s첨부파일1' ><a id='download-link' href='" +root+ "/com/fileDown.jsp?fname="+ promFile+"&gubn=2' >"+ promFile +"</a></span> ";
									sOut += " <input style='display:none;' type='file' id='attachFile1' name='attachFile1' onchange='fnChgFname(this); checkFilesize(this);' />&nbsp ";
									sOut += " <button  type='button' class='deleteBtn' id='deleteBtn' name='deleteBtn' onclick='fnIniFile(\\\"s첨부파일1\\\");'></button> ";
								}
		sOut += "               <div />";
		sOut += "           </td>";
		sOut += "		</tr>";
		
		
		sOut += "		";
		//sOut += "		<!-- 2. 매장인 경우 보이기 tr class=''-->";
		//--------------------------------------------------------
//  		sOut += "		<tr class='hidden'>";
// 		sOut += "			<th>진행상태</th>";
// 		sOut += " 			<td colspan='2'>";
// 		sOut += "		    		<select id='progression2' name='progression2'>";
// 		sOut += "		    			<option value=''>시안보류</option><option value=''>주문취소</option><option value=''>주문완료</option><option value=''>제작완료</option>";
// 		sOut += "		    		</select>";
// 		sOut += " 			</td>";
// 		sOut += " 			<th>시안확인</th>";
// 		sOut += " 			<td colspan='2'><button class='confirmBtn' onclick=''>확인</button></td>";
// 		sOut += "		</tr>";
		//-----------------------------------------------------
		sOut += "	    </thead>";
	    sOut += "	</table>";
// 		sOut += "	<p style=' text-align: center; margin:20px auto;'><button class='redBtn' id='' type='button' onclick='fnSavePopUpInfo(\\\"0\\\"); $(\\\".overlay-bg8\\\").hide();'  >저장</button>&nbsp;&nbsp;<button class='grayBtn' id='' type='button' onclick='$(\\\".overlay-bg8\\\").hide();'  >닫기</button></p>";
		sOut += "	<p style=' text-align: center; margin:20px auto;'><button class='redBtn' id='' type='button' onclick='fnSavePopUpInfo(); $(\\\".overlay-bg8\\\").hide();'  >저장</button>&nbsp;&nbsp;<button class='grayBtn' id='' type='button' onclick='$(\\\".overlay-bg8\\\").hide();'  >닫기</button></p>";
		sOut += "  	";
		//sOut += "  	<!-- 댓글영역 -->";
		sOut += "	 <div id='write_comm'>";
		sOut += "	      <p>댓글입력</p>  ";
		sOut += "	      <textarea cols='90' rows='4' id='comm_write' name='comm_write' ></textarea>";
		//sOut += "	      <!-- <button class='btn_blank gray' id='btn_input' name='btn_input' onclick='input();'>확인</button> -->";
		sOut += "	      <button class='btn_blank' id='btn_input' name='btn_input' onclick='fnWriteComment(\\\"0\\\");' style='cursor:pointer;'></button>  "; //댓글입력
		sOut += "     </div>";
		sOut += "	<div id='comment'>";
		
		//-------------댓글[동적생성으로 처리 사용안함]-------------
// 		sOut += "		<p  class='count' onclick='showComment();'><span class='mark'>▶</span> 총 댓글 (<span class='num'>1</span>)</p>  ";
// 		sOut += "		<ul class='comm_list hidden'>     ";
// 		sOut += "			<li>";
// 		sOut += "	  			<p><span class='writer'>unitas </span><span class='date'> 2015-05-02</span></p>";
// 		sOut += "   			<div id='comm_text' class='comm'>댓글댓글댓글..</div> ";
// 		sOut += "			</li>";
// 		sOut += "		</ul>";
		//-------------댓글-------------
		sOut += "	</div> 	";

	}

	
	
	out.println("<script type='text/javascript' >   ");
	out.println("  parent.fnSelectComment(); "); //댓글조회
	out.println("  parent.fnRetSetting(\"pop-order-dtl\", \""+sOut+"\", \""+ JSPUtil.chkNull((String)orderBean.get시안번호(), "") +"\")   ");
	out.println("</script>");

%>