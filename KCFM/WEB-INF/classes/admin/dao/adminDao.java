package admin.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.net.URLDecoder;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

import admin.beans.adminBean;

import com.util.JSPUtil;

public class adminDao {

	/** ############################################################### */
	/** Program ID   : adminDao.java                                    */
	/** Program Name : adminDao                              			*/
	/** Program Desc : 관리자 Dao 			                 			*/
	/** Create Date  : 2015.04.10                                       */
	/** Programmer   : Hojun.Choi                                       */
	/** Update Date  :                                                  */
	/** ############################################################### */

	/**
	 * 공지사항-교육자료 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<adminBean> selectNoticeList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<adminBean> list = new ArrayList<adminBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));			
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));			
			
			//-------------------------------------------------------------------------------------------
			//  검색어 선언 및 정의
			//-------------------------------------------------------------------------------------------
			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	

            //검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));
			String search_type = JSPUtil.chkNull((String)paramHash.get("search_type"));
			search_type = URLDecoder.decode(search_type , "UTF-8");
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			if (srch_type.equals("notice")) {
				System.out.println("노티스 작동중 입니다");
				System.out.println(srch_key);
				if ("긴급".equals(srch_key)) {
					System.out.println("긴급 작동중입니다.");
					srch_key="2";
				}else if ("공지".equals(srch_key)||"일반".equals(srch_key)) {
				srch_key="1";
				}
			}
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			//-------------------------------------------------------------------------------------------
			
			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"),"01");			//게시구분						

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
            sQry.append("       , 게시구분                                 AS 게시구분코드   \n");
            sQry.append("       , 제목                                                       \n");
            sQry.append("       , 내용                                                       \n");
            sQry.append("       , 조회수                                                     \n");
            sQry.append("       , 등록자                                                     \n");
            sQry.append("       , DECODE(공지구분,'2','긴급','일반')       AS 공지구분		 \n");
            sQry.append("       , TO_CHAR(등록일자,'YYYY-MM-DD')           AS 등록일자       \n");
            sQry.append("                    , FNC_COMMENT_STATUS_INFO(A.기업코드            \n");
            sQry.append("                                             ,A.법인코드            \n");
            sQry.append("                                             ,A.브랜드코드          \n");
            sQry.append("                                             ,A.게시구분            \n");
            sQry.append("                                             ,A.게시번호)  AS 상태  \n");
            sQry.append("   FROM 게시등록정보     A                                          \n");
            sQry.append("  WHERE 1=1                                               			 \n");
            
	        if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            sQry.append("    AND  기업코드  = ?                                              \n");  // 01.기업코드
	            sQry.append("    AND  법인코드  = ?                                              \n");  // 02.법인코드
	        }
            
            sQry.append("    AND  게시구분  = ?                                              \n");  // 03.게시구분
            sQry.append("    AND( 						                                     \n");
            sQry.append("    	 		(게시시작일자  <= ? AND 게시종료일자 >= ?)           \n");  // 04.조회시작일자  05.조회종료일자
            sQry.append("     		 OR  게시시작일자  BETWEEN ?                             \n");  // 06.조회시작일자
            sQry.append("                                  AND ?                             \n");  // 07.조회종료일자
            sQry.append("       )                                                            \n");
            //-------------------------------------------------------------------------------------------------------
	            if (srch_type.equals("title")) {
	                sQry.append("   AND  제목 LIKE ?                                             \n");
	            } else if(srch_type.equals("content")) {
	                sQry.append("   AND  내용 LIKE ?                                             \n");
	            } else if(srch_type.equals("writer")) {
	                sQry.append("   AND  등록자   LIKE ?  										 \n");
	            } else if(srch_type.equals("notice")) {
	                sQry.append("   AND  공지구분   LIKE ?  									 \n");
	            }
	            else {
	                sQry.append("   AND ( 제목 LIKE ?  or 내용 LIKE ? or 등록자 LIKE ?    )      \n");
	            }
            //-------------------------------------------------------------------------------------------------------
            sQry.append("   AND 삭제여부 = 'N'                                            	 \n");
            sQry.append(" )                                                                  \n");
            sQry.append(" WHERE  ROW_NUM >  ?                                                \n");
            sQry.append("   AND  ROW_NUM <= ?                                                \n");
            sQry.append(" ORDER BY 게시번호 DESC                                             \n");     

            //-------------------------------------------------------------------------------------------
            // preparedstatemen
            //-------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
	        
            if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, 기업코드);                                                          // 01.기업코드
	            pstmt.setString(++p, 법인코드);                                                          // 02.법인코드
	        }
            
            pstmt.setString(++p, page_gb);                                                           // 03.게시구분
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );                         // 04.조회시작일자 
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );                         // 05.조회종료일자
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );                         // 06.조회시작일자 
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );                         // 07.조회종료일자
            
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
            
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			//-------------------------------------------------------------------------------------------
            // make databean list
			//-------------------------------------------------------------------------------------------
			adminBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new adminBean(); 
                
                dataBean.setROW_NUM      ((String)rs.getString("ROW_NUM"       )); 
                dataBean.set기업코드     ((String)rs.getString("기업코드"      ));
                dataBean.set법인코드     ((String)rs.getString("법인코드"      ));
                dataBean.set브랜드코드   ((String)rs.getString("브랜드코드"    ));
                dataBean.set게시번호     ((String)rs.getString("게시번호"      ));
                dataBean.set제목         ((String)rs.getString("제목"          ));
                dataBean.set내용         ((String)rs.getString("내용"          ));
                dataBean.set조회수       ((String)rs.getString("조회수"        ));
                dataBean.set등록자       ((String)rs.getString("등록자"        ));
                dataBean.set등록일자     ((String)rs.getString("등록일자"      ));
                dataBean.set공지구분     ((String)rs.getString("공지구분"  	   ));
                dataBean.set상태         ((String)rs.getString("상태"          ));
                dataBean.set게시구분코드 ((String)rs.getString("게시구분코드"  ));
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
	 * 검색 조건에 맞는 공지사항-교육자료 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectNoticeListCount(HashMap paramHash) throws Exception 
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
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));			

			//-------------------------------------------------------------------------------------------
			//  FAQ 관리 검색어 선언 및 정의
			//-------------------------------------------------------------------------------------------	
			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");   //검색Type	
			
			//검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));         //검색어	
			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			//-------------------------------------------------------------------------------------------
			if (srch_type.equals("notice")) {
				System.out.println("노티스 작동중 입니다");
				System.out.println(srch_key);
				if ("긴급".equals(srch_key)) {
					System.out.println("긴급 작동중입니다.");
					srch_key="2";
				}else if ("공지".equals(srch_key)||"일반".equals(srch_key)) {
				srch_key="1";
				}
			}
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";

			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"));			
			con = DBConnect.getInstance().getConnection();
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT COUNT(*)                                                   \n");
            sQry.append("   FROM 게시등록정보   A                                           \n");
            sQry.append("  WHERE 1=1            		                                    \n");
            
	        if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            sQry.append("    AND 기업코드  = ?                                              \n");  // 01.기업코드
	            sQry.append("    AND 법인코드  = ?                                              \n");  // 02.법인코드
	        }
	        
            sQry.append("    AND 게시구분  = ?                                              \n");  // 03.게시구분
            sQry.append("    AND( 						                                    \n");
            sQry.append("    	  게시시작일자  <= ? AND 게시종료일자 >= ?                  \n");
            sQry.append("     OR  게시시작일자  BETWEEN ?                                   \n");
            sQry.append("                           AND ?                                   \n");
            sQry.append("        )                                                          \n");
            sQry.append("    AND 삭제여부 = 'N'                                          	\n");
            //-------------------------------------------------------------------------------------------
            if (srch_type.equals("title")) {
                sQry.append("   AND  제목 LIKE ?                                            \n");
            } else if(srch_type.equals("content")) {
                sQry.append("   AND  내용 LIKE ?                                            \n");
            } else if(srch_type.equals("writer")) {
                sQry.append(" AND  등록자   LIKE ?  										\n");
            } else if(srch_type.equals("notice")) {
                sQry.append(" AND  공지구분   LIKE ?  										\n");
            } else {
                sQry.append("   AND ( 제목 LIKE ?  or 내용 LIKE ? or 등록자 LIKE ?  )       \n");
            }
            //-------------------------------------------------------------------------------------------
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            
	        if(!("90").equals(권한코드)) {															//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, 기업코드);                                                     // 01.기업코드
	            pstmt.setString(++p, 법인코드);                                                     // 02.법인코드
	        }
	        
            pstmt.setString(++p, page_gb);   											       	   // 03.게시구분
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );  
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );  
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );
            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }

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
	 * 건의사항-요청사항 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */	
	public ArrayList<adminBean> selectClaimList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<adminBean> list = new ArrayList<adminBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드")  );
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드")  );
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));			
			String 조회구분   = JSPUtil.chkNull((String)paramHash.get("조회구분")  );
			String 상태구분   = JSPUtil.chkNull((String)paramHash.get("상태구분")  );
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));		
			
																					
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");        //검색 Type	

			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			   //검색어
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"),"11");		   //건의요청구분						
			con = DBConnect.getInstance().getConnection();
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                                               \n");
            sQry.append(" *                                                                    \n");
            sQry.append(" FROM                                                                 \n");
            sQry.append(" (                                                                    \n");
            sQry.append("   SELECT                                                             \n");
            sQry.append("         ROW_NUMBER() OVER (ORDER BY 건의요청번호 DESC) AS ROW_NUM    \n");
            sQry.append("       , A.기업코드                                                   \n");
            sQry.append("       , A.법인코드                                                   \n");
            sQry.append("       , A.브랜드코드                                                 \n");
            sQry.append("       , A.건의요청번호                               AS 게시번호     \n");
            sQry.append("       , A.제목                                                       \n");
            sQry.append("       , A.내용                                                       \n");
            sQry.append("       , A.조회수                                                     \n");
            sQry.append("       , A.공개여부                                                   \n");
            sQry.append("       , A.매장코드                                                   \n");
            sQry.append("       , B.매장명                                                     \n");
            sQry.append("       , case when A.요청구분='01' then '물류'                        \n");
            sQry.append("              when A.요청구분='02' then 'POS'                         \n");
            sQry.append("              when A.요청구분='03' then '인테리어'                    \n");
            sQry.append("         end                                          AS 요청구분     \n");
            sQry.append("       , A.요청건수                                                   \n");
            sQry.append("       , A.요청답변건수                                               \n");
            sQry.append("       , FNC_COMMENT_STATUS_CODE(A.기업코드                           \n"); 
            sQry.append("                                ,A.법인코드                           \n");
            sQry.append("                                ,A.브랜드코드                         \n");
            sQry.append("                                ,A.건의요청구분                       \n");
            sQry.append("                                ,A.건의요청번호                       \n");
            sQry.append("                                ,A.매장코드                           \n");
            sQry.append("                                )                    AS 요청상태코드  \n");
            sQry.append("       , FNC_COMMENT_STATUS_INFO(A.기업코드                           \n"); 
            sQry.append("                                ,A.법인코드                           \n");
            sQry.append("                                ,A.브랜드코드                         \n");
            sQry.append("                                ,A.건의요청구분                       \n");
            sQry.append("                                ,A.건의요청번호                       \n");
            sQry.append("                                ,A.매장코드                           \n");
            sQry.append("                                )                    AS 요청상태      \n");
            sQry.append("       , A.등록자                                                     \n");
            sQry.append("       , TO_CHAR(A.등록일자,'YYYY-MM-DD') as 등록일자                 \n");
            sQry.append("   FROM 건의요청등록정보 A, 매장 B                                    \n");
            sQry.append("  WHERE 1=1                                            	           \n");
            sQry.append("    AND A.매장코드   = B.매장코드                                     \n");
	        
            if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            sQry.append("    AND A.기업코드   = ?                                          \n");  // 01.기업코드
	            sQry.append("    AND A.법인코드   = ?                                          \n");  // 02.법인코드
	            sQry.append("    AND A.브랜드코드 = ?                                          \n");  // 03.브랜드코드
	        }
            
            sQry.append("    AND A.등록일자  BETWEEN ?                                         \n");  // 04.조회시작일자
            sQry.append("                        AND ?               					       \n");  // 05.조회종료일자
            if ("01".equals(조회구분)||"02".equals(조회구분)||"03".equals(조회구분)) {
            	sQry.append("    AND A.요청구분   = ?                                          \n");
            }
            if ("1".equals(상태구분)||"9".equals(상태구분)) {
                sQry.append("    AND FNC_COMMENT_STATUS_CODE(A.기업코드                        \n"); 
                sQry.append("                               ,A.법인코드                        \n");
                sQry.append("                               ,A.브랜드코드                      \n");
                sQry.append("                               ,A.건의요청구분                    \n");
                sQry.append("                               ,A.건의요청번호                    \n");
                sQry.append("                               ,A.매장코드                        \n");
                sQry.append("                               ) = ?                              \n");
            }
            sQry.append("    AND A.건의요청구분 = ?                                            \n");
            
            if (srch_type.equals("title")) {
                sQry.append("   AND  A.제목 LIKE ?                                             \n");
            } else if(srch_type.equals("content")) {
                sQry.append("   AND  A.내용 LIKE ?                                             \n");
            } else if(srch_type.equals("writer")) {
                sQry.append(" AND  A.등록자   LIKE ?  					                       \n");
            } else if(srch_type.equals("storeCd")) {
                sQry.append(" AND  B.매장명   LIKE ?               		     			       \n");
            } else {
                sQry.append("   AND ( A.제목 LIKE ?  or A.내용 LIKE ?  )                       \n");
            }
            sQry.append("   AND A.삭제여부 = 'N'                                               \n");
            sQry.append(" )                                                                    \n");
            sQry.append(" WHERE  ROW_NUM >  ?                                                  \n");
            sQry.append("   AND  ROW_NUM <= ?                                                  \n");
            sQry.append(" ORDER BY 게시번호 DESC                                               \n");

            //-----------------------------------------------------------------------------------------------																					
            // set preparedstatemen
            //-----------------------------------------------------------------------------------------------																					
            pstmt = new LoggableStatement(con, sQry.toString());

            int p=0;
            //-----------------------------------------------------------------------------------------------																					
	        if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, 기업코드);                                                             // 01.기업코드
	            pstmt.setString(++p, 법인코드);                                                             // 02.법인코드
	            pstmt.setString(++p, 브랜드코드);                                                           // 03.브랜드코드
	        }
	        
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );                            // 04.조회시작일자
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );                            // 05.조회종료일자
            if ("01".equals(조회구분)||"02".equals(조회구분)||"03".equals(조회구분)) {
            	pstmt.setString(++p, 조회구분);
            }
            if ("1".equals(상태구분)||"9".equals(상태구분)) {
            	pstmt.setString(++p, 상태구분);
            }
            //
            pstmt.setString(++p, page_gb);

            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }
            
            pstmt.setInt(++p   , (inCurPage-1)*inRowPerPage);  // 페이지당 시작 글 범위
			pstmt.setInt(++p   , (inCurPage*inRowPerPage)  );  // 페이지당 끌 글 범위
            //-----------------------------------------------------------------------------------------------																					
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );        //     쿼리확인
			
			rs = pstmt.executeQuery();
			
            //-----------------------------------------------------------------------------------------------																					
            // make databean list
            //-----------------------------------------------------------------------------------------------																					
			adminBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new adminBean(); 
                
                dataBean.setROW_NUM   	((String)rs.getString("ROW_NUM"     )); 
                dataBean.set기업코드  	((String)rs.getString("기업코드"    ));
                dataBean.set법인코드  	((String)rs.getString("법인코드"    ));
                dataBean.set브랜드코드	((String)rs.getString("브랜드코드"  ));                
                dataBean.set게시번호  	((String)rs.getString("게시번호"    ));
                dataBean.set제목      	((String)rs.getString("제목"        ));
                dataBean.set내용      	((String)rs.getString("내용"        ));
                dataBean.set조회수    	((String)rs.getString("조회수"      ));
                dataBean.set공개여부    ((String)rs.getString("공개여부"    ));
                dataBean.set요청구분    ((String)rs.getString("요청구분"    ));
                dataBean.set요청건수    ((String)rs.getString("요청건수"    ));
                dataBean.set요청답변건수((String)rs.getString("요청답변건수"));
                dataBean.set요청상태코드((String)rs.getString("요청상태코드"));
                dataBean.set요청상태    ((String)rs.getString("요청상태"    ));
                dataBean.set등록자    	((String)rs.getString("등록자"      ));
                dataBean.set등록일자  	((String)rs.getString("등록일자"    ));
                dataBean.set매장코드  	((String)rs.getString("매장코드"    ));
                dataBean.set매장명  	((String)rs.getString("매장명"      ));
                
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
	 * 검색 조건에 맞는 건의사항-요청사항 전체 레코드 수
	 * @param paramData :  JSP페이지의 입력값들이 HashMap형태로 넘어옵니다.  
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectClaimListCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			//-------------------------------------------------------------------------------------------
			// 검색어 선언 및 정의
			//-------------------------------------------------------------------------------------------
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"  ));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"  ));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 조회구분   = JSPUtil.chkNull((String)paramHash.get("조회구분")  );
			String 상태구분   = JSPUtil.chkNull((String)paramHash.get("상태구분")  );
			String page_gb    = JSPUtil.chkNull((String)paramHash.get("pageGb"));			
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));		
			
			//검색 Type
			String srch_type  = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	
			//검색어
			String srch_key   = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			
			//-------------------------------------------------------------------------------------------
			// 검색어 인코딩
			//-------------------------------------------------------------------------------------------
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";			

			//-------------------------------------------------------------------------------------------
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

            sQry.append("  SELECT COUNT(*)                                                     \n");
            sQry.append("    FROM 건의요청등록정보 A, 매장 B                                   \n");
            sQry.append("  WHERE  1=1                                            	           \n");
            
            sQry.append("    AND A.매장코드   = B.매장코드                                     \n");

            if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            sQry.append("    AND A.기업코드   = ?                                          \n");  // 01.기업코드
	            sQry.append("    AND A.법인코드   = ?                                          \n");  // 02.법인코드
	            sQry.append("    AND A.브랜드코드 = ?                                          \n");  // 03.브랜드코드
            }
            
            sQry.append("    AND A.등록일자  BETWEEN ?                                         \n");  // 04.조회시작일자
            sQry.append("                        AND ?               					       \n");  // 05.조회종료일자
            //-------------------------------------------------------------------------------------------
            if ("01".equals(조회구분)||"02".equals(조회구분)||"03".equals(조회구분)) {
            	sQry.append("    AND A.요청구분   = ?                                          \n");
            }
            if ("1".equals(상태구분)||"9".equals(상태구분)) {
                sQry.append("    AND FNC_COMMENT_STATUS_CODE(A.기업코드                        \n"); 
                sQry.append("                               ,A.법인코드                        \n");
                sQry.append("                               ,A.브랜드코드                      \n");
                sQry.append("                               ,A.건의요청구분                    \n");
                sQry.append("                               ,A.건의요청번호                    \n");
                sQry.append("                               ,A.매장코드                        \n");
                sQry.append("                               ) = ?                              \n");
            }
            sQry.append("    AND A.건의요청구분 = ?                                            \n");
            
            if (srch_type.equals("title")) {
                sQry.append("   AND  A.제목 LIKE ?                                             \n");
            } else if(srch_type.equals("content")) {
                sQry.append("   AND  A.내용 LIKE ?                                             \n");
            } else if(srch_type.equals("writer")) {
                sQry.append(" AND  A.등록자   LIKE ?  					                       \n");
            } else if(srch_type.equals("storeCd")) {
                sQry.append(" AND  B.매장명   LIKE ?               		     			       \n");
            } else {
                sQry.append("   AND ( A.제목 LIKE ?  or A.내용 LIKE ?  )                       \n");
            }
            sQry.append("   AND A.삭제여부 = 'N'                                               \n");
            //-------------------------------------------------------------------------------------------	
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;

            if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, 기업코드);                                                         // 01.기업코드
	            pstmt.setString(++p, 법인코드);                                                         // 02.법인코드
	            pstmt.setString(++p, 브랜드코드);                                                       // 03.브랜드코드
            }
            
            pstmt.setString(++p, (String)paramHash.get("조회시작일자")    );                            // 04.조회시작일자
            pstmt.setString(++p, (String)paramHash.get("조회종료일자")    );                            // 05.조회종료일자
            if ("01".equals(조회구분)||"02".equals(조회구분)||"03".equals(조회구분)) {
            	pstmt.setString(++p, 조회구분);
            }
            if ("1".equals(상태구분)||"9".equals(상태구분)) {
            	pstmt.setString(++p, 상태구분);
            }

            pstmt.setString(++p, page_gb);   // 게시구분

            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }

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
     * 공지사항, 교육자료 게시판 글 상세보기
     * @param paramHash
     * @return
     * @throws DAOException
     */
    public ArrayList<adminBean> selectNoticeDetail(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<adminBean> list = new ArrayList<adminBean>();
		
		try
		{ 
						
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));		

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT A.기업코드                                                               \n");
            sQry.append("      , A.법인코드                                                               \n");
            sQry.append("      , A.브랜드코드                                                             \n");
            sQry.append("      , A.게시구분                                                               \n");
            sQry.append("      , A.게시번호                                                               \n");
            sQry.append("      , A.제목                                                                   \n");
            sQry.append("      , A.내용                                                                   \n");
            sQry.append("      , A.공지구분                                                               \n");
            sQry.append("      , TO_CHAR(A.게시시작일자, 'YYYY-MM-DD')  AS 게시시작일자                   \n");
            sQry.append("      , TO_CHAR(A.게시종료일자, 'YYYY-MM-DD')  AS 게시종료일자                   \n");
            sQry.append("      , A.조회수                                                                 \n");
            sQry.append("      , A.등록자                                                                 \n");
            sQry.append("      , TO_CHAR(A.등록일자,'YYYY-MM-DD') AS 등록일자                 		      \n");
            sQry.append("      , A.등록패스워드                                                           \n");
            sQry.append("      , A.삭제여부                                                               \n");
            sQry.append("      , A.예비문자                                                               \n");
            sQry.append("      , A.예비숫자                                                               \n");
            sQry.append("      , A.최종변경일시                                                           \n");
            sQry.append("      , NVL((SELECT COUNT(*)                                                     \n");
            sQry.append("             FROM   게시배포정보                                                 \n");
            sQry.append("             WHERE  1   = 1                                      				  \n");
            sQry.append("             --  AND  기업코드   = A.기업코드                                    \n");	//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
            sQry.append("             --  AND  법인코드   = A.법인코드                                    \n");
            sQry.append("             --  AND  브랜드코드 = A.브랜드코드                                  \n");
            sQry.append("               AND  게시구분   = A.게시구분                                      \n");
            sQry.append("               AND  게시번호   = A.게시번호                                      \n");
            sQry.append("            ), 0)                              AS 매장선택건수                   \n");
            sQry.append(" FROM   게시등록정보 A                                                           \n");
            sQry.append(" WHERE  1=1                                                         			  \n");  

            if(!("90").equals(권한코드)) {																		 //90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            sQry.append("   AND  A.기업코드   = ?                                                     \n");  // 01.기업코드
	            sQry.append("   AND  A.법인코드   = ?    							                      \n");  // 02.법인코드
	            sQry.append("   AND  A.브랜드코드 = ?    							                      \n");  // 03.브랜드코드
            }    
            sQry.append("   AND  A.게시구분   = ?    							                          \n");  // 04.게시구분
            sQry.append("   AND  A.게시번호   = ?    							                          \n");  // 05.게시번호
                                                                                                               
            
            
            //-------------------------------------------------------------------------------------------
            // set preparedstatemen
            //-------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            if(!("90").equals(권한코드)) {																		//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );                                  // 01.기업코드
	            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );                                  // 02.법인코드
	            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );                                  // 03.브랜드코드
	        }
            pstmt.setString(++p, (String)paramHash.get("pageGb"));                                              // 04.페이지 구분
            pstmt.setInt(++p, Integer.parseInt((String)paramHash.get("listNum")));                              // 05.글 번호
            
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
			//-------------------------------------------------------------------------------------------
            // make databean list
			//-------------------------------------------------------------------------------------------
			adminBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new adminBean(); 
                
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set게시번호  ((String)rs.getString("게시번호"  ));
                dataBean.set제목      ((String)rs.getString("제목"      ));
                dataBean.set내용      ((String)rs.getString("내용"      ));
                dataBean.set조회수    ((String)rs.getString("조회수"    ));
                dataBean.set등록자    ((String)rs.getString("등록자"    ));
                dataBean.set등록일자  ((String)rs.getString("등록일자"  ));
                dataBean.set공지구분  ((String)rs.getString("공지구분"  ));
                dataBean.set게시시작일자((String)rs.getString("게시시작일자"));
                dataBean.set게시종료일자((String)rs.getString("게시종료일자"));
                dataBean.set매장선택건수((String)rs.getString("매장선택건수"));

                list.add(dataBean);
                
            }
          //-------------------------------------------------------------------------------------------
            
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
	 * 댓글 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<adminBean> selectCommList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<adminBean> list = new ArrayList<adminBean>();
		
		try
		{ 

			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));		

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT *                                                                    \n");
            sQry.append(" FROM ( SELECT  ROW_NUMBER() OVER (ORDER BY A.게시번호 DESC) AS ROW_NUM      \n");
            sQry.append("             , A.기업코드                                                    \n");
            sQry.append("             , A.법인코드                                                    \n");
            sQry.append("             , A.브랜드코드                                                  \n");
            sQry.append("             , A.게시구분                                                    \n");
            sQry.append("             , A.게시번호                                                    \n");
            sQry.append("             , B.댓글번호                                                    \n");
            sQry.append("             , REPLACE(NVL(B.내용    , ''), '<BR>', CHR(13))     AS 내용     \n");
            sQry.append("             , B.등록자                                                      \n");
            sQry.append("             , TO_CHAR(B.등록일자,'YYYY-MM-DD') AS 등록일자                  \n");
            sQry.append("        FROM   게시등록정보 A                                                \n");
            sQry.append("           ,   게시댓글정보 B                                                \n");
            sQry.append("        WHERE  1=1                                            				  \n");  
            
	        if(!("90").equals(권한코드)) {																	//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            sQry.append("          AND  A.기업코드     = ?                                        \n");  //(01)기업코드
	            sQry.append("          AND  A.법인코드     = ?                                        \n");  //(02)법인코드
	            sQry.append("          AND  A.브랜드코드   = ?                                        \n");  //(03)브랜드코드
	        }    
            sQry.append("          AND  A.게시구분     = ?                                            \n");  //(04)게시구분
            sQry.append("          AND  A.게시번호     = ?                                            \n");  //(05)게시번호
            sQry.append("          AND  A.삭제여부     = 'N'                                          \n");
        //  sQry.append("          AND  B.기업코드     = A.기업코드                                   \n");	//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
        //  sQry.append("          AND  B.법인코드     = A.법인코드                                   \n");
        //  sQry.append("          AND  B.브랜드코드   = A.브랜드코드                                 \n");
            sQry.append("          AND  B.게시구분     = A.게시구분                                   \n");
            sQry.append("          AND  B.게시번호     = A.게시번호                                   \n");
            sQry.append("          AND  B.삭제여부     = 'N'                                          \n");
            sQry.append("      )   T                                                                  \n");
            sQry.append(" ORDER BY T.댓글번호 DESC                                                    \n");

            //-----------------------------------------------------------------------------------------
            // set preparedstatemen
            //-----------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
           
            //-----------------------------------------------------------------------------------------
            // 입력파라미터 조립
            //-----------------------------------------------------------------------------------------
	        if(!("90").equals(권한코드)) {																	//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  //(01)기업코드
	            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  //(02)법인코드
	            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  //(03)브랜드코드
	        }    
            pstmt.setString(++p, (String)paramHash.get("pageGb")		);  //(04)건의요청구분
            pstmt.setString(++p, (String)paramHash.get("listNum")		);  //(05)건의요청번호
            //-----------------------------------------------------------------------------------------

            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			rs = pstmt.executeQuery();
			
            // make databean list
			adminBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new adminBean(); 
                
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"   )); 
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));                
                dataBean.set게시구분  ((String)rs.getString("게시구분"  ));
                dataBean.set게시번호  ((String)rs.getString("게시번호"  ));
                dataBean.set댓글번호  ((String)rs.getString("댓글번호"  ));
                dataBean.set내용      ((String)rs.getString("내용"      ));
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
	 * 해당 게시물의 댓글 수
	 * @param paramData 
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int selectCommListCount(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int totalCnt = 0;
		 
		try 
		{
			
			String 권한코드	= JSPUtil.chkNull((String)paramHash.get("권한코드"));		
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			sQry.append(" SELECT COUNT(*)                                                      \n");                  
   			sQry.append(" FROM   게시등록정보 A                                                \n");                  
   			sQry.append("    ,   게시댓글정보 B                                                \n");                  
   			sQry.append(" WHERE  1=1                                            			   \n");
   			
	        if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	   			sQry.append("   AND  A.기업코드     = ?                                        \n");  //(01)기업코드  
	   			sQry.append("   AND  A.법인코드     = ?                                        \n");  //(02)법인코드  
	   			sQry.append("   AND  A.브랜드코드   = ?                                        \n");  //(03)브랜드코드
	        }	
   			sQry.append("   AND  A.게시구분     = ?                                            \n");  //(04)게시구분  
   			sQry.append("   AND  A.게시번호     = ?                                            \n");  //(05)게시번호  
   			sQry.append("   AND  A.삭제여부     = 'N'                                          \n");                  
   		//	sQry.append("   AND  B.기업코드     = A.기업코드                                   \n");                  
   		//	sQry.append("   AND  B.법인코드     = A.법인코드                                   \n");                  
   		//	sQry.append("   AND  B.브랜드코드   = A.브랜드코드                                 \n");                  
   			sQry.append("   AND  B.게시구분     = A.게시구분                                   \n");                  
   			sQry.append("   AND  B.게시번호     = A.게시번호                                   \n");                  
   			sQry.append("   AND  B.삭제여부     = 'N'                                          \n");                  
    
               
            //-----------------------------------------------------------------------------------------
            // set preparedstatemen
            //-----------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            //-----------------------------------------------------------------------------------------
            // 입력파라미터 조립
            //-----------------------------------------------------------------------------------------
	        if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  //(01)기업코드
	            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  //(02)법인코드
	            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  //(03)브랜드코드
	        }    
            pstmt.setString(++p, (String)paramHash.get("pageGb")		);  //(04)건의요청구분
            pstmt.setString(++p, (String)paramHash.get("listNum")		);  //(05)건의요청번호
            //-----------------------------------------------------------------------------------------
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
   			rs = pstmt.executeQuery();                                    
            
			if(rs != null && rs.next()) totalCnt = rs.getInt(1);		
		} catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
		} catch (Exception e) {
	    	e.printStackTrace(); 
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
     * 건의사항, 요청사항 게시판 글 상세보기
     * @param paramHash
     * @return
     * @throws DAOException
     */
    public ArrayList<adminBean> selectProposalDetail(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<adminBean> list = new ArrayList<adminBean>();
		
		try
		{ 
						
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));		
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                          					         \n");
            sQry.append("        기업코드                  					         \n");
            sQry.append("      , 법인코드                  					         \n");
            sQry.append("      , 브랜드코드                					         \n");
            sQry.append("      , 건의요청구분              					         \n");
            sQry.append("      , 건의요청번호              					         \n");
            sQry.append("      , 요청구분                  					         \n");
            sQry.append("      , 제목                     					         \n");
            sQry.append("      , 공개여부                  					         \n");
            sQry.append("      , 내용                     					         \n");
            sQry.append("      , 조회수                   					         \n");
            sQry.append("      , 요청건수                 					         \n");
            sQry.append("      , 요청답변건수             					         \n");
            sQry.append("      , 요청상태코드              					         \n");
            sQry.append("      , 등록자                    					         \n");
            sQry.append("      , TO_CHAR(등록일자, 'YYYY-MM-DD')  AS 등록일자        \n");
            sQry.append("      , 등록패스워드              					         \n");
            sQry.append("      , 삭제여부                  					         \n");
            sQry.append("      , 수정자                    					         \n");
            sQry.append("      , 수정일자                  					         \n");
            sQry.append("      , 예비문자                  					         \n");
            sQry.append("      , 예비숫자                  					         \n");
            sQry.append("      , 최종변경일시               				         \n");
            sQry.append("   FROM 건의요청등록정보          					         \n");
            sQry.append("  WHERE 1=1          					         			 \n");  
            
	        if(!("90").equals(권한코드)) {														//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            sQry.append("    AND 기업코드     = ?          					         \n");  //(01)기업코드
	            sQry.append("    AND 법인코드     = ?          					         \n");  //(02)법인코드
	            sQry.append("    AND 브랜드코드   = ?          					         \n");  //(03)브랜드코드
	        }    
            sQry.append("    AND 건의요청구분 = ?          					         \n");  //(04)건의요청구분
            sQry.append("    AND 건의요청번호 = ?          					         \n");  //(05)건의요청번호


            //-------------------------------------------------------------------------------------------
            // set preparedstatemen
            //-------------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
	        
            if(!("90").equals(권한코드)) {														//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  				//(01)기업코드
	            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  				//(02)법인코드
	            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  				//(03)브랜드코드
	        }    
            pstmt.setString(++p, (String)paramHash.get("pageGb")		);  				//(04)건의요청구분
            pstmt.setInt(++p, Integer.parseInt((String)paramHash.get("listNum"))); 			//(06)건의요청번호
            
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
			//-------------------------------------------------------------------------------------------
            // make databean list
			//-------------------------------------------------------------------------------------------
			adminBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new adminBean(); 
                
                dataBean.set기업코드    ((String)rs.getString("기업코드"    ));
                dataBean.set법인코드    ((String)rs.getString("법인코드"    ));
                dataBean.set브랜드코드  ((String)rs.getString("브랜드코드"  ));
                dataBean.set건의요청번호((String)rs.getString("건의요청번호"));
                dataBean.set제목        ((String)rs.getString("제목"        ));
                dataBean.set내용        ((String)rs.getString("내용"        ));
                dataBean.set조회수      ((String)rs.getString("조회수"      ));
                dataBean.set등록자      ((String)rs.getString("등록자"      ));
                dataBean.set등록일자    ((String)rs.getString("등록일자"    ));
                

                list.add(dataBean);
                
            }
            
            
	    } catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
	        throw new DAOException(e.getMessage());
	    } catch (Exception e) {
	    	e.printStackTrace(); 
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
	 * 건의&요청 댓글 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<adminBean> selectProposalCommList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<adminBean> list = new ArrayList<adminBean>();
		
		try
		{ 
			
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));		
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT *                                                                    \n");                                                                   
            sQry.append(" FROM ( SELECT  ROW_NUMBER() OVER (ORDER BY A.건의요청번호 DESC) AS ROW_NUM  \n");   
            sQry.append("             , A.기업코드                                                    \n");   
            sQry.append("             , A.법인코드                                                    \n");   
            sQry.append("             , A.브랜드코드                                                  \n");   
            sQry.append("             , A.건의요청구분                                                \n");   
            sQry.append("             , A.건의요청번호                                                \n");   
            sQry.append("             , B.댓글번호                                                    \n");   
            sQry.append("             , B.내용                                                        \n");   
            sQry.append("             , B.등록자                                                      \n");   
            sQry.append("             , TO_CHAR(B.등록일자,'YYYY-MM-DD') AS 등록일자                  \n");   
            sQry.append("        FROM   건의요청등록정보 A                                            \n");   
            sQry.append("           ,   건의요청댓글정보 B                                            \n");   
            sQry.append("        WHERE  1=1                                            				  \n");     
	        
            if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            sQry.append("          AND  A.기업코드     = ?                                        \n");  //(01)기업코드   
	            sQry.append("          AND  A.법인코드     = ?                                        \n");  //(02)법인코드   
	            sQry.append("          AND  A.브랜드코드   = ?                                        \n");  //(03)브랜드코드   
	            sQry.append("          AND  A.매장코드     = ?                                        \n");  //(04)매장코드   
	        }    
            sQry.append("          AND  A.건의요청구분 = ?                                            \n");  //(05)건의요청구분      
            sQry.append("          AND  A.건의요청번호 = ?                                            \n");  //(06)건의요청번호   
            sQry.append("          AND  A.삭제여부     = 'N'                                          \n");   
            //sQry.append("          AND  B.기업코드     = A.기업코드                                   \n");   
            //sQry.append("          AND  B.법인코드     = A.법인코드                                   \n");   
            //sQry.append("          AND  B.브랜드코드   = A.브랜드코드                                 \n");   
            //sQry.append("          AND  B.매장코드     = A.매장코드                                   \n");   
            sQry.append("          AND  B.건의요청구분 = A.건의요청구분                               \n");   
            sQry.append("          AND  B.건의요청번호 = A.건의요청번호                               \n");   
            sQry.append("          AND  B.삭제여부     = 'N'                                          \n");   
            sQry.append("      )   T                                                                  \n");   
            sQry.append(" ORDER BY T.댓글번호 DESC                                                    \n");

            //-----------------------------------------------------------------------------------------
            // 입력파라미터 조립
            //-----------------------------------------------------------------------------------------
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  //(01)기업코드
	            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  //(02)법인코드
	            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  //(03)브랜드코드
	            pstmt.setString(++p, (String)paramHash.get("sseStoreCd")    );  //(04)매장코드
            }    
            pstmt.setString(++p, (String)paramHash.get("pageGb")		);  //(05)건의요청구분
            pstmt.setString(++p, (String)paramHash.get("listNum")		);  //(06)건의요청번호
            //-----------------------------------------------------------------------------------------

            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
            rs = pstmt.executeQuery();
            
            //-------------------------------------------------------------------------------------------
            // make databean list
            //-------------------------------------------------------------------------------------------
            adminBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new adminBean(); 
                
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"      )); 
                dataBean.set기업코드  ((String)rs.getString("기업코드"     ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"     ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"   ));
                dataBean.set게시구분  ((String)rs.getString("건의요청구분" ));
                dataBean.set게시번호  ((String)rs.getString("건의요청번호" ));
                dataBean.set댓글번호  ((String)rs.getString("댓글번호"     ));
                dataBean.set내용      ((String)rs.getString("내용"         ));
                dataBean.set등록자    ((String)rs.getString("등록자"       ));
                dataBean.set등록일자  ((String)rs.getString("등록일자"     ));
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
   	 * 건의&요청 게시물의 댓글 수
   	 * @param paramData 
        * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
   	 * @throws Exception
   	 */    
       public int selectProposalCommListCount(HashMap paramHash) throws Exception 
       {
       	
       	Connection con          = null;
   		PreparedStatement pstmt = null;
   		ResultSet rs            = null;
   		
   		int totalCnt = 0;
   		 
   		try 
   		{
   			
			String 권한코드 = JSPUtil.chkNull((String)paramHash.get("권한코드"));		
   			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
   			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
   			
   			con = DBConnect.getInstance().getConnection();
   			
   			StringBuffer sQry = new StringBuffer();

   			sQry.append(" SELECT COUNT(*)                                                             \n");                  
   		    sQry.append("        FROM   건의요청등록정보 A                                            \n");   
            sQry.append("           ,   건의요청댓글정보 B                                            \n");   
            sQry.append("        WHERE  1=1                                            				  \n");     
	        
            if(!("90").equals(권한코드)) {																	//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            sQry.append("          AND  A.기업코드     = ?                                        \n"); //(01)기업코드   
	            sQry.append("          AND  A.법인코드     = ?                                        \n"); //(02)법인코드   
	            sQry.append("          AND  A.브랜드코드   = ?                                        \n"); //(03)브랜드코드   
	            sQry.append("          AND  A.매장코드     = ?                                        \n"); //(04)매장코드   
	        }    
            sQry.append("          AND  A.건의요청구분 = ?                                            \n");  //(05)건의요청구분      
            sQry.append("          AND  A.건의요청번호 = ?                                            \n");  //(06)건의요청번호   
            sQry.append("          AND  A.삭제여부     = 'N'                                          \n");   
          //sQry.append("          AND  B.기업코드     = A.기업코드                                   \n");   
          //sQry.append("          AND  B.법인코드     = A.법인코드                                   \n");   
          //sQry.append("          AND  B.브랜드코드   = A.브랜드코드                                 \n");   
          //sQry.append("          AND  B.매장코드     = A.매장코드                                   \n");   
            sQry.append("          AND  B.건의요청구분 = A.건의요청구분                               \n");   
            sQry.append("          AND  B.건의요청번호 = A.건의요청번호                               \n");   
            sQry.append("          AND  B.삭제여부     = 'N'                                          \n");                  
    
               
            //-----------------------------------------------------------------------------------------
            // set preparedstatemen
            //-----------------------------------------------------------------------------------------
            int p=0;
           
            pstmt = new LoggableStatement(con, sQry.toString());
            //-----------------------------------------------------------------------------------------
            // 입력파라미터 조립
            //-----------------------------------------------------------------------------------------
            if(!("90").equals(권한코드)) {										//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  //(01)기업코드
	            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  //(02)법인코드
	            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  //(03)브랜드코드
	            pstmt.setString(++p, (String)paramHash.get("sseStoreCd")    );  //(04)매장코드
            }    
            pstmt.setString(++p, (String)paramHash.get("pageGb")		);  //(05)건의요청구분
            pstmt.setString(++p, (String)paramHash.get("listNum")	    );  //(06)건의요청번호
            //-----------------------------------------------------------------------------------------
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
		ResultSet rs             = null;		
		
		int list = 0;
		String s게시번호 = "";
		
		System.out.println(">>>>>>>test>>>>>>>>>>>>>>>>>>>>>>>>"  );
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			//-----------------------------------------------------------------------------------
			// 1. 게시등록정보의 게시번호 조립
			//-----------------------------------------------------------------------------------
			StringBuffer gQry = new StringBuffer();

			gQry.append(" SELECT FNC_BOARD_SEQ_NO(?, ?, ?, ?) AS STORE_COUNT                \n");
            gQry.append(" FROM   DUAL                                                       \n");
            gQry.append(" WHERE  1=1		                                                \n");
            	
            pstmt = new LoggableStatement(con, gQry.toString());

            int i = 0;
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCode")    );  //(01)기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")     );  //(02)법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode")    );  //(03)브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //(04)게시구분        

			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) s게시번호 = rs.getString("STORE_COUNT");		
            
			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"  );
			System.out.println("가져온 게시번호" + s게시번호 + "]"  );
			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"  );
			
			//---------------------------------------------------------------------------------------
			// 2. 게시등록정보 등록처리
			//---------------------------------------------------------------------------------------
			StringBuffer sQry = new StringBuffer();
			sQry.append(" INSERT INTO 게시등록정보                                               \n");
			sQry.append("      ( 기업코드                                                        \n");
			sQry.append("      , 법인코드                                                        \n");
			sQry.append("      , 브랜드코드                                                      \n");
			sQry.append("      , 게시구분                                                        \n");
			sQry.append("      , 게시번호                                                        \n");
			sQry.append("      , 제목                                                            \n");
			sQry.append("      , 내용                                                            \n");
			sQry.append("      , 공지구분                                                        \n");
			sQry.append("      , 게시시작일자                                                    \n");
			sQry.append("      , 게시종료일자                                                    \n");
			sQry.append("      , 조회수                                                          \n");
			sQry.append("      , 등록자                                                          \n");
			sQry.append("      , 등록일자                                                        \n");
			sQry.append("      , 등록패스워드                                                    \n");
			sQry.append("      , 삭제여부                                                        \n");
			sQry.append("      , 예비문자                                                        \n");
			sQry.append("      , 예비숫자                                                        \n");
			sQry.append("      , 최종변경일시                                                    \n");
			sQry.append("      )                                                                 \n");
			sQry.append(" VALUES                                                                 \n");
			sQry.append("      ( ?                                                               \n");   // 01.기업코드
			sQry.append("      , ?                                                               \n");   // 02.법인코드 
			sQry.append("      , ?                                                               \n");   // 03.브랜드코드 
			sQry.append("      , ?                                                               \n");   // 04.게시구분 
			sQry.append("      , ?                                                               \n");   // 05.게시번호 
			sQry.append("      , ?                                                               \n");   // 06.제목 
			sQry.append("      , ?                                                               \n");   // 07.내용 
			sQry.append("      , ?                                                               \n");   // 08.공지구분 
			sQry.append("      , ?                                                               \n");   // 09.게시시작일자 
			sQry.append("      , ?                                                               \n");   // 10.게시종료일자
			sQry.append("      , 0                                                               \n");   // 11.조회수  
			sQry.append("      , ?                                                               \n");   // 12.등록자  
			sQry.append("      , TO_CHAR(SYSDATE,'YYYY-MM-DD')                                   \n");   // 13.등록일자  
			sQry.append("      , '1234'                                                          \n");   // 14.등록패스워드 
			sQry.append("      , 'N'                                                             \n");   // 15.삭제여부
			sQry.append("      , ''                                                              \n");   // 16.예비문자 
			sQry.append("      , 0                                                               \n");   // 17.예비숫자
			sQry.append("      , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')                       \n");   // 18.최종변경일시
			sQry.append("      )                                                                 \n");
			
						
            i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCode")    );  // 01.기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")     );  // 02.법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode")    );  // 03.브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  // 04.게시구분
            pstmt.setString(++i,  s게시번호                               );  // 05.게시번호 
            pstmt.setString(++i, (String)paramData.get("title")           );  // 06.제목
            pstmt.setString(++i, (String)paramData.get("comment")         );  // 07.글내용
            pstmt.setString(++i, (String)paramData.get("noticeKind")      );  // 08.공지구분
            pstmt.setString(++i, (String)paramData.get("bsDate")          );  // 09.게시시작일자
            pstmt.setString(++i, (String)paramData.get("beDate")          );  // 10.게시종료일자
            pstmt.setString(++i, (String)paramData.get("sseCustNm")       );  // 11.등록자명
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
            list = pstmt.executeUpdate();

            //-----------------------------------------------------------------------------------
			// 3. 게시배포정보 처리
			//-----------------------------------------------------------------------------------
            StringBuffer dQry = new StringBuffer();
            
			dQry.append(" UPDATE 게시배포정보 T                                                  \n");
			dQry.append("    SET 게시번호   = ?                                                  \n");
			dQry.append("      , 배포일자   = TO_CHAR(SYSDATE, 'YYYY-MM-DD')                     \n");
			dQry.append(" WHERE  1=1		                                                     \n");
		//	dQry.append("   AND  기업코드   = ?                                                  \n");
		//	dQry.append("   AND  법인코드   = ?                                                  \n");
		//	dQry.append("   AND  브랜드코드 = ?                                                  \n");
			dQry.append("   AND  게시구분   = ?                                                  \n");
			dQry.append("   AND  게시번호   = CASE WHEN T.게시구분 = '01'                        \n");
			dQry.append("                          THEN 999901                                   \n");
			dQry.append("                          ELSE 999902                                   \n");
			dQry.append("                     END                                                \n");
            
            i = 0;
            
            pstmt = new LoggableStatement(con, dQry.toString());
            
            pstmt.setString(++i,  s게시번호                               );  // 01.게시번호 
        //  pstmt.setString(++i, (String)paramData.get("sseGroupCode")    );  // 02.기업코드
        //  pstmt.setString(++i, (String)paramData.get("sseCorpCode")     );  // 03.법인코드
        //  pstmt.setString(++i, (String)paramData.get("sseBrandCode")    );  // 04.브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  // 05.게시구분
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
				rs.close();
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
			            

			sQry.append("  UPDATE 게시등록정보                                                      \n");
			sQry.append("     SET 제목         = ?                                                  \n");  // 01.제목
			sQry.append("       , 내용         = ?                                                  \n");  // 02.내용
			sQry.append("       , 공지구분     = ?                                                  \n");  // 03.공지구분
			sQry.append("       , 게시시작일자 = ?                                                  \n");  // 04.게시시작일자
			sQry.append("       , 게시종료일자 = ?                                                  \n");  // 05.게시종료일자
			sQry.append("       , 최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')          \n");   
			sQry.append("   WHERE 기업코드     = ?                                                  \n");  // 06.기업코드
			sQry.append("     AND 법인코드     = ?                                                  \n");  // 07.법인코드
			sQry.append("     AND 브랜드코드   = ?                                                  \n");  // 08.브랜드코드
			sQry.append("     AND 게시번호     = ?                                                  \n");  // 09.게시번호
			sQry.append("     AND 게시구분     = ?                                    				\n");  // 10.게시구분
			//-------------------------------------------------------------------------------------------
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("title")              		 );  // 01.제목
            pstmt.setString(++i, (String)paramData.get("comment")            		 );  // 02.내용
            pstmt.setString(++i, (String)paramData.get("noticeKind")         		 );  // 03.공지구분
            pstmt.setString(++i, (String)paramData.get("bsDate")              		 );  // 04.게시시작일자
            pstmt.setString(++i, (String)paramData.get("beDate")              		 );  // 05.게시종료일자
            pstmt.setString(++i, (String)paramData.get("sseGroupCode")       		 );  // 06.기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")        		 );  // 07.법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode")       		 );  // 08.브랜드코드
            pstmt.setInt   (++i, Integer.parseInt((String)paramData.get("listNum"))  );  // 09.게시번호
            pstmt.setString(++i, (String)paramData.get("pageGb")          			 );  // 10.게시구분
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
     * 글 조회수 업데이트
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateNoticeReadCount(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
			sQry.append(" UPDATE 게시등록정보                                 \n");
			sQry.append(" SET 조회수 = ( SELECT MAX(조회수)+1                 \n");
			sQry.append("                  FROM 게시등록정보                  \n");
			sQry.append("                 WHERE 기업코드     = ?              \n");      // 01.기업코드
			sQry.append("                   AND 법인코드     = ?              \n");      // 02.법인코드
			sQry.append("                   AND 브랜드코드   = ?              \n");      // 03.브랜드코드
			sQry.append("                   AND 게시번호     = ?              \n");      // 04.게시번호
			sQry.append("                   AND 게시구분     = ?              \n");      // 05.게시구분
			sQry.append("              )                                      \n");
			sQry.append("  WHERE 기업코드      = ?                            \n");      // 06.기업코드
			sQry.append("       AND 법인코드   = ?                            \n");      // 07.법인코드
			sQry.append("       AND 브랜드코드 = ?                            \n");      // 08.브랜드코드
			sQry.append("       AND 게시번호   = ?                            \n");      // 09.게시번호
			sQry.append("       AND 게시구분   = ?                            \n");      // 10.게시구분

			
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")                  );  // 01.기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")                   );  // 02.법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")                  );  // 03.브랜드코드
            pstmt.setString(++i, (String)paramData.get("listNum")					  );  // 04.게시번호
            pstmt.setString(++i, (String)paramData.get("pageGb")					  );  // 05.게시구분
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")                  );  // 06.기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")                   );  // 07.법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")                  );  // 08.브랜드코드
            pstmt.setString(++i, (String)paramData.get("listNum")                     );  // 09.게시번호
            pstmt.setString(++i, (String)paramData.get("pageGb")					  );  // 10.게시구분
            
            //System.out.println("글 조회수 업데이트 SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
	 * 댓글 요청사항관리 내가 쓴 댓글 조회 
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<adminBean> selectMyCommList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<adminBean> list = new ArrayList<adminBean>();
		
		try
		{ 
			
			
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                                             \n");
            sQry.append(" *                                                                  \n");
            sQry.append(" FROM                                                               \n");
            sQry.append(" (                                                                  \n");
            sQry.append("   SELECT                                                           \n");
            sQry.append("       ROW_NUMBER() OVER (ORDER BY 건의요청번호 DESC) AS ROW_NUM    \n");
            sQry.append("       , 기업코드                                                   \n");
            sQry.append("       , 법인코드                                                   \n");
            sQry.append("       , 브랜드코드                                                 \n");
            sQry.append("       , 건의요청구분                                               \n");
            sQry.append("       , 건의요청번호                                               \n");            
            sQry.append("       , 댓글번호                                                   \n");
            sQry.append("       , 내용                                                       \n");
            sQry.append("       , 등록자                                                     \n");
            sQry.append("       , TO_CHAR(등록일자,'YYYY-MM-DD') AS 등록일자                 \n");
            sQry.append("   FROM 건의요청댓글정보                                            \n");
            sQry.append("   WHERE 건의요청구분 = ?                                           \n");  // 01.건의요청구분
            sQry.append("     AND 건의요청번호 = ?                                           \n");  // 02.건의요청번호
            sQry.append("     AND 등록자 = ?                                           		 \n");  // 03.등록자명
            sQry.append(" )                                                                  \n");
            sQry.append(" ORDER BY 건의요청번호 DESC, 댓글번호 ASC                           \n");     

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("pageGb"));    // 01.건의요청구분
            pstmt.setString(++p, (String)paramHash.get("listNum"));   // 02.건의요청번호
            pstmt.setString(++p, (String)paramHash.get("등록자"));    // 03.등록자명
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			rs = pstmt.executeQuery();
			
            // make databean list
			adminBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new adminBean(); 
                
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"   )); 
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));                
                dataBean.set댓글번호  ((String)rs.getString("댓글번호"  ));
                dataBean.set댓글내용  ((String)rs.getString("내용"      ));
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
     * 댓글 저장
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertCommWrite(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append(" INSERT INTO 게시댓글정보     						\n");
			sQry.append(" (                            						\n");
			sQry.append("   기업코드                    					\n");
			sQry.append(" , 법인코드                    					\n");
			sQry.append(" , 브랜드코드                  					\n");
			sQry.append(" , 게시구분                    					\n");
			sQry.append(" , 게시번호                    					\n");
			sQry.append(" , 매장코드 				   						\n");
			sQry.append(" , 댓글번호                    					\n");
			sQry.append(" , 내용                        					\n");
			sQry.append(" , 공개여부                    					\n");
			sQry.append(" , 등록자                      					\n");
			sQry.append(" , 등록일자                    					\n");
			sQry.append(" , 등록패스워드                					\n");
			sQry.append(" , 삭제여부                    					\n");
			sQry.append(" , 예비문자                    					\n");
			sQry.append(" , 예비숫자                    					\n");
			sQry.append(" , 최종변경일시                 					\n");
			sQry.append(" ) VALUES                    						\n");
			sQry.append("        ( ?                           						\n");//01.기업코드
			sQry.append("        , ?                           						\n");//02.법인코드
			sQry.append("        , ?                         						\n");//03.브랜드코드
			sQry.append("        , ?                          						\n");//04.게시구분 
			sQry.append("        , ?  			              						\n");//05.게시번호 
			sQry.append("        , ?                            					\n");//06.매장코드			
			sQry.append("        , FNC_BOARD_COMMENT_SEQ_NO(?                                    \n");   //(07)기업코드
            sQry.append("                                  ,?                                    \n");   //(08)법인코드
            sQry.append("                                  ,?                                    \n");   //(09)브랜드코드
            sQry.append("                                  ,?                                    \n");   //(11)게시구분
            sQry.append("                                  ,?)                                   \n");   //(12)게시번호
			/*sQry.append("        , ?                              					\n");//08.내용 
*/			sQry.append("        , REPLACE(?, CHR(13), '<BR>')                                    \n");   //(12)내용
			sQry.append("        ,'Y'                        						\n");//09.공개여부 
			sQry.append("        , ?                             					\n");//10.등록자
			sQry.append("        , TO_CHAR(SYSDATE,'YYYY-MM-DD')                    \n");//11.등록일자
			sQry.append("        , '1234'                  							\n");//12.등록패스워드
			sQry.append("        , 'N'                         						\n");//13.삭제여부
			sQry.append("        , ''                          						\n");//14.예비문자
			sQry.append("        , ''                          						\n");//15.예비숫자
			sQry.append("        , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')       \n");//16.최종변경일시
			sQry.append("        )                          		  				\n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")     );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")      );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")     );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")		 );   //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")        );  //게시번호
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd") );  //매장코드
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")     );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")      );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")     );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")		 );   //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")        );  //게시번호
            pstmt.setString(++i, (String)paramData.get("comment")        );  //글내용
            pstmt.setString(++i, (String)paramData.get("sseCustNm")      );  //등록자명
            
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
     * 매장건의사항 글 저장
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertProposalWrite(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append(" INSERT INTO 건의요청등록정보 						\n");
			sQry.append(" (                            						\n");
			sQry.append("   기업코드                    					\n");
			sQry.append(" , 법인코드                    					\n");
			sQry.append(" , 브랜드코드                  					\n");			
			sQry.append(" , 매장코드 				   						\n");
			sQry.append(" , 건의요청구분                					\n");			
			sQry.append(" , 건의요청번호                					\n");
			sQry.append(" , 요청구분                    					\n");
			sQry.append(" , 제목                        					\n");
			sQry.append(" , 공개여부                    					\n");
			sQry.append(" , 내용                       						\n");			
			sQry.append(" , 조회수                      					\n");
			sQry.append(" , 요청건수                    					\n");
			sQry.append(" , 요청답변건수               						\n");
			sQry.append(" , 요청상태코드                					\n");
			sQry.append(" , 등록자                     						\n");			
			sQry.append(" , 등록일자                    					\n");
			sQry.append(" , 등록패스워드                					\n");
			sQry.append(" , 삭제여부                    					\n");
			sQry.append(" , 예비문자                    					\n");
			sQry.append(" , 예비숫자                    					\n");			
			sQry.append(" , 최종변경일시                 					\n");			
			sQry.append(" ) VALUES (                   						\n");
			sQry.append(" ?	                								\n");		//기업코드
			sQry.append(" ,?                								\n");		//법인코드
			sQry.append(" ,?              									\n");		//브랜드코드,
			sQry.append(" ,?             									\n");		//매장코드, 
			sQry.append(" ,?            									\n");		//건의요청구분,			
			sQry.append(" ,FNC_SEQ_NO('건의요청등록정보',?,?,?,?)           \n");		//건의요청번호			
			sQry.append(" ,?               									\n");		//요청구분 ,
			sQry.append(" ,?                   								\n");		//제목 ,
			sQry.append(" ,'Y'              								\n");		//공개여부 , 
			sQry.append(" ,?                  								\n");		//내용 , 			
			sQry.append(" ,0                  								\n");		//조회수,
			sQry.append(" ,0                								\n");		//요청건수,
			sQry.append(" ,0            									\n");		//요청답변건수,
			sQry.append(" ,0            									\n");		//요청상태코드,
			sQry.append(" ,?                  								\n");		//등록자,			
			sQry.append(" ,TO_CHAR(SYSDATE,'YYYY-MM-DD')  					\n");		//등록일자,
			sQry.append(" ,'1234'       									\n");		//등록패스워드,
			sQry.append(",'N'               								\n");		//삭제여부,
			sQry.append(" ,''               								\n");		//예비문자,
			sQry.append(" ,''               								\n");		//예비숫자,			
			sQry.append(" , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')       \n");		//최종변경일시
			sQry.append(" )                            						\n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  //건의요청구분(게시구분)
            
            //건의요청번호 Function
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            
            
            pstmt.setString(++i, (String)paramData.get("comboVal")  	);  //요청구분
            pstmt.setString(++i, (String)paramData.get("title")         );  //제목
            pstmt.setString(++i, (String)paramData.get("comment")       );  //내용
            pstmt.setString(++i, (String)paramData.get("sseCustNm")     );  //등록자명
            
            
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
	 * 요청구분 공통코드 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<adminBean> selectComboClaim() throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList list = new ArrayList();
		
		try
		{ 
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("  SELECT 세부코드명                     \n");
            sQry.append("	 FROM PRM공통코드                    \n");
            sQry.append("   WHERE 1=1                            \n");
            sQry.append("     AND 분류코드 = '요청구분'          \n");
            sQry.append("   ORDER BY 표시순서 ASC                \n");
            
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
			
			rs = pstmt.executeQuery();
			
            // make databean list
			adminBean dataBean = null;
            
            while( rs.next() )
            {
                String comboList = "";  
                
                comboList = ((String)rs.getString("세부코드명")); 

                list.add(comboList);
                
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
		
		return list;
            
	}
	
	
	
    /**
	 * 해당 게시물의 댓글 수
	 * @param paramData 
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public int findCommListCount(HashMap paramHash) throws Exception 
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

			sQry.append(" SELECT COUNT(*)                                                    \n");
            sQry.append("   FROM 건의요청댓글정보 A, 건의요청등록정보 B                      \n");
            sQry.append("  WHERE A.건의요청구분 = B.건의요청구분                             \n");
            sQry.append("    AND A.건의요청번호 = B.건의요청번호                             \n");
            sQry.append("    AND A.건의요청구분 = ?                                          \n");
            sQry.append("    AND A.건의요청번호 = ?                                          \n");
            sQry.append("    AND A.등록자 = '관리자'                                         \n");
            /*sQry.append("    AND 제목 LIKE ?                                                \n");*/
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            pstmt.setString(++p, (String)paramHash.get("pageGb"));   //게시구분
            pstmt.setInt   (++p, Integer.parseInt((String)paramHash.get("listNum")) );   //게시번호
            /*pstmt.setString(++p, srch_key);  // 고객ID */
			
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
     * 매장건의사항 글 정보보기
     * @param paramHash
     * @return
     * @throws DAOException
     */
    public ArrayList<adminBean> selectProposalDetail2(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<adminBean> list = new ArrayList<adminBean>();
		
		try
		{ 
						
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                          						\n");
            sQry.append("       기업코드                  						\n"); 
            sQry.append("      , 법인코드                  						\n");  
            sQry.append("      , 브랜드코드                						\n");  
            sQry.append("      , 건의요청구분              						\n");
            sQry.append("      , 건의요청번호              						\n");
            sQry.append("      , 요청구분                  						\n");  
            sQry.append("      , 제목                      						\n");  
            sQry.append("      , 공개여부                  						\n");
            sQry.append("      , 내용                      						\n");  
            sQry.append("      , 조회수                    						\n");  
            sQry.append("      , 요청건수                  						\n");  
            sQry.append("      , 요청답변건수              						\n");  
            sQry.append("      , 요청상태코드              						\n");  
            sQry.append("      , 등록자                    						\n");  
            sQry.append("      , 등록일자                  						\n");  
            sQry.append("      , 등록패스워드              						\n");  
            sQry.append("      , 삭제여부                  						\n");
            sQry.append("      , 수정자                    						\n");
            sQry.append("      , 수정일자                  						\n");
            sQry.append("      , 예비문자                  						\n");  
            sQry.append("      , 예비숫자                  						\n");  
            sQry.append("      , 최종변경일시               					\n");
            sQry.append("      , B.내용     AS 댓글내용     					\n");
            sQry.append(" FROM 건의요청등록정보 A, 건의요청댓글정보 B           \n");
            sQry.append(" WHERE A.건의요청구분 = B.건의요청구분          		\n");
            sQry.append(" AND   A.건의요청번호 = B.건의요청번호          		\n");  
            sQry.append(" AND   건의요청구분 = ?          						\n");
            sQry.append(" AND   건의요청번호 = ?          						\n");
            sQry.append(" AND   건의요청번호 = '관리자'          				\n");
            

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("pageGb"));  //페이지 구분
            pstmt.setInt(++p, Integer.parseInt((String)paramHash.get("listNum"))); //글 번호
            
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			adminBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new adminBean(); 
                
                dataBean.set기업코드    ((String)rs.getString("기업코드"    ));
                dataBean.set법인코드    ((String)rs.getString("법인코드"    ));
                dataBean.set브랜드코드  ((String)rs.getString("브랜드코드"  ));
                dataBean.set건의요청번호((String)rs.getString("건의요청번호"));
                dataBean.set제목        ((String)rs.getString("제목"        ));
                dataBean.set내용        ((String)rs.getString("내용"        ));
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
    
    /**
     * 건의요청 조회수 업데이트
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateProposalReadCount(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			String 권한코드   = JSPUtil.chkNull((String)paramData.get("권한코드"));		
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
			sQry.append(" UPDATE 건의요청등록정보                      	\n");
			sQry.append("    SET 조회수 = 조회수 + 1          			\n");
			sQry.append("  WHERE 1=1                   					\n");
	        
			if(!("90").equals(권한코드)) {											//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
				sQry.append("    AND 기업코드     = ?                   \n");
				sQry.append("    AND 법인코드     = ?                   \n");
				sQry.append("    AND 브랜드코드   = ?                   \n");
	        }
			
			sQry.append("    AND 건의요청번호 = ?                   	\n");
			sQry.append("    AND 건의요청구분 = ?                   	\n");
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
			if(!("90").equals(권한코드)) {													//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	            pstmt.setString(++i, (String)paramData.get("sseGroupCd")                 ); //기업코드
	            pstmt.setString(++i, (String)paramData.get("sseCorpCd")                  ); //법인코드
	            pstmt.setString(++i, (String)paramData.get("sseBrandCd")                 ); //브랜드코드
			}    
            pstmt.setInt   (++i, Integer.parseInt((String)paramData.get("listNum"))  );  //
            pstmt.setString(++i, (String)paramData.get("pageGb")   					 );  //
            
            //System.out.println("글 조회수 업데이트 SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
     * 건의&요청 댓글 저장
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertProposalCommWrite(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append(" INSERT INTO 건의요청댓글정보 						\n");
			sQry.append(" (                            						\n");
			sQry.append("   기업코드                    						\n");
			sQry.append(" , 법인코드                    						\n");
			sQry.append(" , 브랜드코드                  						\n");
			sQry.append(" , 매장코드                    						\n");		
			sQry.append(" , 건의요청구분               						\n");
			sQry.append(" , 건의요청번호                						\n");
			sQry.append(" , 댓글번호                   						\n");
			sQry.append(" , 공개여부                    						\n");
			sQry.append(" , 내용                        						\n");
			sQry.append(" , 등록자                      						\n");
			sQry.append(" , 등록일자                    						\n");
			sQry.append(" , 등록패스워드                						\n");
			sQry.append(" , 삭제여부                    						\n");
			sQry.append(" , 예비문자                    						\n");
			sQry.append(" , 예비숫자                    						\n");
			sQry.append(" , 최종변경일시                 						\n");
			sQry.append(" ) VALUES (                   							\n");
			sQry.append("  ?                									\n");//01.기업코드
			sQry.append(" ,?                									\n");//02.법인코드
			sQry.append(" ,?              										\n");//03.브랜드코드
			sQry.append(" ,?                 									\n");//04.매장코드		
			sQry.append(" ,?           											\n");//05.건의요청구분 
			sQry.append(" ,?           											\n");//06.건의요청번호
			sQry.append("  , FNC_REQUEST_COMMENT_SEQ_NO(?                       \n");   //(07)기업코드
            sQry.append("                              ,?                       \n");   //(08)법인코드
            sQry.append("                              ,?                       \n");   //(09)브랜드코드
            sQry.append("                              ,NVL(?, 'N/A')           \n");   //(10)매장코드
            sQry.append("                              ,?                       \n");   //(11)건의요청구분
            sQry.append("                              ,?)                      \n");   //(12)건의요청번호
			sQry.append(" ,'Y'            										\n");//08.공개여부 
			sQry.append(" ,?                   									\n");//09.내용 
			sQry.append(" ,?                  									\n");//10.등록자
			sQry.append(" ,TO_CHAR(SYSDATE,'YYYY-MM-DD')          				\n");//11.등록일자
			sQry.append(" ,'1234'       										\n");//12.등록패스워드
			sQry.append(" ,'N'               									\n");//13.삭제여부
			sQry.append(" ,''               									\n");//14.예비문자
			sQry.append(" ,''               									\n");//15.예비숫자
			sQry.append(" , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')           \n");//16.최종변경일시
			sQry.append(" )                            							\n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")     );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")      );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")     );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseStoreCd")     );  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")         );  //건의요청구분
            pstmt.setString(++i, (String)paramData.get("listNum")        );  //건의요청번호
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")     );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")      );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")     );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseStoreCd")     );  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")         );  //건의요청구분
            pstmt.setString(++i, (String)paramData.get("listNum")        );  //건의요청번호
            
            pstmt.setString(++i, (String)paramData.get("comment")        );  //글내용
            pstmt.setString(++i, (String)paramData.get("sseCustNm")      );  //등록자명
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
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
     * 요청 상태 저장
     * @param paramData
     * @return
     * @throws DAOException
     */ 
    
    public int reUpdateProposalCommWrite(HashMap paramData) throws DAOException
   	{
       	Connection con           = null;
   		PreparedStatement pstmt  = null;
   		
   		int list = 0;
   		
   		try
   		{
   			con = DBConnect.getInstance().getConnection();
   			
   			StringBuffer sQry = new StringBuffer();
   			sQry.append("  UPDATE 건의요청등록정보                                    		\n");
   			sQry.append("  SET    요청상태코드 = '9'                                  		\n");			
   			sQry.append("      ,  최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')  \n");
   			sQry.append("   WHERE 기업코드     = ?                                    		\n");
   			sQry.append("     AND 법인코드     = ?                                    		\n");
   			sQry.append("     AND 브랜드코드   = ?                                    		\n");
   			sQry.append("     AND 건의요청구분 = ?                                   		\n");
   			sQry.append("     AND 건의요청번호 = ?                                    		\n");
   						
   			int i = 0; 
               
               pstmt = new LoggableStatement(con, sQry.toString());
               pstmt.setString(++i, (String)paramData.get("sseGroupCd"));    //기업코드
               pstmt.setString(++i, (String)paramData.get("sseCorpCd" ));    //법인코드
               pstmt.setString(++i, (String)paramData.get("sseBrandCd"));    //브랜드코드
               pstmt.setString(++i, (String)paramData.get("pageGb"    ));    //건의요청구분
               pstmt.setString(++i, (String)paramData.get("listNum"	  ));    //건의요청번호
               
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
     * 글 삭제
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
			            

			sQry.append("  UPDATE 게시등록정보                                        		\n");
			sQry.append("  SET    삭제여부     = 'Y'                                		\n");			
			sQry.append("      ,  최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')  \n");
			sQry.append("   WHERE 기업코드     = ?                                    		\n");
			sQry.append("        AND 법인코드  = ?                                    		\n");
			sQry.append("        AND 브랜드코드= ?                                   		\n");
			sQry.append("        AND 게시구분  = ?                                    		\n");
			sQry.append("        AND 게시번호  = ?                                    		\n");
			
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++i, (String)paramData.get("sseGroupCode"));  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode" ));  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode"));  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb"      ));  //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum"	 ));  //게시번호
            
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
     * 글 건의사항/요청사항 삭제
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteProposalWrite(HashMap paramData) throws DAOException
	{
    	Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 건의요청등록정보                                       	\n");
			sQry.append("  SET    삭제여부         = 'Y'                                  	\n");			
			sQry.append("      ,  최종변경일시 = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')  \n");
			sQry.append("   WHERE 기업코드         = ?                                   	\n");
			sQry.append("        AND 법인코드      = ?                                    	\n");
			sQry.append("        AND 브랜드코드    = ?                                    	\n");
			sQry.append("        AND 건의요청구분  = ?                                    	\n");
			sQry.append("        AND 건의요청번호  = ?                                    	\n");
			
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++i, (String)paramData.get("sseGroupCode"));  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode" ));  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode"));  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb"      ));  //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum"	 ));  //게시번호
            
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
    
    //-----------------------------------------------------------------------------------------
    // 첨부파일 관련 DAO
    //-----------------------------------------------------------------------------------------
    /**
     * 게시배포정보 첨부파일 신규저장
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertNoticeFileNew(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs             = null;
		
		int list = 0;
		String s게시번호 = "";
		try
		{
			con = DBConnect.getInstance().getConnection();
			//-----------------------------------------------------------------------------------
			// 1. 게시등록정보의 게시번호 조립
			//-----------------------------------------------------------------------------------
			StringBuffer gQry = new StringBuffer();

			gQry.append(" SELECT FNC_BOARD_SEQ_NO(?, ?, ?, ?) AS STORE_COUNT                \n");
            gQry.append(" FROM   DUAL                                                       \n");
            gQry.append(" WHERE  1=1		                                                \n");
            	
            pstmt = new LoggableStatement(con, gQry.toString());

            int i = 0;
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCode")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //게시구분            

			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) s게시번호 = rs.getString("STORE_COUNT");		
            
			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"  );
			System.out.println("가져온 게시번호" + s게시번호 + "]"  );
			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"  );
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append(" INSERT INTO 게시첨부파일     									\n");
			sQry.append(" (                            									\n");
			sQry.append("   기업코드                   									\n");
			sQry.append(" , 법인코드                   									\n");
			sQry.append(" , 브랜드코드                 									\n");
			sQry.append(" , 게시구분                   									\n");
			sQry.append(" , 게시번호               										\n");
			sQry.append(" , 파일순번                   									\n");
			sQry.append(" , 파일경로                   									\n");
			sQry.append(" , 파일명                     									\n");
			sQry.append(" , 원본파일명                 									\n");
			sQry.append(" , 등록일자                   									\n");
			sQry.append(" , 삭제여부                   									\n");
			sQry.append(" , 최종변경일시               									\n");
			sQry.append(" ) VALUES (                   									\n");
			sQry.append(" ?, 			               									\n");			//기업코드
			sQry.append(" ?, 			               									\n");			//법인코드
			sQry.append(" ?,			            									\n");			//브랜드코드 
			sQry.append(" ?,			               									\n");			//게시구분
			sQry.append(" ?,			               									\n");			//게시번호
			sQry.append(" ?,     		              									\n");		    //파일순번
			sQry.append(" ?, 			             									\n");			//파일경호   
			sQry.append(" ?, 		                									\n");			//파일명  
			sQry.append(" ?, 			            									\n");			//원본파일명 
			sQry.append(" TO_CHAR(SYSDATE,'YYYY-MM-DD'), 			 					\n");			//등록일자
			sQry.append("'N', 			             									\n");			//삭제여부
			sQry.append(" TO_CHAR(SYSDATE,'YYYY-MM-DD hh24:mi:ss') 				        \n");			//최종변경일시
			sQry.append(" )                            									\n");
						
            i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCode")    );  							//기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")     );  							//법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode")    );  							//브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  							//게시구분
            pstmt.setString(++i,  s게시번호                               );  							//게시번호
            pstmt.setString(++i, (String)paramData.get("fileNum")  		);  							//파일순번
            pstmt.setString(++i, (String)paramData.get("filePath")      );  							//파일경로
            pstmt.setString(++i, (String)paramData.get("fileName")      );  							//파일명
            pstmt.setString(++i, (String)paramData.get("orgFileName")   );  							//원본파일명
            
            list = pstmt.executeUpdate();
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
     * 공지&교육 첨부파일 수정 저장
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertNoticeFile(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append(" INSERT INTO 게시첨부파일     									\n");
			sQry.append(" (                            									\n");
			sQry.append("   기업코드                    								\n");
			sQry.append(" , 법인코드                    								\n");
			sQry.append(" , 브랜드코드                  								\n");
			sQry.append(" , 게시구분                    								\n");
			sQry.append(" , 게시번호               										\n");
			sQry.append(" , 파일순번                    								\n");
			sQry.append(" , 파일경로                    								\n");
			sQry.append(" , 파일명                      								\n");
			sQry.append(" , 원본파일명                  								\n");
			sQry.append(" , 등록일자                    								\n");
			sQry.append(" , 삭제여부                    								\n");
			sQry.append(" , 최종변경일시                 								\n");
			sQry.append(" ) VALUES (                   									\n");
			sQry.append(" ?, 			               									\n");			//기업코드
			sQry.append(" ?, 			               									\n");			//법인코드
			sQry.append(" ?,			            									\n");			//브랜드코드 
			sQry.append(" ?,			               									\n");			//게시구분
			sQry.append(" ?, 				            								\n");          	//게시번호
			sQry.append(" ?,     		              									\n");		    //파일순번
			sQry.append(" ?, 			             									\n");			//파일경호   
			sQry.append(" ?, 		                									\n");			//파일명  
			sQry.append(" ?, 			            									\n");			//원본파일명 
			sQry.append(" TO_CHAR(SYSDATE,'YYYY-MM-DD'), 			 					\n");			//등록일자
			sQry.append("'N', 			             									\n");			//삭제여부
			sQry.append(" TO_CHAR(SYSDATE,'YYYY-MM-DD hh24:mi:ss') 				        \n");			//최종변경일시
			sQry.append(" )                            									\n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCode")  );  							//기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")   );  							//법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode")  );  							//브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  							//게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")       );  							//게시번호
            pstmt.setString(++i, (String)paramData.get("fileNum")  		);  							//파일순번
            pstmt.setString(++i, (String)paramData.get("filePath")      );  							//파일경로
            pstmt.setString(++i, (String)paramData.get("fileName")      );  							//파일명
            pstmt.setString(++i, (String)paramData.get("orgFileName")   );  							//원본파일명
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
   	 * 건의&요청 파일다운로드 상세보기
   	 * @param 
   	 * @return
   	 * @throws DAOException
   	 */
   	public ArrayList<adminBean> selectRequestDownloadList(HashMap paramHash) throws DAOException
   	{
   		
   		Connection con          = null;
   		PreparedStatement pstmt = null;
   		ResultSet rs            = null;
   		
   		ArrayList<adminBean> list = new ArrayList<adminBean>();
   		
   		try
   		{ 
   			
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));		
   			con = DBConnect.getInstance().getConnection();
   			
               StringBuffer sQry = new StringBuffer();
     
   			   sQry.append(" SELECT 파일명                                      \n");
   			   sQry.append("      , 원본파일명                                  \n");
   			   sQry.append("      , 파일순번                                    \n");
               sQry.append("   FROM 건의요청첨부파일                           	\n");
               sQry.append("  WHERE 1=1				                           	\n");

            if(!("90").equals(권한코드)) {													//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
               sQry.append("    AND 기업코드     = ?                           	\n");
               sQry.append("    AND 법인코드     = ?                           	\n");
               sQry.append("    AND 브랜드코드   = ?                           	\n");
               sQry.append("    AND 매장코드     = ?                           	\n");
            }   
               sQry.append("    AND 건의요청구분 = ?                           	\n");
               sQry.append("    AND 건의요청번호 = ?                           	\n");
               sQry.append("    AND 삭제여부     = 'N'                         	\n"); 
               pstmt = new LoggableStatement(con, sQry.toString());
   			
               int i = 0;
               
            if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
               pstmt.setString(++i, (String)paramHash.get("sseGroupCd")      );  //기업코드
               pstmt.setString(++i, (String)paramHash.get("sseCorpCd")       );  //법인코드
               pstmt.setString(++i, (String)paramHash.get("sseBrandCd")      );  //브랜드코드
               pstmt.setString(++i, (String)paramHash.get("sseStoreCd")		 );  //매장코드
            }   
               pstmt.setString(++i, (String)paramHash.get("pageGb")          );  //건의요청구분
               pstmt.setString(++i, (String)paramHash.get("listNum")         );  //건의요청번호
   			
               //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
   			rs = pstmt.executeQuery();
   			
               // make databean list
   			adminBean dataBean = null;
               
               while( rs.next() )
               {
                   dataBean = new adminBean(); 
                   
                   dataBean.set파일명     ((String)rs.getString("파일명"    ));
                   dataBean.set원본파일명 ((String)rs.getString("원본파일명"));
                   dataBean.set파일순번   ((String)rs.getString("파일순번"  ));

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
	 * 건의&요청 다운로드 파일명 존재 확인
	 * @param paramData 
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public Integer selectRequestDownloadChk(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int cRead = 0;
		 
		try 
		{
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT count(*)                     								\n");
            sQry.append("   FROM 게시첨부파일             									\n");
            sQry.append("  WHERE 기업코드     = ?             								\n");
            sQry.append("    AND 법인코드     = ?             								\n");
            sQry.append("    AND 브랜드코드   = ?             								\n");
            sQry.append("    AND 게시구분     = ?         									\n");
            sQry.append("    AND 게시번호     = ?          									\n");
            sQry.append("    AND 파일순번     = ?             								\n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            pstmt.setString(++i, (String)paramHash.get("sseGroupCode")    					   );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCode")     					   );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCode")    					   );  //브랜드코드
            pstmt.setString(++i, (String)paramHash.get("pageGb")        				 	   );  //건의요청구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       					   );  //건의요청번호
            pstmt.setString(++i, (String)paramHash.get("fileNum")       					   );  //파일순번
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString() );
			rs = pstmt.executeQuery();
			
			 
			if(rs != null && rs.next()) cRead = rs.getInt(1);		
		} catch (SQLException e) {
	    	e.printStackTrace();
	    	System.out.println("SQL Exception : \n" + e.toString()  );
	    	System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString() );
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
		
		return cRead;
		
    }
    /**
     * 게시배포 파일업로드 업데이트
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateRequestFile(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 게시첨부파일                    							  \n");
			sQry.append("  SET    파일경로         = ?                						  \n");
			sQry.append("       , 파일명           = ?                						  \n");
			sQry.append("       , 원본파일명       = ?                						  \n");
			sQry.append("       , 최종변경일시     = TO_CHAR(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("       , 삭제여부         = 'N'                                      \n");
			sQry.append("   WHERE 기업코드         = ?                						  \n");
			sQry.append("        AND 법인코드      = ?                						  \n");
			sQry.append("        AND 브랜드코드    = ?                						  \n");
			sQry.append("        AND 게시번호      = ?                						  \n");
			sQry.append("        AND 게시구분      = ?                						  \n");
			sQry.append("        AND 파일순번      = ?                						  \n");
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("filePath")          );  //파일경로
            pstmt.setString(++i, (String)paramData.get("fileName")          );  //파일명
            pstmt.setString(++i, (String)paramData.get("orgFileName")       );  //원본파일명
            pstmt.setString(++i, (String)paramData.get("sseGroupCode")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("listNum")           );  //게시번호
            pstmt.setString(++i, (String)paramData.get("pageGb")            );  //게시구분
            pstmt.setString(++i, (String)paramData.get("fileNum")           );  //파일순번
            
            list = pstmt.executeUpdate();
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
   	 * 공지&교육 다운로드 파일명
   	 * @param paramData 
        * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
   	 * @throws Exception
   	 */
       public Integer selectNoticeRequestDownloadCnt(HashMap paramHash) throws Exception 
       {
       	
       	Connection con          = null;
   		PreparedStatement pstmt = null;
   		ResultSet rs            = null;
   		
   		int totalCnt = 0;
   		 
   		try 
   		{
   			
   			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
   			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
   			
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));		

   			con = DBConnect.getInstance().getConnection();
   			
   			StringBuffer sQry = new StringBuffer();

   			   sQry.append(" SELECT count(*)                                      \n");
               sQry.append("   FROM 게시첨부파일                                  \n");
               sQry.append("  WHERE 1=1                              			  \n");

   	        if(!("90").equals(권한코드)) {															//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
               sQry.append("    AND 기업코드     = ?                              \n");
               sQry.append("    AND 법인코드     = ?                              \n");
               sQry.append("    AND 브랜드코드   = ?                              \n");               
   	        }
   	        
               sQry.append("    AND 게시번호     = ?                              \n");
               sQry.append("    AND 게시구분     = ?                              \n");
               sQry.append("    AND 삭제여부     = 'N'                            \n");
               pstmt = new LoggableStatement(con, sQry.toString());
   			
               int i = 0;
               
   	        if(!("90").equals(권한코드)) {															//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
               pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
               pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
               pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
   	        }   
               pstmt.setString(++i, (String)paramHash.get("listNum")       );  //게시번호
               pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //게시구분
               
   				
               rs = pstmt.executeQuery();
               //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
   			if(rs != null && rs.next()) totalCnt = rs.getInt(1);
   			System.out.println("totalCnt : \n" + totalCnt  );
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
   	 * 건의&요청 다운로드 파일명
   	 * @param paramData 
        * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
   	 * @throws Exception
   	 */
       public Integer selectRequestDownloadCnt(HashMap paramHash) throws Exception 
       {
       	
       	Connection con          = null;
   		PreparedStatement pstmt = null;
   		ResultSet rs            = null;
   		
   		int cRead = 0;
   		 
   		try 
   		{
   			
			String 권한코드 = JSPUtil.chkNull((String)paramHash.get("권한코드"));		
   			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
   			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
   			
   			con = DBConnect.getInstance().getConnection();
   			
   			StringBuffer sQry = new StringBuffer();

   			   sQry.append(" SELECT count(*)                                      \n");
               sQry.append("   FROM 건의요청첨부파일                              \n");
               sQry.append("  WHERE 1=1                              			  \n");

            if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
               sQry.append("  WHERE 기업코드     = ?                              \n");
               sQry.append("    AND 법인코드     = ?                              \n");
               sQry.append("    AND 브랜드코드   = ?                              \n");
               sQry.append("    AND 매장코드     = ?                              \n");
   	        }   
               sQry.append("    AND 건의요청구분 = ?                              \n");
               sQry.append("    AND 건의요청번호 = ?                              \n");
               
               pstmt = new LoggableStatement(con, sQry.toString());
   			
               int i = 0;
               
               if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
	               pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
	               pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
	               pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
	               pstmt.setString(++i, (String)paramHash.get("sseStoreCd")    );  //매장코드
               }
               pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //건의요청구분
               pstmt.setString(++i, (String)paramHash.get("listNum")       );  //건의요청번호
   			
               //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
   			rs = pstmt.executeQuery();
   			
   			if(rs != null && rs.next()) cRead = rs.getInt(1);		
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
   		
   		return cRead;
   		
       }
    
       /**
   	 * 공지, 교육 파일다운로드 상세보기
   	 * @param 
   	 * @return
   	 * @throws DAOException
   	 */
   	public ArrayList<adminBean> selectNoticeRequestDownloadList(HashMap paramHash) throws DAOException
   	{
   		
   		Connection con          = null;
   		PreparedStatement pstmt = null;
   		ResultSet rs            = null;
   		
   		ArrayList<adminBean> list = new ArrayList<adminBean>();
   		
   		try
   		{ 
   			
			String 권한코드   = JSPUtil.chkNull((String)paramHash.get("권한코드"));		

			con = DBConnect.getInstance().getConnection();
   			
            StringBuffer sQry = new StringBuffer();
     
				sQry.append(" SELECT 파일명                                         \n");
				sQry.append("      , 원본파일명                                     \n");
				sQry.append("      , 파일순번                                       \n");
				sQry.append("   FROM 게시첨부파일                                  	\n");
				sQry.append("  WHERE 1=1                              				\n");
			
	        if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
				sQry.append("    AND 기업코드     = ?                              	\n");
				sQry.append("    AND 법인코드     = ?                              	\n");
				sQry.append("    AND 브랜드코드   = ?                              	\n");
	        }	
				sQry.append("    AND 게시구분     = ?                              	\n");
				sQry.append("    AND 게시번호     = ?                              	\n");
				sQry.append("    AND 삭제여부     = 'N'                            	\n");
				sQry.append("  ORDER BY 파일순번 ASC                               	\n");
               
               pstmt = new LoggableStatement(con, sQry.toString());
   			
               int i = 0;
               
   	        if(!("90").equals(권한코드)) {																//90:Super User권한 사용자의 글 등록시 문제가 되어 변경함. (2015.06.01)
               pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
               pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
               pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
   	        }
   	        
               pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //건의요청구분
               pstmt.setString(++i, (String)paramHash.get("listNum")       );  //건의요청번호
               //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
   			rs = pstmt.executeQuery();
   			
               // make databean list
   			adminBean dataBean = null;
               
               while( rs.next() )
               {
                   dataBean = new adminBean(); 
                   
                   dataBean.set파일명     ((String)rs.getString("파일명"    ));
                   dataBean.set원본파일명 ((String)rs.getString("원본파일명"));
                   dataBean.set파일순번   ((String)rs.getString("파일순번"  ));

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
     * 공지,교육자료 파일업로드 삭제
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteRequestFile(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 게시첨부파일                                                \n");
			sQry.append("  SET    삭제여부         = 'Y'                                      \n");
			sQry.append("       , 최종변경일시     = TO_CHAR(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE    기업코드      = ?                                        \n");
			sQry.append("        AND 법인코드      = ?                                        \n");
			sQry.append("        AND 브랜드코드    = ?                                        \n");
			sQry.append("        AND 게시구분      = ?                                        \n");
			sQry.append("        AND 게시번호      = ?                                        \n");
			sQry.append("        AND 파일순번      = ?                                        \n");
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCode")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")         );  //게시번호
            pstmt.setString(++i, (String)paramData.get("fileNum")         );  //파일순번
            
            list = pstmt.executeUpdate();
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
	 * 건의&요청 다운로드 파일명
	 * @param paramData 
	 * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
	public Integer selectNoticeDownloadCnt(HashMap paramHash) throws Exception 
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		int cRead = 0;
		 
		try 
		{
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
	
			sQry.append(" SELECT MAX(파일순번)                                 \n");
	        sQry.append("   FROM 게시첨부파일                              \n");
	        sQry.append("  WHERE 기업코드     = ?                              \n");
	        sQry.append("    AND 법인코드     = ?                              \n");
	        sQry.append("    AND 브랜드코드   = ?                              \n");
	        sQry.append("    AND 게시구분     = ?                              \n");
	        sQry.append("    AND 게시번호     = ?                              \n");
	        
	        pstmt = new LoggableStatement(con, sQry.toString());
			
	        int i = 0;
	        
	        pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
	        pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
	        pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
	        pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //게시구분
	        pstmt.setString(++i, (String)paramHash.get("listNum")       );  //게시번호
			
			rs = pstmt.executeQuery();
			
			if(rs != null && rs.next()) cRead = rs.getInt(1);		
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
		
		return cRead;
		
		}
	
	public ArrayList<adminBean> selectPartNoticeList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		ArrayList<adminBean> list = new ArrayList<adminBean>();
		String listNum = JSPUtil.chkNull((String)paramHash.get("listNum"),"0");	
		try
		{ 
						
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
			 
            sQry.append(" SELECT                           							  \n");
            sQry.append("        기업코드                   						  \n"); 
            sQry.append("      , 법인코드                   						  \n");  
            sQry.append("      , 브랜드코드                							  \n");  
            sQry.append("      , 게시구분                  							  \n");  
            sQry.append("      , 매장코드                      						  \n");
            sQry.append("      , 확인자                    							  \n");
            sQry.append("      , 확인여부                    						  \n"); 
            sQry.append("      , TO_CHAR(확인일자,'YYYY-MM-DD') AS 확인일자           \n");
            sQry.append("      , TO_CHAR(확인일자,'HH:MM:SS') AS 확인시간             \n");
            sQry.append("      , 배포일자                    						  \n");
            sQry.append("      , 예비문자                  							  \n");  
            sQry.append("      , 예비숫자                  							  \n");  
            sQry.append("      , 최종변경일시               						  \n");
            sQry.append(" FROM 게시배포정보               							  \n");
            sQry.append(" WHERE 게시번호 = ?            							  \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, listNum);
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
			rs = pstmt.executeQuery();
			
            // make databean list
			adminBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new adminBean(); 
                
                dataBean.set매장코드  ((String)rs.getString("매장코드"  ));
                dataBean.set확인여부  ((String)rs.getString("확인여부"  ));
                dataBean.set확인일자  ((String)rs.getString("확인일자"  ));
                dataBean.set확인시간  ((String)rs.getString("확인시간"  ));
                dataBean.set확인자    ((String)rs.getString("확인자"    ));
                dataBean.set배포일자  ((String)rs.getString("배포일자"  ));
                
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


