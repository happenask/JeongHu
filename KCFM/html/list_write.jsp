<%
/** ############################################################### */
/** Program ID   : write.jsp														                                         */
/** Program Name : 글쓰기                              																			 */
/** Program Desc : 건의글, 문의글 작성                                        													 */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="test.dao.testDao" %>
<%@ page import="test.beans.testBean" %>
<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %> 
<%@ page import="board.beans.listBean" %> 
<%@ page import="board.dao.listDao" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/com/common.jsp"%>
 

<%
	String root     = request.getContextPath();	
	
	//String listNum    = JSPUtil.chkNull((String)paramData.get("listNum"),   ""); //게시판 번호
	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb"),      ""); //게시판 구분String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"),""); //등록자명
	
	int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1")); // 현재 페이지
	int inCurBlock   = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1")); // 현재 블럭
	int listNum      = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("listNum"), "0")); // 현재 블럭
	
	
	
	listBean bean = null; //리스트 목록용
	listDao  dao  = new listDao();
	ArrayList<listBean> list = null;
	
	
	
	String pageTitle = "공지 사항 상세";
	String writeYn   = "N";
	String fileYn    = "Y";
	
	
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"),""); //등록자명

	
	//게시판 구분값에 따라 목록 조회
	if(pageGb.equals("proposal")){
		pageTitle = "매장 건의 사항 상세";
		writeYn = "Y";
		
// 		list = dao.selectProposalDetail(paramData); 

		
	}else if(pageGb.equals("request")){
		pageTitle = "매장 요청 사항 상세";
		writeYn = "Y";
		
// 		list = dao.selectRequestDetail(paramData); 

	}else if(pageGb.equals("customer")){
		pageTitle = "고객의 소리 상세";
		writeYn = "N";

// 		list = dao.selectCustomerDetail(paramData); 


	}else if(pageGb.equals("video")){
		pageTitle = "교육 자료 상세";
		writeYn = "N";
		
// 		list = dao.selectVideoDetail(paramData); 
		
	}else{
		
		paramData.put("sseGroupCd",   sseGroupCd   );
		paramData.put("sseCorpCd",    sseCorpCd    );
		paramData.put("sseBrandCd",   sseBrandCd   );
		paramData.put("sseCustNm",    sseCustNm    );
		//paramData.put("listNum",      listNum      );
		
 		

 		
	}
	
	/*
	* 각 게시판에 맞게 추가해서 정보 조회
	*/
	String name    = ""; //작성자
	String title   = ""; //제목
	String comment = ""; //내용
	String addDate = ""; //등록일
	String readCnt = ""; //조회수
	
	
	
	

	
	
	
	
%>


<!DOCTYPE>
<html>
<head>
	<!-- 공용정의파일 -->
	<%@ include file="/include/common_file.inc" %>
     
    <script type="text/javascript">
    function fnChangeAttachFile(img)
    {
    	
    	var attachFile     = "";
    	var attachFilePath = "";
    	var attachFileName = "";
    	
    	document.inquiry_form.attachFileVal.value = "";

    	img.select();
    	
     	if( img.value.match(/\.(gif|jpg|jpeg|png)$/i) ) 
     	{
     		attachFile     = document.selection.createRangeCollection()[0].text.toString();
    		attachFileName = (attachFile).split("\\")[(attachFile).split("\\").length - 1];  // 파일명만 남김
    		document.inquiry_form.attachFileVal.value = attachFile;
    		
//    		alert("attachFile [ "+attachFile+" ]");
//    		alert("attachFileName [ "+attachFileName+" ]");
       	} 
     	else 
     	{
        	img.outerHTML = img.outerHTML;
        	alert('이미지 파일만 올릴수 있습니다.');
       	}
       	
    }

    //목록이동
	function goList(root)
	{	
		var inCurPage = document.getElementById("inCurPage");
		var inCurBlock = document.getElementById("inCurBlock");

		location.href= "list.jsp?inCurPage="+inCurPage.value+"&inCurBlock="+inCurBlock.value; 
	}
	
	
    //글저장
	 function goSave(){
		 
			$.ajax(
			{
				url      : "<%=root%>/board/detail_write_ok.jsp", 
				type     : "POST",
				data     : $("#form1").serialize(), 
				dataType : "html", 
				success  : function(data)
						   {  
							   if( trim(data) == "Y" )
							   { 
								   var inCurPage = document.getElementById("inCurPage");
								   location.href= "<%=root%>/board/list.jsp?pageGb=" + "<%=pageGb%>" + "&inCurPage=" + inCurPage.value; //글 저장 후 목록 이동
							   
				           	   }else if( trim(data) == "N" ){
						   
									alert("저장 실패!!!!"); 
				           	   }
			               }
		    });
    }
    
	//공백제거
    function trim(s) 
    {
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }
    </script>
</head>

<body>
 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("../include/header.jsp"); </script> 
	 	</section>
	 	
	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("../include/edit-info.jsp"); </script> 
	 	</section>
	<!--#### 메뉴 끝 ####--> 	
	 	
 		 <section class="contents">
 		 	<header>
 		 		<h1>◎ <span><%=pageTitle %></span></h1>
 		 	</header>
 		 	
				<div id="dtl_section" class="write">
					<form name="form1" method="post">
					    <input type="hidden" name="inCurPage"   id="inCurPage"   value="<%=inCurPage %>"    >  <!-- 현재 페이지 -->
						<input type="hidden" name="inCurBlock"  id="inCurBlock"  value="<%=inCurBlock %>"	>  <!-- 현재 블럭 -->
						<input type="hidden" name="listNum"     id="listNum"     value="<%=listNum%>"       > <!-- 목록순번 -->
						
				
				  		<table>
				  			<col width="16%"/>
				    		<col width="*"/>
				    		<tbody>
				    			<tr>
				      				<th>작성자</th>
				        			<%-- <td><%=name %></td> --%>
				        			<td> <%=sseCustNm %> </td>
				      			</tr>
				    			<tr>
				      				<th>제목</th>
				        			<td><input type="text" id="title" name="title"  value="<%=title%>"/></td>
				      			</tr>
				    			<tr>
				      				<td colspan="2">
				        				<p> 
							        		<textarea id="comment" name="comment" cols="105" rows="20" ><%=comment%></textarea>
							      		</p>
						 			</td>
				      			</tr>
				      			<tr>
				      				<th>첨부</th>
				        			<td><input type="file" id="attachFile" name="attachFile" onchange="fnChangeAttachFile(this);"/>&nbsp;</td>
			        			</tr>
				    		</tbody>
				  		</table>
				 		<p class="btn">
				 			<button type="button" class="golistBtn" onclick="goList();">목록</button>
				 			<button type="button" class="saveBtn" onclick="goSave();">저장</button>
				 		</p>
					</form>
					
				</div>
			</section>

	 		<!-- modal popup -->
		 	<div class="overlay-bg-half"></div>
	</div>

</body>
</html>