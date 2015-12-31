<%@page import="java.util.Enumeration"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
	request.setCharacterEncoding("UTF-8");
	String saveFolder = "D:/PACKAGE_WORKSPACE/workspace(pos)_2015/KCFM/filestorage";
	String encType = "EUC-KR";
	int maxSize = 5*1024*1024;//5MB
	try{
		MultipartRequest multi = 
				new MultipartRequest(request, saveFolder, 
					maxSize, encType,
					new DefaultFileRenamePolicy());
		Enumeration<String> params = multi.getParameterNames();
		while(params.hasMoreElements()){
			String name = params.nextElement();
			String value = multi.getParameter(name);
			out.print(name+"="+value+"<br/>");
		}
		//out.println("user:"+multi.getParameter("user")+"<br/>");
		//out.println("title:"+multi.getParameter("title")+"<br/>");
		/* if(multi.getFilesystemName("uploadFile")!=null){
			String name = multi.getFilesystemName("uploadFile");
			out.println("파일명:");
			out.println(name+"<br/>");
			File f = multi.getFile(name);
			out.println("파일크기:");
			out.println(multi.getFile("uploadFile").length()+"바이트<br/>");
		} */
		out.println("<p/>");
		Enumeration<String> files = multi.getFileNames();
		while(files.hasMoreElements()){
			String name = files.nextElement();
			String filename = multi.getFilesystemName(name);
			String original = multi.getOriginalFileName(name);
			String type = multi.getContentType(name);
			File f = multi.getFile(name);
			out.println("파라미터 이름:"+name+"<br/>");
			out.println("실제파일 이름:"+original+"<br/>");
			out.println("저장된 파일 이름:"+filename+"<br/>");
			out.println("type:"+type+"<br/>");
			if(f!=null){
				out.println("크기:"+f.length()+"byte");
				out.println("<br/>");
			}
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}
%>