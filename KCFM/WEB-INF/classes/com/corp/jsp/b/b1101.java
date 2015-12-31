/** ############################################################### */
/** Program ID   : b1101.java                               */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.corp.jsp.b;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.apache.ibatis.session.SqlSession;

import com.login.beans.loginCheckBean;
import com.corp.controller.ControllerInterface;
import com.db.DBConnMng;
import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;
import com.util.JSPUtil;



public class b1101 implements ControllerInterface
{

	@Override
	public String getStringResult(HttpServletRequest request,HttpServletResponse response,HashMap paramHash) throws Exception 
	{
		String loginStatus = "";

		SqlSession dao = new DBConnMng().getSqlSession();
		
		ArrayList user = null;
		
		System.out.println(paramHash);
		
		String sectionName = (String)paramHash.get("section");
		
		if(sectionName.equals("branch"))
		{
			user = (ArrayList)dao.selectList("b1101.getList", paramHash); //로그인 체킹
		}
		else if(sectionName.equals("location"))
		{
			user = (ArrayList)dao.selectList("b1101.getList_location", paramHash); //로그인 체킹
		}
		else if(sectionName.equals("year"))
		{
			user = (ArrayList)dao.selectList("b1101.getList_year", paramHash); //로그인 체킹
		}
		
		JSONObject json = new JSONObject();
		
		json.put("list", user);
		
		return json.toString();
		
	}

	
	
}