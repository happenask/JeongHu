<%-- <%
/** ############################################################### */
/** Program ID   : pr-view.jsp                                      */
/** Program Name : 매장주문 상세                                    */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %> 
<%@ page import="board.beans.listBean" %> 
<%@ page import="board.dao.listDao" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.beans.listBean"%>

<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>


<%
	String listNum    = JSPUtil.chkNull((String)paramData.get("listNum"),   "" ); //게시판 번호
	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb"),    "" ); //게시판 구분
	String srch_key   = JSPUtil.chkNull((String)paramData.get("srch_key") , "" ); //검색어
	String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type"), "0"); //검색종류
	
	srch_key =  URLDecoder.decode(srch_key , "UTF-8");
	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),""); //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),""); //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),""); //브랜드코드
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),""); //매장코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),""); //등록자명
	
	
	//상세보기에서 보고있던 목록으로 이동하기 위해서
	int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1")); // 현재 페이지
	int inCurBlock   = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1")); // 현재 블럭
	
	
	listBean bean            = null; //리스트 목록용
	listDao  dao             = new listDao();
	ArrayList<listBean> list = null;


	
	
	System.out.println("detail_view=====================================");
	System.out.println("기업코드   : " + sseGroupCd);
	System.out.println("법인코드   : " + sseCorpCd);
	System.out.println("브랜드코드 : " + sseBrandCd);
	System.out.println("매장코드   : " + sseCustStoreCd);
	System.out.println("게시번호   : " + listNum);
	System.out.println("게시구분   : " + pageGb);
	System.out.println("inCurPage  : " + inCurPage);
	System.out.println("inCurBlock : " + inCurBlock);
	System.out.println("srch_key   : " + srch_key);
	System.out.println("srch_type  : " + srch_type);
	System.out.println("=====================================");
	
	paramData.put("sseGroupCd"    ,   sseGroupCd     );
	paramData.put("sseCorpCd"     ,   sseCorpCd      );
	paramData.put("sseBrandCd"    ,   sseBrandCd     );
	paramData.put("sseCustStoreCd",   sseCustStoreCd );
	paramData.put("sseCustNm"     ,   sseCustNm      );
	paramData.put("listNum"       ,   listNum        );
	paramData.put("pageGb"        ,   pageGb         );
	paramData.put("inCurPage"     ,   inCurPage      );
	paramData.put("inCurBlock"    ,   inCurBlock     );
	paramData.put("srch_key"      ,   srch_key       );
	paramData.put("srch_type"     ,   srch_type      );
	

	list        = dao.selectNoticeDetail(paramData); //상세보기 정보 조회 
	
	String name    = ""; //작성자
	String title   = ""; //제목
	String comment = ""; //내용
	String addDate = ""; //등록일
	String readCnt = ""; //조회수
	
	String commName    = ""; //작성자
	String commComment = ""; //내용
	String commAddDate = ""; //등록일
	String commNum     = "";
	String noticeGb    = ""; //공지구분
	
	String sTitle = "";
	//상세 정보
	if(list != null && list.size() > 0){
		bean     = (listBean)list.get(0);		
		name     = bean.get등록자();
		title    = bean.get제목();
		comment  = bean.get내용();
		addDate  = bean.get등록일자();
		readCnt  = bean.get조회수();
		
		
		
	}
	
%>

<!DOCTYPE html>
<html>
<head>
	<!-- 공용정의파일 -->
	<%@ include file="/include/common_file.inc" %>
     
    <script type="text/javascript">

    $(document).ready(function()
	{  
		$("#header .gnb>ul").find("li#"+"<%=pageGb %>").addClass("active");
	});
     
    function showComment(){
     	//alert("▼ 총 덧글");	
     	if($(".comm_list").hasClass("show")== true ){
         	$(".mark").text("▶");
     		$(".comm_list").removeClass("show").addClass("hidden");
     	}
     	else{
         	$(".mark").text("▼");
     		$(".comm_list").removeClass("hidden").addClass("show");
     		window.scrollTo(0, document.body.scrollHeight);
     	}
    }
     
     
     
	</script>
</head>

<body>
 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("<%=root%>/include/pr-header.jsp"); </script> 
	 	</section>

	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
	 	</section>
	 	
	 	<br><br>
	 	
 		<section class="contents admin">
			<header><h1> ◎ <span>promotion service &gt; 매장주문상세</span></h1></header>
 		 	
			<div id="dtl_section" class="view">
				<form id="form1" name="form1" method="post">
					<input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		   >  <!-- 검색어 -->
					<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		   >  <!-- 검색타입 -->
					<input type="hidden" name="inCurPage"      id="inCurPage"      value="<%=inCurPage %>"         >  <!-- 현재 페이지 -->
					<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		   >  <!-- 현재 블럭 -->
					<input type="hidden" name="listNum"        id="listNum"        value="<%=listNum %>"           >  <!-- 게시판 번호 -->
				    <input type="hidden" name="pageGb"         id="pageGb"         value="<%=pageGb %>"            >  <!-- 게시판 종류 구분 값 -->
				    <input type="hidden" name="sseCustNm"      id="sseCustNm"      value="<%=sseCustNm %>"         >  <!-- 게시판 종류 구분 값 -->
					
			 		<p class="btn above">
			 			<button type="button" class="golistBtn" onclick="goList('<%=pageGb %>');"></button> <!-- 목록이동 -->
			 		</p>
			  		<table>
			  			<col width="15%"/>
			    		<col width="20%"/>
			    		<col width="15%"/>
			    		<col width="20%"/>
			    		<col width="15%"/>
			    		<col width="10%"/>
			    		<thead>
			    			<tr>
			      				<th>주문번호</th>
			      				<td>1</td>
			      				<th>브랜드명</th>
			      				<td>1</td>
			      				<th>매장</th>
			      				<td>1</td>
			      			</tr>
			    			<tr>
			      				<th>주문일자</th>
			      				<td>1900-01-01</td>
			      				<th>전단지명</th>
			      				<td>1</td>
			        			<th>전단지유형</th>
			        			<td>1</td>
			      			</tr>
			      			<tr>
			      				<th>전단지규격</th>
			      				<td>1</td>
			      				<th>주문단위</th>
			      				<td>1</td>
			        			<th>주문수량</th>
			        			<td>1</td>
			      			</tr>
			      			<tr>
			      				<th>인쇄문구</th>
			      				<td colspan="2"><textarea cols="35" rows="4" id="printDesc" name="printDesc" readOnly></textarea></td>
			      				<th>추가요청</th>
			      				<td colspan="2"><textarea cols="35" rows="4" id="addDesc" name="addDesc" readOnly></textarea></td>
			      			</tr>
			      			<tr>
			      				<th>주문상태정보</th>
		      					<td colspan="2" align="center"><input type="radio" id="orderType" name="orderType" value="02">주문확인</td>
		      					<td align="center"><input type="radio" id="orderType" name="orderType" value="03">시안진행</td>
		      					<td colspan="2" align="center"><input type="radio" id="orderType" name="orderType" value="04">시안완료</td>
			      			</tr>
			      			<tr>
			      				<th>시안첨부</th>
			      				<td colspan="5">
			      					<span style="position:absolute; style:none;" id="s첨부파일1" ></span>
			        				<input type="file" id="attachFile1" name="attachFile1" onchange="fnChgFname(this); checkFileSize(this);" value=""/>
			      				</td>
			      			</tr>
			      			<tr>
			      				<td colspan="6" align="center">
			      					<button type="button" class="saveBtn" id="saveBtn" name="saveBtn"  onclick=""></button>
			      				</td>
			      			</tr>
			    		</thead>
			  		</table>
				</form>
				
				<!-- 덧글영역 -->
				<div id="write_comm">
				     <p>덧글입력</p> 
				     <textarea cols="90" rows="4" id="comm_write" name="comm_write" ></textarea>
				     <button class="btn_blank" id="btn_input" name="btn_input" onclick="goWriteComment();"></button>
			    </div>

				<div id="comment">
					<p  class="count" onclick="showComment();"><span class="mark">▶</span> 총 덧글 (<span class="num"> 2 </span>)</p>  
					<ul class="comm_list hidden">    
						<li>
				  			<p><span class="writer">unitas </span><span class="date"> 2015-03-02</span></p>
		          			<div id="comm_text" class="comm">덧글덧글덧글덧글덧글덧글덧글..</div> 
						</li>
						<li>
				  			<p><span class="writer">unitas </span><span class="date"> 2015-03-01</span></p> 
		          			<div id="comm_text" class="comm" style="padding-left:50px; color:#bbb;"> - 비밀 덧글입니다.</div> 
						</li>
					</ul>
				</div> 
			</div>
		</section>

	 	<!-- modal popup -->
		<div class="overlay-bg-half"></div>
	</div>

<script type="text/javascript">
	
	//다운로드 버튼 오버 이미지 링크
	var $container = $("#dtl_section").find("table tbody");
	var $key=$container.find(".attached-file>a");
	var $item=$key.find("img");
	var link = "assets/images/btns/" ;
	
	// 이벤트
	$key.bind("mouseover", over);
	$key.bind("mouseleave", out);
	$key.bind("mouseenter", action);
	
	function over(){
		 //alert( $item.attr("src") );
		 var img = link + "btn_download_over.png";
		 $item.attr("src", img);
	}
	function action(){
		 //alert( $item.attr("src") );
		 var img = link + "btn_download_act.png";
		 $item.attr("src", img);
	}
	function out(){
		 //alert( $item.attr("src") );
		 var img = link + "btn_download.png";
		 $item.attr("src", img);
	}
</script>

</body>
</html>