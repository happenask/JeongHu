<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 인클루드 되므로 보여질 부분만 넣는다. -->
<script type="text/javascript">

	if("${requestScope.success}"){
		alert("${requestScope.success}")
	}
	
</script>


	
	<div style="margin-left: 200px;margin-top: 50px;">
		<embed src="/kostaWebS/images/slide_show.gif" width="700" height="400" />
	</div>
	
	<div style="margin-left: 50px;margin-top: 50px;">
	<strong>Error 페이지</strong>
	${requestScope.error_message };
	</div>
