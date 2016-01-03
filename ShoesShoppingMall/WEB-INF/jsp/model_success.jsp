<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript" src="../jquery.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	alert("모델 저장 완료.");
});
</script>
 	<font color="#353535"><h2><i><u>Model Save Complete</u></i></h2></font>
	<font color="#8C8C8C"><h3>Model 저장 완료</h3></font>
	
	<table border="0" bordercolorlight="#D5D5D5" bordercolordark="white" width="800" cellspacing="0" class="topline">
		<thead>
		</thead>
		<tbody>
			<tr height="40">
				<th class='line'>Model Name</th>
				<td class='line'>${requestScope.mto.modelName }<td>
			</tr>
			<tr height="40">
				<th class='line'>Model Num</th>
				<td class='line'>${requestScope.mto.modelNum }<td>
			</tr>
			<tr height="40">
				<th class='line'>Model Type</th>
				<td class='line'>${requestScope.mto.modelType }<td>
			</tr>
			<tr height="40">
				<th class='line'>Model Heel</th>
				<td class='line'>${requestScope.mto.modelHeel }<td>
			</tr>
			<tr height="40">
				<th class='line'>Model Leather</th>
				<td class='line'>${requestScope.mto.modelLeather }<td>
			</tr>
			<tr height="40">
				<th class='line'>Model Price</th>
				<td class='line'>${requestScope.mto.modelPrice }<td>
			</tr>
			<tr height="40">
				<th class='line'>Image File Name</th>
				<td class='line'>category_${requestScope.mto.modelType }_${requestScope.mto.modelNum }.jpg<td>
			</tr>
		</tbody>
		<tfoot>
				<tr>
					<td colspan="7">
							<span style="padding-left:300px;text-decoration:none;">
								<a href = "/kostaWebS/mainPage.do">메인 페이지로</a>
								<a href = "/kostaWebS/mypageForm.do" >마이 페이지로</a>
								<a href = "/kostaWebS/model/modelList.do" >Model List Page</a>
							</span>
					</td>	
				</tr>
				<tr>		
				</tr>
		</tfoot>
	</table>
	

 	
