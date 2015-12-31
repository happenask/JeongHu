
/*****  js calendar ********************/
/***** 검색기간 시작일에 따라 종료일 세팅 *****/
	function fnCalendar(){
		//시작일
		$('input[name="sDate"]').datepicker({
			changeMonth:true,
			chanegeYear:true,
			showButtonPanel:true,
			showMonthAfterYear:true,
			
			dateFormat:"yy-mm-dd",
			numberOfMonth:3,	//출력되는 달력 범위
			onClose : function (selectedDate){		//종료일 달력 설정(시작일보다 뒤로)
				$('input[name="eDate"]').datepicker('option', 'minDate', selectedDate);
			} 
		}).click(function() {
		    $('button.ui-datepicker-current').removeClass('ui-priority-secondary').addClass('ui-priority-primary');
		   	$('button.ui-datepicker-current').click(function() {
			   // alert("오늘 버튼 클릭");
			    $.datepicker._curInst.input.datepicker('setDate', new Date()).datepicker('hide').blur();
			});
		});
		
		//종료일
		$('input[name="eDate"]').datepicker({
			changeMonth:true,
			chanegeYear:true,
			showButtonPanel:true,
			dateFormat:"yy-mm-dd",
			numberOfMonth:3,	//출력되는 달력 범위
			onClose : function (selectedDate){		//시작일 달력 설정
				$('input[name="sDate"]').datepicker('option', 'maxDate', selectedDate);
			} 
		}).click(function() {
		    $('button.ui-datepicker-current').removeClass('ui-priority-secondary').addClass('ui-priority-primary');
		   	$('button.ui-datepicker-current').click(function() {
			   // alert("오늘 버튼 클릭");
			    $.datepicker._curInst.input.datepicker('setDate', new Date()).datepicker('hide').blur();
			});
		});	
		
		//-------------------------------------------------------------------------------------------------------
		//  admin-writing, admin-writing-modify 의 게시기간 수정
		//-------------------------------------------------------------------------------------------------------
		
		//시작일 (신규 글, 수정시 게시 기간 입력) 
		$('input[name="bsDate"]').datepicker({
			changeMonth:true,
			chanegeYear:true,
			showButtonPanel:true,
			showMonthAfterYear:true,
			
			dateFormat:"yy-mm-dd",
			numberOfMonth:3,	//출력되는 달력 범위
			onClose : function (selectedDate){		//종료일 달력 설정(시작일보다 뒤로)
				$('input[name="beDate"]').datepicker('option', 'minDate', selectedDate);
			} 
		}).click(function() {
		    $('button.ui-datepicker-current').removeClass('ui-priority-secondary').addClass('ui-priority-primary');
		   	$('button.ui-datepicker-current').click(function() {
			   // alert("오늘 버튼 클릭");
		   		alert(selectedDate);
			    $.datepicker._curInst.input.datepicker('setDate', new Date()).datepicker('hide').blur();
			});
		});
		
		
		//종료일 (신규 글, 수정시 게시 기간 입력)
		$('input[name="beDate"]').datepicker({
			changeMonth:true,
			chanegeYear:true,
			showButtonPanel:true,
			dateFormat:"yy-mm-dd",
			numberOfMonth:3,	//출력되는 달력 범위
			onClose : function (selectedDate){		//시작일 달력 설정
				$('input[name="bsDate"]').datepicker('option', 'maxDate', selectedDate);
			} 
		}).click(function() {
		    $('button.ui-datepicker-current').removeClass('ui-priority-secondary').addClass('ui-priority-primary');
		   	$('button.ui-datepicker-current').click(function() {
			   // alert("오늘 버튼 클릭");
			    $.datepicker._curInst.input.datepicker('setDate', new Date()).datepicker('hide').blur();
			});
		});	
		
		
	}