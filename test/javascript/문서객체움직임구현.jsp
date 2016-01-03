<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script type="text/javascript">

window.onload=function(){
	var sun = document.getElementById('sun');
	var earth = document.getElementById('earth');
	var moon = document.getElementById('moon');
	
	sun.style.position = 'absolute';
	earth.style.position = 'absolute';
	moon.style.position = 'absolute';
	
	
	sun.style.left = 250 + 'px';
	sun.style.top = 200 + 'px';
	
	
	//������ �����մϴ�.
	
	var earthAngle = 0;
	var moonAngle = 0;
	
	setInterval(function(){
	    //������ ����� ������ ���� ��ǥ�� ���մϴ�.
	    var earthLeft = 250 + 150 * Math.cos(earthAngle);
	    var earthTop = 200 + 150 * Math.sin(earthAngle);
	    var moonLeft = earthLeft + 50 * Math.cos(moonAngle);
	    var moonTop = earthTop + 50 * Math.cos(moonAngle);
	
	
	      // ��ġ�� �̿��մϴ�.
	
	    earth.style.lefth = earthLeft + 'px';
	    earth.style.top = earthLeft + 'px';
	    moon.style.lefth = moonLeft + 'px';
	    moon.style.top = moonTop + 'px';
	
	
	    //������ �����մϴ�.
	    earthAngle +=0.1;
	    moonAngle += 0.3;
	},1000/30);
	
};

</script>
</head>
<body>
	<h1 id ="sun">@</h1>
	<h1 id ="earth">0</h1>
	<h1 id ="moon">*</h1>
	
</body>
</html>