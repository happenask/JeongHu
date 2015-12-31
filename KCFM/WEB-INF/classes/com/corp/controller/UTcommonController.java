package com.corp.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.util.CommUtil;


/**
 * Servlet implementation class UTcommonController
 */
public class UTcommonController extends HttpServlet{
	private static final long serialVersionUID = 1L;
    
	
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			doPost(request,response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		CommUtil util = new CommUtil();
		
		
		String url = request.getRequestURI();
		
		String 화면명  = url.substring(url.lastIndexOf("/")+1);
		
		request.setCharacterEncoding("UTF-8");
		
		Enumeration reqParam = request.getParameterNames();
		HashMap paramHash = new HashMap();
		paramHash = util.executeParam(reqParam, request);//넘어온 파라메터들을 다 HashMap에 담는다
		
		String command = (String)paramHash.get("actionMode");
		
		
		System.out.println("controller parameter "+화면명);
		
		ControllerInterface ctr = ControllerMapping.getController(화면명);
		//Controller의 ctr 로직 처리 메소드 호출
		
		try {
			
			if(command.equals("search"))
			{
				String result = ctr.getStringResult(request, response,paramHash);
				
				
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();
				
				System.out.println(result);
				out.write(result);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	


}
