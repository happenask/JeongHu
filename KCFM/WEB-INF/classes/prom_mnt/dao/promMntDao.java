/** ############################################################### */
/** Program ID   : promMntDao.java                                  */
/** Program Name : 홍보물 관리(관리자)                       		*/
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package prom_mnt.dao;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import prom_mnt.beans.promMntBean;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;
import com.util.JSPUtil;

public class promMntDao {

	
	/**
	 * 콤보정보 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<promMntBean> selectComboList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<promMntBean> list = new ArrayList<promMntBean>();
		
		try
		{ 
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"));
			
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
            //sQry.append("   AND  A.법인코드   LIKE ?                                                                 \n"); //(02)
            //sQry.append("   AND  A.브랜드코드 LIKE ?                                                                 \n"); //(03)
			//--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
         
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //(01)
            //pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //(02)
            //pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  //(03)
            
			//--------------------------------------------------------------------------------------------------------
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			promMntBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new promMntBean(); 
                
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
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"));
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
            //sQry.append("   AND  A.법인코드   LIKE ?                                                                 \n"); //(02)
            //sQry.append("   AND  A.브랜드코드 LIKE ?                                                                 \n"); //(03)

            //--------------------------------------------------------------------------------------------------------
            // set preparedstatemen
			//--------------------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
        	pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //(01)
        	///pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //(02)
        	//pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  //(03)
            
			//--------------------------------------------------------------------------------------------------------

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
	
	/**
	 * 홍보물 상세정보 조회
	 * @param paramHash
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<promMntBean> selectList(HashMap paramHash) throws DAOException
	{
		Connection con 			= null;
		PreparedStatement pstmt = null;
		ResultSet rs 			= null;
		
		ArrayList<promMntBean> list = new ArrayList<promMntBean>();
		
		try
		{ 
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 7;
			
			//String 조회시작일자 = JSPUtil.chkNull((String)paramHash.get("조회시작일자"));
			//String 조회종료일자 = JSPUtil.chkNull((String)paramHash.get("조회종료일자"));
			String 기업코드   	= JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   	= JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 	= JSPUtil.chkNull((String)paramHash.get("브랜드코드"));			
			String 홍보물대분류 = JSPUtil.chkNull((String)paramHash.get("홍보물대분류"));
			String 홍보물코드   = JSPUtil.chkNull((String)paramHash.get("홍보물코드"));
			String 권한코드     = JSPUtil.chkNull((String)paramHash.get("권한코드"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT *																			  \n");
            sQry.append("  FROM (																		      \n");
            sQry.append("        SELECT ROW_NUMBER() OVER (ORDER BY A.기업코드,A.법인코드,A.브랜드코드,A.홍보물코드,A.홍보물번호) AS 순번	      \n");
            sQry.append("     , A.기업코드                                                                    \n");
            sQry.append("     , A.법인코드                                                                    \n");
            sQry.append("     , B.법인명                                                                      \n");
            sQry.append("     , A.브랜드코드                                                                  \n");
            sQry.append("     , C.브랜드명                                                                    \n");
            sQry.append("     , A.홍보물대분류                                              AS 대분류코드     \n");
            sQry.append("     , CD1.메뉴코드명                                              AS 대분류명       \n");
            sQry.append("     , A.홍보물코드                                                AS 중분류코드     \n");
            sQry.append("     , CD2.메뉴코드명                                              AS 중분류명       \n");
            sQry.append("     , A.홍보물번호                                                                  \n");
            sQry.append("     , A.홍보물명                                                                    \n");
            sQry.append("     , A.인쇄사용문구포함여부   													  \n");
            sQry.append("     , CD5.세부코드명                                              AS 홍보물타입     \n");
            sQry.append("     , TO_CHAR(A.수량,'FM999,999,999,999,990') ||CD3. 세부코드명   AS 주문단위       \n");
            //sQry.append("     , CD3. 세부코드명   AS 주문단위       \n");
            sQry.append("     , TO_CHAR(A.매출단가,'FM999,999,999,999,990')                 AS 단가           \n");
            sQry.append("     , A.이미지경로                                                                  \n");
            sQry.append("     , A.이미지앞면파일명                                                            \n");
            sQry.append("     , A.이미지뒷면파일명                                                            \n");
            sQry.append("     , A.홍보물업체코드                                                              \n");
            sQry.append("     , CD4.사용자명                                                AS 홍보물업체명   \n");
            sQry.append("     , A.등록자                                                                      \n");
            sQry.append(" FROM 홍보물마스터정보 A                                                             \n");
            sQry.append("      JOIN                                                                           \n");
            sQry.append("      법인 B                                                                         \n");
            sQry.append("      ON B.기업코드  = A.기업코드                                                    \n");
            sQry.append("      AND B.법인코드 = A.법인코드  												  \n");    
            sQry.append("      JOIN                                                                           \n");
            sQry.append("      브랜드 C                                                                       \n");
            sQry.append("      ON C.기업코드  = A.기업코드                                                    \n");
            sQry.append("      AND C.법인코드 = A.법인코드  												  \n");    
            sQry.append("      AND C.브랜드코드 = A.브랜드코드                                                 \n");
            sQry.append("      LEFT OUTER JOIN                                                                \n");
            sQry.append("      홍보물메뉴정보 CD1                                                             \n"); // 홍보물대분류코드
            sQry.append("      ON CD1.기업코드 = A.기업코드                                                   \n");
            sQry.append("      AND CD1.법인코드 = A.법인코드                                                  \n");
            sQry.append("      AND CD1.브랜드코드 = A.브랜드코드                                              \n");
            sQry.append("      AND CD1.메뉴코드 = A.홍보물대분류                                              \n");
            sQry.append("      AND CD1.메뉴유형 = 'FOLDER'                                                    \n");
            sQry.append("      AND CD1.사용여부 = 'Y'                                                         \n");
            sQry.append("      LEFT OUTER JOIN                                                                \n");
            sQry.append("      홍보물메뉴정보 CD2                                                             \n"); // 홍보물코드
            sQry.append("      ON CD2.기업코드 = A.기업코드                                                   \n");
            sQry.append("      AND CD2.법인코드 = A.법인코드                                                  \n");
            sQry.append("      AND CD2.브랜드코드 =  A.브랜드코드                                             \n");
            sQry.append("      AND CD2.메뉴코드 = A.홍보물코드                                                \n");
            sQry.append("      AND CD2.메뉴유형 = 'FILE'                                                      \n"); 
            sQry.append("      AND CD2.사용여부 = 'Y'                                                         \n");
            sQry.append("      LEFT OUTER JOIN                                                                \n");
            sQry.append("      PRM공통코드 CD3                                                                \n"); // 단위(주문단위)
            sQry.append("      ON CD3.분류코드 = '단위'                                                       \n");
            sQry.append("      AND CD3.세부코드= A.단위                                                       \n");
            sQry.append("      AND CD3.기업코드 = A.기업코드                                                  \n");
            sQry.append("	   AND CD3.사용여부 = 'Y' 														  \n");
            sQry.append("      LEFT OUTER JOIN															      \n");
            sQry.append("      사용자 CD4																	  \n");
            sQry.append("      ON CD4. 사용자ID = A.홍보물업체코드											  \n"); //홍보물업체
            sQry.append("      AND CD4. APP권한코드 = '41' 												      \n"); 
            sQry.append("	   LEFT OUTER JOIN																  \n");
            sQry.append("	   PRM공통코드 CD5																  \n");
            sQry.append("	   ON CD5. 세부코드 = A.인쇄사용문구포함여부									  \n");
            sQry.append("	   AND CD5.분류코드 = '인쇄사용문구포함여부'   									  \n");
            sQry.append("	   AND CD5.기업코드 = A.기업코드   									              \n");
            sQry.append("	   AND CD5.사용여부 = 'Y' 														  \n");
            sQry.append("WHERE 1=1                                                                            \n");
           // sQry.append("  AND A.등록일자 BETWEEN   ?  AND  ?												  \n");
            sQry.append("  AND A.기업코드 LIKE  ?                                                             \n");
            sQry.append("  AND A.법인코드 LIKE  ?                                                             \n");
            sQry.append("  AND A.브랜드코드 LIKE  ?                                                           \n");
            sQry.append("  AND A.홍보물대분류 LIKE ?                                                          \n");
            sQry.append("  AND A.홍보물코드 LIKE ?                                                            \n");
            sQry.append("  AND A.삭제여부 = 'N'                                                       		  \n");
            if(권한코드.equals("41")){ //홍보물업체인경우
            	sQry.append("  AND A.홍보물업체코드 = ?                                                     \n");
            }
            sQry.append("       )																			  \n");
            sQry.append(" WHERE  순번 >  ?																	  \n");
            sQry.append("   AND  순번 <= ?																	  \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            //pstmt.setString(++p, 조회시작일자);
            //pstmt.setString(++p, 조회종료일자);
            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);
            pstmt.setString(++p, 홍보물대분류);
            pstmt.setString(++p, 홍보물코드);
            if(권한코드.equals("41")){ //홍보물업체인경우
            	pstmt.setString(++p, JSPUtil.chkNull((String)paramHash.get("등록자ID")));
            }
            pstmt.setInt(++p   , (inCurPage-1)*inRowPerPage   );  // 페이지당 시작 글 범위
			pstmt.setInt(++p   , (inCurPage   *inRowPerPage)  );  // 페이지당 끌 글 범위
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			promMntBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new promMntBean(); 

                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set법인명((String)rs.getString("법인명"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set브랜드명((String)rs.getString("브랜드명"));
                dataBean.set대분류코드((String)rs.getString("대분류코드"));
                dataBean.set대분류명((String)rs.getString("대분류명"));
                dataBean.set중분류코드((String)rs.getString("중분류코드"));
                dataBean.set중분류명((String)rs.getString("중분류명"));
                dataBean.set홍보물번호((String)rs.getString("홍보물번호"));
                dataBean.set홍보물명((String)rs.getString("홍보물명"));
                dataBean.set홍보물타입((String)rs.getString("홍보물타입"));
                dataBean.set주문단위((String)rs.getString("주문단위"));
                dataBean.set단가((String)rs.getString("단가"));
                dataBean.set이미지경로((String)rs.getString("이미지경로"));
                dataBean.set이미지앞면파일명((String)rs.getString("이미지앞면파일명"));
                dataBean.set이미지뒷면파일명((String)rs.getString("이미지뒷면파일명"));
                dataBean.set홍보물업체코드((String)rs.getString("홍보물업체코드"));
                dataBean.set홍보물업체명((String)rs.getString("홍보물업체명"));
                dataBean.set등록자((String)rs.getString("등록자"));
                
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
	
	
	/** 검색 조건에 맞는 홍보물상세의 전체 레코드 수
	 * @param paramData : JSP페이지의 입력값들이 HashMap형태로 넘어옵니다. 
	 * @return totalCnt : 전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
	public int selectListCount(HashMap paramHash) throws Exception 
    {
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		
		try
		{ 
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 7;
			
			String 조회시작일자 = JSPUtil.chkNull((String)paramHash.get("조회시작일자"));
			String 조회종료일자 = JSPUtil.chkNull((String)paramHash.get("조회종료일자"));
			String 기업코드   	= JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   	= JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 	= JSPUtil.chkNull((String)paramHash.get("브랜드코드"));			
			String 홍보물대분류 = JSPUtil.chkNull((String)paramHash.get("홍보물대분류"));
			String 홍보물코드   = JSPUtil.chkNull((String)paramHash.get("홍보물코드"));
			String 권한코드     = JSPUtil.chkNull((String)paramHash.get("권한코드"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT COUNT(*)                                                  \n");
            sQry.append(" FROM 홍보물마스터정보 A                                         \n");
            sQry.append("WHERE 1=1							                              \n");
            //sQry.append("  AND A.등록일자 BETWEEN   ?  AND  ?							  \n");
            sQry.append("  AND A.기업코드 		LIKE ?                                    \n");
            sQry.append("  AND A.법인코드 		LIKE ?                                    \n");
            sQry.append("  AND A.브랜드코드 	LIKE ?                                    \n");
            sQry.append("  AND A.홍보물대분류 	LIKE ?                                    \n");
            sQry.append("  AND A.홍보물코드 	LIKE ?                                    \n");
            if(권한코드.equals("41")){ //홍보물업체인경우
            	sQry.append("  AND A.홍보물업체코드 = ?                                                     \n");
            }
            
         // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
           // pstmt.setString(++p, 조회시작일자);
           // pstmt.setString(++p, 조회종료일자);
            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);
            pstmt.setString(++p, 홍보물대분류);
            pstmt.setString(++p, 홍보물코드);
            if(권한코드.equals("41")){ //홍보물업체인경우
            	pstmt.setString(++p, JSPUtil.chkNull((String)paramHash.get("등록자ID")));
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
	
	/**
	 * 홍보물 상세 조회
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public promMntBean selectDetail(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		promMntBean dataBean = null;
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT A.기업코드                                                                    \n");
            sQry.append("     , A.법인코드                                                                    \n");
            sQry.append("     , B.법인명                                                                      \n");
            sQry.append("     , A.브랜드코드                                                                  \n");
            sQry.append("     , C.브랜드명                                                                    \n");
            sQry.append("     , A.홍보물대분류                                              AS 대분류코드     \n");
            sQry.append("     , CD1.메뉴코드명                                              AS 대분류명       \n");
            sQry.append("     , A.홍보물코드                                                AS 중분류코드     \n");
            sQry.append("     , CD2.메뉴코드명                                              AS 중분류명       \n");
            sQry.append("     , A.홍보물번호                                                AS 홍보물번호     \n");
            sQry.append("     , A.홍보물명                                                                    \n");
            sQry.append("     , A.인쇄사용문구포함여부   													  \n");
            sQry.append("     , CD5.세부코드명                                              AS 홍보물타입     \n");
            sQry.append("     , A.수량 														AS 수량           \n");
            sQry.append("     , A.단위												        AS 단위           \n");
            sQry.append("     , TO_CHAR(A.수량,'FM999,999,999,999,990') ||CD3. 세부코드명   AS 주문단위       \n");
            sQry.append("     , A.매출단가                                                  AS 매출단가       \n");
            sQry.append("     , TO_CHAR(A.매출단가,'FM999,999,999,999,990')                 AS 단가           \n");
            sQry.append("     , A.사이즈           															  \n");
            sQry.append("     , A.이미지경로                                                                  \n");
            sQry.append("     , A.이미지표지파일명                                                            \n");
            sQry.append("     , A.이미지앞면파일명                                                            \n");
            sQry.append("     , A.이미지뒷면파일명                                                            \n");
            sQry.append("     , A.홍보물업체코드                                                              \n");
            sQry.append("     , CD4.사용자명                                                AS 홍보물업체명   \n");
            sQry.append("     , A.홍보물업체전화번호                                                          \n");
            sQry.append("     , A.등록자                                                            		  \n");
            sQry.append(" FROM 홍보물마스터정보 A                                                             \n");
            sQry.append("      JOIN                                                                           \n");
            sQry.append("      법인 B                                                                         \n");
            sQry.append("      ON B.기업코드 = A.기업코드                                                     \n");
            sQry.append("      AND B.법인코드 = A.법인코드                                                     \n");
            sQry.append("      JOIN                                                                           \n");
            sQry.append("      브랜드 C                                                                       \n");
            sQry.append("      ON C.기업코드 = A.기업코드                                                     \n");
            sQry.append("      AND C.법인코드 = A.법인코드                                                     \n");
            sQry.append("      AND C.브랜드코드 = A.브랜드코드                                                 \n");
            sQry.append("      LEFT OUTER JOIN                                                                \n");
            sQry.append("      홍보물메뉴정보 CD1                                                             \n"); // 홍보물대분류코드
            sQry.append("      ON CD1.기업코드 = A.기업코드                                                   \n");
            sQry.append("      AND CD1.법인코드 = A.법인코드                                                  \n");
            sQry.append("      AND CD1.브랜드코드 = A.브랜드코드                                              \n");
            sQry.append("      AND CD1.메뉴코드 = A.홍보물대분류                                              \n");
            sQry.append("      AND CD1.메뉴유형 = 'FOLDER'                                                    \n");
            sQry.append("      AND CD1.사용여부 = 'Y'                                                         \n");
            sQry.append("      LEFT OUTER JOIN                                                                \n");
            sQry.append("      홍보물메뉴정보 CD2                                                             \n"); // 홍보물코드
            sQry.append("      ON CD2.기업코드 = A.기업코드                                                   \n");
            sQry.append("      AND CD2.법인코드 = A.법인코드                                                  \n");
            sQry.append("      AND CD2.브랜드코드 = A.브랜드코드                                              \n");
            sQry.append("      AND CD2.메뉴유형 = 'FILE'                                                      \n"); 
            sQry.append("      AND CD2.메뉴코드 = A.홍보물코드                                                \n");
            sQry.append("      AND CD2.사용여부 = 'Y'                                                         \n");
            sQry.append("      LEFT OUTER JOIN                                                                \n");
            sQry.append("      PRM공통코드 CD3                                                                \n"); // 단위(주문단위)
            sQry.append("      ON CD3.분류코드 = '단위'                                                       \n");
            sQry.append("      AND CD3.세부코드= A.단위                                                       \n");
            sQry.append("      AND CD3.기업코드 = A.기업코드                                                  \n");
            sQry.append("	   AND CD3.사용여부 = 'Y' 														  \n");
            sQry.append("      LEFT OUTER JOIN															      \n");
            sQry.append("      사용자 CD4																	  \n");
            sQry.append("      ON CD4. 사용자ID = A.홍보물업체코드											  \n"); //홍보물업체
            sQry.append("      AND CD4. APP권한코드 = '41' 												      \n"); 
            sQry.append("	   LEFT OUTER JOIN																  \n");
            sQry.append("	   PRM공통코드 CD5																  \n");
            sQry.append("	   ON CD5. 세부코드 = A.인쇄사용문구포함여부									  \n");
            sQry.append("	   AND CD5.분류코드 = '인쇄사용문구포함여부'   									  \n");
            sQry.append("	   AND CD5.기업코드 = A.기업코드   									              \n");
            sQry.append("	   AND CD5.사용여부 = 'Y' 														  \n");
            sQry.append("WHERE A.기업코드 = ?                                                         		  \n");
            sQry.append("  AND A.법인코드 = ?                                                         		  \n");
            sQry.append("  AND A.브랜드코드 = ?                                                      		  \n");
            sQry.append("  AND A.홍보물코드 = ?                                                        		  \n");
            sQry.append("  AND A.홍보물번호 = ?                                                      		  \n");
            sQry.append("  AND A.삭제여부 = 'N'                                                       		  \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("홍보물코드"));
            pstmt.setString(++p, (String)paramHash.get("홍보물번호"));
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            while( rs.next() )
            {
                dataBean = new promMntBean(); 
                
                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set법인명((String)rs.getString("법인명"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set브랜드명((String)rs.getString("브랜드명"));
                dataBean.set대분류코드((String)rs.getString("대분류코드"));
                dataBean.set대분류명((String)rs.getString("대분류명"));
                dataBean.set중분류코드((String)rs.getString("중분류코드"));
                dataBean.set중분류명((String)rs.getString("중분류명"));
                dataBean.set홍보물번호((String)rs.getString("홍보물번호"));
                dataBean.set홍보물명((String)rs.getString("홍보물명"));
                dataBean.set인쇄사용문구포함여부((String)rs.getString("인쇄사용문구포함여부"));
                dataBean.set홍보물타입((String)rs.getString("홍보물타입"));
                dataBean.set사이즈((String)rs.getString("사이즈"));
                dataBean.set수량((String)rs.getString("수량"));
                dataBean.set단위((String)rs.getString("단위"));
                dataBean.set주문단위((String)rs.getString("주문단위"));
                dataBean.set매출단가((String)rs.getString("매출단가"));
                dataBean.set단가((String)rs.getString("단가"));
                dataBean.set홍보물업체코드((String)rs.getString("홍보물업체코드"));
                dataBean.set홍보물업체명((String)rs.getString("홍보물업체명"));
                dataBean.set홍보물업체전화번호((String)rs.getString("홍보물업체전화번호"));
                dataBean.set이미지경로((String)rs.getString("이미지경로"));
                dataBean.set이미지표지파일명((String)rs.getString("이미지표지파일명"));
                dataBean.set이미지앞면파일명((String)rs.getString("이미지앞면파일명"));
                dataBean.set이미지뒷면파일명((String)rs.getString("이미지뒷면파일명"));
                dataBean.set등록자((String)rs.getString("등록자"));
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
	
	/**
	 * 홍보물 메뉴정보 조회
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<promMntBean> selectPromList(HashMap paramHash ) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<promMntBean> list = new ArrayList<promMntBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            
            sQry.append(" SELECT                                   \n");
            sQry.append(" *                                        \n");
            sQry.append(" FROM                                     \n");
            sQry.append(" (                                        \n");
            sQry.append("   SELECT                                 \n");
            sQry.append("       ROWNUM AS ROW_NUM                  \n");
            sQry.append("       , 기업코드                         \n");
            sQry.append("       , (SELECT 기업명 FROM 기업 WHERE 기업코드=A.기업코드 AND 사용여부='Y' AND 삭제여부='N') AS 기업명 \n");
            sQry.append("       , 법인코드                         \n");
            sQry.append("       , (SELECT 법인명 FROM 법인 WHERE 기업코드=A.기업코드 AND 법인코드=A.법인코드 AND 사용여부='Y' AND 삭제여부='N') AS 법인명 \n");
            sQry.append("       , 브랜드코드                       \n");
            sQry.append("       , (SELECT 브랜드명 FROM 브랜드 WHERE 기업코드=A.기업코드 AND 법인코드=A.법인코드 AND 브랜드코드=A.브랜드코드 AND 사용여부='Y' AND 삭제여부='N') AS 브랜드명    \n");
            sQry.append("       , 메뉴코드                         \n");
            sQry.append("       , 메뉴코드명                       \n");
            sQry.append("       , 메뉴URL                          \n");
            sQry.append("       , 메뉴레벨                         \n");
            sQry.append("       , 메뉴유형                         \n");
            sQry.append("       , 상위메뉴코드                     \n");
            sQry.append("       , 메뉴순서                         \n");
            sQry.append("       , 사용여부                         \n");
            sQry.append("       , 등록자                           \n");
            sQry.append("       , 등록일자                         \n");
            sQry.append("       , 예비문자                         \n");
            sQry.append("       , 예비숫자                         \n");
            sQry.append("       , 최종변경일시                     \n");
            sQry.append("   FROM  홍보물메뉴정보 A                 \n");
            sQry.append("   WHERE 사용여부 = 'Y'                   \n");
            sQry.append("     AND 메뉴유형 = 'FOLDER'              \n");
            sQry.append("     AND 기업코드   LIKE ?                \n");
            sQry.append("     AND 법인코드   LIKE ?                \n");
            sQry.append("     AND 브랜드코드 LIKE ?                \n");
            //sQry.append("     AND 메뉴코드   LIKE ?                \n");
            sQry.append(" )                                        \n");
            sQry.append(" ORDER BY 기업코드,법인코드,브랜드코드, 메뉴코드, 메뉴순서  \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  //(01)
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  //(02)
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );   //(03)
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			promMntBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new promMntBean(); 
                
                dataBean.setROW_NUM((String)rs.getString("ROW_NUM"));
                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set기업명((String)rs.getString("기업명"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set법인명((String)rs.getString("법인명"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set브랜드명((String)rs.getString("브랜드명"));
                dataBean.set메뉴코드((String)rs.getString("메뉴코드"));
                dataBean.set메뉴코드명((String)rs.getString("메뉴코드명"));
                dataBean.set메뉴URL((String)rs.getString("메뉴URL"));
                dataBean.set메뉴레벨((String)rs.getString("메뉴레벨"));
                dataBean.set메뉴유형((String)rs.getString("메뉴유형"));
                dataBean.set상위메뉴코드((String)rs.getString("상위메뉴코드"));
                dataBean.set메뉴순서((String)rs.getString("메뉴순서"));
                
                
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
	  * 중분류 코드리스트 조회
	  * @param paramHash
	  * @return
	  * @throws DAOException
	  */
	 public ArrayList<promMntBean> selectPromMiddleList(HashMap paramHash) throws DAOException
		{
			
			Connection con          = null;
			PreparedStatement pstmt = null;
			ResultSet rs            = null;
			
			ArrayList<promMntBean> list = new ArrayList<promMntBean>();
			
			try
			{ 
				con = DBConnect.getInstance().getConnection();
				
	            StringBuffer sQry = new StringBuffer();
	  
	            
	            sQry.append(" SELECT                                                                                                                                                                    \n");
	            sQry.append("        기업코드                                                                                                                                                           \n");
	            sQry.append("        ,(SELECT 기업명 FROM 기업 WHERE 기업코드=A.기업코드 AND 사용여부='Y' AND 삭제여부='N') AS 기업명                                                                   \n");
	            sQry.append("        ,법인코드                                                                                                                                                          \n");
	            sQry.append("        ,(SELECT 법인명 FROM 법인 WHERE 기업코드=A.기업코드 AND 법인코드=A.법인코드 AND 사용여부='Y' AND 삭제여부='N') AS 법인명                                           \n");
	            sQry.append("        ,브랜드코드                                                                                                                                                        \n");
	            sQry.append("        ,(SELECT 브랜드명 FROM 브랜드 WHERE 기업코드=A.기업코드 AND 법인코드=A.법인코드 AND 브랜드코드=A.브랜드코드 AND 사용여부='Y' AND 삭제여부='N') AS 브랜드명         \n");
	            sQry.append("        ,메뉴코드                                                                                                                                                          \n");
	            sQry.append("        ,메뉴코드명                                                                                                                                                        \n");
	            sQry.append("        ,메뉴URL                                                                                                                                                           \n");
	            sQry.append("        ,메뉴레벨                                                                                                                                                          \n");
	            sQry.append("        ,메뉴유형                                                                                                                                                          \n");
	            sQry.append("        ,상위메뉴코드                                                                                                                                                      \n");
	            sQry.append("        ,메뉴순서                                                                                                                                                          \n");
	            sQry.append("        ,사용여부                                                                                                                                                          \n");
	            sQry.append("        ,등록자                                                                                                                                                            \n");
	            sQry.append("        ,등록일자                                                                                                                                                          \n");
	            sQry.append("        ,예비문자                                                                                                                                                          \n");
	            sQry.append("        ,예비숫자                                                                                                                                                          \n");
	            sQry.append("        ,최종변경일시                                                                                                                                                      \n");
	            sQry.append("    FROM 홍보물메뉴정보 A                                                                                                                                                  \n");
	            sQry.append("    WHERE 사용여부 = 'Y'                                                                                                                                                   \n");
	            sQry.append("    AND 메뉴유형 = 'FILE'                                                                                                                                                  \n");
	            sQry.append("    AND 기업코드    LIKE ?                                                                                                                                                   \n");
	            sQry.append("    AND 법인코드    LIKE ?                                                                                                                                                   \n");
	            sQry.append("    AND 브랜드코드  LIKE ?                                                                                                                                                   \n");
	            sQry.append("    AND 상위메뉴코드 LIKE ?                                                                                                                                                   \n");
	            sQry.append("    ORDER BY 메뉴순서                                                                                                                                                      \n");
	            
	            // set preparedstatemen
	            int p=0;
	            
	            pstmt = new LoggableStatement(con, sQry.toString());
	            
	            pstmt.setString(++p, (String)paramHash.get("기업코드")      );  //(01)
	            pstmt.setString(++p, (String)paramHash.get("법인코드")      );  //(02)
	            pstmt.setString(++p, (String)paramHash.get("브랜드코드")     );  //(03)
	            pstmt.setString(++p, (String)paramHash.get("홍보물대분류")    );  //(04)
	            
	            
	            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
				
				rs = pstmt.executeQuery();
				
	            // make databean list
				promMntBean dataBean = null;
	            
	            while( rs.next() )
	            {
	                dataBean = new promMntBean(); 
	                
	                dataBean.set기업코드((String)rs.getString("기업코드"));
	                dataBean.set기업명((String)rs.getString("기업명"));
	                dataBean.set법인코드((String)rs.getString("법인코드"));
	                dataBean.set법인명((String)rs.getString("법인명"));
	                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
	                dataBean.set브랜드명((String)rs.getString("브랜드명"));
	                dataBean.set메뉴코드((String)rs.getString("메뉴코드"));
	                dataBean.set메뉴코드명((String)rs.getString("메뉴코드명"));	                
	                
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
		 * 법인코드로 기업코드 조회
		 * @param  
	     * @return
		 * @throws Exception
		 */
	    public String selectGropCd(HashMap paramHash) throws Exception 
	    {
	    	
	    	Connection con          = null;
			PreparedStatement pstmt = null;
			ResultSet rs            = null;
			
			String groupCd = "";
			 
			try 
			{
				con = DBConnect.getInstance().getConnection();
				
	            StringBuffer sQry = new StringBuffer();
	  
	            sQry.append(" SELECT 기업코드              \n");
	            sQry.append("   FROM 법인                  \n");
	            sQry.append("  WHERE 법인코드 =  ?         \n");
	            sQry.append("    AND 사용여부 = 'Y'        \n");
	            sQry.append("    AND 삭제여부 = 'N'        \n");
	            
	            // set preparedstatemen
	            int p=0;
	            
	            pstmt = new LoggableStatement(con, sQry.toString());
	            pstmt.setString(++p, (String)paramHash.get("법인코드"));
	            
	            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
	            
				rs = pstmt.executeQuery();
				 
				if(rs != null && rs.next()) groupCd = rs.getString(1);		
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
			
			return groupCd;
			
	    }
	    
	    
	 /**
	  * 기업코드로 법인코드 조회
	  * @param paramHash
	  * @return
	  * @throws DAOException
	  */
	public ArrayList<promMntBean> selectCompanyCd(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<promMntBean> list = new ArrayList<promMntBean>();
		
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT 법인코드              \n");
            sQry.append("      , 법인명                \n");
            sQry.append("   FROM 법인                  \n");
            sQry.append("  WHERE 기업코드 LIKE ?            \n");
            sQry.append("    AND 사용여부 = 'Y'          \n");
            sQry.append("    AND 삭제여부 = 'N'          \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("기업코드")      );  //(01)
            
	        //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			promMntBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new promMntBean(); 

                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set법인명((String)rs.getString("법인명"));
                
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
	  * 기업,법인코드로 브랜드 코드 조회
	  * @param paramHash
	  * @return
	  * @throws DAOException
	  */
	public ArrayList<promMntBean> selectBrandCd(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<promMntBean> list = new ArrayList<promMntBean>();
		
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT 브랜드코드              \n");
            sQry.append("      , 브랜드명                \n");
            sQry.append("   FROM 브랜드                  \n");
            sQry.append("  WHERE 기업코드 LIKE ?            \n");
            sQry.append("    AND 법인코드 LIKE ?            \n");
            sQry.append("    AND 사용여부 = 'Y'          \n");
            sQry.append("    AND 삭제여부 = 'N'          \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("기업코드")      );  //(01)
            pstmt.setString(++p, (String)paramHash.get("법인코드")      );  //(02)
            
	        System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			promMntBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new promMntBean(); 
                
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set브랜드명((String)rs.getString("브랜드명"));
                
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
	  * 홍보물제작업체 코드 조회
	  * @param paramHash
	  * @return
	  * @throws DAOException
	  */
	public ArrayList<promMntBean> selectPromtion(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<promMntBean> list = new ArrayList<promMntBean>();
		
		
		try
		{ 
			
		   String 권한코드     = JSPUtil.chkNull((String)paramHash.get("권한코드"));
			
		   con = DBConnect.getInstance().getConnection();
			
           StringBuffer sQry = new StringBuffer();
 
           sQry.append(" SELECT 사용자ID AS 홍보물업체코드  		\n");
           sQry.append("      , 사용자명 AS 홍보물업체명    		\n");
           sQry.append("      , 전화번호 AS 홍보물업체전화번호   	\n");
           sQry.append("   FROM 사용자                  			\n");
           sQry.append("  WHERE 1=1            			            \n");
           //sQry.append("    AND 기업코드 = ?            			\n");
           //sQry.append("    AND 법인코드 = ?            			\n");
           sQry.append("    AND APP권한코드 = '41'            		\n");
           sQry.append("    AND 사용여부 = 'Y'          			\n");
           sQry.append("    AND 삭제여부 = 'N'          			\n");
           if(권한코드.equals("41")){ //홍보물업체인경우
        	   sQry.append("   AND 사용자ID = ?                       \n");
           }
           
           // set preparedstatemen
           int p=0;
           
           pstmt = new LoggableStatement(con, sQry.toString());
           
           //pstmt.setString(++p, (String)paramHash.get("기업코드")      );  //(01)
           //pstmt.setString(++p, (String)paramHash.get("법인코드")      );  //(02)
           if(권한코드.equals("41")){ //홍보물업체인경우
          	pstmt.setString(++p, JSPUtil.chkNull((String)paramHash.get("등록자ID")));
           }
	       
           System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
           // make databean list
			promMntBean dataBean = null;
           
           while( rs.next() )
           {
               dataBean = new promMntBean(); 
               
               dataBean.set홍보물업체코드((String)rs.getString("홍보물업체코드"));
               dataBean.set홍보물업체명((String)rs.getString("홍보물업체명"));
               dataBean.set홍보물업체전화번호((String)rs.getString("홍보물업체전화번호"));
               
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
	  * 인쇄사용문구포함여부(홍보물타입) 코드 조회
	  * @param paramHash
	  * @return
	  * @throws DAOException
	 * @throws UnsupportedEncodingException 
	  */
	public ArrayList<promMntBean> selectCode(HashMap paramHash) throws Exception 
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<promMntBean> list = new ArrayList<promMntBean>();
		
		String 분류코드 = URLDecoder.decode((String)paramHash.get("분류코드"), "UTF-8");
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
          StringBuffer sQry = new StringBuffer();

          sQry.append(" SELECT 세부코드 	   		  \n");
          sQry.append("      , 세부코드명 	    	  \n");
          sQry.append("   FROM PRM공통코드            \n");
          sQry.append("  WHERE 기업코드 = ?           \n");
          sQry.append("    AND 분류코드 = ?           \n");
          sQry.append("    AND 사용여부 = 'Y'         \n");
          
          // set preparedstatemen
          int p=0;
          
          pstmt = new LoggableStatement(con, sQry.toString());
          
          pstmt.setString(++p, (String)paramHash.get("기업코드")      );  //(01)
          pstmt.setString(++p, 분류코드	  							  );  //(02)
	       
          //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
          // make databean list
			promMntBean dataBean = null;
          
          while( rs.next() )
          {
              dataBean = new promMntBean(); 
              
              dataBean.set세부코드((String)rs.getString("세부코드"));
              dataBean.set세부코드명((String)rs.getString("세부코드명"));
              
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
	 * 홍보물번호 채번
	 * @param  
     * @return
	 * @throws Exception
	 */
    public String selectPromSeq(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		String promSeq = "";
		 
		try 
		{
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT NVL(MAX(홍보물번호)+1,1) 	    \n");
            sQry.append("  FROM 홍보물마스터정보				\n");
            sQry.append(" WHERE 기업코드 = ?					\n");
            sQry.append("   AND 법인코드 = ?					\n");
            sQry.append("   AND 브랜드코드 = ?					\n");
            sQry.append("   AND 홍보물코드 = ?					\n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("홍보물코드"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) promSeq = rs.getString(1);		
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
		
		return promSeq;
		
    }
    
    
    /**
     * 홍보물 마스터정보 저장
     * @param paramData
     * @return
     * @throws DAOException
     */   
    public int insertWrite(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		ResultSet rs             = null;		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
           
			StringBuffer sQry = new StringBuffer();
			
			sQry.append(" INSERT INTO 홍보물마스터정보                                               \n");
			sQry.append(" (                                                                          \n");
			sQry.append("    기업코드                                                                \n");
			sQry.append("  , 법인코드                                                                \n");
			sQry.append("  , 브랜드코드                                                              \n");
			sQry.append("  , 홍보물코드                                                              \n");
			sQry.append("  , 홍보물번호                                                              \n");
			sQry.append("  , 홍보물대분류                                                            \n");
			sQry.append("  , 홍보물명                                                                \n");
			sQry.append("  , 이미지경로                                                              \n");
			sQry.append("  , 이미지표지파일명                                                        \n");
			sQry.append("  , 이미지앞면파일명                                                        \n");
			sQry.append("  , 이미지뒷면파일명                                                        \n");
			sQry.append("  , 사이즈                                                                  \n");
			sQry.append("  , 수량                                                                    \n");
			sQry.append("  , 단위                                                                    \n");
			sQry.append("  , 매입단가                                                                \n");
			sQry.append("  , 매출단가                                                                \n");
			sQry.append("  , 인쇄사용문구포함여부                                                    \n");
			sQry.append("  , 홍보물업체코드                                                          \n");
			sQry.append("  , 홍보물업체전화번호                                                      \n");
			sQry.append("  , 등록자                                                                  \n");
			sQry.append("  , 등록일자                                                                \n");
			sQry.append("  , 삭제여부                                                                \n");
			sQry.append("  , 수정자                                                                  \n");
			sQry.append("  , 수정일자                                                                \n");
			sQry.append("  , 예비문자                                                                \n");
			sQry.append("  , 예비숫자                                                                \n");
			sQry.append("  , 최종변경일시                                                            \n");
			sQry.append("  )                                                                         \n");
			sQry.append(" VALUES                                                                     \n");
			sQry.append(" (                                                                          \n");
			sQry.append("    ?                                         /* 기업코드 */                \n");
			sQry.append("  , ?                                         /* 법인코드 */                \n");
			sQry.append("  , ?                                         /* 브랜드코드 */              \n");
			sQry.append("  , ?                                         /* 홍보물코드 */              \n");
			sQry.append("  , ?                                         /* 홍보물번호 */              \n");
			sQry.append("  , ?                                         /* 홍보물대분류 */            \n");
			sQry.append("  , ?                                         /* 홍보물명 */                \n");
			sQry.append("  , ?                                         /* 이미지경로 */              \n");
			sQry.append("  , ?                                         /* 이미지표지파일명 */        \n");
			sQry.append("  , ?                                         /* 이미지앞면파일명 */        \n");
			sQry.append("  , ?                                         /* 이미지뒷면파일명 */        \n");
			sQry.append("  , ?                                         /* 사이즈 */                  \n");
			sQry.append("  , ?                                         /* 수량 */                    \n");
			sQry.append("  , ?                                         /* 단위 */                    \n");
			sQry.append("  , 0                                         /* 매입단가 */                \n");
			sQry.append("  , ?                                         /* 매출단가 */                \n");
			sQry.append("  , ?                                         /* 인쇄사용문구포함여부 */    \n");
			sQry.append("  , ?                                         /* 홍보물업체코드 */          \n");
			sQry.append("  , ?                                         /* 홍보물업체전화번호 */      \n");
			sQry.append("  , ?                                         /* 등록자 */                  \n");
			sQry.append("  , TO_CHAR(SYSDATE,'YYYY-MM-DD')             /* 등록일자 */                \n");
			sQry.append("  , 'N'                                       /* 삭제여부 */                \n");
			sQry.append("  , ''                                        /* 수정자 */                  \n");
			sQry.append("  , TO_CHAR(SYSDATE,'YYYY-MM-DD')             /* 수정일자 */                \n");
			sQry.append("  , ''                                        /* 예비문자 */                \n");
			sQry.append("  , 0                                         /* 예비숫자 */                \n");
			sQry.append("  , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') /* 최종변경일시 */            \n");
			sQry.append("  )                                                                         \n");      
						
			int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("기업코드")         );  //기업코드
            pstmt.setString(++i, (String)paramData.get("법인코드")             );  //법인코드
            pstmt.setString(++i, (String)paramData.get("브랜드코드")           );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("홍보물코드")           );  //홍보물코드
            pstmt.setString(++i, (String)paramData.get("홍보물번호")           );  //홍보물번호
            pstmt.setString(++i, (String)paramData.get("홍보물대분류")         );  //홍보물대분류
            pstmt.setString(++i, (String)paramData.get("홍보물명")             );  //홍보물명
            pstmt.setString(++i, (String)paramData.get("이미지경로")             );  //이미지경로
            pstmt.setString(++i, (String)paramData.get("이미지표지파일명")     );  //이미지표지파일명
            pstmt.setString(++i, (String)paramData.get("이미지앞면파일명")     );  //이미지앞면파일명
            pstmt.setString(++i, (String)paramData.get("이미지뒷면파일명")     );  //이미지뒷면파일명
            pstmt.setString(++i, (String)paramData.get("사이즈")               );  //사이즈
            pstmt.setString(++i, (String)paramData.get("수량")                 );  //수량
            pstmt.setString(++i, (String)paramData.get("단위")                 );  //단위
            pstmt.setString(++i, (String)paramData.get("매출단가")             );  //매출단가
            pstmt.setString(++i, (String)paramData.get("인쇄사용문구포함여부") );  //인쇄사용문구포함여부
            pstmt.setString(++i, (String)paramData.get("홍보물업체코드")       );  //홍보물업체코드
            pstmt.setString(++i, (String)paramData.get("홍보물업체전화번호")   );  //홍보물업체전화번호
            pstmt.setString(++i, (String)paramData.get("등록자")               );  //등록자
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
     * 홍보물정보 수정
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
			   
			String 이미지표지파일명 =  JSPUtil.chkNull((String)paramData.get("이미지표지파일명"));
			String 이미지앞면파일명 =  JSPUtil.chkNull((String)paramData.get("이미지앞면파일명"));
			String 이미지뒷면파일명 =  JSPUtil.chkNull((String)paramData.get("이미지뒷면파일명"));
			String mode1 =  JSPUtil.chkNull((String)paramData.get("mode1"));
			String mode2 =  JSPUtil.chkNull((String)paramData.get("mode2"));
			String mode3 =  JSPUtil.chkNull((String)paramData.get("mode3"));
            

			sQry.append("  UPDATE 홍보물마스터정보                                                 \n");
			sQry.append("  SET                                                                     \n");
			sQry.append("         홍보물명             = ?                                         \n");
			sQry.append("       , 이미지경로           = ?                                         \n");
			if(mode1.equals("Y")){
				 sQry.append("       , 이미지표지파일명     = ?                                    \n");
			}
			if(mode2.equals("Y")){
				sQry.append("       , 이미지앞면파일명     = ?                                     \n");
			}
			if(mode3.equals("Y")){
				sQry.append("       , 이미지뒷면파일명     = ?                                     \n");
			}
			sQry.append("       , 사이즈               = ?                                         \n");
			sQry.append("       , 수량                 = ?                                         \n");
			sQry.append("       , 단위                 = ?                                         \n");
			sQry.append("       , 매출단가             = ?                                         \n");
			sQry.append("       , 인쇄사용문구포함여부 = ?                                         \n");
			sQry.append("       , 홍보물업체코드       = ?                                         \n");
			sQry.append("       , 홍보물업체전화번호   = ?                                         \n");
			sQry.append("       , 수정자               = ?                                         \n");
			sQry.append("       , 수정일자             = TO_CHAR(SYSDATE,'YYYY-MM-DD')             \n");
			sQry.append("       , 최종변경일시         = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') \n");
			sQry.append("  WHERE 기업코드 = ?                                                      \n");
			sQry.append("    AND 법인코드 = ?                                                      \n");
			sQry.append("    AND 브랜드코드 = ?                                                    \n");
			sQry.append("    AND 홍보물코드 = ?                                                    \n");
			sQry.append("    AND 홍보물번호 = ?                                                    \n");
			//-------------------------------------------------------------------------------------------
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("홍보물명")             );  //홍보물명
            
            pstmt.setString(++i, (String)paramData.get("이미지경로")           );  //이미지경로
            if(mode1.equals("Y")){
            	pstmt.setString(++i, 이미지표지파일명);  //이미지표지파일명
            }
            if(mode2.equals("Y")){
            	pstmt.setString(++i,이미지앞면파일명);  //이미지앞면파일명
            }
            if(mode3.equals("Y")){
            	pstmt.setString(++i,이미지뒷면파일명);  //이미지뒷면파일명
            }
            pstmt.setString(++i, (String)paramData.get("사이즈")               );  //사이즈
            pstmt.setString(++i, (String)paramData.get("수량")                 );  //수량
            pstmt.setString(++i, (String)paramData.get("단위")                 );  //단위
            pstmt.setString(++i, (String)paramData.get("매출단가")             );  //매출단가
            pstmt.setString(++i, (String)paramData.get("인쇄사용문구포함여부") );  //인쇄사용문구포함여부
            pstmt.setString(++i, (String)paramData.get("홍보물업체코드")       );  //홍보물업체코드
            pstmt.setString(++i, (String)paramData.get("홍보물업체전화번호")   );  //홍보물업체전화번호
            pstmt.setString(++i, (String)paramData.get("등록자")               );  //등록자
            pstmt.setString(++i, (String)paramData.get("기업코드")             );  //기업코드
            pstmt.setString(++i, (String)paramData.get("법인코드")             );  //법인코드
            pstmt.setString(++i, (String)paramData.get("브랜드코드")           );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("홍보물코드")           );  //홍보물코드
            pstmt.setString(++i, (String)paramData.get("홍보물번호")           );  //홍보물번호
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            
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
     * 홍보물 삭제
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteWrite(HashMap paramData) throws DAOException
	{
    	Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			
			sQry.append("  UPDATE 홍보물마스터정보                                                  \n");
			sQry.append("  SET                                                                      \n");
			sQry.append("         삭제여부             = 'Y'                                         \n");
			sQry.append("       , 최종변경일시         = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')  \n");
			sQry.append("  WHERE 기업코드 = ?                                                       \n");
			sQry.append("    AND 법인코드 = ?                                                       \n");
			sQry.append("    AND 브랜드코드 = ?                                                     \n");
			sQry.append("    AND 홍보물코드 = ?                                                     \n");
			sQry.append("    AND 홍보물번호 = ?                                                     \n");
			
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++i, (String)paramData.get("기업코드")             );  //기업코드
            pstmt.setString(++i, (String)paramData.get("법인코드")             );  //법인코드
            pstmt.setString(++i, (String)paramData.get("브랜드코드")           );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("홍보물코드")           );  //홍보물코드
            pstmt.setString(++i, (String)paramData.get("홍보물번호")           );  //홍보물번호
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
