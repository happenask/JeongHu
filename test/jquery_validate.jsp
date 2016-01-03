<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src = "/test/jquery.js"></script>
<script type="text/javascript" src = "/test/jquery.validate.js"></script>
<script type="text/javascript">


//   required : 반드시 입력해야하는지 여부, true일 경우 반드시 입력!
//  minlength: 최소 문자 수
//  equalTo : 값이 같아야하는 입력필드의 아이디 지정
//  email: true 입력하는 내용이 이메일주소의 형태를 가져야함을 지정
//  message에는 rule에 맞지않아 검증결과 실패일 경우, 나타낼 메세지 입니다.
//  각각의 룰이 실패할 경우, 표시할 메세지를 지정해 줍시다.


$(document).ready(function(){
	


    $('#form_signup').validate({
            rules: {
                user_id: { required: true, minlength: 3 },
                user_pass: { required: true ,minlength:8},
                user_pass2: { equalTo: "#user_pass" },
                user_email: { required: true, email: true }
            },
            messages: {
                user_id: {
                    required: "아이디를 입력하시오.",
                    minlength: "암호는 8자 이상이어야 합니다"
                },
                user_pass: { required: "암호를 입력하시오." },
                user_pass2: { equalTo: "암호를 다시 확인하세요." },
                user_email: { 
                                    required: "이메일주소를 입력하시오.",
                                    email: "올바른 이메일주소를 입력하시오." 
                                }
            },
            submitHandler: function (frm) {
                frm.submit();
            },
            success: function (e) { 
            //
            }
        });
    
    
    
    
    $("#signupForm").validate({
        rules: {
          name: "required",
          password: {
            required: true,
            minlength: 8
          },
          confirm_password: {
            required: true,
            minlength: 8,
            equalTo: "#password"
          },
          email: {
            required: true,
            email: true
          },
          topic: {
            required: "#newsletter:checked",
            minlength: 2
          },
          agree: "required"
        },
        messages: {
          name: "이름을 입력해 주세요",
          password: {
            required: "암호를 입력해 주세요",
            minlength: "암호는 8자 이상이어야 합니다."
          },
          confirm_password: {
            required: "암호를 한 번 더 입력해 주세요",
            minlength: "암호는 8자 이상이어야 합니다.",
            equalTo: "암호가 일치하지 않습니다."
          },
          email: "형식에 맞는 이메일을 입력해 주세요.",
          agree: "정책 동의에 체크해 주세요"
        }
      });

});
</script>
</head>
<body>
	<form class="form-signup" name="form_signup" id="form_signup" method="post" action="" >
        
        <fieldset>
		<legend>SING_UP</legend>	
        <label>아이디</label>
        <input type="text" name="user_id" id="user_id" class="input-block-level" >
        <label>비밀번호</label>
        <input type="password" name="user_pass" id="user_pass" class="input-block-level" >
        <label>비밀번호 확인</label>
        <input type="password" name="user_pass2" id="user_pass2" class="input-block-level" >
        <label>이메일주소</label>
        <input type="text" name="user_email" id="user_email" class="input-block-level" >
        <button type="submit" class="btn btn-large btn-primary">가입</button>
        
        </fieldset>
    </form>  
	
	
	<form id="signupForm" method="get" action="">
  <fieldset>
    <legend>정보를 입력해 주세요</legend>
    <p>
      <label for="name">Lastname</label>
      <input id="name" name="name" />
    </p>
    <p>
      <label for="password">암호</label>
      <input id="password" name="password" type="password" />
    </p>
    <p>
      <label for="confirm_password">암호확인</label>
      <input id="confirm_password" name="confirm_password" type="password" />
    </p>
    <p>
      <label for="email">Email</label>
      <input id="email" name="email" />
    </p>
    <p>
      <label for="agree">개인정보 보호정책 동의</label>
      <input type="checkbox" class="checkbox" id="agree" name="agree" />
    </p>
    <p>
      <input class="submit" type="submit" value="제출"/>
    </p>
  </fieldset>
</form>
</body>
</html>