<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<script type="text/javascript" src="/force/jquery.js"></script>
<script type="text/javascript" src="/force/jquery-ui.js"></script>
<script type="text/javascript" src="/force/jsapi.js"></script>
<link rel="stylesheet" type="text/css" href="/force/jquery-ui.css">
<script type="text/javascript">
	$(document).ready(function() {

		$("button").on("click", function() {
			var command = $(this).val();
			$("#command").val(command);
			window.open("/force/menu.jsp", "", "width=900,height=700");
		});
		
		$("#b1").click(function(){
			$("#foodDate").datepicker({"dateFormat":"yy/mm/dd","showButtonPanel":"true","maxDate":"0"});
		});
	});
</script>






<style type="text/css">
div {
	width: 200px;
	height: 200px;
	text-align : center ; 
	background-color:#CC723D;
}
span{
	width: 200px;
	margin-left:200px;
	text-decoration : none ; 
    font : bold 3.0em 'Trebuchet MS' , Arial , Helvetica ;  
    color:#353535;
    display : inline- block ; 
	}

button,#d3 {
	width: 200px;
	background-color:#6799FF;
	font-size:5pt;
    text-decoration : none ; 
    font : bold 1.0em 'Trebuchet MS' , Arial , Helvetica ;  
    display : inline- block ; 

    text-align : center ; 

    color : #fff ; 
    border : 1px solid #9c9c9c ;
    border : 1px solid RGBA ( 0 , 0 , 0 , 0.3 );            

    text-shadow : 0 1px 0 rgba ( 0 , 0 , 0 , 0.4 ); 
    box-shadow : 0 0 . 05em RGBA ( 0 , 0 , 0 , 0.4 ); 
    -moz-box-shadow : 0 0 . 08em RGBA ( 0 , 0 , 0 , 0.4 ); 
    -webkit-box-shadow : 0 0 . 05em RGBA ( 0 , 0 , 0 , 0.4 ); 
	
}
</style>
<body>

	<input type="hidden" name="command" id="command" />

<span>
	별난 버섯집 POS SYSTEM
</span>





	<table>
		<tr>
			<td>
				<div class="div1">
					<button id="table1">TABLE1</button>
				</div>
			</td>
			<td>
				<div class="div2">
					<button id="table2">TABLE2</button>
				</div>
			</td>
			<td>
				<div class="div3">
					<button id="table3">TABLE3</button>
				</div>
			</td>
				<td>
				<div class="div4">
					<button id="table4">TABLE4</button>
				</div>
			</td>
				<td>
				<div class="div5">
					<button id="table5">TABLE5</button>
				</div>
			</td>
		</tr>

		<tr>
			<td>
				<div class="div4">
					<button id="table6">TABLE6</button>
				</div>
			</td>
			<td>
				<div class="div5">
					<button id="table7">TABLE7</button>
				</div>

			</td>
			<td>
				<div class="div3">
					<button id="table8">TABLE8</button>
				</div>
			</td>
				<td>
				<div class="div3">
					<button id="table9">TABLE9</button>
				</div>
			</td>
				<td>
				<div class="div3">
					<button id="table10">TABLE10</button>
				</div>
			</td>
		</tr>

	</table>
	<form action="/force/">
	
	</form>
	<a href="/force/total_calculate.jsp" style="background-color:#F6F6F6;font-weight:bold;text-decoration: none;color: black;background-color:#BDBDBD;"><font size="10">정산하기 Click!</font></a>
 	
</body>
</html>