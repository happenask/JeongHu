<%
/** ############################################################### */
/** Program ID   : edit-info-ok.jsp                                 */
/** Program Name : 정보변경                                         */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.login.dao.loginCheckDao" %>
<%@ page import="com.login.beans.loginCheckBean" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ include file="/com/common.jsp"%>

<% 
	
	com.util.Log4u log4u = new com.util.Log4u();

	loginCheckBean userBean = null; 
	loginCheckDao  userDao  = new loginCheckDao();
	
	ArrayList<loginCheckBean> list = null;
	
	String pGroupCd  = (String)session.getAttribute("sseGroupCd");
	String pCorpCd   = (String)session.getAttribute("sseCorpCd");
	String pBrandCd  = (String)session.getAttribute("sseBrandCd");
	String pUserId   = (String)session.getAttribute("sseCustId");
	String pChkAuth  = (String)session.getAttribute("sseCustAuth");
	
	String pPassWord = JSPUtil.chkNull((String)request.getParameter("passwordNew1"),"");
	String pTelno1   = JSPUtil.chkNull((String)request.getParameter("telno1"),"");
	String pTelno2   = JSPUtil.chkNull((String)request.getParameter("telno2"),"");
	String pTelno3   = JSPUtil.chkNull((String)request.getParameter("telno3"),"");
	
	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("사용자ID"  , (String)session.getAttribute("sseCustId"));
	paramData.put("권한코드"  , (String)session.getAttribute("sseCustAuth"));
	
	paramData.put("비밀번호"  , JSPUtil.chkNull((String)request.getParameter("passwordNew1"),""));
	paramData.put("전화번호1"  , JSPUtil.chkNull((String)request.getParameter("telno1"),""));
	paramData.put("전화번호2"  , JSPUtil.chkNull((String)request.getParameter("telno2"),""));
	paramData.put("전화번호3"  , JSPUtil.chkNull((String)request.getParameter("telno3"),""));
	
	/*
	System.out.println("pGroupCd>>>>>>>>>>>>> : "+pGroupCd);
	System.out.println("pCorpCd >>>>>>>>>>>>> : "+pCorpCd);
	System.out.println("pBrandCd>>>>>>>>>>>>> : "+pBrandCd);
	System.out.println("pUserId >>>>>>>>>>>>> : "+pUserId);
	System.out.println("pChkAuth>>>>>>>>>>>>> : "+pChkAuth);
	
	System.out.println("pPassWord>>>>>>>>>>>>> : "+pPassWord);
	System.out.println("pTelno1  >>>>>>>>>>>>> : "+pTelno1);
	System.out.println("pTelno2  >>>>>>>>>>>>> : "+pTelno2);
	System.out.println("pTelno3  >>>>>>>>>>>>> : "+pTelno3);
	*/
	
	int update = userDao.updateUserInfo(paramData);
	
	
	//사용자ID(사업자번호), Password, 권한체크(매장,전단지업체,관리자)
	list = userDao.checkUserLogin(pUserId, pPassWord, pChkAuth);
	
	String groupCd       = "";  // 기업코드
	String corpCd        = "";  // 법인코드
	String brandCd       = "";  // 브랜드코드
	String custId        = "";  // 사용자ID
	String custNm        = "";  // 사용자명
	String custAuth      = "";  // 사용자권한
	String custpassWd    = "";  // 사용자비밀번호
	String custStoreCd   = "";  // 사용자매장코드
	String custStoreNm   = "";  // 사용자매장
	String custTelNo     = "";  // 사용자전화번호
	String custHpNo      = "";  // 사용자HP번호
	String svCustNm      = "";  // 담당SV명
	String svTelNo       = "";  // 담당SV전화번호
	String msg           = "";
	String loginStatus   = "";  // 로그인상태
	
	if( list != null && list.size() > 0 ) 
	{
		userBean = (loginCheckBean)list.get(0);
		  
		groupCd     = JSPUtil.chkNull(userBean.get기업코드()      );
		corpCd      = JSPUtil.chkNull(userBean.get법인코드()      );
		brandCd     = JSPUtil.chkNull(userBean.get브랜드코드()    );
		custId      = JSPUtil.chkNull(userBean.get사용자ID()      );
		custNm      = JSPUtil.chkNull(userBean.get사용자명()      );
		custAuth    = JSPUtil.chkNull(userBean.get권한코드()      );
		custpassWd  = JSPUtil.chkNull(userBean.get비밀번호()      );
		custStoreCd = JSPUtil.chkNull(userBean.get매장코드()      );
		custStoreNm = JSPUtil.chkNull(userBean.get매장명()        );
		custTelNo   = JSPUtil.chkNull(userBean.get전화번호()      );
		custHpNo    = JSPUtil.chkNull(userBean.get휴대전화번호()  );
		svCustNm    = JSPUtil.chkNull(userBean.get담당SV()        );
		svTelNo     = JSPUtil.chkNull(userBean.get담당SV전화번호());
		
		loginStatus = "Y";  // 로그인상태
		
		
		//세션저장
		session.setAttribute("sseGroupCd"     , groupCd    );
		session.setAttribute("sseCorpCd"      , corpCd     );
		session.setAttribute("sseBrandCd"     , brandCd    );
		session.setAttribute("sseCustId"      , custId     );
		session.setAttribute("sseCustNm"      , custNm     );
		session.setAttribute("sseCustAuth"    , custAuth   );
		session.setAttribute("sseCustPassWd"  , custpassWd );
		session.setAttribute("sseCustStoreCd" , custStoreCd);
		session.setAttribute("sseCustStoreNm" , custStoreNm);
		session.setAttribute("sseCustTelNo"   , custTelNo  );
		session.setAttribute("sseCustHpNo"    , custHpNo   );
		session.setAttribute("sseSvCustNm"    , svCustNm   );
		session.setAttribute("sseSvTelNo"     , svTelNo    );
		
		
        log4u.log("    sseGroupCd     :" + (String)session.getAttribute("sseGroupCd")  );
        log4u.log("    sseCorpCd      :" + (String)session.getAttribute("sseCorpCd")  );
        log4u.log("    sseBrandCd     :" + (String)session.getAttribute("sseBrandCd")  );
        log4u.log("    sseCustId      :" + (String)session.getAttribute("sseCustId")  );
        log4u.log("    sseCustNm      :" + (String)session.getAttribute("sseCustNm")  );
        log4u.log("    sseCustAuth    :" + (String)session.getAttribute("sseCustAuth")  );
        log4u.log("    sseCustPassWd  :" + (String)session.getAttribute("sseCustPassWd")  );
        log4u.log("    sseCustStoreCd :" + (String)session.getAttribute("sseCustStoreCd")  );
        log4u.log("    sseCustStoreNm :" + (String)session.getAttribute("sseCustStoreNm")  );
        log4u.log("    sseCustTelNo   :" + (String)session.getAttribute("sseCustTelNo")  );
        log4u.log("    sseCustHpNo    :" + (String)session.getAttribute("sseCustHpNo")  );
        log4u.log("    sseSvCustNm    :" + (String)session.getAttribute("sseSvCustNm")  );
        log4u.log("    sseSvTelNo     :" + (String)session.getAttribute("sseSvTelNo")  );
        
	}
	
	if( "".equals(loginStatus) )
	{
		
		msg = "No";
	}
	else
	{
		msg = "Yes";
/*		if ( "10".equals(pChkAuth) )
		{
			msg = "10";	//매장 페이지
		}*/
	}

	out.println(msg);
	
%>