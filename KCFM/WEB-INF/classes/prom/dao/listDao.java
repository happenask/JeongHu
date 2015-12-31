/** ############################################################### */
/** Program ID   : listDao.java                                     */
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

import prom.beans.listBean;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;
import com.util.JSPUtil;

public class listDao 
{
	
	/**
	 * 홍보물 목록 조회
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<listBean> selectList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT A.기업코드															\n");
            sQry.append("     , A.법인코드															\n");
            sQry.append("     , A.브랜드코드															\n");
            sQry.append("     , A.홍보물코드															\n");
            sQry.append("     , A.홍보물번호															\n");
            sQry.append("     , A.홍보물명															\n");
            sQry.append("     , A.이미지경로															\n");
            sQry.append("     , A.이미지표지파일명													\n");
            sQry.append("     , A.사이즈																\n");
            sQry.append("     , TO_CHAR(A.수량,'FM999,999,999,999,990') || B.세부코드명	AS 수량		\n");
            sQry.append("     , TO_CHAR(A.매출단가,'FM999,999,999,999,990')				AS 매출단가	\n");
            sQry.append("  FROM 홍보물마스터정보	A													\n");
            sQry.append("     , PRM공통코드		B													\n");
            sQry.append(" WHERE A.기업코드 = B.기업코드												\n");
            sQry.append("   AND A.단위 = B.세부코드													\n");
            sQry.append("   AND A.기업코드 = ?														\n");
            sQry.append("   AND A.법인코드 = ?														\n");
            sQry.append("   AND A.브랜드코드 = ?														\n");
            sQry.append("   AND A.홍보물코드 = ?														\n");
            sQry.append("   AND B.분류코드 = '단위'													\n");
            sQry.append("   AND 삭제여부 = 'N'														\n");
            sQry.append(" ORDER BY A.홍보물번호														\n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("홍보물코드"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set홍보물코드((String)rs.getString("홍보물코드"));
                dataBean.set홍보물번호((String)rs.getString("홍보물번호"));
                dataBean.set홍보물명((String)rs.getString("홍보물명"));
                dataBean.set이미지경로((String)rs.getString("이미지경로"));
                dataBean.set이미지표지파일명((String)rs.getString("이미지표지파일명"));
                dataBean.set사이즈((String)rs.getString("사이즈"));
                dataBean.set수량((String)rs.getString("수량"));
                dataBean.set매출단가((String)rs.getString("매출단가"));
                
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
	 * 홍보물 상세 조회
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public listBean selectDetail(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		listBean dataBean = null;
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT A.기업코드															\n");
            sQry.append("     , A.법인코드															\n");
            sQry.append("     , A.브랜드코드															\n");
            sQry.append("     , A.홍보물코드															\n");
            sQry.append("     , A.홍보물번호															\n");
            sQry.append("     , A.홍보물명															\n");
            sQry.append("     , A.이미지경로															\n");
            sQry.append("     , A.이미지앞면파일명													\n");
            sQry.append("     , A.이미지뒷면파일명													\n");
            sQry.append("     , A.사이즈																\n");
            sQry.append("     , TO_CHAR(A.수량,'FM999,999,999,999,990') || B.세부코드명	AS 수량		\n");
            sQry.append("     , TO_CHAR(A.매출단가,'FM999,999,999,999,990')				AS 매출단가	\n");
            sQry.append("     , A.인쇄사용문구포함여부													\n");
            sQry.append("  FROM 홍보물마스터정보	A													\n");
            sQry.append("     , PRM공통코드		B													\n");
            sQry.append(" WHERE A.기업코드 = B.기업코드												\n");
            sQry.append("   AND A.단위 = B.세부코드													\n");
            sQry.append("   AND A.기업코드 = ?														\n");
            sQry.append("   AND A.법인코드 = ?														\n");
            sQry.append("   AND A.브랜드코드 = ?														\n");
            sQry.append("   AND A.홍보물코드 = ?														\n");
            sQry.append("   AND A.홍보물번호 = ?														\n");
            sQry.append("   AND B.분류코드 = '단위'													\n");
            sQry.append("   AND 삭제여부 = 'N'														\n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("홍보물코드"));
            pstmt.setString(++p, (String)paramHash.get("홍보물번호"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set홍보물코드((String)rs.getString("홍보물코드"));
                dataBean.set홍보물번호((String)rs.getString("홍보물번호"));
                dataBean.set홍보물명((String)rs.getString("홍보물명"));
                dataBean.set이미지경로((String)rs.getString("이미지경로"));
                dataBean.set이미지앞면파일명((String)rs.getString("이미지앞면파일명"));
                dataBean.set이미지뒷면파일명((String)rs.getString("이미지뒷면파일명"));
                dataBean.set사이즈((String)rs.getString("사이즈"));
                dataBean.set수량((String)rs.getString("수량"));
                dataBean.set매출단가((String)rs.getString("매출단가"));
                dataBean.set인쇄사용문구포함여부((String)rs.getString("인쇄사용문구포함여부"));
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
		
		return dataBean;
		
    }

}