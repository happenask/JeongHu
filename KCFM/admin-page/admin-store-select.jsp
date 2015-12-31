
<!-- 
/** ############################################################### */
/** Program ID   : admin-store-select.jsp                           */
/** Program Name : admin-store-select.jsp                           */
/** Program Desc : 관리자 - 매장선택 (공지사항 및 교육자료에 대한 배포시 사용)   */
/** Create Date  : 2015.04.21						              	*/
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
	log4u.log("CALL /admin-store-select.jsp");
	String root = request.getContextPath();

    //-------------------------------------------------------------------------------------------------------
	// Session 정보
	//-------------------------------------------------------------------------------------------------------
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sseCorpCd    = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sseBrandCd   = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	//String sseStoreCd   = JSPUtil.chkNull((String)session.getAttribute("sseStoreCd")  ,""); //매장코드
	//String sseCustNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm")   ,""); //등록자명
	//String sseCustId    = JSPUtil.chkNull((String)session.getAttribute("sseCustId")   ,""); //등록자ID
	//String sseStroeNm   = JSPUtil.chkNull((String)session.getAttribute("sseStroeNm")  ,""); //매장명
	String sseCustAuth  = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth"));
	//-------------------------------------------------------------------------------------------------------
	// Parameter 인터페이스 (화면간 데이터 Interface-영문으로 사용해야 함)
	//-------------------------------------------------------------------------------------------------------
	String pageGb      = JSPUtil.chkNull((String)paramData.get("pageGb"),    "");          //게시판 구분(01:공지사항, 02:교육자료)
	String dataGb      = JSPUtil.chkNull((String)paramData.get("dataGb"),    "");          //데이터구분(new, modify)
	String comboGb     = JSPUtil.chkNull((String)paramData.get("comboGb"),   "");          //
	
	String pCORP_CD    = JSPUtil.chkNull((String)paramData.get("pCORP_CD"  ),"");          //기업코드
	String pCRPN_CD    = JSPUtil.chkNull((String)paramData.get("pCRPN_CD"  ),"");          //법인코드
	String pBRND_CD    = JSPUtil.chkNull((String)paramData.get("pBRND_CD"  ),"");          //브랜드코드
	String pMEST_CD    = JSPUtil.chkNull((String)paramData.get("pMEST_CD"  ),"");          //매장코드
	String pBOARD_NO   = JSPUtil.chkNull((String)paramData.get("pBOARD_NO"  ),"");         //게시번호
	
	int inTotalCnt     = 0;                                                                // 전체 레코드 수
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	if (pCORP_CD.equals("") || pCORP_CD == null ) {          // 기업코드 처리 app 권한이 90이 아닐경우 
		if (sseCustAuth.equals("90")){
			pCORP_CD = "%";
		}else{	
		pCORP_CD = sseGroupCd;
		}
	}
	if (pCRPN_CD.equals("") || pCRPN_CD == null ) {          // 법인코드 처리
		if (sseCustAuth.equals("90")){
			pCRPN_CD = "%";
		}else{	
			pCRPN_CD = sseCorpCd;
		}
	}
	if (pBRND_CD.equals("") || pBRND_CD == null) {          // 브랜드코드 처리
		if (sseCustAuth.equals("90")){
			pBRND_CD = "%";
		}else{	
			pBRND_CD = sseBrandCd;
		}
	}
	if(dataGb.equals("new")){	                              // 게시번호 처리 (신규인 경우)
		pBOARD_NO = "9999" + pageGb;
	}
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 일자에 대하여 조립
	//-------------------------------------------------------------------------------------------------------
	//System.out.println(">>>>> [jsp] 기업코드   ["  + pCORP_CD + "]" );
	//System.out.println(">>>>> [jsp] 법인코드   ["  + pCRPN_CD + "]" );
	//System.out.println(">>>>> [jsp] 브랜드코드 [" + pBRND_CD + "]" );
	//System.out.println(">>>>> [jsp] 게시구분   ["  + pageGb + "]" );
	//System.out.println(">>>>> [jsp] 게시번호   ["  + pBOARD_NO + "]" );
	
	paramData.put("기업코드",   pCORP_CD   );
	paramData.put("법인코드",   pCRPN_CD    );
	paramData.put("브랜드코드", pBRND_CD    );
	paramData.put("게시구분",   pageGb      );
	paramData.put("게시번호",   pBOARD_NO  );
	//-------------------------------------------------------------------------------------------------------
	//  조회대상 자료에 대한 처리
	//-------------------------------------------------------------------------------------------------------
	storeBean bean = null;                                            //댓글관리
	storeDao  dao  = new storeDao();
	ArrayList<storeBean> list = null;
	
	list       = dao.selectStoreList(paramData);                      //조회조건에 맞는 매장정보 조회
	inTotalCnt = dao.selectStoreListCount(paramData);                 //전체레코드 수
	
	//System.out.println(">>>>> count ###   ["  + inTotalCnt + "]" );
	//-------------------------------------------------------------------------------------------------------
%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="/include/common_file.inc" %> 							<!--2015-04-29 HJCHOI 수정  -->
    
	<title>KCFM 배포 점포 선택</title>  
		
    <script type="text/javascript">
	$(document).ready(function()
	{ 
		getCurrent();
		fnCalendar();
		
		$(document.getElementsByName("pSELECT_YN1")).change(function() {
			for(var i = 0; i < document.getElementsByName("pSELECT_YN1").length; i++) {
				if(document.getElementsByName("pSELECT_YN1")[i].checked == true) {
					document.getElementsByName("sMEST_CD1")[i].style.color = "#0000FF";
					document.getElementsByName("sMEST_NM1")[i].style.color = "#0000FF";
				} else {
					document.getElementsByName("sMEST_CD1")[i].style.color = "#000000";
					document.getElementsByName("sMEST_NM1")[i].style.color = "#000000";
				}
			}
		});
			
		$(document.getElementsByName("pSELECT_YN2")).change(function() {
			for(var i = 0; i < document.getElementsByName("pSELECT_YN2").length; i++) {
				if(document.getElementsByName("pSELECT_YN2")[i].checked == true) {
					document.getElementsByName("sMEST_CD2")[i].style.color = "#0000FF";
					document.getElementsByName("sMEST_NM2")[i].style.color = "#0000FF";
				} else {
					document.getElementsByName("sMEST_CD2")[i].style.color = "#000000";
					document.getElementsByName("sMEST_NM2")[i].style.color = "#000000";
				}
			}
		});

		$(document.getElementsByName("pSELECT_YN3")).change(function() {
			for(var i = 0; i < document.getElementsByName("pSELECT_YN3").length; i++) {
				if(document.getElementsByName("pSELECT_YN3")[i].checked == true) {
					document.getElementsByName("sMEST_CD3")[i].style.color = "#0000FF";
					document.getElementsByName("sMEST_NM3")[i].style.color = "#0000FF";
				} else {
					document.getElementsByName("sMEST_CD3")[i].style.color = "#000000";
					document.getElementsByName("sMEST_NM3")[i].style.color = "#000000";
				}
			}
		});

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
    //  매장에 대한 처리 
    //--------------------------------------------------------------------------------------------
	function goSave()
	{
		var f=document.formdata;

		var vList = document.getElementsByName("pSELECT_YN1");
	    var chkCnt = 0;

	    var vCORP_CD = new Array();		//기업코드
	    var vCRPN_CD = new Array();		//법인코드
	    var vBRND_CD = new Array();		//브랜드코드
	    var vMEST_CD = new Array();		//매장코드

	    //----------------------------------------------------------------------------------------
	    //   선택된 매장에 대한 조립
	    //----------------------------------------------------------------------------------------
	    for (var i = 0; i < vList.length; i++)
	    {
	      if ( vList[i].checked == true )
	      {
	    	vCORP_CD[chkCnt] = document.getElementsByName("pCORP_CD1")[i].value;
	    	vCRPN_CD[chkCnt] = document.getElementsByName("pCRPN_CD1")[i].value;
	    	vBRND_CD[chkCnt] = document.getElementsByName("pBRND_CD1")[i].value;
            vMEST_CD[chkCnt] = document.getElementsByName("pMEST_CD1")[i].value;
            
	        chkCnt = chkCnt + 1;
	      }
	    }
	    vList = document.getElementsByName("pSELECT_YN2");
	    for (var i = 0; i < vList.length; i++)
	    {
	      if ( vList[i].checked == true )
	      {
	    	vCORP_CD[chkCnt] = document.getElementsByName("pCORP_CD2")[i].value;
	    	vCRPN_CD[chkCnt] = document.getElementsByName("pCRPN_CD2")[i].value;
	    	vBRND_CD[chkCnt] = document.getElementsByName("pBRND_CD2")[i].value;
	        vMEST_CD[chkCnt] = document.getElementsByName("pMEST_CD2")[i].value;

	        chkCnt = chkCnt + 1;
	      }
	    }
	    vList = document.getElementsByName("pSELECT_YN3");
	    for (var i = 0; i < vList.length; i++)
	    {
	      if ( vList[i].checked == true )
	      {
	    	vCORP_CD[chkCnt] = document.getElementsByName("pCORP_CD3")[i].value;
	    	vCRPN_CD[chkCnt] = document.getElementsByName("pCRPN_CD3")[i].value;
	    	vBRND_CD[chkCnt] = document.getElementsByName("pBRND_CD3")[i].value;
	        vMEST_CD[chkCnt] = document.getElementsByName("pMEST_CD3")[i].value;
	        
	        chkCnt = chkCnt + 1;
	      }
	    }

	    if ( chkCnt == 0 )
	    {
	      alert("선택된 매장이 없습니다.");
	      return;
	    }

	    //----------------------------------------------------------------------------------------
	    //   선택된 매장에 대한 interface 변수조립
	    //----------------------------------------------------------------------------------------
        for (var i = 0; i < vMEST_CD.length; i++)
        {
            if ( i == 0 ) {
                f.pCORP_CD.value = vCORP_CD[i];
                f.pCRPN_CD.value = vCRPN_CD[i];
                f.pBRND_CD.value = vBRND_CD[i];
                f.pMEST_CD.value = vMEST_CD[i];
            } else {
            	f.pCORP_CD.value = f.pCORP_CD.value + "," + vCORP_CD[i];
            	f.pCRPN_CD.value = f.pCRPN_CD.value + "," + vCRPN_CD[i];
            	f.pBRND_CD.value = f.pBRND_CD.value + "," + vBRND_CD[i];
            	f.pMEST_CD.value = f.pMEST_CD.value + "," + vMEST_CD[i];
            }
        }
	    //----------------------------------------------------------------------------------------
	    //  Form Data Interface
	    //----------------------------------------------------------------------------------------

		//alert("페이지구분 [" + f.pageGb.value + "]");

    	//f.pCORP_CD.value = document.formdata.sel_CORP_CD.value;
    	//f.pCRPN_CD.value = document.formdata.sel_CRPN_CD.value;
    	//f.pBRND_CD.value = document.formdata.sel_BRND_CD.value;

    	f.action = "<%=root%>/admin-page/admin-store-select-ok.jsp";
		f.target = "iWorker";
		
		f.submit();
	    //----------------------------------------------------------------------------------------

    	//self.close();
    	//------------------------------------------------------------------------------------------
	}
	
    //--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 수정 및 삭제 처리 결과 확인 (admin-store-select-ok 에서 호출됨)
    //--------------------------------------------------------------------------------------------
	function goSave_return(rowCount) 
	{
		//alert(rowCount + " 개 매장을 선택하셨습니다");

		var objectName = window.dialogArguments;                   // Modal 과의 파라미터 interface
		objectName.storeCount = rowCount;
			
		self.close(); 
	}

    //
    function search_list() 
    {
    	document.formdata.pCORP_CD.value = document.formdata.sel_CORP_CD.value;
   		document.formdata.pCRPN_CD.value = document.formdata.sel_CRPN_CD.value;
    	document.formdata.pBRND_CD.value = document.formdata.sel_BRND_CD.value;

        //----------------------------------------------------------------------------------------
		//  MODAL 자신창 호출
		//----------------------------------------------------------------------------------------
  		var url = "<%=root%>/admin-page/admin-store-select.jsp?comboGb="    + document.formdata.comboGb.value
  		                                                    + "&pageGb="    + "<%=pageGb%>"
  		                                                    + "&dataGb="    + "<%=dataGb%>"
  		                                                    + "&pBOARD_NO=" + "<%=pBOARD_NO%>"
                                                            + "&pCORP_CD="  + document.formdata.pCORP_CD.value
                                                            + "&pCRPN_CD="  + document.formdata.pCRPN_CD.value
                                                            + "&pBRND_CD="  + document.formdata.pBRND_CD.value;

	    window.name = "self";    
        window.open(url, "self");
    }

    function fnSelect_all() 
    {
	    for (var i = 0; i < document.getElementsByName("pSELECT_YN1").length; i++)
	    {
	      document.getElementsByName("pSELECT_YN1")[i].checked = true;
		  document.getElementsByName("sMEST_CD1")[i].style.color = "#0000FF";
		  document.getElementsByName("sMEST_NM1")[i].style.color = "#0000FF";
	    }
	    for (var i = 0; i < document.getElementsByName("pSELECT_YN2").length; i++)
	    {
	      document.getElementsByName("pSELECT_YN2")[i].checked = true;
		  document.getElementsByName("sMEST_CD2")[i].style.color = "#0000FF";
		  document.getElementsByName("sMEST_NM2")[i].style.color = "#0000FF";
	    }
	    for (var i = 0; i < document.getElementsByName("pSELECT_YN3").length; i++)
	    {
	      document.getElementsByName("pSELECT_YN3")[i].checked = true;
		  document.getElementsByName("sMEST_CD3")[i].style.color = "#0000FF";
		  document.getElementsByName("sMEST_NM3")[i].style.color = "#0000FF";
	    }
    }        
        
    function fnSelect_clear() 
    {
	    for (var i = 0; i < document.getElementsByName("pSELECT_YN1").length; i++)
	    {
	      document.getElementsByName("pSELECT_YN1")[i].checked = false;
		  document.getElementsByName("sMEST_CD1")[i].style.color = "#000000";
		  document.getElementsByName("sMEST_NM1")[i].style.color = "#000000";
	    }
	    for (var i = 0; i < document.getElementsByName("pSELECT_YN2").length; i++)
	    {
	      document.getElementsByName("pSELECT_YN2")[i].checked = false;
		  document.getElementsByName("sMEST_CD2")[i].style.color = "#000000";
		  document.getElementsByName("sMEST_NM2")[i].style.color = "#000000";
	    }
	    for (var i = 0; i < document.getElementsByName("pSELECT_YN3").length; i++)
	    {
	      document.getElementsByName("pSELECT_YN3")[i].checked = false;
		  document.getElementsByName("sMEST_CD3")[i].style.color = "#000000";
		  document.getElementsByName("sMEST_NM3")[i].style.color = "#000000";
	    }
    }        
    
	//공백제거
    function trim(s) 
    {
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }

    //--------------------------------------------------------------------------------------------
    //  콤보정보 처리 (load구분:C - 변경, L - Load) (combo구분 : CORP, CRPN, BRND)
    //--------------------------------------------------------------------------------------------
	function fnCombo_Proc(v_loadGb, v_comboGb)
	{
		var f=document.formdata;

		//----------------------------------------------------------------------------------------
		//  입력파라미터 조립 (INTERFACE 변수)  
		//----------------------------------------------------------------------------------------
		f.loadGb.value   = v_loadGb;
		f.comboGb.value  = v_comboGb;

		if(document.formdata.sel_CORP_CD.value == "" || document.formdata.sel_CORP_CD.value == "null") {
			f.pCORP_CD.value = "<%=pCORP_CD%>";
		} else {
			f.pCORP_CD.value = document.formdata.sel_CORP_CD.value;
		} 
		if(document.formdata.sel_CRPN_CD.value == "" || document.formdata.sel_CRPN_CD.value == "null") {
			f.pCRPN_CD.value = "<%=pCRPN_CD%>";
		} else {
			f.pCRPN_CD.value = document.formdata.sel_CRPN_CD.value;
		} 
		//----------------------------------------------------------------------------------------
		//  입력파라미터 조립 (INTERFACE 호출)
		//----------------------------------------------------------------------------------------
		f.action = "<%=root%>/admin-page/admin-store-select-combo.jsp";
		f.target = "iWorker";
		
		f.submit();
		//----------------------------------------------------------------------------------------
	}
	
    //--------------------------------------------------------------------------------------------
    //  댓글관리 상세내역에 대한 수정 및 삭제 처리 결과 확인 (admin-store-select-ok 에서 호출됨)
    //--------------------------------------------------------------------------------------------
	function fnCombo_Return(msg) 
	{
		if(document.formdata.comboGb.value == "CORP") {
			$("#sel_CORP_CD option").remove();
			$("#sel_CORP_CD").append(msg);

			document.formdata.sel_CORP_CD.value = document.formdata.pCORP_CD.value;
			
	        fnCombo_Proc(document.formdata.loadGb.value, "CRPN");             // 법인정보 콤보처리
		} else if(document.formdata.comboGb.value == "CRPN") {
			$("#sel_CRPN_CD option").remove();
			$("#sel_CRPN_CD").append(msg);

			document.formdata.sel_CRPN_CD.value = document.formdata.pCRPN_CD.value;
			
	        fnCombo_Proc(document.formdata.loadGb.value, "BRND");             // 브랜드정보 콤보처리
		} else if(document.formdata.comboGb.value == "BRND") {
			$("#sel_BRND_CD option").remove();
			$("#sel_BRND_CD").append(msg);

			if(document.formdata.loadGb.value == "L") {                       // Load 되는 경우 선택된 브랜드 사용
				document.formdata.sel_BRND_CD.value = document.formdata.pBRND_CD.value;
			}
		}
	}
	
    </script>
</head>

<script for=window event=onload>
    fnCombo_Proc("L", "CORP");                                           // 기업정보 콤보처리

	//---------------------------------------------------------------------------------------
    //  대상점포 선택 색상처리 (span 의 색상변경함)
    //---------------------------------------------------------------------------------------
	for(var i = 0; i < document.getElementsByName("pSELECT_YN1").length; i++) {
		if(document.getElementsByName("pSELECT_YN1")[i].checked == true) {
			document.getElementsByName("sMEST_CD1")[i].style.color = "#0000FF";
			document.getElementsByName("sMEST_NM1")[i].style.color = "#0000FF";
		} else {
			document.getElementsByName("sMEST_CD1")[i].style.color = "#000000";
			document.getElementsByName("sMEST_NM1")[i].style.color = "#000000";
		}
	}

    for(var i = 0; i < document.getElementsByName("pSELECT_YN2").length; i++) {
		if(document.getElementsByName("pSELECT_YN2")[i].checked == true) {
			document.getElementsByName("sMEST_CD2")[i].style.color = "#0000FF";
			document.getElementsByName("sMEST_NM2")[i].style.color = "#0000FF";
		} else {
			document.getElementsByName("sMEST_CD2")[i].style.color = "#000000";
			document.getElementsByName("sMEST_NM2")[i].style.color = "#000000";
		}
	}

    for(var i = 0; i < document.getElementsByName("pSELECT_YN3").length; i++) {
		if(document.getElementsByName("pSELECT_YN3")[i].checked == true) {
			document.getElementsByName("sMEST_CD3")[i].style.color = "#0000FF";
			document.getElementsByName("sMEST_NM3")[i].style.color = "#0000FF";
		} else {
			document.getElementsByName("sMEST_CD3")[i].style.color = "#000000";
			document.getElementsByName("sMEST_NM3")[i].style.color = "#000000";
		}
	}
    //---------------------------------------------------------------------------------------
</script>

<body>
  
 	<div id="wrap" >
 	<form id="formdata" name="formdata" method="POST">
        <input type="hidden" name="loadGb"     id="loadGb"     value="L">    
        <input type="hidden" name="pageGb"     id="pageGb"     value="<%=pageGb%>">    
        <input type="hidden" name="dataGb"     id="dataGb"     value="<%=dataGb%>">    
        <input type="hidden" name="comboGb"    id="comboGb"    value="<%=comboGb%>">    
	    <input type="hidden" name="pCORP_CD"   id="pCORP_CD"   value="<%=pCORP_CD%>">  
		<input type="hidden" name="pCRPN_CD"   id="pCRPN_CD"   value="<%=pCRPN_CD%>">  
		<input type="hidden" name="pBRND_CD"   id="pBRND_CD"   value="<%=pBRND_CD%>"> 
		<input type="hidden" name="pMEST_CD"   id="pMEST_CD"   value=""> 
		<input type="hidden" name="pBOARD_NO"  id="pBOARD_NO"  value="<%=pBOARD_NO%>">
		 
 		  <section class="contents admin">
 		 	<header>
 		 		<h1>◎ <span>admistrator service &gt; 대상점포 선택</span></h1>
 		 	</header>
 		 	
			<div id="cont-list" class="list list-wide">
				<table border="0">
					<tr>
						<td>
						<section class="combo-bg">
							<!-- header include-->
							<!-- script type="text/javascript">	$(".combo-bg").load("../include/createcombo.jsp"); </script -->
							<div class="admin-search-d" align="left">
								<label for="condition2" > ▶ 기업 : </label>
					    		<select id="sel_CORP_CD" name="sel_CORP_CD" class="con"  onchange="fnCombo_Proc('C','CRPN');">
					    			<!-- option -->
					    		</select>
								<label for="condition1" > ▶ 법인 : </label>
					    		<select id="sel_CRPN_CD" name="sel_CRPN_CD" class="con" onchange="fnCombo_Proc('C','BRND');">
					    			<!-- option -->
					    		</select>
								<label for="condition3" > ▶ 브랜드 : </label>
					    		<select id="sel_BRND_CD" name="sel_BRND_CD" class="con">
					    			<!-- option -->
					    		</select>
							</div>
						</section>
						</td>
						<td>
						<button	type="button" class="searchDateBtn" onclick="search_list();">조회</button>
						</td>
					</tr>
				</table>
			</div>
 		 	
 		 	<div id="cont-admin">
 		 		<div id="cont-list" class="list list-wide">
 		 			▶ <span class="no"></span><%=inTotalCnt%>건이 조회 되었습니다.
	 		 		<div class="search-d">
						<button	type="button" class="selectCnclBtn" onclick="fnSelect_clear();">해제</button>&nbsp;&nbsp;
	 		 			<button	type="button" class="selectAllBtn" onclick="fnSelect_all();">선택</button>&nbsp;&nbsp;
					</div>
 		 			
 		 			<table>
			  			<col width="5%"/>
			  			<col width="14%"/>
			    		<col width="14%"/>
			  			<col width="5%"/>
			  			<col width="14%"/>
			    		<col width="14%"/>
			  			<col width="5%"/>
			  			<col width="14%"/>
			    		<col width="*"/>
			    		<thead>
			    			<tr>
			        			<th>구분</th>
			        			<th>매장코드</th>
			        			<th>매장명</th>
			        			<th>구분</th>
			        			<th>매장코드</th>
			        			<th>매장명</th>
			        			<th>구분</th>
			        			<th>매장코드</th>
			        			<th>매장명</th>
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
	      				<td><input type="checkbox" id="pSELECT_YN1" name="pSELECT_YN1" value="<%=bean.get선택여부1()%>" 
	      				           <% if(bean.get선택여부1().equals("1")) { %>
	      				                 checked 
	      				           <% } %> ></td>
	      				<td>
	      				    <input type="hidden" id="pCORP_CD1" name="pCORP_CD1" value="<%=bean.get기업코드1()%>">
	      				    <input type="hidden" id="pCRPN_CD1" name="pCRPN_CD1" value="<%=bean.get법인코드1()%>">
	      				    <input type="hidden" id="pBRND_CD1" name="pBRND_CD1" value="<%=bean.get브랜드코드1()%>">
	      				    <input type="hidden" id="pMEST_CD1" name="pMEST_CD1" value="<%=bean.get매장코드1()%>">
	      				    <span id="sMEST_CD1"><%=bean.get매장코드1()%></span></td>       
	      				<td><input type="hidden" id="pMEST_NM1" name="pMEST_NM1" value="<%=bean.get매장명1()%>"><span id="sMEST_NM1"><%=bean.get매장명1()%></span></td>
	      				<% if(bean.get선택여부2().equals("#")) { %>
	      				<td colspan="3"></td>
	      				<% } else { %> 
	      				<td><input type="checkbox" id="pSELECT_YN2" name="pSELECT_YN2" value="<%=bean.get선택여부2()%>" 
	      				           <% if(bean.get선택여부2().equals("1")) { %>
	      				                 checked
	      				           <% } %> ></td>
	      				<td>
	      				    <input type="hidden" id="pCORP_CD2" name="pCORP_CD2" value="<%=bean.get기업코드2()%>">
	      				    <input type="hidden" id="pCRPN_CD2" name="pCRPN_CD2" value="<%=bean.get법인코드2()%>">
	      				    <input type="hidden" id="pBRND_CD2" name="pBRND_CD2" value="<%=bean.get브랜드코드2()%>">
	      				    <input type="hidden" id="pMEST_CD2" name="pMEST_CD2" value="<%=bean.get매장코드2()%>">
	      				    <span id="sMEST_CD2"><%=bean.get매장코드2()%></span></td>       
	      				<td><input type="hidden" id="pMEST_NM2" name="pMEST_NM2" value="<%=bean.get매장명2()%>"><span id="sMEST_NM2"><%=bean.get매장명2()%></span></td>
	      				<% } %>
	      				<% if(bean.get선택여부3().equals("#")) { %>
	      				<td colspan="3"></td>
	      				<% } else { %>           
	      				<td><input type="checkbox" id="pSELECT_YN3" name="pSELECT_YN3" value="<%=bean.get선택여부3()%>" 
	      				           <% if(bean.get선택여부3().equals("1")) { %>
	      				                 checked
	      				           <% } %> ></td>
	      				<td>
	      				    <input type="hidden" id="pCORP_CD3" name="pCORP_CD3" value="<%=bean.get기업코드3()%>">
	      				    <input type="hidden" id="pCRPN_CD3" name="pCRPN_CD3" value="<%=bean.get법인코드3()%>">
	      				    <input type="hidden" id="pBRND_CD3" name="pBRND_CD3" value="<%=bean.get브랜드코드3()%>">
	      				    <input type="hidden" id="pMEST_CD3" name="pMEST_CD3" value="<%=bean.get매장코드3()%>">
	      				    <span id="sMEST_CD3"><%=bean.get매장코드3()%></span></td>       
	      				<td><input type="hidden" id="pMEST_NM3" name="pMEST_NM3" value="<%=bean.get매장명3()%>"><span id="sMEST_NM3"><%=bean.get매장명3()%></span></td>
	      				<% } %> 
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
			 			<button type="button" class="saveBtn" onclick="goSave();">저장</button>
			 		</p>
 		 		</div>
 		 	</div><!-- end of cont-admin -->
 		 	
 		</section>
  	</form>
 	</div>

</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>