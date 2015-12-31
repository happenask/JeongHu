
//동적 스타일 적용 관련 공통 스크립트

	//html 파라미터 전달
	getParameter = function(name){
		search=location.search;
		if(!search){
    		//파라미터가 하나도 없을때
    		//alert("에러 출력 텍스트");
  			return "empty";
  		}
  		search=search.split("?");
  		data=search[1].split("=");
   		if(search[1].indexOf(name)==(-1) || data[0]!=name){
    		//해당하는 파라미터가 없을때.
    		return "";
    		return;
    	}
    
   		if(search[1].indexOf("&")==(-1)){
		    //한개의 파라미터일때.
		    data=search[1].split("=");
		    return data[1];
    	}else{
		    //여러개의 파라미터 일때.
		    data=search[1].split("&");  //엠퍼센트로 자름.
		     
		    for(i=0;i<=data.length-1;i++){
       			l_data=data[i].split("=");
        		if(l_data[0]==name){
        			return l_data[1];
        			break;
        		}else continue;
      		}
    	}
    }
	
	//정보변경 패널 show/hide
	function fnShowPanel(){
		var browserHeight = document.body.scrollHeight;
		var browserWidth = document.documentElement.offsetWidth;
		var contentHeight = browserHeight - 140;
		var browserHalfWidth = browserWidth/2;
		
		var panelPosition = browserHalfWidth + 162;
		
		//console.log(browserHalfWidth , " /2 -212 " , panelPosition)
		$(".overlay-bg-half").height(contentHeight);
		//$(".overlay-bg-half").height(browserHeight);
		
		if($("#info-panel").css("display") == "none"){
    		$(".overlay-bg-half").fadeIn("fast");
		    $("#mody-btn").css("color","#a1253c");
		}else{
    		$(".overlay-bg-half").fadeOut("slow");
		    $("#mody-btn").css("color","#2d3f52");
		}
		//.slideToggle( [duration ] [, complete ] )
		$("#info-panel").css("right", panelPosition+"px");
		$("#info-panel").slideToggle( "slow");
	}	
	
	//관리자 정보변경 패널 show/hide
	function fnShowPaneladmin(){
		var browserHeight = document.body.scrollHeight;
		var browserWidth = document.documentElement.offsetWidth;
		var contentHeight = browserHeight-100;
		var browserHalfWidth = browserWidth/2;
		
		var panelPosition = browserHalfWidth + 170;
		var adminHeader = 100;
		
		$(".overlay-bg-half").height(contentHeight);
		$(".overlay-bg-half").css("top",adminHeader+"px");
		
		if($("#info-panel").css("display") == "none"){
    		$(".overlay-bg-half").fadeIn("fast");
		    $("#mody-btn").css("color","#a1253c");
		}else{
    		$(".overlay-bg-half").fadeOut("slow");
		    $("#mody-btn").css("color","#2d3f52");
		} 
		$("#info-panel").css("left", panelPosition+"px");
		$("#info-panel").css("top", adminHeader+"px");
		$("#info-panel").slideToggle( "slow");
	}	
	
	//로딩이미지 
	//정보변경 패널 show/hide
	function fnShowLoading(){
		var browserHeight = document.body.scrollHeight;
		var browserWidth = document.documentElement.offsetWidth;
		
		$(".overlay-bg").height(browserHeight);
		$("#loadingImage").css("left",browserWidth/2 - 20);//image size = 40*40
		$(".overlay-bg").show();
		$("#loadingImage").show();
	}	

	//탭 버튼 active 스타일 적용
	function fnResetTab($this){
		//alert($this.parent().attr("id"));
		$this.parent().parent().find("li").each(function(){
			$(this).removeClass("on");
		});
		$this.parent().addClass("on");
		var pageId = $this.parent().attr("id")+"-cont";
		if($this.parent().hasClass("transactional") == false){
			$(".tab-pages").html("<div id='"+pageId+"'>" +  $this.parent().text() + " 화면입니다! </div>");
		}
	} 
	
	//거래내역 화면 & 탭 설정
	function fnResetTab2($this){
		var pageId = $this.parent().attr("id"); //tab-4
		//alert(pageId);
		
		$this.parent().parent().find("li").each(function(){
			$(this).removeClass("on");
		});
		$this.parent().addClass("on");
		
		//해당 데이터 영역 보이기
		$(".tab-pages").find(".table").each(function(){
			$(this).removeClass("show").addClass("hidden");
		});
		$(".tab-pages").find("#"+pageId+"-data").removeClass("hidden").addClass("show");
	} 
	
    function fnShowBill($this){

		var browserWidth = document.documentElement.offsetWidth;
		var browserHalfWidth = browserWidth/2;
		
		var panelPosition = browserHalfWidth - 440;
		
    	$("#bill-box").css("left",panelPosition);
    	$("#bill-box").show();
    }	

    //전단지 주문 상세, 전단지 관리 상세 화면 팝업 Show
    function fnShowDetail(){

		var browserHeight = document.documentElement.height;
		var browserWidth = document.documentElement.offsetWidth;
		
		$(".overlay-bg8").height(browserHeight);
		$(".dtl-pop").css("left",browserWidth/2 - 450);//image size = 40*40
		$(".overlay-bg8").show();
		$(".dtl-pop").show(); 
    }
    
    /***********************************************/
    /****************** 현재 날짜&시간 ******************/
    function getCurrent(){
		var today = new Date();
		var now = today.getFullYear() + '.' +  (today.getMonth() + 1)  + '.' +  today.getDate();
 		
		var dd = ["일","월","화","수","목","금","토"];
		var d = today.getDay();	//요일
		var h = today.getHours();
		var m = today.getMinutes();
		var s = today.getSeconds();
		
		m = toChar(m);
		s = toChar(s);
		
		$("#currentTime").html( now + '(' + dd[d] + ")  <span></span>");
		$("#currentTime span").text( '  ' + h + ":" + m + ":" + s );
		
		var t = setTimeout(function(){getCurrent()},1000);	//1초마다 refresh
	}
	//분,초 숫자가 1자리인 경우 앞에 "0"문자 추가  
	function toChar(i){
		if(i<10){i="0"+i;}
		return i;
	}
	
    
    
    