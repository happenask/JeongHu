<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <p>


<style type="text/css" media="screen">
   
    #list{
        margin:0 auto;
        overflow:hidden;
        position:relative;
    }
    #list ul,
    #list li{
        list-style:none;
        margin:0;
        padding:0;
    }
    #list a{
        position:absolute;
        text-decoration: none;
    }
    #list a:hover{
        color:#8C8C8C;
    }
</style>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">


$(document).ready(function(){
    
var element = $('#list a');
var offset = 0; 
var stepping = 0.01;
var list = $('#list');
var $list = $(list);

/* $list.mousemove(function(e){

    var topOfList = $list.eq(0).offset().top;
 

    var listHeight = $list.height();

    // Sets variable that controls the speed of rotation.
 

    stepping = (e.clientY - topOfList) /  listHeight *0.9 - 0.1;


}); */



for (var i = element.length - 1; i >= 0; i--)
{
    element[i].elemAngle = i * Math.PI * 2 / element.length;
}


setInterval(render, 20);


function render(){
    for (var i = element.length - 1; i >= 0; i--){
        
        var angle = element[i].elemAngle + offset;
        
        x = 120 + Math.sin(angle) * 30;
        y = 45 + Math.cos(angle) * 40;
        size = Math.round(20 - Math.sin(angle) * 20);
        
        var elementCenter = $(element[i]).width() / 2;

        var leftValue = (($list.width()/2) * x / 100 - elementCenter) + "px"

        $(element[i]).css("fontSize", size + "pt");
        $(element[i]).css("opacity",size/100);
        $(element[i]).css("zIndex" ,size);
        $(element[i]).css("left" ,leftValue);
        $(element[i]).css("top", y + "%");
    }
    
    offset += stepping;
}

    
});

</script>

<strong><font size="4px"><u><i>&#9830; Shoes category</i></u></font></strong>
<div  style="background-image: url('/kostaWebS/images/background_left.png');background-position:center; height: 350px;">
 <ul>
 
 
 
                <li class="pst6 xans-record-"><a href="/kostaWebS/model/cate_list.do?cateNumber=01"><img src="/kostaWebS/images/cate_images/cate_menu1.jpg"  border="0" alt="opentoes" onmouseover="this.src='/kostaWebS/images/cate_images/cate_menu1_02.jpg'" onmouseout="this.src='/kostaWebS/images/cate_images/cate_menu1.jpg'"/></a></li><br>
                  <li class="pst7 xans-record-"><a href="/kostaWebS/model/cate_list.do?cateNumber=02"><img src="/kostaWebS/images/cate_images/cate_menu2.jpg"  border="0" alt="sandals" onmouseover="this.src='/kostaWebS/images/cate_images/cate_menu2_02.jpg'"  onmouseout="this.src='/kostaWebS/images/cate_images/cate_menu2.jpg'"/></a></li><br>
                <li class="pst10 xans-record-"><a href="/kostaWebS/model/cate_list.do?cateNumber=03"><img src="/kostaWebS/images/cate_images/cate_menu3.jpg" border="0" alt="flatshoes" onmouseover="this.src='/kostaWebS/images/cate_images/cate_menu3_02.jpg'" onmouseout="this.src='/kostaWebS/images/cate_images/cate_menu3.jpg'"/></a></li><br>
                <li class="pst8 xans-record-"><a href="/kostaWebS/model/cate_list.do?cateNumber=04"><img src="/kostaWebS/images/cate_images/cate_menu4.jpg"  border="0" alt="boots" onmouseover="this.src='/kostaWebS/images/cate_images/cate_menu4_02.jpg'" onmouseout="this.src='/kostaWebS/images/cate_images/cate_menu4.jpg'"/></a></li><br>               
</ul>
</div>

<p>
<p>
<div style="height: 150px;"></div>
	<strong><font size="4px"><u><i>&#9830;Design Community</i></u></font></strong>
<div style="height: 250px;padding-top: 100px;position: bottom" id ="list">
	<p>
	<a href ="/kostaWebS/list.do" ><font color="#000000"><b>We are Designer</b></font></a>
	<a href ="/kostaWebS/list.do" ><img alt="게시판" src="/kostaWebS/images/decoration/boardLogo2.jpg" border="0" width="150px" align="bottom"> </a> 
	<a href ="/kostaWebS/list.do" ><font color="#00005D"><b>Make</b></font></a>	
	<a href ="/kostaWebS/list.do" ><font color ="#660033"><b>YourShoes</b></font></a>
	<a href ="/kostaWebS/list.do" ><font color ="#000000"><b>Community</b></font></a>
	<a href ="/kostaWebS/list.do" ><img alt="게시판" src="/kostaWebS/images/decoration/boardLogo3.jpg" border="0" width="150px" align="bottom"> </a>
	<a href ="/kostaWebS/list.do" ><font color ="#FF0000"><b>DesignBoard</b></font></a>
</div>


	
	
</body>