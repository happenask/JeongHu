<%@ page language="java" contentType="text/html; charset=EUC-KR" import="java.util.*" %>
<html>
<body>
<center><h3> [������ ���ǰ��� ��� �������� ����] </h3></center>
<hr>
getAttributeNames() �޼ҵ带 ����ϴ� JSP������
<hr>
<%
String A = "���� �������� ������ ��� ���ǰ��� ��Ÿ���ϴ�!!";

session.setAttribute("Data02", A);

String se_name = ""; //���� ��ü�� Ű�� ������ ����
String se_value = ""; //���� ��ü�� ����� ���� ������ ����

//getAttributeNames �޼ҵ�� ���ǿ� �ִ� ��� Ŷ���� ������ Enumeration��ü�� ����
Enumeration enum_01 = session.getAttributeNames(); 
int i = 0; //���� Ŷ���� ���� ������ ����
/* Enumeration��ü�� hasMoreElements�޼ҵ带 ����Ͽ� �������� �����ϴ�����
�Ǵ��Ͽ� �����ϸ� �ݺ����� ��� �����ϰ� �������� �������� ������ �ݺ����� �����. */
while(enum_01.hasMoreElements()) {
 i++; //�ݺ����� �����Ҷ����� i�� 1�� ������Ų��
  /* Enumeration ��ü�� nextElement �޼ҵ�� �������� �ϳ��� �̾ƿ��� �������Ѵ�.
     �̾ƿ� ��ü�� ���ڿ��� �����Ͽ� se_name������ �����Ѵ�. */
  se_name = enum_01.nextElement().toString(); 
  /* Ű �̸��� ����� se_name������ ������ getAttribute �޼ҵ忡 �����Ͽ� ���� �޾ƿ�
  toString �޼ҵ带 �̿��Ͽ� ���ڿ��� �����Ͽ� ���ǰ��� se_value�� �����Ѵ�. */
  se_value = session.getAttribute(se_name).toString();
  
  out.println("<br>���� ���� �̸� [" + i + "] : " + se_name + "<br>");
  out.println("<br>���� ���� �� [" + i + "] : " + se_value + "<hr>");
}

 Cookie[] cc = request.getCookies();
 for(int z =0;z<cc.length;z++){
	 out.println("��Ű�� ��ȸ : "+cc[z].getName()+"<br>");
	 out.println("��Ű�� ��ȸ : "+cc[z].getValue()+"<br>");
 }
%>
</body>
</html>



