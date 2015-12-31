/** ############################################################### */
/** Program ID   : testDao.java                                     */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.test.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.test.beans.testBean;
import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;
import com.util.JSPUtil;

public class testDao 
{
	
	/**
	 * 공지사항 조회 List
	 * @param searchWord 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<testBean> selectBoardList(String searchWord) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<testBean> list = new ArrayList<testBean>();
		
		try
		{ 
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                                             \n");
            sQry.append(" *                                                                  \n");
            sQry.append(" FROM                                                               \n");
            sQry.append(" (                                                                  \n");
            sQry.append("   SELECT                                                           \n");
            sQry.append("       ROW_NUMBER() OVER (ORDER BY 게시번호 DESC) AS ROW_NUM        \n");
            sQry.append("       , 기업코드                                                   \n");
            sQry.append("       , 법인코드                                                   \n");
            sQry.append("       , 브랜드코드                                                 \n");
            sQry.append("       , 게시구분                                                   \n");
            sQry.append("       , 게시번호                                                   \n");
            sQry.append("       , 제목                                                       \n");
            sQry.append("       , 내용                                                       \n");
            sQry.append("       , 공지구분                                                   \n");
            sQry.append("       , 게시시작일자                                               \n");
            sQry.append("       , 게시종료일자                                               \n");
            sQry.append("       , 조회수                                                     \n");
            sQry.append("       , 등록자                                                     \n");
            sQry.append("       , 등록일자                                                   \n");
            sQry.append("       , 등록패스워드                                               \n");
            sQry.append("       , 삭제여부                                                   \n");
            sQry.append("       , 예비문자                                                   \n");
            sQry.append("       , 예비숫자                                                   \n");
            sQry.append("       , 최종변경일시                                               \n");
            sQry.append("   FROM 게시등록정보                                                \n");
            sQry.append("   WHERE 게시구분 = 1                                               \n");
            sQry.append("   AND  제목 LIKE '%||?||%'                                         \n");
            sQry.append(" )                                                                  \n");
            sQry.append(" WHERE  ROW_NUM >  ?                                                \n");
            sQry.append("   AND  ROW_NUM <= ?                                                \n");
            sQry.append(" ORDER BY 게시번호 DESC                                             \n");     

            
            // set preparedstatemen
            int j=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++j, JSPUtil.chkNull(searchWord, ""));
            
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			testBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new testBean(); 
                
                
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"   )); 
                dataBean.set게시번호  ((String)rs.getString("게시번호"  ));
                dataBean.set제목      ((String)rs.getString("제목"      ));
                dataBean.set등록자    ((String)rs.getString("등록자"    ));
                dataBean.set등록일    ((String)rs.getString("등록일"    ));
                dataBean.set조회수    ((String)rs.getString("조회수"    ));

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
	 * 목록 갯수 조회
	 * @param searchWord 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<testBean> selectBoardCount(String searchWord) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<testBean> list = new ArrayList<testBean>();
		
		try
		{ 
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                                             \n");
            sQry.append(" *                                                                  \n");
            sQry.append(" FROM                                                               \n");
            sQry.append(" (                                                                  \n");
            sQry.append("   SELECT                                                           \n");
            sQry.append("       ROW_NUMBER() OVER (ORDER BY 게시번호 DESC) AS ROW_NUM        \n");
            sQry.append("       , 기업코드                                                   \n");
            sQry.append("       , 법인코드                                                   \n");
            sQry.append("       , 브랜드코드                                                 \n");
            sQry.append("       , 게시구분                                                   \n");
            sQry.append("       , 게시번호                                                   \n");
            sQry.append("       , 제목                                                       \n");
            sQry.append("       , 내용                                                       \n");
            sQry.append("       , 공지구분                                                   \n");
            sQry.append("       , 게시시작일자                                               \n");
            sQry.append("       , 게시종료일자                                               \n");
            sQry.append("       , 조회수                                                     \n");
            sQry.append("       , 등록자                                                     \n");
            sQry.append("       , 등록일자                                                   \n");
            sQry.append("       , 등록패스워드                                               \n");
            sQry.append("       , 삭제여부                                                   \n");
            sQry.append("       , 예비문자                                                   \n");
            sQry.append("       , 예비숫자                                                   \n");
            sQry.append("       , 최종변경일시                                               \n");
            sQry.append("   FROM 게시등록정보                                                \n");
            sQry.append("   WHERE 게시구분 = 1                                               \n");
            sQry.append("   AND  제목 LIKE '%||?||%'                                         \n");
            sQry.append(" )                                                                  \n");
            sQry.append(" WHERE  ROW_NUM >  ?                                                \n");
            sQry.append("   AND  ROW_NUM <= ?                                                \n");
            sQry.append(" ORDER BY 게시번호 DESC                                             \n");     

            
            // set preparedstatemen
            int j=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++j, JSPUtil.chkNull(searchWord, ""));
            
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			testBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new testBean(); 
                
                
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"   )); 
                dataBean.set게시번호  ((String)rs.getString("게시번호"  ));
                dataBean.set제목      ((String)rs.getString("제목"      ));
                dataBean.set등록자    ((String)rs.getString("등록자"    ));
                dataBean.set등록일    ((String)rs.getString("등록일"    ));
                dataBean.set조회수    ((String)rs.getString("조회수"    ));

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