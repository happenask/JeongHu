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


//   required : �ݵ�� �Է��ؾ��ϴ��� ����, true�� ��� �ݵ�� �Է�!
//  minlength: �ּ� ���� ��
//  equalTo : ���� ���ƾ��ϴ� �Է��ʵ��� ���̵� ����
//  email: true �Է��ϴ� ������ �̸����ּ��� ���¸� ���������� ����
//  message���� rule�� �����ʾ� ������� ������ ���, ��Ÿ�� �޼��� �Դϴ�.
//  ������ ���� ������ ���, ǥ���� �޼����� ������ �ݽô�.


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
                    required: "���̵� �Է��Ͻÿ�.",
                    minlength: "��ȣ�� 8�� �̻��̾�� �մϴ�"
                },
                user_pass: { required: "��ȣ�� �Է��Ͻÿ�." },
                user_pass2: { equalTo: "��ȣ�� �ٽ� Ȯ���ϼ���." },
                user_email: { 
                                    required: "�̸����ּҸ� �Է��Ͻÿ�.",
                                    email: "�ùٸ� �̸����ּҸ� �Է��Ͻÿ�." 
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
          name: "�̸��� �Է��� �ּ���",
          password: {
            required: "��ȣ�� �Է��� �ּ���",
            minlength: "��ȣ�� 8�� �̻��̾�� �մϴ�."
          },
          confirm_password: {
            required: "��ȣ�� �� �� �� �Է��� �ּ���",
            minlength: "��ȣ�� 8�� �̻��̾�� �մϴ�.",
            equalTo: "��ȣ�� ��ġ���� �ʽ��ϴ�."
          },
          email: "���Ŀ� �´� �̸����� �Է��� �ּ���.",
          agree: "��å ���ǿ� üũ�� �ּ���"
        }
      });

});
</script>
</head>
<body>
	<form class="form-signup" name="form_signup" id="form_signup" method="post" action="" >
        
        <fieldset>
		<legend>SING_UP</legend>	
        <label>���̵�</label>
        <input type="text" name="user_id" id="user_id" class="input-block-level" >
        <label>��й�ȣ</label>
        <input type="password" name="user_pass" id="user_pass" class="input-block-level" >
        <label>��й�ȣ Ȯ��</label>
        <input type="password" name="user_pass2" id="user_pass2" class="input-block-level" >
        <label>�̸����ּ�</label>
        <input type="text" name="user_email" id="user_email" class="input-block-level" >
        <button type="submit" class="btn btn-large btn-primary">����</button>
        
        </fieldset>
    </form>  
	
	
	<form id="signupForm" method="get" action="">
  <fieldset>
    <legend>������ �Է��� �ּ���</legend>
    <p>
      <label for="name">Lastname</label>
      <input id="name" name="name" />
    </p>
    <p>
      <label for="password">��ȣ</label>
      <input id="password" name="password" type="password" />
    </p>
    <p>
      <label for="confirm_password">��ȣȮ��</label>
      <input id="confirm_password" name="confirm_password" type="password" />
    </p>
    <p>
      <label for="email">Email</label>
      <input id="email" name="email" />
    </p>
    <p>
      <label for="agree">�������� ��ȣ��å ����</label>
      <input type="checkbox" class="checkbox" id="agree" name="agree" />
    </p>
    <p>
      <input class="submit" type="submit" value="����"/>
    </p>
  </fieldset>
</form>
</body>
</html>