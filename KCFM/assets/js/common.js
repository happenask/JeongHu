// 공백제거
function trim(s) 
{
	s += ''; // 숫자라도 문자열로 변환
	return s.replace(/^\s*|\s*$/g, '');
}

// 숫자만 입력받게 하는 함수
function onlynumber(){
	if (event.keyCode >= 48 && event.keyCode <= 57) 	return true;
	if (event.keyCode >= 96 && event.keyCode <= 105)	return true;
	if (event.keyCode == 8 || event.keyCode == 46)		return true; // back-space key, delete key

	event.returnValue = false;
}

// 콤마찍는 함수
function setComma(data){
	return (!data||data==Infinity||data=='NaN')?0:String(data).replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,'); 
}

// 콤마제거하는 함수
function getNumber(data){
	return parseInt(data.replace(/[^0-9]/g,""),10) || 0;
}

// 엑셀저장
function saveExcel(gbn, targetId, outSrc, saveFileName){
    if(document.all){
    	 
        if(!document.all.excelExportFrame){// 프레임이 없으면 프레임 생성
            var excelFrame=document.createElement("iframe"); 
            excelFrame.id="excelExportFrame";
            excelFrame.position="absolute"; 
            excelFrame.style.zIndex=-1; 
            excelFrame.style.top="-10px"; 
            excelFrame.style.left="-10px"; 
            excelFrame.style.height="0px"; 
            excelFrame.style.width="0px"; 
            document.body.appendChild(excelFrame);
        }
        
        var frmTarget = document.all.excelExportFrame.contentWindow.document; // 해당 아이프레임의 문서에 접근

        frmTarget.write('<html>');
        frmTarget.write('<meta http-equiv=\"Content-Type\" content=\"application/vnd.ms-excel; charset=UTF-8\">\r\n');
        frmTarget.write('<body>');
        
        if(gbn == "id")		frmTarget.write(document.getElementById(targetId).outerHTML);
        else 				frmTarget.write(outSrc);
        
        frmTarget.write('</body>');
        frmTarget.write('</html>');
        frmTarget.close();      

        frmTarget.charset="UTF-8";
        frmTarget.focus();

        if(!saveFileName){
            saveFileName='excel_down.xls';
        }
        
        frmTarget.execCommand('SaveAs','false',saveFileName);
    } else {
        alert('IE만 가능합니다.');
    }
}

function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > milliseconds) {
            break;
        }
    }
}
