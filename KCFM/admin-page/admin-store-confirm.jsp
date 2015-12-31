
<!-- 
/** ############################################################### */
/** Program ID   : admin-store-confirm.jsp                          */
/** Program Name : admin-store-confirm.jsp                          */
/** Program Desc : 관리자 - 매장확인 (매장에서 확인에 대한 자료조회)          */
/** Create Date  : 2015.04.28						              	*/
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

<%@ page import="admin.beans.storeBean" %> 
<%@ page import="admin.dao.storeDao" %>

<%@ include file="/com/common.jsp"%>

<%
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-store-confirm.jsp");
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
	String pageGb      = JSPUtil.chkNull((String)paramData.get("pageGb"),    "");          //게시판 구분(01:공지사항, 02:교육자료)
	String pBOARD_NO   = JSPUtil.chkNull((String)paramData.get("pBOARD_NO"  ),"");         //게시번호
	String pCONFIRM_YN = JSPUtil.chkNull((String)paramData.get("pCONFIRM_YN"),"%");        //확인여부
	
	int inTotalCnt     = 0;                                                                // 전체 레코드 수
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	System.out.println(">>>>> [jsp] 게시구분   ["  + pageGb + "]" );
	System.out.println(">>>>> [jsp] 게시번호   ["  + pBOARD_NO + "]" );
	System.out.println(">>>>> [jsp] 확인여부   ["  + pCONFIRM_YN + "]" );
	
	paramData.put("기업코드",   sseGroupCd   );
	paramData.put("법인코드",   sseCorpCd    );
	paramData.put("브랜드코드", sseBrandCd   );
	paramData.put("게시구분",   pageGb       );
	paramData.put("게시번호",   pBOARD_NO    );
	paramData.put("확인여부",   pCONFIRM_YN  );
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 자료에 대한 처리
	//-------------------------------------------------------------------------------------------------------
	storeBean bean = null;                                            //댓글관리
	storeDao  dao  = new storeDao();
	ArrayList<storeBean> list = null;
	
	list       = dao.confirmStoreList(paramData);                      //조회조건에 맞는 매장정보 조회
	inTotalCnt = dao.confirmStoreListCount(paramData);                 //전체레코드 수
	//-------------------------------------------------------------------------------------------------------
%>

<!DOCTYPE html>
<html>
<head>
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
    //  매장 배포확인에 대한 조회 
    //--------------------------------------------------------------------------------------------
    function search_list() 
    {
        //----------------------------------------------------------------------------------------
        //  확인여부 조립
        //----------------------------------------------------------------------------------------
        document.formdata.pCONFIRM_YN.value = document.formdata.ConfirmYN.value;

        var f = document.formdata;
        
        f.action = "#";
        f.submit();
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

    </script>
</head>

<script for=window event=onload>
	document.formdata.ConfirmYN.value = "<%=pCONFIRM_YN%>";
</script>

<body>
  
 	<div id="wrap" >
 		<form id="formdata" name="formdata" method="POST">
        <input type="hidden" name="pageGb"      id="pageGb"      value="<%=pageGb %>">    
		<input type="hidden" name="pBOARD_NO"   id="pBOARD_NO"   value="<%=pBOARD_NO%>">
		<input type="hidden" name="pCONFIRM_YN" id="pCONFIRM_YN" value="<%=pCONFIRM_YN%>">
		 
 		  <section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>admistrator service &gt; 배포점포 확인내역</span></h1>
 		 	</header>

 		 	<div id="cont-admin">
 		 		<div id="cont-list" class="list list-wide">
 		 			▶ <span class="no"></span>게시번호(<%=pBOARD_NO%>) 에서 <%=inTotalCnt%>건이 조회 되었습니다.
					<div class="search-d">
			    		<label for="start_search" > ▶ 구분 : </label>
			    		<select id="ConfirmYN" name="ConfirmYN" style="height:20px; width:100px;">
				    			<option value="%" selected="selected">전체</option>					    			
				    			<option value="Y">확인</option>
				    			<option value="N">미확인</option>
				    	</select>
				    	<button	type="button" class="searchDateBtn" onclick="search_list();">조회</button>
				    </div>	
 		 			
 		 			<table>
			  			<col width="8%"/>
			  			<col width="12%"/>
			  			<col width="12%"/>
			  			<col width="12%"/>
			    		<col width="15%"/>
			    		<col width="12%"/>
			    		<col width="8%"/>
			    		<col width="12%"/>
			    		<col width="12%"/>
			    		<thead>
			    			<tr>
			        			<th>번호</th>
			        			<th>법인명</th>
			        			<th>브랜드명</th>
			        			<th>매장코드</th>
			        			<th>매장명</th>
			        			<th>확인자</th>
			        			<th>확인여부</th>
			        			<th>확인일자</th>
			        			<th>등록일자</th>
			      			</tr>
			    		</thead>
			    		<tbody>
		<%
			int inSeq = 0;
				
			String title = "";
				
			if( list != null && list.size() > 0 ) 
			{
				for( int i = 0; i < list.size(); i++ ) 
				{
					bean = (storeBean) list.get(i);
		%>
      				<tr>
	      				<td><input type="hidden"   id="번호"     name="번호"     value="<%=bean.getROW_NUM()%>"><%=bean.getROW_NUM()%></td>       
	      				<td><input type="hidden"   id="법인명"    name="법인명"   value="<%=bean.get법인명()%>"><%=bean.get법인명()%></td>       
	      				<td><input type="hidden"   id="브랜드명"  name="브랜드명"  value="<%=bean.get브랜드명()%>"><%=bean.get브랜드명()%></td>       
	      				<td><input type="hidden"   id="매장코드"  name="매장코드"  value="<%=bean.get매장코드()%>"><%=bean.get매장코드()%></td>       
	      				<td><input type="hidden"   id="매장명"    name="매장명"   value="<%=bean.get매장명()%>"><%=bean.get매장명()%></td>       
	      				<td><input type="hidden"   id="확인자"    name="확인자"   value="<%=bean.get확인자()%>"><%=bean.get확인자()%></td>       
	      				<td><input type="hidden"   id="확인여부"  name="확인여부"  value="<%=bean.get확인여부()%>"><%=bean.get확인여부()%></td>       
	      				<td><input type="hidden"   id="확인일자"  name="확인일자"  value="<%=bean.get확인일자()%>"><%=bean.get확인일자()%></td>       
	      				<td><input type="hidden"   id="배포일자"  name="배포일자"  value="<%=bean.get배포일자()%>"><%=bean.get배포일자()%></td> 
      				</tr>
		<%
					inSeq--;
				}
			} 
			else 
			{
		%>
			      	<tr>
			      		<td colspan="9">조회된 내용이 없습니다.</td>
			      	</tr>
		<%
			}
			
		%>
			    		</tbody>
			    	</table>
					   	
			 		<p class="btn">
			 			<button type="button" class="golistBtn" onclick="goClose();">목록</button -->
			 		</p>
 		 		</div>
 		 	</div><!-- end of cont-admin -->
 		 	
 		</section>
 	 	</form>
	 	</div>

</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>