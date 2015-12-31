<%
/** ############################################################### */
/** Program ID   : fileDown.jsp					                    */
/** Program Name : 첨부파일 다운로드							    */
/** Program Desc : 파일다운로드 작업          				    	*/
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.util.JSPUtil"%>
<%@ page import="com.util.BoardConstant" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="java.io.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

 
<%
 
	// 파일 업로드된 경로
	BoardConstant bCont = new BoardConstant();
    String savePath = "" ;
    
    String fname = "";
    String gubn  = "";
    
    if(!"".equals(JSPUtil.chkNull(request.getParameter("fname"), ""))  ){
    	fname = URLDecoder.decode(request.getParameter("fname"),"UTF-8");
    }

    if(!"".equals(JSPUtil.chkNull(request.getParameter("gubn"), ""))  ){
    	gubn = JSPUtil.chkNull(request.getParameter("gubn"), "1") ;
    }    
    
    System.out.println("gubn = " + gubn);
    
    
    // 1:첨부화일, 2:전단지몰 이미지
    if ("1".equals(gubn)) {
    	savePath = bCont.FILEPATH ;
    	//savePath = "D:/PACKAGE_WORKSPACE/workspace(pos)_2015/KCFM/filestorage";
    } else {
    	savePath = bCont.PROMPATH ;
    }

    //savePath = "D:/PACKAGE_WORKSPACE/workspace(pos)_2015/KCFM/WebContent/filestorage/prom";
    System.out.println("savePath = " + savePath);
    System.out.println("fname = " + fname);

    // 서버에 실제 저장된 파일명
    String filename = fname ;
    
    // 실제 내보낼 파일명
    String orgfilename = filename ;

    InputStream in = null;
    OutputStream os = null;
    File file = null;
    boolean skip = false;
    String client = "";
 
 
    try{
         
 
        // 파일을 읽어 스트림에 담기
        try{
            file = new File(savePath, filename);
            in = new FileInputStream(file);
        }catch(FileNotFoundException fe){
            skip = true;
        }
 
 
        client = request.getHeader("User-Agent");
        
 
        // 파일 다운로드 헤더 지정
        response.reset() ;
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Description", "JSP Generated Data");
 
 
        if(!skip){
 
             
            // IE
            if( (client.indexOf("MSIE") != -1)  || (client.indexOf("Windows") != -1)){
                response.setHeader ("Content-Disposition", "attachment; filename="+new String(orgfilename.getBytes("KSC5601"),"ISO8859_1"));
                
            }else{
                // 한글 파일명 처리
                orgfilename = new String(orgfilename.getBytes("utf-8"),"iso-8859-1");
 
                response.setHeader("Content-Disposition", "attachment; filename=\"" + orgfilename + "\"");
                response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
            }  
             
            response.setHeader ("Content-Length", ""+file.length() );
 
            out.clear(); 

            out=pageContext.pushBody();

            os = response.getOutputStream();
            byte b[] = new byte[(int)file.length()];
            int leng = 0;
             
            while( (leng = in.read(b)) > 0 ){
                os.write(b,0,leng);
            }
 
        }else{
            response.setContentType("text/html;charset=UTF-8");
            out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
 
        }
         
        in.close();
        os.close();
 
    }catch(Exception e){
      e.printStackTrace();
    }
%>
