/** ############################################################### */
/** Program ID   : menuDao.java                                     */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package prom.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import prom.beans.menuBean;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

public class menuDao 
{
	
	/**
	 * 메뉴목록 조회
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<menuBean> selectList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<menuBean> list = new ArrayList<menuBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            /*	
            sQry.append("SELECT *					\n");
            sQry.append("  FROM 홍보물메뉴정보		\n");
            sQry.append(" WHERE 기업코드 = ?			\n");
            sQry.append("   AND 법인코드 = ?			\n");
            sQry.append("   AND 브랜드코드 = ?		\n");
            sQry.append("   AND 사용여부 = 'Y'		\n");
            sQry.append(" ORDER BY 메뉴순서			\n");
            */
            
            sQry.append("SELECT A.*																		\n");			
            sQry.append("  FROM 홍보물메뉴정보 A                                                        \n");
            sQry.append("      ,(                                                                       \n");
            sQry.append("        SELECT 메뉴코드||ROW_NUMBER() OVER (ORDER BY 메뉴순서)  AS ORD_NO      \n");
            sQry.append("          FROM 홍보물메뉴정보                                                  \n");
            sQry.append("         WHERE 기업코드   = ?                                                	\n");
            sQry.append("           AND 법인코드   = ?                                               	\n");
            sQry.append("           AND 브랜드코드 = ?													\n");
            sQry.append("           AND 사용여부   = 'Y'                                                \n");
            sQry.append("           AND 상위메뉴코드 = 'NA'                                             \n");
            sQry.append("        )   B                                                                  \n");
            sQry.append(" where 기업코드   = ?                                                        	\n");
            sQry.append("   and 법인코드   = ?                                                       	\n");
            sQry.append("   and 브랜드코드 = ?                                                     		\n");
            sQry.append("   AND 사용여부   = 'Y'														\n");
            sQry.append("   AND SUBSTR(A.메뉴코드,1,3) = SUBSTR(B.ORD_NO,1,3)                           \n");
            sQry.append("ORDER BY SUBSTR(B.ORD_NO,4,1), A.메뉴순서                                      \n");

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			menuBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new menuBean(); 
                
                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set메뉴코드((String)rs.getString("메뉴코드"));
                dataBean.set메뉴코드명((String)rs.getString("메뉴코드명"));
                dataBean.set메뉴URL((String)rs.getString("메뉴URL"));
                dataBean.set메뉴레벨((String)rs.getString("메뉴레벨"));
                dataBean.set메뉴유형((String)rs.getString("메뉴유형"));
                dataBean.set상위메뉴코드((String)rs.getString("상위메뉴코드"));

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