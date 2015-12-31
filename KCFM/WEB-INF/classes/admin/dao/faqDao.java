/** ############################################################### */
/** Program ID   : faqDao.java                                      */
/** Program Name : 자주하는질문내역                                 */
/** Program Desc : 자주하는질문내역 Dao                             */
/** Create Date  : 2015-04-10                                       */
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


import admin.beans.faqBean;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

import com.util.JSPUtil;

public class faqDao 
{
	
    /**
     * faq 신규등록
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertFaq(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;

		
		System.out.println("##### insert Faq ###### \n" );
		
		int RowCnt = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
            sQry.append("INSERT INTO 자주하는질문내역                                  \n");
            sQry.append("     ( 기업코드                                               \n");
            sQry.append("     , 법인코드                                               \n");
            sQry.append("     , 브랜드코드                                             \n");
            sQry.append("     , 질문번호                                               \n");
            sQry.append("     , 질문내용                                               \n");
            sQry.append("     , 답변내용                                               \n");
            sQry.append("     , 조회수                                                 \n");
            sQry.append("     , 등록자                                                 \n");
            sQry.append("     , 등록일자                                               \n");
            sQry.append("     , 등록패스워드                                           \n");
            sQry.append("     , 삭제여부                                               \n");
            sQry.append("     , 예비문자                                               \n");
            sQry.append("     , 예비숫자                                               \n");
            sQry.append("     , 최종변경일시                                           \n");
            sQry.append("     )                                                        \n");
            sQry.append("VALUES                                                        \n");
            sQry.append("     ( ?                                                      \n"); // --01.기업코드   (01)
            sQry.append("     , ?                                                      \n"); // --02.법인코드   (02)
            sQry.append("     , ?                                                      \n"); // --03.브랜드코드 (03)
            sQry.append("     , FNC_SEQ_NO('자주하는질문내역'                          \n"); //                 (04, 05) 
            sQry.append("                  , ? , ?                                     \n"); //                 (06)
            sQry.append("                  , ?, '')                                    \n"); // --04.질문번호
            sQry.append("     , REPLACE(?, CHR(13), '<BR>')                            \n"); // --05.질문내용   (07)
            sQry.append("     , REPLACE(?, CHR(13), '<BR>')                            \n"); // --06.답변내용   (08)
            sQry.append("     , 0                                                      \n"); // --07.조회수
            sQry.append("     , ?                                                      \n"); // --08.등록자      (09)
            sQry.append("     , TO_CHAR(SYSDATE, 'YYYYMMDD')                           \n"); // --09.등록일자
            sQry.append("     , '123'                                                  \n"); // --10.등록패스워드
            sQry.append("     , 'N'                                                    \n"); // --11.삭제여부
            sQry.append("     , ''                                                     \n"); // --12.예비문자
            sQry.append("     , 0                                                      \n"); // --13.예비숫자
            sQry.append("     , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')              \n"); // --14.최종변경일시
            sQry.append("     )                                                        \n"); //
			
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("기업코드")   );  //(01)기업코드
            pstmt.setString(++i, (String)paramData.get("법인코드")   );  //(02)법인코드
            pstmt.setString(++i, (String)paramData.get("브랜드코드")  ); //(03)브랜드코드
            pstmt.setString(++i, (String)paramData.get("기업코드")   );  //(04)기업코드
            pstmt.setString(++i, (String)paramData.get("법인코드")   );  //(05)법인코드
            pstmt.setString(++i, (String)paramData.get("브랜드코드") );  //(06)브랜드코드
            pstmt.setString(++i, (String)paramData.get("질문내용")   );  //(07)질문내용
            pstmt.setString(++i, (String)paramData.get("답변내용")   );  //(08)답변내용
            pstmt.setString(++i, (String)paramData.get("등록자")     );  //(09)등록자
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
     * faq 수정처리
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateFaq(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;

		System.out.println("##### update Faq ###### \n" );
		
		int RowCnt = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
            sQry.append(" UPDATE 자주하는질문내역                                                                                                    \n");
            sQry.append("    SET 질문내용     = REPLACE(?, CHR(13), '<BR>')                           \n");
            sQry.append("      , 답변내용     = REPLACE(?, CHR(13), '<BR>')                           \n");
            sQry.append("      , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')             \n");
            sQry.append(" WHERE  기업코드     = ?                                                     \n");
            sQry.append("   AND  법인코드     = ?                                                     \n");
            sQry.append("   AND  브랜드코드   = ?                                                     \n");
            sQry.append("   AND  질문번호     = ?                                                     \n");
			
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("질문내용")    );  
            pstmt.setString(++i, (String)paramData.get("답변내용")    );  
            pstmt.setString(++i, (String)paramData.get("기업코드")    );  
            pstmt.setString(++i, (String)paramData.get("법인코드")    );  
            pstmt.setString(++i, (String)paramData.get("브랜드코드")  );  
            pstmt.setString(++i, (String)paramData.get("질문번호")    );  
            
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
	 * 자주하는질문내역 조회 List (해당 질문내역 데이터)
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<faqBean> selectFaqData(HashMap paramData) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<faqBean> list = new ArrayList<faqBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 7;
			
			String srch_key = JSPUtil.chkNull((String)paramData.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT ROW_NUMBER() OVER (ORDER BY 질문번호 DESC) AS ROW_NUM       \n");
            sQry.append("      , 기업코드                                                    \n");
            sQry.append("      , 법인코드                                                    \n");
            sQry.append("      , 브랜드코드                                                  \n");
            sQry.append("      , 질문번호                                                    \n");
            sQry.append("      , REPLACE(질문내용, '<BR>', CHR(13)) AS 질문내용              \n");
            sQry.append("      , REPLACE(답변내용, '<BR>', CHR(13)) AS 답변내용              \n");
            sQry.append("      , 조회수                                                      \n");
            sQry.append("      , 등록자                                                      \n");
            sQry.append("      , TO_CHAR(등록일자, 'YYYY-MM-DD')    AS 등록일자              \n");
            sQry.append(" FROM   자주하는질문내역                                            \n");
            sQry.append(" WHERE  기업코드    = ?                                             \n");
            sQry.append("   AND  법인코드    = ?                                             \n");
            sQry.append("   AND  브랜드코드  = ?                                             \n");
            sQry.append("   AND  질문번호    = ?                                             \n");

            
            // set preparedstatemen
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            //pstmt.setString(++p, srch_key);
            
            pstmt.setString(++i, (String)paramData.get("기업코드")    ); 
            pstmt.setString(++i, (String)paramData.get("법인코드")    ); 
            pstmt.setString(++i, (String)paramData.get("브랜드코드")  ); 
            pstmt.setString(++i, (String)paramData.get("질문번호")    ); 
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
			rs = pstmt.executeQuery();
			
            // make databean list
			faqBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new faqBean(); 
                
                dataBean.setROW_NUM     ((String)rs.getString("ROW_NUM"     )); 
                dataBean.set기업코드    ((String)rs.getString("기업코드"    ));
                dataBean.set법인코드    ((String)rs.getString("법인코드"    ));
                dataBean.set브랜드코드  ((String)rs.getString("브랜드코드"  ));
                dataBean.set질문번호    ((String)rs.getString("질문번호"    ));
                dataBean.set질문내용    ((String)rs.getString("질문내용"    ));
                dataBean.set답변내용    ((String)rs.getString("답변내용"    ));
                dataBean.set조회수      ((String)rs.getString("조회수"      ));
                dataBean.set등록자      ((String)rs.getString("등록자"      ));
                dataBean.set등록일자    ((String)rs.getString("등록일자"    ));
                
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
	
    public int deleteFaq(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;

		System.out.println("##### delete Faq ###### \n" );
		
		int RowCnt = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
            sQry.append(" UPDATE 자주하는질문내역                                                                                                    \n");
            sQry.append("    SET 삭제여부     = 'Y'                                                   \n");
            sQry.append("      , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')             \n");
            sQry.append(" WHERE  기업코드     = ?                                                     \n");
            sQry.append("   AND  법인코드     = ?                                                     \n");
            sQry.append("   AND  브랜드코드   = ?                                                     \n");
            sQry.append("   AND  질문번호     = ?                                                     \n");
			
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("기업코드")    );
            pstmt.setString(++i, (String)paramData.get("법인코드")    );
            pstmt.setString(++i, (String)paramData.get("브랜드코드")  );
            pstmt.setString(++i, (String)paramData.get("질문번호")    );

            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
	 * 자주하는질문내역 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<faqBean> selectFaqList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<faqBean> list = new ArrayList<faqBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 7;
			
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
  
            sQry.append(" SELECT                                                             \n");
            sQry.append(" *                                                                  \n");
            sQry.append(" FROM                                                               \n");
            sQry.append(" (                                                                  \n");
            sQry.append("   SELECT ROW_NUMBER() OVER (ORDER BY 질문번호 DESC) AS ROW_NUM     \n");
            sQry.append("        , 기업코드                                                  \n");
            sQry.append("        , 법인코드                                                  \n");
            sQry.append("        , 브랜드코드                                                \n");
            sQry.append("        , 질문번호                                                  \n");
            sQry.append("        , REPLACE(질문내용, '<BR>', CHR(13)) AS 질문내용            \n");
            sQry.append("        , REPLACE(답변내용, '<BR>', CHR(13)) AS 답변내용            \n");
            sQry.append("        , 조회수                                                    \n");
            sQry.append("        , 등록자                                                    \n");
            sQry.append("        , TO_CHAR(등록일자, 'YYYY-MM-DD')    AS 등록일자            \n");
            sQry.append("   FROM   자주하는질문내역                                          \n");
            sQry.append("   WHERE  기업코드        =  ?                                      \n");
            sQry.append("     AND  법인코드        =  ?                                      \n");
            sQry.append("     AND  삭제여부        = 'N'                                     \n");
			//-------------------------------------------------------------------------------------------
            if (srch_type.equals("title")) {
                sQry.append(" AND  질문내용 LIKE ?                                           \n");
            } else if(srch_type.equals("content")) {
                sQry.append(" AND  답변내용 LIKE ?                                           \n");
            } else if(srch_type.equals("writer")) {
                sQry.append(" AND  등록자   LIKE ?                                           \n");
            } else {
                sQry.append(" AND (질문내용 LIKE ? OR 답변내용 LIKE ? OR 등록자 LIKE ? )     \n");
            }
			//-------------------------------------------------------------------------------------------
            sQry.append(" )                                                                  \n");
            sQry.append(" WHERE  ROW_NUM >  ?                                                \n");
            sQry.append("   AND  ROW_NUM <= ?                                                \n");
            sQry.append(" ORDER BY 질문번호 DESC                                             \n");     

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            //pstmt.setString(++p, srch_key);
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );  
			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 조립
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
			//-------------------------------------------------------------------------------------------
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			faqBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new faqBean(); 
                
                dataBean.setROW_NUM    ((String)rs.getString("ROW_NUM"     )); 
                dataBean.set기업코드   ((String)rs.getString("기업코드"    ));
                dataBean.set법인코드   ((String)rs.getString("법인코드"    ));
                dataBean.set브랜드코드 ((String)rs.getString("브랜드코드"  ));
                dataBean.set질문번호   ((String)rs.getString("질문번호"    ));
                dataBean.set질문내용   ((String)rs.getString("질문내용"    ));
                dataBean.set답변내용   ((String)rs.getString("답변내용"    ));
                dataBean.set조회수     ((String)rs.getString("조회수"      ));
                dataBean.set등록자     ((String)rs.getString("등록자"      ));
                dataBean.set등록일자   ((String)rs.getString("등록일자"    ));
                

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
	 * 검색 조건에 맞는 자주하는질문내역의 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectFaqListCount(HashMap paramHash) throws Exception 
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
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	

            //검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));
			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			System.out.println("srch_key : " + srch_key  );

			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			//-------------------------------------------------------------------------------------------
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT COUNT(*)                                                    \n");
            sQry.append(" FROM   자주하는질문내역                                            \n");
            sQry.append("   WHERE  기업코드    =  ?                                          \n");
            sQry.append("     AND  법인코드    =  ?                                          \n");
            sQry.append("     AND  브랜드코드  =  ?                                          \n");
            sQry.append("     AND  삭제여부    = 'N'                                         \n");
			//-------------------------------------------------------------------------------------------
            if (srch_type.equals("title")) {
                sQry.append(" AND  질문내용 LIKE ?                                           \n");
            } else if(srch_type.equals("content")) {
                sQry.append(" AND  답변내용 LIKE ?                                           \n");
            } else if(srch_type.equals("writer")) {
                sQry.append(" AND  등록자   LIKE ?                                           \n");
            } else {
                sQry.append(" AND (질문내용 LIKE ? OR 답변내용 LIKE ? OR 등록자 LIKE ? )     \n");
            }
			//-------------------------------------------------------------------------------------------
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
			//-------------------------------------------------------------------------------------------
            pstmt.setString(++p, (String)paramHash.get("기업코드")        );  
            pstmt.setString(++p, (String)paramHash.get("법인코드")        );
            pstmt.setString(++p, (String)paramHash.get("브랜드코드")      );
			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 조립
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
	 * 자주하는질문내역 조회 List (매장용List)
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<faqBean> selectFaqInfo(HashMap paramData) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<faqBean> list = new ArrayList<faqBean>();
		
		try
		{ 
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT *                                                          \n");
            sQry.append(" FROM                                                              \n");
            sQry.append(" (                                                                 \n");
            sQry.append(" 	SELECT ROW_NUMBER() OVER (ORDER BY 질문번호 DESC) AS ROW_NUM    \n");
            sQry.append("        , 기업코드                                                 \n");
            sQry.append("        , 법인코드                                                 \n");
            sQry.append("        , 브랜드코드                                               \n");
            sQry.append("        , 질문번호                                                 \n");
            sQry.append("        , 질문내용                                                 \n");
            sQry.append("        , 답변내용                                                 \n");
            sQry.append("        , 조회수                                                   \n");
            sQry.append("        , 등록자                                                   \n");
            sQry.append("        , TO_CHAR(등록일자, 'YYYY-MM-DD') AS 등록일자              \n");
            sQry.append("   FROM   자주하는질문내역                                         \n");
            sQry.append("   WHERE  기업코드    = ?                                          \n");
            sQry.append("     AND  법인코드    = ?                                          \n");
            sQry.append("     AND  브랜드코드  = ?                                          \n");
            sQry.append("     AND  삭제여부    = 'N'                                        \n");
            sQry.append(" )                                                                 \n");
            sQry.append(" WHERE  ROW_NUM >  ?                                               \n");
            sQry.append("   AND  ROW_NUM <= ?                                               \n");
            sQry.append(" ORDER BY 질문번호 DESC                                           	\n");

            
            // set preparedstatemen
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            //pstmt.setString(++p, srch_key);
            
            pstmt.setString(++i, (String)paramData.get("기업코드")    ); 
            pstmt.setString(++i, (String)paramData.get("법인코드")    ); 
            pstmt.setString(++i, (String)paramData.get("브랜드코드")  ); 
            pstmt.setInt(++i   , (inCurPage-1)*inRowPerPage);  // 페이지당 시작 글 범위
			pstmt.setInt(++i   , (inCurPage*inRowPerPage)  );  // 페이지당 끌 글 범위
            
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
			rs = pstmt.executeQuery();
			
            // make databean list
			faqBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new faqBean(); 
                
                dataBean.setROW_NUM    ((String)rs.getString("ROW_NUM"     )); 
                dataBean.set기업코드   ((String)rs.getString("기업코드"    ));
                dataBean.set법인코드   ((String)rs.getString("법인코드"    ));
                dataBean.set브랜드코드 ((String)rs.getString("브랜드코드"  ));
                dataBean.set질문번호   ((String)rs.getString("질문번호"    ));
                dataBean.set질문내용   ((String)rs.getString("질문내용"    ));
                dataBean.set답변내용   ((String)rs.getString("답변내용"    ));
                dataBean.set조회수     ((String)rs.getString("조회수"      ));
                dataBean.set등록자     ((String)rs.getString("등록자"      ));
                dataBean.set등록일자   ((String)rs.getString("등록일자"    ));
                
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
     * faq 조회수 수정처리
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateFaqCnt(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;

		System.out.println("##### update Faq ###### \n" );
		
		int RowCnt = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
            sQry.append(" UPDATE 자주하는질문내역                                                   \n");
            sQry.append("    SET 조회수     = 조회수 + 1                                            \n");
            sQry.append(" WHERE  기업코드   = ?                                                     \n");
            sQry.append("   AND  법인코드   = ?                                                     \n");
            sQry.append("   AND  브랜드코드 = ?                                                     \n");
            sQry.append("   AND  질문번호   = ?                                                     \n");
			
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("기업코드")    );  
            pstmt.setString(++i, (String)paramData.get("법인코드")    );  
            pstmt.setString(++i, (String)paramData.get("브랜드코드")  );  
            pstmt.setString(++i, (String)paramData.get("질문번호")    );  
            
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


}