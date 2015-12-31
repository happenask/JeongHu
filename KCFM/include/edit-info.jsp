<!-- 
/** ############################################################### */
/** Program ID   : edit-info.jsp                                   	*/
/** Program Name :  home	       						           	*/
/** Program Desc :  프로그램 메인 									*/
/** Create Date  :   2015.04.13						              	*/
/** Update Date  :                                                  */
/** Programmer   :   s.h.e                                          */
/** ############################################################### */
 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="main.dao.mainDao" %>
<%@ page import="main.beans.mainBean" %>
<%@ page import="com.util.BoardConstant" %>
<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>


<%
	//System.out.println("Program Trace LOG >> Program_ID [ list ] " + JSPUtil.getDateTimeHypen());

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /edit-info.jsp");

	String CustPassWd         = (String)session.getAttribute("sseCustPassWd");
	String CustStoreNm        = (String)session.getAttribute("sseCustStoreNm");
	String CustTelNo          = (String)session.getAttribute("sseCustTelNo");
	String CustHpNo           = (String)session.getAttribute("sseCustHpNo");
	String SvCustNm           = (String)session.getAttribute("sseSvCustNm");
	String SvTelNo            = (String)session.getAttribute("sseSvTelNo");
	
	String[] TelNo = {"","",""};
	
	if (!"".equals(CustHpNo) && (CustHpNo != null)) {
		TelNo = CustHpNo.split("-"); 
	} 
	
	
%>

<script type="text/javascript">
	function doCustInfo(){
		
		var f = document.formC;

		if (f.password.value == "")
		{
			alert("비밀번호를 입력해 주세요.");	
			return;
		}
		if (f.passwordNew1.value == "")
		{
			alert("변경하실 비밀번호를 입력해 주세요.");
			f.passwordNew1.focus();
			return;
		}
		if (f.passwordNew2.value == "")
		{
			alert("변경하실 비밀번호를 입력해 주세요.");
			f.passwordNew2.focus();
			return;
		}
		if (f.passwordNew1.value != f.passwordNew2.value)
		{
			alert("변경하실 비밀번호가 맞지 않습니다.");
			f.passwordNew1.value= "";
			f.passwordNew2.value= "";
			f.passwordNew1.focus();
			return;
		}
		
		
		if (confirm("입력하신 정보변경을 수정 하시겠습니까?")) {
						
			$.ajax(
					{
						url      : "<%=root%>/include/edit-info-ok.jsp", 
						type     : "POST",
						data     : $("#formC").serialize(), 
						dataType : "html", 
						success  : function(data)
								   {  
									   if( trim(data) == "Yes" )
									   { 
										    alert("정상적으로 변경 되었습니다.");
										    location.reload();
						           	   }else if( trim(data) == "No" ){
								   
											alert("정보변경이 잘못 되었습니다."); 
						           	   }
					               }
				    });
		}
	}

    function trim(s) 
    {
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }
</script>

<!-- 정보변경 패널  -->
<form id="formC" name="formC" method="post">
<div id="mody-pw">
	<header class="nv-bord-tit">비밀번호 변경</header>
	<div><p>현재 비밀번호 </p> <input type="password" id="password" name="password" readOnly value="<%=CustPassWd%>"></div>
	<div><p>새 비밀번호 </p> <input type="password" id="passwordNew1" name="passwordNew1"></div>
	<div><p>새 비밀번호 확인 </p> <input type="password" id="passwordNew2" name="passwordNew2"></div>
</div>
<div id="mody-ph-no">
	<header class="nv-bord-tit">전화번호 변경</header>
	<div><p>현재 전화번호 </p> <input type="text" readOnly value="<%=CustHpNo%>"></div>
	<div><p>새 전화번호 </p> 
			<input type="tel" class="ph-no first" id="telno1" name="telno1" value="<%=TelNo[0]%>" maxlength="3">-
			<input type="tel" class="ph-no" id="telno2" name="telno2" value="<%=TelNo[1]%>" maxlength="4">-
			<input type="tel"class="ph-no" id="telno3" name="telno3" value="<%=TelNo[2]%>" maxlength="4">
	</div>
	<div class="txt-cnt"><input type="button" name="confirm"  class="nv-bord-tit" value="수정" onclick="doCustInfo()"></div>
</div> 
</form>