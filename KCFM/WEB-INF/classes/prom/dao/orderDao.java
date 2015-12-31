/** ############################################################### */
/** Program ID   : orderDao.java                                    */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package prom.dao;

import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import prom.beans.orderBean;

import com.beans.CodeBean;
import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;
import com.util.JSPUtil;

public class orderDao 
{
	/**
	 * 콤보목록 조회(진행상황)
	 * @param  
	 * @return 
	 * @throws DAOException
	 */
	public ArrayList<CodeBean> getComboBox(HashMap<String, String> paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<CodeBean> list = new ArrayList<CodeBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT '1' AS 구분					    \n");
            sQry.append("     , '1-' || 세부코드 AS 세부코드	\n");
            sQry.append("     , 세부코드명					    \n");
            sQry.append("     , 표시순서						\n");
            sQry.append("  FROM PRM공통코드					    \n");
            sQry.append(" WHERE 기업코드 = ?					\n");
            sQry.append("   AND 분류코드 = '주문상태'			\n");
            sQry.append("   AND 사용여부 = 'Y'				    \n");
            sQry.append(" UNION ALL							    \n");
            sQry.append("SELECT '2' AS 구분					    \n");
            sQry.append("     , '2-' || 세부코드 AS 세부코드	\n");
            sQry.append("     , 세부코드명					    \n");
            sQry.append("     , 표시순서						\n");
            sQry.append("  FROM PRM공통코드					    \n");
            sQry.append(" WHERE 기업코드 = ?					\n");
            sQry.append("   AND 분류코드 = '제작상태'			\n");
            sQry.append("   AND 사용여부 = 'Y'				    \n");
            sQry.append("ORDER BY 구분, 표시순서				\n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			CodeBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new CodeBean(); 

                dataBean.setStrCode((String)rs.getString("세부코드"));
                dataBean.setStrCodeName((String)rs.getString("세부코드명"));
                
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
	 * 주문 목록 조회
	 * @param  srch_key 검색어
	 * @return 
	 * @throws DAOException
	 */
	public ArrayList<orderBean> selectList(HashMap<String, String> paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<orderBean> list = new ArrayList<orderBean>();
		
		try
		{ 
			String 조회시작일자 = JSPUtil.chkNull((String)paramHash.get("조회시작일자")).replaceAll("-", "");
			String 조회종료일자 = JSPUtil.chkNull((String)paramHash.get("조회종료일자")).replaceAll("-", "");
			String 권한코드 	= JSPUtil.chkNull((String)paramHash.get("권한코드")).replaceAll("-", "");
			
			
			String excelGbn = JSPUtil.chkNull((String)paramHash.get("excelGbn")); // 엑셀구분(excelDown:엑셀/excelAllDown:전체엑셀)
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), 	"1"));  // 현재 페이지
			int inRowPerPage = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inRowPerPage"),  "1"));  // 페이지당 Row수
			//int inRowPerPage = 10;
			
			//검색 Type - 진행상황
			String optProcess = JSPUtil.chkNull((String)paramHash.get("hOptProcess"), ""); //주문상태
			String srch_type  = ""; //주문상태, 제작상태
			
			if(!"".equals(optProcess)){
				srch_type = optProcess.substring(0, 1);
				optProcess = optProcess.substring(1,3);
			}
			
			
            //검색어 - 전단지명
			String srch_key = JSPUtil.chkNull((String)paramHash.get("hoOptPromName"), "");
			
			if(!"".equals(srch_key)){
				srch_key = URLDecoder.decode(srch_key , "UTF-8");
			}

			srch_key = ("".equals(srch_key)) ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT *															                  \n");
            sQry.append("  FROM (															                  \n");
            sQry.append("        SELECT ROW_NUMBER() OVER (ORDER BY 주문번호 DESC) AS 순번	                  \n");
            sQry.append("             , A.기업코드											                  \n");
            sQry.append("             , A.법인코드											                  \n");
            sQry.append("             , H.법인명  											                  \n");
            sQry.append("             , A.브랜드코드										                  \n");
            sQry.append("             , I.브랜드명											                  \n");
            sQry.append("             , A.매장코드											                  \n");
            sQry.append("             , J.매장명											                  \n");
            sQry.append("             , J.전화지역번호||'-'||J.전화국번||'-'||J.전화개별번호   전화번호		  \n");
            sQry.append("             , A.주문번호												              \n");
            sQry.append("             , TO_CHAR(TO_DATE(A.주문일자), 'YYYY-MM-DD') AS 주문일자	              \n");
            sQry.append("             , A.홍보물코드											              \n");
            sQry.append("             , CD1.메뉴코드명 AS 홍보물코드명							              \n");
            sQry.append("             , A.홍보물번호											              \n");
            sQry.append("             , A.홍보물명												              \n");
            sQry.append("             , B.인쇄사용문구포함여부									              \n");
            sQry.append("             , CD5.세부코드명 AS 작업유형								              \n");
            sQry.append("             , A.주문사이즈											              \n");
            sQry.append("             , A.주문수량 || CD2.세부코드명 AS 주문수량				              \n");
            sQry.append("             , TO_CHAR(B.수량,'FM999,999,999,999,990') || CD2.세부코드명 AS 주문단위 \n");
            sQry.append("             , TO_CHAR(A.주문가격,'FM999,999,999,999,990') AS 주문가격               \n");
            sQry.append("             , CD3.세부코드명 AS 주문상태								              \n");
            sQry.append("             , A.시안번호												              \n");
            sQry.append("             , NVL(CD4.세부코드명,' ') 	AS 제작상태					              \n");
            sQry.append("             , A.택배사코드											              \n");
            sQry.append("             , NVL(CD6.세부코드명,' ') 	AS 택배사코드명				              \n");
            sQry.append("             , NVL(A.송장번호,' ')	    	AS 송장번호					              \n");
            sQry.append("             , NVL(A.인쇄사용문구,' ')	    AS 인쇄사용문구				              \n");
            sQry.append("             , NVL(A.추가요청사항,' ')	    AS 추가요청사항				              \n");
            sQry.append("             , A.등록자                                				              \n");
            sQry.append("             , (                                       				              \n");
            sQry.append("                SELECT 시안파일명    				                                  \n");
            sQry.append("                  FROM 홍보물시안정보                            	                  \n");
            sQry.append("                 WHERE 기업코드   = A.기업코드    				                      \n");
            sQry.append("                   AND 법인코드   = A.법인코드    				                      \n");
            sQry.append("                   AND 브랜드코드 = A.브랜드코드    				                  \n");
            sQry.append("                   AND 매장코드   = A.매장코드    				                      \n");
            sQry.append("                   AND 주문번호   = A.주문번호    				                      \n");
            sQry.append("                   AND 시안번호   = A.시안번호    				                      \n");
			sQry.append("               ) AS 시안파일명                                                       \n");
            sQry.append("          FROM 홍보물주문정보 A										              \n");
            sQry.append("             , 홍보물마스터정보 B										              \n");
            sQry.append("             , 홍보물메뉴정보 CD1										              \n");//홍보물코드
            sQry.append("             , PRM공통코드 CD2										                  \n");//단위(주문단위)
            sQry.append("             , PRM공통코드 CD3										                  \n");//주문상태
            sQry.append("             , PRM공통코드 CD4										                  \n");//제작상태
            sQry.append("             , PRM공통코드 CD5										                  \n");//인쇄사용문구포함여부(작업유형)
            sQry.append("             , PRM공통코드 CD6										                  \n");//택배사코드
            sQry.append("             , 법인 	H											                  \n");
            sQry.append("             , 브랜드	I											                  \n");
            sQry.append("             , 매장	J											                  \n");
            sQry.append("         WHERE A.기업코드 = B.기업코드								                  \n");
            sQry.append("           AND A.법인코드 = B.법인코드								                  \n");
            sQry.append("           AND A.브랜드코드 = B.브랜드코드							                  \n");
            sQry.append("           AND A.홍보물코드 = B.홍보물코드							                  \n");
            sQry.append("           AND A.홍보물번호 = B.홍보물번호							                  \n");
            sQry.append("           AND A.기업코드 	= CD1.기업코드(+)							              \n");
            sQry.append("           AND A.법인코드 	= CD1.법인코드(+)							              \n");
            sQry.append("           AND A.브랜드코드= CD1.브랜드코드(+)							              \n");
            sQry.append("           AND A.홍보물코드= CD1.메뉴코드(+)							              \n");
            sQry.append("           AND A.기업코드 = CD2.기업코드(+)							              \n");
            sQry.append("           AND A.주문단위 = CD2.세부코드(+)							              \n");
            sQry.append("           AND CD2.분류코드(+) = '단위'								              \n");
            sQry.append("           AND A.기업코드 = CD3.기업코드(+)							              \n");
            sQry.append("           AND A.주문상태 = CD3.세부코드(+)							              \n");
            sQry.append("           AND CD3.분류코드(+) = '주문상태'							              \n");
            sQry.append("           AND A.기업코드 = CD4.기업코드(+)							              \n");
            sQry.append("           AND A.제작상태 = CD4.세부코드(+)							              \n");
            sQry.append("           AND CD4.분류코드(+) = '제작상태'							              \n");
            sQry.append("           AND B.기업코드 = CD5.기업코드(+)							              \n");
            sQry.append("           AND B.인쇄사용문구포함여부 = CD5.세부코드(+)				              \n");
            sQry.append("           AND CD5.분류코드(+) = '인쇄사용문구포함여부'				              \n");
            sQry.append("           AND A.기업코드 = CD6.기업코드(+)							              \n");
            sQry.append("           AND A.택배사코드 = CD6.세부코드(+)							              \n");
            sQry.append("           AND CD6.분류코드(+) = '택배사코드'							              \n");
           
            if("10".equals(권한코드)) {																	// 매장에서 조회시
	            sQry.append("           AND A.기업코드 = ?										\n");
	            sQry.append("           AND A.법인코드 = ?										\n");
	            sQry.append("           AND A.브랜드코드 = ?									\n");
	            sQry.append("           AND A.매장코드 = ?										\n");
            }else{                                                                                      // 관리자 조회시 - 선택 조회
            	
            	String groupCd = (String)paramHash.get("기업코드");
            	String corpCd  = (String)paramHash.get("법인코드");
            	String brandCd = (String)paramHash.get("브랜드코드");
            	String storeCd = (String)paramHash.get("매장코드");
            	
            	if(groupCd != null && !"".equals(groupCd)){
            		sQry.append("           AND A.기업코드 = '"+groupCd+"'   					\n");
            	}
            	
            	if(corpCd != null && !"".equals(corpCd)){
            		sQry.append("           AND A.법인코드 = '"+corpCd+"'   					\n");
            	}
            	
            	if(brandCd != null && !"".equals(brandCd)){
            		sQry.append("           AND A.브랜드코드 = '"+brandCd+"'   					\n");
            	}
            	
            	if(storeCd != null && !"".equals(storeCd)){
            		sQry.append("           AND A.매장코드 = '"+storeCd+"'   					\n");
            	}
            }
            
            if("41".equals(권한코드)) { //홍보물제작업체		
            	sQry.append("           AND B.홍보물업체코드 = '"+ (String)paramHash.get("사용자ID") +"'   					\n");
            }

            sQry.append("           AND A.주문일자 BETWEEN ? AND ?							\n");
            sQry.append("           AND H.기업코드 	 = A.기업코드							\n");
            sQry.append("           AND H.법인코드 	 = A.법인코드							\n");
            sQry.append("           AND I.기업코드 	 = A.기업코드							\n");
            sQry.append("           AND I.법인코드 	 = A.법인코드							\n");
            sQry.append("           AND I.브랜드코드 = A.브랜드코드							\n");
            sQry.append("           AND J.기업코드 	 = A.기업코드							\n");
            sQry.append("           AND J.법인코드 	 = A.법인코드							\n");
            sQry.append("           AND J.브랜드코드 = A.브랜드코드							\n");
            sQry.append("           AND J.매장코드   = A.매장코드							\n");
            
            if("S".equals(srch_type)){
            	if(!"".equals(optProcess) && optProcess != null){
            		sQry.append("           AND A.주문상태 = '"+optProcess+"'				\n");
            	}
            } else if("M".equals(srch_type)){
            	if(!"".equals(optProcess) && optProcess != null){
            		sQry.append("           AND A.제작상태 = '"+optProcess+"'				\n");
            	}
            }
            
            sQry.append("           AND A.홍보물명 LIKE ?									\n");
            sQry.append("           AND A.삭제여부 = 'N'									\n");
            sQry.append("       )															\n");
            
            if(!"excelAllDown".equals(excelGbn)){ // 전체엑셀 다운로드인 경우 제외하고 페이지처리
	            sQry.append(" WHERE  순번 >  ?												\n");
	            sQry.append("   AND  순번 <= ?												\n");
            }
            
            sQry.append(" ORDER BY 순번														\n");     

            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            if("10".equals(권한코드)) {																	// 매장에서 조회시
	            pstmt.setString(++p, (String)paramHash.get("기업코드"));
	            pstmt.setString(++p, (String)paramHash.get("법인코드"));
	            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
	            pstmt.setString(++p, (String)paramHash.get("매장코드"));
            }
            
            pstmt.setString(++p, 조회시작일자);
            pstmt.setString(++p, 조회종료일자);
            pstmt.setString(++p, srch_key);
            
            if(!"excelAllDown".equals(excelGbn)){
	            pstmt.setInt(++p   , (inCurPage-1)*inRowPerPage   );  // 페이지당 시작 글 범위
				pstmt.setInt(++p   , (inCurPage   *inRowPerPage)  );  // 페이지당 끝 글 범위
            }
            
//            System.out.println("#### [주문내역List] #### : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			orderBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new orderBean(); 

                dataBean.set순번		((String)rs.getString("순번"));
                dataBean.set기업코드	((String)rs.getString("기업코드"));
                dataBean.set법인코드	((String)rs.getString("법인코드"));
                dataBean.set법인명		((String)rs.getString("법인명"));
                dataBean.set브랜드코드	((String)rs.getString("브랜드코드"));
                dataBean.set브랜드명	((String)rs.getString("브랜드명"));
                dataBean.set매장코드	((String)rs.getString("매장코드"));
                dataBean.set매장명		((String)rs.getString("매장명"));
                dataBean.set전화번호	((String)rs.getString("전화번호"));
                dataBean.set주문번호	((String)rs.getString("주문번호"));
                dataBean.set주문일자	((String)rs.getString("주문일자"));
                dataBean.set홍보물코드	((String)rs.getString("홍보물코드"));
                dataBean.set홍보물코드명((String)rs.getString("홍보물코드명"));
                dataBean.set홍보물번호	((String)rs.getString("홍보물번호"));
                dataBean.set홍보물명	((String)rs.getString("홍보물명"));
                dataBean.set작업유형	((String)rs.getString("작업유형"));
                dataBean.set주문사이즈	((String)rs.getString("주문사이즈"));
                dataBean.set주문수량	((String)rs.getString("주문수량"));
                dataBean.set주문단위	((String)rs.getString("주문단위"));
                dataBean.set주문가격	((String)rs.getString("주문가격"));
                dataBean.set주문상태	((String)rs.getString("주문상태"));
                dataBean.set시안번호	((String)rs.getString("시안번호"));
                dataBean.set제작상태	((String)rs.getString("제작상태"));
                dataBean.set택배사코드	((String)rs.getString("택배사코드"));
                dataBean.set택배사코드명((String)rs.getString("택배사코드명"));
                dataBean.set송장번호	((String)rs.getString("송장번호"));
                dataBean.set인쇄사용문구((String)rs.getString("인쇄사용문구"));
                dataBean.set추가요청사항((String)rs.getString("추가요청사항"));
                dataBean.set등록자      ((String)rs.getString("등록자"));
                dataBean.set시안파일명  ((String)rs.getString("시안파일명"));
                
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
	 * 주문 내역 상세 조회
	 * @param  기업,법인,브랜드,매장,주문번호
	 * @return 
	 * @throws DAOException
	 */
	public orderBean selectDetail(HashMap<String, String> paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;

		orderBean dataBean = null;
		
		try
		{ 
			
			//검색 Type - 진행상황
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT *                                                                                                          \n");
            sQry.append("  FROM (                                                                                                          \n");
            sQry.append("        SELECT ROW_NUMBER() OVER (ORDER BY A.주문번호 DESC) AS 순번                                               \n");
            sQry.append("             , A.기업코드                                                                                         \n");
            sQry.append("             , A.법인코드                                                                                         \n");
            sQry.append("             , H.법인명                                                                                           \n");
            sQry.append("             , A.브랜드코드                                                                                       \n");
            sQry.append("             , I.브랜드명                                                                                         \n");
            sQry.append("             , A.매장코드                                                                                         \n");
            sQry.append("             , J.매장명                                                                                           \n");
            sQry.append("             , A.주문번호                                                                                         \n");
            sQry.append("             , TO_CHAR(TO_DATE(A.주문일자), 'YYYY-MM-DD') AS 주문일자                                             \n");
            sQry.append("             , A.홍보물코드                                                                                       \n");
            sQry.append("             , CD1.메뉴코드명 AS 홍보물코드명                                                                     \n");
            sQry.append("             , A.홍보물번호                                                                                       \n");
            sQry.append("             , A.홍보물명                                                                                         \n");
            sQry.append("             , B.인쇄사용문구포함여부                                                                             \n");
            sQry.append("             , CD5.세부코드명 AS 작업유형                                                                         \n");
            sQry.append("             , A.주문사이즈                                                                                       \n");
            sQry.append("             , A.주문수량 || CD2.세부코드명 AS 주문수량                                                           \n");
            sQry.append("             , TO_CHAR(B.수량,'FM999,999,999,999,990') || CD2.세부코드명 AS 주문단위                              \n");
            sQry.append("             , TO_CHAR(A.주문가격,'FM999,999,999,999,990') AS 주문가격                                            \n");
            sQry.append("             , CASE WHEN A.제작상태 IS NULL OR A.제작상태='00'  THEN 'S'||A.주문상태                              \n");
            sQry.append("                 ELSE 'M'||A.제작상태                                                                             \n");
            sQry.append("               END           주문상태                                                                             \n");
            sQry.append("             , CASE WHEN A.제작상태 IS NULL OR A.제작상태='00'                                                    \n");
            sQry.append("                    THEN (SELECT 세부코드명                                                                       \n");
            sQry.append("                            FROM PRM공통코드                                                                      \n");
            sQry.append("                           WHERE 사용여부='Y'                                                                     \n");
            sQry.append("                             AND 기업코드 = A.기업코드                                                            \n");
            sQry.append("                             AND 세부코드 = A.주문상태                                                            \n");
            sQry.append("                             AND 분류코드 = '주문상태' )                                                          \n");
            sQry.append("                    ELSE (SELECT 세부코드명                                                                       \n");
            sQry.append("                            FROM PRM공통코드                                                                      \n");
            sQry.append("                           WHERE 사용여부='Y'                                                                     \n");
            sQry.append("                             AND 기업코드 = A.기업코드                                                            \n");
            sQry.append("                             AND 세부코드 = A.제작상태                                                            \n");
            sQry.append("                             AND 분류코드 = '제작상태' )                                                          \n");
            sQry.append("                END AS 주문상태명                                                                                 \n");
            sQry.append("             , A.시안번호                                                                                         \n");
            sQry.append("             , A.택배사코드                                                                                       \n");
            sQry.append("             , NVL(A.송장번호,' ')         AS 송장번호                                                            \n");
            sQry.append("             , NVL(A.인쇄사용문구,' ')     AS 인쇄사용문구                                                        \n");
            sQry.append("             , NVL(A.추가요청사항,' ')     AS 추가요청사항                                                        \n");
            sQry.append("             , NVL(K.시안경로,' ')         AS 시안경로                                                            \n");
            sQry.append("             , NVL(K.시안파일명,' ')       AS 시안파일명                                                          \n");
            sQry.append("          FROM 홍보물주문정보 A                                                                                   \n");
            sQry.append("             , 홍보물마스터정보 B                                                                                 \n");
            sQry.append("             , 홍보물메뉴정보 CD1   --홍보물코드                                                                  \n");
            sQry.append("             , PRM공통코드 CD2      --단위(주문단위)                                                              \n");
            sQry.append("             , PRM공통코드 CD5      --인쇄사용문구포함여부(작업유형)                                              \n");
            sQry.append("             , 법인        H                                                                                      \n");
            sQry.append("             , 브랜드      I                                                                                      \n");
            sQry.append("             , 매장        J                                                                                      \n");
            sQry.append("             , 홍보물시안정보      K                                                                              \n");
            sQry.append("         WHERE A.기업코드 = B.기업코드                                                                            \n");
            sQry.append("           AND A.법인코드 = B.법인코드                                                                            \n");
            sQry.append("           AND A.브랜드코드 = B.브랜드코드                                                                        \n");
            sQry.append("           AND A.홍보물코드 = B.홍보물코드                                                                        \n");
            sQry.append("           AND A.홍보물번호 = B.홍보물번호                                                                        \n");
            sQry.append("           AND A.기업코드  = CD1.기업코드(+)                                                                      \n");
            sQry.append("           AND A.법인코드  = CD1.법인코드(+)                                                                      \n");
            sQry.append("           AND A.브랜드코드= CD1.브랜드코드(+)                                                                    \n");
            sQry.append("           AND A.홍보물코드= CD1.메뉴코드(+)                                                                      \n");
            sQry.append("           AND A.기업코드 = CD2.기업코드(+)                                                                       \n");
            sQry.append("           AND A.주문단위 = CD2.세부코드(+)                                                                       \n");
            sQry.append("           AND CD2.분류코드(+) = '단위'                                                                           \n");
            sQry.append("           AND B.기업코드 = CD5.기업코드(+)                                                                       \n");
            sQry.append("           AND B.인쇄사용문구포함여부 = CD5.세부코드(+)                                                           \n");
            sQry.append("           AND CD5.분류코드(+) = '인쇄사용문구포함여부'                                                           \n");
                                  
            sQry.append("           AND A.기업코드 = ?                                                                                     \n");
            sQry.append("           AND A.법인코드 = ?                                                                                     \n");
            sQry.append("           AND A.브랜드코드 = ?                                                                                   \n");
            sQry.append("           AND A.매장코드 = ?                                                                                     \n");
            sQry.append("           AND A.주문번호   = ?                                                                                   \n");
                                  
            sQry.append("           AND H.기업코드   = A.기업코드                                                                          \n");
            sQry.append("           AND H.법인코드   = A.법인코드                                                                          \n");
            sQry.append("           AND I.기업코드   = A.기업코드                                                                          \n");
            sQry.append("           AND I.법인코드   = A.법인코드                                                                          \n");
            sQry.append("           AND I.브랜드코드 = A.브랜드코드                                                                        \n");
            sQry.append("           AND J.기업코드   = A.기업코드                                                                          \n");
            sQry.append("           AND J.법인코드   = A.법인코드                                                                          \n");
            sQry.append("           AND J.브랜드코드 = A.브랜드코드                                                                        \n");
            sQry.append("           AND J.매장코드   = A.매장코드                                                                          \n");
            sQry.append("           AND A.기업코드  = K.기업코드(+)                                                                        \n");
            sQry.append("           AND A.법인코드  = K.법인코드(+)                                                                        \n");
            sQry.append("           AND A.브랜드코드 = K.브랜드코드(+)                                                                     \n");
            sQry.append("           AND A.매장코드  = K.매장코드(+)                                                                        \n");
            sQry.append("           AND A.주문번호  = K.주문번호(+)                                                                        \n");
            sQry.append("           AND A.시안번호  = K.시안번호(+)                                                                        \n");
                                                                                                                                           
            sQry.append("           AND A.삭제여부 = 'N'                                                                                   \n");
            sQry.append("       )                                                                                                          \n");

            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("매장코드"));
            pstmt.setString(++p, (String)paramHash.get("주문번호"));
            
            //System.out.println("#### [주문내역 상세조회] #### \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
            
            while( rs.next() )
            {
                dataBean = new orderBean(); 

                dataBean.set순번		((String)rs.getString("순번"));
                dataBean.set기업코드	((String)rs.getString("기업코드"));
                dataBean.set법인코드	((String)rs.getString("법인코드"));
                dataBean.set법인명		((String)rs.getString("법인명"));
                dataBean.set브랜드코드	((String)rs.getString("브랜드코드"));
                dataBean.set브랜드명	((String)rs.getString("브랜드명"));
                dataBean.set매장코드	((String)rs.getString("매장코드"));
                dataBean.set매장명		((String)rs.getString("매장명"));
                dataBean.set주문번호	((String)rs.getString("주문번호"));
                dataBean.set주문일자	((String)rs.getString("주문일자"));
                dataBean.set홍보물코드	((String)rs.getString("홍보물코드"));
                dataBean.set홍보물코드명((String)rs.getString("홍보물코드명"));
                dataBean.set홍보물번호	((String)rs.getString("홍보물번호"));
                dataBean.set홍보물명	((String)rs.getString("홍보물명"));
                dataBean.set인쇄사용문구포함여부((String)rs.getString("인쇄사용문구포함여부"));
                dataBean.set작업유형	((String)rs.getString("작업유형"));
                dataBean.set주문사이즈	((String)rs.getString("주문사이즈"));
                dataBean.set주문수량	((String)rs.getString("주문수량"));
                dataBean.set주문단위	((String)rs.getString("주문단위"));
                dataBean.set주문가격	((String)rs.getString("주문가격"));
                dataBean.set주문상태	((String)rs.getString("주문상태"));
                dataBean.set주문상태명	((String)rs.getString("주문상태명"));
                dataBean.set시안번호	((String)rs.getString("시안번호"));
                dataBean.set택배사코드	((String)rs.getString("택배사코드"));
                dataBean.set송장번호	((String)rs.getString("송장번호"));
                dataBean.set인쇄사용문구((String)rs.getString("인쇄사용문구"));
                dataBean.set추가요청사항((String)rs.getString("추가요청사항"));
                dataBean.set시안경로	((String)rs.getString("시안경로"));
                dataBean.set시안파일명	((String)rs.getString("시안파일명"));
                
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
	 * 검색 조건에 맞는 주문목록의 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectListCount(HashMap<String, String> paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			String 조회시작일자 = JSPUtil.chkNull((String)paramHash.get("조회시작일자")).replaceAll("-", "");
			String 조회종료일자 = JSPUtil.chkNull((String)paramHash.get("조회종료일자")).replaceAll("-", "");
			String 권한코드 	= JSPUtil.chkNull((String)paramHash.get("권한코드")).replaceAll("-", "");
			
			
			String optProcess = JSPUtil.chkNull((String)paramHash.get("hOptProcess"), ""); //주문상태
			String srch_type  = "";
			
			if(!"".equals(optProcess)){
				srch_type = optProcess.substring(0, 1);
				optProcess = optProcess.substring(1,3);
			}
			
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("hoOptPromName"), "");
			
			if(!"".equals(srch_key)){
				srch_key = URLDecoder.decode(srch_key , "UTF-8");
			}

			srch_key = ("".equals(srch_key)) ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT COUNT(*)											\n");
            sQry.append("  FROM 홍보물주문정보 A									\n");
            sQry.append(" WHERE 1=1													\n");
            
            if ("10".equals(권한코드)) {
                sQry.append("   AND A.기업코드 = ?									\n");
                sQry.append("   AND A.법인코드 = ?									\n");
                sQry.append("   AND A.브랜드코드 = ?								\n");
                sQry.append("   AND A.매장코드 = ?									\n");
            }
            
            sQry.append("   AND A.주문일자 BETWEEN ? AND ?							\n");
            
            if("S".equals(srch_type)){
            	if(!"".equals(optProcess) && optProcess != null){
            		sQry.append("   AND A.주문상태 = '"+optProcess+"'				\n");
            	}
            } else if("M".equals(srch_type)){
            	if(!"".equals(optProcess) && optProcess != null){
            		sQry.append("   AND A.제작상태 = '"+optProcess+"'				\n");
            	}
            }
            
            sQry.append("   AND A.홍보물명 LIKE ?									\n");
            sQry.append("   AND A.삭제여부 = 'N'									\n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            if ("10".equals(권한코드)) {
	            pstmt.setString(++p, (String)paramHash.get("기업코드"));
	            pstmt.setString(++p, (String)paramHash.get("법인코드"));
	            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
	            pstmt.setString(++p, (String)paramHash.get("매장코드"));
            }    
            pstmt.setString(++p, 조회시작일자);
            pstmt.setString(++p, 조회종료일자);
            pstmt.setString(++p, srch_key);

            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
	 * 주문번호 채번 (주문일자-매장코드-일련번호(3자리))
	 * @param  
     * @return
	 * @throws Exception
	 */
    public String selectOrderSeq(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		String orderSeq = "";
		 
		try 
		{
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' ||						\n");
            sQry.append("       ? || '-' ||													\n");
            sQry.append("	   (SELECT LPAD(NVL(SUBSTR(MAX(주문번호), -3), 0)+1, 3, '0')	\n");
            sQry.append("          FROM 홍보물주문정보										\n");
            sQry.append("         WHERE 기업코드   = ?										\n");
            sQry.append("           AND 법인코드   = ?										\n");
            sQry.append("           AND 브랜드코드 = ?										\n");
            sQry.append("           AND 매장코드   = ?										\n");
            sQry.append("           AND 등록일자   =  TO_CHAR(SYSDATE, 'YYYYMMDD'))			\n");
            sQry.append("  FROM DUAL                                                        \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("매장코드"));
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("매장코드"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) orderSeq = rs.getString(1);		
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
		
		return orderSeq;
		
    }

    /**
     * 주문정보 저장 (바로구매)
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertOrder(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		
		try
		{
			String 인쇄사용문구 = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("인쇄사용문구")), "UTF-8");
			String 추가요청사항 = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("추가요청사항")), "UTF-8");
			String 배송요청사항 = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("배송요청사항")), "UTF-8");
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("INSERT INTO 홍보물주문정보                                                 \n");
			sQry.append("( 기업코드                                                                 \n");
			sQry.append(", 법인코드                                                                 \n");
			sQry.append(", 브랜드코드                                                               \n");
			sQry.append(", 매장코드                                                                 \n");
			sQry.append(", 주문번호                                                                 \n");
			sQry.append(", 주문일자                                                                 \n");
			sQry.append(", 홍보물코드                                                               \n");
			sQry.append(", 홍보물번호                                                               \n");
			sQry.append(", 홍보물명                                                                 \n");
			sQry.append(", 주문사이즈                                                               \n");
			sQry.append(", 주문수량                                                                 \n");
			sQry.append(", 주문단위                                                                 \n");
			sQry.append(", 주문가격                                                                 \n");
			sQry.append(", 인쇄사용문구                                                             \n");
			sQry.append(", 추가요청사항                                                             \n");
			sQry.append(", 주문상태                                                                 \n");
			sQry.append(", 제작상태                                                                 \n");
			sQry.append(", 배송지번호                                                               \n");
			sQry.append(", 배송요청사항                                                             \n");
			sQry.append(", 등록자                                                                   \n");
			sQry.append(", 등록일자                                                                 \n");
			sQry.append(", 삭제여부                                                                 \n");
			sQry.append(", 최종변경일시                                                             \n");
			sQry.append(")                                                                          \n");
			sQry.append("SELECT 기업코드                                                            \n");  //--
			sQry.append("     , 법인코드                                                            \n");  //--
			sQry.append("     , 브랜드코드                                                          \n");  //--
			sQry.append("     , ?                                                                   \n");  //--매장코드
			sQry.append("     , ?                                                                   \n");  //--주문번호
			sQry.append("     , CASE WHEN ? = '01' THEN TO_CHAR(SYSDATE, 'YYYYMMDD')                \n");
			sQry.append("            ELSE ''                                                        \n");
			sQry.append("       END                                                                 \n");  //--주문일자
			sQry.append("     , 홍보물코드                                                          \n");  //--
			sQry.append("     , 홍보물번호                                                          \n");  //--
			sQry.append("     , 홍보물명                                                            \n");  //--
			sQry.append("     , 사이즈                                                              \n");  //--주문사이즈
			sQry.append("     , ?                                                                   \n");  //--주문수량
			sQry.append("     , 단위                                                                \n");  //--주문단위
			sQry.append("     , 매출단가 * ?                                                        \n");  //--주문가격
			sQry.append("     , ?                                                                   \n");  //--인쇄사용문구
			sQry.append("     , ?                                                                   \n");  //--추가요청사항
			sQry.append("     , ?                                                                   \n");  //--주문상태
			sQry.append("     , '00'                                                                \n");  //--제작상태
			sQry.append("     , ?                                                                   \n");  //--배송지번호
			sQry.append("     , ?                                                                   \n");  //--배송요청사항
			sQry.append("     , ?                                                                   \n");  //--등록자
			sQry.append("     , TO_CHAR(SYSDATE, 'YYYYMMDD')                                        \n");  //--등록일자
			sQry.append("     , 'N'                                                                 \n");  //--삭제여부
			sQry.append("     , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')                           \n");  //--최종변경일시
			sQry.append("  FROM 홍보물마스터정보                                                    \n");
			sQry.append(" WHERE 기업코드 = ?                                                        \n");
			sQry.append("   AND 법인코드 = ?                                                        \n");
			sQry.append("   AND 브랜드코드 = ?                                                      \n");
			sQry.append("   AND 홍보물코드 = ?                                                      \n");
			sQry.append("   AND 홍보물번호 = ?                                                      \n");
						
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("매장코드"));
            pstmt.setString(++p, (String)paramData.get("주문번호"));
            pstmt.setString(++p, (String)paramData.get("주문상태"));
            pstmt.setString(++p, (String)paramData.get("주문수량"));
            pstmt.setString(++p, (String)paramData.get("주문수량"));
            pstmt.setString(++p, 인쇄사용문구);
            pstmt.setString(++p, 추가요청사항);
            pstmt.setString(++p, (String)paramData.get("주문상태"));
            pstmt.setString(++p, (String)paramData.get("배송지번호"));
            pstmt.setString(++p, 배송요청사항);
            pstmt.setString(++p, (String)paramData.get("등록자"));
            
            pstmt.setString(++p, (String)paramData.get("기업코드"));
            pstmt.setString(++p, (String)paramData.get("법인코드"));
            pstmt.setString(++p, (String)paramData.get("브랜드코드"));
            pstmt.setString(++p, (String)paramData.get("홍보물코드"));
            pstmt.setString(++p, (String)paramData.get("홍보물번호"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            
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
		
		return iRet;
            
	}

    /**
     * 주문정보 저장 (장바구니)
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateOrder01(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		
		try
		{
			String 배송요청사항 = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("배송요청사항")), "UTF-8");
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("UPDATE 홍보물주문정보											    \n");
			sQry.append("   SET 주문일자 = TO_CHAR(SYSDATE, 'YYYYMMDD')					    \n");
			sQry.append("     , 주문상태 = ?												\n");
			sQry.append("     , 배송지번호 = ?											    \n");
			sQry.append("     , 배송요청사항 = ?											\n");
			sQry.append("     , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')	\n");
			sQry.append(" WHERE 기업코드 = ?												\n");
			sQry.append("   AND 법인코드 = ?												\n");
			sQry.append("   AND 브랜드코드 = ?											    \n");
			sQry.append("   AND 매장코드 = ?												\n");
			sQry.append("   AND 주문번호 IN ("+(String)paramData.get("주문번호")+")		    \n");
			
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("주문상태"));
            pstmt.setString(++p, (String)paramData.get("배송지번호"));
            pstmt.setString(++p, 배송요청사항);
            pstmt.setString(++p, (String)paramData.get("기업코드")); 
            pstmt.setString(++p, (String)paramData.get("법인코드")); 
            pstmt.setString(++p, (String)paramData.get("브랜드코드")); 
            pstmt.setString(++p, (String)paramData.get("매장코드")); 
          
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            
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
		
		return iRet;
            
	}

    /**
     * 주문정보 저장 (장바구니)
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateCart01(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("UPDATE 홍보물주문장바구니											\n");
			sQry.append("   SET 주문상태 = ?												\n");
			sQry.append("     , 삭제여부 = 'Y'											    \n");
			sQry.append("     , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')	\n");
			sQry.append(" WHERE 기업코드 = ?												\n");
			sQry.append("   AND 법인코드 = ?												\n");
			sQry.append("   AND 브랜드코드 = ?											    \n");
			sQry.append("   AND 매장코드 = ?												\n");
			sQry.append("   AND 주문번호 IN ("+(String)paramData.get("주문번호")+")		    \n");
			
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("주문상태"));
            pstmt.setString(++p, (String)paramData.get("기업코드")); 
            pstmt.setString(++p, (String)paramData.get("법인코드")); 
            pstmt.setString(++p, (String)paramData.get("브랜드코드")); 
            pstmt.setString(++p, (String)paramData.get("매장코드")); 
          
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            
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
		
		return iRet;
            
	}

    /**
     * 주문장바구니 저장
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertCart(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("INSERT INTO 홍보물주문장바구니				\n");
			sQry.append("( 기업코드									\n");
			sQry.append(", 법인코드									\n");
			sQry.append(", 브랜드코드								\n");
			sQry.append(", 매장코드									\n");
			sQry.append(", 주문번호									\n");
			sQry.append(", 주문상태									\n");
			sQry.append(", 등록자									\n");
			sQry.append(", 등록일자									\n");
			sQry.append(", 삭제여부									\n");
			sQry.append(", 최종변경일시								\n");
			sQry.append(") VALUES (									\n");
			sQry.append("  ?										\n"); //--기업코드
			sQry.append(", ?										\n"); //--법인코드
			sQry.append(", ?										\n"); //--브랜드코드
			sQry.append(", ?										\n"); //--매장코드
			sQry.append(", ?										\n"); //--주문번호
			sQry.append(", ?										\n"); //--주문상태
			sQry.append(", ?										\n"); //--등록자
			sQry.append(", TO_CHAR(SYSDATE, 'YYYYMMDD')				\n"); //--등록일자
			sQry.append(", 'N'										\n"); //--삭제여부
			sQry.append(", TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')\n"); //--최종변경일시
			sQry.append(")											\n");
			
						
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("기업코드")); 
            pstmt.setString(++p, (String)paramData.get("법인코드")); 
            pstmt.setString(++p, (String)paramData.get("브랜드코드")); 
            pstmt.setString(++p, (String)paramData.get("매장코드")); 
            pstmt.setString(++p, (String)paramData.get("주문번호")); 
            pstmt.setString(++p, (String)paramData.get("주문상태")); 
            pstmt.setString(++p, (String)paramData.get("등록자")); 
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            
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
		
		return iRet;
            
	}

    /**
     * 주문정보 수정 (장바구니)
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateOrder(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("UPDATE 홍보물주문정보	     										\n");
			sQry.append("   SET 주문수량 = ?												\n");
			sQry.append("     , 주문가격 = ?	* ?											\n");
			sQry.append("     , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')	\n");
			sQry.append(" WHERE 기업코드 = ?												\n");
			sQry.append("   AND 법인코드 = ?												\n");
			sQry.append("   AND 브랜드코드 = ?		     									\n");
			sQry.append("   AND 매장코드 = ?												\n");
			sQry.append("   AND 주문번호 = ?												\n");
			
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("주문수량"));
            pstmt.setString(++p, (String)paramData.get("주문수량"));
            pstmt.setString(++p, (String)paramData.get("단위가격"));
            pstmt.setString(++p, (String)paramData.get("기업코드")); 
            pstmt.setString(++p, (String)paramData.get("법인코드")); 
            pstmt.setString(++p, (String)paramData.get("브랜드코드")); 
            pstmt.setString(++p, (String)paramData.get("매장코드")); 
            pstmt.setString(++p, (String)paramData.get("주문번호")); 
          
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            
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
		
		return iRet;
            
	}

    /**
     * 주문정보 삭제
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteOrder(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("UPDATE 홍보물주문정보											    \n");
			sQry.append("   SET 삭제여부 = 'Y'											    \n");
			sQry.append("     , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')	\n");
			sQry.append(" WHERE 기업코드 = ?												\n");
			sQry.append("   AND 법인코드 = ?												\n");
			sQry.append("   AND 브랜드코드 = ?											    \n");
			sQry.append("   AND 매장코드 = ?												\n");
			sQry.append("   AND 주문번호 = ?												\n");
			
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("기업코드")); 
            pstmt.setString(++p, (String)paramData.get("법인코드")); 
            pstmt.setString(++p, (String)paramData.get("브랜드코드")); 
            pstmt.setString(++p, (String)paramData.get("매장코드")); 
            pstmt.setString(++p, (String)paramData.get("주문번호")); 
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            
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
		
		return iRet;
            
	}

    /**
     * 주문장바구니 삭제
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteCart(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("UPDATE 홍보물주문장바구니											\n");
			sQry.append("   SET 삭제여부 = 'Y'											    \n");
			sQry.append("     , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')	\n");
			sQry.append(" WHERE 기업코드 = ?												\n");
			sQry.append("   AND 법인코드 = ?												\n");
			sQry.append("   AND 브랜드코드 = ?											    \n");
			sQry.append("   AND 매장코드 = ?												\n");
			sQry.append("   AND 주문번호 = ?												\n");
			
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("기업코드")); 
            pstmt.setString(++p, (String)paramData.get("법인코드")); 
            pstmt.setString(++p, (String)paramData.get("브랜드코드")); 
            pstmt.setString(++p, (String)paramData.get("매장코드")); 
            pstmt.setString(++p, (String)paramData.get("주문번호")); 
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            

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
		
		return iRet;
            
	}

	/**
	 * 주문내역 조회 (장바구니)
	 * @param  
	 * @return 
	 * @throws DAOException
	 */
	public ArrayList<orderBean> selectOrder00(HashMap paramData) throws DAOException
	{
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<orderBean> list = new ArrayList<orderBean>();
		String 주문번호 = JSPUtil.chkNull((String)paramData.get("주문번호"));
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT A.기업코드                                                                       \n");
            sQry.append("     , A.법인코드                                                                       \n");
            sQry.append("     , A.브랜드코드                                                                     \n");
            sQry.append("     , A.매장코드                                                                       \n");
            sQry.append("     , A.주문번호                                                                       \n");
            sQry.append("     , A.홍보물코드                                                                     \n");
            sQry.append("     , A.홍보물번호                                                                     \n");
            sQry.append("     , A.홍보물명                                                                       \n");
            sQry.append("     , TO_CHAR(C.수량,'FM999,999,999,999,990') || D.세부코드명 AS 주문단위              \n");
            sQry.append("     , C.매출단가 AS 단위가격                                                           \n");
            sQry.append("     , A.주문수량                                                                       \n");
            sQry.append("     , A.주문가격                                                                       \n");
            sQry.append(" FROM 홍보물주문정보 A                                                                  \n");
            sQry.append("    , 홍보물주문장바구니 B                                                              \n");
            sQry.append("    , 홍보물마스터정보 C                                                                \n");
            sQry.append("    , PRM공통코드 D                                                                     \n");
            sQry.append("WHERE A.기업코드 = B.기업코드                                                           \n");
            sQry.append("  AND A.법인코드 = B.법인코드                                                           \n");
            sQry.append("  AND A.브랜드코드 = B.브랜드코드                                                       \n");
            sQry.append("  AND A.매장코드 = B.매장코드                                                           \n");
            sQry.append("  AND A.주문번호 = B.주문번호                                                           \n");
            sQry.append("  AND A.기업코드 = C.기업코드                                                           \n");
            sQry.append("  AND A.법인코드 = C.법인코드                                                           \n");
            sQry.append("  AND A.브랜드코드 = C.브랜드코드                                                       \n");
            sQry.append("  AND A.홍보물코드 = C.홍보물코드                                                       \n");
            sQry.append("  AND A.홍보물번호 = C.홍보물번호                                                       \n");
            sQry.append("  AND C.기업코드 = D.기업코드                                                           \n");
            sQry.append("  AND C.단위 = D.세부코드                                                               \n");
            sQry.append("  AND A.기업코드 = ?                                                                    \n");
            sQry.append("  AND A.법인코드 = ?                                                                    \n");
            sQry.append("  AND A.브랜드코드 = ?                                                                  \n");
            sQry.append("  AND A.매장코드 = ?                                                                    \n");
                                                                                                                 
            if(!"".equals(주문번호) && 주문번호 != null){                                                       
            sQry.append("  AND A.주문번호 IN ("+(String)paramData.get("주문번호")+")                             \n");
            }                                                                                                    
                                                                                                                 
            sQry.append("  AND A.주문상태 = '00'                                                                 \n");
            sQry.append("  AND A.삭제여부 = 'N'                                                                  \n");
            sQry.append("  AND B.주문상태 = '00'                                                                 \n");
            sQry.append("  AND B.삭제여부 = 'N'                                                                  \n");
            sQry.append("  AND D.분류코드 = '단위'                                                               \n");
            sQry.append("ORDER BY A.주문번호 DESC                                                                \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramData.get("기업코드"));
            pstmt.setString(++p, (String)paramData.get("법인코드"));
            pstmt.setString(++p, (String)paramData.get("브랜드코드"));
            pstmt.setString(++p, (String)paramData.get("매장코드"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			orderBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new orderBean(); 

                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set매장코드((String)rs.getString("매장코드"));
                dataBean.set주문번호((String)rs.getString("주문번호"));
                dataBean.set홍보물코드((String)rs.getString("홍보물코드"));
                dataBean.set홍보물번호((String)rs.getString("홍보물번호"));
                dataBean.set홍보물명((String)rs.getString("홍보물명"));
                dataBean.set주문단위((String)rs.getString("주문단위"));
                dataBean.set단위가격((String)rs.getString("단위가격"));
                dataBean.set주문수량((String)rs.getString("주문수량"));
                dataBean.set주문가격((String)rs.getString("주문가격"));
                
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
	 * 주문내역 조회 (바로구매)
	 * @param  
	 * @return 
	 * @throws DAOException
	 */
	public ArrayList<orderBean> selectOrder01(HashMap paramData) throws DAOException
	{
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<orderBean> list = new ArrayList<orderBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT A.기업코드															\n");
            sQry.append("     , A.법인코드															\n");
            sQry.append("     , A.브랜드코드														\n");
            sQry.append("     , A.홍보물코드														\n");
            sQry.append("     , A.홍보물번호														\n");
            sQry.append("     , A.홍보물명															\n");
            sQry.append("     , TO_CHAR(A.수량,'FM999,999,999,999,990') || B.세부코드명 AS 주문단위	\n");
            sQry.append("     , A.매출단가       AS 단위가격										\n");
            sQry.append("     , ?                AS 주문수량										\n");
            sQry.append("     , A.매출단가 * ?   AS 주문가격										\n");
            sQry.append("  FROM 홍보물마스터정보 A												    \n");
            sQry.append("     , PRM공통코드		 B													\n");
            sQry.append(" WHERE A.기업코드   = B.기업코드											\n");
            sQry.append("   AND A.단위       = B.세부코드											\n");
            sQry.append("   AND A.기업코드   = ?													\n");
            sQry.append("   AND A.법인코드   = ?													\n");
            sQry.append("   AND A.브랜드코드 = ?													\n");
            sQry.append("   AND A.홍보물코드 = ?													\n");
            sQry.append("   AND A.홍보물번호 = ?													\n");
            sQry.append("   AND B.분류코드   = '단위'												\n");
            sQry.append("   AND A.삭제여부   = 'N'													\n");

            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramData.get("주문수량"));
            pstmt.setString(++p, (String)paramData.get("주문수량"));
            pstmt.setString(++p, (String)paramData.get("기업코드"));
            pstmt.setString(++p, (String)paramData.get("법인코드"));
            pstmt.setString(++p, (String)paramData.get("브랜드코드"));
            pstmt.setString(++p, (String)paramData.get("홍보물코드"));
            pstmt.setString(++p, (String)paramData.get("홍보물번호"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			orderBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new orderBean(); 

                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set홍보물코드((String)rs.getString("홍보물코드"));
                dataBean.set홍보물번호((String)rs.getString("홍보물번호"));
                dataBean.set홍보물명((String)rs.getString("홍보물명"));
                dataBean.set주문단위((String)rs.getString("주문단위"));
                dataBean.set단위가격((String)rs.getString("단위가격"));
                dataBean.set주문수량((String)rs.getString("주문수량"));
                dataBean.set주문가격((String)rs.getString("주문가격"));
                
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
	 * selectbox 법인코드 조회
	 * @param groupCd 기업코드
	 * @return 법인코드 리스트
	 * @throws DAOException
	 */
	public ArrayList<orderBean> selectGroupCdList(String groupCd, String sseCustAuth) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<orderBean> list = new ArrayList<orderBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT 법인코드                \n");
            sQry.append("      , 법인명                  \n");
            sQry.append("      , 기업코드                \n");
            sQry.append("   FROM 법인                    \n");
            sQry.append("  WHERE 1=1                     \n");
           	
            if(!"41".equals(sseCustAuth) && !"90".equals(sseCustAuth)){ //전단지업체, 슈퍼유저는 전체 검색
            sQry.append("  	 AND 기업코드 = '"+ groupCd +"'            \n");
            }
            
            sQry.append("    AND 사용여부 = 'Y'          \n");
            sQry.append("    AND 삭제여부 = 'N'          \n");
            sQry.append("    ORDER BY 법인명             \n");
            
            // set preparedstatemen
//            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
//            pstmt.setString(++p, groupCd);
            
            
//            System.out.println("#### [법인코드 리스트 조회] #### : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			orderBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new orderBean(); 

                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set법인명((String)rs.getString("법인명"));
                dataBean.set기업코드((String)rs.getString("기업코드"));
                
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
	 * selectbox 브랜드코드 조회
	 * @param 기업코드, 법인코드
	 * @return 브랜드코드 리스트
	 * @throws DAOException
	 */
	public ArrayList<orderBean> selectBrandCdList(String groupCd, String corpCd) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<orderBean> list = new ArrayList<orderBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT 브랜드코드                   \n");
            sQry.append("      , 브랜드명                     \n");
            sQry.append("   FROM 브랜드                       \n");
            sQry.append("  WHERE 1=1                          \n");
            
            if(groupCd != null && !"".equals(groupCd)){
            	sQry.append("    AND 기업코드 = '"+groupCd+"'                 \n");
            }
            
            if(corpCd != null && !"".equals(corpCd)){
            	sQry.append("    AND 법인코드 = '"+corpCd+"'  \n");
            }
            
            sQry.append("    AND 사용여부 = 'Y'               \n");
            sQry.append("    AND 삭제여부 = 'N'               \n");
            sQry.append("    ORDER BY 브랜드명                \n");
            
            // set preparedstatemen
//            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
//            pstmt.setString(++p, groupCd);
            
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			orderBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new orderBean(); 

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
	 * selectbox 매장코드 조회
	 * @param groupCd
	 * @param corpCd
	 * @param brandCd
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<orderBean> selectStoreCdList(String groupCd, String corpCd, String brandCd) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<orderBean> list = new ArrayList<orderBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT 매장코드                              \n");
            sQry.append("      , 매장명                                \n");
            sQry.append("   FROM 매장                                  \n");
            sQry.append("  WHERE 1=1                                   \n");
            if(groupCd != null && !"".equals(groupCd)){
            	sQry.append("    AND 기업코드 = '"+groupCd+"'                 \n");
            }
            
            if(corpCd != null && !"".equals(corpCd)){
            	sQry.append("    AND 법인코드 = '"+corpCd+"'           \n");
            }
            
            if(brandCd != null && !"".equals(brandCd)){
            	sQry.append("    AND 브랜드코드 = '"+brandCd+"'        \n");
            }
            sQry.append("    AND 사용여부 = 'Y'                        \n");
            sQry.append("    AND 삭제여부 = 'N'                        \n");
            sQry.append("    ORDER BY 매장명                           \n");
            
            // set preparedstatemen
//            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
//            pstmt.setString(++p, groupCd);
            
           // System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			orderBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new orderBean(); 

                dataBean.set매장코드((String)rs.getString("매장코드"));
                dataBean.set매장명((String)rs.getString("매장명"));
                
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
	 * 매장진행상태 조회
	 * @param sseGroupCd 기업코드
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<orderBean> selectStatusList(String sseGroupCd) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<orderBean> list = new ArrayList<orderBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
//            sQry.append(" SELECT                                   \n");
//            sQry.append("        세부코드 AS 주문상태              \n");
//            sQry.append("      , 세부코드명 AS 주문상태명          \n");
//            sQry.append("   FROM PRM공통코드                       \n");
//            sQry.append("  WHERE 1=1                               \n");
//            sQry.append("    AND 사용여부 = 'Y'                    \n");
//            sQry.append("    AND 기업코드 = ?                      \n");
//            sQry.append("    AND 분류코드 = '주문상태'             \n");
            
            sQry.append(" SELECT                                           \n");
            sQry.append("        'S'||세부코드 AS 주문상태                 \n");
            sQry.append("      , 세부코드명 AS 주문상태명                  \n");
            sQry.append("   FROM PRM공통코드                               \n");
            sQry.append("  WHERE 1=1                                       \n");
            sQry.append("    AND 사용여부 = 'Y'                            \n");
            sQry.append("    AND 분류코드 = '주문상태'                     \n");
            sQry.append("    AND 기업코드 = ?                              \n");
            sQry.append("  UNION ALL                                       \n");
            sQry.append(" SELECT                                           \n");
            sQry.append("        'M'||세부코드 AS 주문상태                 \n");
            sQry.append("      , 세부코드명 AS 주문상태명                  \n");
            sQry.append("   FROM PRM공통코드                               \n");
            sQry.append("  WHERE 1=1                                       \n");
            sQry.append("    AND 사용여부 = 'Y'                            \n");
            sQry.append("    AND 분류코드 = '제작상태'                     \n");
            sQry.append("    AND 기업코드 = ?                              \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, sseGroupCd);
            pstmt.setString(++p, sseGroupCd);
            
            //System.out.println("#### [주문진행상황 select box] #### \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			orderBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new orderBean(); 

                dataBean.set주문상태((String)rs.getString("주문상태"));
                dataBean.set주문상태명((String)rs.getString("주문상태명"));
                
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
	 * 홍보물시안정보 저장
	 * @param paramData
	 * @return
	 * @throws DAOException
	 */
	public int insertPromFlyerInfo(HashMap<String, String> paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" MERGE INTO 홍보물시안정보 A                                                                                                               \n");
			sQry.append(" USING (                                                                                                                                   \n");
			sQry.append("                  SELECT ? AS 기업코드                                                                                                     \n");
			sQry.append("                       , ? AS 법인코드                                                                                                     \n");
			sQry.append("                       , ? AS 브랜드코드                                                                                                   \n");
			sQry.append("                       , ? AS 매장코드                                                                                                     \n");
			sQry.append("                       , ? AS 주문번호                                                                                                     \n");
			sQry.append("                       , ? AS 시안번호                                                                                                     \n");
			sQry.append("                       , ? AS 시안경로                                                                                                     \n");
			sQry.append("                       , ? AS 시안파일명                                                                                                   \n");
			sQry.append("                       , ? AS 시안원본파일명                                                                                               \n");
			sQry.append("                    FROM DUAL                                                                                                              \n");
			sQry.append("       ) B                                                                                                                                 \n");
			sQry.append("    ON (    A.기업코드   = B.기업코드                                                                                                      \n");
			sQry.append("        AND A.법인코드   = B.법인코드                                                                                                      \n");
			sQry.append("        AND A.브랜드코드 = B.브랜드코드                                                                                                    \n");
			sQry.append("        AND A.매장코드   = B.매장코드                                                                                                      \n");
			sQry.append("        AND A.주문번호   = B.주문번호                                                                                                      \n");
			sQry.append("        AND A.시안번호   = B.시안번호                                                                                                      \n");
			sQry.append("       )                                                                                                                                   \n");
			if( "Y".equals(paramData.get("modYn1")) ){ //파일수정이 있을때만 업데이트
			sQry.append("      WHEN MATCHED THEN UPDATE SET A.시안경로 = B.시안경로                                                                                 \n");
			sQry.append("                                 , A.시안파일명 = B.시안파일명                                                                             \n");
			sQry.append("                                 , A.시안원본파일명 = B.시안원본파일명                                                                     \n");
			sQry.append("                                 , A.최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') --최종변경일시                               \n");
			}else{
				sQry.append("      WHEN MATCHED THEN UPDATE SET A.최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') --최종변경일시                           \n");
			}
			sQry.append("      WHEN NOT MATCHED THEN                                                                                                                \n");
			sQry.append("      INSERT                                                                                                                               \n");
			sQry.append("      (                                                                                                                                    \n");
			sQry.append("           A.기업코드                                                                                                                      \n");
			sQry.append("         , A.법인코드                                                                                                                      \n");
			sQry.append("         , A.브랜드코드                                                                                                                    \n");
			sQry.append("         , A.매장코드                                                                                                                      \n");
			sQry.append("         , A.주문번호                                                                                                                      \n");
			sQry.append("         , A.시안번호                                                                                                                      \n");
			sQry.append("         , A.시안경로                                                                                                                      \n");
			sQry.append("         , A.시안파일명                                                                                                                    \n");
			sQry.append("         , A.시안원본파일명                                                                                                                \n");
			sQry.append("         , A.등록자                                                                                                                        \n");
			sQry.append("         , A.등록일자                                                                                                                      \n");
			sQry.append("         , A.삭제여부                                                                                                                      \n");
			sQry.append("         , A.예비문자                                                                                                                      \n");
			sQry.append("         , A.예비숫자                                                                                                                      \n");
			sQry.append("         , A.최종변경일시                                                                                                                  \n");
			sQry.append("     ) VALUES(                                                                                                                             \n");
			sQry.append("          ?    --기업코드                                                                                                                  \n");
			sQry.append("         ,?    --법인코드                                                                                                                  \n");
			sQry.append("         ,?    --브랜드코드                                                                                                                \n");
			sQry.append("         ,?    --매장코드                                                                                                                  \n");
			sQry.append("         ,?    --주문번호                                                                                                                  \n");
			sQry.append("         ,NVL((SELECT MAX(시안번호)+1                                                                                                      \n");
			sQry.append("               FROM 홍보물시안정보                                                                                                         \n");
			sQry.append("              WHERE 기업코드   = ?                                                                                                         \n");
			sQry.append("                AND 법인코드   = ?                                                                                                         \n");
			sQry.append("                AND 브랜드코드 = ?                                                                                                         \n");
			sQry.append("                AND 매장코드   = ?                                                                                                         \n");
			sQry.append("                AND 주문번호   = ?                                                                                                         \n");
			sQry.append("                AND 삭제여부   = 'N'                                                                                                       \n");
			sQry.append("          ), 1)-- 시안번호                                                                                                                 \n");
			sQry.append("         ,?    --시안경로                                                                                                                  \n");
			sQry.append("         ,?    --시안파일명                                                                                                                \n");
			sQry.append("         ,?    --시안원본파일명                                                                                                            \n");
			sQry.append("         ,?    --등록자                                                                                                                    \n");
			sQry.append("         ,SYSDATE   --등록일자                                                                                                             \n");
			sQry.append("         ,'N'         --삭제여부                                                                                                           \n");
			sQry.append("         ,NULL       --예비문자                                                                                                            \n");
			sQry.append("         ,NULL      -- 예비숫자                                                                                                            \n");
			sQry.append("         ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') --최종변경일시                                                                         \n");
			sQry.append("     )                                                                                                                                     \n");
						
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("hGroupCd"));       //기업코드
            pstmt.setString(++p, (String)paramData.get("hCorpCd"));        //법인코드
            pstmt.setString(++p, (String)paramData.get("hBrandCd"));       //브랜드코드
            pstmt.setString(++p, (String)paramData.get("hCustStoreCd"));   //매장코드
            pstmt.setString(++p, (String)paramData.get("hOrderNo"));       //주문번호
            pstmt.setString(++p, (String)paramData.get("hPromFlyerNo"));   //시안번호
            pstmt.setString(++p, (String)paramData.get("filePath"));       //시안경로
            pstmt.setString(++p, (String)paramData.get("fileName"));       //시안파일명
            pstmt.setString(++p, (String)paramData.get("orgFileName"));    //시안원본파일명
            
            pstmt.setString(++p, (String)paramData.get("hGroupCd"));       //기업코드
            pstmt.setString(++p, (String)paramData.get("hCorpCd"));        //법인코드
            pstmt.setString(++p, (String)paramData.get("hBrandCd"));       //브랜드코드
            pstmt.setString(++p, (String)paramData.get("hCustStoreCd"));   //매장코드
            pstmt.setString(++p, (String)paramData.get("hOrderNo"));       //주문번호
            
            pstmt.setString(++p, (String)paramData.get("hGroupCd"));       //기업코드
            pstmt.setString(++p, (String)paramData.get("hCorpCd"));        //법인코드
            pstmt.setString(++p, (String)paramData.get("hBrandCd"));       //브랜드코드
            pstmt.setString(++p, (String)paramData.get("hCustStoreCd"));   //매장코드
            pstmt.setString(++p, (String)paramData.get("hOrderNo"));       //주문번호
            
            
            //pstmt.setString(++p, (String)paramData.get("hPromFlyerNo")); //시안번호
            pstmt.setString(++p, (String)paramData.get("filePath"));       //시안경로
            pstmt.setString(++p, (String)paramData.get("fileName"));       //시안파일명
            pstmt.setString(++p, (String)paramData.get("orgFileName"));    //시안원본파일명
            
            pstmt.setString(++p, (String)paramData.get("sseCustId"));      //등록자
            
            
//            System.out.println("#### [홍보물시안정보 저장] #### : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            
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
		
		return iRet;
            
	}
	
	
	/**
	 * 홍보물시안정보테이블에서 저장된 시안번호 조회
	 * @param paramData
	 * @return
	 * @throws DAOException
	 */
	public String selectPromFlyerNumber(HashMap<String, String> paramData) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		String rtnVal = "";
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                   \n");
            sQry.append("        시안번호                          \n");
            sQry.append("   FROM 홍보물시안정보                    \n");
            sQry.append("  WHERE 1=1                               \n");
            sQry.append("    AND 기업코드   = ?                    \n");
			sQry.append("    AND 법인코드   = ?                    \n");
			sQry.append("    AND 브랜드코드 = ?                    \n");
			sQry.append("    AND 매장코드   = ?                    \n");
			sQry.append("    AND 주문번호   = ?                    \n");
			sQry.append("    AND 삭제여부   = 'N'                  \n");
			
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("hGroupCd"));       //기업코드
            pstmt.setString(++p, (String)paramData.get("hCorpCd"));        //법인코드
            pstmt.setString(++p, (String)paramData.get("hBrandCd"));       //브랜드코드
            pstmt.setString(++p, (String)paramData.get("hCustStoreCd"));   //매장코드
            pstmt.setString(++p, (String)paramData.get("hOrderNo"));       //주문번호
            
            //System.out.println("#### [홍보물시안정보] #### \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            
            while( rs.next() )
            {
                rtnVal = (String)rs.getString("시안번호");                
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
		
		return rtnVal;
		
    }
	
	
	/**
	 * 홍보물주문정보 수정(인쇄문구, 추가요청사항, 진행상태, 시안) 
	 * @param paramData
	 * @return
	 * @throws DAOException
	 */
	public int updatePromOrdrInfo(HashMap<String, String> paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		String promFlyerNo = ""; //시안번호
		String orderStatus = JSPUtil.chkNull(paramData.get("hProgression1"), "");
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			promFlyerNo = this.selectPromFlyerNumber(paramData); //시안번호 조회
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("  UPDATE 홍보물주문정보                           \n");
			sQry.append("     SET 인쇄사용문구 = ?                         \n");
			sQry.append("       , 추가요청사항 = ?                         \n");
			
			
			if(!"".equals(orderStatus)){
				
				//M : 제작상태   S : 주문상태
				if( "M".equals(orderStatus.substring(0, 1)) ){
					sQry.append("       , 제작상태     = '"+orderStatus.substring(1, 3)+"'                         \n");
				}else{
					sQry.append("       , 주문상태     = '"+orderStatus.substring(1, 3)+"'                         \n");
				}
			}
			sQry.append("       , 시안번호     = ?                         \n");
			
			//관리자 90,41 이거나 등록자가 로그인ID같은경우 수정
			if("90".equals(paramData.get("sseCustAuth")) || "41".equals(paramData.get("sseCustAuth"))
			                                             || paramData.get("hInsertUserId").equals(paramData.get("sseCustId")) ){
				sQry.append("       ,수정자 = '"+ paramData.get("sseCustId") +"'                                  \n");
				sQry.append("       ,수정일자      = SYSDATE              \n");	
			}
			
			sQry.append("  WHERE 기업코드      = ?                         \n");
			sQry.append("    AND 법인코드      = ?                         \n");
			sQry.append("    AND 브랜드코드    = ?                         \n");
			sQry.append("    AND 매장코드      = ?                         \n");
			sQry.append("    AND 주문번호      = ?                         \n");
			
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramData.get("hPrintTxt"));      //인쇄사용문구
            pstmt.setString(++p, (String)paramData.get("hRequestTxt"));    //추가요청사항
            pstmt.setInt   (++p, Integer.parseInt(promFlyerNo));           //시안번호
            
            pstmt.setString(++p, (String)paramData.get("hGroupCd"));       //기업코드
            pstmt.setString(++p, (String)paramData.get("hCorpCd"));        //법인코드
            pstmt.setString(++p, (String)paramData.get("hBrandCd"));       //브랜드코드
            pstmt.setString(++p, (String)paramData.get("hCustStoreCd"));   //매장코드
            pstmt.setString(++p, (String)paramData.get("hOrderNo"));       //주문번호
            
//            System.out.println("#### [홍보물주문정보] #### : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            

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
		
		return iRet;
		
	}
	

	
	/**
	 * 홍보물시안 주문상세내역 댓글 등록, 수정
	 * @param paramData
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<orderBean> selectPromOrderComm(HashMap<String, String> paramData) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<orderBean> list = new ArrayList<orderBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("  SELECT                                              \n");
            sQry.append("        기업코드                                      \n");
            sQry.append("      , 법인코드                                      \n");
            sQry.append("      , 브랜드코드                                    \n");
            sQry.append("      , 매장코드                                      \n");
            sQry.append("      , 주문번호                                      \n");
            sQry.append("      , 댓글번호                                      \n");
            sQry.append("      , 내용                                          \n");
            sQry.append("      , TO_CHAR(등록일자, 'YYYY-MM-DD') AS 등록일자   \n");
            sQry.append("      , 등록자                                        \n");
            sQry.append("   FROM 홍보물댓글정보                                \n");
            sQry.append("  WHERE 기업코드   = ?                                \n");
            sQry.append("    AND 법인코드   = ?                                \n");
            sQry.append("    AND 브랜드코드 = ?                                \n");
            sQry.append("    AND 매장코드   = ?                                \n");
            sQry.append("    AND 주문번호   = ?                                \n");
            sQry.append("    AND 삭제여부   = 'N'                              \n");
            sQry.append("  ORDER BY 댓글번호                                   \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());  
            pstmt.setString(++p, paramData.get("hGroupCd"));      //기업코드
            pstmt.setString(++p, paramData.get("hCorpCd"));       //법인코드
            pstmt.setString(++p, paramData.get("hBrandCd"));      //브랜드코드
            pstmt.setString(++p, paramData.get("hCustStoreCd"));  //매장코드
            pstmt.setString(++p, paramData.get("hOrderNo"));      //주문번호
            
            //System.out.println("#### [홍보물 주문내역 상세 댓글정보 조회] #### : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			orderBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new orderBean(); 

                dataBean.set기업코드   ((String)rs.getString("기업코드"));
                dataBean.set법인코드   ((String)rs.getString("법인코드"));
                dataBean.set브랜드코드 ((String)rs.getString("브랜드코드"));
                dataBean.set매장코드   ((String)rs.getString("매장코드"));
                dataBean.set주문번호   ((String)rs.getString("주문번호"));
                dataBean.set댓글번호   ((String)rs.getString("댓글번호"));
                dataBean.set내용       ((String)rs.getString("내용"));
                dataBean.set등록일자   ((String)rs.getString("등록일자"));
                dataBean.set등록자     ((String)rs.getString("등록자"));
                
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
	 * 홍보물시안 주문상세내역 댓글 등록, 수정
	 * @param paramData
	 * @return
	 * @throws DAOException
	 */
	public int insertPromOrderComm(HashMap<String, String> paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int iRet = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append("  MERGE INTO 홍보물댓글정보 A                                                                                          \n");
			sQry.append("  USING (                                                                                                              \n");
			sQry.append("          SELECT ? AS 기업코드                                                                                         \n");
			sQry.append("               , ? AS 법인코드                                                                                         \n");
			sQry.append("               , ? AS 브랜드코드                                                                                       \n");
			sQry.append("               , ? AS 매장코드                                                                                         \n");
			sQry.append("               , ? AS 주문번호                                                                                         \n");
			sQry.append("               , ? AS 댓글번호                                                                                         \n");
			sQry.append("            FROM DUAL                                                                                                  \n");
			sQry.append("        ) B                                                                                                            \n");
			sQry.append("     ON (    A.기업코드   = B.기업코드                                                                                 \n");
			sQry.append("         AND A.법인코드   = B.법인코드                                                                                 \n");
			sQry.append("         AND A.브랜드코드 = B.브랜드코드                                                                               \n");
			sQry.append("         AND A.매장코드   = B.매장코드                                                                                 \n");
			sQry.append("         AND A.주문번호   = B.주문번호                                                                                 \n");
			sQry.append("         AND A.댓글번호   = B.댓글번호                                                                                 \n");
			sQry.append("        )                                                                                                              \n");
			sQry.append("  WHEN MATCHED THEN UPDATE SET A.내용 = ?                                                                              \n");
			sQry.append("                             , A.최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') --최종변경일시               \n");
			sQry.append("  WHEN NOT MATCHED THEN                                                                                                \n");
			sQry.append("       INSERT                                                                                                          \n");
			sQry.append("       (                                                                                                               \n");
			sQry.append("            A.기업코드                                                                                                 \n");
			sQry.append("          , A.법인코드                                                                                                 \n");
			sQry.append("          , A.브랜드코드                                                                                               \n");
			sQry.append("          , A.매장코드                                                                                                 \n");
			sQry.append("          , A.주문번호                                                                                                 \n");
			sQry.append("          , A.댓글번호                                                                                                 \n");
			sQry.append("          , A.내용                                                                                                     \n");
			sQry.append("          , A.공개여부                                                                                                 \n");
			sQry.append("          , A.등록자                                                                                                   \n");
			sQry.append("          , A.등록일자                                                                                                 \n");
			sQry.append("          , A.등록패스워드                                                                                             \n");
			sQry.append("          , A.삭제여부                                                                                                 \n");
			sQry.append("          , A.예비문자                                                                                                 \n");
			sQry.append("          , A.예비숫자                                                                                                 \n");
			sQry.append("          , A.최종변경일시                                                                                             \n");
			sQry.append("        ) VALUES(                                                                                                      \n");
			sQry.append("           ?    --기업코드                                                                                             \n");
			sQry.append("          ,?    --법인코드                                                                                             \n");
			sQry.append("          ,?    --브랜드코드                                                                                           \n");
			sQry.append("          ,?    --매장코드                                                                                             \n");
			sQry.append("          ,?    --주문번호                                                                                             \n");
			sQry.append("          ,NVL((SELECT MAX(댓글번호)+1                                                                                 \n");
			sQry.append("                FROM 홍보물댓글정보                                                                                    \n");
			sQry.append("               WHERE 기업코드   = ?                                                                                    \n");
			sQry.append("                 AND 법인코드   = ?                                                                                    \n");
			sQry.append("                 AND 브랜드코드 = ?                                                                                    \n");
			sQry.append("                 AND 매장코드   = ?                                                                                    \n");
			sQry.append("                 AND 주문번호   = ?                                                                                    \n");
			sQry.append("                 AND 삭제여부   = 'N'                                                                                  \n");
			sQry.append("           ), 1)      -- 댓글번호                                                                                      \n");
			sQry.append("          ,?          --내용                                                                                           \n");
			sQry.append("          ,'Y'        --공개여부                                                                                       \n");
			sQry.append("          ,?          --등록자                                                                                         \n");
			sQry.append("          ,SYSDATE    --등록일자                                                                                       \n");
			sQry.append("          ,NULL       --등록패스워드                                                                                   \n");
			sQry.append("          ,'N'        --삭제여부                                                                                       \n");
			sQry.append("          ,NULL       --예비문자                                                                                       \n");
			sQry.append("          ,NULL       -- 예비숫자                                                                                      \n");
			sQry.append("          ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') --최종변경일시                                                    \n");
			sQry.append("        )                                                                                                              \n");
						
            int p = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            //비교
            pstmt.setString(++p, (String)paramData.get("hGroupCd"));       //기업코드
            pstmt.setString(++p, (String)paramData.get("hCorpCd"));        //법인코드
            pstmt.setString(++p, (String)paramData.get("hBrandCd"));       //브랜드코드
            pstmt.setString(++p, (String)paramData.get("hCustStoreCd"));   //매장코드
            pstmt.setString(++p, (String)paramData.get("hOrderNo"));       //주문번호
            pstmt.setInt   (++p, Integer.parseInt(paramData.get("hCommNum")));  //댓글번호
            
            //수정
            pstmt.setString(++p, (String)paramData.get("hCommTxt"));       //댓글내용
            
            //신규
            pstmt.setString(++p, (String)paramData.get("hGroupCd"));       //기업코드
            pstmt.setString(++p, (String)paramData.get("hCorpCd"));        //법인코드
            pstmt.setString(++p, (String)paramData.get("hBrandCd"));       //브랜드코드
            pstmt.setString(++p, (String)paramData.get("hCustStoreCd"));   //매장코드
            pstmt.setString(++p, (String)paramData.get("hOrderNo"));       //주문번호
            
            //댓글번호 생성
            pstmt.setString(++p, (String)paramData.get("hGroupCd"));       //기업코드
            pstmt.setString(++p, (String)paramData.get("hCorpCd"));        //법인코드
            pstmt.setString(++p, (String)paramData.get("hBrandCd"));       //브랜드코드
            pstmt.setString(++p, (String)paramData.get("hCustStoreCd"));   //매장코드
            pstmt.setString(++p, (String)paramData.get("hOrderNo"));       //주문번호
            
            pstmt.setString(++p, (String)paramData.get("hCommTxt"));       //댓글내용
            pstmt.setString(++p, (String)paramData.get("sseCustId"));       //등록자
            
            
            //System.out.println("#### [홍보물시안 주문상세 댓글 등록] #### : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            iRet = pstmt.executeUpdate();
            
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
		
		return iRet;
            
	}
	
	
	
}