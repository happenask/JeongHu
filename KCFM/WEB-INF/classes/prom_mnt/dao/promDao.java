/** ############################################################### */
/** Program ID   : promDao.java                                     */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package prom_mnt.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import prom_mnt.beans.promBean;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;

public class promDao 
{
	
	/**
	 * 홍보물 메뉴정보 조회
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<promBean> selectPromList(String groupCd, String corpCd, String brandCd ) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<promBean> list = new ArrayList<promBean>();
		
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
            sQry.append("     AND 기업코드   = ?                   \n");
            sQry.append("     AND 법인코드   = ?                   \n");
            sQry.append("     AND 브랜드코드 = ?                   \n");
            sQry.append(" )                                        \n");
            sQry.append(" ORDER BY 기업코드,법인코드,브랜드코드, 메뉴코드, 메뉴순서  \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++p, groupCd);
            pstmt.setString(++p, corpCd);
            pstmt.setString(++p, brandCd);
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			promBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new promBean(); 
                
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
	 public ArrayList<promBean> selectPromMiddleList(String companyCd, String corpcd, String brandCd, String menuCd) throws DAOException
		{
			
			Connection con          = null;
			PreparedStatement pstmt = null;
			ResultSet rs            = null;
			
			ArrayList<promBean> list = new ArrayList<promBean>();
			
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
	            sQry.append("    AND 기업코드     = ?                                                                                                                                                   \n");
	            sQry.append("    AND 법인코드     = ?                                                                                                                                                   \n");
	            sQry.append("    AND 브랜드코드   = ?                                                                                                                                                   \n");
	            sQry.append("    AND 상위메뉴코드 = ?                                                                                                                                                   \n");
	            sQry.append("    ORDER BY 메뉴순서                                                                                                                                                      \n");
	            
	            // set preparedstatemen
	            int p=0;
	            
	            pstmt = new LoggableStatement(con, sQry.toString());
	            pstmt.setString(++p, companyCd );
	            pstmt.setString(++p, corpcd    );
	            pstmt.setString(++p, brandCd   );
	            pstmt.setString(++p, menuCd    );
	            
//	            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
				
				rs = pstmt.executeQuery();
				
	            // make databean list
				promBean dataBean = null;
	            
	            while( rs.next() )
	            {
	                dataBean = new promBean(); 
	                
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
	  * 홍보물 대분류코드 등록
	  * @param paramData
	  * @return
	  * @throws DAOException
	  */
	 public int addLargeCd(HashMap<String, String> paramData) throws DAOException
		{
			Connection con           = null;
			PreparedStatement pstmt  = null;
			
			int list = 0;
			
			try
			{
				con = DBConnect.getInstance().getConnection();
				
				StringBuffer sQry = new StringBuffer();
				            

				sQry.append("  INSERT INTO 홍보물메뉴정보                                                  \n");
				sQry.append("  (                                                                           \n");
				sQry.append("       기업코드                                                               \n");
				sQry.append("      ,법인코드                                                               \n");
				sQry.append("      ,브랜드코드                                                             \n");
				sQry.append("      ,메뉴코드                                                               \n");
				sQry.append("      ,메뉴코드명                                                             \n");
				sQry.append("      ,메뉴URL                                                                \n");
				sQry.append("      ,메뉴레벨                                                               \n");
				sQry.append("      ,메뉴유형                                                               \n");
				sQry.append("      ,상위메뉴코드                                                           \n");
				sQry.append("      ,메뉴순서                                                               \n");
				sQry.append("      ,사용여부                                                               \n");
				sQry.append("      ,등록자                                                                 \n");
				sQry.append("      ,등록일자                                                               \n");
				sQry.append("      ,예비문자                                                               \n");
				sQry.append("      ,예비숫자                                                               \n");
				sQry.append("      ,최종변경일시                                                           \n");
				sQry.append("  ) VALUES(                                                                   \n");
				sQry.append("       ?    --기업코드                                                        \n");
				sQry.append("      ,?    --법인코드                                                        \n");
				sQry.append("      ,?    --브랜드코드                                                      \n");
				sQry.append("      ,?    --메뉴코드                                                        \n");
				sQry.append("      ,?    --메뉴코드명                                                      \n");
				sQry.append("      ,NULL --메뉴URL                                                         \n");
				sQry.append("      ,1    --메뉴레벨                                                        \n");
				sQry.append("      ,'FOLDER' --메뉴유형                                                    \n");
				sQry.append("      ,'NA'     --상위메뉴코드                                                \n");
				sQry.append("      ,(SELECT MAX(메뉴순서)+1 FROM 홍보물메뉴정보 ) --메뉴순서               \n");
				sQry.append("      ,'Y'     --사용여부                                                     \n");
				sQry.append("      ,?       --등록자                                                       \n");
				sQry.append("      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD') --등록일자                              \n");
				sQry.append("      ,NULL    --예비문자                                                     \n");
				sQry.append("      ,0       --예비숫자                                                     \n");
				sQry.append("      ,SYSDATE --최종변경일시                                                 \n");
				sQry.append("  )                                                                           \n");
				
							
	            int i = 0;
	            
	            pstmt = new LoggableStatement(con, sQry.toString());
	            
	            pstmt.setString(++i, (String)paramData.get("groupCd")); //기업코드
	            pstmt.setString(++i, (String)paramData.get("corpCd"));  //법인코드
	            pstmt.setString(++i, (String)paramData.get("brandCd")); //브랜드코드
	            pstmt.setString(++i, (String)paramData.get("menuCd"));  //메뉴코드
	            pstmt.setString(++i, (String)paramData.get("menuNm"));  //메뉴명
	            pstmt.setString(++i, (String)paramData.get("custId"));  //등록자명
	            
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
	  * 홍보물 중분류코드 저장
	  * @param paramData
	  * @return
	  * @throws DAOException
	  */
	 public int addMiddleCd(HashMap<String, String> paramData) throws DAOException
		{
			Connection con           = null;
			PreparedStatement pstmt  = null;
			
			int list = 0;
			
			try
			{
				con = DBConnect.getInstance().getConnection();
				
				StringBuffer sQry = new StringBuffer();
				            

				sQry.append("  MERGE INTO 홍보물메뉴정보 A                                             \n");
				sQry.append("  USING (                                                                 \n");
				sQry.append("                 SELECT ? AS 기업코드                                     \n");
				sQry.append("                      , ? AS 법인코드                                     \n");
				sQry.append("                      , ? AS 브랜드코드                                   \n");
				sQry.append("                      , ? AS 메뉴코드                                     \n");
				sQry.append("                      , ? AS 메뉴코드명                                   \n");
				sQry.append("                   FROM DUAL                                              \n");
				sQry.append("        ) B                                                               \n");
				sQry.append("     ON (    A.기업코드   = B.기업코드                                    \n");
				sQry.append("         AND A.법인코드   = B.법인코드                                    \n");
				sQry.append("         AND A.브랜드코드 = B.브랜드코드                                  \n");
				sQry.append("         AND A.메뉴코드   = B.메뉴코드                                    \n");
				sQry.append("        )                                                                 \n");
				sQry.append("     WHEN MATCHED THEN UPDATE SET A.메뉴코드명 = B.메뉴코드명             \n");
				sQry.append("     WHEN NOT MATCHED THEN                                                \n");
				sQry.append("     INSERT                                                               \n");
				sQry.append("     (                                                                    \n");
				sQry.append("         A.기업코드                                                       \n");
				sQry.append("        ,A.법인코드                                                       \n");
				sQry.append("        ,A.브랜드코드                                                     \n");
				sQry.append("        ,A.메뉴코드                                                       \n");
				sQry.append("        ,A.메뉴코드명                                                     \n");
				sQry.append("        ,A.메뉴URL                                                        \n");
				sQry.append("        ,A.메뉴레벨                                                       \n");
				sQry.append("        ,A.메뉴유형                                                       \n");
				sQry.append("        ,A.상위메뉴코드                                                   \n");
				sQry.append("        ,A.메뉴순서                                                       \n");
				sQry.append("        ,A.사용여부                                                       \n");
				sQry.append("        ,A.등록자                                                         \n");
				sQry.append("        ,A.등록일자                                                       \n");
				sQry.append("        ,A.예비문자                                                       \n");
				sQry.append("        ,A.예비숫자                                                       \n");
				sQry.append("        ,A.최종변경일시                                                   \n");
				sQry.append("    ) VALUES(                                                             \n");
				sQry.append("         ?    --기업코드                                                  \n");
				sQry.append("        ,?    --법인코드                                                  \n");
				sQry.append("        ,?    --브랜드코드                                                \n");
				sQry.append("        ,?    --메뉴코드                                                  \n");
				sQry.append("        ,?    --메뉴코드명                                                \n");
				sQry.append("        ,NULL --메뉴URL                                                   \n");
				sQry.append("        ,2    --메뉴레벨                                                  \n");
				sQry.append("        ,'FILE' --메뉴유형                                                \n");
				sQry.append("        ,?     --상위메뉴코드                                             \n");
				sQry.append("        ,(SELECT MAX(메뉴순서)+1 FROM 홍보물메뉴정보 ) --메뉴순서         \n");
				sQry.append("        ,'Y'     --사용여부                                               \n");
				sQry.append("        ,?       --등록자                                                 \n");
				sQry.append("        ,TO_CHAR(SYSDATE, 'YYYY-MM-DD') --등록일자                        \n");
				sQry.append("        ,NULL        --예비문자                                           \n");
				sQry.append("        ,0       --예비숫자                                               \n");
				sQry.append("        ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') --최종변경일시         \n");
				sQry.append("    )                                                                     \n");
				
							
	            int i = 0;
	            
	            pstmt = new LoggableStatement(con, sQry.toString());
	            
	            pstmt.setString(++i, (String)paramData.get("groupCd")); //기업코드
	            pstmt.setString(++i, (String)paramData.get("corpCd"));  //법인코드
	            pstmt.setString(++i, (String)paramData.get("brandCd")); //브랜드코드
	            pstmt.setString(++i, (String)paramData.get("menuCd"));  //메뉴코드
	            pstmt.setString(++i, (String)paramData.get("menuNm"));  //메뉴코드명
	            
	            
	            pstmt.setString(++i, (String)paramData.get("groupCd")); //기업코드
	            pstmt.setString(++i, (String)paramData.get("corpCd"));  //법인코드
	            pstmt.setString(++i, (String)paramData.get("brandCd")); //브랜드코드
	            pstmt.setString(++i, (String)paramData.get("menuCd"));  //메뉴코드
	            pstmt.setString(++i, (String)paramData.get("menuNm"));  //메뉴코드명
	            pstmt.setString(++i, (String)paramData.get("parentCd"));//상위코드명
	            pstmt.setString(++i, (String)paramData.get("custId"));  //등록자명
	            
//	            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
	            
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
	  * 홍보물 중분류코드 삭제
	  * @param paramData
	  * @return
	  * @throws DAOException
	  */
	 public int delMiddleCd(HashMap paramData) throws DAOException
		{
			Connection con           = null;
			PreparedStatement pstmt  = null;
			
			
			int list = 0;
			
			try
			{
				con = DBConnect.getInstance().getConnection();
				
				StringBuffer sQry = new StringBuffer();
				            

				sQry.append("  DELETE 홍보물메뉴정보                  \n");
				sQry.append("   WHERE 기업코드   = ?                  \n");
				sQry.append("     AND 법인코드   = ?                  \n");
				sQry.append("     AND 브랜드코드 = ?                  \n");
				sQry.append("     AND 메뉴코드   = ?                  \n");
							
	            int i = 0;
	            
	            pstmt = new LoggableStatement(con, sQry.toString());
	            
	            pstmt.setString(++i, (String)paramData.get("groupCd")); //기업코드
	            pstmt.setString(++i, (String)paramData.get("corpCd"));  //법인코드
	            pstmt.setString(++i, (String)paramData.get("brandCd")); //브랜드코드
	            pstmt.setString(++i, (String)paramData.get("menuCd"));  //메뉴코드
	            
//	            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
	            
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
	  * 법인 조회
	  * @param groupCd
	  * @param sseCustAuth
	  * @return
	  * @throws DAOException
	  */
	 public ArrayList<promBean> selectCorpCd(String groupCd, String sseCustAuth) throws DAOException
		{
			
			Connection con          = null;
			PreparedStatement pstmt = null;
			ResultSet rs            = null;
			
			ArrayList<promBean> list = new ArrayList<promBean>();
			
			
			try
			{ 
				con = DBConnect.getInstance().getConnection();
				
	            StringBuffer sQry = new StringBuffer();
	  
	            sQry.append(" SELECT 법인코드                \n");
	            sQry.append("      , 법인명                  \n");
	            sQry.append("      , 기업코드                \n");
	            sQry.append("   FROM 법인                    \n");
	            sQry.append("  WHERE 1=1                     \n");
	           	
	            if(!"90".equals(sseCustAuth)){ //슈퍼유저는 전체 검색
	            sQry.append("  	 AND 기업코드 = '"+ groupCd +"'            \n");
	            }
	            
	            sQry.append("    AND 사용여부 = 'Y'          \n");
	            sQry.append("    AND 삭제여부 = 'N'          \n");
	            sQry.append("    ORDER BY 법인명             \n");
	            
	            // set preparedstatemen
//	            int p=0;
	            
	            pstmt = new LoggableStatement(con, sQry.toString());
	            
//	            pstmt.setString(++p, groupCd);
//	            pstmt.setString(++p, corpCd);
	            
//		            System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
				
				rs = pstmt.executeQuery();
				
	            // make databean list
				promBean dataBean = null;
	            
	            while( rs.next() )
	            {
	                dataBean = new promBean(); 
	                
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
	  * 기업,법인코드로 브랜드 코드 조회
	  * @param paramHash
	  * @return
	  * @throws DAOException
	  */
	public ArrayList<promBean> selectBrandCd(String groupCd, String corpCd, String sseCustAuth) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<promBean> list = new ArrayList<promBean>();
		
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append(" SELECT 브랜드코드              \n");
            sQry.append("      , 브랜드명                \n");
            sQry.append("   FROM 브랜드                  \n");
            sQry.append("  WHERE 1 = 1                   \n");
           // if(!"90".equals(sseCustAuth)){ //슈퍼유저는 전체 검색
            sQry.append("  	 AND 기업코드 = '"+ groupCd +"'            \n");
            //}

            sQry.append("    AND 법인코드 = ?            \n");
            sQry.append("    AND 사용여부 = 'Y'          \n");
            sQry.append("    AND 삭제여부 = 'N'          \n");
            sQry.append("    ORDER  BY 브랜드명          \n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
//            pstmt.setString(++p, groupCd);
            pstmt.setString(++p, corpCd);
            
//	        System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			promBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new promBean(); 
                
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

}