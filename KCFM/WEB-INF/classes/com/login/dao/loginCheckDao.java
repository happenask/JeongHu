/** ############################################################### */
/** Program ID   : loginCheckDao.java                               */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.login.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;

import com.login.beans.loginCheckBean;
import com.db.DBConnMng;
import com.db.DBConnect;
import com.db.LoggableStatement;
import com.exception.DAOException;
import com.util.JSPUtil;



public class loginCheckDao 
{
	
	//
	public String checkUserLogin(HttpServletRequest request,String userId, String password, String chkAuth) throws DAOException
	{
		
		String loginStatus = "";
		
		SqlSession dao = new DBConnMng().getSqlSession();
		
		ArrayList user = null;
		
		
		
		HashMap paramHash = new HashMap();
		
		
		paramHash.put("txtUserID", userId);
		paramHash.put("txtPwd", password);
		
		
		
		user = (ArrayList)dao.selectList("login.user_check", paramHash); //로그인 체킹
		
		
		System.out.println("사용자 갯수 - " + user.size());
		
		
		if ( "10".equals(chkAuth) ) // 매장에서 로그인시
		{
			if(user.size() > 0)
			{
				loginStatus ="Y";
				
				HashMap s = new HashMap();
				
				System.out.println("사용자 처리...");
				
				try
				{
					s = (HashMap)user.get(0);
					
					HttpSession session = request.getSession();
					
					HashMap<String,String> userInfo = new HashMap<String,String>();
					
					
					userInfo.put("user_id"        , s.get("사용자ID"        ).toString());
					userInfo.put("user_nm"        , s.get("사용자명"        ).toString());
					userInfo.put("role_cd"        , s.get("권한코드"        ).toString());
					userInfo.put("role_nm"        , s.get("권한명"          ).toString());
					userInfo.put("group_cd"       , s.get("기업코드"        ).toString());
					userInfo.put("group_nm"       , s.get("기업명"          ).toString());
					userInfo.put("corp_cd"        , s.get("법인코드"        ).toString());
					userInfo.put("corp_nm"        , s.get("법인명"          ).toString());
					userInfo.put("user_brand_cd"  , s.get("소속브랜드코드"  ).toString());
					userInfo.put("user_brand_nm"  , s.get("소속브랜드명"    ).toString());
					userInfo.put("biz_dept_cd"    , s.get("소속사업부코드"  ).toString());
					userInfo.put("biz_dept_nm"    , s.get("소속사업부명"    ).toString());
					userInfo.put("base_log_gbn_cd", s.get("소속거점구분코드").toString());
					userInfo.put("base_log_gbn_nm", s.get("소속거점구분명"  ).toString());
					userInfo.put("base_log_cd"    , s.get("소속거점코드"    ).toString());
					userInfo.put("base_log_nm"    , s.get("소속거점명"      ).toString());
					userInfo.put("dept_nm"        , s.get("소속부서"        ).toString());
					userInfo.put("duty_nm"        , s.get("직책"            ).toString());				
	                userInfo.put("user_dist_cd"   , s.get("소속물류센터코드").toString());
	                userInfo.put("user_dist_nm"   , s.get("소속물류센터명"  ).toString());
	                userInfo.put("user_branch_cd" , s.get("소속지사코드"    ).toString());
	                userInfo.put("user_branch_nm" , s.get("소속지사명"      ).toString());
	                userInfo.put("user_chain_cd"  , s.get("소속가맹점코드"  ).toString());
	                userInfo.put("user_chian_nm"  , s.get("소속가맹점명"    ).toString());
	                userInfo.put("user_chain_nm"  , s.get("소속가맹점명"    ).toString());
	                userInfo.put("subul_close_yyyymm", s.get("수불마감년월"    ).toString());
	                userInfo.put("misu_close_yyyymm" , s.get("미수마감년월"    ).toString());

	                System.out.println("사용자ID         userInfo.get(\"user_id\"           ) ["+userInfo.get("user_id"        )+"]");
	                System.out.println("사용자명         userInfo.get(\"user_nm\"           ) ["+userInfo.get("user_nm"        )+"]");
	                System.out.println("권한코드         userInfo.get(\"role_cd\"           ) ["+userInfo.get("role_cd"        )+"]");
	                System.out.println("권한명           userInfo.get(\"role_nm\"           ) ["+userInfo.get("role_nm"        )+"]");
	                System.out.println("기업코드         userInfo.get(\"group_cd\"          ) ["+userInfo.get("group_cd"       )+"]");
	                System.out.println("기업명           userInfo.get(\"group_nm\"          ) ["+userInfo.get("group_nm"       )+"]");
	                System.out.println("법인코드         userInfo.get(\"corp_cd\"           ) ["+userInfo.get("corp_cd"        )+"]");
	                System.out.println("법인명           userInfo.get(\"corp_nm\"           ) ["+userInfo.get("corp_nm"        )+"]");
	                System.out.println("소속브랜드코드   userInfo.get(\"user_brand_cd\"     ) ["+userInfo.get("user_brand_cd"  )+"]");
	                System.out.println("소속브랜드명     userInfo.get(\"user_brand_nm\"     ) ["+userInfo.get("user_brand_nm"  )+"]");
	                System.out.println("소속사업부코드   userInfo.get(\"biz_dept_cd\"       ) ["+userInfo.get("biz_dept_cd"    )+"]");
	                System.out.println("소속사업부명     userInfo.get(\"biz_dept_nm\"       ) ["+userInfo.get("biz_dept_nm"    )+"]");
	                System.out.println("소속거점구분코드 userInfo.get(\"base_log_gbn_cd\"   ) ["+userInfo.get("base_log_gbn_cd")+"]");
	                System.out.println("소속거점구분명   userInfo.get(\"base_log_gbn_nm\"   ) ["+userInfo.get("base_log_gbn_nm")+"]");
	                System.out.println("소속거점코드     userInfo.get(\"base_log_cd\"       ) ["+userInfo.get("base_log_cd"    )+"]");
	                System.out.println("소속거점명       userInfo.get(\"base_log_nm\"       ) ["+userInfo.get("base_log_nm"    )+"]");
	                System.out.println("소속부서         userInfo.get(\"dept_nm\"           ) ["+userInfo.get("dept_nm"        )+"]");
	                System.out.println("직책             userInfo.get(\"duty_nm\"           ) ["+userInfo.get("duty_nm"        )+"]");
	                System.out.println("소속물류센터코드 userInfo.get(\"user_dist_cd\"      ) ["+userInfo.get("user_dist_cd"   )+"]");
	                System.out.println("소속물류센터명   userInfo.get(\"user_dist_nm\"      ) ["+userInfo.get("user_dist_nm"   )+"]");
	                System.out.println("소속지사코드     userInfo.get(\"user_branch_cd\"    ) ["+userInfo.get("user_branch_cd" )+"]");
	                System.out.println("소속지사명       userInfo.get(\"user_branch_nm\"    ) ["+userInfo.get("user_branch_nm" )+"]");
	                System.out.println("소속가맹점코드   userInfo.get(\"user_chain_cd\"     ) ["+userInfo.get("user_chain_cd"  )+"]");
	                System.out.println("소속가맹점명     userInfo.get(\"user_chian_nm\"     ) ["+userInfo.get("user_chian_nm"  )+"]");
	                System.out.println("수불마감년월     userInfo.get(\"subul_close_yyyymm\") ["+userInfo.get("subul_close_yyyymm"  )+"]");
	                System.out.println("미수마감년월     userInfo.get(\"misu_close_yyyymm\" ) ["+userInfo.get("misu_close_yyyymm"  )+"]");
					
	                
	                session.setAttribute("userInfo"           , userInfo        );//로그인한 사용자 정보
				}
				catch(Exception e)
				{
					System.err.println(e.getMessage());
				}
				finally
				{
					
				}
			}
		}
		
		
		return loginStatus;
		
		
    }

    /**
     * 정보 변경
     * @param paramData
     * @return
     * @throws DAOException
     */
    public int updateUserInfo(HashMap paramData) throws DAOException
	{
		Connection con           = null;
		PreparedStatement pstmt  = null;
		
		int list = 0;
		
		try
		{
			con = DBConnect.getInstance().getConnection();
			
			StringBuffer sQry = new StringBuffer();

			String 기업코드   = JSPUtil.chkNull((String)paramData.get("기업코드")  ,   "");
			String 법인코드   = JSPUtil.chkNull((String)paramData.get("법인코드")  ,   "");
			String 브랜드코드 = JSPUtil.chkNull((String)paramData.get("브랜드코드"),   "");
			String 사용자ID   = JSPUtil.chkNull((String)paramData.get("사용자ID")  ,   "");
			String 권한코드   = JSPUtil.chkNull((String)paramData.get("권한코드")  ,   "");
			
			String 비밀번호   = JSPUtil.chkNull((String)paramData.get("비밀번호")  ,   "");
			String 전화번호1  = JSPUtil.chkNull((String)paramData.get("전화번호1") ,   "");
			String 전화번호2  = JSPUtil.chkNull((String)paramData.get("전화번호2") ,   "");
			String 전화번호3  = JSPUtil.chkNull((String)paramData.get("전화번호3") ,   "");
			
			if ( "10".equals(권한코드) ) // 매장에서 로그인시
  			{
				sQry.append(" UPDATE 매장                                        \n");
				sQry.append("    SET PRM비밀번호  = ?                            \n");
				sQry.append("      , 휴대전화번호 = nvl(?,휴대전화번호)          \n");
				sQry.append("      , 휴대식별번호 = nvl(?,휴대식별번호)          \n");
				sQry.append("      , 휴대국번     = nvl(?,휴대국번)              \n");
				sQry.append("      , 휴대개별번호 = nvl(?,휴대개별번호)          \n");
				sQry.append("      , 수정일자     = SYSDATE                      \n");
				sQry.append("  WHERE 기업코드     = ?                            \n");
				sQry.append("    AND 법인코드     = ?                            \n");
				sQry.append("    AND 브랜드코드   = ?                            \n");
				sQry.append("    AND 사업자번호   = ?                            \n");
  			}
			else
			{
				sQry.append(" UPDATE 사용자                                      \n");
				sQry.append("    SET 비밀번호     = ?                            \n");
				sQry.append("      , 전화번호     = nvl(?,전화번호)              \n");
				sQry.append("      , 수정일자     = TO_CHAR(SYSDATE,'YYYYMMDD')  \n");
				sQry.append("  WHERE 기업코드     = ?                            \n");
				sQry.append("    AND 법인코드     = ?                            \n");
				sQry.append("    AND 브랜드코드   = ?                            \n");
				sQry.append("    AND 사용자ID     = ?                            \n");
			}

									
            int i = 0;
            
            pstmt = new LoggableStatement(con, sQry.toString());
            
            pstmt.setString(++i, 비밀번호        );
            if ( "10".equals(권한코드) ) // 매장에서 로그인시
  			{
            	pstmt.setString(++i, 전화번호1+전화번호2+전화번호3);
            	pstmt.setString(++i, 전화번호1);
            	pstmt.setString(++i, 전화번호2);
            	pstmt.setString(++i, 전화번호3);
  			}
            else
            {
            	pstmt.setString(++i, 전화번호1+전화번호2+전화번호3);
            }
            
            pstmt.setString(++i, 기업코드        );
            pstmt.setString(++i, 법인코드        );
            pstmt.setString(++i, 브랜드코드      );
            pstmt.setString(++i, 사용자ID        );

            
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