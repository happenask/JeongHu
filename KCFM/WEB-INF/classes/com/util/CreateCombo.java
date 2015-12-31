/** ############################################################### */
/** Program ID   : CreateCombo.java                               */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.util;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

public class CreateCombo 
{
	
	private String CD            = null;
	private String NM            = null; 
	
	public String getCD() {		return CD;	}
	public void setCD(String cD) {		CD = cD;	}
	public String getNM() {		return NM;	}
	public void setNM(String nM) {		NM = nM;	}

	
	public String doAction(HashMap paramHash)	throws Exception 
	{
		// TODO Auto-generated method stub
		
		String comboVal = (String)paramHash.get("selType");
		String sCombo   = "";
		
		if( comboVal.equals("G") ) 
		{
			sCombo = createComboBox(paramHash);
			paramHash.put("combo기업", sCombo);
		}			
		else if( comboVal.equals("C") ) 
		{
			sCombo = createComboBox(paramHash);
			paramHash.put("combo법인", sCombo);
		}			
		else if( comboVal.equals("B") ) 
		{
			sCombo = createComboBox(paramHash);
			paramHash.put("combo브랜드", sCombo);
		}			
		else if( comboVal.equals("S") ) 
		{
			sCombo = createComboBox(paramHash);
			paramHash.put("combo매장", sCombo);
		}			
		
		StringBuffer sb = new StringBuffer();
		
		try
		{
			sb.append("<combo><![CDATA[");
			sb.append(sCombo);
			sb.append("]]></combo>");
			
			return sb.toString();	
			
		}catch(Throwable e){
			e.printStackTrace();
		    return null;
		}finally{}
		//return null;
		
	}
	
	
	public String createComboBox(HashMap paramHash) {
		

		StringBuffer sbCombo = new StringBuffer();

		try
		{
			
			String selType = (String)paramHash.get("selType");
			String select_tag_id = (String)paramHash.get("select_tag_id");
			String stype = (String)paramHash.get("stype");
			String selCustAuth = (String)paramHash.get("selCustAuth");
			
			ArrayList <CreateCombo> list = null;
			
			if ("G".equals(selType))
			{
				list = (ArrayList)select기업List(paramHash);
			}
			else if ("C".equals(selType))
			{
				list = (ArrayList)select법인List(paramHash);
			}
			else if ("B".equals(selType))
			{
				list = (ArrayList)select브랜드List(paramHash);
			}
			else if ("S".equals(selType))
			{
				list = (ArrayList)select매장List(paramHash);
			}

			
			sbCombo.append("<select id='"+select_tag_id+"' name='"+select_tag_id+"'  class='con'>");
			if ( "90".equals(selCustAuth) )
			{
				if(stype.equals("선택"))
				{
					sbCombo.append("<option value='none' selected>::선택::::::::::</option>");
				}
				else if(stype.equals("전체"))
				{
					sbCombo.append("<option value='' selected>::전체::::::::::</option>");
				}
			}
			else if ( "50".equals(selCustAuth) )
			{
				if (!"G".equals(selType))
				{
					sbCombo.append("<option value='' selected>::전체::::::::::</option>");
				}
			}
			else if ( "40".equals(selCustAuth) )
			{
				if ( !("G".equals(selType) || "C".equals(selType)) )
				{
					sbCombo.append("<option value='' selected>::전체::::::::::</option>");
				}
			}
			else if ( "30".equals(selCustAuth) )
			{
				if ("S".equals(selType))
				{
					sbCombo.append("<option value='' selected>::전체::::::::::</option>");
				}
			}

			
			String scd = "";
			String snm = "";
			
			CreateCombo bean = null;
			
			for(int i = 0 ; i < list.size() ; i++)
			{
				bean = list.get(i);
				scd = bean.getCD();
				snm = bean.getNM();
				
				sbCombo.append("<option value='"+scd+"'>"+snm+"</option>");
			}
			
			sbCombo.append("</select>");
		}
		catch(Exception e)
		{
			System.out.println("[Exception] createComboBox() : "+e.toString());
		}			
		return sbCombo.toString();
	}
	
	
	/**
	 * 기업코드 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<CreateCombo> select기업List(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<CreateCombo> list = new ArrayList<CreateCombo>();
		
		try
		{ 
			String 기업코드    = JSPUtil.chkNull((String)paramHash.get("selGroupCd"));
			String selCustAuth = JSPUtil.chkNull((String)paramHash.get("selCustAuth"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" select 기업코드 AS CD               \n");
            sQry.append("      , 기업명   AS NM               \n");
            sQry.append("   from 기업                         \n");
            sQry.append("  where 1=1                          \n");
            if (!selCustAuth.equals("90")) //권한코드
            {
            	sQry.append("    and 기업코드 = ?                 \n");
            }
            sQry.append("    and 사용여부 = 'Y'               \n");
            sQry.append("    and 삭제여부 = 'N'               \n");

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            if (!selCustAuth.equals("90")) //권한코드
            {
            	pstmt.setString(++p, 기업코드);
            }         
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			CreateCombo dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new CreateCombo(); 
                
                dataBean.setCD((String)rs.getString("CD"   )); 
                dataBean.setNM((String)rs.getString("NM"  ));

                list.add(dataBean);
                
            }
            
            
	    } catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
	        //logger.error("[EJB][selectSub]" + e.toString());
	        throw new DAOException(e.getMessage());
	    } catch (Exception e) {
	    	e.printStackTrace(); 
	    	//logger.error("[EJB][selectSub]", e);			
	        throw new DAOException();
		} finally { 
			try {
				rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				pstmt.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} 
		
		return list;
		
    }

	/**
	 * 법인코드 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<CreateCombo> select법인List(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<CreateCombo> list = new ArrayList<CreateCombo>();
		
		try
		{ 
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("selGroupCd"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("selCorpCd"));
			String selCustAuth = JSPUtil.chkNull((String)paramHash.get("selCustAuth"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" select 법인코드 AS CD               \n");
            sQry.append("      , 법인명   AS NM               \n");
            sQry.append("   from 법인                         \n");
            sQry.append("  where 1=1                          \n");
            sQry.append("    and 기업코드 = ?                 \n");
            if (!(selCustAuth.equals("90")||selCustAuth.equals("50"))) //권한코드
            {
            	sQry.append("    and 법인코드 = ?                 \n");
            }
            sQry.append("    and 사용여부 = 'Y'               \n");
            sQry.append("    and 삭제여부 = 'N'               \n");

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, 기업코드);
            if (!(selCustAuth.equals("90")||selCustAuth.equals("50"))) //권한코드
            {
            	pstmt.setString(++p, 법인코드);
            }
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			CreateCombo dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new CreateCombo(); 
                
                dataBean.setCD((String)rs.getString("CD"   )); 
                dataBean.setNM((String)rs.getString("NM"  ));

                list.add(dataBean);
                
            }
            
            
	    } catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
	        //logger.error("[EJB][selectSub]" + e.toString());
	        throw new DAOException(e.getMessage());
	    } catch (Exception e) {
	    	e.printStackTrace(); 
	    	//logger.error("[EJB][selectSub]", e);			
	        throw new DAOException();
		} finally { 
			try {
				rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				pstmt.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} 
		
		return list;
		
    }

	/**
	 * 브랜드코드 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<CreateCombo> select브랜드List(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<CreateCombo> list = new ArrayList<CreateCombo>();
		
		try
		{ 
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("selGroupCd"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("selCorpCd"));
			String 브랜드코드   = JSPUtil.chkNull((String)paramHash.get("selBrandCd"));
			String selCustAuth = JSPUtil.chkNull((String)paramHash.get("selCustAuth"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" select 브랜드코드 AS CD             \n");
            sQry.append("      , 브랜드명   AS NM             \n");
            sQry.append("   from 브랜드                       \n");
            sQry.append("  where 1=1                          \n");
            sQry.append("    and 기업코드 = ?                 \n");
            sQry.append("    and 법인코드 = ?                 \n");
            if (!(selCustAuth.equals("90")||selCustAuth.equals("50")||selCustAuth.equals("40"))) //권한코드
            {
            	sQry.append("    and 브랜드코드 = ?                 \n");
            }
            sQry.append("    and 사용여부 = 'Y'               \n");
            sQry.append("    and 삭제여부 = 'N'               \n");

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            if (!(selCustAuth.equals("90")||selCustAuth.equals("50")||selCustAuth.equals("40"))) //권한코드
            {
            	pstmt.setString(++p, 브랜드코드);
            }
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			CreateCombo dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new CreateCombo(); 
                
                dataBean.setCD((String)rs.getString("CD"   )); 
                dataBean.setNM((String)rs.getString("NM"  ));

                list.add(dataBean);
                
            }
            
            
	    } catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
	        //logger.error("[EJB][selectSub]" + e.toString());
	        throw new DAOException(e.getMessage());
	    } catch (Exception e) {
	    	e.printStackTrace(); 
	    	//logger.error("[EJB][selectSub]", e);			
	        throw new DAOException();
		} finally { 
			try {
				rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				pstmt.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} 
		
		return list;
		
    }

	/**
	 * 매장코드 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<CreateCombo> select매장List(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<CreateCombo> list = new ArrayList<CreateCombo>();
		
		try
		{ 
			String 기업코드    = JSPUtil.chkNull((String)paramHash.get("selGroupCd"));
			String 법인코드    = JSPUtil.chkNull((String)paramHash.get("selCorpCd"));
			String 브랜드코드  = JSPUtil.chkNull((String)paramHash.get("selBrandCd"));
			String 매장코드    = JSPUtil.chkNull((String)paramHash.get("selStoreCd"));
			String selCustAuth = JSPUtil.chkNull((String)paramHash.get("selCustAuth"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" select 매장코드 AS CD             \n");
            sQry.append("      , 매장명   AS NM             \n");
            sQry.append("   from 매장                       \n");
            sQry.append("  where 1=1                        \n");
            sQry.append("    and 기업코드   = ?             \n");
            sQry.append("    and 법인코드   = ?             \n");
            sQry.append("    and 브랜드코드 = ?             \n");
            if (selCustAuth.equals("10")) //권한코드
            {
            	sQry.append("    and 매장코드   = ?             \n");
            }
            sQry.append("    and 사용여부   = 'Y'           \n");
            sQry.append("    and 삭제여부   = 'N'           \n");

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);
            if (selCustAuth.equals("10")) //권한코드
            {
            	pstmt.setString(++p, 매장코드);
            }
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			CreateCombo dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new CreateCombo(); 
                
                dataBean.setCD((String)rs.getString("CD"   )); 
                dataBean.setNM((String)rs.getString("NM"  ));

                list.add(dataBean);
                
            }
            
            
	    } catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
	        //logger.error("[EJB][selectSub]" + e.toString());
	        throw new DAOException(e.getMessage());
	    } catch (Exception e) {
	    	e.printStackTrace(); 
	    	//logger.error("[EJB][selectSub]", e);			
	        throw new DAOException();
		} finally { 
			try {
				rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				pstmt.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try {
				con.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} 
		
		return list;
		
    }
}