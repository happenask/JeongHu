<%
/** ############################################################### */
/** Program ID   :  prom-ord-list.jsp                       		*/
/** Program Name :  prom-ord-list       							*/
/** Program Desc :  전단지업체-홍보물 주문내역						    */
/** Create Date  :   2015.05.04					              		*/
/** Update Date  :                                                  */
/** Programmer   :                                          		*/
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %> 
<%@ page import="prom.beans.orderBean" %> 
<%@ page import="prom.dao.orderDao" %>
<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%
	
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /promotion/prom-ord-list.jsp");
	
	/* adminBean dataBean = null;
	dataBean = new adminBean(); */
	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	String sseCustAuth = (String)session.getAttribute("sseCustAuth");
	String sseCustId    = JSPUtil.chkNull((String)session.getAttribute("sseCustId"    ), ""); //사용자ID
	String sseGroupCd   = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"   ), ""); //기업코드
	String hGroupCd     = JSPUtil.chkNull((String)request.getParameter("hGroupCd"     ), ""); //기업코드
	String hCorpCd      = JSPUtil.chkNull((String)request.getParameter("hCorpCd"      ), ""); //법인코드
	String hBrandCd     = JSPUtil.chkNull((String)request.getParameter("hBrandCd"     ), ""); //브랜드코드
	String hCustStoreCd = JSPUtil.chkNull((String)request.getParameter("hCustStoreCd" ), ""); //매장코드
	String optPromName  = JSPUtil.chkNull((String)request.getParameter("hoOptPromName"), ""); //전단지명
	String optProcess   = JSPUtil.chkNull((String)request.getParameter("hOptProcess"  ), ""); //진행상황
	
	if("41".equals(sseCustAuth) || "90".equals(sseCustAuth)){
		sseGroupCd = hGroupCd;
	}
	
	String hCorpCdIdx   = JSPUtil.chkNull((String)request.getParameter("hCorpCdIdx"   ), ""); //법인코드 선택 인덱스
	String hBrandCdIdx  = JSPUtil.chkNull((String)request.getParameter("hBrandCdIdx"  ), ""); //브랜드코드 선택 인덱스
	String hStoreCdIdx  = JSPUtil.chkNull((String)request.getParameter("hStoreCdIdx"  ), ""); //매장코드 선택 인덱스

	
	optPromName = URLDecoder.decode(optPromName, "UTF-8");
	
	paramData.put("사용자ID"  , sseCustId);
	paramData.put("기업코드"  , sseGroupCd);
	paramData.put("법인코드"  , hCorpCd);
	paramData.put("브랜드코드", hBrandCd);
	paramData.put("매장코드"  , hCustStoreCd);
	paramData.put("권한코드",   (String)session.getAttribute("sseCustAuth"));		//권한구분
	paramData.put("조회시작일자", request.getParameter("sDate"));
	paramData.put("조회종료일자", request.getParameter("eDate"));
	paramData.put("inCurPage", request.getParameter("inCurPage"));

	//--------------------------------------------------------------------------------------------------
	// Parameter 정보
	//--------------------------------------------------------------------------------------------------
	String StartDate   = JSPUtil.chkNull((String)paramData.get("sDate"), "");      //주문기간시작
	String EndDate     = JSPUtil.chkNull((String)paramData.get("eDate"), "");      //주문기간종료
	
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
	
	paramData.put("조회시작일자",    StartDate      );
	paramData.put("조회종료일자" ,   EndDate        );

	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 10;                                                                           // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 10;                                                                           // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝
 
	paramData.put("inRowPerPage", Integer.toString(inRowPerPage));

	orderBean orderBean  = new orderBean(); //내용보기 에서 담을 빈
	orderDao  orderDao   = new orderDao();
	
	ArrayList<orderBean> list = null;
	list       = orderDao.selectList(paramData);        //조회조건에 맞는 이벤트 리스트
	inTotalCnt = orderDao.selectListCount(paramData);   //전체레코드 수
	
	
	//수정[X]
	//#################################################################################################### 페이지 구하기 시작
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
	//#################################################################################################### 페이지 구하기 끝

%>
<!DOCTYPE html>
<html>
<head>
	
<%@ include file="/include/common_file.inc" %>

	<title>KCFM 관리자</title>  
	
<%@ include file="/com/fileUpload.jsp"%>	
    
    <script type="text/javascript">
	$(document).ready(function()
	{ 
		getCurrent();
		fnCalendar();
		
		var proTdWidth = 0;
		$(".productionTh").each(function(){
			proTdWidth += $(this).width();
		});

		//2015.05.04
		//if(매장에서 로그인 한 경우 업체관련 항목 숨기고 사이즈 조절)
		//브랜드, 매장명, 전화번호, 시안등록 hide 
		//매장 로그인 시 - 아래 4줄 주석 풀기!!
		
		//var tableWidth = $("#ord-list-tb").width() - proTdWidth;
		//$("#ord-list-tb").width(tableWidth);
		//$(".productionTh").hide();
		//$(".production").hide();
		
		//////////////////////////////////////////////////////
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
    
    function trim(s) 
    {
    	s += ''; // 숫자라도 문자열로 변환
    	return s.replace(/^\s*|\s*$/g, '');
    }
    
    
    window.onload = function(){
    	$("#opt-prom-name").attr("value", "<%=optPromName%>"); //전달지명
    	
    	comboCorpCd();  //법인   SELECT BOX
    };
    
   
    //엔터 이벤트 조회
    document.onkeyup = function(evt){
    	try{
    		var charCode = (evt.which) ? evt.which : event.keyCode;
	    	if (charCode == 13) { //엔터
		        	//fnShowOrderList();
	    			return false;
		    }
    	}catch(e){
    		return false;		
    	}
    };
    
    // 주문확인 보기
    function fnShowOrderList(){
    	var frm = document.getElementById("formdata");
    	
		$("input[name=hOptProcess]"  ).attr("value", $("#opt-process").val() ); //진행상황
		$("input[name=hCustStoreCd]" ).attr("value", $("#opt-branch").val()  ); //매장코드
		$("input[name=hoOptPromName]").attr("value", encodeURI( $("#opt-prom-name").val() )); //전달지명
		
    	frm.action = "<%=root%>/promotion/prom-ord-list.jsp";
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

	 //팝업화면 주문내역 상세보기
    function fnShowListDetail(groupCd,corpCd,brandCd,storeCd,ordNo, insertUserId){

		fnShowDetail();

		var $frm = $("#formdata");
		
		$("input[name=hGroupCd]"     ).attr("value", groupCd);
		$("input[name=hCorpCd]"      ).attr("value", corpCd );
		$("input[name=hBrandCd]"     ).attr("value", brandCd);
		$("input[name=hCustStoreCd]" ).attr("value", storeCd);
		$("input[name=hOrderNo]"     ).attr("value", ordNo  );
		$("input[name=hInsertUserId]").attr("value", insertUserId  );//등록자ID
		
    	$frm.attr("action",   "<%=root%>/promotion/prom-ord-list-dtl-view.jsp");
    	$frm.attr("target",   "iWorker");
    	$frm.attr("method",   "post");
        $frm.attr("enctype",  "");
        $frm.attr("encoding", "");
        
    	$frm.submit();
    	
    }
	
    //팝업화면 화면에 생성
    function fnRetSetting(id, out, prom_flyer_no){
    	
    	document.getElementById(id).innerHTML = decodeURIComponent(out);
    	
    	$("input[name=hPromFlyerNo]").attr("value", prom_flyer_no); //홍보물 시안번호
    	
    }
    
    
    //법인COMBO LIST 조회
    function comboCorpCd(){
    	
    	$("input[name=hGroupCd]").attr("value","<%=sseGroupCd%>"); //기업코드
    	$("input[name=hComboGubun]").attr("value","corpCombo"); //조회 구분
    	
    	//선택값 표시를 위한 값
    	if("<%=hCorpCd%>" != null && "<%=hCorpCd%>" != ""){
    		$("input[name=hCorpCd]").attr("value","<%=hCorpCd%>"); 
    	}
    	
		$.ajax(
			{
				url      : "<%=root%>/promotion/prom-ord-list-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {  
								$("#opt-corp option").remove();
								$("#opt-corp").append(data);
								
								comboBrandCd(); //브랜드조회
								
				           },

			});
    }
    
    //브랜드COMBO LIST 조회
    function comboBrandCd(){
    	
    	var corpCd = $("#opt-corp").val();
    	
    	$("input[name=hGroupCd]").attr("value","<%=sseGroupCd%>"); //기업코드
    	$("input[name=hCorpCd]" ).attr("value",corpCd); //법인코드
    	$("input[name=hComboGubun]").attr("value","brandCombo");   //조회 구분
    	
    	if("<%=hBrandCd%>" != null && "<%=hBrandCd%>" != ""){
    		$("input[name=hBrandCd]").attr("value", "<%=hBrandCd%>"); //브랜드코드
    	}else{
    		$("input[name=hBrandCd]").attr("value", ""); //브랜드코드 초기화
    	}
    	
    	//권한이 41일때 초기 기업코드가 없어서 법인코드 조회 할때 같이 갖고옴
    	var selGroupCd = "";
    	var selCorpCd  = "";
    	if("<%=sseCustAuth%>" == "41" || "<%=sseCustAuth%>" == "90"){
    		
    		var optCorpVal = document.getElementById("opt-corp").value;
    		
    		if( optCorpVal != ""){
    			selGroupCd = optCorpVal.split("-")[1];
    			selCorpCd  = optCorpVal.split("-")[0];
    		}
    		
    		$("input[name=hGroupCd]").attr("value", selGroupCd); //기업코드
        	$("input[name=hCorpCd]" ).attr("value", selCorpCd ); //법인코드
    	}

    	
		$.ajax(
			{
				url      : "<%=root%>/promotion/prom-ord-list-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {   
								$("#opt-brand option").remove();
								$("#opt-brand").append(data);
								
								comboStoreCd(); //매장조회
								
				           }
			});
    }
    
    //매장조회
    function comboStoreCd(){
    	
    	var corpCd  = $("#opt-corp").val();   //법인코드
    	var brandCd = $("#opt-brand").val();  //브랜드코드
    	
    	$("input[name=hGroupCd]").attr("value","<%=sseGroupCd%>"); //기업코드
    	$("input[name=hCorpCd]" ).attr("value",corpCd);  //법인코드
    	$("input[name=hBrandCd]").attr("value",brandCd); //브랜드코드
    	
    	$("input[name=hComboGubun]").attr("value","storeCombo");   //조회 구분
    	
    	
    	if("<%=hCustStoreCd%>" != null && "<%=hCustStoreCd%>" != ""){
    		$("input[name=hCustStoreCd]").attr("value", "<%=hCustStoreCd%>"); //매장코드
    	}else{
    		$("input[name=hCustStoreCd]").attr("value", ""); //매장코드 초기화
    	}
    	
    	//권한이 41일때 초기 기업코드가 없어서 법인코드 조회 할때 같이 갖고옴
    	var selGroupCd = "";
    	var selCorpCd  = "";
    	if("<%=sseCustAuth%>" == "41" || "<%=sseCustAuth%>" == "90"){
			
    		var optCorpVal = document.getElementById("opt-corp").value;
    		
    		if( optCorpVal != ""){
    			selGroupCd = optCorpVal.split("-")[1];
    			selCorpCd  = optCorpVal.split("-")[0];
    		}
    		
    		$("input[name=hGroupCd]").attr("value", selGroupCd); //기업코드
        	$("input[name=hCorpCd]" ).attr("value", selCorpCd ); //법인코드
    	}

    	
		$.ajax(
			{
				url      : "<%=root%>/promotion/prom-ord-list-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {   
								$("#opt-branch option").remove();
								$("#opt-branch").append(data);
								
								comboStatusCd(); //진행상황 조회
				           }
			});
    }
    
    //진행상황 조회
	function comboStatusCd(){
    	$("input[name=hComboGubun]").attr("value","orderStatus");   //조회 구분
    	
    	if("<%=optProcess%>" != null && "<%=optProcess%>" != ""){
    		$("input[name=hOptProcess]").attr("value", "<%=optProcess%>");
    	}
    	
		$.ajax(
			{
				url      : "<%=root%>/promotion/prom-ord-list-combo.jsp",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {   
								$("#opt-process option").remove();
								$("#opt-process").append(data);
				           }
			});
    }
    
    
	//--------------------------[파일첨부]-----------------------------------
	 //초기화
	function fnIniFile(obj)
	{
		var frm    = document.getElementById("formdata"   );
		var aFile1 = document.getElementById("attachFile1");
		var sFile1 = document.getElementById("s첨부파일1" );
			
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
	}

	//파일첨부 이름변경
	function fnChgFname(obj)
	{
		document.getElementById("s첨부파일1").innerHTML = "";
	}
	
	
// 	function fnModYn(strYn, obj){
// 		var frm = document.formdata;
// 		frm.modYn1.value=strYn;	
// 	}

	
	//첨부파일 삭제
	function fnDeleteFile(obj)
	{
		
		var aFile1 = document.getElementById("attachFile1").value;
			
		if(aFile1 == ""){
			alert("삭제할 파일이 없습니다.");
			return;
		}else if (!confirm("삭제하시겠습니까?")){
			return;
		}else{
			$("modYn1").attr("value", "Y");
			
			var input = $("#attachFile1");
			input.replaceWith(input.val('').clone(true));
		}
	
	}
	
	function checkFilesize(obj){
		if(checkFileSize(obj, 2)){
			$("modYn1").attr("value", "Y");
		} else {
			$("modYn1").attr("value", "N");
		}
	}
	
	//진행상태 확인
	function fnCheckProcess(obj){
		//선택한 상태
		var val    = obj.value;
		var flag   = val.substring(0,1);
		var status = val.substring(1,3);
		
		//현 상태
		var proStatus = $("#progressStatus").val();
		var nowFlag   = proStatus.substring(0,1);
		var nowStatus = proStatus.substring(1,3);
	
		//주문취소에서는 상태변경 안됨.
		if( proStatus == "S92" ){
			alert("주문취소 상태에서는 상태변경을 할 수 없습니다.");
			
			$("input[name=progression1]").each(function(i){
				this.checked = false;
			});

			return;

		}

		//현상태 보다 하위 단계로 못가게 막음.
		if(nowFlag == "S"){
			if(flag == "S"){
				
				//시안보류(91)에서 시안완료(04) 만 가능
				if ((status=="04") && (nowStatus=="91")) {
					
				} else {
					if( parseInt(nowStatus,10) >= parseInt(status, 10)){
						alert("진행 중 하위단계 선택은 할 수 없습니다.");
						
						$("input[name=progression1]").each(function(i){
							this.checked = false;
						});
					}
				}	
			} else {
				if(nowStatus!="99") {
					alert("주문완료 상태에서만 제작/배송으로 상태변경이 가능합니다.");
					
					$("input[name=progression1]").each(function(i){
						this.checked = false;
					});
					
					return;
					
				}				
			}

			
			
		}else{
			if(flag == "S"){
				alert("제작, 배송 상태에서는 전 단계로 선택 할 수 없습니다.");
				
				$("input[name=progression1]").each(function(i){
					this.checked = false;
				});
			}
			
			if( parseInt(nowStatus,10) >= parseInt(status, 10)){
				alert("진행 중 하위단계 선택은 할 수 없습니다.");
				
				$("input[name=progression1]").each(function(i){
					this.checked = false;
				});
			}
		}
	}
	
	//주문상세 내역 저장
	function fnSavePopUpInfo(){

		var printTxt   = encodeURIComponent($("#printTxt"  ).val()); //인쇄문구
		var requestTxt = encodeURIComponent($("#requestTxt").val()); //요구사항
		
		var $frm = $("#formdata");
		
		//진행상황 
		$("input[name=progression1]").each(function(i){
			if(this.checked == true){
				$("#hProgression1").attr("value", this.value);
			}
		});
		
		$("#hPrintTxt"  ).attr("value", printTxt  ); //한글깨짐처리
		$("#hRequestTxt").attr("value", requestTxt); //요구사항
		
		$frm.attr("action",   "<%=root%>/promotion/prom-ord-list-dtl-write-ok.jsp" );
		$frm.attr("target",   "iWorker");
        $frm.attr("method",   "post");
        $frm.attr("enctype",  "multipart/form-data");
        $frm.attr("encoding", "multipart/form-data");
        
        $frm.submit();
		
	}
	
	//저장결과 확인.
	function fnSavePopUpResult(msg){
		alert(msg);
		
		//저장 후 각 코드 초기화 
		$("input[name=hGroupCd]"     ).attr("value", "");
		$("input[name=hCorpCd]"      ).attr("value", "");
		$("input[name=hBrandCd]"     ).attr("value", "");
		$("input[name=hCustStoreCd]" ).attr("value", "");
		$("input[name=hOrderNo]"     ).attr("value", "");
		$("input[name=hInsertUserId]").attr("value", "");//등록자ID
		
		
 		setTimeout(fnShowOrderList, 500);
 		
	}
	
	 //--------------------------[파일점부]-----------------------------------
	  
	//---------------------------[팝업 댓글 등록]-----------------------------
	//댓글정보 조회
	function fnSelectComment(){
		 
		$.ajax(
			{
				url      : "<%=root%>/promotion/prom-ord-list-dtl-view-comment.jsp?gubun=select",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {   
								$("#comment").html("");
								$("#comment").html( trim(data));
								
				           }
			});
	 }
	 
	 //댓글 저장.
	function fnWriteComment(num){

		 //num[0번 신규입력, 0 이외 수정]
		$("input[name=hCommNum]").attr("value", num);
		 
		 if(num == "0"){
			//신규입력
			$("input[name=hCommTxt]").attr("value", encodeURIComponent($("#comm_write").val()));
		 }else{
			 //수정
			$("input[name=hCommTxt]").attr("value", encodeURIComponent( document.getElementById("txt"+num).value ));
		 }
				
		$.ajax(
			{
				url      : "<%=root%>/promotion/prom-ord-list-dtl-view-comment.jsp?gubun=insert",
				type     : "POST",
				data     : $("#formdata").serialize(),
				dataType : "html", 
				success  : function(data)
						   {   
								if(trim(data) == "Y"){
									alert("등록 되었습니다.");
									
									//등록 후 화면 댓글 새로고침
									fnSelectComment();
						   		}else{
						   			alert("등록 실패 하였습니다.");
						   		}
				           }
			});
	 }
	 
	 
	 
	 //댓글 > 수정 후 저장 버튼 클릭
    function goCommConfirm(num)
    {
    	var viewObj = $('#list_'+num+' #comm_text'); //현 댓글
    	var txtObj  = $('#list_'+num+' #txt'+num);	 //수정입력칸
    	
    	var writeYN = document.getElementById("txt"+num).value;//comm_write
    	var no = "no";
		if (!trim(writeYN)){
			alert("댓글을 입력해주세요~!");
			return;
			
		}else if(txtObj.val() == viewObj.html()){
			alert("변경사항이 없습니다.");
			return;
			
		}else{
			//저장
			fnWriteComment(num); 
		}
    	
    }
    
    //댓글 > 수정버튼 클릭 후 종료버튼 클릭
    function closeComm(num)
	{  
    	
    	var viewObj  = $('#list_'+num+' #comm_text'); //현 댓글
    	var txtObj   = $('#list_'+num+' #txt'+num);	 //수정입력칸
    	var wrObj    = $('#list_'+num+' #wrBtn');     //수정 버튼
    	var saveObj  = $('#list_'+num+' #saveBtn');   //저장 버튼
    	var closeObj = $('#list_'+num+' #closeBtn'); //취소 버튼
    	
    	viewObj.show();    	
    	wrObj.show();
    	
    	txtObj.hide();
    	saveObj.hide();
    	closeObj.hide();
    	
	}


	 
	 //댓글 > 수정버튼 클릭
	function goCommWrite(num)
	{  
		 
    	var viewObj  = $('#list_'+num+' #comm_text'); //현 댓글
    	var txtObj   = $('#list_'+num+' #txt'+num);	 //수정입력칸
    	var wrObj    = $('#list_'+num+' #wrBtn');     //수정 버튼
    	var saveObj  = $('#list_'+num+' #saveBtn');   //저장 버튼
    	var closeObj = $('#list_'+num+' #closeBtn'); //취소 버튼
    	
    	txtObj.val(viewObj.html());
    	    	
    	viewObj.hide();
    	wrObj.hide();
    	
    	txtObj.show();
    	saveObj.show();
    	closeObj.show();
    	
	}
	//---------------------------[팝업 댓글 등록]-----------------------------
	 
	
	//페이지 초기화
	function fnPagingInit(){
		$("#inCurPage" ).attr("value","1"); //현재 페이지
		$("#inCurBlock").attr("value","1"); //현재 블럭
	}
	

	//권한코드[90]일때 전체 조회로 인해서 같은코드가 있음
	//선택 항목 다시 선택되게 표시하기 위해서 선택 인덱스로 변경.
	function fnOptionSelectIdx(val){
		
		//상위코드를 선택하면 하위 선택 인덱스 초기화
		if(val == "1"){ //법인
			$("#hCorpCdIdx" ).attr("value", $("#opt-corp option:selected").index());   //법인   선택 인덱스
			$("#hBrandCdIdx").attr("value", 0); //브랜드 선택 인덱스
			$("#hStoreCdIdx").attr("value", 0); //매장   선택 인덱스
			
		}else if(val == "2"){
			$("#hCorpCdIdx" ).attr("value", $("#opt-corp option:selected").index());   //법인   선택 인덱스
			$("#hBrandCdIdx").attr("value", $("#opt-brand option:selected").index());  //브랜드 선택 인덱스
			$("#hStoreCdIdx").attr("value", 0); //매장   선택 인덱스
			
		}else if(val == "3"){
			$("#hCorpCdIdx" ).attr("value", $("#opt-corp option:selected").index());   //법인   선택 인덱스
			$("#hBrandCdIdx").attr("value", $("#opt-brand option:selected").index());  //브랜드 선택 인덱스
			$("#hStoreCdIdx").attr("value", $("#opt-branch option:selected").index()); //매장   선택 인덱스
			
		}
	}
	
	
	//홍보물 시안 이미지 보기
	 function ImgPopup(imgFileNm){
	    	
		 	var imgPath = "<%=root%>/filestorage/prom/"+imgFileNm;
		 
		 	var popOption = "width=600, height=800, menubar=no, resizable=yes, scrollbars=yes, status=no, titlebar=no, tollbar=no";
	 	    var pop = window.open('',"ImgPopup",popOption);

	 	    pop.document.write('<html><head><title>이미지팝업보기</title></head>');
	 	    pop.document.write('<body style="margin:0px;">'); // margin는 여백조절
	 	    pop.document.write('<img src="'+ imgPath +'">');
	 	    pop.document.write('</body></html>');

	 }
	
	</script>
</head>

<body>
<form id="formdata" name="formdata" method="post"  >
	<input type="hidden" name="inCurPage" 	   id="inCurPage"      value="<%=inCurPage %>"		>  <!-- 현재 페이지 -->
	<input type="hidden" name="inCurBlock"     id="inCurBlock"     value="<%=inCurBlock %>"		>  <!-- 현재 블럭 -->
	<input type="hidden" name="inRowPerPage"   id="inRowPerPage"   value="<%=inRowPerPage %>"	>  <!-- 한 페이지당 표시할 레코드 수 -->
	<input type="hidden" name="inPagePerBlock" id="inPagePerBlock" value="<%=inPagePerBlock %>"	>  <!-- 한 블럭당 할당된 페이지 수 -->

	<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
	<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
	<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
	<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>
	<input type="hidden" name="srch_type"   value="1"><!-- 주문상태,제작상태 구분 -->

	<input type="hidden" name="hGroupCd"     value=""/>
	<input type="hidden" name="hCorpCd"      value=""/>
	<input type="hidden" name="hBrandCd"     value=""/>
	<input type="hidden" name="hCustStoreCd" value=""/>
	<input type="hidden" name="hOrderNo"     value=""/>
	<input type="hidden" name="hOptProcess"  value=""/>
	<input type="hidden" name="hoOptPromName" value=""> <!-- 전단지명 -->
		
	<input type="hidden" name="hComboGubun" value="" /><!-- 법인,브랜드,매장 구분 -->
	<input type='hidden' name='modYn1'        id='modYn1'        value="N" >
	<input type='hidden' name='hPrintTxt'     id='hPrintTxt'     value="" >
	<input type='hidden' name='hRequestTxt'   id='hRequestTxt'   value="" >
	<input type='hidden' name='hProgression1' id='hProgression1' value="" >
	<input type='hidden' name='hPromFlyerNo'  id='hPromFlyerNo'  value="" ><!-- 홍보물 시안번호 -->
	<input type="hidden" name="hInsertUserId" id="hInsertUserId" value="" ><!-- 수정자ID -->
	<input type="hidden" name="hCommTxt"      id="hCommTxt"      value="" ><!-- 주문상세내역 댓글 -->
	<input type='hidden' name='hCommNum'      id='hCommNum'      value="" ><!-- 댓글번호 -->
	
	<input type="hidden" id="hCorpCdIdx"  name="hCorpCdIdx"  value="<%=hCorpCdIdx%>" > <!-- 법인코드 선택 인덱스   -->
	<input type="hidden" id="hBrandCdIdx" name="hBrandCdIdx" value="<%=hBrandCdIdx%>" > <!-- 브랜드코드 선택 인덱스 -->
	<input type="hidden" id="hStoreCdIdx" name="hStoreCdIdx" value="<%=hStoreCdIdx%>" > <!-- 매장코드 선택 인덱스   -->

 	<div id="wrap" >
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("../include/pr-header.jsp"); </script> 
	 	</section> 
	 	
	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("<%=root%>/include/edit-info.jsp"); </script> 
	 	</section>
	 	
 		  <section class="contents admin" style="top: 25px">
 		 	<header>
 		 		<h1>◎ <span>주문내역 확인</span></h1>
 		 	
	        	<div class="search-d">
		    		<label for="sDate" > ▶ 주문 기간 : </label>
		    		<input class="big_0" name="sDate" type="text" value="<%=StartDate%>" onchange="fnPagingInit();"/> ~ 
					<input class="big_0" name="eDate" type="text" value="<%=EndDate%>" onchange="fnPagingInit();"/> 
		    		<span><button class="searchDateBtn" onclick="fnShowOrderList();" style="cursor: pointer;">조회</button></span>
		  		</div>
 		 	</header>
 		 	
 		 	<div id="cont-admin">
	        	<div class="admin-search-o">
		    		<label for="opt-corp" > ▶ 법인 : </label>
		    		<select id="opt-corp" name="opt-corp" onchange="fnOptionSelectIdx('1'); comboBrandCd(); fnPagingInit();">
		    			<!-- option -->
		    		</select>
		    		<label for="opt-brand" > ▶ 브랜드 : </label>
		    		<select id="opt-brand" name="opt-brand" onchange="fnOptionSelectIdx('2'); comboStoreCd(); fnPagingInit();">
		    			<!-- option -->
		    		</select>
		    		<label for="opt-branch" > ▶ 매장 : </label>
		    		<select id="opt-branch" name="opt-branch" onchange="fnOptionSelectIdx('3'); comboStatusCd(); fnPagingInit();">
		    			<!-- option -->
		    		</select>
		    		<label for="opt-process" > ▶ 진행상황 : </label>
		    		<select id="opt-process" name="opt-process" onchange="fnPagingInit();">
		    			<!-- option -->
		    		</select>
		    		<label for="opt-prom-name" > ▶ 전단지명 : </label>
		    		<input id="opt-prom-name" name="opt-prom-name" value="" style="width:90px;" onchange="fnPagingInit();">
		    		<!-- <span><button class="searchDateBtn" onclick="">조회</button></span> -->
		  		</div>
			  		
 		 		<div id="" class="list-wide ad-tbl">
 		 			<div class="long-tbl-box">
				  		<table style="width: 1870px;" class="scroll-y" id="ord-list-tb">
				    		<thead>
				    			<tr>
				      				<th width="50" >순번</th>
				        			<th width="100" >주문일자</th>
				        			<th width="120" class="productionTh">법인</th>
				        			<th width="120" class="productionTh">브랜드</th>
				        			<th width="140" class="productionTh">매장</th>
				      				<th width="120" class="productionTh">전화번호</th>
				        			<th width="130" >주문번호</th>
				        			<th width="100">홍보물코드</th>
				        			<th width="100">홍보물명</th>
				      				<th width="100" >작업유형</th>
				        			<th width="60">주문단위</th>
				        			<th width="60">주문수량</th>
				        			<th width="120">주문금액</th>
				        			<th width="100">주문상태</th>
				        			<th width="80" class="productionTh">시안등록</th>
				      				<th width="100" >최종시안</th>
				        			<th width="60">배송상태</th>
				        			<th width="80">택배사</th>
				        			<th width="130">송장번호</th>
<!-- 				        			<th width="0">기업코드</th> -->
<!-- 				        			<th width="0">법인코드</th> -->
<!-- 				        			<th width="0">브랜드코드</th> -->
<!-- 				        			<th width="0">매장코드</th> -->
				      			</tr>
				    		</thead>
				    		<tbody>
		<%
			int inSeq = 0;
				
			if( list != null && list.size() > 0 ) 
			{
				for( int i = 0; i < list.size(); i++ ) 
				{
					orderBean = (orderBean) list.get(i);
					inSeq = inTotalCnt - ((inCurPage-1)*inRowPerPage);
		%>
			    			<tr>
				      				<td width="50" class="txt-cnt"><%=orderBean.get순번()%></td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get주문일자()%></td> 
				      				<td width="120" class="txt-cnt production"><%=orderBean.get법인명()%></td> 
				      				<td width="120" class="txt-cnt production"><%=orderBean.get브랜드명()%></td> 
				      				<td width="140" class="txt-cnt production"><%=orderBean.get매장명()%></td>
				      				<td width="120" class="txt-cnt production"><%=orderBean.get전화번호()%></td> 
				      				<td width="130" class="txt-cnt">
				      					<a href="javascript:void(0);" class="bold" onclick="fnShowListDetail('<%=orderBean.get기업코드()%>','<%=orderBean.get법인코드()%>','<%=orderBean.get브랜드코드()%>','<%=orderBean.get매장코드()%>','<%=orderBean.get주문번호()%>', '<%=orderBean.get등록자()%>')"><%=orderBean.get주문번호()%></a>
				      				</td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get홍보물코드()%></td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get홍보물코드명()%></td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get작업유형()%></td> 
				      				<td width="60" class="txt-cnt"><%=orderBean.get주문단위()%></td>
				      				<td width="60" class="txt-cnt"><%=orderBean.get주문수량()%></td> 
				      				<td width="120" class="txt-prc"><%=orderBean.get주문가격()%></td> 
				      				<td width="100" class="txt-cnt"><%=orderBean.get주문상태()%></td> 
				      				<td width="80" class="txt-cnt production"><button style="cursor:pointer; " class="fileBtn" onclick="fnShowListDetail('<%=orderBean.get기업코드()%>','<%=orderBean.get법인코드()%>','<%=orderBean.get브랜드코드()%>','<%=orderBean.get매장코드()%>','<%=orderBean.get주문번호()%>', '<%=orderBean.get등록자()%>')">등록</button></td> 
				      				<td width="100" class="txt-cnt"> 
				      				<%
				      					String promFile = JSPUtil.chkNull((String)orderBean.get시안파일명() , "");
				      					if(!"".equals(promFile)){
				      				%>
<%-- 				      					<button style="cursor:pointer;" class="confirmBtn" onclick="self.location='<%=root%>/com/fileDown.jsp?fname=<%=promFile %>&gubn=2'; return false;">확인</button> --%>
											<button style="cursor:pointer;" class="confirmBtn" onclick="ImgPopup('<%=promFile%>'); return false;">확인</button>
				      				<%	}else{ %>
<!-- 				      					<button class="confirmBtn" onclick="return false;">확인</button> -->
				      				<%  } %>
				      				</td> 
				      				<td width="60" class="txt-cnt"><%=orderBean.get제작상태()%></td> 
				      				<td width="80" class="txt-cnt"><%=orderBean.get택배사코드명()%></td> 
				      				<td width="114" class="txt-cnt"><%=orderBean.get송장번호()%></td>
<%-- 				      				<td width="0" id="tGroupCd" class="txt-cnt"><%=orderBean.get기업코드()%></td> --%>
<%-- 				      				<td width="0" id="tCorpCd" class="txt-cnt"><%=orderBean.get법인코드()%></td> --%>
<%-- 				      				<td width="0" id="tBrandCd" class="txt-cnt"><%=orderBean.get브랜드코드()%></td> --%>
<%-- 				      				<td width="0" id="tCustStoreCd" class="txt-cnt"><%=orderBean.get매장코드()%></td> --%>
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
		
 		 		</div>
 		 	</div><!-- end of cont-admin -->
 		 	
 		</section>
 	
	 	<!-- 주문 상세 보기 : 주문번호 클릭 시 -->
	 	<!-- modal popup -->
	 	<div class="overlay-bg8" >
	 		<div class="dtl-pop view-pop" id="pop-order-dtl"> </div>
	 	</div>
 	</div><!-- wrap end -->
 
</form> 
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>