<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%


FileWriter fw ;
BufferedWriter bw;

request.setCharacterEncoding("utf-8");
	String name = request.getParameter("name");
//	String callback = request.getParameter("callback");
	//response.setContentType("application/json");
	
//	response.setContentType("text/html");
//	response.setCharacterEncoding("UTF-8");
//	String result = callback + "({'success':'" + name + "'})";  
			
//	out.write(result);
//	out.write("{'success':'"+name+"'})");
	
	

try
{
    
	
  	Date date = new Date();
	
	
	SimpleDateFormat sdate = new SimpleDateFormat("HH:mm - EEE dd-MMM-yyyy");
	
	
	String fileDate = sdate.format(date);
	
	//File file = new File("C:\\Users\\work\\webworkspace\\test\\text.txt");
	//FileOutputStream fw = new FileOutputStream(file);
	
	
	fw = new FileWriter("C:\\Users\\work\\webworkspace\\test\\WebContent\\text.dat",true);
	
	
		
	//OutputStreamWriter ow = new OutputStreamWriter(fw);
	
	bw = new BufferedWriter(fw);
    
    bw.write(fileDate+"_"+name+"\n");
    bw.flush();
    fw.close();
    bw.close(); 
}

catch (IOException io)
{
    System.out.println ( "FILEWRITER EXCEPTION " +io.getMessage() );
}

catch (Exception e)
{
    System.out.println (" FILEWRITER GENERIC EXCEPTION " +e.getMessage());
}
finally{

   
   
} 


%>


