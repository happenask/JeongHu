<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.beans.CodeBean" %>
<%@ page import="prom.beans.orderBean" %>
<%@ page import="prom.dao.orderDao" %>
<%@ include file="/com/common.jsp"%>

<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	String root = request.getContextPath();
	
	String srch_key   = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("srch_key") , ""), "UTF-8"); //검색어
	String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type"), "0");//검색종류
	String StartDate  = JSPUtil.chkNull((String)paramData.get("sDate")    , ""); //조회시작일자
	String EndDate    = JSPUtil.chkNull((String)paramData.get("eDate")    , ""); //조회종료일자

	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드", (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("조회시작일자", request.getParameter("sDate"));
	paramData.put("조회종료일자", request.getParameter("eDate"));
	paramData.put("srch_key", request.getParameter("srch_key"));
	paramData.put("srch_type", request.getParameter("srch_type"));
	paramData.put("inCurPage", request.getParameter("inCurPage"));
	paramData.put("inCurBlock", request.getParameter("inCurBlock"));

	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	if ("".equals(StartDate) || StartDate == null)
	{
		StartDate = CommUtil.insDash(CommUtil.calDate(CommUtil.getDate(), "MONTH",-1));
	}
	if ("".equals(EndDate) || EndDate == null)
	{
		EndDate = JSPUtil.getYear() + "-" + JSPUtil.getMonth() + "-" + JSPUtil.getDay();
	}	
	
	paramData.put("조회시작일자",    StartDate   );
	paramData.put("조회종료일자" ,   EndDate    );

	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull(request.getParameter("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull(request.getParameter("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 7;                                                                            // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 7;                                                                            // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝

	orderBean orderBean  = new orderBean(); //내용보기 에서 담을 빈
	orderDao  orderDao   = new orderDao();
	
	ArrayList<orderBean> list = null;
	list       = orderDao.selectList(paramData);        //조회조건에 맞는 이벤트 리스트
	inTotalCnt = orderDao.selectListCount(paramData);   //전체레코드 수

	//수정[X]
	//####################################################################################################페이지 구하기 시작
	//현재 블럭의 페이지수구하기
	if( inTotalCnt % inRowPerPage == 0 ) { inTotalPageCount = inTotalCnt / inRowPerPage; } 
	else    	 						 { inTotalPageCount = inTotalCnt / inRowPerPage + 1; }
	
	//페이지 블럭 구하기
	if( inTotalPageCount % inPagePerBlock == 0 ) { inTotalPageBlockCount = (int)Math.round((double)(inTotalPageCount/inPagePerBlock)); }
	else                                		 {inTotalPageBlockCount = (int)Math.round((double)(inTotalPageCount/inPagePerBlock) + 0.5); }
	
	//이전 블럭 구하기
	if( inCurBlock > 1 ) { inPrevBlock = inCurBlock - 1; }
	else             	 {inPrevBlock = inCurBlock; }
	
	inPrevPage = inPrevBlock * inPagePerBlock - inPagePerBlock + 1;
	
	//다음 블럭 구하기 
	if( inCurBlock < inTotalPageBlockCount ) { inNextBlock = inCurBlock + 1; }
	else                            		 { inNextBlock = inCurBlock; }
	
	//다음 페이지 구하기
	inNextPage = inNextBlock * inPagePerBlock - inPagePerBlock + 1;
	//####################################################################################################페이지 구하기 끝
	
	//-------------------------------------------------------------------------------------------------------
	//  콤보박스에 대한 처리
	//-------------------------------------------------------------------------------------------------------
	CodeBean codeBean  = new CodeBean();
	
	ArrayList<CodeBean> comboList = null;
	comboList = orderDao.getComboBox(paramData);
%>

<!DOCTYPE html>
<html>
<head>
<!-- 공용정의파일 -->
<%@ include file="/include/common_file.inc" %>
	<title>홍보물신청</title>  
     
    <script type="text/javascript">
    $(document).ready(function(){
    	$("#ord-list-area").show();
    	
		var frm = document.getElementById("formdata");
		frm.conditions.value = frm.srch_type.value;
    });
    
    // 주문확인 보기
    function fnShowOrderList(){
		var frm = document.getElementById("formdata");
		
    	frm.srch_type.value = frm.conditions.value;
    	frm.srch_key.value = encodeURIComponent(frm.search_name.value);
    	frm.action = "<%=root%>/prom/order_list.jsp";
    	frm.target = "_self";
    	frm.submit();
    }
	// 목차이동
	function goPage(page, block){
		var frm = document.getElementById("formdata");
		
 	    frm.inCurPage.value  = page;        
 	  	frm.inCurBlock.value = block; 
 	  	fnShowOrderList();
	}
    // 엑셀데이터 추출
    function fnExcelDown(gbn){
    	var frm = document.getElementById("formdata");
    	
    	frm.srch_type.value = frm.conditions.value;
    	frm.srch_key.value = encodeURIComponent(frm.search_name.value);
    	frm.action = "<%=root%>/prom/excel_down.jsp?gbn="+gbn;
    	frm.target = "iWorker";
    	frm.submit();
    }
    // 엑셀저장
    function fnSaveExcel(out){
    	saveExcel("src", "", out, "주문확인내역.xls");
    }
   </script>
</head>

<body>
<form id="formdata" name="formdata" method="post">
	<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
	<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 -->
	<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
	<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
	<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
	<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->

	<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>
	
 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("<%=root%>/include/header.jsp"); </script> 
	 	</section>
	 	
	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
	 	</section>
	 	
 		 <section class="contents">
 		 	<header> 
 		 		<h1>◎ <span>홍보물 신청  ☞  주문내역</span></h1>
 		 	</header>
 		 	
			 <article class="" id="material-menus">
		        <!-- 화면 오른쪽 페이지 영역 -->
		        <div class="menu-dtl-page">
		        	<!-- 1. 주문 확인 화면 -->
		        	<div id="ord-list-area">
			        	▶ 주문확인 - 매장
			    		<span class="btns"><button class="excelBtn" onclick="javascript:fnExcelDown('excelDown');">엑셀</button></span>
			    		<span class="btns"><button class="excelAllBtn" onclick="javascript:fnExcelDown('excelAllDown');">전체엑셀</button></span>
						
						<div id="search-condition">
							<!-- 검색기간 -->
							<div class="search-d">
					    		<label for="start_search" > 검색 기간 : </label>
					    		<input class="big_0" name="sDate" type="text" value="<%=StartDate%>"/> ~ 
								<input class="big_0" name="eDate" type="text" value="<%=EndDate%>"/> 
					  		</div>
					  		<!-- 기타 검색 조건 -->
					  		<div class="search-d">
						  		<label for="conditions" > 진행 상황 : </label>
					    		<select id="conditions" name="conditions">
					    			<option value="0">전체</option>
					    		<%
					    			if(comboList != null && comboList.size() > 0){ 
					    				for(int i=0; i<comboList.size(); i++){
											codeBean = (CodeBean)comboList.get(i);
							    			out.print("<option value='"+codeBean.getStrCode()+"'>"+codeBean.getStrCodeName()+"</option>");
					    				}
					    			}
								%>
					    		</select>
					    		<label for="search_name" > 전단지명 : </label>
					    		<input type="text" id="search_name" name="search_name" value="<%=srch_key %>"/>
					    		<span><button class="searchDateBtn" onclick="fnShowOrderList();">검색</button></span>	
					  		</div>
						</div>		        	
			        	<!-- 테이블 영역 -->
				  		<div id="ord-list-table" class="table">
							<table id="ord-list-data" width="1140" height="320" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="">
								<tr bgcolor="#b2b19c" align="center">
								  <th style="border-bottom: 1px solid #797979;" width="50"><font color="#ffffff"><b>순번</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="80"><font color="#ffffff"><b>주문일자</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="120"><font color="#ffffff"><b>주문번호</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="100"><font color="#ffffff"><b>품목구분</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="150"><font color="#ffffff"><b>홍보물명</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="60"><font color="#ffffff"><b>작업유형</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="80"><font color="#ffffff"><b>주문단위</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="60"><font color="#ffffff"><b>주문수량</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="80"><font color="#ffffff"><b>주문금액</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="60"><font color="#ffffff"><b>주문상태</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="80"><font color="#ffffff"><b>최종시안</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="60"><font color="#ffffff"><b>배송상태</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="80"><font color="#ffffff"><b>택배사</b></font></th>
								  <th style="border-bottom: 1px solid #797979;" width="80"><font color="#ffffff"><b>송장번호</b></font></th>
								</tr>
							<%
							if(list != null && list.size() > 0){ 
								for(int i=0; i<list.size(); i++){
									orderBean = (orderBean) list.get(i);
							%>
								<tr class="data" align="center" bgcolor="#ffffff">
								  <td><%=orderBean.get순번()%></td>
								  <td><%=orderBean.get주문일자()%></td>
								  <td><%=orderBean.get주문번호()%></td>
								  <td><%=orderBean.get홍보물코드명()%></td>
								  <td><%=orderBean.get홍보물명()%></td>
								  <td><%=orderBean.get작업유형()%></td>
								  <td><%=orderBean.get주문단위()%></td>
								  <td><%=orderBean.get주문수량()%></td>
								  <td><%=orderBean.get주문가격()%>원</td>
								  <td><%=JSPUtil.chkNull(orderBean.get주문상태())%></td>
								  <td><font color="#fb2a2a">시안확인(<%=orderBean.get시안번호()%>)</font></td>
								  <td><%=orderBean.get제작상태()%></td>
								  <td><%=JSPUtil.chkNull(orderBean.get택배사코드명())%></td>
								  <td><%=JSPUtil.chkNull(orderBean.get송장번호())%></td>
								</tr>
							<%
								}
							} else {
							%>
								<tr class="data" align="center" bgcolor="#ffffff"><td colspan="14">조회된 내용이 없습니다.</td></tr>
							<%
							}
							%>
				  			</table>

				  			<!-- 페이징 표시 -->
					  		<div class="paging">
							    <ul class="numbering">
							<% if(inTotalPageCount > 0){ %>
							<%   if(inCurBlock == 1){ %>
									<li class="f"><a href="#">◁</a></li>
							<%	 } else { %>
									<li class="f"><a href="javascript:goPage(1,1);" onFocus="this.blur()">◁</a></li>
							<%   } %>
							<%   if(inPrevBlock == inCurBlock){ %>
									<li class="p"><a href="#">PREV</a></li>
							<%	 } else { %>
									<li class="p"><a href="javascript:goPage(<%=inPrevPage%>,<%=inPrevBlock%>);" onFocus="this.blur()">PREV</a></li>
							<%   } %>
							<%
								int nPageIndex = 0;
								for(int i = 0; i < inPagePerBlock; i++){
									nPageIndex = inCurBlock * inPagePerBlock  - inPagePerBlock  + (i+1);
									if(nPageIndex <= inTotalPageCount){
										if(nPageIndex == inCurPage){
							%>
									<li><%=nPageIndex%></li>
							<%
										} else {
							%>
									<li class="p"><a href="javascript:goPage(<%=nPageIndex%>,<%=inCurBlock%>);" onFocus="this.blur()"><%=nPageIndex%></a></li>
							<%
										}
									}
								}
							%>
							<%   if(inNextBlock == inCurBlock){ %>
									<li class="n"><a href="#">NEXT</a></li>
							<%	 } else { %>
									<li class="n"><a href="javascript:goPage(<%=inNextPage%>,<%=inNextBlock%>);" onFocus="this.blur()">NEXT</a></li>
							<%   } %>
							<%   if(inTotalPageBlockCount == inCurBlock){ %>
									<li class="l"><a href="#">▷</a></li>
							<%	 } else { %>
									<li class="l"><a href="javascript:goPage(<%=inTotalPageCount%>,<%=inTotalPageBlockCount%>);" onFocus="this.blur()">▷</a></li>
							<%   } %>
							<% } %>  
							   	</ul>
							</div>
				  		</div>
				  		<!-- 테이블 끝 -->
			  		</div><!-- 1. 주문확인 끝 -->
		        </div>
	        </article>
		 </section>
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half">
	 	</div>
 		<!-- modal popup -->
	 	<div class="overlay-bg8" >
	 		<div class='dtl-pop' id='pop-order-dtl'></div>
	 	</div>
	 	
	</div><!-- end of wrap -->
</form>
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>
