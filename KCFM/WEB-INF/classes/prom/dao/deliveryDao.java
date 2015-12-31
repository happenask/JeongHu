/** ############################################################### */
/** Program ID   : deliveryDao.java                                 */
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

import prom.beans.deliveryBean;

import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;
import com.util.JSPUtil;

public class deliveryDao 
{
	
	/**
	 * 배송지정보 조회 (기본배송지)
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public deliveryBean selectDefaultAddr(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		deliveryBean dataBean = null;
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT *					\n");
            sQry.append("  FROM 홍보물배송지정보		\n");
            sQry.append(" WHERE 기업코드 = ?			\n");
            sQry.append("   AND 법인코드 = ?			\n");
            sQry.append("   AND 브랜드코드 = ?		\n");
            sQry.append("   AND 매장코드 = ?			\n");
            sQry.append("   AND 배송지번호 = 0		\n");
            sQry.append("   AND 삭제여부 = 'N'		\n");
            sQry.append(" ORDER BY 배송지번호 DESC	\n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("매장코드"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            while( rs.next() )
            {
                dataBean = new deliveryBean(); 
                
                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set매장코드((String)rs.getString("매장코드"));
                dataBean.set배송지번호((String)rs.getString("배송지번호"));
                dataBean.set우편번호((String)rs.getString("우편번호"));
                dataBean.set우편주소((String)rs.getString("우편주소"));
                dataBean.set상세주소((String)rs.getString("상세주소"));
                dataBean.set수취인이름((String)rs.getString("수취인이름"));
                dataBean.set수취인전화번호((String)rs.getString("수취인전화번호"));
                dataBean.set수취인휴대전화번호((String)rs.getString("수취인휴대전화번호"));
                dataBean.set배송시요청사항((String)rs.getString("배송시요청사항"));
                
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
	 * 배송지정보 조회 (최근 배송지)
	 * @param 
	 * @return
	 * @throws DAOException
	 */
	public ArrayList<deliveryBean> selectList(HashMap paramHash) throws DAOException
	{
		
		Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		ArrayList<deliveryBean> list = new ArrayList<deliveryBean>();
		
		try
		{ 
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
			sQry.append("SELECT *															\n");
            sQry.append("  FROM (															\n");
            sQry.append("        SELECT ROW_NUMBER() OVER (ORDER BY A.배송지번호 DESC) AS RN	\n");
            sQry.append("             , A.*													\n");
            sQry.append("          FROM 홍보물배송지정보 A										\n");
            sQry.append("         WHERE 기업코드 = ?											\n");
            sQry.append("           AND 법인코드 = ?											\n");
            sQry.append("           AND 브랜드코드 = ?										\n");
            sQry.append("           AND 매장코드 = ?											\n");
            sQry.append("           AND 배송지번호 > 0										\n");
            sQry.append("           AND 삭제여부 = 'N'										\n");
            sQry.append("       )															\n");
            sQry.append(" WHERE RN <= 5														\n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("매장코드"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
			
			rs = pstmt.executeQuery();
			
            // make databean list
			deliveryBean dataBean = null;
            
            while( rs.next() )
            {
                dataBean = new deliveryBean(); 
                
                dataBean.set기업코드((String)rs.getString("기업코드"));
                dataBean.set법인코드((String)rs.getString("법인코드"));
                dataBean.set브랜드코드((String)rs.getString("브랜드코드"));
                dataBean.set매장코드((String)rs.getString("매장코드"));
                dataBean.set배송지번호((String)rs.getString("배송지번호"));
                dataBean.set우편번호((String)rs.getString("우편번호"));
                dataBean.set우편주소((String)rs.getString("우편주소"));
                dataBean.set상세주소((String)rs.getString("상세주소"));
                dataBean.set수취인이름((String)rs.getString("수취인이름"));
                dataBean.set수취인전화번호((String)rs.getString("수취인전화번호"));
                dataBean.set수취인휴대전화번호((String)rs.getString("수취인휴대전화번호"));
                dataBean.set배송시요청사항((String)rs.getString("배송시요청사항"));
                
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
	 * 배송지 번호 채번
	 * @param  
     * @return
	 * @throws Exception
	 */
    public String selectAddrSeq(HashMap paramHash) throws Exception 
    {
    	
    	Connection con          = null;
		PreparedStatement pstmt = null;
		ResultSet rs            = null;
		
		String addrSeq = "";
		 
		try 
		{
			con = DBConnect.getInstance().getConnection();
			
            StringBuffer sQry = new StringBuffer();
  
            sQry.append("SELECT FNC_SEQ_NO('홍보물배송지정보', ? , ? , ? , ? )       	\n"); 
            sQry.append("  FROM DUAL													\n");
            
            // set preparedstatemen
            int p=0;
            
            pstmt = new LoggableStatement(con, sQry.toString());

            pstmt.setString(++p, (String)paramHash.get("기업코드"));
            pstmt.setString(++p, (String)paramHash.get("법인코드"));
            pstmt.setString(++p, (String)paramHash.get("브랜드코드"));
            pstmt.setString(++p, (String)paramHash.get("매장코드"));
            
            //System.out.println("SQL String : \n" + ((LoggableStatement)pstmt).getQueryString()  );
            
			rs = pstmt.executeQuery();
			 
			if(rs != null && rs.next()) addrSeq = rs.getString(1);		
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
		
		return addrSeq;
		
    }
    
    /**
	 * 배송지정보 등록 (새로운 배송지) 
	 * @param paramData
	 * @return
	 * @throws DAOException
	 */
	 public int insertNewAddr(HashMap paramData) throws DAOException
	 {
		 	Connection con           = null;
			PreparedStatement pstmt  = null;
			
			int iRet = 0;
			
			try
			{
				String 배송요청사항 = URLDecoder.decode(JSPUtil.chkNull((String)paramData.get("배송요청사항")), "UTF-8");
				
				con = DBConnect.getInstance().getConnection();
				
				StringBuffer sQry = new StringBuffer();

				sQry.append("INSERT INTO 홍보물배송지정보				\n");
				sQry.append("( 기업코드									\n");
				sQry.append(", 법인코드									\n");
				sQry.append(", 브랜드코드								\n");
				sQry.append(", 매장코드									\n");
				sQry.append(", 배송지번호								\n");
				sQry.append(", 우편번호									\n");
				sQry.append(", 우편주소									\n");
				sQry.append(", 상세주소									\n");
				sQry.append(", 수취인이름								\n");
				sQry.append(", 수취인전화번호							\n");
				sQry.append(", 수취인휴대전화번호						\n");
				sQry.append(", 배송시요청사항							\n");
				sQry.append(", 등록자									\n");
				sQry.append(", 등록일자									\n");
				sQry.append(", 삭제여부									\n");
				sQry.append(", 예비문자									\n");
				sQry.append(", 예비숫자									\n");
				sQry.append(", 최종변경일시								\n");
				sQry.append(") VALUES (									\n");
				sQry.append("  ?										\n"); //01.기업코드
				sQry.append(", ?										\n"); //02.법인코드
				sQry.append(", ?										\n"); //03.브랜드코드
				sQry.append(", ?										\n"); //04.매장코드
				sQry.append(" ,? 										\n"); //05.배송지번호
				sQry.append(", ?										\n"); //06.우편번호
				sQry.append(", ?										\n"); //07.우편주소
				sQry.append(", ?										\n"); //08.상세주소
				sQry.append(", ?										\n"); //09.수취인이름
				sQry.append(", ?										\n"); //10.수취인전화번호
				sQry.append(", ?										\n"); //11.수취인휴대전화번호
				sQry.append(", ?										\n"); //12.배송시요청사항
				sQry.append(", ?										\n"); //13.등록자
				sQry.append(", TO_CHAR(SYSDATE, 'YYYYMMDD')				\n"); //14.등록일자
				sQry.append(", 'N'										\n"); //15.삭제여부
				sQry.append(", ''										\n"); //16.예비문자
				sQry.append(", 0										\n"); //17.예비숫자
				sQry.append(", TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')\n"); //18.최종변경일시
				sQry.append(")											\n");
				
				System.out.println("paramData String : \n" +  (String)paramData.toString()  );
		           			
	            int p = 0;
	            
	            pstmt = new LoggableStatement(con, sQry.toString());
	            
	            pstmt.setString(++p, (String)paramData.get("기업코드")); 
	            pstmt.setString(++p, (String)paramData.get("법인코드")); 
	            pstmt.setString(++p, (String)paramData.get("브랜드코드")); 
	            pstmt.setString(++p, (String)paramData.get("매장코드"));
	            pstmt.setString(++p, (String)paramData.get("배송지번호")); 
	            pstmt.setString(++p, (String)paramData.get("우편번호")); 
	            pstmt.setString(++p, (String)paramData.get("우편주소")); 
	            pstmt.setString(++p, (String)paramData.get("상세주소")); 
	            pstmt.setString(++p, (String)paramData.get("수취인이름")); 
	            pstmt.setString(++p, (String)paramData.get("수취인전화번호")); 
	            pstmt.setString(++p, (String)paramData.get("수취인휴대전화번호")); 
	            pstmt.setString(++p, 배송요청사항);
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

}