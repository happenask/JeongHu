
<%
/** ############################################################### */
/** Program ID   : prom-delete-ok.jsp                               */
/** Program Name : 홍보물 삭제 										*/
/** Program Desc : 홍보물 삭제 처리				                    */
/** Create Date  : 2015.05.14                                       */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.multipart.MultipartParser"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.util.BoardConstant" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="prom_mnt.beans.promMntBean" %> 
<%@ page import="prom_mnt.dao.promMntDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ include file="/com/common.jsp"%>

<%
		com.util.Log4u log4u = new com.util.Log4u();
		log4u.log("CALL /prom-delete-ok.jsp");		
		
		String root = request.getContextPath();
		
		//--------------------------------------------------------------------------------------------------
		// Session 정보
		//--------------------------------------------------------------------------------------------------
		
		String sGroupCode      = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
		String sCorpCode       = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
		String sBrandCode      = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
		String sCustAuth       = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth" ),""); //권한코드
		String sCustLoginNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"   ),""); //등록자명

		//--------------------------------------------------------------------------------------------------
	  	// 파라미터 인코딩
	  	//--------------------------------------------------------------------------------------------------

	  	request.setCharacterEncoding("UTF-8");
	  	String encType = "UTF-8";
	  	
		//--------------------------------------------------------------------------------------------------
		// 변수 초기화
		//--------------------------------------------------------------------------------------------------
		
		String msg = "";
		String event = "";
		
		int rtn = 0;
		
		String param_name   = "";
		String param_value  = "";
		String name			= "";
		String filename		= "";
		String original		= "";
		String type			= "";
		
		//-------------------------------------------------------------------------------------------------------
		//  Bean 및 Dao 처리
		//-------------------------------------------------------------------------------------------------------
		
		promMntBean bean = null;
		promMntDao dao = new promMntDao();
		
	
		
		//--------------------------------------------------------------------------------------------------
		// Parameter 정보
		//--------------------------------------------------------------------------------------------------
		
		String sEvent		= JSPUtil.chkNull((String)request.getParameter("inEvent"),""); 			//이벤트구분
		String sOptGroup	= JSPUtil.chkNull((String)request.getParameter("inCompanyCd"),""); 		//기업코드
		String sOptCorp		= JSPUtil.chkNull((String)request.getParameter("inCorpCd"),""); 	    //법인코드
		String sOptBrand	= JSPUtil.chkNull((String)request.getParameter("inBrandCd"),""); 		//브랜드코드
		String sOptBigClass	= JSPUtil.chkNull((String)request.getParameter("inBigClass"),""); 		//대분류코드
		String sOptMidClass	= JSPUtil.chkNull((String)request.getParameter("inMidClass"),""); 		//중분류코드
		String sPromNo		= JSPUtil.chkNull((String)request.getParameter("inPromNo"),""); 		//홍보물번호
		String StartDate 	= JSPUtil.chkNull((String)request.getParameter("sDate"),"");            //조회시작일자
		String EndDate   	= JSPUtil.chkNull((String)request.getParameter("eDate"),"");            //조회종료일자
		
		int inCurPage          = Integer.parseInt(JSPUtil.chkNull((String)request.getParameter("inCurPage"),  "1"));
	
		System.out.println ("prom-delete-ok========================================");
		System.out.println ("sseGroupCd       : " + sGroupCode		);
		System.out.println ("sseCorpCd        : " + sCorpCode		);
		System.out.println ("sseBrandCd       : " + sBrandCode		);
		System.out.println ("sseCustNm        : " + sCustLoginNm	);
		System.out.println ("sEvent           : " + sEvent        );
		System.out.println ("sOptGroup        : " + sOptGroup        );
		System.out.println ("sOptCorp         : " + sOptCorp        );
		System.out.println ("sOptBrand        : " + sOptBrand       );
		System.out.println ("sOptBigClass     : " + sOptBigClass    );
		System.out.println ("sOptMidClass     : " + sOptMidClass    );
		System.out.println ("sPromNo          : " + sPromNo     	);
		System.out.println ("sDate            : " + StartDate       );
		System.out.println ("eDate            : " + EndDate         );
		System.out.println ("inCurPage        : " + inCurPage		);
		System.out.println ("=======================================================");
		
		//--------------------------------------------------------------------------------------------------
		// Parameter 입력
		//--------------------------------------------------------------------------------------------------		
		
		paramData.put("sseGroupCode",   		sGroupCode      );
		paramData.put("sseCorpCode",    		sCorpCode       );
		paramData.put("sseBrandCode",   		sBrandCode      );
		paramData.put("등록자",      			sCustLoginNm    );
		paramData.put("기업코드",          		sOptGroup      );
		paramData.put("법인코드",          		sOptCorp        );
		paramData.put("브랜드코드",        		sOptBrand       );
		paramData.put("홍보물대분류",        	sOptBigClass    );
		paramData.put("홍보물코드",         	sOptMidClass    );
		paramData.put("홍보물번호",         	sPromNo         );
	    paramData.put("조회시작일자"  , 		StartDate       );
	    paramData.put("조회종료일자"  , 		EndDate         );
		paramData.put("inCurPage",      	    inCurPage       );
				

		//--------------------------------------------------------------------------------------------------
		// 게시구분의 따른 삭제 
		//--------------------------------------------------------------------------------------------------
		
		rtn = dao.deleteWrite(paramData);
		System.out.println ("deleteWrite  : "+rtn);
		event = "삭제";
		
		response.sendRedirect(root+"/prom_mnt/maintain-prom-dtl.jsp?inCurPage="+inCurPage+"&sDate="+StartDate+"&eDate="+EndDate);

		
		if(rtn > 0  )
		{
			msg =  "정상적으로 "+event+"되었습니다.";
		}
		else
		{	
			msg = "작업중 오류가 발생하였습니다.";	
		}
		

		out.println(msg);
	
%>