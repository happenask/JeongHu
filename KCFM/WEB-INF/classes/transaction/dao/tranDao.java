/** ############################################################### */
/** Program ID   : tranDao.java                                     */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package transaction.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.net.URLDecoder;

import transaction.beans.tranBean;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

import board.beans.listBean;

import com.util.JSPUtil;

public class tranDao 
{
	
	
    /**
     * 조회 매출월 정보보기
     * @param paramHash
     * @return
     * @throws DAOException
     */
    public ArrayList<tranBean> selectTranMonth(HashMap paramData) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
						
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT DISTINCT(매출월)            \n");
            sQry.append(" FROM   카드승인내역집계            \n");
            /*
            sQry.append(" WHERE  기업코드     = ?            \n");
			sQry.append(" AND    법인코드     = ?            \n");
			sQry.append(" AND    브랜드코드   = ?            \n");
			sQry.append(" AND    매장코드     = ?            \n");
            */
            sQry.append(" WHERE  1=1                         \n");
            sQry.append(" AND    매출월       >= ?           \n");
            sQry.append(" AND    매출월       <= ?           \n");
			sQry.append(" ORDER BY 매출월 ASC                \n");  

            
            // set preparedstatemen
            int i=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            /*
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
			*/
            
            pstmt.setString(++i, (String)paramData.get("sDate"));  //시작일자
            pstmt.setString(++i, (String)paramData.get("eDate"));  //종료일자
            
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set매출월  ((String)rs.getString("매출월"  ));

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
	 * 해당 매출월별 카드승인내역 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthList1(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
			String 사용자명   = JSPUtil.chkNull((String)paramHash.get("사용자명"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("   SELECT                                                           \n");
            sQry.append("         MIN(거래구분) AS 거래구분                                  \n");
            sQry.append("       , 카드발급사코드                                             \n");
            sQry.append("       , MIN(카드발급사명) AS 카드발급사명                          \n");
            sQry.append("       , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수     \n");
            sQry.append("       , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액     \n");
            sQry.append("       , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세       \n");
            sQry.append("       , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료       \n");
            sQry.append("       , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액       \n");
            sQry.append("       , MAX(사업자번호) AS 사업자번호                              \n");
            sQry.append("    FROM                                                            \n");
            sQry.append("    (                                                				 \n");
            sQry.append("      SELECT 거래구분                                				 \n");
            sQry.append("           , 카드발급사코드                                         \n");
            sQry.append("           , 카드발급사명                                         	 \n");
            sQry.append("           , 승인건수                                         		 \n");
            sQry.append("           , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("           , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("           , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("           , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("           , B.사업자번호                                           \n");
            sQry.append("        FROM 카드승인내역집계                                       \n");
            sQry.append("           , (                                                      \n");
            sQry.append("              SELECT 사업자번호                                     \n");
            sQry.append("                FROM 매장                                           \n");
            sQry.append("               WHERE 기업코드   = ?                                 \n");
            sQry.append("                 AND 법인코드   = ?                                 \n");
            sQry.append("                 AND 브랜드코드 = ?                                 \n");
            sQry.append("                 AND 매장코드   = ?                                 \n");
            sQry.append("             ) B                                                    \n");
            sQry.append("       WHERE 1=1                                                    \n");
            sQry.append("         AND 거래구분   IN ('01','02','04')                         \n");
            sQry.append("         AND 매출월     = ?                                         \n");
            sQry.append("         AND 기업코드   = ?                                         \n");
            sQry.append("         AND 법인코드   = ?                                         \n");
            sQry.append("         AND 브랜드코드 = ?                                         \n");
            sQry.append("         AND 매장코드   = ?                                         \n");
            sQry.append("    )                                                				 \n");
            sQry.append("   GROUP BY 카드발급사코드                                          \n");
            sQry.append("   ORDER BY 거래구분, 카드발급사코드                                \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            

            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당 매출월
            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
            
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
			
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));
                dataBean.set사업자번호     ((String)rs.getString("사업자번호"     ));

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
	 * 엑셀다운로드시 사업장번호 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectCorpNumList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
			String 사용자명   = JSPUtil.chkNull((String)paramHash.get("사용자명"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  

            sQry.append("  SELECT 사업자번호                                     \n");
            sQry.append("    FROM 매장                                           \n");
            sQry.append("   WHERE 기업코드   = ?                                 \n");
            sQry.append("     AND 법인코드   = ?                                 \n");
            sQry.append("     AND 브랜드코드 = ?                                 \n");
            sQry.append("     AND 매장코드   = ?                                 \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            

            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
			
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set사업자번호     ((String)rs.getString("사업자번호"     ));

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
	 * 해당 매출월별 현금 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthList2(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("   SELECT                                                           \n");
            sQry.append("         거래구분                                                   \n");
            sQry.append("       , '' AS 카드발급사코드                                       \n");
            sQry.append("       , '' AS 카드발급사명                                         \n");
            sQry.append("       , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수     \n");
            sQry.append("       , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액     \n");
            sQry.append("       , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세       \n");
            sQry.append("       , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료       \n");
            sQry.append("       , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액       \n");
            sQry.append("    FROM                                                			 \n");
            sQry.append("       (                                                			 \n");
            sQry.append("        SELECT 거래구분                                			 \n");
            sQry.append("             , '' AS 카드발급사코드                                 \n");
            sQry.append("             , '' AS 카드발급사명                                   \n");
            sQry.append("             , 승인건수                                         	 \n");
            sQry.append("             , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("             , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("             , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("             , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("          FROM 카드승인내역집계                                     \n");
            sQry.append("         WHERE 1=1                                                  \n");
            sQry.append("           AND 거래구분   = '02'                                    \n");
            sQry.append("           AND 매출월     = ?                                       \n");
            sQry.append("           AND 기업코드   = ?                                       \n");
            sQry.append("           AND 법인코드   = ?                                       \n");
            sQry.append("           AND 브랜드코드 = ?                                       \n");
            sQry.append("           AND 매장코드   = ?                                       \n");
            sQry.append("       )                                                            \n");
            sQry.append("   GROUP BY 거래구분                                                \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당 매출월
            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));

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
	 * 해당 매출월별 현금영수증 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthList3(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("   SELECT                                                           \n");
            sQry.append("         거래구분                                                   \n");
            sQry.append("       , '' AS 카드발급사코드                                       \n");
            sQry.append("       , '' AS 카드발급사명                                         \n");
            sQry.append("       , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수     \n");
            sQry.append("       , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액     \n");
            sQry.append("       , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세       \n");
            sQry.append("       , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료       \n");
            sQry.append("       , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액       \n");
            sQry.append("    FROM                                                			 \n");
            sQry.append("       (                                                			 \n");
            sQry.append("        SELECT 거래구분                                			 \n");
            sQry.append("             , '' AS 카드발급사코드                                 \n");
            sQry.append("             , '' AS 카드발급사명                                   \n");
            sQry.append("             , 승인건수                                         	 \n");
            sQry.append("             , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("             , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("             , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("             , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("          FROM 카드승인내역집계                                     \n");
            sQry.append("         WHERE 1=1                                                  \n");
            sQry.append("           AND 거래구분   = '03'                                    \n");
            sQry.append("           AND 매출월     = ?                                       \n");
            sQry.append("           AND 기업코드   = ?                                       \n");
            sQry.append("           AND 법인코드   = ?                                       \n");
            sQry.append("           AND 브랜드코드 = ?                                       \n");
            sQry.append("           AND 매장코드   = ?                                       \n");
            sQry.append("       )                                                            \n");
            sQry.append("   GROUP BY 거래구분                                                \n");
            
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당 매출월
            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));

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
	 * 해당 매출월별 카드/현금/현금영수증 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthListSum(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("   SELECT                                                           \n");
            sQry.append("         '합계' AS 거래구분                                         \n");
            sQry.append("       , '' AS 카드발급사코드                                       \n");
            sQry.append("       , '' AS 카드발급사명                                         \n");
            sQry.append("       , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수     \n");
            sQry.append("       , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액     \n");
            sQry.append("       , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세       \n");
            sQry.append("       , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료       \n");
            sQry.append("       , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액       \n");
            sQry.append("    FROM                                                			 \n");
            sQry.append("       (                                                			 \n");
            sQry.append("        SELECT '합계' AS 거래구분                                	 \n");
            sQry.append("             , '' AS 카드발급사코드                                 \n");
            sQry.append("             , '' AS 카드발급사명                                   \n");
            sQry.append("             , 승인건수                                         	 \n");
            sQry.append("             , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("             , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("             , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("             , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("          FROM 카드승인내역집계                                     \n");
            sQry.append("         WHERE 1=1                                                  \n");
            sQry.append("           AND 거래구분 IN ('01', '02', '03', '04')                 \n");
            sQry.append("           AND 매출월     = ?                                       \n");
            sQry.append("           AND 기업코드   = ?                                       \n");
            sQry.append("           AND 법인코드   = ?                                       \n");
            sQry.append("           AND 브랜드코드 = ?                                       \n");
            sQry.append("           AND 매장코드   = ?                                       \n");
            sQry.append("       )                                                            \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당 매출월
            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));

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
	 * 해당 카드별 상세 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectCardDetailList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
            
            //to_char(sysdate,'YYYY-MM-DD')
            sQry.append("   SELECT                                                                         \n");
            sQry.append("         가맹점명                                                                 \n");
            sQry.append("       , 카드발급사명 AS 카드사명                                                 \n");
            sQry.append("       , 기준년월 AS 승인년월                                                     \n");
            sQry.append("       , to_char(to_date(거래일자,'YYYY-MM-DD'),'YYYY-MM-DD') AS 승인일자         \n");
            sQry.append("       , 카드번호                                                                 \n");
            sQry.append("       , to_char(to_date(거래시간,'hh24:mi:ss'),'hh24:mi:ss') AS 승인시간         \n");
            sQry.append("       , 승인번호                                                                 \n");
            sQry.append("       , to_char(공급가액,'999,999,999,999') AS 공급가액                              \n");
            sQry.append("       , to_char(부가세,'999,999,999,999') AS 부가세                                  \n");
            sQry.append("       , to_char(매출액,'999,999,999,999') AS 매출액                                  \n");
            sQry.append("       , to_char(to_date(매입일자,'YYYY-MM-DD'),'YYYY-MM-DD') AS 매입일자         \n");
            sQry.append("       , to_char(to_date( (case when 매입취소일자='00000000' then null else 매입취소일자 end) \n");
            sQry.append("                       ,'YYYY-MM-DD'),'YYYY-MM-DD') AS 매입취소일자               \n");
            sQry.append("    FROM 카드승인내역                                                             \n");
            sQry.append("   WHERE 1=1                                                                      \n");
            sQry.append("     AND 거래구분        IN ('01','02','04')                                      \n");
            sQry.append("     AND 기준년월        = ?                                                      \n");
            sQry.append("     AND 카드발급사코드  = ?                                                      \n");
            sQry.append("     AND 사업자번호      = ?                                                      \n");
            sQry.append("   ORDER BY 승인일자, 승인시간, 승인번호 ASC                                      \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("inDate")      );  //해당 매출월
            pstmt.setString(++p, (String)paramHash.get("iTranCd")     );  //카드발급사코드
            pstmt.setString(++p, (String)paramHash.get("corpNum")     );  //사업자번호
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
			
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set가맹점명   	   ((String)rs.getString("가맹점명"       ));
                dataBean.set카드사명       ((String)rs.getString("카드사명"       ));
                dataBean.set승인년월       ((String)rs.getString("승인년월"       ));
                dataBean.set승인일자       ((String)rs.getString("승인일자"       ));
                dataBean.set카드번호       ((String)rs.getString("카드번호"       ));
                dataBean.set승인시간       ((String)rs.getString("승인시간"       ));
                dataBean.set승인번호       ((String)rs.getString("승인번호"       ));
                dataBean.set공급가액       ((String)rs.getString("공급가액"       ));
                dataBean.set부가세         ((String)rs.getString("부가세"         ));
                dataBean.set매출액         ((String)rs.getString("매출액"         ));
                dataBean.set매입일자       ((String)rs.getString("매입일자"       ));
                dataBean.set매입취소일자   ((String)rs.getString("매입취소일자"   ));
                
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
     * 초기 월 정보보기
     * @param paramHash
     * @return
     * @throws DAOException
     */
    public ArrayList<tranBean> selectMonthInit() throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
						
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT to_char(sysdate, 'YYYY') || '01' as 초기시작월                \n");
            sQry.append("      , to_char(add_months(sysdate, -1), 'YYYYMM') as 초기전월          \n");
            sQry.append(" FROM   dual                                                          \n");
            
            int i=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set초기시작월  ((String)rs.getString("초기시작월"));
                dataBean.set초기전월    ((String)rs.getString("초기전월"  ));

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
	 * 해당 매출월별 카드 조회 List 테스트용
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthList1Test(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
			String 사용자명   = JSPUtil.chkNull((String)paramHash.get("사용자명"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("  SELECT MIN(거래구분) AS 거래구분                                  \n");
            sQry.append("       , 카드발급사코드                                             \n");
            sQry.append("       , MIN(카드발급사명) AS 카드발급사명                          \n");
            sQry.append("       , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수     \n");
            sQry.append("       , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액     \n");
            sQry.append("       , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세       \n");
            sQry.append("       , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료       \n");
            sQry.append("       , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액       \n");
            sQry.append("    FROM                                                            \n");
            sQry.append("    (                                                				 \n");
            sQry.append("      SELECT 거래구분                                				 \n");
            sQry.append("           , 카드발급사코드                                         \n");
            sQry.append("           , 카드발급사명                                         	 \n");
            sQry.append("           , 승인건수                                         		 \n");
            sQry.append("           , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("           , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("           , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("           , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("        FROM 카드승인내역집계                                       \n");
            sQry.append("       WHERE 1=1                                                    \n");
            sQry.append("         AND 거래구분   IN ('01','02','04')                         \n");
            sQry.append("         AND 매출월     = ?                                         \n");
            sQry.append("    )                                                				 \n");
            sQry.append("   GROUP BY 카드발급사코드                                          \n");
            sQry.append("   ORDER BY 거래구분, 카드발급사코드                                \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            

            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
            
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
			
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));

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
	 * 해당 매출월별 현금 조회 List 테스트용
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthList2Test(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("   SELECT                                                           \n");
            sQry.append("         거래구분                                                   \n");
            sQry.append("       , '' AS 카드발급사코드                                       \n");
            sQry.append("       , '' AS 카드발급사명                                         \n");
            sQry.append("       , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수     \n");
            sQry.append("       , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액     \n");
            sQry.append("       , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세       \n");
            sQry.append("       , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료       \n");
            sQry.append("       , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액       \n");
            sQry.append("    FROM                                                			 \n");
            sQry.append("       (                                                			 \n");
            sQry.append("        SELECT 거래구분                                			 \n");
            sQry.append("             , '' AS 카드발급사코드                                 \n");
            sQry.append("             , '' AS 카드발급사명                                   \n");
            sQry.append("             , 승인건수                                         	 \n");
            sQry.append("             , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("             , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("             , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("             , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("          FROM 카드승인내역집계                                     \n");
            sQry.append("         WHERE 1=1                                                  \n");
            sQry.append("           AND 거래구분   = '02'                                    \n");
            sQry.append("           AND 매출월     = ?                                       \n");
            sQry.append("       )                                                            \n");
            sQry.append("   GROUP BY 거래구분                                                \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));

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
	 * 해당 매출월별 현금영수증 조회 List 테스트용
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthList3Test(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("   SELECT                                                           \n");
            sQry.append("         거래구분                                                   \n");
            sQry.append("       , '' AS 카드발급사코드                                       \n");
            sQry.append("       , '' AS 카드발급사명                                         \n");
            sQry.append("       , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수     \n");
            sQry.append("       , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액     \n");
            sQry.append("       , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세       \n");
            sQry.append("       , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료       \n");
            sQry.append("       , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액       \n");
            sQry.append("    FROM                                                			 \n");
            sQry.append("       (                                                			 \n");
            sQry.append("        SELECT 거래구분                                			 \n");
            sQry.append("             , '' AS 카드발급사코드                                 \n");
            sQry.append("             , '' AS 카드발급사명                                   \n");
            sQry.append("             , 승인건수                                         	 \n");
            sQry.append("             , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("             , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("             , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("             , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("          FROM 카드승인내역집계                                     \n");
            sQry.append("         WHERE 1=1                                                  \n");
            sQry.append("           AND 거래구분   = '03'                                    \n");
            sQry.append("           AND 매출월     = ?                                       \n");
            sQry.append("       )                                                            \n");
            sQry.append("   GROUP BY 거래구분                                                \n");
            
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));

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
	 * 해당 매출월별 카드/현금/현금영수증 조회 List 테스트용
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthListSumTest(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("   SELECT                                                           \n");
            sQry.append("         '합계' AS 거래구분                                         \n");
            sQry.append("       , '' AS 카드발급사코드                                       \n");
            sQry.append("       , '' AS 카드발급사명                                         \n");
            sQry.append("       , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수     \n");
            sQry.append("       , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액     \n");
            sQry.append("       , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세       \n");
            sQry.append("       , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료       \n");
            sQry.append("       , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액       \n");
            sQry.append("    FROM                                                			 \n");
            sQry.append("       (                                                			 \n");
            sQry.append("        SELECT '합계' AS 거래구분                                	 \n");
            sQry.append("             , '' AS 카드발급사코드                                 \n");
            sQry.append("             , '' AS 카드발급사명                                   \n");
            sQry.append("             , 승인건수                                         	 \n");
            sQry.append("             , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("             , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("             , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("             , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("          FROM 카드승인내역집계                                     \n");
            sQry.append("         WHERE 1=1                                                  \n");
            sQry.append("           AND 거래구분 IN ('01', '02', '03', '04')                 \n");
            sQry.append("           AND 매출월     = ?                                       \n");
            sQry.append("       )                                                            \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));

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
	 * 해당 카드별 상세 조회 List 테스트용
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectCardDetailListTest(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
            
            //to_char(sysdate,'YYYY-MM-DD')
            sQry.append("   SELECT                                                                         \n");
            sQry.append("         가맹점명                                                                 \n");
            sQry.append("       , 카드발급사명 AS 카드사명                                                 \n");
            sQry.append("       , 기준년월 AS 승인년월                                                     \n");
            sQry.append("       , to_char(to_date(거래일자,'YYYY-MM-DD'),'YYYY-MM-DD') AS 승인일자         \n");
            sQry.append("       , 카드번호                                                                 \n");
            sQry.append("       , to_char(to_date(거래시간,'hh24:mi:ss'),'hh24:mi:ss') AS 승인시간         \n");
            sQry.append("       , 승인번호                                                                 \n");
            sQry.append("       , to_char(공급가액,'999,999,999,999') AS 공급가액                                  \n");
            sQry.append("       , to_char(부가세,'999,999,999,999') AS 부가세                                      \n");
            sQry.append("       , to_char(매출액,'999,999,999,999') AS 매출액                                      \n");
            sQry.append("       , to_char(to_date(매입일자,'YYYY-MM-DD'),'YYYY-MM-DD') AS 매입일자         \n");
            sQry.append("       , to_char(to_date( (case when 매입취소일자='00000000' then null else 매입취소일자 end) \n");
            sQry.append("                       ,'YYYY-MM-DD'),'YYYY-MM-DD') AS 매입취소일자               \n");
            sQry.append("    FROM 카드승인내역                                                             \n");
            sQry.append("   WHERE 1=1                                                                      \n");
            sQry.append("     AND 거래구분        IN ('01','02','04')                                      \n");
            sQry.append("     AND 기준년월        = ?                                                      \n");
            sQry.append("     AND 카드발급사코드  = ?                                                      \n");
            sQry.append("   ORDER BY 승인일자, 승인시간, 승인번호  ASC                                     \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("inDate")      );  //include변수
            pstmt.setString(++p, (String)paramHash.get("iTranCd")     );  //카드발급사코드
			
			rs = pstmt.executeQuery();
            // make databean list
			tranBean dataBean = null;
			
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set가맹점명   	   ((String)rs.getString("가맹점명"       ));
                dataBean.set카드사명       ((String)rs.getString("카드사명"       ));
                dataBean.set승인년월       ((String)rs.getString("승인년월"       ));
                dataBean.set승인일자       ((String)rs.getString("승인일자"       ));
                dataBean.set카드번호       ((String)rs.getString("카드번호"       ));
                dataBean.set승인시간       ((String)rs.getString("승인시간"       ));
                dataBean.set승인번호       ((String)rs.getString("승인번호"       ));
                dataBean.set공급가액       ((String)rs.getString("공급가액"       ));
                dataBean.set부가세         ((String)rs.getString("부가세"         ));
                dataBean.set매출액         ((String)rs.getString("매출액"         ));
                dataBean.set매입일자       ((String)rs.getString("매입일자"       ));
                dataBean.set매입취소일자   ((String)rs.getString("매입취소일자"   ));
                
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
	
	/* MSSHIN테스트 추가용 (추후 상황에 따라 삭제할 예정임.) */
	/* line : 1450 ~ end                                     */
	/**
	 * 해당 매출월별 카드승인내역 조회 List 테스트용
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthAllList1Test(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
			String 사용자명   = JSPUtil.chkNull((String)paramHash.get("사용자명"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("  SELECT *                                                                                  \n");
            sQry.append("  FROM   (                                                                                  \n");
            sQry.append("  	   SELECT 거래구분                                                                       \n");
            sQry.append("       	, 카드발급사코드                                                                 \n");
            sQry.append("       	, 카드발급사명                                                                   \n");
            sQry.append("       	, 승인건수                                                                       \n");
            sQry.append("       	, 공급가액                                                                       \n");
            sQry.append("       	, 부가세                                                                         \n");
            sQry.append("       	, 봉사료                                                                         \n");
            sQry.append("       	, 매출액                                                                         \n");
            sQry.append("        	, ROW_NUMBER() OVER (ORDER BY 거래구분 ASC) AS ROW_NUM                           \n");
            sQry.append("  	     FROM (                                                                              \n");
            sQry.append("  	    	SELECT MIN(거래구분) AS 거래구분                                                 \n");
            sQry.append("      		 	, 카드발급사코드                                                             \n");
            sQry.append("       	 	, MIN(카드발급사명) AS 카드발급사명                                          \n");
            sQry.append("       	 	, to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                     \n");
            sQry.append("       	 	, to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                     \n");
            sQry.append("       		, to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                       \n");
            sQry.append("       	 	, to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                       \n");
            sQry.append("       	 	, to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                       \n");
            sQry.append("    		FROM                                                                             \n");
            sQry.append("    			(                                                				             \n");
            sQry.append("      			SELECT 거래구분                                				                 \n");
            sQry.append("           	 	, 카드발급사코드                                                         \n");
            sQry.append("           	 	, 카드발급사명                                         	                 \n");
            sQry.append("           	 	, 승인건수                                         		                 \n");
            sQry.append("            	 	, (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("        	  	FROM 카드승인내역집계                                                        \n");
            sQry.append("       	 	WHERE 1=1                                                                    \n");
            sQry.append("         	   	AND 거래구분   IN ('01','02','04')                                           \n");
            sQry.append("              	AND 매출월     = ?                                                           \n");
            sQry.append("           	)                                                				             \n");
            sQry.append("       	GROUP BY 카드발급사코드                                                          \n");
            sQry.append("   		UNION ALL                                                                        \n");
            sQry.append("   		SELECT 거래구분                                                                  \n");
            sQry.append("       		, '' AS 카드발급사코드                                                       \n");
            sQry.append("       		, '' AS 카드발급사명                                                         \n");
            sQry.append("       		, to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                     \n");
            sQry.append("       		, to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                     \n");
            sQry.append("       		, to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                       \n");
            sQry.append("       		, to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                       \n");
            sQry.append("       		, to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                       \n");
            sQry.append("   		FROM                                                			                 \n");
            sQry.append("      			(                                                			                 \n");
            sQry.append("        		SELECT 거래구분                                			                     \n");
            sQry.append("             		, '' AS 카드발급사코드                                                   \n");
            sQry.append("            		, '' AS 카드발급사명                                                     \n");
            sQry.append("           		, 승인건수                                         	                     \n");
            sQry.append("          	    	, (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("          	    	, (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("          	    	, (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("          	    	, (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("         	 	FROM 카드승인내역집계                                                        \n");
            sQry.append("        		WHERE 1=1                                                                    \n");
            sQry.append("             	AND 거래구분   = '03'                                                        \n");
            sQry.append("             	AND 매출월     = ?                                                           \n");
            sQry.append("       		)                                                                            \n");
            sQry.append("   		GROUP BY 거래구분                                                                \n");
            sQry.append("       	)                                                                                \n");
            sQry.append("  		ORDER BY 거래구분, 카드발급사코드                                                    \n");
            sQry.append("  		)                                                								     \n");
            sQry.append("  WHERE  ROW_NUM >  ?                                                                       \n");
            sQry.append("    AND  ROW_NUM <= ?                                                                       \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            

            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
            pstmt.setInt   (++p   , (inCurPage-1)*inRowPerPage);        // 페이지당 시작 글 범위
			pstmt.setInt   (++p   , (inCurPage*inRowPerPage)  );        // 페이지당 끌 글 범위
			
			rs = pstmt.executeQuery();
			
            // make databean list
			tranBean dataBean = null;
			
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));
                dataBean.setROW_NUM        ((String)rs.getString("ROW_NUM"        )); 

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
	 * 카드승인내역 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectTranAllListCountTest(HashMap paramHash) throws Exception 
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
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
		
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("  SELECT COUNT(*)                                                                       \n");
            sQry.append("  FROM (                                                                                \n");
            sQry.append("  	    SELECT MIN(거래구분) AS 거래구분                                                 \n");
            sQry.append("      		 , 카드발급사코드                                                            \n");
            sQry.append("       	 , MIN(카드발급사명) AS 카드발급사명                                         \n");
            sQry.append("       	 , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                    \n");
            sQry.append("       	 , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                    \n");
            sQry.append("       	 , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                      \n");
            sQry.append("       	 , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                      \n");
            sQry.append("       	 , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                      \n");
            sQry.append("    	FROM                                                                             \n");
            sQry.append("    		(                                                				             \n");
            sQry.append("      		SELECT 거래구분                                				                 \n");
            sQry.append("           	 , 카드발급사코드                                                        \n");
            sQry.append("           	 , 카드발급사명                                         	             \n");
            sQry.append("           	 , 승인건수                                         		             \n");
            sQry.append("            	 , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액\n");
            sQry.append("           	 , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세  \n");
            sQry.append("           	 , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료  \n");
            sQry.append("           	 , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액  \n");
            sQry.append("        	  FROM 카드승인내역집계                                                      \n");
            sQry.append("       	 WHERE 1=1                                                                   \n");
            sQry.append("         	   AND 거래구분   IN ('01','02','04')                                        \n");
            sQry.append("              AND 매출월     = ?                                                        \n");
            sQry.append("           )                                                				             \n");
            sQry.append("       GROUP BY 카드발급사코드                                                          \n");
            sQry.append("   	UNION ALL                                                                        \n");
            sQry.append("   	SELECT 거래구분                                                                  \n");
            sQry.append("       	, '' AS 카드발급사코드                                                       \n");
            sQry.append("       	, '' AS 카드발급사명                                                         \n");
            sQry.append("       	, to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                     \n");
            sQry.append("       	, to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                     \n");
            sQry.append("       	, to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                       \n");
            sQry.append("       	, to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                       \n");
            sQry.append("       	, to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                       \n");
            sQry.append("   	FROM                                                			                 \n");
            sQry.append("      		(                                                			                 \n");
            sQry.append("        	SELECT 거래구분                                			                     \n");
            sQry.append("             	, '' AS 카드발급사코드                                                   \n");
            sQry.append("            	, '' AS 카드발급사명                                                     \n");
            sQry.append("           	, 승인건수                                         	                     \n");
            sQry.append("          	    , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("          	    , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("          	    , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("          	    , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("         	 FROM 카드승인내역집계                                                       \n");
            sQry.append("        	WHERE 1=1                                                                    \n");
            sQry.append("             AND 거래구분   = '03'                                                      \n");
            sQry.append("             AND 매출월     = ?                                                         \n");
            sQry.append("       	)                                                                            \n");
            sQry.append("   	GROUP BY 거래구분                                                                \n");
            sQry.append("       )                                                                                \n");
            sQry.append("  ORDER BY 거래구분, 카드발급사코드                                                     \n");

            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
            
			rs = pstmt.executeQuery();
			System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
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
	 * 카드승인내역중 카드만 포함된 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectTranCardListCountTest(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
		
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append("  SELECT COUNT(*)                                                                           \n");
            sQry.append("  FROM   (                                                                                  \n");
            sQry.append("  	   SELECT 거래구분                                                                       \n");
            sQry.append("       	, 카드발급사코드                                                                 \n");
            sQry.append("       	, 카드발급사명                                                                   \n");
            sQry.append("       	, 승인건수                                                                       \n");
            sQry.append("       	, 공급가액                                                                       \n");
            sQry.append("       	, 부가세                                                                         \n");
            sQry.append("       	, 봉사료                                                                         \n");
            sQry.append("       	, 매출액                                                                         \n");
            sQry.append("        	, ROW_NUMBER() OVER (ORDER BY 거래구분 ASC) AS ROW_NUM                           \n");
            sQry.append("  	     FROM (                                                                              \n");
            sQry.append("  	    	SELECT MIN(거래구분) AS 거래구분                                                 \n");
            sQry.append("      		 	, 카드발급사코드                                                             \n");
            sQry.append("       	 	, MIN(카드발급사명) AS 카드발급사명                                          \n");
            sQry.append("       	 	, to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                     \n");
            sQry.append("       	 	, to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                     \n");
            sQry.append("       		, to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                       \n");
            sQry.append("       	 	, to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                       \n");
            sQry.append("       	 	, to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                       \n");
            sQry.append("    		FROM                                                                             \n");
            sQry.append("    			(                                                				             \n");
            sQry.append("      			SELECT 거래구분                                				                 \n");
            sQry.append("           	 	, 카드발급사코드                                                         \n");
            sQry.append("           	 	, 카드발급사명                                         	                 \n");
            sQry.append("           	 	, 승인건수                                         		                 \n");
            sQry.append("            	 	, (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("        	  	FROM 카드승인내역집계                                                        \n");
            sQry.append("       	 	WHERE 1=1                                                                    \n");
            sQry.append("         	   	AND 거래구분   IN ('01','02','04')                                           \n");
            sQry.append("              	AND 매출월     = ?                                                           \n");
            sQry.append("           	)                                                				             \n");
            sQry.append("       	GROUP BY 카드발급사코드                                                          \n");
            sQry.append("       	)                                                                                \n");
            sQry.append("  		ORDER BY 거래구분, 카드발급사코드                                                    \n");
            sQry.append("  		)                                                								     \n");
            sQry.append("  WHERE  ROW_NUM >  ?                                                                       \n");
            sQry.append("    AND  ROW_NUM <= ?                                                                       \n");

            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            pstmt.setString(++p, (String)paramHash.get("inDate"));  //해당매출월
            pstmt.setInt   (++p, (inCurPage-1)*inRowPerPage);       // 페이지당 시작 글 범위
			pstmt.setInt   (++p, (inCurPage*inRowPerPage)  );       // 페이지당 끌 글 범위
            
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
	 * 해당 매출월별 카드 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<tranBean> selectTranMonthAllList1(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<tranBean> list = new ArrayList<tranBean>();
		
		try
		{ 
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
			String 사용자명   = JSPUtil.chkNull((String)paramHash.get("사용자명"));

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("  SELECT *                                                                                  \n");
            sQry.append("  FROM   (                                                                                  \n");
            sQry.append("  	   SELECT 거래구분                                                                       \n");
            sQry.append("       	, 카드발급사코드                                                                 \n");
            sQry.append("       	, 카드발급사명                                                                   \n");
            sQry.append("       	, 승인건수                                                                       \n");
            sQry.append("       	, 공급가액                                                                       \n");
            sQry.append("       	, 부가세                                                                         \n");
            sQry.append("       	, 봉사료                                                                         \n");
            sQry.append("       	, 매출액                                                                         \n");
            sQry.append("        	, ROW_NUMBER() OVER (ORDER BY 거래구분 ASC) AS ROW_NUM                           \n");
            sQry.append("       	, 사업자번호                                                                     \n");
            sQry.append("  	     FROM (                                                                              \n");
            sQry.append("  	    	SELECT MIN(거래구분) AS 거래구분                                                 \n");
            sQry.append("      		 	, 카드발급사코드                                                             \n");
            sQry.append("       	 	, MIN(카드발급사명) AS 카드발급사명                                          \n");
            sQry.append("       	 	, to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                     \n");
            sQry.append("       	 	, to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                     \n");
            sQry.append("       		, to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                       \n");
            sQry.append("       	 	, to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                       \n");
            sQry.append("       	 	, to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                       \n");
            sQry.append("               , MAX(사업자번호) AS 사업자번호                                              \n");
            sQry.append("    		FROM                                                                             \n");
            sQry.append("    			(                                                				             \n");
            sQry.append("      			SELECT 거래구분                                				                 \n");
            sQry.append("           	 	, 카드발급사코드                                                         \n");
            sQry.append("           	 	, 카드발급사명                                         	                 \n");
            sQry.append("           	 	, 승인건수                                         		                 \n");
            sQry.append("            	 	, (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("                   , B.사업자번호                                                           \n");
            sQry.append("        	  	FROM 카드승인내역집계                                                        \n");
            sQry.append("           		, (                                                                      \n");
            sQry.append("              			SELECT 사업자번호                                                    \n");
            sQry.append("                		  FROM 매장                                                          \n");
            sQry.append("               		 WHERE 기업코드   = ?                                                \n");
            sQry.append("                 		   AND 법인코드   = ?                                                \n");
            sQry.append("                 		   AND 브랜드코드 = ?                                                \n");
            sQry.append("                 		   AND 매장코드   = ?                                                \n");
            sQry.append("             		   ) B                                                                   \n");
            sQry.append("       	 	WHERE 1=1                                                                    \n");
            sQry.append("         	   	AND 거래구분   IN ('01','02','04')                                           \n");
            sQry.append("              	AND 매출월     = ?                                                           \n");
            sQry.append("         		AND 기업코드   = ?                                                           \n");
            sQry.append("         		AND 법인코드   = ?                                                           \n");
            sQry.append("         		AND 브랜드코드 = ?                                                           \n");
            sQry.append("         		AND 매장코드   = ?                                                           \n");
            sQry.append("           	)                                                				             \n");
            sQry.append("       	GROUP BY 카드발급사코드                                                          \n");
            sQry.append("   		UNION ALL                                                                        \n");
            sQry.append("   		SELECT 거래구분                                                                  \n");
            sQry.append("       		, '' AS 카드발급사코드                                                       \n");
            sQry.append("       		, '' AS 카드발급사명                                                         \n");
            sQry.append("       		, to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                     \n");
            sQry.append("       		, to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                     \n");
            sQry.append("       		, to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                       \n");
            sQry.append("       		, to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                       \n");
            sQry.append("       		, to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                       \n");
            sQry.append("               , '' AS 사업자번호                                                           \n");
            sQry.append("   		FROM                                                			                 \n");
            sQry.append("      			(                                                			                 \n");
            sQry.append("        		SELECT 거래구분                                			                     \n");
            sQry.append("             		, '' AS 카드발급사코드                                                   \n");
            sQry.append("            		, '' AS 카드발급사명                                                     \n");
            sQry.append("           		, 승인건수                                         	                     \n");
            sQry.append("          	    	, (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("          	    	, (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("          	    	, (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("          	    	, (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("                   , '' AS 사업자번호                                                       \n");
            sQry.append("         	 	FROM 카드승인내역집계                                                        \n");
            sQry.append("        		WHERE 1=1                                                                    \n");
            sQry.append("             	AND 거래구분   = '03'                                                        \n");
            sQry.append("             	AND 매출월     = ?                                                           \n");
            sQry.append("           	AND 기업코드   = ?                                                           \n");
            sQry.append("           	AND 법인코드   = ?                                                           \n");
            sQry.append("           	AND 브랜드코드 = ?                                                           \n");
            sQry.append("           	AND 매장코드   = ?                                                           \n");
            sQry.append("       		)                                                                            \n");
            sQry.append("   		GROUP BY 거래구분                                                                \n");
            sQry.append("       	)                                                                                \n");
            sQry.append("  		ORDER BY 거래구분, 카드발급사코드                                                    \n");
            sQry.append("  		)                                                								     \n");
            sQry.append("  WHERE  ROW_NUM >  ?                                                                       \n");
            sQry.append("    AND  ROW_NUM <= ?                                                                       \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            

            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
            
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당 매출월
            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
            
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당 매출월
            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
            
            pstmt.setInt   (++p   , (inCurPage-1)*inRowPerPage);        // 페이지당 시작 글 범위
			pstmt.setInt   (++p   , (inCurPage*inRowPerPage)  );        // 페이지당 끌 글 범위
			
			rs = pstmt.executeQuery();
			System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
            // make databean list
			tranBean dataBean = null;
			
            while( rs.next() )
            {
                dataBean = new tranBean(); 
                
                dataBean.set거래구분   	   ((String)rs.getString("거래구분"       ));
                dataBean.set카드발급사코드 ((String)rs.getString("카드발급사코드" ));
                dataBean.set카드발급사명   ((String)rs.getString("카드발급사명"   ));
                dataBean.set승인건수   	   ((String)rs.getString("승인건수"       ));
                dataBean.set공급가액   	   ((String)rs.getString("공급가액"       ));
                dataBean.set부가세   	   ((String)rs.getString("부가세"         ));
                dataBean.set봉사료   	   ((String)rs.getString("봉사료"         ));
                dataBean.set매출액   	   ((String)rs.getString("매출액"         ));
                dataBean.set사업자번호     ((String)rs.getString("사업자번호"     ));
                dataBean.setROW_NUM        ((String)rs.getString("ROW_NUM"        )); 

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
	 * 카드승인내역 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectTranAllListCount(HashMap paramHash) throws Exception 
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
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
		
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("  SELECT COUNT(*)                                                                       \n");
            sQry.append("  FROM (                                                                                \n");
            sQry.append("  	    SELECT MIN(거래구분) AS 거래구분                                                 \n");
            sQry.append("      		 , 카드발급사코드                                                            \n");
            sQry.append("       	 , MIN(카드발급사명) AS 카드발급사명                                         \n");
            sQry.append("       	 , to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                    \n");
            sQry.append("       	 , to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                    \n");
            sQry.append("       	 , to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                      \n");
            sQry.append("       	 , to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                      \n");
            sQry.append("       	 , to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                      \n");
            sQry.append("    	FROM                                                                             \n");
            sQry.append("    		(                                                				             \n");
            sQry.append("      		SELECT 거래구분                                				                 \n");
            sQry.append("           	 , 카드발급사코드                                                        \n");
            sQry.append("           	 , 카드발급사명                                         	             \n");
            sQry.append("           	 , 승인건수                                         		             \n");
            sQry.append("            	 , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액\n");
            sQry.append("           	 , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세  \n");
            sQry.append("           	 , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료  \n");
            sQry.append("           	 , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액  \n");
            sQry.append("        	  FROM 카드승인내역집계                                                      \n");
            sQry.append("       	 WHERE 1=1                                                                   \n");
            sQry.append("         	   AND 거래구분   IN ('01','02','04')                                        \n");
            sQry.append("              AND 매출월     = ?                                                        \n");
            sQry.append("              AND 기업코드   = ?                                                        \n");
            sQry.append("         	   AND 법인코드   = ?                                                        \n");
            sQry.append("         	   AND 브랜드코드 = ?                                                        \n");
            sQry.append("         	   AND 매장코드   = ?                                                        \n");
            sQry.append("           )                                                				             \n");
            sQry.append("       GROUP BY 카드발급사코드                                                          \n");
            sQry.append("   	UNION ALL                                                                        \n");
            sQry.append("   	SELECT 거래구분                                                                  \n");
            sQry.append("       	, '' AS 카드발급사코드                                                       \n");
            sQry.append("       	, '' AS 카드발급사명                                                         \n");
            sQry.append("       	, to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                     \n");
            sQry.append("       	, to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                     \n");
            sQry.append("       	, to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                       \n");
            sQry.append("       	, to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                       \n");
            sQry.append("       	, to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                       \n");
            sQry.append("   	FROM                                                			                 \n");
            sQry.append("      		(                                                			                 \n");
            sQry.append("        	SELECT 거래구분                                			                     \n");
            sQry.append("             	, '' AS 카드발급사코드                                                   \n");
            sQry.append("            	, '' AS 카드발급사명                                                     \n");
            sQry.append("           	, 승인건수                                         	                     \n");
            sQry.append("          	    , (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("          	    , (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("          	    , (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("          	    , (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("         	 FROM 카드승인내역집계                                                       \n");
            sQry.append("        	WHERE 1=1                                                                    \n");
            sQry.append("             AND 거래구분   = '03'                                                      \n");
            sQry.append("             AND 매출월     = ?                                                         \n");
            sQry.append("             AND 기업코드   = ?                                                         \n");
            sQry.append("         	  AND 법인코드   = ?                                                         \n");
            sQry.append("         	  AND 브랜드코드 = ?                                                         \n");
            sQry.append("         	  AND 매장코드   = ?                                                         \n");
            sQry.append("       	)                                                                            \n");
            sQry.append("   	GROUP BY 거래구분                                                                \n");
            sQry.append("       )                                                                                \n");
            sQry.append("  ORDER BY 거래구분, 카드발급사코드                                                     \n");

            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
            
            pstmt.setString(++p, (String)paramHash.get("inDate")    );  //해당매출월
            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
            
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
	 * 카드승인내역중 카드만 포함된 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectTranCardListCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));
		
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append("  SELECT COUNT(*)                                                                           \n");
            sQry.append("  FROM   (                                                                                  \n");
            sQry.append("  	   SELECT 거래구분                                                                       \n");
            sQry.append("       	, 카드발급사코드                                                                 \n");
            sQry.append("       	, 카드발급사명                                                                   \n");
            sQry.append("       	, 승인건수                                                                       \n");
            sQry.append("       	, 공급가액                                                                       \n");
            sQry.append("       	, 부가세                                                                         \n");
            sQry.append("       	, 봉사료                                                                         \n");
            sQry.append("       	, 매출액                                                                         \n");
            sQry.append("        	, ROW_NUMBER() OVER (ORDER BY 거래구분 ASC) AS ROW_NUM                           \n");
            sQry.append("  	     FROM (                                                                              \n");
            sQry.append("  	    	SELECT MIN(거래구분) AS 거래구분                                                 \n");
            sQry.append("      		 	, 카드발급사코드                                                             \n");
            sQry.append("       	 	, MIN(카드발급사명) AS 카드발급사명                                          \n");
            sQry.append("       	 	, to_char( SUM(승인건수),'999,999,999,999' ) AS 승인건수                     \n");
            sQry.append("       	 	, to_char( SUM(공급가액),'999,999,999,999' ) AS 공급가액                     \n");
            sQry.append("       		, to_char( SUM(부가세),'999,999,999,999' )   AS 부가세                       \n");
            sQry.append("       	 	, to_char( SUM(봉사료),'999,999,999,999' )   AS 봉사료                       \n");
            sQry.append("       	 	, to_char( SUM(매출액),'999,999,999,999' )   AS 매출액                       \n");
            sQry.append("    		FROM                                                                             \n");
            sQry.append("    			(                                                				             \n");
            sQry.append("      			SELECT 거래구분                                				                 \n");
            sQry.append("           	 	, 카드발급사코드                                                         \n");
            sQry.append("           	 	, 카드발급사명                                         	                 \n");
            sQry.append("           	 	, 승인건수                                         		                 \n");
            sQry.append("            	 	, (case 매출구분 when '01' then 공급가액 else -공급가액 end) as 공급가액 \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 부가세   else -부가세   end) as 부가세   \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 봉사료   else -봉사료   end) as 봉사료   \n");
            sQry.append("           	 	, (case 매출구분 when '01' then 매출액   else -매출액   end) as 매출액   \n");
            sQry.append("        	  	FROM 카드승인내역집계                                                        \n");
            sQry.append("       	 	WHERE 1=1                                                                    \n");
            sQry.append("         	   	AND 거래구분   IN ('01','02','04')                                           \n");
            sQry.append("              	AND 매출월     = ?                                                           \n");
            sQry.append("           	AND 기업코드   = ?                                                           \n");
            sQry.append("           	AND 법인코드   = ?                                                           \n");
            sQry.append("           	AND 브랜드코드 = ?                                                           \n");
            sQry.append("           	AND 매장코드   = ?                                                           \n");
            sQry.append("           	)                                                				             \n");
            sQry.append("       	GROUP BY 카드발급사코드                                                          \n");
            sQry.append("       	)                                                                                \n");
            sQry.append("  		ORDER BY 거래구분, 카드발급사코드                                                    \n");
            sQry.append("  		)                                                								     \n");
            sQry.append("  WHERE  ROW_NUM >  ?                                                                       \n");
            sQry.append("    AND  ROW_NUM <= ?                                                                       \n");

            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            pstmt.setString(++p, (String)paramHash.get("inDate"));  //해당매출월
            pstmt.setString(++p, (String)paramHash.get("기업코드")  );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("법인코드")  );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("매장코드")  );  //매장코드
            
            pstmt.setInt   (++p, (inCurPage-1)*inRowPerPage);       // 페이지당 시작 글 범위
			pstmt.setInt   (++p, (inCurPage*inRowPerPage)  );       // 페이지당 끌 글 범위
            
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