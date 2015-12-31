/** ############################################################### */
/** Program ID   : testDao.java                                     */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package address.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

import address.beans.addressBean;

import com.util.JSPUtil;

public class addressDao 
{
	
	/**
	 * 주소 검색
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<addressBean> searchAddress(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<addressBean> list = new ArrayList<addressBean>();
		
		try
		{ 
			
			
			String search_word = JSPUtil.chkNull((String)paramHash.get("search_word"), "");			
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                                                              \n");
            sQry.append("   SUBSTR(우편번호,0,3) AS 우편번호1                                                 \n");
            sQry.append("  ,SUBSTR(우편번호,3,3) AS 우편번호2                                                 \n");
            sQry.append("  ,주소                                                                              \n");
            sQry.append(" FROM 우편번호                                                                       \n");
            sQry.append(" WHERE 삭제여부 = 'N'                                                                \n");
            sQry.append(" AND 읍면동 LIKE '%'||?||'%'                                                         \n");
            sQry.append(" ORDER BY 1, 2                                                                       \n"); 

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, search_word);
            
            
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			addressBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new addressBean(); 
                
                dataBean.set우편번호1 ((String)rs.getString("우편번호1"  )); 
                dataBean.set우편번호2 ((String)rs.getString("우편번호2"  ));
                dataBean.set주소      ((String)rs.getString("주소"       ));
                
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
	 * 매장 주소 검색
	 * @param paramHash
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<addressBean> selectBaseAddr(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<addressBean> list = new ArrayList<addressBean>();
		
		try
		{ 
			
			String groupCd = JSPUtil.chkNull((String)paramHash.get("groupCd"), "");			
			String corpCd  = JSPUtil.chkNull((String)paramHash.get("corpCd") , "");
			String brandCd = JSPUtil.chkNull((String)paramHash.get("brandCd"), "");
			String storeCd = JSPUtil.chkNull((String)paramHash.get("storeCd"), "");
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("  SELECT                                        \n");
            sQry.append("        SUBSTR(우편번호,0,3) AS 우편번호1          \n");
            sQry.append("       ,SUBSTR(우편번호,3,3) AS 우편번호2          \n");
            sQry.append("       ,우편주소                                   \n");
            sQry.append("       ,상세주소                                   \n");
            sQry.append("   FROM 매장                                     \n");
            sQry.append("  WHERE 기업코드   = ?                            \n");
            sQry.append("    AND 법인코드   = ?                           \n");
            sQry.append("    AND 브랜드코드 = ?                            \n");
            sQry.append("    AND 매장코드   = ?                              \n");

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, groupCd);
            pstmt.setString(++p, corpCd);
            pstmt.setString(++p, brandCd);
            pstmt.setString(++p, storeCd);
            
            
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			addressBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new addressBean(); 
                
                dataBean.set우편번호1 ((String)rs.getString("우편번호1"  )); 
                dataBean.set우편번호2 ((String)rs.getString("우편번호2"  ));
                dataBean.set우편주소  ((String)rs.getString("우편주소"   ));
                dataBean.set상세주소  ((String)rs.getString("상세주소"   ));
                
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