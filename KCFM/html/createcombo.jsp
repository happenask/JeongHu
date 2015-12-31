<!-- 
/** ############################################################### */
/** Program ID   :   createcombo.jsp      							*/
/** Program Name :            	       						        */
/** Program Desc :   기업,법인,브랜드,매장 공통 콤보                */
/** Create Date  :   2015.04.20						              	*/
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>


<%
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /createcombo.jsp");
	
	// Session 정보
	String sseGroupCd     = JSPUtil.chkNull((String)paramData.get("selGroupCd"), JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),"")) ; //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)paramData.get("selCorpCd"), JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),"")) ; //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)paramData.get("selBrandCd"), JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),"")); //브랜드코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"   ),""); //등록자명
	String sseCustAuth    = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth" ),""); //권한코드
	String sseCustId      = JSPUtil.chkNull((String)session.getAttribute("sseCustId"   ),""); //등록자ID
	String sseStroeNm     = JSPUtil.chkNull((String)session.getAttribute("sseStroeNm"  ),""); //매장명
	String sseCustStoreCd = JSPUtil.chkNull((String)paramData.get("selStoreCd"), JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),"")); //매장코드
	
%>
<script type="text/javascript">

	function fnOnloadWindow(){
		fnGroupComboCreate();
		fnCorpComboCreate();
		fnBrandComboCreate();
		fnStoreCdComboCreate();
	}
	 
	function fnGroupComboCreate()
	{
    	
		document.formcombo.selType.value = "G";
		document.getElementById("span기업").innerHTML = "<select id='sel_GroupCd' name='sel_GroupCd' class='con'><option value='' selected>::전체::::::::::</option></select>";

		var oForm = $("#formcombo").serializeArray();
		
		$.ajax({
			url      : "<%=root%>/com/combo.jsp",
			data : oForm,
			success : function(data,status)
			{
				var combo_data = data.getElementsByTagName("combo")[0].childNodes[0].nodeValue;  
				
				document.getElementById("span기업").innerHTML = combo_data;
			}
		});
	}
	function fnCorpComboCreate()
	{
		document.formcombo.selType.value = "C";
		document.getElementById("span법인").innerHTML = "<select id='sel_CorpCd' name='sel_CorpCd' class='con'><option value='' selected>::전체::::::::::</option></select>";

		var oForm = $("#formcombo").serializeArray();

		$.ajax({
			url      : "<%=root%>/com/combo.jsp",
			data : oForm,
			success : function(data,status)
			{
				var combo_data = data.getElementsByTagName("combo")[0].childNodes[0].nodeValue;  
				
				document.getElementById("span법인").innerHTML = combo_data;
			}
		});
	}
	function fnBrandComboCreate()
	{
		document.formcombo.selType.value = "B";
		document.getElementById("span브랜드").innerHTML = "<select id='sel_BrandCd' name='sel_BrandCd' class='con'><option value='' selected>::전체::::::::::</option></select>";

		var oForm = $("#formcombo").serializeArray();

		$.ajax({
			url      : "<%=root%>/com/combo.jsp",
			data : oForm,
			success : function(data,status)
			{
				var combo_data = data.getElementsByTagName("combo")[0].childNodes[0].nodeValue;  
				
				document.getElementById("span브랜드").innerHTML = combo_data;
			}
		});
		
	}
	function fnStoreCdComboCreate()
	{
		document.formcombo.selType.value = "S";
		document.getElementById("span매장").innerHTML = "<select id='sel_StoreCd' name='sel_StoreCd' class='con'><option value='' selected>::전체::::::::::</option></select>";

		var oForm = $("#formcombo").serializeArray();

		$.ajax({
			url      : "<%=root%>/com/combo.jsp",
			data : oForm,
			success : function(data,status)
			{
				var combo_data = data.getElementsByTagName("combo")[0].childNodes[0].nodeValue;  
				
				document.getElementById("span매장").innerHTML = combo_data;
			}
		});
		
	}
</script>
	
<script for=window event=onload>
	setTimeout("fnOnloadWindow()",100); // 처음으로 Page가 호출될때 처리할 작업이 있으면 기술한다.
</script>

<script for="sel_GroupCd" event="onchange">
	document.formcombo.selGroupCd.value = document.formcombo.sel_GroupCd.value;
	setTimeout("fnCorpComboCreate()", 100);
	setTimeout("fnBrandComboCreate()", 100);
	setTimeout("fnStoreCdComboCreate()", 100);
</script>

<script for="sel_CorpCd" event="onchange">
	document.formcombo.selCorpCd.value = document.formcombo.sel_CorpCd.value;
	setTimeout("fnBrandComboCreate()", 100);
	setTimeout("fnStoreCdComboCreate()", 100);
</script>

<script for="sel_BrandCd" event="onchange">
	document.formcombo.selBrandCd.value = document.formcombo.sel_BrandCd.value;
	setTimeout("fnStoreCdComboCreate()", 100);
</script>

<script for="sel_StoreCd" event="onchange">
	document.formcombo.selStoreCd.value = document.formcombo.sel_StoreCd.value;
</script>

<form id="formcombo" name="formcombo" method="post">

	<input type="hidden" name="selGroupCd"   id="selGroupCd"     value="<%=sseGroupCd%>" >
	<input type="hidden" name="selCorpCd"    id="selCorpCd"      value="<%=sseCorpCd%>" >
	<input type="hidden" name="selBrandCd"   id="selBrandCd"     value="<%=sseBrandCd%>" >
	<input type="hidden" name="selStoreCd"   id="selStoreCd"     value="<%=sseCustStoreCd%>" >
	<input type="hidden" name="selType"      id="selType"        value="" >
	<input type="hidden" name="selCustAuth"  id="selCustAuth"    value="<%=sseCustAuth%>" >
	
					
					
	<!-- 2015.04.14  관리자 조회 조건 추가 -->
	<div class="admin-search-d" align="left">
		<label for="condition2" > ▶ 기업 : </label>
		<span id="span기업">&nbsp;</span>&nbsp;&nbsp;&nbsp;
		<label for="condition1" > ▶ 법인 : </label>
		<span id="span법인">&nbsp;</span>&nbsp;&nbsp;&nbsp;
		<label for="condition3" > ▶ 브랜드 : </label>
		<span id="span브랜드">&nbsp;</span>&nbsp;&nbsp;&nbsp;
		<label for="condition4" > ▶ 매장 : </label>
		<span id="span매장">&nbsp;</span>
	</div>
</form>