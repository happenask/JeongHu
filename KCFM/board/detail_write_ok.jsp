<%-- <%
/** ############################################################### **/
/** Program ID   : detail_write_ok.jsp                                 */
/** Program Name : 글저장                                           */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%> --%>

<%@page import="com.oreilly.servlet.multipart.MultipartParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.util.BoardConstant" %>
<%@ page import="board.beans.listBean" %>
<%@ page import="board.dao.listDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ include file="/com/common.jsp"%>

<% 

	String root = request.getContextPath();
    System.out.println ("root : " + root);

	listBean bean = null; 
	listDao  dao  = new listDao();
	String   msg  = "";
	int rtn = 0;
	String hit = "no";

	String param_name   = "";
	String param_value  = "";
	String name			= "";
	String filename		= "";
	String original		= "";
	String type			= "";
	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),""); //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),""); //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),""); //브랜드코드
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),""); //매장코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),""); //등록자명
	
	String listNum        = JSPUtil.chkNull((String)paramData.get("listNum"),   "" ); //게시번호 
	String no             = JSPUtil.chkNull((String)paramData.get("no"),        "0"); //
	/* String srch_key    = JSPUtil.chkNull((String)paramData.get("srch_key") , "" ); //검색어
	String srch_type      = JSPUtil.chkNull((String)paramData.get("srch_type"), "0"); //검색종류 */

	int inCurPage   = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1")); // 현재 페이지
	int inCurBlock  = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1")); // 현재 블럭
	
	

	

	request.setCharacterEncoding("UTF-8");
	String encType = "UTF-8";

	// 파일저장위치 경로
	BoardConstant bCont = new BoardConstant();

	String 	saveFolder 	= bCont.FILEPATH ;				//저장위치
	int 	maxSize 	= bCont.FILESIZE;				//파일최대크기(5M)
	
	try{
		
		MultipartRequest multi = new MultipartRequest(request, saveFolder, maxSize, encType, new DefaultFileRenamePolicy()) ;
		
		String sTitle  = new String(multi.getParameter("title").getBytes("8859_1"),"UTF-8"  );   //제목
		String comment = new String(multi.getParameter("comment").getBytes("8859_1"),"UTF-8");   //글내용
		String pageGb         = JSPUtil.chkNull((String)multi.getParameter("pageGb"       ),""); //게시구분
		String comboClaimGb   = JSPUtil.chkNull((String)multi.getParameter("comboVal"     ),""); //건의요청콤보update
		String comboVal       = JSPUtil.chkNull((String)multi.getParameter("comboVal"     ),""); //건의요청콤보insert
		String mode1          = JSPUtil.chkNull((String)multi.getParameter("mode1"        ),""); //삭제여부 파라미터(del1)
		String mode2          = JSPUtil.chkNull((String)multi.getParameter("mode2"        ),""); //삭제여부 파라미터(del2)
		String mode3          = JSPUtil.chkNull((String)multi.getParameter("mode3"        ),""); //삭제여부 파라미터(del3)
		String srch_key       = JSPUtil.chkNull((String)multi.getParameter("srch_key"     ),""); //검색어
		String srch_type      = JSPUtil.chkNull((String)multi.getParameter("srch_type"    ),"0"); //검색종류
		
		//srch_key =  URLDecoder.decode(srch_key , "UTF-8");
		
		
		System.out.println ("detail_write_ok========================================");
		
		System.out.println ("title          : " + sTitle         );
		System.out.println ("comment        : " + comment        );
		System.out.println ("sseGroupCd     : " + sseGroupCd     );
		System.out.println ("sseCorpCd      : " + sseCorpCd      );
		System.out.println ("sseCustStoreCd : " + sseCustStoreCd );
		System.out.println ("sseBrandCd     : " + sseBrandCd     );
		System.out.println ("sseCustNm      : " + sseCustNm      );
		System.out.println ("listNum        : " + listNum        );
		System.out.println ("pageGb         : " + pageGb         );
		System.out.println ("comboClaimGb   : " + comboClaimGb   );
		System.out.println ("comboVal       : " + comboVal       );
		System.out.println ("inCurPage      : " + inCurPage      );
		System.out.println ("inCurBlock     : " + inCurBlock     );
		System.out.println ("srch_key       : " + srch_key       );
		System.out.println ("srch_type      : " + srch_type      );
		System.out.println ("no             : " + no             );
		System.out.println ("mode1          : " + mode1          );
		System.out.println ("mode2          : " + mode2          );
		System.out.println ("mode3          : " + mode3          );
		System.out.println ("=======================================================");
		
		paramData.put("title"         , sTitle         );
		paramData.put("comment"       , comment        );
		paramData.put("sseGroupCd"    , sseGroupCd     );
		paramData.put("sseCorpCd"     , sseCorpCd      );
		paramData.put("sseBrandCd"    , sseBrandCd     );
		paramData.put("sseCustStoreCd", sseCustStoreCd );
		paramData.put("sseCustNm"     , sseCustNm      );
		paramData.put("listNum"       , listNum        );
		paramData.put("pageGb"        , pageGb         );
		paramData.put("comboClaimGb"  , comboClaimGb   );
		paramData.put("comboVal"      , comboVal       );
		paramData.put("srch_key"      , srch_key       );
		paramData.put("srch_type"     , srch_type      );
		paramData.put("inCurPage"     , inCurPage      );
		paramData.put("inCurBlock"    , inCurBlock     );
		
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
		
		fNumCnt = dao.selectProposalDownloadCnt(paramData);
		if("".equals(fNumCnt)){
			fNumCnt = 0;
		}
		
		
		Enumeration<String> params = multi.getParameterNames();

		while(params.hasMoreElements()){
			param_name 	= params.nextElement();
			param_value = multi.getParameter(param_name);
			
			//out.print(param_name+"="+param_value+"<br/>");
			paramData.put(param_name         , param_value         );
			
			if ( param_name.equals("listNum") ) {
				listNum = param_value;				
			}
			if ( param_name.equals("pageGb") ) {
				pageGb = param_value;				
			}
			if ( param_name.equals("inCurPage") ) {
				inCurPage = Integer.parseInt(param_value);			
			}
			
		}

		out.println("<p/>");
		
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

			/* out.println("파라미터 이름:"+name+"<br/>");
			out.println("실제파일 이름:"+original+"<br/>");
			out.println("저장된 파일 이름:"+filename+"<br/>");
			out.println("type:"+type+"<br/>"); */
			
			if(f!=null){
				out.println("크기:"+f.length()+"byte");
				out.println("<br/>");

				paramData.put("fileName"	,filename           );
				paramData.put("orgFileName"	,original           );
				paramData.put("filePath"    ,saveFolder         );
				/* paramData.put("fileNum"     ,name.substring(10) ); */
				String sfNumCnt = Integer.toString(fNumCnt);
				paramData.put("fileNum"     ,sfNumCnt );
				
				int chkNum = dao.selectRequestDownloadChk(paramData);
				
				System.out.println("fileName : "+filename);
				System.out.println("orgFileName : "+original);
				System.out.println("filePath : "+saveFolder);
				System.out.println("fileNum : "+name.substring(10));
				
				if(chkNum > 0){
					//파일첨부 업데이트
					
						rtn = dao.updateRequestFile(paramData);
						System.out.println ("FILE_UPDATE  : "+rtn);
					
				}else{
					if("".equals(listNum)){
						rtn = dao.insertProposalFile(paramData);
						System.out.println ("FILE_INSERT_new  : "+rtn);
					}else{
						rtn = dao.insertProposalFile(paramData);
						System.out.println ("FILE_INSERT  : "+rtn);
					}
				}
			
			}
		}
		
		if("".equals(listNum) || listNum == null){

			rtn += dao.insertProposalWrite(paramData); 
			
			System.out.println ("INSERT  : "+rtn);
			response.sendRedirect(root+"/board/list.jsp?pageGb=" + pageGb);
			
		}else {
			if("01".equals(pageGb)){
				rtn = dao.updateWrite(paramData); 
				System.out.println ("UPDATE 01   : "+rtn);
				System.out.println ("inCurPage01 : "+inCurPage);
			}else if("02".equals(pageGb)){
				rtn = dao.updateWrite(paramData);
				System.out.println ("UPDATE 02 : "+rtn);
			}else if("11".equals(pageGb)){
				rtn = dao.updateProposalWrite(paramData); 
				System.out.println ("UPDATE 11   : "+rtn);
				System.out.println ("inCurPage11 : "+inCurPage);
			}else if("12".equals(pageGb)){
				rtn = dao.updateProposalWrite(paramData); 
				System.out.println ("UPDATE 12 : "+rtn);
			}
			
		    /* ServletContext sc = getServletContext();
		    RequestDispatcher rd = sc.getRequestDispatcher("/board/list.jsp?listNum="+ listNum + "&pageGb=" + pageGb+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type);
		    rd.forward(request, response); */
		    out.println("<script>location.href='"+ root +"/board/list.jsp?listNum="+ listNum + "&pageGb=" + pageGb+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type+"'</script>");
		}
	
		
	}catch(Exception e){
		e.printStackTrace();
	}
	
%>

<!DOCTYPE html>