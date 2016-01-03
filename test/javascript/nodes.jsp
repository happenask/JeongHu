<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<script type="text/javascript">

	function sortkids(e){
		
		if(typeof e =="string") e = document.getElementById(e);
		
		var kids[];
		
		kids = e.childNodes;
		
		
		for(var x = e.firstChild;a!=null;x=e.nextSibling){
			
			if(x.nodeType==1){
				kids.push(x);
			}
		}
		
		
		kids.sort(function(n,m){
			
		});
	}

</script>
<body>



<ul id = "list">
	<li>c</li><li>f</li><li>d</li><li>a</li><li>b</li>

</ul>

<button onclick="sortkids('list')">Sort List</button>
</body>
</html>