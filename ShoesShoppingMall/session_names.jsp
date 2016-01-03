<%@ page language="java" contentType="text/html; charset=EUC-KR" import="java.util.*" %>
<html>
<body>
<center><h3> [설정된 세션값을 모두 가져오는 예제] </h3></center>
<hr>
getAttributeNames() 메소드를 사용하는 JSP페이지
<hr>
<%
String A = "현재 페이지를 포함한 모든 세션값이 나타납니다!!";

session.setAttribute("Data02", A);

String se_name = ""; //세션 객체의 키를 저장할 공간
String se_value = ""; //세견 객체에 저장된 값을 저장할 공간

//getAttributeNames 메소드로 세션에 있는 모든 킷값을 가져와 Enumeration객체에 저장
Enumeration enum_01 = session.getAttributeNames(); 
int i = 0; //세션 킷값의 수를 저장할 공간
/* Enumeration객체의 hasMoreElements메소드를 사용하여 아이템이 존재하는지를
판단하여 존재하면 반복문을 계속 진행하고 아이템이 존재하지 않으면 반복문은 벗어난다. */
while(enum_01.hasMoreElements()) {
 i++; //반복문을 수행할때마다 i를 1씩 증가시킨다
  /* Enumeration 객체의 nextElement 메소드는 아이템을 하나씩 뽑아오는 역할을한다.
     뽑아온 객체를 문자열로 변경하여 se_name변수에 저장한다. */
  se_name = enum_01.nextElement().toString(); 
  /* 키 이름이 저장된 se_name변수를 세션의 getAttribute 메소드에 지정하여 값을 받아와
  toString 메소드를 이용하여 문자열로 변경하여 세션값을 se_value에 저장한다. */
  se_value = session.getAttribute(se_name).toString();
  
  out.println("<br>얻어온 세션 이름 [" + i + "] : " + se_name + "<br>");
  out.println("<br>얻어온 세션 값 [" + i + "] : " + se_value + "<hr>");
}

 Cookie[] cc = request.getCookies();
 for(int z =0;z<cc.length;z++){
	 out.println("쿠키값 조회 : "+cc[z].getName()+"<br>");
	 out.println("쿠키값 조회 : "+cc[z].getValue()+"<br>");
 }
%>
</body>
</html>



