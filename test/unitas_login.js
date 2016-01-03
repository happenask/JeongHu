
			$(document).ready(function() {
			
				
				
				$("#login").click(function(){
					
					if($("#user_id").val()=="" || $("#user_pass").val()=="") 
					{
						alert("아이디와비밀번호를 입력하세요.");
						return false;						
					}
	
					if($("#user_id").val()=="unifos" && $("#user_pass").val() =="unitas027867838")
					{
						location.replace("unitas_site_link_page.html");
					}
					else
					{
						alert("아이디와비밀번호를 확인 후 재시도 하세요.");
						$("#user_id"  ).val("");
						$("#user_pass").val("");
						$("#user_id"  ).focus();
					}
					
				});
				
				$(":input").keypress(function(event){
				            if(event.keyCode == 13)
				            {
				                $("#login").trigger('click');
				            }
				});
			});
