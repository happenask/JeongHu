<%
/** ############################################################### */
/** Program ID   : faq_list.jsp                                     */
/** Program Name : FAQ 리스트                                       */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.BoardConstant" %>

<%@ page import="admin.beans.faqBean" %> 
<%@ page import="admin.dao.faqDao" %>

<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /faq_list.jsp");

	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("사용자ID"  , (String)session.getAttribute("sseCustId"));
	paramData.put("사용자명"  , (String)session.getAttribute("sseCustNm"));
	paramData.put("권한코드"  , (String)session.getAttribute("sseCustAuth"));
	paramData.put("매장코드"  , (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("매장명"    , (String)session.getAttribute("sseCustStoreNm"));

	faqBean bean = null; 					//리스트 목록용
	faqDao  dao  = new faqDao();
	ArrayList<faqBean> list = null;
	
	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 10;                                                                            // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 10;                                                                            // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝

	list = dao.selectFaqInfo(paramData); 	//FAQ리스트 조회
	inTotalCnt = dao.selectFaqListCount(paramData); //전체레코드수
	
	
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
		
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/common_file.inc" %>
	<title>FAQ</title>  
     
    <script type="text/javascript">
        $(document).ready(function(){

        });

        $(function(){
    		$("#btn-left").hover(function(){
    			$("#ic-box-menu2-sub").stop().slideToggle();
    		},function(){
    			$("#ic-box-menu2-sub").stop().slideToggle();
    		});
    	});
    </script>

	<script type="text/javascript">

		function goSave(seqNo){
		
			document.form1.질문번호.value = seqNo;  
			
			$.ajax(
			{
				url      : "<%=root%>/board/faq_list_ok.jsp", 
				type     : "POST",
				data     : $("#form1").serialize(), 
				dataType : "html", 
				success  : function(data)
						   {  
							   if( trim(data) == "Y" )
							   { 
								  	//location.href= "<%=root%>/board/faq_list.jsp";
				           	   }else if( trim(data) == "N" ){
									alert("조회수  수정 실패!!!!"); 
				           	   }
			               }
		    });
		}
		
	    function trim(s) 
	    {
	    	s += ''; // 숫자라도 문자열로 변환
	    	return s.replace(/^\s*|\s*$/g, '');
	    }
	    
	    function goPage(page, block) 
     	{
     	    var f = document.form1;	
    	    f.inCurPage.value  = page;        
    	    f.inCurBlock.value = block; 
     	    f.submit();
    	}
	    
	    function search_list() 
     	{
    		var f = document.form1;
    		var v_searchWord = 	f.search_word.value;

    		f.srch_type.value  = f.search_type.value;
    		f.srch_key.value   = encodeURIComponent(v_searchWord);
    		f.inCurPage.value  = "1";
    		f.inCurBlock.value = "1";
    		
    		f.submit();
    		
    	}
	    
	</script>

    
</head>

<body>
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
 		 		<h1>◎ <span>자주하는 질문</span></h1>
 		 	</header>
 		 	
			 <article class="tabs" id="call-center-menus">
		         <div id="qna_area" class="txt_left">
					<form id="form1" name="form1" method="post">
						<input type="hidden" name="질문번호"       id="질문번호"       value=""		>  				   <!-- 질문번호 -->
						<%-- <input type="hidden" name="srch_key"       id="srch_key"       value="<%=srch_key %>"		>  <!-- 검색어 -->
						<input type="hidden" name="srch_type"      id="srch_type"      value="<%=srch_type %>"		>  <!-- 검색타입 --> --%>
						<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
						<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
						<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
						<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->
						
						
					<p style="color:#bfbfbf; font-size:12px; margin: 10px 0;">※ 질문을 클릭하면 답변을 보실 수 있습니다!! </p>
					   <!-- //////////////////////////////// 가맹점 FAQ 시작 //////////////////////////////////////// -->
				   	<div id="tab1" class="tab">
					    <dl class="qna_list">
		<%
				
			String title = "";
				
			if( list != null && list.size() > 0 ) 
			{
				for( int i = 0; i < list.size(); i++ ) 
				{
					bean = (faqBean) list.get(i);
					
		%>
					    	<dt class="q" onclick="goSave(<%=bean.get질문번호() %>);"><%=bean.get질문내용() %></dt>
						    <dd class="a"><%=bean.get답변내용() %></dd>

		<%
				}
			} 
		%>
					    </dl>
					</div>
					
				</div>
				
				<!-- 페이징 표시 -->
			  	<div class="paging">
				    <ul class="numbering">
					        
				<%	
					if( inTotalPageCount > 0 ) 
					{
						if( inCurBlock == 1 ) 
						{
				%>
							<li class="f"><a href="#">◁</a></li>
				<%	
						} 
						else 
						{
				%>
							<li class="f"><a href="JavaScript:goPage('1','1');" onFocus='this.blur()'>◁</a></li>  
				<%	
						}
						
						if( inPrevBlock == inCurBlock ) 
						{
				%>
				  		 	<li class="p"><a href="#">PREV</a></li>
				<% 
						
						} 
						else 
						{
				%>
							<li class="p"><a href="JavaScript:goPage('<%=inPrevPage %>','<%=inPrevBlock %>');" onFocus='this.blur()'>PREV</a></li>
				<%
						}
					
						int nPageIndex = 0;
						
						for( int i = 0; i < inPagePerBlock; i++ ) 
						{
							nPageIndex = inCurBlock * inPagePerBlock  - inPagePerBlock  + (i+1);
							
							if( nPageIndex <= inTotalPageCount ) 
							{
								if( nPageIndex == inCurPage ) 
								{
				%>   
				   			<li><%=nPageIndex %></li>
				<%
								} 
								else 
								{
				%>
				   			<li><a href="JavaScript:goPage('<%=nPageIndex %>','<%=inCurBlock %>');" onFocus='this.blur()'><%=nPageIndex %></a></li>
				<%
								}
							}
						}
						
						if( inNextBlock == inCurBlock ) 
						{
				%>
				    		<li class="n"><a href="#">NEXT</a></li>
				<%
						} 
						else 
						{
				%>
				    		<li class="n"><a href="JavaScript:goPage('<%=inNextPage %>','<%=inNextBlock %>');"  onFocus='this.blur()'>NEXT</a></li>
				<%
						}
						
						if( inTotalPageBlockCount == inCurBlock ) 
						{
				%>
							<li class="l"><a href="#">▷</a></li>
				<%	
						} 
						else 
						{
				%>
							<li class="l"><a href="JavaScript:goPage('<%=inTotalPageCount%>','<%=inTotalPageBlockCount%>');" onFocus='this.blur()'>▷</a></li>			
				<%	
						}
					}
				%>
					</ul>
				</div>
			  		<!--#### 페이징 표시 끝 ####-->
				
					<!-- <div id="search-option">
			    		<label for="select_search" class="hidden">검색구분</label>
			    		<select id="search_type" name="search_type" style="height:20px; width:80px;">
			    			<option value="0">전체</option>
			    			<option value="title">제목</option>
			    			<option value="content">내용</option>
			    		</select>
			    		<label for="search_word" class="hidden">검색어</label>
			    		<input type="text" id="search_word" name="search_word" style="ime-mode:active" value="" style="width:180px;" onKeyDown="if(event.keyCode==13) { searchBtn.focus();  }"/>
			    		<button type="button" id = "searchBtn" class="searchBtn"  onclick="search_list();">검색</button>
			  		</div> -->
				
				
				</form>
        	</article>
				
 		 </section>
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div><!-- end of wrap -->
	
<script type="text/javascript"> 

var $tab=$(".tab")
var $tab_q=$tab.find(".q")
var $tab_a=$tab.find(".a")

$tab_q.show()
$tab_a.hide()
 
$(function(){
	$(".q").click(function(){
		$(this).css("color","#f00");
		$(this).next().stop().slideToggle();
	},function(){
		
		$(this).css("color","#000");
		$(this).next().stop().slideToggle();
	});
});
 
</script>
</body>
</html>