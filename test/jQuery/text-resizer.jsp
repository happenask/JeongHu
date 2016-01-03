<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="../jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="../jquery.cookie.js"></script>
<style type="text/css">
body { font: 12px/18px Arial, sans-serif; } 
.medium { font-size: 16px; line-height: 22px; }
.large { font-size: 20px; line-height: 26px; } 
h1 { font-size: 30px; line-height: 36px; }
.medium h1 { font-size: 34px; line-height: 40px; }
.large h1 { font-size: 38px; line-height: 44px; }
h2 { font-size: 24px; line-height: 30px; }
.medium h2 { font-size: 28px; line-height: 34px; }
.large h2 { font-size: 32px; line-height: 38px; }
h3 { font-size: 18px; line-height: 24px; }
.medium h3 { font-size: 22px; line-height: 28px; }
.large h3 { font-size: 26px; line-height: 32px; } 



</style>
<script type="text/javascript">

/*set resizer cookie*/
$(document).ready(function() {
 if($.cookie('TEXT_SIZE')) {
  $('body').addClass($.cookie('TEXT_SIZE')); 
 }
 $('.resizer a').click(function() {
  var textSize = $(this).parent().attr('class');
  $('body').removeClass('small medium large').addClass(textSize);
  $.cookie('TEXT_SIZE',textSize, { path: '/', expires: 10000 });
  return false;
 });
}); 
</script>
</head>
<body>
<ul class="resizer">
 <li class="small"><a href="#">small</a></li>
 <li class="medium"><a href="#">medium</a></li>
 <li class="large"><a href="#">large</a></li>
</ul> 
</body>
</html>
