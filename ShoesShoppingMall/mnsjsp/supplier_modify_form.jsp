<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <script type="text/javascript">
$(document).ready(function(){
	$("#submit").on("click",function(){
		if($("#name").val()==""){
			alert("거래처 이름을 입력하세요.");
			$("#name").focus();
			return false;
		}
		if($("#address").val()==""){
			alert("거래처 주소를 입력하세요.");
			$("#address").focus();
			return false;
		}
		if($("#tel").val()==""){
			alert("전화번호를 입력하세요.");
			$("#tel").focus();
			return false;
		}
		if($("#message").val()==""){
			alert("메모를 입력하세요.");
			$("#message").focus();
			return false;
		}
		
	});
	if("${requestScope.error_message}"){
		
		alert("${requestScope.error_message}");
	}
});
</script>
<h2>거래처 수정 폼</h2>
<form name="sr" action="/kostaWebS/supplier/supplierModifySuccess.do">
    <table width='500'>
        <tr>
            <td width="150">거래처 이름</td>
            <td><input type="text" name="name" id="name" value="${sessionScope.supplier.name }" readonly></td>
        </tr>
        <tr>
            <td>거래처 주소</td>
            <td>
                <input type="text" name="address" id="address">
            </td>
        </tr>
        <tr>
            <td>거래처 전화번호</td>
            <td>
                <input type="text" name="tel" id="tel">
            </td>
        </tr>
        <tr>
            <td>메모</td>
            <td>
                <textarea name="message" id="message" rows="5" cols="30" style="resize:none"></textarea>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" id="submit" value="수정" style="background-color: buttonhighlight";>
                <input type="reset" value="다시작성" style="background-color: buttonhighlight";>
            </td>
        </tr>
    </table>
</form>
