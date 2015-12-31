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
<script type="text/javascript" src="<%=root %>/assets/js/fusionChart/fusioncharts.js"></script>
<script type="text/javascript" src="<%=root %>/assets/js/fusionChart/fusioncharts.charts.js"></script>
<script type="text/javascript" src="<%=root %>/assets/js/fusionChart/fusioncharts-jquery-plugin.min.js"></script>
<script type="text/javascript">

    $(document).ready(function(){

    	fnSearchList_지사();
    	fnSearchList_지역();
    	fnSearchList_년도();

    });
    


    function fnSearchList_지사(){
    	document.form1.actionMode.value = "search";
    	document.form1.section.value    = "branch";
    	
    	var fData = $("#form1").serializeArray();
    	
    	
    	$.ajax({
			url: 'b1101.do',
    		data:fData,
    		dataType:'json',
    		success:function(Jsondata){
    			
    			var data = Jsondata.list;
    			
    			fnMakeDataTable_지사(data);
    		}
    	});
    }
    
    function fnSearchList_지역(){
    	document.form1.actionMode.value = "search";
    	document.form1.section.value    = "location";
    	
    	var fData = $("#form1").serializeArray();
    	
    	
    	$.ajax({
			url: 'b1101.do',
    		data:fData,
    		dataType:'json',
    		success:function(Jsondata){
    			
    			var data = Jsondata.list;
    			
    			fnMakeDataTable_지역(data);
    		}
    	});
    }

    function fnSearchList_년도(){
    	document.form1.actionMode.value = "search";
    	document.form1.section.value    = "year";
    	
    	var fData = $("#form1").serializeArray();
    	
    	
    	$.ajax({
			url: 'b1101.do',
    		data:fData,
    		dataType:'json',
    		success:function(Jsondata){
    			
    			var data = Jsondata.list;
    			
    			fnMakeDataTable_년도(data);
    		}
    	});
    }
    
    
    
    
    function fnMakeDataTable_지사(data)
   	{
    	
    	if(data.length==0)
    	{
    		$("#tableA tbody").append("<tr><td>조회된 자료가 없습니다.</td></tr>")
    		
    		return;
    	}
    	
    	for(var i =0;i<data.length;i++)
    	{
    		var str = "<tr align='center' bgcolor='#ffffff'>"; //행시작
    		
    		str +=  "<td bgcolor='#DFE1E0'>"+(i+1)+"</td>";                        //컬럼 정의
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].지사명+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].직영점+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].가맹점+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].점합계+"</td>";
    		
    		str +=  "</tr>"; //행 끝
    		
    		$("#tableA tbody").append(str);
    	}
    	
    	
    	
    	fnCreateChart_지사(data);
    	
   	}
    
    function fnMakeDataTable_지역(data)
   	{
    	
    	if(data.length==0)
    	{
    		$("#tableB tbody").append("<tr><td>조회된 자료가 없습니다.</td></tr>")
    		
    		return;
    	}
    	
    	for(var i =0;i<data.length;i++)
    	{
    		var str = "<tr align='center' bgcolor='#ffffff'>"; //행시작
    		
    		str +=  "<td bgcolor='#DFE1E0'>"+(i+1)+"</td>";                        //컬럼 정의
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].지역명+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].직영점+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].가맹점+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].점합계+"</td>";
    		
    		str +=  "</tr>"; //행 끝
    		
    		$("#tableB tbody").append(str);
    	}
    	
    	
    	
    	fnCreateChart_지역(data);
    	
   	}
    
    
    function fnMakeDataTable_년도(data)
   	{
    	
    	if(data.length==0)
    	{
    		$("#tableB tbody").append("<tr><td>조회된 자료가 없습니다.</td></tr>")
    		
    		return;
    	}
    	
    	for(var i =0;i<data.length;i++)
    	{
    		var str = "<tr align='center' bgcolor='#ffffff'>"; //행시작
    		
    		str +=  "<td bgcolor='#DFE1E0'>"+(i+1)+"</td>";                        //컬럼 정의
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].회계년도+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].직영개점+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].직영폐점+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].가맹개점+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].가맹폐점+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].개점합계+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].폐점합계+"</td>";
    		str +=  "<td bgcolor='#DFE1E0'>"+data[i].증감매장+"</td>";
    		
    		str +=  "</tr>"; //행 끝
    		
    		$("#tableC tbody").append(str);
    	}
    	
    	
    	
    	fnCreateChart_년도(data);
    	
   	}
    
    
	function fnCreateChart_지사(data)
	{
	
		var objParam = {};
		var row = data.length;
		
		for(var i =0;i<row;i++)
		{
			var 지사명 = data[i].지사명;
			var 점합계 = data[i].점합계;
			
			지사명 = (지사명||'이름없음');
			objParam[지사명] = 점합계;
			
		}

		
		$("#chartA").insertFusionCharts({
			type: "Pie2D",
			width: "100%",
			height: "500",
			dataFormat: "json",
			dataSource: getParentChartData(objParam,'지사')
		});
		
	}

	function fnCreateChart_지역(data)
	{
	
		var objParam = {};
		var row = data.length;
		
		for(var i =0;i<row;i++)
		{
			var 지역명 = data[i].지역명;
			var 점합계 = data[i].점합계;
			
			지역명 = (지역명||'이름없음');
			objParam[지역명] = 점합계;
			
		}

		
		$("#chartB").insertFusionCharts({
			type: "Pie3D",
			width: "100%",
			height: "500",
			dataFormat: "json",
			dataSource: getParentChartData(objParam,'지역')
		});
		
	}
	
	
	function fnCreateChart_년도(data)
	{
	
		var objParam = {};
		var row = data.length;
		
		for(var i =0;i<row;i++)
		{
			var 회계년도 = data[i].회계년도;
			var 증감매장 = data[i].증감매장;
			
			objParam[회계년도] = 증감매장;
			
		}

		
		$("#chartC").insertFusionCharts({
			type: "Bar2D",
			width: "100%",
			height: "500",
			dataFormat: "json",
			dataSource: getParentChartData(objParam,'년도')
		});
		
	}
	
	
	function getParentChartData(objParam,chartName){
		//Create JSON object for primary chart's data
		var chartData = {};
		//Set chart attributes
		chartData.chart = {};
		
		switch(chartName)
		{
		case '지사':
			chartData.chart.caption = "Statistics Based on Branch ";
			break;
		case '지역':
			chartData.chart.caption = "Statistics Based on Location ";
			
		case '년도':
			chartData.chart.caption = "Statistics Based on Year ";
		default:
			break;
		}
//		chartData.chart.caption = "가맹점현황";
//		chartData.chart.subCaption = "Click on a pie to see details";
//		chartData.chart.xAxisName = "Country";
//		chartData.chart.yAxisName = "Sales";
//		chartData.chart.showPercentValues = "1";
		chartData.chart.showPercentInToolTip = "0";
//		chartData.chart.numberPrefix = "$";
		//Disabling slicing of pie slice upon click, by setting distance to 0
		chartData.chart.slicingDistance="0";
		chartData.chart.bgColor = "#DFE1E0";
		chartData.chart.bgAlpha = "30";
		chartData.chart.showBorder = "0";
		//Create array within the chartData object to store data
		chartData.data = [];
		//Iterate through each country to add data
		$.each(objParam, function(i, val){
			chartData.data.push ({"label":i, "value":val});
		});
		return chartData;
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
 			 		<h1>◎ <span>지사별 현황</span></h1>
 			 	</div>
			  	<div style="margin-top:5px;width:25%;;height:500px;display:inline-block;overflow:scroll;">
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
	
			  	</div>
				<div id="chartA" style="width:65%;display:inline-block;padding-left:20px;"></div>
				
			  </article>
			  
			 <article class="tab-pages" >
	 		 	<div> 
	 		 		<h1>◎ <span>지역별 현황</span></h1>
	 		 	</div>
			  	<div style="margin-top:5px;width:25%;;height:500px;display:inline-block;overflow:scroll;">
					<table id="tableB" class='tableT'   width="100%" height="100%" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="font-size: 11px; margin-right: 5px;">
						<thead>
				 			<tr bgcolor="#80B38C" align="center" style="border-bottom: 1px solid #797979;">
					         <th ><font color="#ffffff"><b>NO</b></font></th>
					         <th ><font color="#ffffff"><b>지역명</b></font></th>
					         <th ><font color="#ffffff"><b>직영점</b></font></th>
					         <th ><font color="#ffffff"><b>가맹점</b></font></th>
					         <th ><font color="#ffffff"><b>합계</b></font></th>
						    </tr>
						</thead>
						<tbody>

						</tbody>				  			
					</table>
	
			  	</div>
	 			<div id="chartB" style="width:65%;display:inline-block;padding-left:20px;"></div> 
				
			  </article>
	 


			 <article class="tab-pages" >
	 		 	<div> 
	 		 		<h1>◎ <span>년도별 현황</span></h1>
	 		 	</div>
			  	<div style="margin-top:5px;width:30%;;height:500px;display:inline-block;overflow:scroll;">
					<table id="tableC" class='tableT'   width="100%" height="100%" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" style="font-size: 11px; margin-right: 5px;">
						<thead>
				 			<tr bgcolor="#80B38C" align="center" style="border-bottom: 1px solid #797979;">
					         <th rowspan="2"><font color="#ffffff"><b>NO</b></font></th>
					         <th rowspan="2"><font color="#ffffff"><b>년도</b></font></th>
					         <th colspan="2"><font color="#ffffff"><b>직영점</b></font></th>
					         <th colspan="2"><font color="#ffffff"><b>가맹점</b></font></th>
					         <th colspan="3"><font color="#ffffff"><b>합계</b></font></th>
						    </tr>
						    <tr bgcolor="#80B38C" align="center" style="border-bottom: 1px solid #797979;">

					         <th ><font color="#ffffff"><b>개점</b></font></th>
					         <th ><font color="#ffffff"><b>폐점</b></font></th>
					     	 <th ><font color="#ffffff"><b>개점</b></font></th>
					         <th ><font color="#ffffff"><b>폐점</b></font></th>
					     	 <th ><font color="#ffffff"><b>개점</b></font></th>
					         <th ><font color="#ffffff"><b>폐점</b></font></th>
					         <th ><font color="#ffffff"><b>증감</b></font></th>					         
						    </tr>
						</thead>
						<tbody>

						</tbody>				  			
					</table>
	
			  	</div>
	 			<div id="chartC" style="width:65%;display:inline-block;padding-left:20px;"></div> 
				
			  </article>	 
	 
	     </section>
	 
	 
	 
 		 	

	 
	 
 		 
 		 
 		<!-- modal popup -->
	 	<div class="overlay-bg-half"></div>
	</div><!-- end of wrap -->
</body>
<iframe name="iWorker" style="width:0;height:0;"></iframe>
</html>