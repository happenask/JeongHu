/** ############################################################### */
/** Program ID   : testDao.java                                     */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package test.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

import test.beans.testBean;

import com.util.JSPUtil;

public class testDao 
{
	
	/**
	 * 공지사항 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<testBean> selectList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<testBean> list = new ArrayList<testBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
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
            sQry.append("       , 게시번호                                                   \n");
            sQry.append("       , 제목                                                       \n");
            sQry.append("       , 내용                                                       \n");
            sQry.append("       , 조회수                                                     \n");
            sQry.append("       , 등록자                                                     \n");
            sQry.append("       , to_char(등록일자,'YYYY-MM-DD') as 등록일자                 \n");
            sQry.append("   FROM 게시등록정보                                                \n");
            sQry.append("   WHERE 게시구분 = 1                                               \n");
            sQry.append("   AND  제목 LIKE ?                                                 \n");
            sQry.append(" )                                                                  \n");
            sQry.append(" WHERE  ROW_NUM >  ?                                                \n");
            sQry.append("   AND  ROW_NUM <= ?                                                \n");
            sQry.append(" ORDER BY 게시번호 DESC                                             \n");     

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, srch_key);
            pstmt.setInt(++p   , (inCurPage-1)*inRowPerPage);  // 페이지당 시작 글 범위
			pstmt.setInt(++p   , (inCurPage*inRowPerPage)  );  // 페이지당 끌 글 범위
            
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			testBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new testBean(); 
                
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"   )); 
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
	 * 검색 조건에 맞는 게시글 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectListCount(HashMap paramHash) throws Exception 
    {
    	
    	//System.out.println("Program Trace LOG >> Program_ID [ pj_7001Dao ], Function [ selectOrderCount() ]" + JSPUtil.getDateTimeHypen());
		
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 5;
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT COUNT(*)                                                   \n");
            sQry.append("   FROM 게시등록정보                                               \n");
            sQry.append("  WHERE 게시구분 = 1                                               \n");
            sQry.append("    AND 제목 LIKE ?                                                \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            pstmt.setString(++p, srch_key);  // 고객ID

			
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
     * 글 저장
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertWrite(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append(" INSERT INTO 게시등록정보     \n");
			sQry.append(" (                            \n");
			sQry.append(" 기업코드,                    \n");
			sQry.append(" 법인코드,                    \n");
			sQry.append(" 브랜드코드,                  \n");
			sQry.append(" 게시구분 ,                   \n");
			sQry.append(" 게시번호 ,                   \n");
			sQry.append(" 제목 ,                       \n");
			sQry.append(" 내용 ,                       \n");
			sQry.append(" 공지구분 ,                   \n");
			sQry.append(" 게시시작일자,                \n");
			sQry.append(" 게시종료일자 ,               \n");
			sQry.append(" 조회수,                      \n");
			sQry.append(" 등록자,                      \n");
			sQry.append(" 등록일자,                    \n");
			sQry.append(" 등록패스워드,                \n");
			sQry.append(" 삭제여부,                    \n");
			sQry.append(" 예비문자,                    \n");
			sQry.append(" 예비숫자,                    \n");
			sQry.append(" 최종변경일시                 \n");
			sQry.append(" ) VALUES (                   \n");
			sQry.append(" ?, --기업코드,               \n");
			sQry.append(" ?, --법인코드,               \n");
			sQry.append(" ?, --브랜드코드,             \n");
			sQry.append(" 1, --게시구분 ,              \n");
			sQry.append(" (SELECT MAX(게시번호)+1 FROM 게시등록정보), --게시번호 ,              \n");
			sQry.append(" ?, --제목 ,                  \n");
			sQry.append(" ?, --내용 ,                  \n");
			sQry.append(" '1', --공지구분 ,              \n");
			sQry.append(" SYSDATE, --게시시작일자,           \n");
			sQry.append(" SYSDATE, --게시종료일자,          \n");
			sQry.append(" 0, --조회수,                 \n");
			sQry.append(" ?, --등록자,                 \n");
			sQry.append(" SYSDATE, --등록일자,               \n");
			sQry.append(" '1234', --등록패스워드,           \n");
			sQry.append("'N', --삭제여부,               \n");
			sQry.append(" '', --예비문자,               \n");
			sQry.append(" '', --예비숫자,               \n");
			sQry.append(" SYSDATE --최종변경일시            \n");
			sQry.append(" )                            \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("groupCode")       );  //기업코드
            pstmt.setString(++i, (String)paramData.get("corpCode")        );  //법인코드
            pstmt.setString(++i, (String)paramData.get("brandCode")       );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("title")           );  //제목
            pstmt.setString(++i, (String)paramData.get("comment")         );  //글내용
            pstmt.setString(++i, (String)paramData.get("custLoginNm")     );  //등록자명
            
            list = pstmt.executeUpdate();
            
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
		
		return list;
            
	}
    
    
    
    /**
     * 게시판 글 정보보기
     * @param paramHash
     * @return
     * @throws DAOException
     */
    public ArrayList<testBean> selectBoardInfo(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<testBean> list = new ArrayList<testBean>();
		
		try
		{ 
						
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                          \n");
            sQry.append("     기업코드,                   \n"); 
            sQry.append("      법인코드,                  \n");  
            sQry.append("      브랜드코드,                \n");  
            sQry.append("      게시구분 ,                 \n");  
            sQry.append("      게시번호 ,                 \n");  
            sQry.append("      제목 ,                     \n");  
            sQry.append("      내용 ,                     \n");  
            sQry.append("      공지구분 ,                 \n");  
            sQry.append("      게시시작일자,              \n");  
            sQry.append("      게시종료일자 ,             \n");  
            sQry.append("      조회수,                    \n");  
            sQry.append("      등록자,                    \n");  
            sQry.append("      등록일자,                  \n");  
            sQry.append("      등록패스워드,              \n");  
            sQry.append("      삭제여부,                  \n");  
            sQry.append("      예비문자,                  \n");  
            sQry.append("      예비숫자,                  \n");  
            sQry.append("      최종변경일시               \n");
            sQry.append(" FROM 게시등록정보               \n");
            sQry.append(" WHERE 게시구분 = '1'            \n");
            sQry.append(" AND   게시번호 = ?              \n");  

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setInt(++p, Integer.parseInt((String)paramHash.get("seqNum"))); //글 번호
            
            
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
     * 글 수정
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateWrite(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 게시등록정보                                        \n");
			sQry.append("  SET    제목         = ?                                    \n");
			sQry.append("      ,  내용         = ?                                    \n");
			sQry.append("      ,  최종변경일시 = SYSDATE                              \n");
			sQry.append("   WHERE 기업코드     = ?                                    \n");
			sQry.append("        AND 법인코드  = ?                                    \n");
			sQry.append("        AND 브랜드코드= ?                                    \n");
			sQry.append("        AND 게시번호  = ?                                    \n");
			sQry.append("        AND 게시구분  = '1'                                  \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("title")           );  //제목
            pstmt.setString(++i, (String)paramData.get("comment")         );  //글내용
            
            pstmt.setString(++i, (String)paramData.get("groupCode")       );  //기업코드
            pstmt.setString(++i, (String)paramData.get("corpCode")        );  //법인코드
            pstmt.setString(++i, (String)paramData.get("brandCode")       );  //브랜드코드
            pstmt.setInt   (++i, Integer.parseInt((String)paramData.get("seqNum"))  );  //등록자명
            
            list = pstmt.executeUpdate();
            
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
		
		return list;
            
	}
    
    
	
}