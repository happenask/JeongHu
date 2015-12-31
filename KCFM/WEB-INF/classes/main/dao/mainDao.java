/** ############################################################### */
/** Program ID   : mainDao.java                                     */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package main.dao;

import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

import main.beans.mainBean;

import com.util.JSPUtil;

public class mainDao 
{
	
	/**
	 * 공지사항 및 교육자료 최근 5건 조회 List  (일반유저모드)
	 * @param 게시구분(01:공지사항,02:교육자료)
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<mainBean> selectNoticeVideoList(HashMap paramHash, String 게시구분) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<mainBean> list = new ArrayList<mainBean>();
		
		try
		{
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT 기업코드                                                            \n");
            sQry.append("      , 법인코드                                                            \n");
            sQry.append("      , 브랜드코드                                                          \n");
            sQry.append("      , 게시번호                                                            \n");
            sQry.append("      , 제목                                                                \n");
            sQry.append("      , 내용                                                                \n");
            sQry.append("      , 조회수                                                              \n");
            sQry.append("      , 등록자                                                              \n");
            sQry.append("      , 등록일자                                                            \n");
            sQry.append("   FROM (                                                                   \n");
            sQry.append("         SELECT 기업코드                                                    \n");
            sQry.append("              , 법인코드                                                    \n");
            sQry.append("              , 브랜드코드                                                  \n");
            sQry.append("              , 게시번호                                                    \n");
            sQry.append("              , NVL(제목,'N/A') AS 제목                                                           \n");
            sQry.append("              , CASE WHEN LENGTH(NVL(내용,'N/A')) > 100 THEN SUBSTR(NVL(내용,'N/A'),1,100)||'...' \n");
            sQry.append("                     ELSE NVL(내용,'N/A')                                                         \n");
            sQry.append("                END 내용                                                    \n");
            sQry.append("              , 조회수                                                      \n");
            sQry.append("              , 등록자                                                      \n");
            sQry.append("              , TO_CHAR(등록일자,'YYYY-MM-DD') AS 등록일자                  \n");
            sQry.append("           FROM 게시등록정보  A                                             \n");
            sQry.append("          WHERE 1=1                                                         \n");
            sQry.append("    		 AND A.게시시작일자 <= to_char(sysdate,'YYYY-MM-DD')			 \n");		 
            sQry.append("    	 	 AND A.게시종료일자 >= to_char(sysdate,'YYYY-MM-DD')             \n");
            sQry.append("            AND 게시구분   = ?                                              \n");
            //sQry.append("          AND 기업코드   = ?                                              \n");  //90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
            //sQry.append("          AND 법인코드   = ?                                              \n");
            //sQry.append("          AND 브랜드코드 = ?                                              \n");
            sQry.append("            AND 삭제여부   = 'N'                                            \n");
            sQry.append("			 AND EXISTS ( SELECT 1 											 \n");	
            sQry.append("							FROM 게시배포정보  B							 \n");	
            sQry.append("						   WHERE B.기업코드   = ?                			 \n");                 
            sQry.append("							 AND B.법인코드   = ?                			 \n");                   
            sQry.append("							 AND B.브랜드코드 = ?                			 \n");                 
            sQry.append("							 AND B.매장코드   = ?                			 \n");                 
            //sQry.append("                          AND B.기업코드   = A.기업코드       			 \n");	//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)              
            //sQry.append("		                     AND B.법인코드   = A.법인코드       			 \n");              
            //sQry.append("                          AND B.브랜드코드 = A.브랜드코드     			 \n");            
            sQry.append("                            AND B.게시구분   = A.게시구분       			 \n");              
            sQry.append("                            AND B.게시번호   = A.게시번호       			 \n");
            sQry.append("																			 \n");
            sQry.append("					    )											         \n");
            sQry.append("          ORDER BY 게시번호 DESC                                            \n");
            sQry.append("      )                                                                     \n");
            sQry.append("  WHERE 1=1                                                                 \n");
            sQry.append("    AND ROWNUM < 6                                                          \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p , 게시구분);
        //  pstmt.setString(++p , 기업코드);
		//	pstmt.setString(++p , 법인코드);
		//	pstmt.setString(++p , 브랜드코드);
			pstmt.setString(++p , 기업코드);
			pstmt.setString(++p , 법인코드);
			pstmt.setString(++p , 브랜드코드);
			pstmt.setString(++p , 매장코드);
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			mainBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new mainBean(); 
                
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set게시번호  ((String)rs.getString("게시번호"  ));
                dataBean.set제목      ((String)rs.getString("제목"      ));
                dataBean.set내용      ((String)rs.getString("내용"      ));
                dataBean.set조회수    ((String)rs.getString("조회수"    ));
                dataBean.set등록자    ((String)rs.getString("등록자"    ));
                dataBean.set등록일자  ((String)rs.getString("등록일자"  ));
                

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
	 * 공지사항 및 교육자료 최근 5건 조회 List (관리자모드)
	 * @param 게시구분(01:공지사항,02:교육자료)
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<mainBean> selectNoticeAdminList(HashMap paramHash, String 게시구분) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<mainBean> list = new ArrayList<mainBean>();
		
		try
		{
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT 기업코드                                                            \n");
            sQry.append("      , 법인코드                                                            \n");
            sQry.append("      , 브랜드코드                                                          \n");
            sQry.append("      , 게시번호                                                            \n");
            sQry.append("      , 제목                                                                \n");
            sQry.append("      , 내용                                                                \n");
            sQry.append("      , 조회수                                                              \n");
            sQry.append("      , 등록자                                                              \n");
            sQry.append("      , 등록일자                                                            \n");
            sQry.append("   FROM (                                                                   \n");
            sQry.append("         SELECT 기업코드                                                    \n");
            sQry.append("              , 법인코드                                                    \n");
            sQry.append("              , 브랜드코드                                                  \n");
            sQry.append("              , 게시번호                                                    \n");
            sQry.append("              , NVL(제목,'N/A') AS 제목                                                           \n");
            sQry.append("              , CASE WHEN LENGTH(NVL(내용,'N/A')) > 100 THEN SUBSTR(NVL(내용,'N/A'),1,100)||'...' \n");
            sQry.append("                     ELSE NVL(내용,'N/A')                                                         \n");
            sQry.append("                END 내용                                                    \n");
            sQry.append("              , 조회수                                                      \n");
            sQry.append("              , 등록자                                                      \n");
            sQry.append("              , TO_CHAR(등록일자,'YYYY-MM-DD') AS 등록일자                  \n");
            sQry.append("           FROM 게시등록정보  A                                             \n");
            sQry.append("          WHERE 1=1                                                         \n");
            sQry.append("            AND 게시구분   = ?                                              \n");
            sQry.append("            AND 기업코드   = ?                                              \n");
            sQry.append("            AND 법인코드   = ?                                              \n");
            sQry.append("            AND 브랜드코드 = ?                                              \n");
            sQry.append("          ORDER BY 게시번호 DESC                                            \n");
            sQry.append("      )                                                                     \n");
            sQry.append("  WHERE 1=1                                                                 \n");
            sQry.append("    AND ROWNUM < 6                                                          \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p , 게시구분);
            pstmt.setString(++p , 기업코드);
			pstmt.setString(++p , 법인코드);
			pstmt.setString(++p , 브랜드코드);
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			mainBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new mainBean(); 
                
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set게시번호  ((String)rs.getString("게시번호"  ));
                dataBean.set제목      ((String)rs.getString("제목"      ));
                dataBean.set내용      ((String)rs.getString("내용"      ));
                dataBean.set조회수    ((String)rs.getString("조회수"    ));
                dataBean.set등록자    ((String)rs.getString("등록자"    ));
                dataBean.set등록일자  ((String)rs.getString("등록일자"  ));
                

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
	 * 매장건의사항 최근 5건 조회 List
	 * @param 건의요청구분(11:매장건의사항,12:매장요청사항)
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<mainBean> selectProposalList(HashMap paramHash, String 건의요청구분) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<mainBean> list = new ArrayList<mainBean>();
		
		try
		{
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT 기업코드                                                             \n");
            sQry.append("      , 법인코드                                                             \n");
            sQry.append("      , 브랜드코드                                                           \n");
            sQry.append("      , 건의요청번호                                                         \n");
            sQry.append("      , 제목                                                                 \n");
            sQry.append("      , 내용                                                                 \n");
            sQry.append("      , 조회수                                                               \n");
            sQry.append("      , 등록자                                                               \n");
            sQry.append("      , 등록일자                                                             \n");
            sQry.append("   FROM (                                                                    \n");
            sQry.append("         SELECT 기업코드                                                     \n");
            sQry.append("              , 법인코드                                                     \n");
            sQry.append("              , 브랜드코드                                                   \n");
            sQry.append("              , 건의요청번호                                                 \n");
            sQry.append("              , 제목                                                         \n");
            sQry.append("              , CASE WHEN LENGTH(내용) > 100 THEN SUBSTR(내용,1,100)||'...'  \n");
            sQry.append("                     ELSE 내용                                               \n");
            sQry.append("                END 내용                                                     \n");
            sQry.append("              , 조회수                                                       \n");
            sQry.append("              , 등록자                                                       \n");
            sQry.append("              , TO_CHAR(등록일자,'YYYY-MM-DD') AS 등록일자                   \n");
            sQry.append("           FROM 건의요청등록정보                                             \n");
            sQry.append("          WHERE 1=1                                                          \n");
            sQry.append("            AND 건의요청구분 = ?                                             \n");
            sQry.append("            AND 기업코드     = ?                                             \n");
            sQry.append("            AND 법인코드     = ?                                             \n");
            sQry.append("            AND 브랜드코드   = ?                                             \n");
            sQry.append("            AND 삭제여부     = 'N'                                           \n");
            sQry.append("          ORDER BY 건의요청번호 DESC                                         \n");
            sQry.append("      )                                                                      \n");
            sQry.append("  WHERE 1=1                                                                  \n");
            sQry.append("    AND ROWNUM < 6                                                           \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p , 건의요청구분);
            pstmt.setString(++p , 기업코드);
			pstmt.setString(++p , 법인코드);
			pstmt.setString(++p , 브랜드코드);
            
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			mainBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new mainBean(); 
                
                dataBean.set기업코드  ((String)rs.getString("기업코드"    ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"    ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"  ));
                dataBean.set게시번호  ((String)rs.getString("건의요청번호"));
                dataBean.set제목      ((String)rs.getString("제목"        ));
                dataBean.set내용      ((String)rs.getString("내용"        ));
                dataBean.set조회수    ((String)rs.getString("조회수"      ));
                dataBean.set등록자    ((String)rs.getString("등록자"      ));
                dataBean.set등록일자  ((String)rs.getString("등록일자"    ));
                

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
	 * Promotion 매장주문내역
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<mainBean> selectStoreOrderList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<mainBean> list = new ArrayList<mainBean>();
		
		try
		{
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));

			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	

			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";		
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            
            sQry.append(" select *                                                           \n");
            sQry.append("   from                                                             \n");
            sQry.append(" (                                                                  \n");
            sQry.append(" select row_number() over (order by a.주문일자 desc) as row_num     \n");
            sQry.append("      , a.기업코드                                                  \n");
            sQry.append("      , a.법인코드                                                  \n");
            sQry.append("      , a.브랜드코드                                                \n");
            sQry.append("      , a.매장코드                                                  \n");
            sQry.append("      , b.매장명                                                    \n");
            sQry.append("      , b.대표자명                                                  \n");
            sQry.append("      , a.주문번호                                                  \n");
            sQry.append("      , a.주문일자                                                  \n");
            sQry.append("      , a.홍보물코드                                                \n");
            sQry.append("      , a.홍보물번호                                                \n");
            sQry.append("      , a.홍보물명                                                  \n");
            sQry.append("      , a.주문사이즈                                                \n");
            sQry.append("      , a.주문수량                                                  \n");
            sQry.append("      , a.주문가격                                                  \n");
            sQry.append("      , a.주문상태                                                  \n");
            sQry.append("      , a.제작상태                                                  \n");
            sQry.append("      , a.시안번호                                                  \n");
            sQry.append("      , a.배송지번호                                                \n");
            sQry.append("      , a.배송요청사항                                              \n");
            sQry.append("      , a.택배사코드                                                \n");
            sQry.append("      , a.송장번호                                                  \n");
            sQry.append("      , a.등록일자                                                  \n");
            sQry.append("   from 홍보물주문정보 a                                            \n");
            sQry.append("      , 매장 b                                                      \n");
            sQry.append("  where 1=1                                                         \n");
            sQry.append("    and a.기업코드   = b.기업코드(+)                                \n");
            sQry.append("    and a.법인코드   = b.법인코드(+)                                \n");
            sQry.append("    and a.브랜드코드 = b.브랜드코드(+)                              \n");
            sQry.append("    and a.매장코드   = b.매장코드(+)                                \n");
            sQry.append("    and a.삭제여부   = 'N'                                          \n");
            sQry.append("    and nvl(a.주문상태,'00') <> '00'                                \n");
            sQry.append("    and a.기업코드   = ?                                            \n");
            sQry.append("    and a.법인코드   = ?                                            \n");
            sQry.append("    and a.브랜드코드 = ?                                            \n");
            if (srch_type.equals(""))
            {
            	sQry.append("    and ( a.매장명 like ? or b.대표자명 like ? )                \n");
            }
            else if (srch_type.equals("1"))
            {
            	sQry.append("    and a.매장명 like ?                                         \n");
            }
            else if (srch_type.equals("2"))
            {
            	sQry.append("    and a.대표자명 like ?                                       \n");
            }
            sQry.append("  order by a.주문일자 desc                                          \n");
            sQry.append(" )                                                                  \n");
            sQry.append(" where row_num >  ?                                                 \n");
            sQry.append("   and row_num <= ?                                                 \n");
            sQry.append(" order by 주문일자 desc                                             \n"); 

            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);

            if (srch_type.equals(""))
            {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            }
            else if (srch_type.equals("1"))
            {
                pstmt.setString(++p, srch_key);
            }
            else if (srch_type.equals("2"))
            {
                pstmt.setString(++p, srch_key);
            }
            
            pstmt.setInt(++p   , (inCurPage-1)*inRowPerPage);  // 페이지당 시작 글 범위
			pstmt.setInt(++p   , (inCurPage*inRowPerPage)  );  // 페이지당 끌 글 범위
			
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			mainBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new mainBean(); 

                dataBean.set기업코드   ((String)rs.getString("기업코드"));
                dataBean.set법인코드   ((String)rs.getString("법인코드"));
                dataBean.set브랜드코드 ((String)rs.getString("브랜드코드"));
                dataBean.set매장코드   ((String)rs.getString("매장코드"));
                dataBean.set매장명     ((String)rs.getString("매장명"));
                dataBean.set대표자명   ((String)rs.getString("대표자명"));
                dataBean.set주문번호   ((String)rs.getString("주문번호"));
                dataBean.set주문일자   ((String)rs.getString("주문일자"));
                dataBean.set홍보물코드 ((String)rs.getString("홍보물코드"));
                dataBean.set홍보물번호 ((String)rs.getString("홍보물번호"));
                dataBean.set홍보물명   ((String)rs.getString("홍보물명"));
                dataBean.set주문사이즈 ((String)rs.getString("주문사이즈"));
                dataBean.set주문수량   ((String)rs.getString("주문수량"));
                dataBean.set주문가격   ((String)rs.getString("주문가격"));
                dataBean.set주문상태   ((String)rs.getString("주문상태"));
                dataBean.set제작상태   ((String)rs.getString("제작상태"));
                dataBean.set시안번호   ((String)rs.getString("시안번호"));
                dataBean.set택배사코드 ((String)rs.getString("택배사코드"));
                dataBean.set송장번호   ((String)rs.getString("송장번호"));
                dataBean.set등록일자   ((String)rs.getString("등록일자"));
                

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
	 * 매장주문내역 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectStoreOrderCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));

			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	

			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";			
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" select COUNT(*)                               \n");
            sQry.append("   from 홍보물주문정보 a                       \n");
            sQry.append("      , 매장 b                                 \n");
            sQry.append("  where 1=1                                    \n");
            sQry.append("    and a.기업코드   = b.기업코드(+)           \n");
            sQry.append("    and a.법인코드   = b.법인코드(+)           \n");
            sQry.append("    and a.브랜드코드 = b.브랜드코드(+)         \n");
            sQry.append("    and a.매장코드   = b.매장코드(+)           \n");
            sQry.append("    and a.삭제여부   = 'N'                     \n");
            sQry.append("    and nvl(a.주문상태,'00') <> '00'           \n");
            sQry.append("    and a.기업코드   = ?                       \n");
            sQry.append("    and a.법인코드   = ?                       \n");
            sQry.append("    and a.브랜드코드 = ?                       \n");
            if (srch_type.equals(""))
            {
            	sQry.append("    and ( a.매장명 like ? or b.대표자명 like ? )   \n");
            }
            else if (srch_type.equals("1"))
            {
            	sQry.append("    and a.매장명 like ?                            \n");
            }
            else if (srch_type.equals("2"))
            {
            	sQry.append("    and a.대표자명 like ?                          \n");
            }
                        	
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            
            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);

            if (srch_type.equals(""))
            {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            }
            else if (srch_type.equals("1"))
            {
                pstmt.setString(++p, srch_key);
            }
            else if (srch_type.equals("2"))
            {
                pstmt.setString(++p, srch_key);
            }

            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
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