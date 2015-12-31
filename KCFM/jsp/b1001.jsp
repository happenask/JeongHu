<%
/** ############################################################### */
/** Program ID   : transactional-info.jsp                           */
/** Program Name : 거래내역 > 카드승인내역                          */
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

<%@ page import="transaction.beans.tranBean" %> 
<%@ page import="transaction.dao.tranDao" %>

<%@ include file="/com/common.jsp"%>
<%@ include file="/com/sessionchk.jsp"%>

<%

	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /transaction-info.jsp");


//	String sseCustNm = (String)session.getAttribute("sseCustNm");      //사용자명
	

%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/common_file.inc" %>
	<title>가맹점 현황</title>  
     
<style type="text/css">


</style>
<link rel="stylesheet" href="<%=root %>/assets/jqwidgets/styles/jqx.base.css" type="text/css" />
<link rel="stylesheet" href="<%=root %>/assets/jqwidgets/styles/jqx.energyblue.css" type="text/css" />

<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxmenu.js"></script>
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxdropdownlist.js"></script>
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxgrid.js"></script>
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxgrid.selection.js"></script> 
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxgrid.columnsresize.js"></script> 
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxgrid.filter.js"></script> 
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxgrid.sort.js"></script> 
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxgrid.pager.js"></script> 
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxgrid.grouping.js"></script> 
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxwindow.js"></script>
<script type="text/javascript" src="<%=root %>/assets/jqwidgets/jqxgrid.edit.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

    	
    	fnSearchList();
    	


    });
    


    function fnSearchList(){
    	document.form1.actionMode.value = "search";
    	
    	var fData = $("#form1").serializeArray();
    	
    	
    	$.ajax({
			url: 'b1001.do',
    		data:fData,
    		dataType:'json',
    		success:function(Jsondata){
    			
    			var data = Jsondata.list;
    			fnMakeJqxGrid(data);
    		}
    	});
    }
    


    

    function fnMakeJqxGrid(data)
    {

    	var source =

    	{

    	    localdata: data,

    	    datatype: "json"

    	};
    	
    	
    	var dataAdapter = new $.jqx.dataAdapter(source, {

    	    loadComplete: function (data) { },

    	    loadError: function (xhr, status, error) { }    

    	});
    	

    	
    	$("#jqxgrid").jqxGrid(
   			{

    			     source: dataAdapter,
					 width:'100%',
					 autoheight:true,
					 theme: 'energyblue',
					 showstatusbar: true,
		             editable: true,
		             selectionmode: 'singlecell',
		             editmode: 'click',
					 renderstatusbar: function (statusbar) {

		                    // appends buttons to the status bar.

		                    var container = $("<div style='overflow: hidden; position: relative; margin: 5px;'></div>");

		                    var addButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='<%=root %>/assets/jqwidgets/images/add.png'/><span style='margin-left: 4px; position: relative; top: -3px;'>Add</span></div>");

		                    var deleteButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='<%=root %>/assets/jqwidgets/images/close.png'/><span style='margin-left: 4px; position: relative; top: -3px;'>Delete</span></div>");

		                    var reloadButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='<%=root %>/assets/jqwidgets/images/refresh.png'/><span style='margin-left: 4px; position: relative; top: -3px;'>Reload</span></div>");

		                    var searchButton = $("<div style='float: left; margin-left: 5px;'><img style='position: relative; margin-top: 2px;' src='<%=root %>/assets/jqwidgets/images/search.png'/><span style='margin-left: 4px; position: relative; top: -3px;'>Find</span></div>");

		                    container.append(addButton);

		                    container.append(deleteButton);

		                    container.append(reloadButton);

		                    container.append(searchButton);

		                    statusbar.append(container);

		                    addButton.jqxButton({  width: 60, height: 20 });

		                    deleteButton.jqxButton({  width: 65, height: 20 });

		                    reloadButton.jqxButton({  width: 65, height: 20 });

		                    searchButton.jqxButton({  width: 50, height: 20 });

		                    // add new row.

		                    addButton.click(function (event) {

		                        //var datarow = generatedata(1);

		                        $("#jqxgrid").jqxGrid('addrow', null, {});

		                    });

		                    // delete selected row.

		                    deleteButton.click(function (event) {

		                        var selectedrowindex = $("#jqxgrid").jqxGrid('getselectedrowindex');

		                        var rowscount = $("#jqxgrid").jqxGrid('getdatainformation').rowscount;

		                        var id = $("#jqxgrid").jqxGrid('getrowid', selectedrowindex);

		                        $("#jqxgrid").jqxGrid('deleterow', id);

		                    });

		                    // reload grid data.

		                    reloadButton.click(function (event) {

		                        $("#jqxgrid").jqxGrid({ source: getAdapter() });

		                    });

		                    // search for a record.

		                    searchButton.click(function (event) {

		                        var offset = $("#jqxgrid").offset();

		                        $("#jqxwindow").jqxWindow('open');

		                        $("#jqxwindow").jqxWindow('move', offset.left + 30, offset.top + 30);

		                    });

		                },
    			    columns: [

    			        { text: '지사'			, datafield: '지사코드'		, width: 100 },
    			        { text: '지사명'		, datafield: '지사명'		, width: 100 },
    			        { text: '가맹점코드'	, datafield: '가맹점코드'	, width: 180 },
    			        { text: '가맹점명'		, datafield: '가맹점명'		, width: 80, cellsalign: 'right' },
    			        { text: '매출일자'		, datafield: '매출일자'		, width: 90  },//, cellsalign: 'right', cellsformat: 'c2' },
    			        { text: '육계'			, datafield: '품목01'		, width: 100 },//, cellsalign: 'right', cellsformat: 'c2' },
    			        { text: '낱개'			, datafield: '품목02'		, width: 180 },
    			        { text: '다리'			, datafield: '품목03'		, width: 180 },
    			        { text: '살살'			, datafield: '품목04'		, width: 180 },
    			        { text: '소이살살'		, datafield: '품목05'		, width: 180 },
    			        { text: '허니오리지날'  , datafield: '품목06'		, width: 180 },
    			        { text: '허니콤보'		, datafield: '품목07'		, width: 180 },
    			        { text: '합계'			, datafield: '합계'			, width: 180 },
    			        { text: '교촌(양념)'	, datafield: '품목08'		, width: 180 },
    			        { text: '핫(양념)'		, datafield: '품목09'		, width: 180 },
    			        { text: '소이(양념)'	, datafield: '품목10'		, width: 180 },
    			        { text: '허니(양념)'	, datafield: '품목11'		, width: 180 },
    			        { text: '소이야채(양념)', datafield: '품목12'		, width: 180 },
    			        { text: '파우더(양념)'	, datafield: '품목13'		, width: 180 }

    			    ]

    			});
    	
    }
	

    
 	// 엑셀데이터 추출
    function fnExcelDown(gbn){
    	var frm = document.getElementById("form1");
    	var v_inDate = document.getElementById("i_inDate");	//include 변수
    	
    	if('' == 4){
    	
	    	v_inDate.value = '';
	    	
	    	frm.action = "<%=root%>/transaction/excel_down.jsp";
		    frm.target = "iWorker";
		    frm.submit();
		    
    	}else{
    		return;
    	}
    	
    }
	
    // 엑셀저장
    function fnSaveExcel(out){
    	saveExcel("src", "", out, "카드승인내역.xls");
    }
    
    
    function fnPrintPage(){
    	
    	//* 방법 1 
    	var restorepage = document.body.innerHTML;
    	var printcontent = document.getElementById("contents").innerHTML;
    	document.body.innerHTML = printcontent;
    	window.print();

    	document.body.innerHTML = restorepage;

    	//* 방법 2 (iframe 이용) 
//    	iWorker.document.body.innerHTML = printcontent;
//    	iWorker.print();
    	
    	
    }
    
    </script>

    
</head>

<body>
 	<div id="wrap" >
      	<div id="search-option">
       		<form id="form1" name="form1" method="post" >
       				<input type="hidden" id="user_id"         name="user_id"         value="${sessionScope.userInfo.user_id}" />         <!-- 사용자 ID        -->
					<input type="hidden" id="user_nm"         name="user_nm"         value="${sessionScope.userInfo.user_nm}" />         <!-- 사용자명         -->
					<input type="hidden" id="role_cd"         name="role_cd"         value="${sessionScope.userInfo.role_cd}" />         <!-- 권한코드         -->
					<input type="hidden" id="role_nm"         name="role_nm"         value="${sessionScope.userInfo.role_nm}" />         <!-- 권한명           -->
					<input type="hidden" id="group_cd"        name="group_cd"        value="${sessionScope.userInfo.group_cd}" />        <!-- 기업코드         -->
					<input type="hidden" id="group_nm"        name="group_nm"        value="${sessionScope.userInfo.group_nm}" />        <!-- 기업명           -->
					<input type="hidden" id="corp_cd"         name="corp_cd"         value="${sessionScope.userInfo.corp_cd}" />         <!-- 법인코드         -->
					<input type="hidden" id="corp_nm"         name="corp_nm"         value="${sessionScope.userInfo.corp_nm}" />         <!-- 법인명           -->
									        			
					<input type="hidden" id="actionMode"       name="actionMode"   value="" />
					<input type="hidden" id="section"          name="section"      value="" />  
					
					
					   
		    		
  			</form>
			  		
  		</div>
	 	<section class="header-bg">
  			<!-- header include-->
	 		<script type="text/javascript">	$(".header-bg").load("../include/header.jsp"); </script> 
	 	</section>
	 	
	 	<!-- 정보 변경 패널 -->
	 	<section id="info-panel">
  			<!-- info-panel include-->
	 		<script type="text/javascript">	$("#info-panel").load("../include/edit-info.jsp"); </script> 
	 	</section>
	 	 		 <!-- <section class="contents" style="background:rgb(223, 224, 224);"> -->
 		 <section class="contents" id="contents" >
				<img alt="PRINT" src="/KCFM/assets/images/print_btn.png" onclick="javascript:fnPrintPage();" style="width:50px;height:50px;float:right"/>
		    <article class="tab-pages" >
	 		 	<div> 
 			 		<h1>◎ <span>매출 입력</span></h1>
 			 	</div>
<!-- 			  	<div style="margin-top:5px;width:25%;;height:500px;display:inline-block;overflow:scroll;">
 					<table id="tableA" class='tableT'   width="100%" height="100%" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="font-size: 11px; margin-right: 5px;">
						<thead>
				 			<tr bgcolor="#80B38C" align="center" style="border-bottom: 1px solid #797979;">
					         <th style="border-bottom: 1px solid #797979;"><font color="#ffffff"><b>NO</b></font></th>
					         <th ><font color="#ffffff"><b>지사명</b></font></th>
					         <th ><font color="#ffffff"><b>직영점</b></font></th>
					         <th ><font color="#ffffff"><b>가맹점</b></font></th>
					         <th ><font color="#ffffff"><b>합계</b></font></th>
						    </tr>
						</thead>
						<tbody>

						</tbody>				  			
					</table> 
	
			  	</div> -->
 			    <div id='jqxWidget' style="width:100%;font-size: 13px; font-family: Verdana;">
			        <div id="jqxgrid" ></div>
			    </div>
				
			  </article>



	     </section>
	 
	 
	 
 		 	

	 
	 
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div><!-- end of wrap -->
</body>
<iframe name="iWorker" style="width:0;height:0;"></iframe>
</html>