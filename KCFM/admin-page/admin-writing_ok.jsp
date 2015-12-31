
<%
/** ############################################################### */
/** Program ID   : admin-writing_ok.jsp                             */
/** Program Name : 관리자 공지사항,교육자료 글저장 					*/
/** Program Desc : 공지사항 교육자료 신규, 수정 처리                */
/** Create Date  : 2015.04.10                                       */
/** Programmer   : Hojun.Choi                                       */
/** Update Date  : 2015.05.15                                       */
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
<%@ page import="admin.beans.adminBean" %> 
<%@ page import="admin.dao.adminDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ include file="/com/common.jsp"%>

<% 	
	com.util.Log4u log4u = new com.util.Log4u();
	log4u.log("CALL /admin-writing-ok.jsp");		

	String root = request.getContextPath();

	//--------------------------------------------------------------------------------------------------
	// Session 정보
	//--------------------------------------------------------------------------------------------------
	
	String sGroupCode      = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
	String sCorpCode       = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
	String sBrandCode      = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
	String sCustLoginNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"   ),""); //등록자명

	//--------------------------------------------------------------------------------------------------
	// 변수 초기화
	//--------------------------------------------------------------------------------------------------

	adminBean bean = null; 
	adminDao  dao  = new adminDao();
	String   msg   = "";
	int rtn = 0;
	
	String param_name   = "";
	String param_value  = "";
	String name			= "";
	String filename		= "";
	String original		= "";
	String type			= "";

	//--------------------------------------------------------------------------------------------------
	// 파라미터 인코딩
	//--------------------------------------------------------------------------------------------------

	request.setCharacterEncoding("UTF-8");
	String encType = "UTF-8";

	//--------------------------------------------------------------------------------------------------
	// 파일저장위치 경로
	//--------------------------------------------------------------------------------------------------	
	
	BoardConstant bCont = new BoardConstant();
	String 	saveFolder 	= bCont.FILEPATH ;				//저장위치
	int 	maxSize 	= bCont.FILESIZE;				//파일최대크기(5M)
	
	//String saveFolder 	= "D:/PACKAGE_WORKSPACE/workspace(pos)_2015/KCFM/filestorage" ;
	try{
		//--------------------------------------------------------------------------------------------------
		// Parameter 정보
		//--------------------------------------------------------------------------------------------------		
		MultipartRequest multi = new MultipartRequest(request, saveFolder, maxSize, encType, new DefaultFileRenamePolicy()) ;
		String sTitle          = JSPUtil.chkNull((String)multi.getParameter("title"       ), ""); //제목
		String sComment        = JSPUtil.chkNull((String)multi.getParameter("comment"     ), ""); //글내용	
		String spageGb         = JSPUtil.chkNull((String)multi.getParameter("pageGb"      ), ""); //게시구분//
		String noticeKind      = JSPUtil.chkNull((String)multi.getParameter("noticeKind"  ),"1"); //건의요청구분
		String listNum         = JSPUtil.chkNull((String)multi.getParameter("seqNum"      ), ""); //글 순번
		String mode1           = JSPUtil.chkNull((String)multi.getParameter("mode1"       ), ""); //삭제여부 파라미터(del1)
		String mode2           = JSPUtil.chkNull((String)multi.getParameter("mode2"       ), ""); //삭제여부 파라미터(del2)
		String mode3           = JSPUtil.chkNull((String)multi.getParameter("mode3"       ), ""); //삭제여부 파라미터(del3)
		String StartDate 	   = JSPUtil.chkNull((String)multi.getParameter("sDate"		  ), ""); //조회시작일자
		String EndDate   	   = JSPUtil.chkNull((String)multi.getParameter("eDate"		  ), ""); //조회종료일자
		String srch_type  	   = JSPUtil.chkNull((String)multi.getParameter("srch_type"   ),"0"); //검색종류
		String BoardStartDate  = JSPUtil.chkNull((String)multi.getParameter("bsDate"      ), ""); //게시시작일자
		String BoardEndDate    = JSPUtil.chkNull((String)multi.getParameter("beDate"      ), ""); //게시종료일자
		String srch_key        = JSPUtil.chkNull((String)paramData.get("srch_key") , ""); //검색어
		
		int inCurPage          = Integer.parseInt(JSPUtil.chkNull((String)multi.getParameter("inCurPage"),  "1"));
		
		srch_key = URLEncoder.encode(srch_key);
		
		System.out.println ("admin-writing-ok========================================");
		
		System.out.println ("title          : " + sTitle         );
		System.out.println ("comment        : " + sComment        );
		System.out.println ("sseGroupCd     : " + sGroupCode     );
		System.out.println ("sseCorpCd      : " + sCorpCode      );
		System.out.println ("sseBrandCd     : " + sBrandCode     );
		System.out.println ("sseCustNm      : " + sCustLoginNm      );
		System.out.println ("listNum        : " + listNum        );
		System.out.println ("pageGb         : " + spageGb         );
		System.out.println ("inCurPage      : " + inCurPage      );
		System.out.println ("mode1          : " + mode1           );
		System.out.println ("mode2          : " + mode2           );
		System.out.println ("mode3          : " + mode3           );
		System.out.println ("sDate          : " + StartDate           );
		System.out.println ("eDate          : " + EndDate           );
		System.out.println ("bsDate         : " + BoardStartDate           );
		System.out.println ("beDate         : " + BoardEndDate           );
		System.out.println ("srch_type      : " + srch_type           );
		System.out.println ("srch_key       : " + srch_key           );
		System.out.println ("=======================================================");
		
		//--------------------------------------------------------------------------------------------------
		// Parameter 입력
		//--------------------------------------------------------------------------------------------------		
		
		
		paramData.put("sseGroupCode",   sGroupCode     );
		paramData.put("sseCorpCode",    sCorpCode      );
		paramData.put("sseBrandCode",   sBrandCode     );
		paramData.put("sseCustNm",      sCustLoginNm   );
		paramData.put("title",          sTitle         );
		paramData.put("comment",        sComment       );
		paramData.put("listNum",        listNum        );
		paramData.put("pageGb",         spageGb        );
		paramData.put("noticeKind",     noticeKind     );
		paramData.put("inCurPage",      inCurPage      );
	    paramData.put("sDate"  , 		StartDate      );
	    paramData.put("eDate"  , 		EndDate        );
	    paramData.put("bsDate"  , 		BoardStartDate );
	    paramData.put("beDate"  , 		BoardEndDate   );
	    paramData.put("srch_type",      srch_type      );
	    paramData.put("srch_key",       srch_key       );
	    
		//--------------------------------------------------------------------------------------------------
		// 파일 첨부 삭제
		//--------------------------------------------------------------------------------------------------		
	    
		int chkDeleteNum = dao.selectRequestDownloadChk(paramData);
		
		if(!"".equals(mode1)){
			//파일첨부 삭제
			paramData.put("fileNum"    , mode1     );
			rtn = dao.deleteRequestFile(paramData);
			System.out.println ("FILE_DELETE1  : "+rtn);
		}
		if(!"".equals(mode2)){
			//파일첨부 삭제
			paramData.put("fileNum"    , mode2     );
			rtn = dao.deleteRequestFile(paramData);
			System.out.println ("FILE_DELETE2  : "+rtn);
		}
		if(!"".equals(mode3)){
			//파일첨부 삭제
			paramData.put("fileNum"    , mode3     );
			rtn = dao.deleteRequestFile(paramData);
			System.out.println ("FILE_DELETE3  : "+rtn);
		}
		
		int fNumCnt = 0;
		
		fNumCnt = dao.selectNoticeDownloadCnt(paramData);
		if("".equals(fNumCnt)){
			fNumCnt = 0;
		}
		
		Enumeration<String> params = multi.getParameterNames();
		
		while(params.hasMoreElements()){
			param_name 	= params.nextElement();
			param_value = multi.getParameter(param_name);
			
			out.print(param_name+"="+param_value+"<br/>");
			paramData.put(param_name         , param_value         );
			
			if ( param_name.equals("listNum") ) {
				listNum = param_value;				
			}
			if ( param_name.equals("pageGb") ) {
				spageGb = param_value;				
			}
			
		}
		
		out.println("<p/>");

		//--------------------------------------------------------------------------------------------------
		// 파일명 조립
		//--------------------------------------------------------------------------------------------------		

		Enumeration<String> files = multi.getFileNames();
		
		while(files.hasMoreElements()){
			fNumCnt++;
			System.out.println("fNumCnt=======================");
			System.out.println(fNumCnt);
			System.out.println("=======================");
			name = files.nextElement();
			filename = multi.getFilesystemName(name);
			original = multi.getOriginalFileName(name);
			type = multi.getContentType(name);
			
			File f = multi.getFile(name);

			out.println("파라미터 이름:"+name+"<br/>");
			out.println("실제파일 이름:"+original+"<br/>");
			out.println("저장된 파일 이름:"+filename+"<br/>");
			out.println("type:"+type+"<br/>");
			
			if(f!=null){
				out.println("크기:"+f.length()+"byte");
				out.println("<br/>");

				paramData.put("fileName"	,filename     );
				paramData.put("orgFileName"	,original     );
				paramData.put("filePath"    ,saveFolder   );
				/* paramData.put("fileNum"     ,name.substring(10)); */
				
				String sfNumCnt = Integer.toString(fNumCnt);
				paramData.put("fileNum"     ,sfNumCnt );

		//--------------------------------------------------------------------------------------------------
		// 첨부파일 테이블 Insert & Update 
		//--------------------------------------------------------------------------------------------------		
				
				int chkNum = dao.selectRequestDownloadChk(paramData);
				if (chkNum > 0){
					rtn = dao.updateRequestFile(paramData);
					System.out.println ("FILE_UPDATE  : "+rtn);
					System.out.println ("FILE_UPDATE paramData  : "+paramData);
				}else{
					if("0".equals(listNum)){
						rtn = dao.insertNoticeFileNew(paramData);
						System.out.println ("FILE_INSERT_new  : "+rtn);
						System.out.println ("FILE_INSERT_new paramData : "+paramData);
					}else{
						rtn = dao.insertNoticeFile(paramData);
						System.out.println ("FILE_INSERT  : "+rtn);
						System.out.println ("FILE_INSERT paramData : "+paramData);
					}
				}
			}
		}
		//--------------------------------------------------------------------------------------------------
		// 게시글 Insert & Update 
		//--------------------------------------------------------------------------------------------------		
		if("0".equals(listNum)){
			
			rtn = dao.insertWrite(paramData);
			System.out.println ("insertWrite  : "+rtn);
			response.sendRedirect(root+"/admin-page/admin-main.jsp?pageGb="+spageGb+"&inCurPage="+inCurPage+"&srch_type="+srch_type+"&srch_key="+srch_key+ "&sDate=" + StartDate+ "&eDate=" + EndDate);
		}else {
			rtn = dao.updateWrite(paramData);
			System.out.println ("updateWrite  : "+rtn);
			//수정후 detail-view로 이동
			response.sendRedirect(root+"/admin-page/admin-main.jsp?listNum="+ listNum + "&pageGb=" + spageGb + "&srch_key=" + srch_key + "&srch_type=" + srch_type + "&sDate=" + StartDate + "&eDate=" + EndDate);
			//수정후 main-view로 이동
			/* response.sendRedirect(root+"/admin-page/admin-main.jsp?pageGb="+spageGb+"&inCurPage="+inCurPage+"&srch_type="+srch_type+"&srch_key="+srch_key+ "&sDate=" + StartDate+ "&eDate=" + EndDate); */
		}
		 	
		    
		    
	}catch(Exception e){
		e.printStackTrace();
	}
	
	
	if(rtn > 0  )
	{
		msg = "Admin_writing_Ok";
	}
	else
	{	
		msg = "Admin_writing_Err";	
	}

	out.println(msg);
%>