function back(){
	
	document.navbar.url.value = "";
	
	
	try{
		
		parent.main.history.back();
	}catch(e){
		alert("block history.forward()");
	}
	
	
}

function forward(){
	document.navbar.url.value = "";
	try{
		parent.main.histroty.forward();
	}catch(e){
		alert("에러다");
	}
	setTimeout(updateURL, 1000);
}

function updateURL() {
	try{
		document.navbar.url.value = parent.main.location.href; 
	}catch(e)
	{
		document.navbar.url.value = "policy restrict url.";
	}
}

function fixup(url){
	if(url.substring(0,7) != "http://") url = "http://" +url;
	
	return url;
}
function go(){
	alert(fixup(document.navbar.url.value));
	alert(parent.main.location);
	parent.main.location = document.navbar.url.value;
}

function displayInNewWindow(){
	window.open(fixup(document.navbar.url.value));
}


