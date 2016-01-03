<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <script type="text/javascript">
    $(document).ready(function(){
    	$("#submit").on("click",function(){
    		if($("#materialId").val()==""){
    			alert("재료 ID를 입력하세요.");
    			$("#materialId").focus();
    			return false;
    		}
    	});
    	if("${requestScope.error_message}"){
    		alert("${requestScope.error_message}");
    	}
    	$("#total").on("click",function(){
    		$.ajax({
    			type:"POST",
                url:"/kostaWebS/material/totalMaterial.do",
                dataType:"JSON",
                success:function(jsonData){
                   var total = jsonData.totalList;
                   $("#tbody").empty();
                   for(var i = 0; i<total.length;i++){
                        $("#tbody").append("<tr><td>"+total[i].materialId+"</td><td>"+total[i].type+"</td><td>"+total[i].name+"</td><td>"+total[i].spec+"</td><td>"+total[i].supplier+"</td><td>"+total[i].quantity+"</td><td>"+total[i].price+"</td></tr>");
                   }                                           
                },
    		});
    		
    	});

    });
</script>
<form name="mr" action="/kostaWebS/material/materialSearchSuccess.do">
재료ID로 검색 : <input type="text" name="materialId" id="materialId">
<input type="submit" id="submit" value="SEARCH"style="background-color:white;font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" id="total" value="TOTAL SEARCH" style="background-color: white;font-weight: bold;">


<table border='1' cellspacing="0" width="600px" cellpadding="5px"> 
    <thead>
        <tr>
            <td>재료ID</td>
            <td>재료타입</td>
            <td>재료이름</td>
            <td>재료특징</td>
            <td>재료거래처</td>
            <td>재료수량</td>
            <td>재료가격</td>
        </tr>
    
    
    </thead>
    
    <tbody id ="tbody">
        
    
    
    </tbody>   
   
</table>