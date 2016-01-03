<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 인클루드 되므로 보여질 부분만 넣는다. -->
회원 등록 폼입니다.

<script type="text/javascript">

$(document).ready(function(){
	
	
	$("#joinBtn").on("click",function(){
		if($("#id").val()==""){
			alert("아이디를 입력하세요.");
			$("#id").focus();
			return false;
		}
		if($("#password").val()==""){
			alert("password를 입력하세요.");
			$("#password").focus();
			return false;
		}
		if($("#name").val()==""){
			alert("이름을 입력하세요.");
			$("#name").focus();
			return false;
		}
		if($("#reg1").val()==""){
			alert("주민번호 앞자리를 입력하세요.");
			$("#reg1").focus();
			return false;
		}
		if($("#reg2").val()==""){
			alert("주민번호 뒷자리를 입력하세요.");
			$("#reg2").focus();
			return false;
		}
		if($("#postcode1").val()==""){
			alert("우편번호를 검색하세요.");
			$("#postcode1").focus();
			return false;
		}
		if($("#addr2").val()==""){
			alert("상세 주소를 입력해주세요.");
			$("#addr2").focus();
			return false;
		}
		
		var address = $("#addr1").val()+" "+$("#addr2").val();
		$("#address").val(address);
		var tel = $("#phone1").val()+""+$("#phone2").val()+""+$("#phone3").val();
		$("#tel").val(tel);
		
			 
	});
		
	$("#checkReg").click(function(){
	 	$.ajax({
			"url":"/kostaWebS/registerCheck.do",
			"type":"POST",
			"data":"registerNumber1="+$("#reg1").val()+"&registerNumber2="+$("#reg2").val(),
			"dataType":"JSON",
			"beforeSend":function(){
			},
			"success":function(data){
				var flag = data.flag;
				if(flag){
					alert("이미 가입된 주민번호 입니다.");
					return false;
				}else{
					alert("가입가능한 주민번호 입니다.");
					return true;
				}
			}
		
		});
	});
	
	
	
	
	$("#email2").change(function(){
		var txt = $(this).val();
		if($("#email2 option").index("#email:selected")!=0){
		$("#email").val(txt);
		}
	});
	
	
	
		$("#idCheck").click(function(){
		window.open("/kostaWebS/memberjsp/checkId_popup.jsp","","width=400,height=300");
		});
		
		$("#postCheck").click(function(){
			window.open("/kostaWebS/memberjsp/checkPost_popup.jsp","","width=500,height=300,scrollbars=yes");
		});
		
});

</script>

  <font color="#353535"><h2><i><u>JOIN US</u></i></h2></font>
	<font color="#8C8C8C"><h3>기본정보</h3></font>
	

	<form method ="POST" action="/kostaWebS/joinMember.do" name="joinForm">
	<table border="0" bordercolorlight="#D5D5D5" bordercolordark="white" cellspacing="0" width="800" height="500" class="topline">

		<thead></thead>


		<tbody>

			<tr>
				<th class="line">아이디</th>
				<td class="line"><input type="text" name="id" id = "id"/><img alt="아이디중복확인" src="/kostaWebS/images/decoration/checkId.jpg" id="idCheck"> (영문소문자/숫자, 4~16자)</td>
			</tr>
			<tr>
				<th class="line">별명</th>
				<td class="line"><input id="nick_name" name="nick_name" maxlength="20"
					value="" type="text" /> (한글2~10자/영문 대소문자4~20자/숫자 혼용가능)
				</td>
			</tr>
			<tr>
				<th class="line">비밀번호</th>
				<td class="line"><input type="text" name="password" id = "password"/> (영문자/숫자, 4~16자)
				</td>
			</tr>
			<tr>
				<th class="line">비밀번호 확인</th>
				<td class="line"><input id="user_passwd_confirm" name="user_passwd_confirm" maxlength="16" value="" type="password" /></td>
			</tr>
			<tr>
				<th class="line">비밀번호 확인 질문</th>
				<td class="line"><select id="hint" name="hint">
						<option value="hint_01">당신의 첫경험 여자 이름?</option>
						<option value="hint_02">후장 해본 경험?</option>
						<option value="hint_03">자신의 보물 제1호는?</option>
						<option value="hint_04">가장 기억에 남는 섹스 파트너?</option>
						<option value="hint_05">타인이 모르는 자신만의 섹스 기술?</option>
						<option value="hint_06">당신의 성감대는?</option>
						<option value="hint_07">받았던 선물 중 가장 기억에 남는 섹스?</option>
						<option value="hint_08">유년시절 가장 생각나는 친구 이름은?</option>
						<option value="hint_09">인상 깊게 성인 소설?</option>
						<option value="hint_10">읽은 책 중에서 좋아하는 구절이 있다면?</option>
						<option value="hint_11">자신이 두번째로 존경하는 인물은?</option>
				</select></td>
			</tr>
			<tr>
				<th class="line">비밀번호 확인 답변</th>
				<td class="line"><input id="hint_answer" name="hint_answer" value="" type="text" /></td>
			</tr>
			
			<tr>
				<th class="line">이름</th>
				<td class="line"><input type="text" name="name" id ="name"/></td>
			</tr>
			<tr>
				<th class="line">주민등록번호</th>
				<td class="line"><input type="text" name="registerNumber1" maxlength="6" id = "reg1"/>-<input type="text" name="registerNumber2" maxlength="7" id="reg2"/>
				<img alt="주민번호 확인" src="/kostaWebS/images/decoration/checkRegnum.jpg" id="checkReg"/>
				</td>
			</tr>
			
			<tr>
				<th class="line">주소</th>
                <td class="line">
                    <input id="postcode1" name="zipcode" value="" type="text" readonly="readonly" size="5"/>
                    <img src="/kostaWebS/images/decoration/checkPostNum.jpg" alt="우편번호 검색" border="0" id="postCheck"/></a><br>
                    <input id="addr1" name="address1" type="text" maxlength="100" size="50"/><br/>
                    <input id="addr2" name="address2" type="text" maxlength="100" size="50"/>
                    <input type = "hidden" name = "address" id="address"/>
                </td>
            </tr>

			</tr>
			<tr>
				<th class="line">유선전화</th>
				<td class="line">
				<select>
						<option value="02">02</option>
						<option value="031">031</option>
						<option value="032">032</option>
						<option value="033">033</option>
						<option value="019">019</option>
				</select>
				&nbsp;&nbsp;&nbsp;
				<input id="" name="" value="" type="text"  size="5"/>-<input id="" name="" value="" type="text"  size="5"/>
				</td>

			</tr>
			<tr>
				<th class="line">휴대전화</th>
				<td class="line">
				<select  id="phone1">
						<option value="" selected="selected">없음</option>
						<option value="010">010</option>
						<option value="011">011</option>
						<option value="016">016</option>
						<option value="017">017</option>
						<option value="018">018</option>
						<option value="019">019</option>
				</select>
				&nbsp;&nbsp;&nbsp;
				<input id="phone2" name="" type="text"  size="5"/>-<input id="phone3" name="" type="text"  size="5"/>
				<input type="hidden" name = "tel" id="tel"/>
				<input type="hidden" name = "memberLevel" value="1"/>
				</td>
			</tr>
			<tr>
				<th class="line">이메일</th>
				<td class="line"><input value="" type="text" />@<input
					id="email" name="email" value="" type="text" />
					<select id="email2">
						<option value="" selected="selected">:::::선택:::::</option>
						<option value="naver.com">naver.com</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="empal.com">empal.com</option>
						<option value="etc">직접입력</option>
				</select></td>
			</tr>
			
		</tbody>


		<tfoot>
				<tr>
					<td colspan="3">
							<span style="padding-left:250px;text-decoration:none ">
						<a href = "/kostaWebS/joinForm.do"><img alt="회원가입 취소" src="/kostaWebS/images/decoration/joinCancel.jpg" border="0" id="cancelBtn"/></a>
							<input type="image" src ="/kostaWebS/images/decoration/joinRegister.jpg" border="0" id="joinBtn"/>
							</span>
							
					</td>	
				</tr>
				<tr>
					
				</tr>
		</tfoot>


	</table>
	
	</form>

