/** ############################################################### */
/** Program ID   : listDao.java                                     */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package board.dao;

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

import board.beans.listBean;

import com.util.JSPUtil;

public class listDao 
{
	
	/**
	 * 공지사항-교육자료 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<listBean> selectNoticeList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	

            //검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));
			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			System.out.println("srch_key : " + srch_key  );

			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";

//		 	String pageGb = new String(request.getParameter("pageGb").getBytes("8859_1"),"UTF-8");
 
			//게시구분
			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"),"01");			

			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                                             \n");
            sQry.append(" *                                                                  \n");
            sQry.append(" FROM                                                               \n");
            sQry.append(" (                                                                  \n");
            sQry.append("   SELECT                                                           \n");
            sQry.append("       ROW_NUMBER() OVER (ORDER BY A.게시번호 DESC) AS ROW_NUM        \n");
            sQry.append("       , A.기업코드                                                   \n");
            sQry.append("       , A.법인코드                                                   \n");
            sQry.append("       , A.브랜드코드                                                 \n");
            sQry.append("       , A.게시번호                                                   \n");
            sQry.append("       , A.제목                                                       \n");
            sQry.append("       , A.내용                                                       \n");
            sQry.append("       , A.조회수                                                     \n");
            sQry.append("       , A.등록자                                                     \n");
            sQry.append("       , A.공지구분                                                   \n");
            sQry.append("       , to_char(A.등록일자,'YYYY-MM-DD') as 등록일자                 \n");
            sQry.append("       , C.확인여부                                                   \n");
            sQry.append("       , (CASE TO_CHAR(C.확인일자,'YYYY') WHEN '1900' THEN NULL ELSE TO_CHAR(C.확인일자,'YYYY-MM-DD') END) as 확인여부일자                                                   \n");
            sQry.append("   FROM 게시등록정보     A                                            \n");
            sQry.append("      , 게시배포정보     C                                            \n");
            sQry.append("  WHERE 1=1                                               			   \n");
            sQry.append("    AND A.게시구분 = ?                                                \n");
            
            if (srch_type.equals("title")) {
                sQry.append("   AND  A.제목 LIKE ?                                             \n");
            } else if(srch_type.equals("content")) {
                sQry.append("   AND  A.내용 LIKE ?                                             \n");
            } else {
                sQry.append("   AND ( A.제목 LIKE ?  or A.내용 LIKE ?  )                       \n");
            }
            	
            sQry.append("   AND A.게시시작일자 <= to_char(sysdate,'YYYY-MM-DD')            	   \n");
            sQry.append("   AND A.게시종료일자 >= to_char(sysdate,'YYYY-MM-DD')            	   \n");
            sQry.append("   AND A.삭제여부 = 'N'                                               \n");
            sQry.append("   AND EXISTS ( SELECT 1											   \n");					
            sQry.append("                  FROM 게시배포정보  B                         	   \n");
            sQry.append("                 WHERE 1=1				                          	   \n");
            sQry.append("                   AND B.기업코드   = ?                          	   \n");
            sQry.append("                   AND B.법인코드   = ?                          	   \n");
            sQry.append("                   AND B.브랜드코드 = ?                        	   \n");
            
            if (!매장코드.equals("N/A")) {
            	sQry.append("               AND B.매장코드   = ?							   \n");	
            }		

        //  sQry.append("                   AND B.기업코드   = A.기업코드                 	   \n");
        //  sQry.append("                   AND B.법인코드   = A.법인코드                 	   \n");
        //  sQry.append("                   AND B.브랜드코드 = A.브랜드코드             	   \n");
            sQry.append("                   AND B.게시구분   = A.게시구분                 	   \n");
            sQry.append("                   AND B.게시번호   = A.게시번호  					   \n");
            sQry.append("               )                                               	   \n");
            
            sQry.append("   AND C.기업코드   = ?                          	                   \n");
            sQry.append("   AND C.법인코드   = ?                          	                   \n");
            sQry.append("   AND C.브랜드코드 = ?                        	                   \n");
            
            if (!매장코드.equals("N/A")) {
            	sQry.append("AND C.매장코드  = ?							                   \n");	
            }		

        //  sQry.append("    AND C.기업코드   = A.기업코드                 	                   \n");
        //  sQry.append("    AND C.법인코드   = A.법인코드                 	                   \n");
        //  sQry.append("    AND C.브랜드코드 = A.브랜드코드             	                   \n");
            sQry.append("    AND C.게시구분   = A.게시구분                 	                   \n");
            sQry.append("    AND C.게시번호   = A.게시번호  					               \n");
            
            sQry.append(" )                                                                    \n");
            sQry.append(" WHERE  ROW_NUM >  ?                                                  \n");
            sQry.append("   AND  ROW_NUM <= ?                                                  \n");
            sQry.append(" ORDER BY 게시번호 DESC                                               \n");     

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, page_gb);

            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }
            
            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);

            if (!매장코드.equals("N/A")) {
            	pstmt.setString(++p, 매장코드);
            }
            
            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);

            if (!매장코드.equals("N/A")) {
            	pstmt.setString(++p, 매장코드);
            }
            
            
            pstmt.setInt(++p   , (inCurPage-1)*inRowPerPage);  // 페이지당 시작 글 범위
			pstmt.setInt(++p   , (inCurPage*inRowPerPage)  );  // 페이지당 끌 글 범위
			
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"      )); 
                dataBean.set기업코드  ((String)rs.getString("기업코드"     ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"     ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"   ));
                dataBean.set게시번호  ((String)rs.getString("게시번호"     ));
                dataBean.set제목      ((String)rs.getString("제목"         ));
                dataBean.set내용      ((String)rs.getString("내용"         ));
                dataBean.set조회수    ((String)rs.getString("조회수"       ));
                dataBean.set등록자    ((String)rs.getString("등록자"       ));
                dataBean.set공지구분  ((String)rs.getString("공지구분"     ));
                dataBean.set등록일자  ((String)rs.getString("등록일자"     ));
                dataBean.set확인여부  ((String)rs.getString("확인여부"     ));
                dataBean.set확인일자  ((String)rs.getString("확인여부일자" ));

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
	 * 공지사항 (긴급공지) 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<listBean> selectEmergNoticeList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	

            //검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));
			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			System.out.println("srch_key : " + srch_key  );

			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";

//		 	String pageGb = new String(request.getParameter("pageGb").getBytes("8859_1"),"UTF-8");
 
			//게시구분
			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"),"01");			

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
            sQry.append("       , 공지구분                                                   \n");
            sQry.append("       , to_char(등록일자,'YYYY-MM-DD') as 등록일자                 \n");
            sQry.append("   FROM 게시등록정보     A                                          \n");
            sQry.append("  WHERE 1=1                                               			 \n");
            sQry.append("    AND 게시구분 = '01'                                           	 \n");
            sQry.append("    AND 게시시작일자 <= to_char(sysdate,'YYYY-MM-DD')            	 \n");
            sQry.append("    AND 게시종료일자 >= to_char(sysdate,'YYYY-MM-DD')            	 \n");
            sQry.append("    AND 삭제여부 = 'N'                                            	 \n");
            sQry.append("    AND 공지구분 = '2'                                             \n");
            sQry.append("    AND EXISTS ( SELECT 1											 \n");					
            sQry.append("                  FROM 게시배포정보  B                         	 \n");
            sQry.append("                 WHERE 1=1				                          	 \n");
            sQry.append("                   AND B.기업코드   = ?                          	 \n");
            sQry.append("                   AND B.법인코드   = ?                          	 \n");
            sQry.append("                   AND B.브랜드코드 = ?                        	 \n");
            
            if (!매장코드.equals("N/A")) {
            	sQry.append("               AND B.매장코드   = ?							 \n");	
            }		

        //  sQry.append("                   AND B.기업코드   = A.기업코드                 	 \n");
        //  sQry.append("                   AND B.법인코드   = A.법인코드                 	 \n");
        //  sQry.append("                   AND B.브랜드코드 = A.브랜드코드             	 \n");
            sQry.append("                   AND B.게시구분   = A.게시구분                 	 \n");
            sQry.append("                   AND B.게시번호   = A.게시번호  					 \n");
            sQry.append("                   AND B.확인여부   = 'N'      					 \n");
            sQry.append("               )                                               	 \n");

            sQry.append(" )                                                                  \n");
            sQry.append(" ORDER BY 게시번호 DESC                                             \n");     

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);

            if (!매장코드.equals("N/A")) {
            	pstmt.setString(++p, 매장코드);
            }
            
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"   )); 
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set게시번호  ((String)rs.getString("게시번호"  ));
                dataBean.set제목      ((String)rs.getString("제목"      ));
                dataBean.set내용      ((String)rs.getString("내용"      ));
                dataBean.set조회수    ((String)rs.getString("조회수"    ));
                dataBean.set등록자    ((String)rs.getString("등록자"    ));
                dataBean.set공지구분  ((String)rs.getString("공지구분"  ));
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
	 * 건의사항-요청사항 조회 List
	 * @param srch_key 검색어
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<listBean> selectClaimList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
			
			int inCurPage    = Integer.parseInt(JSPUtil.chkNull((String)paramHash.get("inCurPage"), "1"));  // 현재 페이지
			int inRowPerPage = 10;
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	

			//검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));
			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			//건의요청구분
			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"),"11");						

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
            sQry.append("       , 매장코드                                                 	 \n");
            sQry.append("       , 건의요청번호                                AS 게시번호    \n");
            sQry.append("       , 제목                                                       \n");
            sQry.append("       , 내용                                                       \n");
            sQry.append("       , 조회수                                                     \n");
            sQry.append("       , 공개여부                                                   \n");
            sQry.append("       , case when 요청구분='00' then '건의'                        \n");
            sQry.append("              when 요청구분='01' then '물류'                        \n");
            sQry.append("              when 요청구분='02' then 'POS'                         \n");
            sQry.append("       	   when 요청구분='03' then '인테리어'                    \n");
            sQry.append("         end                                         AS 요청구분    \n");
            sQry.append("       , 요청건수                                                   \n");
            sQry.append("       , 요청답변건수                                               \n");
            sQry.append("       , 요청상태코드                                               \n");
            sQry.append("       , 등록자                                                     \n");
            sQry.append("       , to_char(등록일자,'YYYY-MM-DD') as 등록일자                 \n");
            sQry.append("   FROM 건의요청등록정보                                            \n");
            sQry.append("  WHERE 1=1                                        				 \n");
            sQry.append("    AND 기업코드   = ?                                              \n");
            sQry.append("    AND 법인코드   = ?                                              \n");
            sQry.append("    AND 브랜드코드 = ?                                              \n");
            
            //요청사항인 경우에 해당매장 건만 조회
            if ( page_gb.equals("12") && !매장코드.equals("N/A")) {
                sQry.append("    AND 매장코드  = ?                                           \n");
            }

            sQry.append("    AND 건의요청구분 = ?                                            \n");
            
            if (srch_type.equals("title")) {
                sQry.append("   AND  제목 LIKE ?                                             \n");
            } else if(srch_type.equals("content")) {
                sQry.append("   AND  내용 LIKE ?                                             \n");
            } else {
                sQry.append("   AND ( 제목 LIKE ?  or 내용 LIKE ?  )                         \n");
            }

            sQry.append("   AND 삭제여부 = 'N'                                            	 \n");
            sQry.append(" )                                                                  \n");
            sQry.append(" WHERE  ROW_NUM >  ?                                                \n");
            sQry.append("   AND  ROW_NUM <= ?                                                \n");
            sQry.append(" ORDER BY 게시번호 DESC                                             \n");     

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);

            //요청사항인 경우에 해당매장 건만 조회
            if (page_gb.equals("12") && !매장코드.equals("N/A")) {
            	pstmt.setString(++p, 매장코드);
            }	

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
            
            
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
                dataBean.setROW_NUM   	((String)rs.getString("ROW_NUM"   )); 
                dataBean.set기업코드  	((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  	((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드	((String)rs.getString("브랜드코드"));
                dataBean.set매장코드  	((String)rs.getString("매장코드"  ));
                dataBean.set게시번호  	((String)rs.getString("게시번호"  ));
                dataBean.set제목      	((String)rs.getString("제목"      ));
                dataBean.set내용      	((String)rs.getString("내용"      ));
                dataBean.set조회수    	((String)rs.getString("조회수"    ));
                dataBean.set공개여부    ((String)rs.getString("공개여부"    ));
                dataBean.set요청구분    ((String)rs.getString("요청구분"    ));
                dataBean.set요청건수    ((String)rs.getString("요청건수"    ));
                dataBean.set요청답변건수((String)rs.getString("요청답변건수"));
                dataBean.set요청상태코드((String)rs.getString("요청상태코드"));
                dataBean.set등록자    	((String)rs.getString("등록자"    ));
                dataBean.set등록일자  	((String)rs.getString("등록일자"  ));
                
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
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			//검색Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	

			//검색어
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));	
			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";

			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"));			
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT COUNT(*)                                                   \n");
            sQry.append("   FROM 게시등록정보   A                                           \n");
            sQry.append("  WHERE 1=1            		                                    \n");
            sQry.append("    AND 게시구분 = ?                                               \n");

            if (srch_type.equals("title")) {
                sQry.append("   AND  제목 LIKE ?                                            \n");
            } else if(srch_type.equals("content")) {
                sQry.append("   AND  내용 LIKE ?                                            \n");
            } else {
                sQry.append("   AND ( 제목 LIKE ?  or 내용 LIKE ?  )                        \n");
            }
            	
            sQry.append("   AND 게시시작일자 <= to_char(sysdate,'YYYY-MM-DD')            	 \n");
            sQry.append("   AND 게시종료일자 >= to_char(sysdate,'YYYY-MM-DD')            	 \n");
            sQry.append("   AND 삭제여부 = 'N'                                            	\n");
            sQry.append("   AND EXISTS ( SELECT 1											\n");					
            sQry.append("                  FROM 게시배포정보  B                         	\n");
            sQry.append("                 WHERE B.기업코드   = ?                          	\n");
            sQry.append("                   AND B.법인코드   = ?                          	\n");
            sQry.append("                   AND B.브랜드코드 = ?                        	\n");

            if (!매장코드.equals("N/A")) {
            	sQry.append("               AND B.매장코드   = ?							\n");
            }
            
        //  sQry.append("                   AND B.기업코드   = A.기업코드                 	\n");
        //  sQry.append("                   AND B.법인코드   = A.법인코드                 	\n");
        //  sQry.append("                   AND B.브랜드코드 = A.브랜드코드             	\n");
            sQry.append("                   AND B.게시구분   = A.게시구분                 	\n");
            sQry.append("                   AND B.게시번호   = A.게시번호  					\n");
            sQry.append("               )                                               	\n");

            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            pstmt.setString(++p, page_gb);   // 게시구분

            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }

            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);

            if (!매장코드.equals("N/A")) {
            	pstmt.setString(++p, 매장코드);
            }
            
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
			
			String 기업코드   = JSPUtil.chkNull((String)paramHash.get("기업코드"));
			String 법인코드   = JSPUtil.chkNull((String)paramHash.get("법인코드"));
			String 브랜드코드 = JSPUtil.chkNull((String)paramHash.get("브랜드코드"));
			String 매장코드   = JSPUtil.chkNull((String)paramHash.get("매장코드"));

			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"));			

			//검색 Type
			String srch_type = JSPUtil.chkNull((String)paramHash.get("srch_type"),"0");	

			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = URLDecoder.decode(srch_key , "UTF-8");
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";			
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT COUNT(*)                                                   \n");
            sQry.append("   FROM 건의요청등록정보                                           \n");
            sQry.append("  WHERE 1=1		                                                \n");
            sQry.append("    AND 기업코드   = ?                                             \n");
            sQry.append("    AND 법인코드   = ?                                             \n");
            sQry.append("    AND 브랜드코드 = ?                                             \n");
            
            //요청사항인 경우에 해당매장 건만 조회
            if (page_gb.equals("12") && !매장코드.equals("N/A")) {
                sQry.append("    AND 매장코드  = ?                                          \n");
            }

            sQry.append("    AND 건의요청구분 = ?                                           \n");

            if (srch_type.equals("title")) {
                sQry.append("   AND  제목 LIKE ?                                            \n");
            } else if(srch_type.equals("content")) {
                sQry.append("   AND  내용 LIKE ?                                            \n");
            } else {
                sQry.append("   AND ( 제목 LIKE ?  or 내용 LIKE ?  )                        \n");
            }
            sQry.append("   AND 삭제여부 = 'N'                                            	\n");
            	
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            
            pstmt.setString(++p, 기업코드);
            pstmt.setString(++p, 법인코드);
            pstmt.setString(++p, 브랜드코드);

            //요청사항인 경우에 해당매장 건만 조회
            if (page_gb.equals("12") && !매장코드.equals("N/A")) {
            	pstmt.setString(++p, 매장코드);
            }	

            pstmt.setString(++p, page_gb);   // 게시구분

            if (srch_type.equals("0")) {
                pstmt.setString(++p, srch_key);
                pstmt.setString(++p, srch_key);
            } 
            else {
                pstmt.setString(++p, srch_key);
            }

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
			            

			sQry.append(" INSERT INTO 게시등록정보                                     \n");
			sQry.append(" (                                                            \n");
			sQry.append(" 기업코드,                                                    \n");
			sQry.append(" 법인코드,                                                    \n");
			sQry.append(" 브랜드코드,                                                  \n");
			sQry.append(" 게시구분 ,                                                   \n");
			sQry.append(" 게시번호 ,                                                   \n");
			sQry.append(" 제목 ,                                                       \n");
			sQry.append(" 내용 ,                                                       \n");
			sQry.append(" 공지구분 ,                                                   \n");
			sQry.append(" 게시시작일자,                                                \n");
			sQry.append(" 게시종료일자 ,                                               \n");
			sQry.append(" 조회수,                                                      \n");
			sQry.append(" 등록자,                                                      \n");
			sQry.append(" 등록일자,                                                    \n");
			sQry.append(" 등록패스워드,                                                \n");
			sQry.append(" 삭제여부,                                                    \n");
			sQry.append(" 예비문자,                                                    \n");
			sQry.append(" 예비숫자,                                                    \n");
			sQry.append(" 최종변경일시                                                 \n");
			sQry.append(" ) VALUES (                                                   \n");
			sQry.append(" ?,                                                           \n");
			sQry.append(" ?,                                                           \n");
			sQry.append(" ?,                                                           \n");
			sQry.append(" 1,                                                           \n");
			sQry.append(" (SELECT MAX(게시번호)+1 FROM 게시등록정보),                  \n");
			sQry.append(" ?,                                                           \n");
			sQry.append(" ?,                                                           \n");
			sQry.append(" '1',                                                         \n");
			sQry.append(" SYSDATE,                                                     \n");
			sQry.append(" SYSDATE,                                                     \n");
			sQry.append(" 0,                                                           \n");
			sQry.append(" ?,                                                           \n");
			sQry.append(" to_char(SYSDATE,'YYYY-MM-DD'),                               \n");
			sQry.append(" '1234',                                                      \n");
			sQry.append("'N',                                                          \n");
			sQry.append(" '',                                                          \n");
			sQry.append(" '',                                                          \n");
			sQry.append(" to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss')                     \n");
			sQry.append(" )                                                            \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCode")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("title")           );  //제목
            pstmt.setString(++i, (String)paramData.get("comment")         );  //글내용
            pstmt.setString(++i, (String)paramData.get("sseCustNm")       );  //등록자명
            
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
    public ArrayList<listBean> selectNoticeDetail(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
						
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                             \n");
            sQry.append("       기업코드,                                    \n"); 
            sQry.append("       법인코드,                                    \n");  
            sQry.append("       브랜드코드,                                  \n");  
            sQry.append("       게시구분 ,                                   \n");  
            sQry.append("       게시번호 ,                                   \n");  
            sQry.append("       제목 ,                                       \n");  
            sQry.append("       내용 ,                                       \n");  
            sQry.append("       공지구분 ,                                   \n");  
            sQry.append("       게시시작일자,                                \n");  
            sQry.append("       게시종료일자 ,                               \n");  
            sQry.append("       조회수,                                      \n");  
            sQry.append("       등록자,                                      \n");  
            sQry.append("       to_char(등록일자,'YYYY-MM-DD') as 등록일자 , \n");  
            sQry.append("       등록패스워드,                                \n");  
            sQry.append("       삭제여부,                                    \n");  
            sQry.append("       예비문자,                                    \n");  
            sQry.append("       예비숫자,                                    \n");  
            sQry.append("       최종변경일시                                 \n");
            sQry.append("  FROM 게시등록정보  A                              \n");
            sQry.append(" WHERE 게시구분     = ?                             \n");
            sQry.append("   AND 게시번호     = ?                             \n");  
            sQry.append("   AND EXISTS ( SELECT 1 FROM 게시배포정보  B         \n");
            sQry.append("                 WHERE B.기업코드     = ?             \n");
            sQry.append("                   AND B.법인코드     = ?             \n");
            sQry.append("                   AND B.브랜드코드   = ?             \n");
            sQry.append("                   AND B.게시구분     = ?             \n");
            sQry.append("                   AND B.게시번호     = ?             \n");
            sQry.append("                   AND B.매장코드     = ?             \n");
            sQry.append("                   AND B.게시구분   = A.게시구분      \n");
            sQry.append("                   AND B.게시번호   = A.게시번호  	)  \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++p, (String)paramHash.get("listNum")       );  //게시번호
            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++p, (String)paramHash.get("listNum")       );  //게시번호
            pstmt.setString(++p, (String)paramHash.get("sseCustStoreCd"));  //매장코드
			
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set게시번호  ((String)rs.getString("게시번호"  ));
                dataBean.set제목      ((String)rs.getString("제목"      ));
                dataBean.set내용      ((String)rs.getString("내용"      ));
                dataBean.set공지구분  ((String)rs.getString("공지구분"  ));
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
     * 공지&교육 글 수정
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
			            

			sQry.append("  UPDATE 게시등록정보                                            \n");
			sQry.append("  SET    제목         = ?                                        \n");
			sQry.append("      ,  내용         = ?                                        \n");
			sQry.append("      ,  최종변경일시 = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드     = ?                                        \n");
			sQry.append("        AND 법인코드  = ?                                        \n");
			sQry.append("        AND 브랜드코드= ?                                        \n");
			sQry.append("        AND 게시번호  = ?                                        \n");
			sQry.append("        AND 게시구분  = ?                                        \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("title")        );  //제목
            pstmt.setString(++i, (String)paramData.get("comment")      );  //글내용
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCode") );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCode")  );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCode") );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("listNum")      );  //게시번호
            pstmt.setString(++i, (String)paramData.get("pageGb")       );  //게시구분
            
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
     * 건의&요청 글 수정
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateProposalWrite(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 건의요청등록정보                                        \n");
			sQry.append("  SET    제목         = ?                                        \n");
			sQry.append("      ,  내용         = ?                                        \n");
			sQry.append("      ,  요청구분     = ?                                        \n");
			sQry.append("      ,  요청상태코드 = '1'                                      \n");
			sQry.append("      ,  수정자       = ?                                        \n");
			sQry.append("      ,  수정일자     = to_char(SYSDATE,'YYYY-MM-DD')            \n");
			sQry.append("      ,  최종변경일시 = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE    기업코드     = ?                                     \n");
			sQry.append("        AND 법인코드     = ?                                     \n");
			sQry.append("        AND 브랜드코드   = ?                                     \n");
			sQry.append("        AND 매장코드     = ?                                     \n");
			sQry.append("        AND 건의요청번호 = ?                                     \n");
			sQry.append("        AND 건의요청구분 = ?                                     \n");
			
			int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("title")         );  //제목
            pstmt.setString(++i, (String)paramData.get("comment")       );  //글내용
            pstmt.setString(++i, (String)paramData.get("comboClaimGb")  );  //요청구분
            pstmt.setString(++i, (String)paramData.get("sseCustNm")     );  //수정자
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramData.get("listNum")       );  //건의요청번호
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  //건의요청구분
            
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
			            
			sQry.append(" UPDATE 게시등록정보  A                          	\n");
			sQry.append("    SET 조회수 = 조회수+1                          \n");
			sQry.append("  WHERE 1=1                         				\n");
		//	sQry.append("    AND 기업코드      	= ?                         \n");
		//	sQry.append("    AND 법인코드   	= ?                         \n");
		//	sQry.append("    AND 브랜드코드 	= ?                         \n");
			sQry.append("    AND A.게시구분   	= ?                         \n");
			sQry.append("    AND A.게시번호   	= ?                         \n");
            sQry.append("    AND EXISTS (SELECT 1 FROM 게시배포정보  B         \n");
            sQry.append("                 WHERE B.기업코드     = ?             \n");
            sQry.append("                   AND B.법인코드     = ?             \n");
            sQry.append("                   AND B.브랜드코드   = ?             \n");
            sQry.append("                   AND B.게시구분     = ?             \n");
            sQry.append("                   AND B.게시번호     = ?             \n");
            sQry.append("                   AND B.매장코드     = ?             \n");
            sQry.append("                   AND B.게시구분   = A.게시구분      \n");
            sQry.append("                   AND B.게시번호   = A.게시번호  	)  \n");

            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("pageGb")           );  //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")          );  //게시번호
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")       );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")        );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")       );  //브랜드코드 
            pstmt.setString(++i, (String)paramData.get("pageGb")           );  //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")          );  //게시번호
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")   );  //매장코드 
            
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
	 * 댓글 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<listBean> selectCommList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
			
			
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                                             \n");
            sQry.append(" *                                                                  \n");
            sQry.append(" FROM                                                               \n");
            sQry.append(" (                                                                  \n");
            sQry.append("   SELECT                                                           \n");
            sQry.append("         ROW_NUMBER() OVER (ORDER BY 게시번호 DESC) AS ROW_NUM      \n");
            sQry.append("       , 기업코드                                                   \n");
            sQry.append("       , 법인코드                                                   \n");
            sQry.append("       , 브랜드코드                                                 \n");
            sQry.append("       , 게시구분                                                   \n");
            sQry.append("       , 게시번호                                                   \n");
            sQry.append("       , 매장코드                                                   \n");
            sQry.append("       , 댓글번호                                                   \n");
            sQry.append("       , REPLACE(내용, '<BR>', CHR(13))           AS 내용           \n");
            sQry.append("       , 등록자                                                     \n");
            sQry.append("       , to_char(등록일자,'YYYY-MM-DD') as 등록일자                 \n");
            sQry.append("   FROM  게시댓글정보   A                                           \n");
            sQry.append("  WHERE  A.게시구분   = ?                                           \n");
            sQry.append("    AND  A.게시번호   = ?                                           \n");
            sQry.append("    AND  A.삭제여부   = 'N'                                         \n");
            sQry.append("    AND EXISTS (SELECT 1 FROM 게시배포정보  B         				\n");
            sQry.append("                 WHERE B.기업코드     = ?             				\n");
            sQry.append("                   AND B.법인코드     = ?             				\n");
            sQry.append("                   AND B.브랜드코드   = ?             				\n");
            sQry.append("                   AND B.게시구분     = ?             				\n");
            sQry.append("                   AND B.게시번호     = ?             				\n");
            sQry.append("                   AND B.매장코드     = ?             				\n");
            sQry.append("                   AND B.게시구분   = A.게시구분      				\n");
            sQry.append("                   AND B.게시번호   = A.게시번호  	)  				\n");            
            sQry.append(" )                                                                  \n");
            sQry.append(" ORDER BY 게시번호 DESC, 댓글번호 DESC                              \n");     

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++p, (String)paramHash.get("listNum")       );  //게시번호
            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++p, (String)paramHash.get("listNum")       );  //게시번호
            pstmt.setString(++p, (String)paramHash.get("sseCustStoreCd"));  //매장코드
			
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
			System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"   )); 
                dataBean.set기업코드  ((String)rs.getString("기업코드"  ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"  ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set매장코드  ((String)rs.getString("매장코드"  ));
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
     * 공지&교육 댓글 저장
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
			            

			sQry.append(" INSERT INTO 게시댓글정보                                        \n");
			sQry.append(" (                                                               \n");
			sQry.append(" 기업코드,                                                       \n");
			sQry.append(" 법인코드,                                                       \n");
			sQry.append(" 브랜드코드,                                                     \n");
			sQry.append(" 게시구분 ,                                                      \n");
			sQry.append(" 게시번호 ,                                                      \n");
			sQry.append(" 매장코드 ,                                                      \n");
			sQry.append(" 댓글번호 ,                                                      \n");
			sQry.append(" 내용 ,                                                          \n");
			sQry.append(" 공개여부 ,                                                      \n");
			sQry.append(" 등록자,                                                         \n");
			sQry.append(" 등록일자,                                                       \n");
			sQry.append(" 등록패스워드,                                                   \n");
			sQry.append(" 삭제여부,                                                       \n");
			sQry.append(" 예비문자,                                                       \n");
			sQry.append(" 예비숫자,                                                       \n");
			sQry.append(" 최종변경일시                                                    \n");
			sQry.append(" ) VALUES (                                                      \n");
			sQry.append(" ?,                                                              \n");
			sQry.append(" ?,                                                              \n");
			sQry.append(" ?,                                                              \n");
			sQry.append(" ?,                                                              \n");
			sQry.append(" ?,                                                              \n");
			sQry.append(" ?,                                                              \n");
			/*sQry.append(" (SELECT nvl(MAX(댓글번호),0)+1 FROM 게시댓글정보),              \n");*/
			sQry.append(" FNC_BOARD_COMMENT_SEQ_NO(?,?,?,?,?),                            \n");
			sQry.append(" REPLACE(?, CHR(13), '<BR>'),                                                              \n");
			sQry.append(" 'Y',                                                            \n");
			sQry.append(" ?,                                                              \n");
			sQry.append(" to_char(SYSDATE,'YYYY-MM-DD'),                                  \n");
			sQry.append(" '1234',                                                         \n");
			sQry.append("'N',                                                             \n");
			sQry.append(" '',                                                             \n");
			sQry.append(" '',                                                             \n");
			sQry.append(" to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss')                        \n");
			sQry.append(" )                                                               \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")     );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")      );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")     );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")         );  //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")        );  //게시번호
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd") );  //매장코드
            
            //게시번호 체번
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")     );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")      );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")     );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("pageGb")         );  //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")        );  //게시번호
            
            pstmt.setString(++i, (String)paramData.get("comment")        );  //댓글내용
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
	 * 공지&교육 게시물의 댓글 수
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
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT COUNT(*)                                 \n");
            sQry.append("   FROM 게시댓글정보  A                          \n");
            sQry.append("  WHERE 1=1                                      \n");
            sQry.append("    AND A.게시구분    = ?                        \n");
            sQry.append("    AND A.게시번호    = ?                        \n");
            sQry.append("    AND A.삭제여부    = 'N'                      \n");
            sQry.append("    AND EXISTS (SELECT 1 FROM 게시배포정보  B         \n");
            sQry.append("                 WHERE B.기업코드     = ?             \n");
            sQry.append("                   AND B.법인코드     = ?             \n");
            sQry.append("                   AND B.브랜드코드   = ?             \n");
            sQry.append("                   AND B.게시구분     = ?             \n");
            sQry.append("                   AND B.게시번호     = ?             \n");
            sQry.append("                   AND B.매장코드     = ?             \n");
            sQry.append("                   AND B.게시구분   = A.게시구분      \n");
            sQry.append("                   AND B.게시번호   = A.게시번호  	)  \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            
            pstmt.setString(++p, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++p, (String)paramHash.get("listNum")       );  //게시번호
        	pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++p, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++p, (String)paramHash.get("listNum")       );  //게시번호
            pstmt.setString(++p, (String)paramHash.get("sseCustStoreCd"));  //매장코드
			
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
     * 매장 건의요청사항 글 저장
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
			            

			sQry.append(" INSERT INTO 건의요청등록정보              \n");
			sQry.append(" (                                         \n");
			sQry.append(" 기업코드,                                 \n");
			sQry.append(" 법인코드,                                 \n");
			sQry.append(" 브랜드코드,                               \n");
			sQry.append(" 매장코드,                                 \n");
			sQry.append(" 건의요청구분 ,                            \n");
			
			sQry.append(" 건의요청번호 ,                            \n");
			sQry.append(" 요청구분 ,                                \n");
			sQry.append(" 제목 ,                                    \n");
			sQry.append(" 공개여부 ,                                \n");
			sQry.append(" 내용 ,                                    \n");
			
			sQry.append(" 조회수 ,                                  \n");
			sQry.append(" 요청건수,                                 \n");
			sQry.append(" 요청답변건수 ,                            \n");
			sQry.append(" 요청상태코드,                             \n");
			sQry.append(" 등록자,                                   \n");
			
			sQry.append(" 등록일자,                                 \n");
			sQry.append(" 등록패스워드,                             \n");
			sQry.append(" 삭제여부,                                 \n");
			sQry.append(" 예비문자,                                 \n");
			sQry.append(" 예비숫자,                                 \n");
			
			sQry.append(" 최종변경일시                              \n");
			
			sQry.append(" ) VALUES (                                \n");
			sQry.append(" ?,                                        \n");
			sQry.append(" ?,                                        \n");
			sQry.append(" ?,                                        \n");
			sQry.append(" ?,                                        \n");
			sQry.append(" ?,                                        \n");
			
			/*sQry.append(" FNC_SEQ_NO('건의요청등록정보',?,?,?,?),   \n");*/
			sQry.append(" FNC_REQUEST_SEQ_NO(?,?,?,?,?),            \n");
			sQry.append(" ?,                                        \n");
			sQry.append(" ?,                                        \n");
			sQry.append(" 'Y',                                      \n");
			sQry.append(" ?,                                        \n");
			
			sQry.append(" 0,                                        \n");
			sQry.append(" 0,                                        \n");
			sQry.append(" 0,                                        \n");
			sQry.append(" '1',                                      \n");
			sQry.append(" ?,                                        \n");
			
			sQry.append(" to_char(sysdate,'YYYY-MM-DD'),            \n");
			sQry.append(" '1234',                                   \n");
			sQry.append("'N',                                       \n");
			sQry.append(" '',                                       \n");
			sQry.append(" '',                                       \n");
			
			sQry.append(" to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss')  \n");
			sQry.append(" )                                         \n");
			
						
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
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  //건의요청구분(게시구분)
            
            pstmt.setString(++i, (String)paramData.get("comboVal")      );  //요청구분
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
     * 건의요청사항 첨부파일 저장
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int insertProposalFile(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;
		
		int list = 0;
		
		
		try
		{
			String listNum = JSPUtil.chkNull((String)paramData.get("listNum"));
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append(" INSERT INTO 건의요청첨부파일 \n");
			sQry.append(" (                            \n");
			sQry.append(" 기업코드,                    \n");
			sQry.append(" 법인코드,                    \n");
			sQry.append(" 브랜드코드,                  \n");
			sQry.append(" 매장코드,                    \n");
			sQry.append(" 건의요청구분 ,               \n");
			
			sQry.append(" 건의요청번호 ,               \n");
			sQry.append(" 파일순번 ,                   \n");
			sQry.append(" 파일경로 ,                   \n");
			sQry.append(" 파일명 ,                     \n");
			sQry.append(" 원본파일명 ,                 \n");

			sQry.append(" 등록일자,                    \n");
			sQry.append(" 삭제여부,                    \n");
			sQry.append(" 최종변경일시                 \n");
			
			sQry.append(" ) VALUES (                   \n");
			sQry.append(" ?, --기업코드,               \n");
			sQry.append(" ?, --법인코드,               \n");
			sQry.append(" ?, --브랜드코드,             \n");
			sQry.append(" ?, --매장코드,               \n");
			sQry.append(" ?, --건의요청구분,           \n");
			
			if("".equals(listNum)){
				/*sQry.append(" FNC_SEQ_NO('건의요청등록정보',?,?,?,?), --건의요청번호,    \n");*/
				sQry.append(" FNC_REQUEST_SEQ_NO(?,?,?,?,?), --건의요청번호,    \n");
			}else{
				sQry.append(" ?, --건의요청번호 ,          \n");
			}
			
			sQry.append(" ?, --파일순번 ,              \n");
			sQry.append(" ?, --파일경로 ,              \n");
			sQry.append(" ?, --파일명 ,                \n");
			sQry.append(" ?, --원본파일명 ,            \n");
			
			sQry.append(" to_char(sysdate,'YYYY-MM-DD'), --등록일자, \n");
			sQry.append("'N', --삭제여부,              \n");
			sQry.append(" to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') --최종변경일시       \n");
			sQry.append(" )                            \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  //건의요청구분(게시구분)
            
            if("".equals(listNum)){
            	//건의요청번호 Function
                pstmt.setString(++i, (String)paramData.get("sseGroupCd"));     //기업코드
                pstmt.setString(++i, (String)paramData.get("sseCorpCd") );     //법인코드
                pstmt.setString(++i, (String)paramData.get("sseBrandCd"));     //브랜드코드
                pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")); //매장코드
                pstmt.setString(++i, (String)paramData.get("pageGb")    );     //건의요청구분(게시구분)
            }else{
            	pstmt.setString(++i, (String)paramData.get("listNum")   );  //건의요청번호(게시번호)
            }
            
            pstmt.setString(++i, (String)paramData.get("fileNum")  		);  //파일순번
            pstmt.setString(++i, (String)paramData.get("filePath")      );  //파일경로
            pstmt.setString(++i, (String)paramData.get("fileName")      );  //파일명
            pstmt.setString(++i, (String)paramData.get("orgFileName")   );  //원본파일명
            
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
	public ArrayList<listBean> selectComboClaim() throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList list = new ArrayList();
		
		try
		{ 
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("  SELECT 세부코드명                    \n");
            sQry.append("	 FROM PRM공통코드                   \n");
            sQry.append("   WHERE 1=1                           \n");
            sQry.append("     AND 분류코드 = '요청구분'         \n");
            sQry.append("   ORDER BY 표시순서 ASC               \n");
            
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
			
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
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
     * 매장 건의요청사항 글 정보보기
     * @param paramHash
     * @return
     * @throws DAOException
     */
    public ArrayList<listBean> selectProposalDetail(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
			String sseCustStoreCd   = JSPUtil.chkNull((String)paramHash.get("sseCustStoreCd"));
			//건의요청구분
			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"),"11");
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                               \n");
            sQry.append("      A.기업코드,                                     \n"); 
            sQry.append("      A.법인코드,                                     \n");  
            sQry.append("      A.브랜드코드,                                   \n");  
            sQry.append("      A.매장코드,                                     \n");
            sQry.append("      A.건의요청구분,                                 \n");
            sQry.append("      A.건의요청번호,                                 \n");
            sQry.append("      A.요청구분 ,                                    \n");  
            sQry.append("      A.제목 ,                                        \n");  
            sQry.append("      A.공개여부 ,                                    \n");
            sQry.append("      A.내용 ,                                        \n");  
            sQry.append("      A.조회수 ,                                      \n");  
            sQry.append("      A.요청건수,                                     \n");  
            sQry.append("      A.요청답변건수 ,                                \n");  
            sQry.append("      A.요청상태코드,                                 \n");  
            sQry.append("      A.등록자,                                       \n");  
            sQry.append("      to_char(A.등록일자,'YYYY-MM-DD') as 등록일자 ,  \n");  
            sQry.append("      A.등록패스워드,                                 \n");  
            sQry.append("      A.삭제여부,                                     \n");
            sQry.append("      A.수정자,                                       \n");
            sQry.append("      A.수정일자,                                     \n");
            sQry.append("      A.예비문자,                                     \n");  
            sQry.append("      A.예비숫자,                                     \n");  
            sQry.append("      A.최종변경일시                                  \n");
            sQry.append(" FROM 건의요청등록정보 A                              \n");
            sQry.append(" WHERE A.건의요청구분 = ?                             \n");
            sQry.append(" AND   A.건의요청번호 = ?                             \n");
            sQry.append(" AND   A.기업코드     = ?                             \n");
			sQry.append(" AND   A.법인코드     = ?                             \n");
			sQry.append(" AND   A.브랜드코드   = ?                             \n");
			//요청사항인 경우에 해당매장 건만 조회
            if ( page_gb.equals("12") && !sseCustStoreCd.equals("N/A")) {
                sQry.append("    AND A.매장코드  = ?                             \n");
            }
            sQry.append(" AND A.삭제여부       = 'N'                           \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("pageGb")            );  //건의요청구분(게시구분)
            pstmt.setString(++p, (String)paramHash.get("listNum")           );  //건의요청번호(게시번호)
            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")        );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")         );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")        );  //브랜드코드
            
            if (page_gb.equals("12") && !sseCustStoreCd.equals("N/A")) {
            	pstmt.setString(++p, (String)paramHash.get("sseCustStoreCd")    );  //매장코드
            }
            
            
			rs = pstmt.executeQuery();
			
			System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
            // make databean list
			listBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
                dataBean.set기업코드    ((String)rs.getString("기업코드"    ));
                dataBean.set법인코드    ((String)rs.getString("법인코드"    ));
                dataBean.set브랜드코드  ((String)rs.getString("브랜드코드"  ));
                dataBean.set매장코드    ((String)rs.getString("매장코드"    ));
                dataBean.set건의요청번호((String)rs.getString("건의요청번호"));
                dataBean.set제목        ((String)rs.getString("제목"        ));
                dataBean.set내용        ((String)rs.getString("내용"        ));
                dataBean.set조회수      ((String)rs.getString("조회수"      ));
                dataBean.set등록자      ((String)rs.getString("등록자"      ));
                dataBean.set등록일자    ((String)rs.getString("등록일자"    ));
                dataBean.set요청구분    ((String)rs.getString("요청구분"    ));
                
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
     * 건의 & 요청 조회수 업데이트
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
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            
			sQry.append(" UPDATE 건의요청등록정보                      \n");
			sQry.append(" SET 조회수 = ( SELECT MAX(조회수)+1          \n");
			sQry.append("                  FROM 건의요청등록정보       \n");
			sQry.append("                 WHERE 기업코드     = ?       \n");
			sQry.append("                   AND 법인코드     = ?       \n");
			sQry.append("                   AND 브랜드코드   = ?       \n");
			sQry.append("                   AND 매장코드     = ?       \n");
			sQry.append("                   AND 건의요청번호 = ?       \n");
			sQry.append("                   AND 건의요청구분 = ?       \n");
			sQry.append("              )                               \n");
			sQry.append("  WHERE 기업코드        = ?                   \n");
			sQry.append("       AND 법인코드     = ?                   \n");
			sQry.append("       AND 브랜드코드   = ?                   \n");
			sQry.append("       AND 매장코드     = ?                   \n");
			sQry.append("       AND 삭제여부     = 'N'                 \n");
			sQry.append("       AND 건의요청번호 = ?                   \n");
			sQry.append("       AND 건의요청구분 = ?                   \n");
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramData.get("listNum")       );  //건의요청번호(게시번호)
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  //건의요청구분(게시구분)
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramData.get("listNum")       );  //건의요청번호(게시번호)
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  //건의요청구분(게시구분)
            
            list = pstmt.executeUpdate();
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
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
     * 건의&요청 댓글 등록
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
			            

			sQry.append(" INSERT INTO 건의요청댓글정보 \n");
			sQry.append(" (                            \n");
			sQry.append(" 기업코드,                    \n");
			sQry.append(" 법인코드,                    \n");
			sQry.append(" 브랜드코드,                  \n");
			sQry.append(" 매장코드 ,                   \n");
			sQry.append(" 건의요청구분 ,               \n");
			
			sQry.append(" 건의요청번호 ,               \n");
			sQry.append(" 댓글번호 ,                   \n");
			sQry.append(" 공개여부 ,                   \n");
			sQry.append(" 내용 ,                       \n");
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
			sQry.append(" ?, --매장코드                \n");
			sQry.append(" ?, --건의요청구분 ,          \n");
			
			sQry.append(" ?, --건의요청번호 ,          \n");
			sQry.append(" FNC_REQUEST_COMMENT_SEQ_NO(?,?,?,?,?,?), --댓글번호       \n");
			sQry.append(" 'Y', --공개여부 ,            \n");
			sQry.append(" ?, --내용 ,                  \n");
			sQry.append(" ?, --등록자,                 \n");
			
			sQry.append(" to_char(sysdate,'YYYY-MM-DD'), --등록일자,               \n");
			sQry.append(" '1234', --등록패스워드,      \n");
			sQry.append("'N', --삭제여부,              \n");
			sQry.append(" '', --예비문자,              \n");
			sQry.append(" '', --예비숫자,              \n");
			
			sQry.append(" to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') --최종변경일시  \n");
			sQry.append(" )                            \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")     );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")      );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")     );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd") );  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")         );  //건의요청구분
            
            pstmt.setString(++i, (String)paramData.get("listNum")        );  //건의요청번호
            
            /*FNC_REQUEST_COMMENT_SEQ_NO 건의요청 댓글번호 체번*/
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")     );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")      );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")     );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd") );  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")         );  //건의요청구분
            pstmt.setString(++i, (String)paramData.get("listNum")        );  //건의요청번호
            
            
            pstmt.setString(++i, (String)paramData.get("comment")        );  //댓글내용
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
	 * 건의&요청 댓글 조회 List
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<listBean> selectProposalCommList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
			String sseCustStoreCd   = JSPUtil.chkNull((String)paramHash.get("sseCustStoreCd"));
			//건의요청구분
			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"),"11");
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT                                                             \n");
            sQry.append(" *                                                                  \n");
            sQry.append(" FROM                                                               \n");
            sQry.append(" (                                                                  \n");
            sQry.append("   SELECT                                                           \n");
            sQry.append("         ROW_NUMBER() OVER (ORDER BY 건의요청번호 DESC) AS ROW_NUM  \n");
            sQry.append("       , 기업코드                                                   \n");
            sQry.append("       , 법인코드                                                   \n");
            sQry.append("       , 브랜드코드                                                 \n");
            sQry.append("       , 매장코드                                                   \n");
            sQry.append("       , 건의요청구분                                               \n");
            sQry.append("       , 건의요청번호                                               \n");
            sQry.append("       , 댓글번호                                                   \n");
            sQry.append("       , 내용                                                       \n");
            sQry.append("       , 등록자                                                     \n");
            sQry.append("       , to_char(등록일자,'YYYY-MM-DD') as 등록일자                 \n");
            sQry.append("   FROM  건의요청댓글정보                                           \n");
            sQry.append("   WHERE 건의요청구분 = ?                                           \n");
            sQry.append("     AND 기업코드     = ?                                           \n");
			sQry.append("     AND 법인코드     = ?                                           \n");
			sQry.append("     AND 브랜드코드   = ?                                           \n");
			//요청사항인 경우에 해당매장 건만 조회
            if ( page_gb.equals("12") && !sseCustStoreCd.equals("N/A")) {
                sQry.append("    AND 매장코드  = ?                             \n");
            }
            sQry.append("     AND 삭제여부     = 'N'                                         \n");
            sQry.append(" )                                                                  \n");
            sQry.append(" ORDER BY 댓글번호 DESC                                             \n");     

            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("pageGb")        );  //건의요청구분(게시구분)
            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            
            //요청사항인 경우에 해당매장 건만 조회
            if (page_gb.equals("12") && !sseCustStoreCd.equals("N/A")) {
            	pstmt.setString(++p, (String)paramHash.get("sseCustStoreCd"));  //매장코드
            }
            
			
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
                dataBean.setROW_NUM   ((String)rs.getString("ROW_NUM"      )); 
                dataBean.set기업코드  ((String)rs.getString("기업코드"     ));
                dataBean.set법인코드  ((String)rs.getString("법인코드"     ));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"   ));
                dataBean.set매장코드  ((String)rs.getString("매장코드"     ));
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
			String sseCustStoreCd   = JSPUtil.chkNull((String)paramHash.get("sseCustStoreCd"));
			//건의요청구분
			String page_gb  = JSPUtil.chkNull((String)paramHash.get("pageGb"),"11");
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT COUNT(*)                                        \n");
            sQry.append("   FROM 건의요청댓글정보                                \n");
            sQry.append("  WHERE 1=1                                             \n");
            sQry.append("    AND 건의요청구분 = ?                                \n");
            sQry.append("    AND 건의요청번호 = ?                                \n");
            sQry.append("    AND 기업코드     = ?                                \n");
			sQry.append("    AND 법인코드     = ?                                \n");
			sQry.append("    AND 브랜드코드   = ?                                \n");
			//요청사항인 경우에 해당매장 건만 조회
            if ( page_gb.equals("12") && !sseCustStoreCd.equals("N/A")) {
                sQry.append("    AND 매장코드  = ?                             \n");
            }
            sQry.append("    AND 삭제여부     = 'N'                              \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int p = 0;
            
            pstmt.setString(++p, (String)paramHash.get("pageGb")        );  //건의요청구분
            pstmt.setString(++p, (String)paramHash.get("listNum")       );  //건의요청번호
            pstmt.setString(++p, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++p, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++p, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            
            //요청사항인 경우에 해당매장 건만 조회
            if (page_gb.equals("12") && !sseCustStoreCd.equals("N/A")) {
            	pstmt.setString(++p, (String)paramHash.get("sseCustStoreCd"));  //매장코드
            }
            
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
     * 건의&요청 게시글 삭제
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteProposal(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 건의요청등록정보                    \n");
			sQry.append("  SET    삭제여부 = 'Y'                      \n");
			sQry.append("      ,  최종변경일시     = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드         = ?                \n");
			sQry.append("        AND 법인코드      = ?                \n");
			sQry.append("        AND 브랜드코드    = ?                \n");
			sQry.append("        AND 매장코드      = ?                \n");
			sQry.append("        AND 건의요청번호  = ?                \n");
			sQry.append("        AND 건의요청구분  = ?                \n");			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")  );  //매장코드
            pstmt.setString(++i, (String)paramData.get("listNum")         );  //건의요청번호
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //건의요청구분
            
            list = pstmt.executeUpdate();
            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
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
     * 건의&요청 첨부파일 삭제
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteProposalFile(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 건의요청첨부파일                    \n");
			sQry.append("  SET    삭제여부 = 'Y'                      \n");
			sQry.append("      ,  최종변경일시    = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드         = ?                \n");
			sQry.append("        AND 법인코드      = ?                \n");
			sQry.append("        AND 브랜드코드    = ?                \n");
			sQry.append("        AND 매장코드      = ?                \n");
			sQry.append("        AND 건의요청번호  = ?                \n");
			sQry.append("        AND 건의요청구분  = ?                \n");			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")  );  //매장코드
            pstmt.setString(++i, (String)paramData.get("listNum")         );  //건의요청번호
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //건의요청구분
            
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
     * 공지&교육 댓글 수정
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateComm(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 게시댓글정보                                            \n");
			sQry.append("  SET    내용         = ?                                        \n");
			sQry.append("      ,  최종변경일시 = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드     = ?                                        \n");
			sQry.append("        AND 법인코드  = ?                                        \n");
			sQry.append("        AND 브랜드코드= ?                                        \n");
			sQry.append("        AND 매장코드  = ?                                        \n");
			sQry.append("        AND 게시번호  = ?                                        \n");
			sQry.append("        AND 게시구분  = ?                                        \n");
			sQry.append("        AND 댓글번호  = ?                                        \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("comment")       );  //댓글내용
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
            
            pstmt.setString(++i, (String)paramData.get("listNum")       );  //게시번호
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  //게시구분 
            pstmt.setString(++i, (String)paramData.get("commGb")        );  //댓글번호
            
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
     * 공지&교육 댓글 삭제
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteComm(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 게시댓글정보                      \n");
			sQry.append("  SET    삭제여부 = 'Y'                    \n");	
			sQry.append("      ,  최종변경일시    = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드       = ?                \n");
			sQry.append("        AND 법인코드    = ?                \n");
			sQry.append("        AND 브랜드코드  = ?                \n");
			sQry.append("        AND 매장코드    = ?                \n");
			sQry.append("        AND 게시구분    = ?                \n");
			sQry.append("        AND 게시번호    = ?                \n");
			sQry.append("        AND 댓글번호    = ?                \n");
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")  );  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")         );  //게시번호
            pstmt.setString(++i, (String)paramData.get("commGb")          );  //댓글번호
            
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
     * 건의&요청 댓글 수정
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateProposalComm(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 건의요청댓글정보                                           \n");
			sQry.append("  SET    내용            = ?                                        \n");
			sQry.append("      ,  수정자          = ?                                        \n");
			sQry.append("      ,  수정일자        = to_char(SYSDATE,'YYYY-MM-DD')            \n");
			sQry.append("      ,  최종변경일시    = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드        = ?                                        \n");
			sQry.append("        AND 법인코드     = ?                                        \n");
			sQry.append("        AND 브랜드코드   = ?                                        \n");
			sQry.append("        AND 매장코드     = ?                                        \n");
			sQry.append("        AND 건의요청번호 = ?                                        \n");
			sQry.append("        AND 건의요청구분 = ?                                        \n");
			sQry.append("        AND 댓글번호     = ?                                        \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("comment")       );  //댓글내용
            pstmt.setString(++i, (String)paramData.get("sseCustNm")     );  //수정자
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
            
            pstmt.setString(++i, (String)paramData.get("listNum")       );  //건의요청번호
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  //건의요청구분 
            pstmt.setString(++i, (String)paramData.get("commGb")        );  //댓글번호
            
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
     * 건의&요청 댓글 삭제
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int deleteProposalComm(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 건의요청댓글정보                   \n");
			sQry.append("  SET    삭제여부 = 'Y'                     \n");	
			sQry.append("      ,  최종변경일시    = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE    기업코드     = ?                \n");
			sQry.append("        AND 법인코드     = ?                \n");
			sQry.append("        AND 브랜드코드   = ?                \n");
			sQry.append("        AND 매장코드     = ?                \n");
			sQry.append("        AND 건의요청구분 = ?                \n");
			sQry.append("        AND 건의요청번호 = ?                \n");
			sQry.append("        AND 댓글번호     = ?                \n");
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")  );  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //건의요청구분
            pstmt.setString(++i, (String)paramData.get("listNum")         );  //건의요청번호
            pstmt.setString(++i, (String)paramData.get("commGb")          );  //댓글번호
            
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
     * 공지&교육 게시배포 읽음처리
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateReadNortice(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 게시배포정보                                               \n");
			sQry.append("  SET    확인자          = ?                                        \n");
			sQry.append("      ,  확인여부        = 'Y'                                      \n");
			sQry.append("      ,  확인일자        = to_char(SYSDATE,'YYYY-MM-DD')            \n");
			sQry.append("      ,  최종변경일시    = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드        = ?                                        \n");
			sQry.append("        AND 법인코드     = ?                                        \n");
			sQry.append("        AND 브랜드코드   = ?                                        \n");
			sQry.append("        AND 매장코드     = ?                                        \n");
			sQry.append("        AND 게시구분     = ?                                        \n");
			sQry.append("        AND 게시번호     = ?                                        \n");
			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseCustNm")     );  //확인자
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramData.get("pageGb")        );  //게시구분
            pstmt.setString(++i, (String)paramData.get("listNum")       );  //게시번호

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
	 * 공지&교육 읽음처리 확인여부
	 * @param paramData 
     * @return totalCnt :  
	 * @throws Exception
	 */
    public String selectReadConFirm(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		String cRead = "";
		 
		try 
		{
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT 확인여부                                      \n");
            sQry.append("   FROM 게시배포정보                                  \n");
            sQry.append("  WHERE 기업코드   = ?                                \n");
            sQry.append("    AND 법인코드   = ?                                \n");
            sQry.append("    AND 브랜드코드 = ?                                \n");
            sQry.append("    AND 매장코드   = ?                                \n");
            sQry.append("    AND 게시구분   = ?                                \n");
            sQry.append("    AND 게시번호   = ?                                \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            
            pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramHash.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //게시번호
			
			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) cRead = rs.getString(1);		
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
     * 건의&요청 댓글등록시 요청상태코드를 '1_답변대기'로 변경
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateProposalRequest(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 건의요청등록정보                    \n");
			sQry.append("  SET    요청상태코드     = '1'              \n");
			sQry.append("      ,  수정자           = ?                \n");
			sQry.append("      ,  수정일자         = to_char(SYSDATE,'YYYY-MM-DD')            \n");
			sQry.append("      ,  최종변경일시     = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드         = ?                \n");
			sQry.append("        AND 법인코드      = ?                \n");
			sQry.append("        AND 브랜드코드    = ?                \n");
			sQry.append("        AND 매장코드      = ?                \n");
			sQry.append("        AND 건의요청번호  = ?                \n");
			sQry.append("        AND 건의요청구분  = ?                \n");			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++i, (String)paramData.get("sseCustNm")       );  //등록자
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")  );  //매장코드
            pstmt.setString(++i, (String)paramData.get("listNum")         );  //건의요청번호
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //건의요청구분
            
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
     * 건의&요청 댓글 삭제시 요청상태코드를 '9_답변완료'로 변경
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateProposalStatusDone(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();
			            

			sQry.append("  UPDATE 건의요청등록정보                    \n");
			sQry.append("  SET    요청상태코드     = '9'              \n");
			sQry.append("      ,  수정자           = ?                \n");
			sQry.append("      ,  수정일자         = to_char(SYSDATE,'YYYY-MM-DD')            \n");
			sQry.append("      ,  최종변경일시     = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드         = ?                \n");
			sQry.append("        AND 법인코드      = ?                \n");
			sQry.append("        AND 브랜드코드    = ?                \n");
			sQry.append("        AND 매장코드      = ?                \n");
			sQry.append("        AND 건의요청번호  = ?                \n");
			sQry.append("        AND 건의요청구분  = ?                \n");			
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++i, (String)paramData.get("sseCustNm")       );  //등록자
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")  );  //매장코드
            pstmt.setString(++i, (String)paramData.get("listNum")         );  //건의요청번호
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //건의요청구분
            
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
	 * 건의&요청 상태 확인
	 * @param paramData 
     * @return totalCnt :  
	 * @throws Exception
	 */
    public String selectRequestStatus(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		String cRead = "";
		 
		try 
		{
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT 요청상태코드                                  \n");
            sQry.append("   FROM 건의요청등록정보                              \n");
            sQry.append("  WHERE 기업코드     = ?                              \n");
            sQry.append("    AND 법인코드     = ?                              \n");
            sQry.append("    AND 브랜드코드   = ?                              \n");
            sQry.append("    AND 매장코드     = ?                              \n");
            sQry.append("    AND 건의요청구분 = ?                              \n");
            sQry.append("    AND 건의요청번호 = ?                              \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            
            pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramHash.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //건의요청구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //건의요청번호
			
			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) cRead = rs.getString(1);		
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
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT count(*)                                      \n");
            sQry.append("   FROM 건의요청첨부파일                              \n");
            sQry.append("  WHERE 기업코드     = ?                              \n");
            sQry.append("    AND 법인코드     = ?                              \n");
            sQry.append("    AND 브랜드코드   = ?                              \n");
            sQry.append("    AND 매장코드     = ?                              \n");
            sQry.append("    AND 건의요청구분 = ?                              \n");
            sQry.append("    AND 건의요청번호 = ?                              \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            
            pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramHash.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //건의요청구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //건의요청번호
			
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
	 * 건의&요청 파일다운로드 상세보기
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<listBean> selectRequestDownloadList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
			sQry.append(" SELECT 파일명                                        \n");
			sQry.append("      , 원본파일명                                    \n");
			sQry.append("      , 파일순번                                      \n");
            sQry.append("   FROM 건의요청첨부파일                              \n");
            sQry.append("  WHERE 기업코드     = ?                              \n");
            sQry.append("    AND 법인코드     = ?                              \n");
            sQry.append("    AND 브랜드코드   = ?                              \n");
            sQry.append("    AND 매장코드     = ?                              \n");
            sQry.append("    AND 건의요청구분 = ?                              \n");
            sQry.append("    AND 건의요청번호 = ?                              \n");
            sQry.append("    AND 삭제여부     = 'N'                            \n");
            sQry.append("  ORDER BY 파일순번 ASC                               \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            
            pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramHash.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //건의요청구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //건의요청번호
			
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
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

			sQry.append(" SELECT count(*)                     \n");
            sQry.append("   FROM 건의요청첨부파일             \n");
            sQry.append("  WHERE 기업코드     = ?             \n");
            sQry.append("    AND 법인코드     = ?             \n");
            sQry.append("    AND 브랜드코드   = ?             \n");
            sQry.append("    AND 매장코드     = ?             \n");
            sQry.append("    AND 건의요청구분 = ?             \n");
            sQry.append("    AND 건의요청번호 = ?             \n");
            sQry.append("    AND 파일순번     = ?             \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            
            pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramHash.get("sseCustStoreCd"));  //매장코드
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //건의요청구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //건의요청번호
            pstmt.setString(++i, (String)paramHash.get("fileNum")       );  //파일순번
			
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
     * 건의&요청 파일업로드 업데이트
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
			            

			sQry.append("  UPDATE 건의요청첨부파일                    \n");
			sQry.append("  SET    파일경로         = ?                \n");
			sQry.append("       , 파일명           = ?                \n");
			sQry.append("       , 원본파일명       = ?                \n");
			sQry.append("       , 최종변경일시     = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE 기업코드         = ?                \n");
			sQry.append("        AND 법인코드      = ?                \n");
			sQry.append("        AND 브랜드코드    = ?                \n");
			sQry.append("        AND 매장코드      = ?                \n");
			sQry.append("        AND 건의요청번호  = ?                \n");
			sQry.append("        AND 건의요청구분  = ?                \n");
			sQry.append("        AND 파일순번      = ?                \n");
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("filePath")        );  //파일경로
            pstmt.setString(++i, (String)paramData.get("fileName")        );  //파일명
            pstmt.setString(++i, (String)paramData.get("orgFileName")     );  //원본파일명
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")  );  //매장코드
            pstmt.setString(++i, (String)paramData.get("listNum")         );  //건의요청번호
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //건의요청구분
            pstmt.setString(++i, (String)paramData.get("fileNum")         );  //파일순번
            
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
	 * 건의&요청 매장명 가져오기
	 * @param paramData 
     * @return totalCnt :  
	 * @throws Exception
	 */
    public String selectRequestStoreName(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		String cRead = "";
		 
		try 
		{
			
			String srch_key = JSPUtil.chkNull((String)paramHash.get("srch_key"));			
			srch_key = (srch_key=="") ? "%" : "%"+srch_key+"%";
			
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			sQry.append(" SELECT B.매장명                        \n");
			sQry.append("   FROM                                 \n");
			sQry.append("       (                                \n");
			sQry.append("        SELECT A.*                      \n");
            sQry.append("          FROM 건의요청등록정보 A       \n");
            sQry.append("         WHERE A.건의요청구분 = ?       \n");
            sQry.append("           AND A.건의요청번호 = ?       \n");
            sQry.append("           AND A.기업코드     = ?       \n");
			sQry.append("           AND A.법인코드     = ?       \n");
			sQry.append("           AND A.브랜드코드   = ?       \n");
			sQry.append("           AND A.삭제여부     = 'N'     \n");
			sQry.append("       ) A                              \n");
			sQry.append("    , 매장 B                            \n");
            sQry.append(" WHERE   A.기업코드   = B.기업코드      \n");
			sQry.append(" AND     A.법인코드   = B.법인코드      \n");
			sQry.append(" AND     A.브랜드코드 = B.브랜드코드    \n");
            sQry.append(" AND     A.매장코드   = B.매장코드      \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //건의요청구분(게시구분)
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //건의요청번호(게시번호)
            pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
			
			rs = pstmt.executeQuery();
			
			System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			if(rs != null && rs.next()) cRead = rs.getString(1);		
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
     * 건의&요청 파일업로드 삭제
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
			            

			sQry.append("  UPDATE 건의요청첨부파일                                            \n");
			sQry.append("  SET    삭제여부         = 'Y'                                      \n");
			sQry.append("       , 최종변경일시     = to_char(SYSDATE,'YYYY-MM-DD hh24:mi:ss') \n");
			sQry.append("   WHERE    기업코드      = ?                                        \n");
			sQry.append("        AND 법인코드      = ?                                        \n");
			sQry.append("        AND 브랜드코드    = ?                                        \n");
			sQry.append("        AND 매장코드      = ?                                        \n");
			sQry.append("        AND 건의요청번호  = ?                                        \n");
			sQry.append("        AND 건의요청구분  = ?                                        \n");
			sQry.append("        AND 파일순번      = ?                                        \n");
						
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, (String)paramData.get("sseGroupCd")      );  //기업코드
            pstmt.setString(++i, (String)paramData.get("sseCorpCd")       );  //법인코드
            pstmt.setString(++i, (String)paramData.get("sseBrandCd")      );  //브랜드코드
            pstmt.setString(++i, (String)paramData.get("sseCustStoreCd")  );  //매장코드
            pstmt.setString(++i, (String)paramData.get("listNum")         );  //건의요청번호
            pstmt.setString(++i, (String)paramData.get("pageGb")          );  //건의요청구분
            pstmt.setString(++i, (String)paramData.get("fileNum")         );  //파일순번
            
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
	 * 공지&교육 다운로드 파일명
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

			sQry.append(" SELECT count(*)                                      \n");
            sQry.append("   FROM 게시첨부파일  A                               \n");
            sQry.append("  WHERE 1=1                              			   \n");
          //sQry.append("    AND 기업코드     = ?                              \n");
          //sQry.append("    AND 법인코드     = ?                              \n");
          //sQry.append("    AND 브랜드코드   = ?                              \n");
            sQry.append("    AND A.게시구분   = ?                              \n");
            sQry.append("    AND A.게시번호   = ?                              \n");
            sQry.append("    AND EXISTS (SELECT 1 FROM 게시배포정보  B         \n");
            sQry.append("                 WHERE B.기업코드     = ?             \n");
            sQry.append("                   AND B.법인코드     = ?             \n");
            sQry.append("                   AND B.브랜드코드   = ?             \n");
            sQry.append("                   AND B.게시구분     = ?             \n");
            sQry.append("                   AND B.게시번호     = ?             \n");
            sQry.append("                   AND B.매장코드     = ?             \n");
            sQry.append("                   AND B.게시구분   = A.게시구분      \n");
            sQry.append("                   AND B.게시번호   = A.게시번호  	)  \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //게시번호
            pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //게시번호
            pstmt.setString(++i, (String)paramHash.get("sseCustStoreCd"));  //매장코드
			
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
	 * 공지&교육 파일다운로드 상세보기
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<listBean> selectNoticeDownloadList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<listBean> list = new ArrayList<listBean>();
		
		try
		{ 
			
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
			sQry.append(" SELECT 파일명                                        \n");
			sQry.append("      , 원본파일명                                    \n");
			sQry.append("      , 파일순번                                      \n");
            sQry.append("   FROM 게시첨부파일  A                               \n");
            sQry.append("  WHERE 1=1			                               \n");
          //sQry.append("  WHERE 기업코드     = ?                              \n");
          //sQry.append("    AND 법인코드     = ?                              \n");
          //sQry.append("    AND 브랜드코드   = ?                              \n");
            sQry.append("    AND A.게시구분   = ?                              \n");
            sQry.append("    AND A.게시번호   = ?                              \n");
            sQry.append("    AND A.삭제여부   = 'N'                            \n");
            sQry.append("    AND EXISTS (SELECT 1 FROM 게시배포정보  B         \n");
            sQry.append("                 WHERE B.기업코드     = ?             \n");
            sQry.append("                   AND B.법인코드     = ?             \n");
            sQry.append("                   AND B.브랜드코드   = ?             \n");
            sQry.append("                   AND B.게시구분     = ?             \n");
            sQry.append("                   AND B.게시번호     = ?             \n");
            sQry.append("                   AND B.매장코드     = ?             \n");
            sQry.append("                   AND B.게시구분   = A.게시구분      \n");
            sQry.append("                   AND B.게시번호   = A.게시번호  	)  \n");
            sQry.append("  ORDER BY 파일순번 ASC                               \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //게시번호
            pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramHash.get("pageGb")        );  //게시구분
            pstmt.setString(++i, (String)paramHash.get("listNum")       );  //게시번호
            pstmt.setString(++i, (String)paramHash.get("sseCustStoreCd"));  //매장코드
			
			rs = pstmt.executeQuery();
			
            // make databean list
			listBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new listBean(); 
                
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
	 * 건의&요청 다운로드 파일명
	 * @param paramData 
     * @return totalCnt :  전체레코드수를 int형에 담아 리턴합니다.
	 * @throws Exception
	 */
    public Integer selectProposalDownloadCnt(HashMap paramHash) throws Exception 
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
            sQry.append("   FROM 건의요청첨부파일                              \n");
            sQry.append("  WHERE 기업코드     = ?                              \n");
            sQry.append("    AND 법인코드     = ?                              \n");
            sQry.append("    AND 브랜드코드   = ?                              \n");
            sQry.append("    AND 매장코드     = ?                              \n");
            sQry.append("    AND 건의요청구분 = ?                              \n");
            sQry.append("    AND 건의요청번호 = ?                              \n");
            
            pstmt = new LoggableStatement(con, sQry.toString());
			
            int i = 0;
            
            pstmt.setString(++i, (String)paramHash.get("sseGroupCd")    );  //기업코드
            pstmt.setString(++i, (String)paramHash.get("sseCorpCd")     );  //법인코드
            pstmt.setString(++i, (String)paramHash.get("sseBrandCd")    );  //브랜드코드
            pstmt.setString(++i, (String)paramHash.get("sseCustStoreCd"));  //매장코드
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
	
}