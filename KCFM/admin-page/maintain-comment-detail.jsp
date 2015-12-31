<!-- 
/** ############################################################### */
/** Program ID   : maintain-comment-detail.jsp                      */
/** Program Name : maintain-comment-detail.jsp                      */
/** Program Desc : 관리자 - 댓글관리 - 관리 (팝업으로 처리)                 */
/** Create Date  : 2015.05.07						              	*/
/** Update Date  :                                                  */
/** Programmer   : JHYOUN                                           */
/** ############################################################### */
 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.BoardConstant" %>

<%@ page import="admin.beans.commentBean" %> 
<%@ page import="admin.dao.commentDao" %>

<%@ include file="/com/common.jsp"%>

<%
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /maintain-comment-detail.jsp");
	String root = request.getContextPath();

    //-------------------------------------------------------------------------------------------------------
	// Session 정보
	//-------------------------------------------------------------------------------------------------------
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sseStoreCd   = JSPUtil.chkNull((String)session.getAttribute("sseStoreCd")  ,""); //매장코드
	String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm")   ,""); //등록자명
	String sseCustId    = JSPUtil.chkNull((String)session.getAttribute("sseCustId")   ,""); //등록자ID
	String sseStroeNm   = JSPUtil.chkNull((String)session.getAttribute("sseStroeNm")  ,""); //매장명

	//-------------------------------------------------------------------------------------------------------
	// Parameter 인터페이스 (화면간 데이터 Interface-영문으로 사용해야 함)
	//-------------------------------------------------------------------------------------------------------
	String pCORP_CD     = JSPUtil.chkNull((String)paramData.get("pCORP_CD"),  "");          //기업코드
	String pCRPN_CD     = JSPUtil.chkNull((String)paramData.get("pCRPN_CD"),  "");          //법인코드
	String pBRND_CD     = JSPUtil.chkNull((String)paramData.get("pBRND_CD"),  "");          //브랜드코드
	String pMEST_CD     = JSPUtil.chkNull((String)paramData.get("pMEST_CD"),  "");          //매장코드
	String pGESI_GB     = JSPUtil.chkNull((String)paramData.get("pGESI_GB"),  "");          //게시판 구분(01:공지사항, 02:교육자료, 11:건의사항, 12:요청사항)
	String pGESI_NO     = JSPUtil.chkNull((String)paramData.get("pGESI_NO"  ),"");          //게시번호
	
	int inTotalCnt      = 0;                                                                // 전체 레코드 수
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	System.out.println(">>>>> [jsp] 기업코드    ["  + pCORP_CD + "]" );
	System.out.println(">>>>> [jsp] 법인코드    ["  + pCRPN_CD + "]" );
	System.out.println(">>>>> [jsp] 브랜드코드 ["  + pBRND_CD + "]" );
	System.out.println(">>>>> [jsp] 매장코드    ["  + pMEST_CD + "]" );
	System.out.println(">>>>> [jsp] 게시구분    ["  + pGESI_GB + "]" );
	System.out.println(">>>>> [jsp] 게시번호    ["  + pGESI_NO + "]" );
	
	paramData.put("기업코드",   pCORP_CD   );
	paramData.put("법인코드",   pCRPN_CD   );
	paramData.put("브랜드코드", pBRND_CD   );
	paramData.put("매장코드",   pMEST_CD   );
	paramData.put("게시구분",   pGESI_GB   );
	paramData.put("게시번호",   pGESI_NO   );
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 자료에 대한 처리 (게시에 대한 등록내용 조회)
	//-------------------------------------------------------------------------------------------------------
	String title   = "";                                              //제목
	String comment = "";                                              //내용

	commentBean bean = null;                                          //등록정보처리
	commentDao  dao  = new commentDao();
	ArrayList<commentBean> list = null;
	
	list       = dao.commentDetail(paramData);                        //조회조건에 맞는 매장정보 조회
	inTotalCnt = dao.commentDetailCount(paramData);                   //전체레코드 수

	if(list != null && list.size() > 0){                        
		bean     = (commentBean)list.get(0);		
		
		title    = bean.get제목();
		comment  = bean.get내용();
	}
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 자료에 대한 처리 (게시에 대한 등록내용 조회)
	//-------------------------------------------------------------------------------------------------------
	list       = dao.commentDetailList(paramData);                    //조회조건에 맞는 매장정보 조회
	inTotalCnt = dao.commentDetailListCount(paramData);               //전체레코드 수
	//-------------------------------------------------------------------------------------------------------
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Expires" content="0"/> 
<meta http-equiv="Pragma" content="no-cache"/>
	<%@ include file="/include/common_file.inc" %>                     <!-- 2015-04-29 HJCHOI INCLUDE 삽입 -->
    
	<title>KCFM 배포 점포 선택</title>  
		
    <script type="text/javascript">
	$(document).ready(function()
	{ 
		getCurrent();
		fnCalendar();
	});
	
	$(function(){
		$("#btn-left").hover(function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		},function(){
			$("#ic-box-menu2-sub").stop().slideToggle();
		});
	});
    
	//html 파라미터 전달
	getNo = function(no){
		
	}

    //--------------------------------------------------------------------------------------------
    //  덧글입력 
    //--------------------------------------------------------------------------------------------
    function goWrite() 
    {
    	//------------------------------------------------------------------------------------------
		//  입력항목 체크
		//------------------------------------------------------------------------------------------
		if (trim(document.formdata.comm_write.value) == "" 
		||  trim(document.formdata.comm_write.value) == "null") {
			alert("댓글내용을 입력해 주세요");
			
			document.formdata.comm_write.focus();
			 
			return;
		} 
		//------------------------------------------------------------------------------------------
		//  처리대상 댓글번호 및 댓글내용 조립 (Interface 영역)
		//------------------------------------------------------------------------------------------
		document.formdata.dataGb.value     = "insert";
		document.formdata.pMEST_CD.value   = "<%=pMEST_CD%>";
		document.formdata.pDAGL_STMT.value = trim(document.formdata.comm_write.value);
		//------------------------------------------------------------------------------------------
		//  댓글관리 상세내역에 대한 수정 및 삭제처리 함수 호출 (수정처리)
		//------------------------------------------------------------------------------------------
		fn_update_delete_proc();
		//------------------------------------------------------------------------------------------
    }

    //--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 수정처리 ▷ 파라미터 : 댓글번호, 댓글내용 
    //--------------------------------------------------------------------------------------------
	function goSave(v_MEST_CD, v_DAGL_NO)
	{
    	//------------------------------------------------------------------------------------------
		//  입력항목 체크
		//------------------------------------------------------------------------------------------
		if (trim(document.getElementById("댓글내용"+v_DAGL_NO).value) == "" 
		||  trim(document.getElementById("댓글내용"+v_DAGL_NO).value) == "null") {
			alert("댓글내용을 입력해 주세요");
			
			document.getElementById("댓글내용"+v_DAGL_NO).focus();
			 
			return;
		} 
		//------------------------------------------------------------------------------------------
		//  처리대상 댓글번호 및 댓글내용 조립 (Interface 영역)
		//------------------------------------------------------------------------------------------
		document.formdata.dataGb.value     = "modify";
		document.formdata.pMEST_CD.value   = v_MEST_CD;
		document.formdata.pDAGL_NO.value   = v_DAGL_NO;
		document.formdata.pDAGL_STMT.value = trim(document.getElementById("댓글내용"+v_DAGL_NO).value);
		//------------------------------------------------------------------------------------------
		//  댓글관리 상세내역에 대한 수정 및 삭제처리 함수 호출 (수정처리)
		//------------------------------------------------------------------------------------------
		fn_update_delete_proc();
		//------------------------------------------------------------------------------------------
	}

    //--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 삭제처리 ▷  파라미터 : 댓글번호 
    //--------------------------------------------------------------------------------------------
	function goDelete(v_MEST_CD, v_DAGL_NO)
	{
		var msg;

		if (confirm("삭제하시겠습니까?")) {
			//------------------------------------------------------------------------------------------
			//  처리대상 댓글번호 및 댓글내용 조립 (Interface 영역)
			//------------------------------------------------------------------------------------------
			document.formdata.dataGb.value     = "delete";
			document.formdata.pMEST_CD.value   = v_MEST_CD;
			document.formdata.pDAGL_NO.value   = v_DAGL_NO;
			//------------------------------------------------------------------------------------------
			//  댓글관리 상세내역에 대한 수정 및 삭제처리 함수 호출 (삭제처리)
			//------------------------------------------------------------------------------------------
			fn_update_delete_proc();
			//------------------------------------------------------------------------------------------
		} else {
			return;
		}
	}

	//--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 수정 및 삭제처리 
    //--------------------------------------------------------------------------------------------
	function fn_update_delete_proc() 
	{
		var f=document.formdata;

		f.action = "<%=root%>/admin-page/maintain-comment-detail-ok.jsp";
		f.target = "iWorker";
		f.submit();
	}

    //--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 수정 및 삭제 처리 결과 확인 (maintain-comment_edit-ok.jsp 에서 호출됨)
    //--------------------------------------------------------------------------------------------
	function fn_update_delete_return(inqGubun, msg) 
	{
		if (msg == "Y") {
			alert("정상적으로 처리되었습니다.");
		} else {
			alert("저장실패");
		}
		//----------------------------------------------------------------------------------------
		//  MODAL 자신창 호출
		//----------------------------------------------------------------------------------------
        var url = "<%=root%>/admin-page/maintain-comment-detail.jsp?pCORP_CD=<%=pCORP_CD%>"
														        + "&pCRPN_CD=<%=pCRPN_CD%>"
														        + "&pBRND_CD=<%=pBRND_CD%>"
														        + "&pMEST_CD=<%=pMEST_CD%>"
														        + "&pGESI_GB=<%=pGESI_GB%>"
														        + "&pGESI_NO=<%=pGESI_NO%>";

	    window.name = "self";    
        window.open(url, "self");
		//----------------------------------------------------------------------------------------
	}

    //--------------------------------------------------------------------------------------------
    //   
    //--------------------------------------------------------------------------------------------
	function goClose()
	{
    	self.close();
	}
	
	//공백제거
    function trim(s) 
    {
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }


    function showComment(){
    	//alert("▼ 총 댓글");
    		
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
 	<form id="formdata" name="formdata" method="POST">
        <input type="hidden" name="dataGb"      id="dataGb"      value="">    
        <input type="hidden" name="pCORP_CD"    id="pCORP_CD"    value="<%=pCORP_CD%>">    
        <input type="hidden" name="pCRPN_CD"    id="pCRPN_CD"    value="<%=pCRPN_CD%>">    
        <input type="hidden" name="pBRND_CD"    id="pBRND_CD"    value="<%=pBRND_CD%>">    
        <input type="hidden" name="pMEST_CD"    id="pMEST_CD"    value="<%=pMEST_CD%>">    
        <input type="hidden" name="pGESI_GB"    id="pGEGI_GB"    value="<%=pGESI_GB%>">    
		<input type="hidden" name="pGESI_NO"    id="pGESI_NO"    value="<%=pGESI_NO%>">
		<input type="hidden" name="pDAGL_NO"    id="pDAGL_NO"    value="">
	    <input type="hidden" name="pDAGL_STMT"  id="pDAGL_STMT"  value="">
		 
 		  <section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>admistrator service &gt; 댓글관리 상세내역</span></h1>
 		 	</header>

 		 	<div id="cont-admin">
 		 		<div id="cont-list" class="list list-wide">
 		 			▶ <span class="no"></span>게시번호(<%=pGESI_NO%>) 에 대한 내용입니다.
					<div class="search-d">
					    <button type="button" class="golistBtn" onclick="goClose();">목록</button -->
				    </div>	
 		 			
				  		<table>
				  			<col width="15%"/>
				    		<col width="*"/>
				    		<thead>
				    			<tr>
				      				<th>제목</th>
				      				<td colspan="5" style="text-align:left">&nbsp;&nbsp;<b><%=title%></b>
				      				</td>
				      			</tr>
				    			<tr>
				    			    <th>내용</th>
				      				<td colspan="5" style="text-align:left">
				        				<div class="comm"><PRE>&nbsp;<%=comment%></PRE></div><!-- 글 내용 -->
			        				</td>
				      			</tr>

			    		    <tr>
			    		    	<th><p> 댓글입력</p></th>
			    		    	<td> 
					                <textarea style="width:85%" cols="90" rows="4" id="comm_write" name="comm_write" ></textarea>
					                &nbsp;&nbsp;
            					    <button style="vertical-align:top" type="button" class="btn_blank" id="btn_input" name="btn_input" onclick="goWrite();"></button> <!-- 댓글 입력버튼  -->
            					</td>    
					        </tr> 

				    		</thead>
				  		</table>
				  		
					<div id="comment">
						<p  class="count" onclick="showComment();"><span class="mark">▶</span> 총 댓글 (<span class="num"> <%=inTotalCnt%></span>)</p>  
						<ul class="comm_list hidden">
						    <table> 
					  			<col width="10%" />
					  			<col width="10%" />
					    		<col width="10%"/>
					    		<col width="*"/>
					    		<col width="15%"/>
					    		<thead>
					    			<tr>
					      				<th>매장명</th>
					      				<th>등록일</th>
					      				<th>작성자</th>
					        			<th>댓글내용</th>
					        			<th>편집</th>
					      			</tr>
					    		</thead>
					    		<tbody>
				<%
					int inSeq = 0;
						
					if( list != null && list.size() > 0 ) 
					{
						for( int i = 0; i < list.size(); i++ ) 
						{
							bean = (commentBean) list.get(i);
				%>
				      				<tr>
		        						<% if(bean.get댓글등록자().equals(sseCustNm))
		        						   {
		        					    %>
					        			<td><%=bean.get매장명()%></td>
					        			<td><%=bean.get댓글등록일자()%></td>
					      				<td><%=bean.get댓글등록자()%></td>       
					      				<td class="subject"><textarea  class="edit admin-text" id="댓글내용<%=bean.get댓글번호()%>" name="댓글내용<%=bean.get댓글번호()%>"><%=bean.get댓글내용()%></textarea></td>
					        			<td align="center">
					        				<button type="button" class="deleteBtn" onclick="goDelete('<%=bean.get매장코드()%>'
					        				                                                         ,'<%=bean.get댓글번호()%>');">삭제</button>
					        				<button type="button" class="modifyBtn" onclick="goSave('<%=bean.get매장코드()%>'
					        				                                                       ,'<%=bean.get댓글번호()%>');">수정</button>
					        			</td>
		        			            <% } else 
		        			               { 
		        			            %>
					        			<td><%=bean.get매장명()%></td>
					        			<td><%=bean.get댓글등록일자()%></td>
					      				<td><%=bean.get댓글등록자()%></td>       
					      				<td  class="subject"><pre><%=bean.get댓글내용()%></pre></td>
					        			<td align="center">
					        				<button type="button" class="deleteBtn" onclick="goDelete('<%=bean.get매장코드()%>'
					        				                                                         ,'<%=bean.get댓글번호()%>');">삭제</button>
					        			</td>
		        			            <% }
		        						%>         
				      				</tr>
				<%
						}
					} 
					else 
					{
				%>
					      			<tr>
					      				<td colspan="4">조회된 내용이 없습니다.</td>
					      			</tr>
				<%
					}
					
				%>
					    		</tbody>
					    		
					    		
							</table>
						</ul>
					</div> 


 		 		</div>
 		 	</div><!-- end of cont-admin -->

 		 	
 		</section>
 	 </form>
	 </div>

</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>