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
			
			var DEFAULT_ARRAY = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
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
			    o_array[i] = o_array[i]- (Math.floor(Math.random()*3)); //0~2 占쎌삏占쎈쑁 占쎈떭占쎌쁽
			    
			}
			
			for(var j in OPERATOR_ARRAY)
			{
			    o_array2[o_array[j]] = OPERATOR_ARRAY[j];  // 占쎈염占쎄텦占쎌쁽�몴占� �솒�눘占� 獄쏄퀣肉� 占쎈뱟占쎌젟 占쎌뵥占쎈쑔占쎈뮞占쎈퓠 筌욎떝堉깍옙苑뷂옙�뮉占쎈뼄.
			}
			


	//		var n_array2 = DEFAULT_ARRAY.concat(OPERATOR_ARRAY);
			var sh1   = $secondGame.shuffleNumber(DEFAULT_ARRAY);

			for(var b = 0;b<o_array2.length;b++)
			{
				
				if(o_array2[b]==='' || o_array2[b]===undefined) // 獄쏄퀣肉댐옙釉욑옙肉� 揶쏅�れ뵠 占쎈씨占쎌몵筌롳옙 筌욑옙疫뀐옙 獄쏄퀣肉� 占쎌굨占쎄묶占쎈뮉 => ['','*','','','-'] 占쎌뵠占쎌쑕 占쎌굨占쎄묶占쎈뼄.
				{											    // * 筌〓㈇�ф에占� 占쎌뵠占쎌쑕 獄쎻뫖苡울옙�뱽 占쎈쾺占쎈뮉椰꾬옙 row 筌띾뜄�뼄 占쎈릭占쎄돌占쎌벥 占쎈염占쎄텦占쎌쁽�몴占� 占쎈７占쎈맙占쎈릭疫뀐옙 占쎌맄占쎈맙占쎌뵠占쎈뼄.
					o_array2[b] = sh1[0];
					
					sh1.splice(0,1);  // 獄쏄퀣肉댐옙占� 筌〓챷�� 癰귨옙占쎈땾 占쎌뵠疫뀐옙 占쎈르�눧紐꾨퓠 sh1 占쎈즲 DEFAULT_ARRAY 占쎌벥 筌롫뗀�걟�뵳�딉폒占쎈꺖�몴占� 揶쏅쉰�� 占쎌뿳占쎈뼄. 域밸챶�삋占쎄퐣 splice 占쎈릭筌롳옙 DEFAULT_ARRAY獄쏄퀣肉댐옙猷� 占쎌겫占쎈샨占쎌뱽 獄쏆룆�뮉占쎈뼄.
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
				DEFAULT_ARRAY = [1,2,3,4,5,6,7,8,9,10,0];
				shf_array 	  = $secondGame.shuffleNumber(DEFAULT_ARRAY);
			}


			for ( var i = 0; i < r_number; i++)
			{
				var result;


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

				case '×':
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

				case '÷':
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

					case '×':
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

					case '÷':
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
		    	 
		     },300);
		     
		     if ($('.card_result').length === 0) {
		    	 
		    	 $('.result_list').hide();
		    	 $('.countdown').show();
		    	 
		    	 $('.countdown').html("<h1>COMPLETE</h1>").css({'font-size':'25px','color':'yellow'});
		    	 
	 				var endDate = new Date();
	 				secondGame_elapsedTime = time(endDate);

	  				navigator.notification.vibrate(800);
	  				navigator.notification.confirm(
	  						"YOU TAKE " + (secondGame_elapsedTime)+" sec \n TO COMPLETE GAME", // message
	  						secondGameAlertCallback, //callback
  						"Game Over", // title
  						['Check your Rank','Quit']  // buttonName
						);
	 				
	  				
	  				
	  				$(".flip2 .card").attr("action","show").addClass('flipped');
	 			}
		     else{
		    	 
		    	 $('.flip2 div[action=show]').attr('action','hide').removeClass('flipped');
		     }
			});
			
		},
		
		
		fnWrongResult: function(){
			
			setTimeout(function(){
				navigator.notification.vibrate(300);
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
		
		caculate_elapsedTime: function(){ // �뇦猿딆뒩占쎈엮 �뇦猿뗫윞占쎄땁 �뜝�럥六삥뤆�룄�뫒占쎈굵 占썩몿�뫒亦낆룊�삕�뇡占썲뜝�럥裕� �뜝�럥留쇿뜝�럥�빢 closer占쎈ご�뜝占� �뜝�럩�꽎�뜝�럩�뮔�뜝�럥六ε뜝�럥堉�.
			
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