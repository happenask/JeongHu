/** ############################################################### */
/** Program ID   : stroetDao.java                                  */
/** Program Name : 매장관리                                         */
/** Program Desc : 매장관리 Dao                                     */
/** Create Date  : 2015-04-21                                       */
/** Programmer   : JHYOUN                                           */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package admin.dao;

import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import admin.beans.storeBean;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;
import com.util.JSPUtil;

public class storeDao 
{
	/**--------------------------------------------------------------------------------------------------------------*
	 * 기업코드 콤보정보 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 **--------------------------------------------------------------------------------------------------------------*/
	public ArrayList<storeBean> selectCORP_ComboList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));
		ArrayList<storeBean> list = new ArrayList<storeBean>();
		
		try
		{ 
			//--------------------------------------------------------------------------------------------------------
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT A.기업코드                                         AS 기업코드                  \n");
            sQry.append("      , A.기업명                                           AS 기업명                    \n");
            sQry.append(" FROM   기업   A                                                                        \n");
            
            sQry.append("   WHERE  A.사용여부    = 'Y'                                                             \n");
            if (!권한코드.equals("90")) {
            	sQry.append(" AND  A.기업코드 LIKE  ?                                                          \n"); //(01)
			}																									       //권한코드가 아닐경우 기업코드 검색조건 빠짐.
            sQry.append("   AND  A.삭제여부    = 'N'                                                             \n"); 
			//--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            if (!권한코드.equals("90")) {
            	pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //(01)
			}//권한코드가 아닐경우 기업코드 검색조건 빠짐.
			//--------------------------------------------------------------------------------------------------------
            //  대상 쿼리 실행 및 확인
			//--------------------------------------------------------------------------------------------------------
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			//--------------------------------------------------------------------------------------------------------
            // make databean list
			//--------------------------------------------------------------------------------------------------------
			storeBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new storeBean(); 
                
                dataBean.set기업코드      ((String)rs.getString("기업코드"      ));
                dataBean.set기업명        ((String)rs.getString("기업명"        ));

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

	/**--------------------------------------------------------------------------------------------------------------*
	 * 법인코드 콤보정보 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 **--------------------------------------------------------------------------------------------------------------*/
	public ArrayList<storeBean> selectCRPN_ComboList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<storeBean> list = new ArrayList<storeBean>();
		
		try
		{ 
			//--------------------------------------------------------------------------------------------------------
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT A.법인코드                                         AS 법인코드                  \n");
            sQry.append("      , A.법인명                                           AS 법인명                    \n");
            sQry.append(" FROM   법인   A                                                                        \n");
            sQry.append(" WHERE  A.기업코드 LIKE  ?                                                              \n"); //(01)
            sQry.append("   AND  A.사용여부    = 'Y'                                                             \n"); 
            sQry.append("   AND  A.삭제여부    = 'N'                                                             \n"); 
			//--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //(01)
			//--------------------------------------------------------------------------------------------------------
            //  대상 쿼리 실행 및 확인
			//--------------------------------------------------------------------------------------------------------
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			//--------------------------------------------------------------------------------------------------------
            // make databean list
			//--------------------------------------------------------------------------------------------------------
			storeBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new storeBean(); 
                
                dataBean.set법인코드      ((String)rs.getString("법인코드"      ));
                dataBean.set법인명        ((String)rs.getString("법인명"        ));

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

	/**--------------------------------------------------------------------------------------------------------------*
	 * 브랜드코드 콤보정보 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 **--------------------------------------------------------------------------------------------------------------*/
	public ArrayList<storeBean> selectBRND_ComboList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<storeBean> list = new ArrayList<storeBean>();
		
		try
		{ 
			//--------------------------------------------------------------------------------------------------------
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT A.브랜드코드                                       AS 브랜드코드                \n");
            sQry.append("      , A.브랜드명                                         AS 브랜드명                  \n");
            sQry.append(" FROM   브랜드   A                                                                      \n");
            sQry.append(" WHERE  A.기업코드 LIKE  ?                                                              \n"); //(01)
            sQry.append("   AND  A.법인코드 LIKE  ?                                                              \n"); //(02)
            sQry.append("   AND  A.사용여부    = 'Y'                                                             \n"); 
            sQry.append("   AND  A.삭제여부    = 'N'                                                             \n"); 
			//--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //(01)
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //(02)
			//--------------------------------------------------------------------------------------------------------
            //  대상 쿼리 실행 및 확인
			//--------------------------------------------------------------------------------------------------------
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			//--------------------------------------------------------------------------------------------------------
            // make databean list
			//--------------------------------------------------------------------------------------------------------
			storeBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new storeBean(); 
                
                dataBean.set브랜드코드      ((String)rs.getString("브랜드코드"      ));
                dataBean.set브랜드명        ((String)rs.getString("브랜드명"        ));

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
	 * 콤보정보 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<storeBean> selectComboList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<storeBean> list = new ArrayList<storeBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT ROW_NUMBER() OVER(PARTITION BY A.기업코드                                           \n");
            sQry.append("                          ORDER BY  A.기업코드)            AS 기업번호                      \n");
            sQry.append("      , A.기업코드                                         AS 기업코드                      \n");
            sQry.append("      , B.기업명                                           AS 기업명                        \n");
            sQry.append("      , ROW_NUMBER() OVER(PARTITION BY A.기업코드, A.법인코드                               \n");
            sQry.append("                          ORDER BY A.기업코드, A.법인코드) AS 법인번호                      \n");
            sQry.append("      , A.법인코드                                         AS 법인코드                      \n");
            sQry.append("      , C.법인명                                           AS 법인명                        \n");
            sQry.append("      , ROW_NUMBER() OVER(PARTITION BY A.기업코드, A.법인코드, 브랜드코드                   \n");
            sQry.append("                          ORDER BY A.기업코드, A.법인코드, A.브랜드코드)                    \n");
            sQry.append("                                                           AS 브랜드번호                    \n");
            sQry.append("      , A.브랜드코드                                       AS 브랜드코드                    \n");
            sQry.append("      , A.브랜드명                                         AS 브랜드명                      \n");
            sQry.append(" FROM   브랜드 A                                                                            \n");
            sQry.append("        INNER JOIN                                                                          \n");
            sQry.append("        기업   B                                                                            \n");
            sQry.append("         ON B.기업코드  = A.기업코드                                                        \n");
            sQry.append("        AND B.사용여부  = 'Y'                                                               \n");
            sQry.append("        AND B.삭제여부  = 'N'                                                               \n");
            sQry.append("        INNER JOIN                                                                          \n");
            sQry.append("        법인   C                                                                            \n");
            sQry.append("         ON C.기업코드  = A.기업코드                                                        \n");
            sQry.append("        AND C.법인코드  = A.법인코드                                                        \n");
            sQry.append("        AND C.사용여부  = 'Y'                                                               \n");
            sQry.append("        AND C.삭제여부  = 'N'                                                               \n");
            sQry.append(" WHERE  A.기업코드   LIKE ?                                                                 \n"); //(01)
            sQry.append("   AND  A.법인코드   LIKE ?                                                                 \n"); //(02)
            sQry.append("   AND  A.브랜드코드 LIKE ?                                                                 \n"); //(03)
			//--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //(01)
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //(02)
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  //(03)
			//--------------------------------------------------------------------------------------------------------
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			storeBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new storeBean(); 
                
                dataBean.set기업번호      ((String)rs.getString("기업번호"      ));
                dataBean.set기업코드      ((String)rs.getString("기업코드"      ));
                dataBean.set기업명        ((String)rs.getString("기업명"        ));
                dataBean.set법인번호      ((String)rs.getString("법인번호"      ));
                dataBean.set법인코드      ((String)rs.getString("법인코드"      ));
                dataBean.set법인명        ((String)rs.getString("법인명"        ));
                dataBean.set브랜드번호    ((String)rs.getString("브랜드번호"    ));
                dataBean.set브랜드코드    ((String)rs.getString("브랜드코드"    ));
                dataBean.set브랜드명      ((String)rs.getString("브랜드명"      ));

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
	 * 검색 조건에 맞는 콤보정보의 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectComboListCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			//-------------------------------------------------------------------------------------------
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append(" SELECT COUNT(*)                                                                            \n"); 
            sQry.append(" FROM   브랜드 A                                                                            \n");
            sQry.append("        INNER JOIN                                                                          \n");
            sQry.append("        기업   B                                                                            \n");
            sQry.append("         ON B.기업코드  = A.기업코드                                                        \n");
            sQry.append("        AND B.사용여부  = 'Y'                                                               \n");
            sQry.append("        AND B.삭제여부  = 'N'                                                               \n");
            sQry.append("        INNER JOIN                                                                          \n");
            sQry.append("        법인   C                                                                            \n");
            sQry.append("         ON C.기업코드  = A.기업코드                                                        \n");
            sQry.append("        AND C.법인코드  = A.법인코드                                                        \n");
            sQry.append("        AND C.사용여부  = 'Y'                                                               \n");
            sQry.append("        AND C.삭제여부  = 'N'                                                               \n");
            sQry.append(" WHERE  A.기업코드   LIKE ?                                                                 \n"); //(01)
            sQry.append("   AND  A.법인코드   LIKE ?                                                                 \n"); //(02)
            sQry.append("   AND  A.브랜드코드 LIKE ?                                                                 \n"); //(03)

            //--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //(01)
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //(02)
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  //(03)
			//--------------------------------------------------------------------------------------------------------

            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) totalCnt = rs.getInt(1);		
		} catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
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
		
		return totalCnt;
		
    }
	
	
	/**
	 * 매장정보 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<storeBean> selectStoreList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<storeBean> list = new ArrayList<storeBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT MAX(CASE WHEN T.ROW_MOD = 1                                                     \n");
            sQry.append("                 THEN T.선택여부                                                        \n");
            sQry.append("                 ELSE '#'                                                               \n");
            sQry.append("            END)                              AS 선택여부1                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 1                                                     \n");
            sQry.append("                 THEN T.매장코드                                                        \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 매장코드1                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 1                                                     \n");
            sQry.append("                 THEN T.매장명                                                          \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 매장명1                                \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 1                                                     \n");
            sQry.append("                 THEN T.기업코드                                                        \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 기업코드1                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 1                                                     \n");
            sQry.append("                 THEN T.법인코드                                                        \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 법인코드1                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 1                                                     \n");
            sQry.append("                 THEN T.브랜드코드                                                      \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 브랜드코드1                            \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 2                                                     \n");
            sQry.append("                 THEN T.선택여부                                                        \n");
            sQry.append("                 ELSE '#'                                                               \n");
            sQry.append("            END)                              AS 선택여부2                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 2                                                     \n");
            sQry.append("                 THEN T.매장코드                                                        \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 매장코드2                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 2                                                     \n");
            sQry.append("                 THEN T.매장명                                                          \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 매장명2                                \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 2                                                     \n");
            sQry.append("                 THEN T.기업코드                                                        \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 기업코드2                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 2                                                     \n");
            sQry.append("                 THEN T.법인코드                                                        \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 법인코드2                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 2                                                     \n");
            sQry.append("                 THEN T.브랜드코드                                                      \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 브랜드코드2                            \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 0                                                     \n");
            sQry.append("                 THEN T.선택여부                                                        \n");
            sQry.append("                 ELSE '#'                                                               \n");
            sQry.append("            END)                              AS 선택여부3                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 0                                                     \n");
            sQry.append("                 THEN T.매장코드                                                        \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 매장코드3                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 0                                                     \n");
            sQry.append("                 THEN T.매장명                                                          \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 매장명3                                \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 0                                                     \n");
            sQry.append("                 THEN T.기업코드                                                        \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 기업코드3                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 0                                                     \n");
            sQry.append("                 THEN T.법인코드                                                        \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 법인코드3                              \n");
            sQry.append("      , MAX(CASE WHEN T.ROW_MOD = 0                                                     \n");
            sQry.append("                 THEN T.브랜드코드                                                      \n");
            sQry.append("                 ELSE ' '                                                               \n");
            sQry.append("            END)                              AS 브랜드코드3                            \n");
            sQry.append(" FROM ( SELECT T1.ROW_NUM                                                               \n");
            sQry.append("             , TRUNC((T1.ROW_NUM - 0.1) / 3)  AS ROW_CNT                                \n");
            sQry.append("             , MOD(T1.ROW_NUM, 3)             AS ROW_MOD                                \n");
            sQry.append("             , T1.선택여부                    AS 선택여부                               \n");
            sQry.append("             , T1.매장코드                    AS 매장코드                               \n");
            sQry.append("             , T1.매장명                      AS 매장명                                 \n");
            sQry.append("             , T1.기업코드                    AS 기업코드                               \n");
            sQry.append("             , T1.법인코드                    AS 법인코드                               \n");
            sQry.append("             , T1.브랜드코드                  AS 브랜드코드                             \n");
            sQry.append("        FROM ( SELECT ROW_NUMBER() OVER(ORDER BY A.기업코드                             \n");
            sQry.append("                                               , A.법인코드                             \n");
            sQry.append("                                               , A.브랜드코드                           \n");
            sQry.append("                                               , A.매장코드)                            \n");
            sQry.append("                                              AS ROW_NUM                                \n");
            sQry.append("                    , CASE WHEN E.매장코드 IS NULL                                      \n");
            sQry.append("                           THEN '0'                                                     \n");
            sQry.append("                           ELSE (CASE WHEN E.게시번호 LIKE '9999%' THEN '0' ELSE '1' END)   \n");
            sQry.append("                      END                     AS 선택여부                               \n");
            sQry.append("                    , A.매장코드              AS 매장코드                               \n");
            sQry.append("                    , NVL(A.매장명  , ' ')    AS 매장명                                 \n");
            sQry.append("                    , A.기업코드              AS 기업코드                               \n");
            sQry.append("                    , A.법인코드              AS 법인코드                               \n");
            sQry.append("                    , A.브랜드코드            AS 브랜드코드                             \n");
            sQry.append("               FROM   매장 A                                                            \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      기업 B                                                            \n");
            sQry.append("                       ON B.기업코드   = A.기업코드                                     \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      법인 C                                                            \n");
            sQry.append("                       ON C.기업코드   = A.기업코드                                     \n");
            sQry.append("                      AND C.법인코드   = A.법인코드                                     \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      브랜드 D                                                          \n");
            sQry.append("                       ON D.기업코드   = A.기업코드                                     \n");
            sQry.append("                      AND D.법인코드   = A.법인코드                                     \n");
            sQry.append("                      AND D.브랜드코드 = A.브랜드코드                                   \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      게시배포정보 E                                                    \n");
            sQry.append("                       ON E.기업코드   = A.기업코드                                     \n");
            sQry.append("                      AND E.법인코드   = A.법인코드                                     \n");
            sQry.append("                      AND E.브랜드코드 = A.브랜드코드                                   \n");
            sQry.append("                      AND E.매장코드   = A.매장코드                                     \n");
            sQry.append("                      AND E.게시구분   LIKE  ?                                          \n"); //(01)게시구분
            sQry.append("                      AND E.게시번호   LIKE  ?                                          \n"); //(02)게시번호
            sQry.append("               WHERE  A.기업코드       LIKE  ?                                          \n"); //(03)기업코드
            sQry.append("                 AND  A.법인코드       LIKE  ?                                          \n"); //(04)법인코드
            sQry.append("                 AND  A.브랜드코드     LIKE  ?                                          \n"); //(05)브랜드코드
            sQry.append("                 AND  A.매장상태코드  IN('00', '10')                                    \n");
            sQry.append("                 AND  A.매장구분코드  IN('10', '20')                                    \n");
            sQry.append("                 AND  A.삭제여부       = 'N'                                    		 \n");
            sQry.append("                 AND  A.사용여부       = 'Y'                                    		 \n");
            sQry.append("             ) T1                                                                       \n");
            sQry.append("       ) T                                                                              \n");
            sQry.append(" WHERE  1 = 1                                                                           \n");
            sQry.append(" GROUP BY T.ROW_CNT                                                                     \n");
            sQry.append(" ORDER BY T.ROW_CNT                                                                     \n");

			//--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("게시구분")        );  //01.
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );  //02.
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //03.
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //04.
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  //05.
			//--------------------------------------------------------------------------------------------------------
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			storeBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new storeBean(); 
                
                dataBean.set선택여부1     ((String)rs.getString("선택여부1"     ));
                dataBean.set매장코드1     ((String)rs.getString("매장코드1"     ));
                dataBean.set매장명1       ((String)rs.getString("매장명1"       ));
                dataBean.set기업코드1     ((String)rs.getString("기업코드1"     ));
                dataBean.set법인코드1     ((String)rs.getString("법인코드1"     ));
                dataBean.set브랜드코드1   ((String)rs.getString("브랜드코드1"   ));
                dataBean.set선택여부2     ((String)rs.getString("선택여부2"     ));
                dataBean.set매장코드2     ((String)rs.getString("매장코드2"     ));
                dataBean.set매장명2       ((String)rs.getString("매장명2"       ));
                dataBean.set기업코드2     ((String)rs.getString("기업코드2"     ));
                dataBean.set법인코드2     ((String)rs.getString("법인코드2"     ));
                dataBean.set브랜드코드2   ((String)rs.getString("브랜드코드2"   ));
                dataBean.set선택여부3     ((String)rs.getString("선택여부3"     ));
                dataBean.set매장코드3     ((String)rs.getString("매장코드3"     ));
                dataBean.set매장명3       ((String)rs.getString("매장명3"       ));
                dataBean.set기업코드3     ((String)rs.getString("기업코드3"     ));
                dataBean.set법인코드3     ((String)rs.getString("법인코드3"     ));
                dataBean.set브랜드코드3   ((String)rs.getString("브랜드코드3"   ));

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
	 * 검색 조건에 맞는 매장정보의 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectStoreListCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			//-------------------------------------------------------------------------------------------
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append(" SELECT NVL(MAX(T.ROW_NUM), 0)                                                          \n"); 
            sQry.append(" FROM ( SELECT T1.ROW_NUM                                                               \n");
            sQry.append("             , TRUNC((T1.ROW_NUM - 0.1) / 3)  AS ROW_CNT                                \n");
            sQry.append("             , MOD(T1.ROW_NUM, 3)             AS ROW_MOD                                \n");
            sQry.append("             , T1.선택여부                    AS 선택여부                               \n");
            sQry.append("             , T1.매장코드                    AS 매장코드                               \n");
            sQry.append("             , T1.매장명                      AS 매장명                                 \n");
            sQry.append("        FROM ( SELECT ROW_NUMBER() OVER(ORDER BY A.기업코드                             \n");
            sQry.append("                                               , A.법인코드                             \n");
            sQry.append("                                               , A.브랜드코드                           \n");
            sQry.append("                                               , A.매장코드)                            \n");
            sQry.append("                                              AS ROW_NUM                                \n");
            sQry.append("                    , CASE WHEN E.매장코드 IS NULL                                      \n");
            sQry.append("                           THEN '0'                                                     \n");
            sQry.append("                           ELSE '1'                                                     \n");
            sQry.append("                      END                     AS 선택여부                               \n");
            sQry.append("                    , A.매장코드              AS 매장코드                               \n");
            sQry.append("                    , NVL(A.매장명  , ' ')    AS 매장명                                 \n");
            sQry.append("               FROM   매장 A                                                            \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      기업 B                                                            \n");
            sQry.append("                       ON B.기업코드   = A.기업코드                                     \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      법인 C                                                            \n");
            sQry.append("                       ON C.기업코드   = A.기업코드                                     \n");
            sQry.append("                      AND C.법인코드   = A.법인코드                                     \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      브랜드 D                                                          \n");
            sQry.append("                       ON D.기업코드   = A.기업코드                                     \n");
            sQry.append("                      AND D.법인코드   = A.법인코드                                     \n");
            sQry.append("                      AND D.브랜드코드 = A.브랜드코드                                   \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      게시배포정보 E                                                    \n");
            sQry.append("                       ON E.기업코드   = A.기업코드                                     \n");
            sQry.append("                      AND E.법인코드   = A.법인코드                                     \n");
            sQry.append("                      AND E.브랜드코드 = A.브랜드코드                                   \n");
            sQry.append("                      AND E.매장코드   = A.매장코드                                     \n");
            sQry.append("                      AND E.게시구분   LIKE  ?                                          \n"); //(01)게시구분
            sQry.append("                      AND E.게시번호   LIKE  ?                                          \n"); //(02)게시번호
            sQry.append("               WHERE  A.기업코드       LIKE  ?                                          \n"); //(03)기업코드
            sQry.append("                 AND  A.법인코드       LIKE  ?                                          \n"); //(04)법인코드
            sQry.append("                 AND  A.브랜드코드     LIKE  ?                                          \n"); //(05)브랜드코드
            sQry.append("                 AND  A.매장상태코드  IN('00', '10')                                    \n");
            sQry.append("                 AND  A.매장구분코드  IN('10', '20')                                    \n");
            sQry.append("                 AND  A.삭제여부       = 'N'                                    		 \n");
            sQry.append("                 AND  A.사용여부       = 'Y'                                    		 \n");
            sQry.append("             ) T1                                                                       \n");
            sQry.append("       ) T                                                                              \n");
            sQry.append(" WHERE  1 = 1                                                                           \n");

            //--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("게시구분")        );  //01.
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );  //02.
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //03.
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //04.
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  //05.
			//--------------------------------------------------------------------------------------------------------

            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) totalCnt = rs.getInt(1);		
		} catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
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
		
		return totalCnt;
		
    }

    
    /**
     * 게시배포정보 삭제처리
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteStoreSelect(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;

		
		System.out.println("##### deleteStoreSelect ###### \n" );
		
		int RowCnt = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
            sQry.append(" DELETE                                                       \n");
            sQry.append(" FROM   게시배포정보                                          \n");
            sQry.append(" WHERE  1=1                                        		   \n");
          //sQry.append("   AND  기업코드   = ?                                        \n");
          //sQry.append("   AND  법인코드   = ?                                        \n");
          //sQry.append("   AND  브랜드코드 = ?                                        \n");
            sQry.append("   AND  게시구분   = ?                                        \n");
            sQry.append("   AND  게시번호   LIKE '9999%'                               \n");
            sQry.append("   AND  확인여부   = 'N'                                      \n");
			
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
          //pstmt.setString(++i, (String)paramData.get("기업코드")   );  
          //pstmt.setString(++i, (String)paramData.get("법인코드")   );  
          //pstmt.setString(++i, (String)paramData.get("브랜드코드")  );
            pstmt.setString(++i, (String)paramData.get("게시구분")   );
          //pstmt.setString(++i, (String)paramData.get("게시번호")   );
            //pstmt.setInt   (++i, Integer.parseInt((String)paramData.get("게시번호")));  
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            RowCnt = pstmt.executeUpdate();
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
		
		return RowCnt;
            
	}

    /**
     * 게시배포정보 기존점 삭제시 사용
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteStore(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;

		
		System.out.println("##### deleteStoreSelect ###### \n" );
		
		int RowCnt = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
            sQry.append(" DELETE                                                       \n");
            sQry.append(" FROM   게시배포정보                                          \n");
            sQry.append(" WHERE  1=1                                        		   \n");
          //sQry.append("   AND  기업코드   = ?                                        \n");
          //sQry.append("   AND  법인코드   = ?                                        \n");
          //sQry.append("   AND  브랜드코드 = ?                                        \n");
            sQry.append("   AND  게시구분   = ?                                        \n");
            sQry.append("   AND  게시번호   = ?			                               \n");
            sQry.append("   AND  확인여부   = 'N'                                      \n");
			
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
          //pstmt.setString(++i, (String)paramData.get("기업코드")   );  
          //pstmt.setString(++i, (String)paramData.get("법인코드")   );  
          //pstmt.setString(++i, (String)paramData.get("브랜드코드")  );
            pstmt.setString(++i, (String)paramData.get("게시구분")   );
            pstmt.setString(++i, (String)paramData.get("게시번호")   );
            //pstmt.setInt   (++i, Integer.parseInt((String)paramData.get("게시번호")));  
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            RowCnt = pstmt.executeUpdate();
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
		
		return RowCnt;
            
	}

    /**
     * 게시배포정보 등록처리(신규등록)
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertStoreSelect(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;

		
		System.out.println("##### insertStoreSelect ###### \n" );
		
		int RowCnt = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
            sQry.append(" INSERT INTO 게시배포정보                                     \n");
            sQry.append("     ( 기업코드                                               \n");
            sQry.append("     , 법인코드                                               \n");
            sQry.append("     , 브랜드코드                                             \n");
            sQry.append("     , 게시구분                                               \n");
            sQry.append("     , 게시번호                                               \n");
            sQry.append("     , 매장코드                                               \n");
            sQry.append("     , 확인자                                                 \n");
            sQry.append("     , 확인여부                                               \n");
            sQry.append("     , 확인일자                                               \n");
            sQry.append("     , 배포일자                                               \n");
            sQry.append("     , 예비문자                                               \n");
            sQry.append("     , 예비숫자                                               \n");
            sQry.append("     , 최종변경일시                                           \n");
            sQry.append("     )                                                        \n");
            sQry.append("VALUES                                                        \n");
            sQry.append("     ( ?                                                      \n");  //기업코드 
            sQry.append("     , ?                                                      \n");  //법인코드 
            sQry.append("     , ?                                                      \n");  //브랜드코드
            sQry.append("     , ?                                                      \n");  //게시구분
            sQry.append("     , ?                                                      \n");  //게시번호
            sQry.append("     , ?                                                      \n");  //매장코드
            sQry.append("     , ''                                                     \n");  //확인자
            sQry.append("     , 'N'                                                    \n");  //확인여부
            sQry.append("     , '1900-01-01'                                           \n");  //확인일자
            sQry.append("     , '1900-01-01'                                           \n");  //배포일자
            sQry.append("     , ''                                                     \n");  //예비문자 
            sQry.append("     , 0                                                      \n");  //예비숫자 
            sQry.append("     , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')              \n");  //최종변경일시
            sQry.append("     )                                                        \n"); 
			
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("기업코드")   );  
            pstmt.setString(++i, (String)paramData.get("법인코드")   );  
            pstmt.setString(++i, (String)paramData.get("브랜드코드")  );
            pstmt.setString(++i, (String)paramData.get("게시구분")   );
            pstmt.setString(++i, (String)paramData.get("게시번호")   );
            pstmt.setString(++i, (String)paramData.get("매장코드")   );
            //pstmt.setInt   (++i, Integer.parseInt((String)paramData.get("게시번호")));  
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            RowCnt = pstmt.executeUpdate();
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
		
		return RowCnt;
            
	}

    
    /**
     * 게시배포정보 등록처리(수정등록)
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateStoreSelect(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;

		
		System.out.println("##### updateStoreSelect ###### \n" );
		
		int RowCnt = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
            sQry.append(" MERGE INTO  게시배포정보 M1                                        \n"); 
            sQry.append("      USING (SELECT ?                    AS 기업코드                \n");  //(01):기업코드
            sQry.append("                  , ?                    AS 법인코드                \n");  //(02):법인코드
            sQry.append("                  , ?                    AS 브랜드코드              \n");  //(03):브랜드코드
            sQry.append("                  , ?                    AS 게시구분                \n");  //(04):게시구분
            sQry.append("                  , ?                    AS 게시번호                \n");  //(05):게시번호
            sQry.append("                  , ?                    AS 매장코드                \n");  //(06):매장코드
            sQry.append("             FROM   DUAL                                            \n");
            sQry.append("            ) M2                                                    \n");
            sQry.append("         ON (M2.기업코드   = M1.기업코드                            \n");
            sQry.append("        AND  M2.법인코드   = M1.법인코드                            \n");
            sQry.append("        AND  M2.브랜드코드 = M1.브랜드코드                          \n");
            sQry.append("        AND  M2.게시구분   = M1.게시구분                            \n");
            sQry.append("        AND  M2.게시번호   = M1.게시번호                            \n");
            sQry.append("        AND  M2.매장코드   = M1.매장코드)                           \n");
            sQry.append(" WHEN MATCHED THEN                                                  \n");
            sQry.append("      UPDATE SET 예비숫자 = 예비숫자 + 1                            \n");
            sQry.append(" WHEN NOT MATCHED THEN                                              \n");
            sQry.append("      INSERT ( 기업코드                                             \n");
            sQry.append("             , 법인코드                                             \n");
            sQry.append("             , 브랜드코드                                           \n");
            sQry.append("             , 게시구분                                             \n");
            sQry.append("             , 게시번호                                             \n");
            sQry.append("             , 매장코드                                             \n");
            sQry.append("             , 확인자                                               \n");
            sQry.append("             , 확인여부                                             \n");
            sQry.append("             , 확인일자                                             \n");
            sQry.append("             , 배포일자                                             \n");
            sQry.append("             , 예비문자                                             \n");
            sQry.append("             , 예비숫자                                             \n");
            sQry.append("             , 최종변경일시                                         \n");
            sQry.append("             )                                                      \n");
            sQry.append("      VALUES ( M2.기업코드                                          \n");
            sQry.append("             , M2.법인코드                                          \n");
            sQry.append("             , M2.브랜드코드                                        \n");
            sQry.append("             , M2.게시구분                                          \n");
            sQry.append("             , M2.게시번호                                          \n");
            sQry.append("             , M2.매장코드                                          \n");
            sQry.append("             , ''                                                   \n");
            sQry.append("             , 'N'                                                  \n");
            sQry.append("             , '1900-01-01'                                         \n");
            sQry.append("             , '1900-01-01'                                         \n");
            sQry.append("             , ''                                                   \n");
            sQry.append("             , 0                                                    \n");
            sQry.append("             , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')            \n");
            sQry.append("             )                                                      \n");
			
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("기업코드")   );  //(01)  
            pstmt.setString(++i, (String)paramData.get("법인코드")   );  //(02)
            pstmt.setString(++i, (String)paramData.get("브랜드코드") );  //(03)
            pstmt.setString(++i, (String)paramData.get("게시구분")   );  //(04)
            pstmt.setString(++i, (String)paramData.get("게시번호")   );  //(05)
            pstmt.setString(++i, (String)paramData.get("매장코드")   );  //(06)
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            RowCnt = pstmt.executeUpdate();
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
		
		return RowCnt;
            
	}

	/**
	 * 매장 배포확인 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<storeBean> confirmStoreList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<storeBean> list = new ArrayList<storeBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT ROW_NUMBER() OVER(ORDER BY A.기업코드                                           \n");
            sQry.append("                                 , A.법인코드                                           \n");
            sQry.append("                                 , A.브랜드코드                                         \n");
            sQry.append("                                 , A.매장코드)       AS ROW_NUM                         \n");
            sQry.append("      , A.기업코드                                   AS 기업코드                        \n");
            sQry.append("      , A.법인코드                                   AS 법인코드                        \n");
            sQry.append("      , A.브랜드코드                                 AS 브랜드코드                      \n");
            sQry.append("      , A.매장코드                                   AS 매장코드                        \n");
            sQry.append("      , NVL(B.매장명, ' ')                           AS 매장명                          \n");
            sQry.append("      , NVL(C.법인명, ' ')                           AS 법인명                          \n");
            sQry.append("      , NVL(D.브랜드명, ' ')                         AS 브랜드명                        \n");
            sQry.append("      , NVL(A.확인자, ' ')                           AS 확인자                          \n");
            sQry.append("      , A.확인여부                                   AS 확인여부                        \n");
            sQry.append("      , CASE WHEN A.확인여부 = 'N'                                                      \n");
            sQry.append("             THEN ' '                                                                   \n");
            sQry.append("             ELSE TO_CHAR(A.확인일자, 'YYYY-MM-DD')                                     \n");
            sQry.append("        END                                          AS 확인일자                        \n");
            sQry.append("      , TO_CHAR(A.배포일자, 'YYYY-MM-DD')            AS 배포일자                        \n");
            sQry.append(" FROM   게시배포정보  A                                                                 \n");
            sQry.append("        LEFT OUTER JOIN                                                                 \n");
            sQry.append("        매장          B                                                                 \n");
            sQry.append("         ON B.기업코드      =  A.기업코드                                               \n");
            sQry.append("        AND B.법인코드      =  A.법인코드                                               \n");
            sQry.append("        AND B.브랜드코드    =  A.브랜드코드                                             \n");
            sQry.append("        AND B.매장코드      =  A.매장코드                                               \n");
            sQry.append("        AND B.매장상태코드 IN('00', '10')                                               \n");
            sQry.append("        AND B.매장구분코드 IN('10', '20')                                               \n");
            sQry.append("        LEFT OUTER JOIN                                                                 \n");
            sQry.append("        법인          C                                                                 \n");
            sQry.append("         ON C.기업코드      =  A.기업코드                                               \n");
            sQry.append("        AND C.법인코드      =  A.법인코드                                               \n");
            sQry.append("        AND C.사용여부      = 'Y'                                                       \n");
            sQry.append("        AND C.삭제여부      = 'N'                                                       \n");
            sQry.append("        LEFT OUTER JOIN                                                                 \n");
            sQry.append("        브랜드        D                                                                 \n");
            sQry.append("         ON D.기업코드      =  A.기업코드                                               \n");
            sQry.append("        AND D.법인코드      =  A.법인코드                                               \n");
            sQry.append("        AND D.브랜드코드    =  A.브랜드코드                                             \n");
            sQry.append("        AND D.사용여부      = 'Y'                                                       \n");
            sQry.append("        AND D.삭제여부      = 'N'                                                       \n");
            sQry.append(" WHERE  1=1                                                         					 \n");  //90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
        //  sQry.append("   AND  A.기업코드          = ?                                                         \n");  //01.기업코드
        //  sQry.append("   AND  A.법인코드          = ?                                                         \n");  //02.법인코드
        //  sQry.append("   AND  A.브랜드코드        = ?                                                         \n");  //03.브랜드코드
            sQry.append("   AND  A.게시구분          = ?                                                         \n");  //04.브랜드코드
            sQry.append("   AND  A.게시번호          = ?                                                         \n");  //05.브랜드코드
            sQry.append("   AND  A.확인여부       LIKE ?                                                         \n");  //06.확인여부
            sQry.append(" ORDER BY 1,2,3,4,5                                                                     \n");

			//--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            //pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //01.
            //pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //02.
            //pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  //03.
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );  //04.
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );  //05.
            pstmt.setString(++p, (String)paramHash.get("확인여부")        );  //06.
			//--------------------------------------------------------------------------------------------------------
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			storeBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new storeBean(); 
                
                dataBean.setROW_NUM       ((String)rs.getString("ROW_NUM"       )); 
                dataBean.set기업코드      ((String)rs.getString("기업코드"      ));
                dataBean.set법인코드      ((String)rs.getString("법인코드"      ));
                dataBean.set브랜드코드    ((String)rs.getString("브랜드코드"    ));
                dataBean.set매장코드      ((String)rs.getString("매장코드"      ));
                dataBean.set매장명        ((String)rs.getString("매장명"        ));
                dataBean.set법인명        ((String)rs.getString("법인명"        ));
                dataBean.set브랜드명      ((String)rs.getString("브랜드명"      ));
                dataBean.set확인자        ((String)rs.getString("확인자"        ));
                dataBean.set확인여부      ((String)rs.getString("확인여부"      ));
                dataBean.set확인일자      ((String)rs.getString("확인일자"      ));
                dataBean.set배포일자      ((String)rs.getString("배포일자"      ));

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
	 * 검색 조건에 맞는 매장 배포확인 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int confirmStoreListCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			//-------------------------------------------------------------------------------------------
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append(" SELECT COUNT(*)                                                                        \n"); 
            sQry.append(" FROM   게시배포정보  A                                                                 \n");
            sQry.append("        LEFT OUTER JOIN                                                                 \n");
            sQry.append("        매장          B                                                                 \n");
            sQry.append("         ON B.기업코드      =  A.기업코드                                               \n");
            sQry.append("        AND B.법인코드      =  A.법인코드                                               \n");
            sQry.append("        AND B.브랜드코드    =  A.브랜드코드                                             \n");
            sQry.append("        AND B.매장코드      =  A.매장코드                                               \n");
            sQry.append("        AND B.매장상태코드 IN('00', '10')                                               \n");
            sQry.append("        AND B.매장구분코드 IN('10', '20')                                               \n");
            sQry.append("        LEFT OUTER JOIN                                                                 \n");
            sQry.append("        법인          C                                                                 \n");
            sQry.append("         ON C.기업코드      =  A.기업코드                                               \n");
            sQry.append("        AND C.법인코드      =  A.법인코드                                               \n");
            sQry.append("        AND C.사용여부      = 'Y'                                                       \n");
            sQry.append("        AND C.삭제여부      = 'N'                                                       \n");
            sQry.append("        LEFT OUTER JOIN                                                                 \n");
            sQry.append("        브랜드        D                                                                 \n");
            sQry.append("         ON D.기업코드      =  A.기업코드                                               \n");
            sQry.append("        AND D.법인코드      =  A.법인코드                                               \n");
            sQry.append("        AND D.브랜드코드    =  A.브랜드코드                                             \n");
            sQry.append("        AND D.사용여부      = 'Y'                                                       \n");
            sQry.append("        AND D.삭제여부      = 'N'                                                       \n");	//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
            sQry.append(" WHERE  1=1                                                         					 \n");  //01.기업코드
        //  sQry.append("   AND  A.기업코드          = ?                                                         \n");  //01.기업코드
        //  sQry.append("   AND  A.법인코드          = ?                                                         \n");  //02.법인코드
        //  sQry.append("   AND  A.브랜드코드        = ?                                                         \n");  //03.브랜드코드
            sQry.append("   AND  A.게시구분          = ?                                                         \n");  //04.브랜드코드
            sQry.append("   AND  A.게시번호          = ?                                                         \n");  //05.브랜드코드
            sQry.append("   AND  A.확인여부       LIKE ?                                                         \n");  //06.확인여부

            //--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

          //pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //01.
          //pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //02.
          //pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  //03.
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );  //04.
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );  //05.
            pstmt.setString(++p, (String)paramHash.get("확인여부")        );  //06.
			//--------------------------------------------------------------------------------------------------------

            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) totalCnt = rs.getInt(1);		
		} catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
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
		
		return totalCnt;
		
    }
    
	
}