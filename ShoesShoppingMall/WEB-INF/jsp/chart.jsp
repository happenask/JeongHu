<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="../jsapi.js"></script> 
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">  
google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(); 
$(document).ready(function(){
	$("#year").on("click", function(){
		$("#year").val("");
	});
	$("#btn").on("click", function(){
		if(isNaN($("#year").val())){
			$("#year").val("'Year' 입력");
			alert("그래프를 그릴 Year를 숫자로 입력하세요.\n 예: 2013");
			return;
		}
		var chartdata = "";
		$.ajax({
			"url":"/kostaWebS/order/getChartData.do",
			"type":"POST",
			"data":"year="+$("#year").val(),
			"dataType":"JSON",
			"beforeSend":function(){},
			"success":function(data){
				var list = data.list;
				if((list.length!=0)&&(list[0]!=null)){
					chartdata = [list[0], list[1], list[2], list[3], list[4], list[5], list[6], list[7], list[8], list[9], list[10], list[11], list[12]];
					drawChart(chartdata);
				}
				
			
			}
		});
		
		
	});
});

function drawChart(data){
	var data = google.visualization.arrayToDataTable(data);
	var options = {title: '매출 금액/수량', width: 900, height: 500};
	var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
	chart.draw(data, options); 
}   
</script>
<img alt="" src="/kostaWebS/images/decoration/mypageLogo.jpg"><p>
<font color="#353535"><h2><i><u>Chart - 월별 판매 수량/ 금액</u></i></h2></font>
<input type="text" id="year" value="'Year' 입력">
<button id="btn" >그래프 그리기</button><br>
<div id="chart_div" style="width: 900px; height: 500px;">
</div>