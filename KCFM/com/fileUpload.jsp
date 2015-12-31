<%
/** ############################################################### */
/** Program ID   : fileUpload.jsp				                    */
/** Program Name : 첨부파일 업로드시 체크						    */
/** Program Desc : 파일첨부시 사이즈체크          				    */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.util.BoardConstant" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

 
<%

	// 파일 업로드된 경로
	//BoardConstant bCont = new BoardConstant();

 // String savePath = "D:/PACKAGE_WORKSPACE/workspace(pos)_2015/KCFM/filestorage";
 	String savePath = "";
 	int    imaxSize = 0 ;
 
	String savePath1 = BoardConstant.FILEPATH ;
    int    imaxSize1 = BoardConstant.FILESIZE ;		//5MB
  	
	String savePath2 = BoardConstant.PROMPATH ;
    int    imaxSize2 = BoardConstant.PROMSIZE ;		//5MB
    
%>

<script type="text/javascript">

	//첨부화일 사이즈 체크
	//   gubn(1:첨부화일, 2:홍보물이미지)
	function checkFileSize(obj, gubn){
		
		var maxSize ;
		var filePath ;
		
		if ( gubn == 1) {
			filePath = "<%=savePath1%>" ;		
			maxSize  =  <%=imaxSize1%>  ;		
		} else {
			filePath = "<%=savePath2%>" ;		
			maxSize  =  <%=imaxSize2%>  ;		
		}
		
		//filePath = "D:/PACKAGE_WORKSPACE/workspace(pos)_2015/KCFM/WebContent/filestorage/prom";
			
		//IE 7 이상인경우 확장자 제한
		if(typeof document.body.style.maxHeight != "undefined"){
	
			if(/(\.exe)$/i.test(obj.value)) 
		 	{
		       alert("지원하지 않는 파일확장자입니다.");
		       fileValueReset(obj.name);	

		       return false;
		    }
			
			
		}else{ //IE 6 이하인 경우
	
			var img = new Image();
	
		    img.dynsrc = obj.value;
		    
		    var fileSize = img.fileSize;
		}	
		

		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var f = fso.GetFile(obj.value);
		var fileSize = f.size;
		var fileName = fso.GetFileName(obj.value);
		
		var fileFullName = filePath + "/" + fileName;
		
		//파일이 있는지 검사
		if (fso.FileExists(fileFullName)) {
			alert('동일한 이름의 파일이 존재합니다.\n 다른 이름으로 첨부하세요.');			
	        fileValueReset(obj.name);	

	        return false;
		}
		
		f=null;
		fso=null;
		
		if(maxSize < fileSize){
		       alert("첨부파일의 용량은 5MB로 제한됩니다.");
		       fileValueReset(obj.name);	
	
		       return false;
	    }else{
	     return true;
	    }
	
		    
	}	
	
	//첨부화일 파일 reset
	function fileValueReset(oName){
		
		var fileDiv1 = document.getElementById("fileDiv1");
		var fileDiv2 = document.getElementById("fileDiv2");
		var fileDiv3 = document.getElementById("fileDiv3");
	
		var vGubn = oName.substr(oName.length-1,1);		//구분값
	
		if (vGubn == "1") {
			fileDiv1.innerHTML = "<input type=\"file\" id=\"attachFile1\" name=\"attachFile1\" onchange=\"checkFileSize(this);\"/>&nbsp;\n"+
									"<button  type=\"button\" class=\"deleteBtn\" id=\"deleteBtn\" name=\"deleteBtn\" onclick=\"fnDeleteFile('s첨부파일1');\"></button>";
		} else if(vGubn == "2") {
			fileDiv2.innerHTML = "<input type=\"file\" id=\"attachFile2\" name=\"attachFile2\" onchange=\"checkFileSize(this);\"/>&nbsp;\n"+
									"<button  type=\"button\" class=\"deleteBtn\" id=\"deleteBtn\" name=\"deleteBtn\" onclick=\"fnDeleteFile('s첨부파일2');\"></button>";
		} else {
			fileDiv3.innerHTML = "<input type=\"file\" id=\"attachFile3\" name=\"attachFile3\" onchange=\"checkFileSize(this);\"/>&nbsp;\n"+
									"<button  type=\"button\" class=\"deleteBtn\" id=\"deleteBtn\" name=\"deleteBtn\" onclick=\"fnDeleteFile('s첨부파일3');\"></button>";
		}
		
	
	
	}

</script>
