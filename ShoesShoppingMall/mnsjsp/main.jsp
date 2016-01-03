<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 인클루드 되므로 보여질 부분만 넣는다. -->
메인 페이지 입니다. ${requestScope.msg }<br>

<script type="text/javascript">
if("${requestScope.success}"){
	alert("${requestScope.success}");
}
</script>
