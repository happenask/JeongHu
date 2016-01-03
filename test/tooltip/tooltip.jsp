<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>

<script type="text/javascript" src = "/test/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src = "/test/jquery.qtip-1.0.0-rc3.min.js"></script>
<script type="text/javascript">

/* qtip 사이트 주소 http://craigsworks.com/projects/qtip/docs/tutorials/#styling */

	$(document).ready(function(){
		
	     /* TOOTIP BIGGINH */
		  $('#content a[href]').qtip({
			   content: 'This is an active list element',
			   show: 'mouseover',
			   hide: 'mouseout'
			});
		  
		  $('a[title]').qtip({
			   style:{name:'cream',tip:true}
			});

		  /* TOOTIP styling */
		  
		  $("#styling").qtip({
			   content: 'Presets, presets and more presets. Let\'s spice it up a little with our own style!',
			   style: { 
			      width: 200,
			      padding: 5,
			      background: '#A2D959',
			      color: 'black',
			      textAlign: 'center',
			      border: {
			         width: 7,
			         radius: 5,
			         color: '#A2D959'
			      },
			      tip: 'bottomLeft',
			      name: 'dark' // Inherit the rest of the attributes from the preset dark style
			   }
			});
		/* TOOLTIP POSITIONING */
		  $("#positioning").qtip({
			   content: 'I\'m at the top right of my target',
			   position: {
			      corner: {
			         target: 'topRight',
			         tooltip: 'bottomLeft'
			      }
			   }
			});
	});

</script>
</head>
<body>


<div id ="content" >

	<a href="" title="TOOTIP">TOOTIP BEGING.</a>
	<a href="" id ="styling">TOOTIP STYLING.</a>
	<a href="" id ="positioning">TOOTIP POSITIONING.</a>
</div>
</body>
</html>