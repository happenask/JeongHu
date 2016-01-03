
var $firstGame = {
//		node_number:20,
		
		shuffleNumber: function(array){
			for (var i = 0; i < array.length - 1; i++)
		    {
		        var num;
		        var num2;
		        do
		        {
		            num  = Math.floor(Math.random() * array.length);
		            num2 = Math.floor(Math.random() * array.length);
		        } while (num === num2);
	
		        var temp = array[num];
		        array[num] = array[num2];
		        array[num2] = temp;
	
			    }
	
			    
			    return array;
				
		},
		
		make_number: function(result,operator,level){
				switch(operator)
			    {
			        case '+': 
			        	var num1;

			        	if(result>=100)
			       		{
			       			num1 = Math.floor(Math.random()*71)+20; //占쎈뼄占쎈펶占쎈립 占쎈염占쎄텦占쎈뻼占쎌뱽 筌띾슢諭얏묾占� 占쎌맄占쎈맙. 20 ~ 90
			       		}
			       		else
			       		{
			       			num1   = Math.floor((Math.random()*(result-1)))+1; // 野껉퀗�궢揶쏉옙 (result)癰귣��뼄 占쎌삂占쏙옙揶쏉옙 餓λ쵐肉됵옙苑� 占쎈돗占쎈염占쎄텦占쎌쁽�몴占� 占쎌삏占쎈쑁占쎌몵嚥∽옙 占쎄문占쎄쉐占쎈립占쎈뼄.
			       		}
			        	
			    		var num2   = result - num1;
			        	var operation = new Operation(num1,num2,operator);
			        	
//			        	$.data(this,'expression',operation.toString()+"="+result);
			        	$.data(this,'expression',operation.toString());
			        	$.data(this,'result',result);
			        	$(this).attr('answer',false);
						break;
				
			        	
			        case '-':
			        	
			        	var rnum = 0;
			        	if(level == 'beginner') rnum = 20 - result;
						else if(level == 'advance')  rnum = 100 - result;
			        	
			        	var num1   = Math.floor((Math.random()*rnum))+1; // 野껉퀗�궢揶쏉옙 (result)癰귣��뼄 占쎄쿃 揶쏉옙 餓λ쵐肉됵옙苑� 占쎈돗占쎈염占쎄텦占쎌쁽�몴占� 占쎌삏占쎈쑁占쎌몵嚥∽옙 占쎄문占쎄쉐占쎈립占쎈뼄.
			        	var num2   = Number(result) + Number(num1);
			        
			        	var operation = new Operation(num2,num1,operator);
			        	
			       // 	$.data(this,'expression',operation.toString()+"="+result);
			        	$.data(this,'expression',operation.toString());
			        	$.data(this,'result',result);
			        	$(this).attr('answer',false);
						break;
						
			        case '×':
			        	var	num1 =0;
			        	do{
				        	if(level == 'beginner')
				        	{
				        		if(result>=45) // 占쎈뼄占쎈펶占쎈립 占쎈염占쎄텦占쎈뻼占쎌뱽 筌띾슢諭얏묾占� 占쎌맄占쎈립 �굜遺얜굡 占쎌뵠占쎈뼄. 野껉퀗�궢揶쏅�れ뵠 50占쎌뵠 占쎄퐜占쎌몵筌롳옙 占쎈돗占쎈염占쎄텦占쎌쁽占쎈뮉 5 占쎌뵠占쎄맒占쎌몵嚥∽옙 占쎈염占쎄텦占쎌뱽 筌띾슢諭븝옙�뼄.
				        		{
				        			num1   = Math.floor((Math.random()*7))+3;
				        		}
				        		else if(result >=20 && result <45)
				        		{
				        			num1   = Math.floor((Math.random()*8))+2;
				        		}
				        		else if(result < 20)
				        		{
				        			num1   = Math.floor((Math.random()*9))+1;
				        		}
				        		
				        	}
				        	else if(level == 'advance')
				        	{
				        		if(result>=1000 && result < 2000)  // �떎�뼇�븳 �뿰�궛�떇�쓣 留뚮뱾湲� �쐞�븳 肄붾뱶 �씠�떎. 寃곌낵媛믪씠 100�씠 �꽆�쑝硫� �뵾�뿰�궛�옄�뒗 10 �씠�긽�쑝濡� �뿰�궛�쓣 留뚮뱺�떎.
				        		{
				        			num1   = Math.floor((Math.random()*90))+2; // 1 ~ 30
				        		}
				        		else if(result >2000)
				        		{
				        			num1   = Math.floor((Math.random()*90))+10; // 1 ~ 30
				        		}
				        		else if(result<1000)
				        		{
				        			num1   = Math.floor((Math.random()*90))+1; // 1 ~ 30
				        		}
				        		
				        	}
			        	}while((Number(result)%num1)!=0);
			        	var num2   = result/num1;
			        	
			        	var operation = new Operation(num1,num2,operator);
			        	
			        	result = num1 * num2;
			        	
			       // 	$.data(this,'expression',operation.toString()+"="+result);
			        	$.data(this,'expression',operation.toString());
			        	$.data(this,'result',result);
			        	$(this).attr('answer',false);
						break;
			    
			    }
			
			
		},
		
		make_result: function(node_number,operator,level){
			var maxNum = 0;
			var minNum = 0;
			
			var array = [];
			var array_result=[];

			if(operator=='×') 
			{
				for(var j=0;j<10;j++)
				{
					var num1 =0;
					var num2 =0;
					if(level == 'advance')
					{
						num1   = Math.floor((Math.random()*15))+10;
						num2   = Math.floor((Math.random()*15))+10;
						
						num1 = num1 *2; 
						num2 = num2 *2; 
					}
					else if(level == 'beginner')
					{
						var minor_num = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79];  //소수들
						do
						{
							num1   = Math.floor(Math.random()*9)+1;  
							num2   = Math.floor(Math.random()*9)+1;  
							
//						num1   = Math.floor(Math.random()*(rnum-10))+10;
//						num2   = Math.floor(Math.random()*(rnum-10))+10;
							
						}while($.inArray((num1*num2),minor_num)!=-1); //결과값이 소수가 되는 것을 피한다.
					}
					
					var result = num1*num2;
					
					array.push(result);
				}
				array_result = array.concat(array);
				return array_result;
			}
			
			if(operator=='-')
			{
				if(level == 'beginner'){maxNum = 10; minNum = 1;}
				
				if(level == 'advance') {maxNum = 50; minNum = 10;}
				
				for (var j = minNum; j <= maxNum; j++) {
					
					array.push(j);
				}
			}
			if(operator=='+')
			{
				if(level == 'beginner'){ maxNum = 20; minNum = 2;}
				
				if(level == 'advance')  {maxNum = 190; minNum = 100;}
				
				for (var j = minNum; j <= maxNum; j++) {
					array.push(j);
				}
			}
			 
			$firstGame.shuffleNumber(array);

			array = array.slice(0,10); //결과 값 중에 앞에서 10개 까지만 가져 온다.
			
			
			array_result = array.concat(array); // 생성한 결과값 10개를 붙여 20개로 만든다. 
			
			array_result = $firstGame.shuffleNumber(array_result);  
			
			return array_result;
			
			
		},
		randomItem: function(a){
			var index = Math.floor(Math.random()*a.length);
			var array = a.splice(index,1); //
			
			return array;
		},
		
		compare_result:function(){
			
			var first_result;
			var second_result;
			
			var compare_result = $(".flip div[action=show][answer=false]");
			
			if(compare_result.length==2)
			{
		
				first_result = $(compare_result[0]).data('result');
				second_result =$(compare_result[1]).data('result');
	
				if(Number(first_result) == Number(second_result))
				{
					$(compare_result[0]).attr('answer',true);
					$(compare_result[1]).attr('answer',true);
					
					// animation start
					
					$(compare_result[0]).find('.back').css({'background':'#E86520'}).html($(compare_result[0]).data("result"));
					$(compare_result[1]).find('.back').css({'background':'#E86520'}).html($(compare_result[1]).data("result"));
					
					// animation effect end
				//	$("div[answer=true]").unbind("click");
					
				}
				else
				{
					setTimeout(function(){
						
					$(compare_result[0]).attr('action','hide').removeClass('flipped');
					$(compare_result[1]).attr('action','hide').removeClass('flipped');
			
						
					},'770');
					    
					
							
				}
			}
			
		},
		
		endGameCheck : function(){
			
			var length = $('.flip .card').length;
			
			var compare_result = $(".flip div[action=show][answer=true]");
			
//			alert(compare_result.length);
			if(((length-1)==compare_result.length)&& length==$(".flip div[action=show]").length)
			{
				$('.flip .card:last').find('.back').css({'background':'#E86520'});
				$('.flip .card:last').attr('answer',true);
				return true;			
			}
			return false;
		},
		
		caculate_elapsedTime: function(){ // 
			
			var startTime = new Date();
			
		    return function (endTime) {
		
		        var elapsed = (endTime.getTime() - startTime.getTime()) / 1000;
		
		        elapsed    =  Math.round(elapsed * 100) / 100;
		        
		        return elapsed;
		
		    };
		},
		
		flipCardSoundEffect: function(option){
			var myMedia = null;
			if(option=='on')
			{
				myMedia = new Media("/android_asset/www/resource/flip_sound.mp3");
				myMedia.play();
				
	 			setTimeout(function(){
					myMedia.stop();
	 				myMedia.release();
	 			},350);
 			}
		}
		
};







function Operation(num1,num2,operator)
{
    this.num1 = num1;
    this.num2 = num2;
    this.operator = operator;
    
    this.toString = function(){
        var output = "";
        
        output = this.num1+this.operator+this.num2;
        return output;
    };
}