package com.db;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;


public class DBConnMng {

	private static final SqlSessionFactory sqlMapper;

	static
	{
		String resource = "property/SqlMapConfig.xml";
		Reader reader = null;
		
		try 
		{
			reader = Resources.getResourceAsReader(resource);
		} catch (IOException e) {
			e.printStackTrace();
		}
		sqlMapper = new SqlSessionFactoryBuilder().build(reader);

	}
	
	//public static SqlSessionFactory getSqlSessionFactory() {
	//	return sqlMapper;   
	//}
	
	public SqlSession getSqlSession() {
		return sqlMapper.openSession();   
	}


	
}

