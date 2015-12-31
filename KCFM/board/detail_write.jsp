<%-- <%
/** ############################################################### */
/** Program ID   : detail_write.jsp									*/
/** Program Name : 글쓰기                              				*/
/** Program Desc : 건의글, 요청글 작성                              */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="test.dao.testDao" %>
<%@ page import="test.beans.testBean" %>
<%@ page import="com.util.CommUtil" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %> 
<%@ page import="board.beans.listBean" %> 
<%@ page import="board.dao.listDao" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/com/common.jsp"%>
<%@ include file="/com/fileUpload.jsp"%> 

<%
	String root       = request.getContextPath();	

	String pageGb     = JSPUtil.chkNull((String)paramData.get("pageGb"),    "" ); //게시구분
//	String srch_key   = JSPUtil.chkNull((String)paramData.get("srch_key") , "" ); //검색어
//	String srch_type  = JSPUtil.chkNull((String)paramData.get("srch_type"), "0"); //검색종류
	
	int inCurPage     = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1")); // 현재 페이지
	int inCurBlock    = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1")); // 현재 블럭
	
	String no = "";
	if("11".equals(pageGb)){
		no    = JSPUtil.chkNull((String)request.getParameter("no"  ),"00"); 
	}else if ("12".equals(pageGb)){
		no    = JSPUtil.chkNull((String)request.getParameter("no"  ),"01");
	}else {
		no    = JSPUtil.chkNull((String)request.getParameter("no"  ),""  );
	}
	
	String modify     = JSPUtil.chkNull((String)request.getParameter("modify"  ),"");    //수정여부
	String listNum    = JSPUtil.chkNull((String)request.getParameter("listNum" ),"");    //게시번호
	String srch_key   = JSPUtil.chkNull((String)request.getParameter("srch_key" ),"");   //검색어
	String srch_type  = JSPUtil.chkNull((String)request.getParameter("srch_type" ),"0"); //검색종류
	
	
	listBean bean = null; //리스트 목록용
	listDao  dao  = new listDao();
	ArrayList<listBean> list = null;
	ArrayList comboList = null;
	ArrayList<listBean> listDownload = null;
	
	String pageTitle = "공지 사항 상세";
	String writeYn   = "N";
	String fileYn    = "Y";
	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),""); //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),""); //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),""); //브랜드코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),""); //등록자명
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),""); //매장코드
	
	System.out.println("detail_write=========================");
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
	System.out.println("no         : " + no);
	System.out.println("=====================================");
	
	paramData.put("sseGroupCd",    sseGroupCd     );
	paramData.put("sseCorpCd",     sseCorpCd      );
	paramData.put("sseBrandCd",    sseBrandCd     );
	paramData.put("sseCustNm",     sseCustNm      );
	paramData.put("listNum",       listNum        );
	paramData.put("sseCustStoreCd",sseCustStoreCd );
	paramData.put("inCurPage"     ,inCurPage      );
	paramData.put("inCurBlock"    ,inCurBlock     );
	paramData.put("srch_key"      ,srch_key       );
	paramData.put("srch_type"     ,srch_type      );
	paramData.put("no"            ,no             );
	
	
	//게시판 구분값에 따라 목록 조회
	if(pageGb.equals("01")){
		pageTitle = "공지 사항";
		writeYn = "N";
		
	}else if(pageGb.equals("02")){
		pageTitle = "교육 자료";
		writeYn = "N";

	}else if(pageGb.equals("11")){
		pageTitle = "매장 건의 사항";
		writeYn = "Y";
		
	}else if(pageGb.equals("12")){
		pageTitle = "매장 요청 사항";
		writeYn = "Y";

	}
	
	
	if(modify != ""){
		if(pageGb.equals("11")){
			pageTitle = "매장 건의 사항";
			writeYn = "Y";
			
	 		list = dao.selectProposalDetail(paramData);
	 		listDownload = dao.selectRequestDownloadList(paramData);
	 		
		}else if(pageGb.equals("12")){
			pageTitle = "매장 요청 사항";
			writeYn = "Y";
	
			list = dao.selectProposalDetail(paramData);	
			listDownload = dao.selectRequestDownloadList(paramData);
	
		}
	}
	
	/*
	* 각 게시판에 맞게 추가해서 정보 조회
	*/
	String name          = ""; //작성자
	String title         = ""; //제목
	String comment       = ""; //내용
	String addDate       = ""; //등록일
	String readCnt       = ""; //조회수
	String fileName1     = ""; //첨부파일이름1
	String fileName2     = ""; //첨부파일이름2
	String fileName3     = ""; //첨부파일이름3
	String fileOrderNum1 = ""; //첨부파일순번1
	String fileOrderNum2 = ""; //첨부파일순번2
	String fileOrderNum3 = ""; //첨부파일순번3
	
	
	//상세 정보
	if(list != null && list.size() > 0){
	bean    = (listBean)list.get(0);
	
	name    = bean.get등록자();
	title   = bean.get제목();
	comment = bean.get내용();
	addDate = bean.get등록일자();
	readCnt = bean.get조회수();
	//listNum = bean.get게시번호();
	listNum = bean.get건의요청번호();
		
	}
	
	
	comboList = dao.selectComboClaim();
	

	if (listDownload != null && listDownload.size() > 0) {
		for( int i = 0; i < listDownload.size(); i++ ) 
		{
			bean = (listBean) listDownload.get(i);
			
			if (i==0){
				
				fileName1     = bean.get파일명();
				fileOrderNum1 = bean.get파일순번();
				
			} else if (i==1){
				
				fileName2     = bean.get파일명();
				fileOrderNum2 = bean.get파일순번();
				
			} else {
				
				fileName3     = bean.get파일명();
				fileOrderNum3 = bean.get파일순번();
				
			}
				
		}
	}
	System.out.println("fileName============================");
	System.out.println("fileName1 + " + fileName1);
	System.out.println("fileName2 + " + fileName2);
	System.out.println("fileName3 + " + fileName3);
	System.out.println("fileName============================");
%>


<!DOCTYPE>
<html>
<head>
	<!-- 공용정의파일 -->
	<%@ include file="/include/common_file.inc" %>
     
    <script type="text/javascript">
    
    function fnStartLoad(){
    	
    	var combo = document.getElementById("comboClaimGb");
    	combo.disabled = false;
    	
    	if ('<%=pageGb%>'=='11'){
    		combo.value = '00';
    		combo.disabled = true;
    	}
    	
    	combo.value = '<%=no%>' ;
    	
    	
    	//첨부파일 추가
    	var f = document.form1 ;
    		
    	document.getElementById("s첨부파일1").innerHTML = '<%=fileName1%>';
    	document.getElementById("s첨부파일2").innerHTML = '<%=fileName2%>';
    	document.getElementById("s첨부파일3").innerHTML = '<%=fileName3%>';
    	
    }
    

    //목록이동
	function goList(root)
	{	
		var frm = document.getElementById("form2");
    	frm.action = "<%=root%>/board/list.jsp";
    	frm.submit();
    	
	}
    
	//글 저장
 	function goSave()
 	{
 		var vModYn1   = document.getElementById("modYn1").value;
 		var vModYn2   = document.getElementById("modYn2").value;
 		var vModYn3   = document.getElementById("modYn3").value;
 		var frm       = document.getElementById("form1");
 		var comboVal  = document.getElementById("comboClaimGb").value;
 		var vListNum  = document.getElementById("listNum").value;
 		var vTitle    = document.getElementById("title").value;
 		var vComment  = document.getElementById("comment").value; 
 		var aFile1    = document.getElementById("attachFile1").value; //input type : file
		var aFile2    = document.getElementById("attachFile2").value; //input type : file
		var aFile3    = document.getElementById("attachFile3").value; //input type : file
//		var sFile1    = document.getElementById("s첨부파일1").value;
		var sFile1    = "";
		var sFile2    = "";
		var sFile3    = "";
		var del1      = "";
		var del2      = "";
		var del3      = "";
		
		var vOldComment  = document.getElementById("oldcomment").value;  
		
		
		if ('<%=fileName1%>' != ''){
			
			sFile1 = document.getElementById("s첨부파일1").value;
		}
		if ('<%=fileName2%>' != ''){
					
			sFile2 = document.getElementById("s첨부파일2").value;
		}
		if ('<%=fileName3%>' != ''){
			
			sFile3 = document.getElementById("s첨부파일3").value;
		}
 		
 		if(!trim(vTitle)){
 			alert("제목을 입력해주세요!");
 			document.getElementById("title").focus();
 			return;
 		}
 		if(!trim(vComment)){
 			alert("내용을 입력해주세요!");
 			document.getElementById("comment").focus();
 			return;
 		}

   		 if( ((vModYn1 != 'Y') && (vModYn2 != 'Y') && (vModYn3 != 'Y')) && (vTitle == '<%=title%>') && (vComment == vOldComment) ){ 
   			alert("변경된 내용이 없습니다.");
   			return;
   		} 
 		
 		
 		if(aFile1 == '' && sFile1 == '') {
 			del1 = '<%=fileOrderNum1%>';
 		}
 		if(aFile2 == '' && sFile2 == '') {
 			del2 = '<%=fileOrderNum2%>';
 		}
 		if(aFile3 == '' && sFile3 == '') {
 			del3 = '<%=fileOrderNum3%>';
 		}
 		frm.action = "<%=root%>/board/detail_write_ok.jsp?comboVal=" + comboVal + "&listNum=" + vListNum + "&mode1="+ del1 + "&mode2=" + del2 + "&mode3="+ del3;
 		frm.submit();
			 
 	}
    
	
	//파일첨부 이름 변경
	function fnChgFname(obj)
	{
		var oName = obj.name ;
		var vGubn = oName.substr(oName.length-1,1);		//구분값

		if (vGubn == "1") {
			document.getElementById("s첨부파일1").innerHTML = "";
		} else if(vGubn == "2") {
			document.getElementById("s첨부파일2").innerHTML = "";
		} else {
			document.getElementById("s첨부파일3").innerHTML = "";
		}

			
	}
	
	//파일첨부 초기화
	function fnIniFile(obj)
	{
		
		var frm    = document.getElementById("form1");
		var aFile1 = document.getElementById("attachFile1");
		var aFile2 = document.getElementById("attachFile2");
		var aFile3 = document.getElementById("attachFile3");
		var sFile1 = document.getElementById("s첨부파일1");
		var sFile2 = document.getElementById("s첨부파일2");
		var sFile3 = document.getElementById("s첨부파일3");

		
		if(obj == "s첨부파일1"){
			
			if(aFile1.value == "" && sFile1.value == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if(!confirm("삭제하시겠습니까?")){
				return;
			}else {
				sFile1.value = "";
				sFile1.style.display = 'none';
				aFile1.style.display = '';
				var input = $("#attachFile1");
				input.replaceWith(input.val('').clone(true));
				frm.modYn1.value='Y';
			}
				 		
		}else if(obj == "s첨부파일2"){
			
			if(aFile2.value == "" && sFile2.value == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if(!confirm("삭제하시겠습니까?")){
				return;
			}else {
				sFile2.value = "";
				sFile2.style.display = 'none';
				aFile2.style.display = '';
				var input = $("#attachFile2");
				input.replaceWith(input.val('').clone(true));
				frm.modYn2.value='Y';
			}
			
		}else if(obj == "s첨부파일3"){
			
			if(aFile3.value == "" && sFile3.value == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if(!confirm("삭제하시겠습니까?")){
				return;
			}else{
				sFile3.value = "";
				sFile3.style.display = 'none';
				aFile3.style.display = '';
				var input = $("#attachFile3");
				input.replaceWith(input.val('').clone(true));
				frm.modYn3.value='Y';
			}
		}
		
	}
	
	function fnModYn(strYn, obj){
		
		var frm = document.form1;
		
		if (obj == 's첨부파일1'){
			frm.modYn1.value=strYn;	
		}else if (obj == 's첨부파일2'){
			frm.modYn2.value=strYn;	
		}else if (obj == 's첨부파일3'){
			frm.modYn3.value=strYn;	
		}
		
		
	}
	
	//파일첨부삭제
	function fnDeleteFile(obj)
	{
		
		var aFile1 = document.getElementById("attachFile1").value;
		var aFile2 = document.getElementById("attachFile2").value;
		var aFile3 = document.getElementById("attachFile3").value;
		
		if(obj == "s첨부파일1"){
			
			if(aFile1 == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if (!confirm("삭제하시겠습니까?")){
				return;
			}else{
				var input = $("#attachFile1");
				input.replaceWith(input.val('').clone(true));
			}
		}else if(obj == "s첨부파일2"){
			
			if(aFile2 == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if (!confirm("삭제하시겠습니까?")){
				return;
			}else{
				var input = $("#attachFile2");
				input.replaceWith(input.val('').clone(true));
			}
		}else if(obj == "s첨부파일3"){
			
			if(aFile3 == ""){
				alert("삭제할 파일이 없습니다.");
				return;
			}else if (!confirm("삭제하시겠습니까?")){
				return;
			}else{
				var input = $("#attachFile3");
				input.replaceWith(input.val('').clone(true));
			}
		}
		
		<%-- frm.action = "<%=root%>/board/detail_write_ok.jsp?comboVal=" + comboVal + "&listNum=" + listNum + "&mode=del" ;
 		frm.submit(); --%>
		
	}
	
    </script>
</head>

<body onload="fnStartLoad();">
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
 						<form id="form1" name="form1" method="post" enctype="multipart/form-data" >
 						    <input type="hidden" name="srch_key"         id="srch_key"         value="<%=srch_key %>"     > <!-- 검색어      -->
							<input type="hidden" name="srch_type"        id="srch_type"        value="<%=srch_type %>"    > <!-- 검색타입    -->
 						    <input type="hidden" name="inCurPage"        id="inCurPage"        value="<%=inCurPage %>"    > <!-- 현재 페이지 -->
 							<input type="hidden" name="inCurBlock"       id="inCurBlock"       value="<%=inCurBlock %>"   > <!-- 현재 블럭   -->
 							<input type="hidden" name="listNum"          id="listNum"          value="<%=listNum%>"       > <!-- 목록순번    -->
 							<input type="hidden" name="pageGb"           id="pageGb"           value="<%=pageGb%>"        > <!-- 게시구분    -->
 							<input type="hidden" name="modYn1"           id="modYn1"           value=""                   > <!-- 첨부파일수정여부    -->
 							<input type="hidden" name="modYn2"           id="modYn2"           value=""                   > <!-- 첨부파일수정여부    -->
 							<input type="hidden" name="modYn3"           id="modYn3"           value=""                   > <!-- 첨부파일수정여부    -->
 							<input type="hidden" name="oldcomment"       id="oldcomment"       value="<%=comment%>"       > <!-- 이전내용    -->
 							
 							
 					  		<table>
 					  			<col width="16%"/>
 					    		<col width="*"/>
 					    		<col width="16%"/>
 					    		<col width="*"/>
 					    		<tbody>
 					    			<tr>
 					      				<th>작성자</th>
 					        			<td width="100"><%=sseCustNm %></td>
 					        			
 					        			<th>요청구분</th>
 					        			<td> 
 					        			<%
 					        			if ("11".equals(pageGb))
 					        			{
 					        			%>
 					        				<select id="comboClaimGb" onchange="fnStartLoad(this.selectedIndex)" >
 					      						<option value="00" >기본(건의사항)   </option>
 					      					</select>
 					        			<%
 					        			}else{
 					        			%>
 					      					<select id="comboClaimGb" onchange="" >
 					      						<option value="01" >물류크레임       </option>
 					      						<option value="02" >포스게시판       </option>
 					      						<option value="03" >인테리어보수신청 </option>
 					      					</select>
 					      				<%
 					        			}
 					      				%>	
 					      				</td>
 					      			</tr>
 					    			<tr>
 					      				<th>제목</th>
 					        			<td colspan="3"><input type="text" id="title" name="title"  value="<%=title%>"/>
 					        			                <input type="text" style="display: none"/>
 					        			</td>
 					      			</tr>
 					    			<tr>
 					      				<td colspan="4">
 					        				<p> 
 								        		<textarea id="comment" name="comment" cols="105" rows="20" ><%=comment%></textarea>
 								      		</p>
 							 			</td>
 					      			</tr>
 					      			<tr>
 					      				<th>첨부1</th>
				        				<td colspan="3">
				        					<div id="fileDiv1">
				        					
				        						<%
				        						if ("".equals(fileName1)){
				        						%>
				        							<span style="position:absolute; display:none;" id="s첨부파일1" ></span>
				        							<input type="file" id="attachFile1" name="attachFile1" onchange="fnChgFname(this);if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일1');} else {fnModYn('N','s첨부파일1');};" value=""/>&nbsp;
				        							<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnDeleteFile('s첨부파일1');"></button> <!-- 글 삭제 -->
				        						<%	
				        						}else{
				        						%>
					        						<span style="position:absolute;" id="s첨부파일1" ></span>
					        						<input style="display: none;" style="" type="file" id="attachFile1" name="attachFile1" onchange="fnChgFname(this);if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일1');} else {fnModYn('N','s첨부파일1');};" value=""/>&nbsp;
					        						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnIniFile('s첨부파일1');"></button> <!-- 글 삭제 -->
				        						<%
				        						}
				        						%>
				        							
				        					</div>
				        				</td>
 				        			</tr>
 					      			<tr>
 					      				<th>첨부2</th>
				      					<td colspan="3">
				      						<div id="fileDiv2">
				      						
				      							<%
				        						if ("".equals(fileName2)){
				        						%>
				        							<span style="position:absolute; display:none;" id="s첨부파일2" ></span>
				        							<input type="file" id="attachFile2" name="attachFile2" onchange="fnChgFname(this); if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일2');} else {fnModYn('N','s첨부파일2');};" value=""/>&nbsp;
				        							<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnDeleteFile('s첨부파일2');"></button> <!-- 글 삭제 -->
				        						<%	
				        						}else{
				        						%>
					        						<span style="position:absolute;" id="s첨부파일2" ></span>
					        						<input style="display: none;"  type="file" id="attachFile2" name="attachFile2" onchange="fnChgFname(this); if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일2');} else {fnModYn('N','s첨부파일2');};" value=""/>&nbsp;
					        						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnIniFile('s첨부파일2');"></button> <!-- 글 삭제 -->
				        						<%
				        						}
				        						%>
				      						
				      						</div>
				      					</td>
 				        			</tr>
 					      			<tr>
 					      				<th>첨부3</th>
 					      				<td colspan="3">
 					      					<div id="fileDiv3">
 					      					
 					      						<%
				        						if ("".equals(fileName3)){
				        						%>
				        							<span style="position:absolute; display:none;" id="s첨부파일3" ></span>
				        							<input type="file" id="attachFile3" name="attachFile3" onchange="fnChgFname(this); if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일3');} else {fnModYn('N','s첨부파일3');};" value=""/>&nbsp;
				        							<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnDeleteFile('s첨부파일3');"></button> <!-- 글 삭제 -->
				        						<%	
				        						}else{
				        						%>
					        						<span style="position:absolute;" id="s첨부파일3" ></span>
					        						<input style="display: none" type="file" id="attachFile3" name="attachFile3" onchange="fnChgFname(this);if(checkFileSize(this,1)) {fnModYn('Y','s첨부파일3');} else {fnModYn('N','s첨부파일3');};" value=""/>&nbsp;
					        						<button  type="button" class="deleteBtn" id="deleteBtn" name="deleteBtn" onclick="fnIniFile('s첨부파일3');"></button> <!-- 글 삭제 -->
				        						<%
				        						}
				        						%>
				        						
 					      					</div>
 					      				</td>
 				        			</tr>
 					    		</tbody>
 					  		</table>
 					 		<p class="btn">
 					 			<button type="button" class="golistBtn" onclick="goList();">목록</button>
 					 			<button type="button" class="saveBtn" onclick="goSave();">저장</button>
 					 		</p>
 						</form>
 						<form id="form2" name="form2" method="post"  >
 						    <input type="hidden" name="srch_key"         id="srch_key"         value="<%=srch_key %>"   > <!-- 검색어      -->
							<input type="hidden" name="srch_type"        id="srch_type"        value="<%=srch_type %>"  > <!-- 검색타입    -->
 						    <input type="hidden" name="inCurPage"        id="inCurPage"        value="<%=inCurPage %>"  > <!-- 현재 페이지 -->
 							<input type="hidden" name="inCurBlock"       id="inCurBlock"       value="<%=inCurBlock %>" > <!-- 현재 블럭   -->
 							<input type="hidden" name="listNum"          id="listNum"          value="<%=listNum%>"     > <!-- 목록순번    -->
 							<input type="hidden" name="pageGb"           id="pageGb"           value="<%=pageGb%>"      > <!-- 게시구분    -->
 						</form>
 						
 					</div>
 				
			</section>

	 		<!-- modal popup -->
		 	<div class="overlay-bg-half"></div>
	</div>

</body>
</html>