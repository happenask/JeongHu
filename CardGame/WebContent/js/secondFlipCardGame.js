var $secondGame  = {
		
		
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
		
		make_number: function(level){
			
			var DEFAULT_ARRAY  = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];

			var o_array = [2,5,8,11,14];

			var o_array2 = new Array(18);

			if(level == 'beginner')
			{
				DEFAULT_ARRAY = [1,2,3,4,5,6,7,8,9,10];
				o_array       = [2,5,8,11]; 
				o_array2      = new Array(12);
			}
			
			
			
			o_array = $secondGame.shuffleNumber(o_array);
			
			for(var i in o_array)
			{
			    o_array[i] = o_array[i]- (Math.floor(Math.random()*3));
			    
			}
			
			for(var j in OPERATOR_ARRAY)
			{
			    o_array2[o_array[j]] = OPERATOR_ARRAY[j];  // 연산자를 먼저 배열 특정 인덱스에 짚어넣는다.
			}
			


	//		var n_array2 = DEFAULT_ARRAY.concat(OPERATOR_ARRAY);
			var sh1   = $secondGame.shuffleNumber(DEFAULT_ARRAY);

			for(var b = 0;b<o_array2.length;b++)
			{
				
				if(o_array2[b]==='' || o_array2[b]===undefined) // 배열안에 값이 없으면 지금 배열 형태는 => ['','*','','','-'] 이런 형태다.
				{											    // * 참고로 이런 방법을 쓰는건 row 마다 하나의 연산자를 포함하기 위함이다.
					o_array2[b] = sh1[0];
					
					sh1.splice(0,1);  // 배열은 참조 변수 이기 때문에 sh1 도 DEFAULT_ARRAY 의 메모리주소를 갖고 있다. 그래서 splice 하면 DEFAULT_ARRAY배열도 영향을 받는다.
				}
			}
			
			
			
			return o_array2;
			
		},
		
		
		make_result: function(r_number,level){
			
			var DEFAULT_ARRAY = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
			var result_array = [];
			var shf_array = $secondGame.shuffleNumber(DEFAULT_ARRAY.slice(0,12));
			
			if(level == 'beginner')
			{
				DEFAULT_ARRAY = [1,2,3,4,5,6,7,8,9,10];
				shf_array 	  = $secondGame.shuffleNumber(DEFAULT_ARRAY.slice(0,8));
			}
			
//	 		var aaa =""
//	 		for(var a in shf_array)
//	 		{
//	 			aaa+=shf_array[a]+' ';
//	 		}
//	 		alert(aaa);

			for ( var i = 0; i < r_number; i++)
			{
				var result;

			//	var num = Math.floor(Math.random() * (shf_array.length - 1));

				var fnum = Number(shf_array[i]);
				var lnum = Number(shf_array[i + 1]);
				
				
				var num2 = Math.floor(Math.random() * OPERATOR_ARRAY.length);

				var oper = OPERATOR_ARRAY[num2];


				switch (oper)
				{
				case '+':
					result = Number(fnum) + Number(lnum);
			//		alert(fnum + '+' + lnum + '=' + result);
					break;
				case '-':
					if(Number(fnum) < Number(lnum))
					{
						var tnum = fnum;
						fnum = lnum;
						lnum = tnum;
					}
					result = Number(fnum) - Number(lnum);
			//		alert(fnum + '-' + lnum + '=' + result);
					break;

				case '*':
					if((Number(fnum)>10)||(Number(lnum)>10))
					{
						result = Number(fnum) + Number(lnum);
					}
					else
					{
						result = Number(fnum) * Number(lnum);
					}
			//		alert(fnum + '*' + lnum + '=' + result);
					break;

				case '/':
					result = Math.floor(Number(fnum) / Number(lnum));
					result = (result==0)? (fnum+lnum):result;
			//		alert(fnum + '/' + lnum + '=' + result);
					break;
				}

				result_array.push(result);
			}
			return result_array;
			
			
		},
		
		
		compare_result: function(array,time){
			
			var first_num;
			var middle_operator;
			var second_num;
			var result;
			
			var compare_result = array;


				first_num        =  compare_result[0];
				middle_operator  =  compare_result[1];
				second_num       =  compare_result[2];

				chk_first_num	     =  isNaN(first_num)? false:true;
				chk_middle_operator	 =  isNaN(middle_operator)? true:false;
				chk_second_num	     =  isNaN(second_num)? false:true;
				
//				alert(first_num+':'+chk_first_num+' '+middle_operator+':'+chk_middle_operator+' '+second_num+':'+chk_second_num);
				if(chk_first_num && chk_middle_operator && chk_second_num)
				{
					switch (middle_operator)
					{
					case '+':
						result = Number(first_num) + Number(second_num);
						
							if(Number($('.card_result:first').text())==Number(result))
							{
								$secondGame.fnAfterCheckResult(time);
							}
							else
							{
								$secondGame.fnWrongResult();
							}
								
						break;
					case '-':
						result = Number(first_num) - Number(second_num);
						
							if(Number($('.card_result:first').text())==Number(result))
							{
								$secondGame.fnAfterCheckResult(time);
							}
							else
							{
								$secondGame.fnWrongResult();
							}
								
						break;

					case '*':
						result = Number(first_num) * Number(second_num);
						
							if(Number($('.card_result:first').text())==Number(result))
							{
								$secondGame.fnAfterCheckResult(time);
							}
							else
							{
								$secondGame.fnWrongResult();
							}
								
						break;

					case '/':
						result = Number(first_num) / Number(second_num);
						
							if(Number($('.card_result:first').text())==Number(result))
							{
								$secondGame.fnAfterCheckResult(time);
							}
							else
							{
								$secondGame.fnWrongResult();
							}
								
						break;
					}

				}
					
					
				else
				{
					$secondGame.fnWrongResult();
				}
			
		},		
		
		fnAfterCheckResult: function(time){
			
			$('.overlay').show();
			$('.card_result:first').fadeOut('slow', function() {
			    // Animation complete.

		     $('.card_result:first').remove();
		     $('.card_result:eq(0)').show();
		     $('.card_result:eq(1)').show();
		     
		     setTimeout(function(){
		    	 
			     $('.overlay').hide();
		    	 
		     },500);
		     
		     if ($('.card_result').length === 0) {
		    	 
		    	 $('.result_list').hide();
		    	 $('.countdown').show();
		    	 
		    	 $('.countdown').html("<h1>COMPLETE</h1>").css({'font-size':'25px','color':'yellow'});
		    	 
	 				var endDate = new Date();
	 				secondGame_elapsedTime = time(endDate);

//	  				navigator.notification.vibrate(800);
//	  				navigator.notification.alert(
	//  						"경과시간:" + (secondGame_elapsedTime-5), // message
//	  						secondGameAlertCallback, //callback
	//  						"Game Over", // title
	 // 						"Done" // buttonName
	  //						);
	 				alert("경과시간:" + secondGame_elapsedTime);
	 				
	 			}
		     
		     $('.flip2 div[action=show]').attr('action','hide').removeClass('flipped');
			});
			
		},
		
		
		fnWrongResult: function(){
			
			setTimeout(function(){
//				navigator.notification.vibrate(300);
				$('.flip2 div[action=show]').removeClass('flipped');
				$('.flip2 div[action=show]').attr('action','hide');
				
			},500);
			
		},
		
		endGameCheck : function(){
			
			var length = $('.card_result').length;
			if(length==0)
			{
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
				
				myMedia = new Media("/android_asset/www/flip_sound.mp3");
				myMedia.play();
				
	 			setTimeout(function(){
					myMedia.stop();
	 				myMedia.release();
	 			},350);
 			}
		}
		
		
};