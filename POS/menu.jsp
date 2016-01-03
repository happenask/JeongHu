<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="/force/jquery-ui.css">
<style type="text/css">
#b1,#order1,#order2 {
	width: 120px;
	height:100px;
	background-color:#6799FF;
	font-size:5pt;
	margin : 10px ; 
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
#d1{
		border:2px solid #EAEAEA; 
		background-color: #A6A6A6;
	}
#d2{
		border:2px solid #EAEAEA; 
		background-color:#353535;
	}
	
#table {
	border: 1px solid #D5D5D5;
	width:700px
	cellspacing: 1;
	bordercolorlight:#D5D5D5;
	border-style:groove;
	width:500px;
	height:"500px;
	
}

</style>
<script type="text/javascript" src="/force/jquery.js"></script>
<script type="text/javascript" src="/force/jquery-ui.js"></script>
<script type="text/javascript" src="/force/jsapi.js"></script>

<script type="text/javascript">

	$(document).ready(function(){
			var command=opener.command.value;
			
					$("#thead").append("<tr><td>음식명</td><td>가격</td><td>수량</td><td>"+command+"</td></tr>");
					$("#thead").css({"font-size":"12pt", "color":"#EAEAEA","font-weight":"bold","background-color":"#353535"});
			$.ajax({
				type:"get",
				url:"/force/orderList.do",
				data:{"tableNum":command},
				dataType:"JSON",
				success:function(jsonData){
				
					var list = jsonData.list;
					
						if(list.length!=0){		
							
							for(var i=0;i<list.length;i++){
								$("#t1").append("<tr><td>"+list[i].name+"</td><td id='p1'>"+list[i].price+"</td><td id='f1'>"+list[i].foodNum+"</td><td align='right'><button id='c1'>cancel</button></td></tr>");
								
							}
						}
						
						}
				
				
				
			});
		$("#d1 button").click(function(){
			var name = $(this).text();
			var price = $(this).val();
				alert(name+""+price);
			
			$("#dialog").dialog({"position":"center","draggable":"true","modal":"true","buttons":{"주문":function(){
				
				
			
					var foodNum =$("#foodNum").val();
					
						$.ajax({
							type:"get",
							url:"/force/order.do",
							data:{"tableNum":command,"name":name,"price":price,"foodNum":foodNum},
							dataType:"JSON",
							beforeSend:function(){
								
							},
							success:function(jsonData){
								var fto = jsonData.fto;
								if(!$("#table").is(":contains("+fto.name+")")){
								$("#t1").append("<tr><td>"+fto.name+"</td><td id='p1'>"+fto.price+"</td><td id='f1'>"+fto.foodNum+"</td><td align='right'><button id='c1'>cancel</button></td></tr>");
								
								}
								else{
									$("#table").find(":contains("+fto.name+")").nextAll("#f1").html(fto.foodNum);
									$("#table").find(":contains("+fto.name+")").nextAll("#p1").html(fto.price);
									
								}
							}
						});
				
					},
					Cancel: function() {

				          $( this ).dialog( "close" );
				        }


			}
			
			});
			
					
			
			});
		
		
		
		$("#order1").click(function(){
		
			var flag = window.confirm("창을 닫겠습니까?");
			if(flag){
				window.close(flag);
			}
		});
		
	});
</script>
</head>
<body>


	<table id="table">
		<thead id=thead></thead>
		<tbody id=t1></tbody>

		<tfoot>
		</tfoot>

	</table>

	<div style="background-color: #B2EBF4;">
		<div id="d1">
			<br>

			<button id="b1" value="6000">버섯매운탕</button>
			<button id="b1" value="6000">버섯뚝불고기</button>
			<button id="b1" value="6000">숫총각버섯탕</button>
			<button id="b1" value="5000">알밥</button>
			<button id="b1" value="6000">갈치조림</button>
			<p>
				<button id="b1" value="6000">다슬기탕</button>
				<button id="b1" value="10000">버섯해물파전</button>
				<button id="b1" value="30000">닭볶음탕(대)</button>
				<button id="b1" value="25000">낙지전골(대)</button>
				<button id="b1" value="20000">버섯전골(대)</button>
		</div>
		<p>
		<div id="d2">
			<button id="order1" style="background-color: #99004C;">주문</button>
			&nbsp;&nbsp;&nbsp;
			<button id="order2" style="background-color: #993800;">주문취소</button>
		</div>
		<div id="dialog" title="수량을 입력하세요."
			style="display: none; cursor: pointer">
			수량<input type="text" name="foodNum" id="foodNum">
		</div></body>
</html>