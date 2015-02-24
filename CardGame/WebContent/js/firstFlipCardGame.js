
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
			       			num1 = Math.floor(Math.random()*71)+20; //다양한 연산식을 만들기 위함. 20 ~ 90
			       		}
			       		else if(result>=50 && result <100)
			       		{
			       			num1   = Math.floor(Math.random()*41)+5; // 5 ~ 45
			       		}
			       		else
			       		{
			       			num1   = Math.floor((Math.random()*(result-1)))+1; // 결과값 (result)보다 작은값 중에서 피연산자를 랜덤으로 생성한다.
			       		}
			        	
			    		var num2   = result - num1;
			        	var operation = new Operation(num1,num2,operator);
			        	
			        	$.data(this,'expression',operation.toString()+"="+result);
//			        	$.data(this,'expression',operation.toString());
			        	$.data(this,'result',result);
			        	$(this).attr('answer',false);
						break;
				
			        	
			        case '-':
			        	
			        	var rnum = 0;
			        	if(level == 'beginner') rnum = 9;
						else if(level == 'advance')  rnum = 50;
			        	
			        	var num1   = Math.floor((Math.random()*rnum))+1; // 결과값 (result)보다 큰 값 중에서 피연산자를 랜덤으로 생성한다.
			        	var num2   = Number(result) + Number(num1);
			        
			        	var operation = new Operation(num2,num1,operator);
			        	
			       // 	$.data(this,'expression',operation.toString()+"="+result);
			        	$.data(this,'expression',operation.toString()+"="+result);
			        	$.data(this,'result',result);
			        	$(this).attr('answer',false);
						break;
						
			        case '*':
			        	var	num1 =0;
			        	do{
				        	if(level == 'beginner')
				        	{
				        		if(result>=45) // 다양한 연산식을 만들기 위한 코드 이다. 결과값이 50이 넘으면 피연산자는 5 이상으로 연산을 만든다.
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
				        		if(result>=1000 && result < 2000)  // 다양한 연산식을 만들기 위한 코드 이다. 결과값이 100이 넘으면 피연산자는 10 이상으로 연산을 만든다.
				        		{
				        			num1   = Math.floor((Math.random()*90))+2; // 1 ~ 30
				        		}
				        		else if(result >2000)
				        		{
				        			num1   = Math.floor((Math.random()*90))+4; // 1 ~ 30
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
			        	$.data(this,'expression',operation.toString()+"="+result);
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

			if(operator=='*') 
			{
				// 怨깊븯湲곕뒗 (1~9 * 1~9) 媛��뒫 �뿰�궛媛� �뱾�쓣 援ы븯湲� �쐞�빐 �떎瑜� 諛⑹떇�쑝濡� 寃곌낵媛믪쓣 �깮�꽦�븯���떎. 
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
						num1   = Math.floor(Math.random()*9)+1;
						num2   = Math.floor(Math.random()*9)+1;
						
//						num1   = Math.floor(Math.random()*(rnum-10))+10;
//						num2   = Math.floor(Math.random()*(rnum-10))+10;
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
				if(level == 'beginner'){ maxNum = 20; minNum = 5;}
				
				if(level == 'advance')  {maxNum = 190; minNum = 50;}
				
				for (var j = minNum; j <= maxNum; j++) {
					array.push(j);
				}
			}
			 
			$firstGame.shuffleNumber(array);

			array = array.slice(0,10); //섞은 다음 그중 10개만 추출한다.
			
			
			array_result = array.concat(array); // 2개씩 결과값 짝을 만들기 위해 똑같은 배열 2개를 하나로 붙인다.
			
			array_result = $firstGame.shuffleNumber(array_result); // 배열에 저장되어 있는 결과값을 섞는다.
			
			return array_result;
			
			
		},
		randomItem: function(a){
			var index = Math.floor(Math.random()*a.length);
			var array = a.splice(index,1); //諛곗뿴�쓽 �슂�냼瑜� 諛섑솚 �썑 �젣嫄고븳�떎.
			
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
					
					$(compare_result[0]).find('.back').css({'background':'#E86520'});
					$(compare_result[1]).find('.back').css({'background':'#E86520'});
					
					// animation effect end
				//	$("div[answer=true]").unbind("click");
					
				}
				else
				{
					setTimeout(function(){
						
					$(compare_result[0]).attr('action','hide').removeClass('flipped');
					$(compare_result[1]).attr('action','hide').removeClass('flipped');
			
						
					},'800');
					    
					
							
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
				return true;			
			}
			return false;
		},
		
		caculate_elapsedTime: function(){ // 寃뚯엫 寃쎄낵 �떆媛꾩쓣 怨꾩궛�븯�뒗 �븿�닔 closer瑜� �솢�슜�뻽�떎.
			
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