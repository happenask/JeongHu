<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><tiles:getAsString name="title"/></title>
<script type="text/javascript" src="/kostaWebS/jquery.js"></script>
<style type="text/css">
  .line{border-top:1px solid #D5D5D5; font-size:8pt; color:#8C8C8C;font-style:normal;padding-left:50px; }
  .writeline{border-top:1px solid #D5D5D5; font-size:9pt; color:#8C8C8C;font-style:normal;padding-left:50px; }
  .topline{border-top:2px solid #D5D5D5;}
  .link{text-decoration: none;}
  .board{margin-left: 50px;margin-top: 50px;width:900px;border-collapse: collapse;border:0;border-right:3px solid #242424; }
  .boardline1{border-top:2px solid #242424;border-bottom:2px solid #242424;font-size:15px;font-style:inherit;}
  .boardline2{border-bottom:1px solid #D5D5D5;color:#242424;}
 .productTable img
 {
 opacity:1.0;
 filter:alpha(opacity=100); /* For IE8 and earlier */
 }
 .productTable img:hover
 {
 opacity:0.4;
 filter:alpha(opacity=40); /* For IE8 and earlier */
 }
 li img
 {
 opacity:0.5;
 filter:alpha(opacity=50); /* For IE8 and earlier */
 }


#container{
	width:1221px;
	border: 1px solid black;
	margin:auto; 
}
#header{
	padding: 5px;
	border-bottom: 1px solid black;
}
#left{
	padding: 5px;
	height:800px;width:200px; 
	float:left;
}
#content{
	padding: 5px;
	width:600px;
	float:left;
	padding-left:50px;
	text-decoration:none;
	 CURSOR: pointer;
}
#footer{
	padding-top:5px;
	clear:left;  
	text-align:center;
	height:350px;
}
</style>
</head>
<body>
<a href = "/kostaWebS/mainPage.do"><img src = "/kostaWebS/images/decoration/Logo.jpg" border="0"></a>
<div id="container" >

	<div id="header" align="right">
		<tiles:insertAttribute name = "header"/>
	</div>

	<div id="left" >
		<tiles:insertAttribute name = "left"/><!--설정 불러오기  -->
	</div>

	<div id="content" >
		<tiles:insertAttribute name = "main"/>
		
	</div>

	<div id="footer" >
		<tiles:insertAttribute name = "footer"/>
	</div>
</div>

</body>
</html>