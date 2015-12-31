/** ############################################################### */
/** Program ID   : commentDao.java                                  */
/** Program Name : 댓글관리                                         */
/** Program Desc : 댓글관리 Dao                                     */
/** Create Date  : 2015-04-14                                       */
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

import admin.beans.commentBean;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

import com.util.JSPUtil;

public class commentDao 
{
	
	/**
	 * 댓글내역 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<commentBean> selectCommentList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<commentBean> list = new ArrayList<commentBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 6;    // 10
			
			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 선언 및 정의
			//-------------------------------------------------------------------------------------------
			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"), "0");	

            //검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));
			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			System.out.println("srch_key : " + srch_key  );

			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			//-------------------------------------------------------------------------------------------
			
            System.out.println("##### DAO inCurPage [" + inCurPage + "]"  );
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT T.*                                                                             \n");
            sQry.append(" FROM ( SELECT ROW_NUMBER() OVER(ORDER BY T1.게시구분코드                               \n");
            sQry.append("                                        , T1.게시번호 DESC)      AS ROW_NUM             \n");
            sQry.append("             , T1.*                                                                     \n");
            sQry.append("        FROM ( SELECT A.기업코드                                 AS 기업코드            \n");
            sQry.append("                    , A.법인코드                                 AS 법인코드            \n");
            sQry.append("                    , A.브랜드코드                               AS 브랜드코드          \n");
            sQry.append("                    , NVL(B.매장코드, '9999')                    AS 매장코드            \n");
            sQry.append("                    , A.게시구분                                 AS 게시구분코드        \n");
            sQry.append("                    , NVL((SELECT MAX(세부코드명)                                       \n");
            sQry.append("                           FROM   PRM공통코드                                           \n");
            sQry.append("                           WHERE  기업코드 = A.기업코드                                 \n");
            sQry.append("                             AND  분류코드 =  '게시구분'                                \n");
            sQry.append("                             AND  세부코드 = A.게시구분                                 \n");
            sQry.append("                          ), 'NA')                               AS 게시구분            \n");
            sQry.append("                    , A.게시번호                                 AS 게시번호            \n");
            sQry.append("                    , A.제목                                     AS 제목                \n");
            sQry.append("                    , A.등록자                                   AS 등록자              \n");
            sQry.append("                    , TO_CHAR(A.등록일자, 'YYYY-MM-DD')          AS 등록일자            \n");
            sQry.append("                    , A.등록패스워드                             AS 등록패스워드        \n");
            sQry.append("                    , NVL(B.댓글번호,  0)                        AS 댓글번호            \n");
            sQry.append("                    , NVL(B.등록자  , '')                        AS 댓글등록자          \n");
            sQry.append("                    , NVL(TO_CHAR(B.등록일자, 'YYYY.MM.DD'), '') AS 댓글등록일자        \n");
            sQry.append("                    , REPLACE(NVL(B.내용    , ''), '<BR>', CHR(13))                     \n");
            sQry.append("                                                                 AS 댓글내용            \n");
            sQry.append("                    , FNC_COMMENT_STATUS_INFO(A.기업코드                                \n");
            sQry.append("                                             ,A.법인코드                                \n");
            sQry.append("                                             ,A.브랜드코드                              \n");
            sQry.append("                                             ,A.게시구분                                \n");
            sQry.append("                                             ,A.게시번호)        AS 상태                \n");
            sQry.append("               FROM   게시등록정보        A                                             \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      게시댓글정보        B                                             \n");
            sQry.append("                       ON 1=1						                                     \n");
        //  sQry.append("                      AND B.기업코드   = A.기업코드                                     \n");  //90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
        //  sQry.append("                      AND B.법인코드   = A.법인코드                                     \n");
        //  sQry.append("                      AND B.브랜드코드 = A.브랜드코드                                   \n");
            sQry.append("                      AND B.게시구분   = A.게시구분                                     \n");
            sQry.append("                      AND B.게시번호   = A.게시번호                                     \n");
            sQry.append("                      AND B.댓글번호   = FNC_MAX_NO('게시댓글정보'                      \n");
            sQry.append("                                                   , A.기업코드                         \n");
            sQry.append("                                                   , A.법인코드                         \n");
            sQry.append("                                                   , A.브랜드코드                       \n");
            sQry.append("                                                   , ''                                 \n");
            sQry.append("                                                   , A.게시구분                         \n");
            sQry.append("                                                   , A.게시번호)                        \n");
            sQry.append("                      AND B.삭제여부   = 'N'                                            \n");
            sQry.append("               WHERE  A.기업코드       =  ?                                             \n");
            sQry.append("                 AND  A.법인코드       =  ?                                             \n");
            sQry.append("                 AND  A.게시구분    LIKE  ?                                             \n");
            sQry.append("                 AND  A.게시구분      IN('01','02')                                     \n");
            sQry.append("                 AND  A.등록일자 BETWEEN  ?                                             \n");
            sQry.append("                                     AND  ?                                             \n");
            sQry.append("                 AND  A.삭제여부       = 'N'                                            \n");
			//-------------------------------------------------------------------------------------------------------
            if (srch_type.equals("title")) {
                sQry.append(" AND  A.제목          LIKE ?                                                        \n");
            } else if(srch_type.equals("content")) {
                sQry.append(" AND  NVL(B.내용, '') LIKE ?                                                        \n");
            } else if(srch_type.equals("writer")) {
                sQry.append(" AND  A.등록자   LIKE ?                                                             \n");
            } else {
                sQry.append(" AND (A.제목 LIKE ? OR NVL(B.내용, '') LIKE ? OR A.등록자 LIKE ? )                  \n");
            }
			//-------------------------------------------------------------------------------------------------------
            sQry.append("               UNION ALL                                                                \n");
            sQry.append("               SELECT A.기업코드                                 AS 기업코드            \n");
            sQry.append("                    , A.법인코드                                 AS 법인코드            \n");
            sQry.append("                    , A.브랜드코드                               AS 브랜드코드          \n");
            sQry.append("                    , A.매장코드                                 AS 매장코드            \n");
            sQry.append("                    , A.건의요청구분                             AS 게시구분코드        \n");
            sQry.append("                    , NVL((SELECT MAX(세부코드명)                                       \n");
            sQry.append("                           FROM   PRM공통코드                                           \n");
            sQry.append("                           WHERE  기업코드 = A.기업코드                                 \n");
            sQry.append("                             AND  분류코드 =  '건의요청구분'                            \n");
            sQry.append("                             AND  세부코드 = A.건의요청구분                             \n");
            sQry.append("                          ), 'NA')                               AS 게시구분            \n");
            sQry.append("                    , A.건의요청번호                             AS 게시번호            \n");
            sQry.append("                    , A.제목                                     AS 제목                \n");
            sQry.append("                    , A.등록자                                   AS 등록자              \n");
            sQry.append("                    , TO_CHAR(A.등록일자, 'YYYY-MM-DD')          AS 등록일자            \n");
            sQry.append("                    , A.등록패스워드                             AS 등록패스워드        \n");
            sQry.append("                    , NVL(B.댓글번호,  0)                        AS 댓글번호            \n");
            sQry.append("                    , NVL(B.등록자  , '')                        AS 댓글등록자          \n");
            sQry.append("                    , NVL(TO_CHAR(B.등록일자, 'YYYY.MM.DD'), '') AS 댓글등록일자        \n");
            sQry.append("                    , REPLACE(NVL(B.내용    , ''), '<BR>', CHR(13))                     \n");
            sQry.append("                                                                 AS 댓글내용            \n");
            sQry.append("                    , FNC_COMMENT_STATUS_INFO(A.기업코드                                \n");
            sQry.append("                                             ,A.법인코드                                \n");
            sQry.append("                                             ,A.브랜드코드                              \n");
            sQry.append("                                             ,A.건의요청구분                            \n");
            sQry.append("                                             ,A.건의요청번호                            \n");
            sQry.append("                                             ,A.매장코드)        AS 상태                \n");
            sQry.append("               FROM   건의요청등록정보     A                                            \n");
            sQry.append("                      LEFT OUTER JOIN                                                   \n");
            sQry.append("                      건의요청댓글정보     B                                            \n");
            sQry.append("                       ON B.기업코드     = A.기업코드                                   \n"); 
            sQry.append("                      AND B.법인코드     = A.법인코드                                   \n");
            sQry.append("                      AND B.브랜드코드   = A.브랜드코드                                 \n");
            sQry.append("                      AND B.매장코드     = A.매장코드                                   \n");
            sQry.append("                      AND B.건의요청구분 = A.건의요청구분                               \n");
            sQry.append("                      AND B.건의요청번호 = A.건의요청번호                               \n");
            sQry.append("                      AND B.댓글번호     = FNC_MAX_NO('건의요청댓글정보'                \n");
            sQry.append("                                                      , A.기업코드                      \n");
            sQry.append("                                                      , A.법인코드                      \n");
            sQry.append("                                                      , A.브랜드코드                    \n");
            sQry.append("                                                      , A.매장코드                      \n");
            sQry.append("                                                      , A.건의요청구분                  \n");
            sQry.append("                                                      , A.건의요청번호)                 \n");
            sQry.append("                      AND B.삭제여부    = 'N'                                           \n");
            sQry.append("               WHERE  A.기업코드        =  ?                                            \n");
            sQry.append("                 AND  A.법인코드        =  ?                                            \n");
            sQry.append("                 AND  A.건의요청구분 LIKE  ?                                            \n");
            sQry.append("                 AND  A.건의요청구분   IN('11', '12')                                   \n");
            sQry.append("                 AND  A.등록일자  BETWEEN  ?                                            \n");
            sQry.append("                                      AND  ?                                            \n");
            sQry.append("                 AND  A.삭제여부        = 'N'                                           \n");
			//-------------------------------------------------------------------------------------------------------
            if (srch_type.equals("title")) {
                sQry.append(" AND  A.제목          LIKE ?                                                        \n");
            } else if(srch_type.equals("content")) {
                sQry.append(" AND  NVL(B.내용, '') LIKE ?                                                        \n");
            } else if(srch_type.equals("writer")) {
                sQry.append(" AND  A.등록자   LIKE ?                                                             \n");
            } else {
                sQry.append(" AND (A.제목 LIKE ? OR NVL(B.내용, '') LIKE ? OR A.등록자 LIKE ? )                  \n");
            }
			//-------------------------------------------------------------------------------------------------------
            sQry.append("             ) T1                                                                       \n");
            sQry.append("      ) T                                                                               \n");
            sQry.append(" WHERE  T.ROW_NUM >  ?                                                                  \n");
            sQry.append("   AND  T.ROW_NUM <= ?                                                                  \n");
            sQry.append(" ORDER BY T.게시구분코드                                                                \n");
            sQry.append("        , T.게시번호     DESC                                                           \n");

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
			//-------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  
            pstmt.setString(++p, (String)paramHash.get("조회구분")        );  
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );  
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );  
			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 조립 (게시등록정보)
			//-------------------------------------------------------------------------------------------
            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }
			//-------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  
            pstmt.setString(++p, (String)paramHash.get("조회구분")        );  
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );  
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );  
			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 조립 (건의요청등록정보)
			//-------------------------------------------------------------------------------------------
            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }
			//-------------------------------------------------------------------------------------------
            pstmt.setInt(++p   , (inCurPage-1)*inRowPerPage   );  // 페이지당 시작 글 범위
			pstmt.setInt(++p   , (inCurPage   *inRowPerPage)  );  // 페이지당 끌 글 범위
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			commentBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new commentBean(); 
                
                dataBean.setROW_NUM       ((String)rs.getString("ROW_NUM"       )); 
                dataBean.set기업코드      ((String)rs.getString("기업코드"      ));
                dataBean.set법인코드      ((String)rs.getString("법인코드"      ));
                dataBean.set브랜드코드    ((String)rs.getString("브랜드코드"    ));
                dataBean.set매장코드      ((String)rs.getString("매장코드"      ));
                dataBean.set게시구분코드  ((String)rs.getString("게시구분코드"  ));
                dataBean.set게시구분      ((String)rs.getString("게시구분"      ));
                dataBean.set게시번호      ((String)rs.getString("게시번호"      ));
                dataBean.set제목          ((String)rs.getString("제목"          ));
                dataBean.set등록자        ((String)rs.getString("등록자"        ));
                dataBean.set등록일자      ((String)rs.getString("등록일자"      ));
                dataBean.set등록패스워드  ((String)rs.getString("등록패스워드"  ));
                dataBean.set댓글번호      ((String)rs.getString("댓글번호"      ));
                dataBean.set댓글등록자    ((String)rs.getString("댓글등록자"    ));
                dataBean.set댓글등록일자  ((String)rs.getString("댓글등록일자"  ));
                dataBean.set댓글내용      ((String)rs.getString("댓글내용"      ));
                dataBean.set상태          ((String)rs.getString("상태"          ));

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
	 * 검색 조건에 맞는 댓글내역의 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectCommentListCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			
			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 선언 및 정의
			//-------------------------------------------------------------------------------------------
			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"), "0");	

            //검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));
			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			System.out.println("srch_key : " + srch_key  );

			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			//-------------------------------------------------------------------------------------------
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append(" SELECT SUM(T.ROW_CNT)                                                           \n");
            sQry.append(" FROM ( SELECT COUNT(*)                                   AS ROW_CNT             \n");
            sQry.append("        FROM   게시등록정보        A                                             \n");
            sQry.append("               LEFT OUTER JOIN                                                   \n");
            sQry.append("               게시댓글정보        B                                             \n");
            sQry.append("                ON 1=1						                                      \n");
        //  sQry.append("               AND B.기업코드   = A.기업코드                                     \n");  //90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
        //  sQry.append("               AND B.법인코드   = A.법인코드                                     \n");
        //  sQry.append("               AND B.브랜드코드 = A.브랜드코드                                   \n");
            sQry.append("               AND B.게시구분   = A.게시구분                                     \n");
            sQry.append("               AND B.게시번호   = A.게시번호                                     \n");
            sQry.append("               AND B.댓글번호   = FNC_MAX_NO('게시댓글정보'                      \n");
            sQry.append("                                            , A.기업코드                         \n");
            sQry.append("                                            , A.법인코드                         \n");
            sQry.append("                                            , A.브랜드코드                       \n");
            sQry.append("                                            , ''                                 \n");
            sQry.append("                                            , A.게시구분                         \n");
            sQry.append("                                            , A.게시번호)                        \n");
            sQry.append("               AND B.삭제여부   = 'N'                                            \n");
            sQry.append("        WHERE  A.기업코드       =  ?                                             \n");
            sQry.append("          AND  A.법인코드       =  ?                                             \n");
            sQry.append("          AND  A.게시구분    LIKE  ?                                             \n");
            sQry.append("          AND  A.게시구분      IN('01','02')                                     \n");
            sQry.append("          AND  A.등록일자 BETWEEN  ?                                             \n");
            sQry.append("                              AND  ?                                             \n");
            sQry.append("          AND  A.삭제여부       = 'N'                                            \n");
			//------------------------------------------------------------------------------------------------
            if (srch_type.equals("title")) {
                sQry.append(" AND  A.제목          LIKE ?                                                 \n");
            } else if(srch_type.equals("content")) {
                sQry.append(" AND  NVL(B.내용, '') LIKE ?                                                 \n");
            } else if(srch_type.equals("writer")) {
                sQry.append(" AND  A.등록자   LIKE ?                                                      \n");
            } else {
                sQry.append(" AND (A.제목 LIKE ? OR NVL(B.내용, '') LIKE ? OR A.등록자 LIKE ? )           \n");
            }
			//------------------------------------------------------------------------------------------------
            sQry.append("        UNION ALL                                                                \n");
            sQry.append("        SELECT COUNT(*)                                   AS ROW_CNT             \n");
            sQry.append("        FROM   건의요청등록정보     A                                            \n");
            sQry.append("               LEFT OUTER JOIN                                                   \n");
            sQry.append("               건의요청댓글정보     B                                            \n");
            sQry.append("                ON B.기업코드     = A.기업코드                                   \n");
            sQry.append("               AND B.법인코드     = A.법인코드                                   \n");
            sQry.append("               AND B.브랜드코드   = A.브랜드코드                                 \n");
            sQry.append("               AND B.매장코드     = A.매장코드                                   \n");
            sQry.append("               AND B.건의요청구분 = A.건의요청구분                               \n");
            sQry.append("               AND B.건의요청번호 = A.건의요청번호                               \n");
            sQry.append("               AND B.댓글번호     = FNC_MAX_NO('건의요청댓글정보'                \n");
            sQry.append("                                               , A.기업코드                      \n");
            sQry.append("                                               , A.법인코드                      \n");
            sQry.append("                                               , A.브랜드코드                    \n");
            sQry.append("                                               , A.매장코드                      \n");
            sQry.append("                                               , A.건의요청구분                  \n");
            sQry.append("                                               , A.건의요청번호)                 \n");
            sQry.append("               AND B.삭제여부    = 'N'                                           \n");
            sQry.append("        WHERE  A.기업코드        =  ?                                            \n");
            sQry.append("          AND  A.법인코드        =  ?                                            \n");
            sQry.append("          AND  A.건의요청구분 LIKE  ?                                            \n");
            sQry.append("          AND  A.건의요청구분   IN('11', '12')                                   \n");
            sQry.append("          AND  A.등록일자  BETWEEN  ?                                            \n");
            sQry.append("                               AND  ?                                            \n");
            sQry.append("          AND  A.삭제여부        = 'N'                                           \n");
			//------------------------------------------------------------------------------------------------
            if (srch_type.equals("title")) {
                sQry.append(" AND  A.제목          LIKE ?                                                 \n");
            } else if(srch_type.equals("content")) {
                sQry.append(" AND  NVL(B.내용, '') LIKE ?                                                 \n");
            } else if(srch_type.equals("writer")) {
                sQry.append(" AND  A.등록자   LIKE ?                                                      \n");
            } else {
                sQry.append(" AND (A.제목 LIKE ? OR NVL(B.내용, '') LIKE ? OR A.등록자 LIKE ? )           \n");
            }
			//------------------------------------------------------------------------------------------------
            sQry.append("      ) T                                                                        \n");
            sQry.append(" WHERE  1 = 1                                                                    \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
			//-------------------------------------------------------------------------------------------
            //pstmt.setString(++p, srch_key);  // 고객ID
			//-------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  
            pstmt.setString(++p, (String)paramHash.get("조회구분")        );  
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );  
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );  
			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 조립 (게시등록정보)
			//-------------------------------------------------------------------------------------------
            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }
			//-------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  
            pstmt.setString(++p, (String)paramHash.get("조회구분")        );  
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );  
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );  
			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 조립 (건의요청등록정보)
			//-------------------------------------------------------------------------------------------
            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }
			//-------------------------------------------------------------------------------------------

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
	 * 댓글상세내역 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<commentBean> selectCommentDetail(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<commentBean> list = new ArrayList<commentBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 6;    // 10
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
            // System.out.println("##### DAO inCurPage [" + inCurPage + "]"  );
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT T.*                                                                         \n");
            sQry.append(" FROM ( SELECT ROW_NUMBER() OVER(ORDER BY T1.댓글번호 DESC)  AS ROW_NUM             \n");
            sQry.append("             , T1.*                                                                 \n");
            sQry.append("        FROM ( SELECT A.기업코드                             AS 기업코드            \n");
            sQry.append("                    , A.법인코드                             AS 법인코드            \n");
            sQry.append("                    , A.브랜드코드                           AS 브랜드코드          \n");
            sQry.append("                    , A.매장코드                             AS 매장코드            \n");
            sQry.append("                    , NVL(B.매장명, 'N/A')                   AS 매장명              \n");
            sQry.append("                    , A.게시구분                             AS 게시구분            \n");
            sQry.append("                    , A.게시번호                             AS 게시번호            \n");
            sQry.append("                    , A.댓글번호                             AS 댓글번호            \n");
            sQry.append("                    , A.내용                                 AS 댓글내용            \n");
            sQry.append("                    , A.등록자                               AS 댓글등록자          \n");
            sQry.append("                    , TO_CHAR(A.등록일자, 'YYYY-MM-DD')      AS 댓글등록일자        \n");
            sQry.append("               FROM   게시댓글정보   A                                              \n");
            sQry.append("                      LEFT OUTER JOIN                                               \n");
            sQry.append("                      매장           B                                              \n");
            sQry.append("                       ON B.기업코드   = A.기업코드                                 \n");
            sQry.append("                      AND B.법인코드   = A.법인코드                                 \n");
            sQry.append("                      AND B.브랜드코드 = A.브랜드코드                               \n");
            sQry.append("                      AND B.매장코드   = A.매장코드                                 \n");
            sQry.append("               WHERE  A.기업코드   = ?                                              \n");
            sQry.append("                 AND  A.법인코드   = ?                                              \n");
            sQry.append("                 AND  A.브랜드코드 = ?                                              \n");
            sQry.append("                 AND  A.게시구분   = ?                                              \n");
            sQry.append("                 AND  A.게시번호   = ?                                              \n");
            sQry.append("                 AND  A.삭제여부   = 'N'                                            \n");
            sQry.append("               UNION ALL                                                            \n");
            sQry.append("               SELECT A.기업코드                             AS 기업코드            \n");
            sQry.append("                    , A.법인코드                             AS 법인코드            \n");
            sQry.append("                    , A.브랜드코드                           AS 브랜드코드          \n");
            sQry.append("                    , A.매장코드                             AS 매장코드            \n");
            sQry.append("                    , NVL(B.매장명, 'N/A')                   AS 매장명              \n");
            sQry.append("                    , A.건의요청구분                         AS 게시구분            \n");
            sQry.append("                    , A.건의요청번호                         AS 게시번호            \n");
            sQry.append("                    , A.댓글번호                             AS 댓글번호            \n");
            sQry.append("                    , A.내용                                 AS 댓글내용            \n");
            sQry.append("                    , A.등록자                               AS 댓글등록자          \n");
            sQry.append("                    , TO_CHAR(A.등록일자, 'YYYY-MM-DD')      AS 댓글등록일자        \n");
            sQry.append("               FROM   건의요청댓글정보 A                                            \n");
            sQry.append("                      LEFT OUTER JOIN                                               \n");
            sQry.append("                      매장           B                                              \n");
            sQry.append("                       ON B.기업코드   = A.기업코드                                 \n");
            sQry.append("                      AND B.법인코드   = A.법인코드                                 \n");
            sQry.append("                      AND B.브랜드코드 = A.브랜드코드                               \n");
            sQry.append("                      AND B.매장코드   = A.매장코드                                 \n");
            sQry.append("               WHERE  A.기업코드     = ?                                            \n");
            sQry.append("                 AND  A.법인코드     = ?                                            \n");
            sQry.append("                 AND  A.브랜드코드   = ?                                            \n");
            sQry.append("                 AND  A.매장코드     = ?                                            \n");
            sQry.append("                 AND  A.건의요청구분 = ?                                            \n");
            sQry.append("                 AND  A.건의요청번호 = ?                                            \n");
            sQry.append("                 AND  A.삭제여부     = 'N'                                          \n");
            sQry.append("              ) T1                                                                  \n");
            sQry.append("      ) T                                                                           \n");
            sQry.append(" WHERE  T.ROW_NUM >  ?                                                              \n");
            sQry.append("   AND  T.ROW_NUM <= ?                                                              \n");
            sQry.append(" ORDER BY T.댓글번호     DESC                                                       \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            //pstmt.setString(++p, srch_key);
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );  
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );  
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  
            pstmt.setString(++p, (String)paramHash.get("매장코드")        );  
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );  
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );  
            pstmt.setInt(++p   , (inCurPage-1)*inRowPerPage   );  // 페이지당 시작 글 범위
			pstmt.setInt(++p   , (inCurPage   *inRowPerPage)  );  // 페이지당 끌 글 범위
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			commentBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new commentBean(); 
                
                dataBean.setROW_NUM       ((String)rs.getString("ROW_NUM"       )); 
                dataBean.set기업코드      ((String)rs.getString("기업코드"      ));
                dataBean.set법인코드      ((String)rs.getString("법인코드"      ));
                dataBean.set브랜드코드    ((String)rs.getString("브랜드코드"    ));
                dataBean.set매장코드      ((String)rs.getString("매장코드"      ));
                dataBean.set매장명        ((String)rs.getString("매장명"        ));
                dataBean.set게시구분      ((String)rs.getString("게시구분"      ));
                dataBean.set게시번호      ((String)rs.getString("게시번호"      ));
                dataBean.set댓글번호      ((String)rs.getString("댓글번호"      ));
                dataBean.set댓글내용      ((String)rs.getString("댓글내용"      ));
                dataBean.set댓글등록자    ((String)rs.getString("댓글등록자"    ));
                dataBean.set댓글등록일자  ((String)rs.getString("댓글등록일자"  ));

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
	 * 검색 조건에 맞는 댓글상세내역의 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectCommentDetailCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append(" SELECT SUM(T.ROW_CNT)                                                       \n");
            sQry.append(" FROM ( SELECT COUNT(*)                               AS ROW_CNT             \n");
            sQry.append("        FROM   게시댓글정보   A                                              \n");
            sQry.append("        WHERE  A.기업코드   = ?                                              \n");
            sQry.append("          AND  A.법인코드   = ?                                              \n");
            sQry.append("          AND  A.브랜드코드 = ?                                              \n");
            sQry.append("          AND  A.게시구분   = ?                                              \n");
            sQry.append("          AND  A.게시번호   = ?                                              \n");
            sQry.append("          AND  A.삭제여부   = 'N'                                            \n");
            sQry.append("        UNION ALL                                                            \n");
            sQry.append("        SELECT COUNT(*)                               AS ROW_CNT             \n");
            sQry.append("        FROM   건의요청댓글정보 A                                            \n");
            sQry.append("        WHERE  A.기업코드     = ?                                            \n");
            sQry.append("          AND  A.법인코드     = ?                                            \n");
            sQry.append("          AND  A.브랜드코드   = ?                                            \n");
            sQry.append("          AND  A.매장코드     = ?                                            \n");
            sQry.append("          AND  A.건의요청구분 = ?                                            \n");
            sQry.append("          AND  A.건의요청번호 = ?                                            \n");
            sQry.append("          AND  A.삭제여부     = 'N'                                          \n");
            sQry.append("       ) T                                                                   \n");
            sQry.append(" WHERE 1 = 1                                                                 \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            //pstmt.setString(++p, srch_key);  // 고객ID
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );  
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );  
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );  
            pstmt.setString(++p, (String)paramHash.get("매장코드")        );  
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );  
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );  

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
     * 댓글관리 등록처리
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertComment(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;

		System.out.println("##### insert Comment ###### \n" );
		
		String v_GESI_GB = JSPUtil.chkNull((String)paramData.get("게시구분"));
		
		System.out.println(">>>>>>>>> 게시구분 [" + v_GESI_GB + "]"  );
		
		int RowCnt = 0;

		int i = 0;

		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            if (v_GESI_GB.equals("01") || v_GESI_GB.equals("02") ) {            // 01:공지사항, 02:교육자료

            	System.out.println(">>>>>>>>> 게시구분 (then) [" + v_GESI_GB + "]"  );

                sQry.append(" INSERT INTO 게시댓글정보                                              \n"); 
                sQry.append("      ( 기업코드                                                       \n"); 
                sQry.append("      , 법인코드                                                       \n"); 
                sQry.append("      , 브랜드코드                                                     \n"); 
                sQry.append("      , 게시구분                                                       \n"); 
                sQry.append("      , 게시번호                                                       \n"); 
                sQry.append("      , 매장코드                                                       \n"); 
                sQry.append("      , 댓글번호                                                       \n"); 
                sQry.append("      , 내용                                                           \n"); 
                sQry.append("      , 공개여부                                                       \n"); 
                sQry.append("      , 등록자                                                         \n"); 
                sQry.append("      , 등록일자                                                       \n"); 
                sQry.append("      , 등록패스워드                                                   \n"); 
                sQry.append("      , 삭제여부                                                       \n"); 
                sQry.append("      , 예비문자                                                       \n"); 
                sQry.append("      , 예비숫자                                                       \n"); 
                sQry.append("      , 최종변경일시                                                   \n"); 
                sQry.append("      )                                                                \n"); 
                sQry.append(" VALUES                                                                \n"); 
                sQry.append("      ( ?                                                              \n");   //(01)기업코드
                sQry.append("      , ?                                                              \n");   //(02)법인코드
                sQry.append("      , ?                                                              \n");   //(03)브랜드코드
                sQry.append("      , ?                                                              \n");   //(04)게시구분
                sQry.append("      , ?                                                              \n");   //(05)게시번호
                sQry.append("      , NVL(?, 'N/A')                                                  \n");   //(06)매장코드
                sQry.append("      , FNC_BOARD_COMMENT_SEQ_NO(?                                     \n");   //(07)기업코드
                sQry.append("                                ,?                                     \n");   //(08)법인코드
                sQry.append("                                ,?                                     \n");   //(09)브랜드코드
                sQry.append("                                ,?                                     \n");   //(10)게시구분
                sQry.append("                                ,?)                                    \n");   //(11)게시번호
                sQry.append("      , REPLACE(?, CHR(13), '<BR>')                                    \n");   //(12)내용
                sQry.append("      , 'Y'                                                            \n");   //(xx)공개여부
                sQry.append("      , ?                                                              \n");   //(13)등록자
                sQry.append("      , TO_CHAR(SYSDATE, 'YYYY-MM-DD')                                 \n");   //(xx)등록일자
                sQry.append("      , '1234'                                                         \n");   //(xx)등록패스워드
                sQry.append("      , 'N'                                                            \n");   //(xx)삭제여부
                sQry.append("      , ''                                                             \n");   //(xx)예비문자
                sQry.append("      , 0                                                              \n");   //(xx)예비숫자
                sQry.append("      , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')                      \n");   //(xx)최종변경일시
                sQry.append("      )                                                                \n");

                //-----------------------------------------------------------------------------------------
                //   Interface 항목 Setting
                //-----------------------------------------------------------------------------------------
                
                pstmt = new LoggableStatement(con, sQry.toString());
                
                pstmt.setString(++i, (String)paramData.get("기업코드")    );  //(01)기업코드 
                pstmt.setString(++i, (String)paramData.get("법인코드")    );  //(02)법인코드
                pstmt.setString(++i, (String)paramData.get("브랜드코드")  );  //(03)브랜드코드
                pstmt.setString(++i, (String)paramData.get("게시구분")    );  //(04)게시구분
                pstmt.setString(++i, (String)paramData.get("게시번호")    );  //(05)게시번호
                pstmt.setString(++i, (String)paramData.get("매장코드")    );  //(06)매장코드
                pstmt.setString(++i, (String)paramData.get("기업코드")    );  //(07) 기업코드
                pstmt.setString(++i, (String)paramData.get("법인코드")    );  //(08)법인코드
                pstmt.setString(++i, (String)paramData.get("브랜드코드")  );  //(09)브랜드코드
                pstmt.setString(++i, (String)paramData.get("게시구분")    );  //(10)게시구분
                pstmt.setString(++i, (String)paramData.get("게시번호")    );  //(11)게시번호
                pstmt.setString(++i, (String)paramData.get("댓글내용")    );  //(12)내용
                pstmt.setString(++i, (String)paramData.get("등록자")      );  //(13)등록자

                System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );

                RowCnt = pstmt.executeUpdate();
                //-----------------------------------------------------------------------------------------
            } else {
            	System.out.println(">>>>>>>>> 게시구분 (else) [" + v_GESI_GB + "]"  );

                sQry.append(" INSERT INTO 건의요청댓글정보                                          \n");   
                sQry.append("      ( 기업코드                                                       \n");   
                sQry.append("      , 법인코드                                                       \n");   
                sQry.append("      , 브랜드코드                                                     \n");   
                sQry.append("      , 매장코드                                                       \n");   
                sQry.append("      , 건의요청구분                                                   \n");   
                sQry.append("      , 건의요청번호                                                   \n");   
                sQry.append("      , 댓글번호                                                       \n");   
                sQry.append("      , 내용                                                           \n");   
                sQry.append("      , 공개여부                                                       \n");   
                sQry.append("      , 등록자                                                         \n");   
                sQry.append("      , 등록일자                                                       \n");   
                sQry.append("      , 등록패스워드                                                   \n");   
                sQry.append("      , 삭제여부                                                       \n");   
                sQry.append("      , 수정자                                                         \n");   
                sQry.append("      , 수정일자                                                       \n");   
                sQry.append("      , 예비문자                                                       \n");   
                sQry.append("      , 예비숫자                                                       \n");   
                sQry.append("      , 최종변경일시                                                   \n");   
                sQry.append("      )                                                                \n");   
                sQry.append(" VALUES                                                                \n");   
                sQry.append("      ( ?                                                              \n");   //(01)기업코드
                sQry.append("      , ?                                                              \n");   //(02)법인코드
                sQry.append("      , ?                                                              \n");   //(03)브랜드코드
                sQry.append("      , NVL(?, 'N/A')                                                  \n");   //(04)매장코드
                sQry.append("      , ?                                                              \n");   //(05)게시구분
                sQry.append("      , ?                                                              \n");   //(06)게시번호
                sQry.append("      , FNC_REQUEST_COMMENT_SEQ_NO(?                                   \n");   //(07)기업코드
                sQry.append("                                  ,?                                   \n");   //(08)법인코드
                sQry.append("                                  ,?                                   \n");   //(09)브랜드코드
                sQry.append("                                  ,NVL(?, 'N/A')                       \n");   //(10)매장코드
                sQry.append("                                  ,?                                   \n");   //(11)게시구분
                sQry.append("                                  ,?)                                  \n");   //(12)게시번호
                sQry.append("      , REPLACE(?, CHR(13), '<BR>')                                    \n");   //(13)내용
                sQry.append("      , 'Y'                                                            \n");   //(xx)공개여부
                sQry.append("      , ?                                                              \n");   //(14)등록자
                sQry.append("      , TO_CHAR(SYSDATE, 'YYYY-MM-DD')                                 \n");   //(xx)등록일자
                sQry.append("      , '1234'                                                         \n");   //(xx)등록패스워드
                sQry.append("      , 'N'                                                            \n");   //(xx)삭제여부
                sQry.append("      , ''                                                             \n");   //(xx)수정자
                sQry.append("      , '1900-01-01'                                                   \n");   //(xx)수정일자
                sQry.append("      , ''                                                             \n");   //(xx)예비문자
                sQry.append("      , 0                                                              \n");   //(xx)예비숫자
                sQry.append("      , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')                      \n");   //(xx)최종변경일시
                sQry.append("      )                                                                \n");   
                
                //-----------------------------------------------------------------------------------------
                //   Interface 항목 Setting
                //-----------------------------------------------------------------------------------------
                //int i = 0;
                
                pstmt = new LoggableStatement(con, sQry.toString());
                
                pstmt.setString(++i, (String)paramData.get("기업코드")    );  //(01)기업코드 
                pstmt.setString(++i, (String)paramData.get("법인코드")    );  //(02)법인코드
                pstmt.setString(++i, (String)paramData.get("브랜드코드")  );  //(03)브랜드코드
                pstmt.setString(++i, (String)paramData.get("매장코드")    );  //(04)매장코드
                pstmt.setString(++i, (String)paramData.get("게시구분")    );  //(05)게시구분
                pstmt.setString(++i, (String)paramData.get("게시번호")    );  //(06)게시번호
                pstmt.setString(++i, (String)paramData.get("기업코드")    );  //(07) 기업코드
                pstmt.setString(++i, (String)paramData.get("법인코드")    );  //(08)법인코드
                pstmt.setString(++i, (String)paramData.get("브랜드코드")  );  //(09)브랜드코드
                pstmt.setString(++i, (String)paramData.get("매장코드")    );  //(10)배장코드
                pstmt.setString(++i, (String)paramData.get("게시구분")    );  //(11)게시구분
                pstmt.setString(++i, (String)paramData.get("게시번호")    );  //(12)게시번호
                pstmt.setString(++i, (String)paramData.get("댓글내용")    );  //(13)내용
                pstmt.setString(++i, (String)paramData.get("등록자")      );  //(14)등록자

                System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
                
                RowCnt = pstmt.executeUpdate();
                //-----------------------------------------------------------------------------------------
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
     * 댓글관리 수정처리
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateComment(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;

		System.out.println("##### update Comment ###### \n" );
		
		String v_GESI_GB = JSPUtil.chkNull((String)paramData.get("게시구분"));
		
		System.out.println(">>>>>>>>> 게시구분 [" + v_GESI_GB + "]"  );
		
		int RowCnt = 0;

		int i = 0;

		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            if (v_GESI_GB.equals("01") || v_GESI_GB.equals("02") ) {            // 01:공지사항, 02:교육자료

            	System.out.println(">>>>>>>>> 게시구분 (then) [" + v_GESI_GB + "]"  );

            	sQry.append(" UPDATE 게시댓글정보                                                                                                    \n");
                sQry.append("    SET 내용         = REPLACE(?, CHR(13), '<BR>')                        \n");
                sQry.append("      , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')          \n");
                sQry.append(" WHERE  기업코드     = ?                                                  \n");
                sQry.append("   AND  법인코드     = ?                                                  \n");
                sQry.append("   AND  브랜드코드   = ?                                                  \n");
                sQry.append("   AND  매장코드     = ?                                                  \n");
                sQry.append("   AND  게시구분     = ?                                                  \n");
                sQry.append("   AND  게시번호     = ?                                                  \n");
                sQry.append("   AND  댓글번호     = ?                                                  \n");

                //-----------------------------------------------------------------------------------------
                //   Interface 항목 Setting
                //-----------------------------------------------------------------------------------------
                
                pstmt = new LoggableStatement(con, sQry.toString());
                
                pstmt.setString(++i, (String)paramData.get("댓글내용")    ); 
                pstmt.setString(++i, (String)paramData.get("기업코드")    );
                pstmt.setString(++i, (String)paramData.get("법인코드")    );
                pstmt.setString(++i, (String)paramData.get("브랜드코드")  );
                pstmt.setString(++i, (String)paramData.get("매장코드")    );
                pstmt.setString(++i, (String)paramData.get("게시구분")    );
                pstmt.setString(++i, (String)paramData.get("게시번호")    );
                pstmt.setString(++i, (String)paramData.get("댓글번호")    );

                System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );

                RowCnt = pstmt.executeUpdate();
                //-----------------------------------------------------------------------------------------
            } else {
            	System.out.println(">>>>>>>>> 게시구분 (else) [" + v_GESI_GB + "]"  );

            	sQry.append(" UPDATE 건의요청댓글정보                                                  \n");
                sQry.append("    SET 내용         = REPLACE(?, CHR(13), '<BR>')                        \n");
                sQry.append("      , 수정자       = ?                                                  \n");
                sQry.append("      , 수정일자     = TO_CHAR(SYSDATE, 'YYYY-MM-DD')                     \n");
                sQry.append("      , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')          \n");
                sQry.append(" WHERE  기업코드     = ?                                                  \n");
                sQry.append("   AND  법인코드     = ?                                                  \n");
                sQry.append("   AND  브랜드코드   = ?                                                  \n");
                sQry.append("   AND  매장코드     = ?                                                  \n");
                sQry.append("   AND  건의요청구분 = ?                                                  \n");
                sQry.append("   AND  건의요청번호 = ?                                                  \n");
                sQry.append("   AND  댓글번호     = ?                                                  \n");
                
                //-----------------------------------------------------------------------------------------
                //   Interface 항목 Setting
                //-----------------------------------------------------------------------------------------
                //int i = 0;
                
                pstmt = new LoggableStatement(con, sQry.toString());
                
                pstmt.setString(++i, (String)paramData.get("댓글내용")    ); 
                pstmt.setString(++i, (String)paramData.get("수정자")       );
                pstmt.setString(++i, (String)paramData.get("기업코드")    );
                pstmt.setString(++i, (String)paramData.get("법인코드")    );
                pstmt.setString(++i, (String)paramData.get("브랜드코드")  );
                pstmt.setString(++i, (String)paramData.get("매장코드")    );
                pstmt.setString(++i, (String)paramData.get("게시구분")    );
                pstmt.setString(++i, (String)paramData.get("게시번호")    );
                pstmt.setString(++i, (String)paramData.get("댓글번호")    );

                System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
                
                RowCnt = pstmt.executeUpdate();
                //-----------------------------------------------------------------------------------------
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
     * 댓글관리 삭제처리
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteComment(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;

		System.out.println("##### delete Comment ###### \n" );
		
		String v_GESI_GB = JSPUtil.chkNull((String)paramData.get("게시구분"));

		System.out.println(">>>>>>>>> 게시구분 [" + v_GESI_GB + "]"  );
		
		int RowCnt = 0;
        int i = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            if (v_GESI_GB.equals("01") || v_GESI_GB.equals("02") ) {            // 01:공지사항, 02:교육자료
                sQry.append(" UPDATE 게시댓글정보                                                                                                    \n");
                sQry.append("    SET 삭제여부     = 'Y'                                                \n");
                sQry.append("      , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')          \n");
                sQry.append(" WHERE  기업코드     = ?                                                  \n");
                sQry.append("   AND  법인코드     = ?                                                  \n");
                sQry.append("   AND  브랜드코드   = ?                                                  \n");
                sQry.append("   AND  매장코드     = ?                                                  \n");
                sQry.append("   AND  게시구분     = ?                                                  \n");
                sQry.append("   AND  게시번호     = ?                                                  \n");
                sQry.append("   AND  댓글번호     = ?                                                  \n");

                //-----------------------------------------------------------------------------------------
                //   Interface 항목 Setting
                //-----------------------------------------------------------------------------------------
                
                pstmt = new LoggableStatement(con, sQry.toString());
                
                pstmt.setString(++i, (String)paramData.get("기업코드")    );
                pstmt.setString(++i, (String)paramData.get("법인코드")    );
                pstmt.setString(++i, (String)paramData.get("브랜드코드")  );
                pstmt.setString(++i, (String)paramData.get("매장코드")    );
                pstmt.setString(++i, (String)paramData.get("게시구분")    );
                pstmt.setString(++i, (String)paramData.get("게시번호")    );
                pstmt.setString(++i, (String)paramData.get("댓글번호")    );

                System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
                
                RowCnt = pstmt.executeUpdate();
                //-----------------------------------------------------------------------------------------
            } else {
                sQry.append(" UPDATE 건의요청댓글정보                                                  \n");
                sQry.append("    SET 삭제여부     = 'Y'                                                \n");
                sQry.append("      , 수정자       = ?                                                  \n");
                sQry.append("      , 수정일자     = TO_CHAR(SYSDATE, 'YYYY-MM-DD')                     \n");
                sQry.append("      , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')          \n");
                sQry.append(" WHERE  기업코드     = ?                                                  \n");
                sQry.append("   AND  법인코드     = ?                                                  \n");
                sQry.append("   AND  브랜드코드   = ?                                                  \n");
                sQry.append("   AND  매장코드     = ?                                                  \n");
                sQry.append("   AND  건의요청구분 = ?                                                  \n");
                sQry.append("   AND  건의요청번호 = ?                                                  \n");
                sQry.append("   AND  댓글번호     = ?                                                  \n");
                
                //-----------------------------------------------------------------------------------------
                //   Interface 항목 Setting
                //-----------------------------------------------------------------------------------------
                //int i = 0;
                
                pstmt = new LoggableStatement(con, sQry.toString());
                
                pstmt.setString(++i, (String)paramData.get("수정자")       );
                pstmt.setString(++i, (String)paramData.get("기업코드")    );
                pstmt.setString(++i, (String)paramData.get("법인코드")    );
                pstmt.setString(++i, (String)paramData.get("브랜드코드")  );
                pstmt.setString(++i, (String)paramData.get("매장코드")    );
                pstmt.setString(++i, (String)paramData.get("게시구분")    );
                pstmt.setString(++i, (String)paramData.get("게시번호")    );
                pstmt.setString(++i, (String)paramData.get("댓글번호")    );

                System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
                
                RowCnt = pstmt.executeUpdate();
                //-----------------------------------------------------------------------------------------
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
	 * 검색 조건에 맞는 댓글상세내역 조회 (팝업에서 사용)
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<commentBean> commentDetail(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<commentBean> list = new ArrayList<commentBean>();
		
		try
		{ 
			
			//-------------------------------------------------------------------------------------------
            System.out.println("##### commentDetail ####"  );
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT T.제목                           AS 제목                           \n");
            sQry.append("      , T.내용                           AS 내용                           \n");
            sQry.append(" FROM ( SELECT 제목                                                        \n");
            sQry.append("             , 내용                                                        \n");
            sQry.append("        FROM   게시등록정보                                                \n");
            sQry.append("        WHERE  기업코드     =  ?                                           \n"); //(01)기업코드
            sQry.append("          AND  법인코드     =  ?                                           \n"); //(02)법인코드
            sQry.append("          AND  브랜드코드   =  ?                                           \n"); //(03)브랜드코드
            sQry.append("          AND  게시구분     =  ?                                           \n"); //(04)게시구분
            sQry.append("          AND  게시번호     =  ?                                           \n"); //(05)게시번호
            sQry.append("          AND  삭제여부     = 'N'                                          \n");
            sQry.append("        UNION ALL                                                          \n");
            sQry.append("        SELECT 제목                                                        \n");
            sQry.append("             , 내용                                                        \n");
            sQry.append("        FROM   건의요청등록정보                                            \n");
            sQry.append("        WHERE  기업코드     =  ?                                           \n"); //(06)기업코드
            sQry.append("          AND  법인코드     =  ?                                           \n"); //(07)법인코드
            sQry.append("          AND  브랜드코드   =  ?                                           \n"); //(08)브랜드코드
            sQry.append("          AND  매장코드     =  ?                                           \n"); //(09)매장코드
            sQry.append("          AND  건의요청구분 =  ?                                           \n"); //(10)게시구분 
            sQry.append("          AND  건의요청번호 =  ?                                           \n"); //(11)게시번호
            sQry.append("          AND  삭제여부     = 'N'                                          \n");
            sQry.append("      ) T                                                                  \n");
            sQry.append(" WHERE  1 = 1                                                              \n"); 
            
			//-------------------------------------------------------------------------------------------
            // set preparedstatemen
			//-------------------------------------------------------------------------------------------
            pstmt = new LoggableStatement(con, sQry.toString());

            int p=0;
			//-------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );    //(01)  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );    //(02)
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );    //(03)
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );    //(04)
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );    //(05)
			//-------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );    //(06)  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );    //(07)
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );    //(08)
            pstmt.setString(++p, (String)paramHash.get("매장코드")        );    //(09)
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );    //(10)
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );    //(11)
			//-------------------------------------------------------------------------------------------
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			commentBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new commentBean(); 
                
                dataBean.set제목          ((String)rs.getString("제목"      ));
                dataBean.set내용          ((String)rs.getString("내용"      ));

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
	 * 검색 조건에 맞는 댓글상세내역 건수조회 (팝업에서 사용)
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int commentDetailCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			
			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 선언 및 정의
			//-------------------------------------------------------------------------------------------
			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"), "0");	

            //검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));
			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			System.out.println("srch_key : " + srch_key  );

			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			//-------------------------------------------------------------------------------------------
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append(" SELECT COUNT(*)                                                           \n");
            sQry.append(" FROM ( SELECT 제목                                                        \n");
            sQry.append("             , 내용                                                        \n");
            sQry.append("        FROM   게시등록정보                                                \n");
            sQry.append("        WHERE  기업코드     =  ?                                           \n"); //(01)기업코드
            sQry.append("          AND  법인코드     =  ?                                           \n"); //(02)법인코드
            sQry.append("          AND  브랜드코드   =  ?                                           \n"); //(03)브랜드코드
            sQry.append("          AND  게시구분     =  ?                                           \n"); //(04)게시구분
            sQry.append("          AND  게시번호     =  ?                                           \n"); //(05)게시번호
            sQry.append("          AND  삭제여부     = 'N'                                          \n");
            sQry.append("        UNION ALL                                                          \n");
            sQry.append("        SELECT 제목                                                        \n");
            sQry.append("             , 내용                                                        \n");
            sQry.append("        FROM   건의요청등록정보                                            \n");
            sQry.append("        WHERE  기업코드     =  ?                                           \n"); //(06)기업코드
            sQry.append("          AND  법인코드     =  ?                                           \n"); //(07)법인코드
            sQry.append("          AND  브랜드코드   =  ?                                           \n"); //(08)브랜드코드
            sQry.append("          AND  매장코드     =  ?                                           \n"); //(09)매장코드
            sQry.append("          AND  건의요청구분 =  ?                                           \n"); //(10)게시구분 
            sQry.append("          AND  건의요청번호 =  ?                                           \n"); //(11)게시번호
            sQry.append("          AND  삭제여부     = 'N'                                          \n");
            sQry.append("      ) T                                                                  \n");
            sQry.append(" WHERE  1 = 1                                                              \n"); 
            
			//-------------------------------------------------------------------------------------------
            // set preparedstatemen
			//-------------------------------------------------------------------------------------------
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
			//-------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );    //(01)  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );    //(02)
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );    //(03)
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );    //(04)
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );    //(05)
			//-------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );    //(06)  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );    //(07)
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );    //(08)
            pstmt.setString(++p, (String)paramHash.get("매장코드")        );    //(09)
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );    //(10)
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );    //(11)
			//-------------------------------------------------------------------------------------------

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
	 * 댓글상세내역 조회 List (팝업에서 사용)
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<commentBean> commentDetailList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<commentBean> list = new ArrayList<commentBean>();
		
		try
		{ 
			
            System.out.println("##### commentDetailList #####"  );
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT T.*                                                                         \n");
            sQry.append(" FROM ( SELECT ROW_NUMBER() OVER(ORDER BY T1.댓글번호 DESC)  AS ROW_NUM             \n");
            sQry.append("             , T1.*                                                                 \n");
            sQry.append("        FROM ( SELECT A.기업코드                             AS 기업코드            \n");
            sQry.append("                    , A.법인코드                             AS 법인코드            \n");
            sQry.append("                    , A.브랜드코드                           AS 브랜드코드          \n");
            sQry.append("                    , A.매장코드                             AS 매장코드            \n");
            sQry.append("                    , NVL(B.매장명, 'N/A')                   AS 매장명              \n");
            sQry.append("                    , A.게시구분                             AS 게시구분            \n");
            sQry.append("                    , A.게시번호                             AS 게시번호            \n");
            sQry.append("                    , A.댓글번호                             AS 댓글번호            \n");
            sQry.append("                    , REPLACE(A.내용, '<BR>', CHR(13))       AS 댓글내용            \n");
            sQry.append("                    , A.등록자                               AS 댓글등록자          \n");
            sQry.append("                    , TO_CHAR(A.등록일자, 'YYYY-MM-DD')      AS 댓글등록일자        \n");
            sQry.append("               FROM   게시댓글정보   A                                              \n");
            sQry.append("                      LEFT OUTER JOIN                                               \n");
            sQry.append("                      매장           B                                              \n");
            sQry.append("                       ON B.기업코드   = A.기업코드                                 \n");
            sQry.append("                      AND B.법인코드   = A.법인코드                                 \n");
            sQry.append("                      AND B.브랜드코드 = A.브랜드코드                               \n");
            sQry.append("                      AND B.매장코드   = A.매장코드                                 \n");
            sQry.append("               WHERE  1=1					                                         \n");  //90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
        //  sQry.append("                 AND  A.기업코드       = ?                                          \n");  //(01)기업코드
        //  sQry.append("                 AND  A.법인코드       = ?                                          \n");  //(02)법인코드
        //  sQry.append("                 AND  A.브랜드코드     = ?                                          \n");  //(03)브랜드코드
            sQry.append("                 AND  A.게시구분       = ?                                          \n");  //(04)게시구분
            sQry.append("                 AND  A.게시번호       = ?                                          \n");  //(05)게시번호
            sQry.append("                 AND  A.삭제여부       = 'N'                                        \n");
            sQry.append("               UNION ALL                                                            \n");
            sQry.append("               SELECT A.기업코드                             AS 기업코드            \n");
            sQry.append("                    , A.법인코드                             AS 법인코드            \n");
            sQry.append("                    , A.브랜드코드                           AS 브랜드코드          \n");
            sQry.append("                    , A.매장코드                             AS 매장코드            \n");
            sQry.append("                    , NVL(B.매장명, 'N/A')                   AS 매장명              \n");
            sQry.append("                    , A.건의요청구분                         AS 게시구분            \n");
            sQry.append("                    , A.건의요청번호                         AS 게시번호            \n");
            sQry.append("                    , A.댓글번호                             AS 댓글번호            \n");
            sQry.append("                    , REPLACE(A.내용, '<BR>', CHR(13))       AS 댓글내용            \n");
            sQry.append("                    , A.등록자                               AS 댓글등록자          \n");
            sQry.append("                    , TO_CHAR(A.등록일자, 'YYYY-MM-DD')      AS 댓글등록일자        \n");
            sQry.append("               FROM   건의요청댓글정보 A                                            \n");
            sQry.append("                      LEFT OUTER JOIN                                               \n");
            sQry.append("                      매장           B                                              \n");
            sQry.append("                       ON B.기업코드   = A.기업코드                                 \n");
            sQry.append("                      AND B.법인코드   = A.법인코드                                 \n");
            sQry.append("                      AND B.브랜드코드 = A.브랜드코드                               \n");
            sQry.append("                      AND B.매장코드   = A.매장코드                                 \n");
            sQry.append("               WHERE  A.기업코드       = ?                                          \n");  //(06)기업코드
            sQry.append("                 AND  A.법인코드       = ?                                          \n");  //(07)법인코드
            sQry.append("                 AND  A.브랜드코드     = ?                                          \n");  //(08)브랜드코드
            sQry.append("                 AND  A.매장코드       = ?                                          \n");  //(09)매장코드
            sQry.append("                 AND  A.건의요청구분   = ?                                          \n");  //(10)게시구분
            sQry.append("                 AND  A.건의요청번호   = ?                                          \n");  //(11)게시번호
            sQry.append("                 AND  A.삭제여부       = 'N'                                        \n");
            sQry.append("              ) T1                                                                  \n");
            sQry.append("      ) T                                                                           \n");
            sQry.append(" ORDER BY T.댓글번호     DESC                                                       \n");
            
            //---------------------------------------------------------------------------------------------------
            // set preparedstatemen
            //---------------------------------------------------------------------------------------------------
            pstmt = new LoggableStatement(con, sQry.toString());

            int p=0;
            //---------------------------------------------------------------------------------------------------
          //pstmt.setString(++p, (String)paramHash.get("기업코드")        );    //(01)
          //pstmt.setString(++p, (String)paramHash.get("법인코드")        );    //(02)
          //pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );    //(03)
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );    //(04)
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );    //(05)
            //---------------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );    //(06)
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );    //(07)
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );    //(08)
            pstmt.setString(++p, (String)paramHash.get("매장코드")        );    //(09)
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );    //(10)
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );    //(11)
            //---------------------------------------------------------------------------------------------------
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			commentBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new commentBean(); 
                
                dataBean.setROW_NUM       ((String)rs.getString("ROW_NUM"       )); 
                dataBean.set기업코드      ((String)rs.getString("기업코드"      ));
                dataBean.set법인코드      ((String)rs.getString("법인코드"      ));
                dataBean.set브랜드코드    ((String)rs.getString("브랜드코드"    ));
                dataBean.set매장코드      ((String)rs.getString("매장코드"      ));
                dataBean.set매장명        ((String)rs.getString("매장명"        ));
                dataBean.set게시구분      ((String)rs.getString("게시구분"      ));
                dataBean.set게시번호      ((String)rs.getString("게시번호"      ));
                dataBean.set댓글번호      ((String)rs.getString("댓글번호"      ));
                dataBean.set댓글내용      ((String)rs.getString("댓글내용"      ));
                dataBean.set댓글등록자    ((String)rs.getString("댓글등록자"    ));
                dataBean.set댓글등록일자  ((String)rs.getString("댓글등록일자"  ));

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
	 * 검색 조건에 맞는 댓글상세내역의 전체 레코드 수(팝업에서 사용)
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int commentDetailListCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append(" SELECT SUM(T.ROW_CNT)                                                       \n");
            sQry.append(" FROM ( SELECT COUNT(*)                               AS ROW_CNT             \n");
            sQry.append("        FROM   게시댓글정보     A                                            \n");
            sQry.append("        WHERE  1=1                                            				  \n");  //90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
        //  sQry.append("          AND  A.기업코드     = ?                                            \n");  //(01)기업코드
        //  sQry.append("          AND  A.법인코드     = ?                                            \n");  //(02)법인코드
        //  sQry.append("          AND  A.브랜드코드   = ?                                            \n");  //(03)브랜드코드
            sQry.append("          AND  A.게시구분     = ?                                            \n");  //(04)게시구분
            sQry.append("          AND  A.게시번호     = ?                                            \n");  //(05)게시번호
            sQry.append("          AND  A.삭제여부     = 'N'                                          \n");
            sQry.append("        UNION ALL                                                            \n");
            sQry.append("        SELECT COUNT(*)                               AS ROW_CNT             \n");
            sQry.append("        FROM   건의요청댓글정보 A                                            \n");
            sQry.append("        WHERE  A.기업코드     = ?                                            \n");  //(06)기업코드
            sQry.append("          AND  A.법인코드     = ?                                            \n");  //(07)법인코드
            sQry.append("          AND  A.브랜드코드   = ?                                            \n");  //(08)브랜드코드
            sQry.append("          AND  A.매장코드     = ?                                            \n");  //(09)매장코드
            sQry.append("          AND  A.건의요청구분 = ?                                            \n");  //(10)게시구분
            sQry.append("          AND  A.건의요청번호 = ?                                            \n");  //(11)게시번호
            sQry.append("          AND  A.삭제여부     = 'N'                                          \n");
            sQry.append("       ) T                                                                   \n");
            sQry.append(" WHERE 1 = 1                                                                 \n");
            
            //---------------------------------------------------------------------------------------------------
            // set preparedstatemen
            //---------------------------------------------------------------------------------------------------
            pstmt = new LoggableStatement(con, sQry.toString());

            int p=0;
            //---------------------------------------------------------------------------------------------------
          //pstmt.setString(++p, (String)paramHash.get("기업코드")        );    //(01)
          //pstmt.setString(++p, (String)paramHash.get("법인코드")        );    //(02)
          //pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );    //(03)
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );    //(04)
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );    //(05)
            //---------------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );    //(06)
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );    //(07)
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );    //(08)
            pstmt.setString(++p, (String)paramHash.get("매장코드")        );    //(09)
            pstmt.setString(++p, (String)paramHash.get("게시구분")        );    //(10)
            pstmt.setString(++p, (String)paramHash.get("게시번호")        );    //(11)
            //---------------------------------------------------------------------------------------------------

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