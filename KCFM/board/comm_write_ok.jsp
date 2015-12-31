<%-- <%
/** ###############################################################**/
/** Program ID   : comm_write_ok.jsp                                */
/** Program Name : 댓글 등록/수정/삭제                              */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%> --%>

<%@page import="javax.swing.JOptionPane"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.beans.listBean" %>
<%@ page import="board.dao.listDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="/com/common.jsp"%>

<% 
	String root = request.getContextPath();

    listBean bean = null; 
	listDao  dao  = new listDao();
	String   msg  = "";
	int rtn = 0;
	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),""); //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),""); //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),""); //브랜드코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),""); //등록자명
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),""); //매장코드
	
	String listNum        = JSPUtil.chkNull((String)request.getParameter("listNum"       ),""); //게시번호
	String pageGb         = JSPUtil.chkNull((String)request.getParameter("pageGb"        ),""); //게시구분
	String mode           = JSPUtil.chkNull((String)request.getParameter("mode"          ),""); //수정 업데이트 여부
	String commGb         = JSPUtil.chkNull((String)request.getParameter("commGb"        ),""); //댓글번호
	
	int inCurPage         = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1")); // 현재 페이지
	int inCurBlock        = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1")); // 현재 블럭
	
	String srch_key       = JSPUtil.chkNull((String)paramData.get("srch_key") , "");  //검색어
	String srch_type      = JSPUtil.chkNull((String)paramData.get("srch_type"), "0"); //검색종류
	
	srch_key = URLEncoder.encode(srch_key);
	
	String comment="";
	String comment2="";
	String hit = "no";
	String decodeYn = "n";
	
	if("".equals(mode)){
		comment = new String(request.getParameter("comm_write").getBytes("8859_1"),"UTF-8"); //글내용
	}else if ("m".equals(mode)){
		comment = new String(request.getParameter("txt"+commGb).getBytes("8859_1"),"UTF-8"); //댓글내용
	}
	
	paramData.put("comment"       ,  comment       );
	paramData.put("sseGroupCd"    ,  sseGroupCd    );
	paramData.put("sseCorpCd"     ,  sseCorpCd     );
	paramData.put("sseBrandCd"    ,  sseBrandCd    );
	paramData.put("sseCustNm"     ,  sseCustNm     );
	paramData.put("sseCustStoreCd",  sseCustStoreCd);
	paramData.put("pageGb"        ,  pageGb        );
	paramData.put("listNum"       ,  listNum       );
	paramData.put("commGb"          ,  commGb      );
	paramData.put("inCurPage"     ,   inCurPage    );
	paramData.put("inCurBlock"    ,   inCurBlock   );
	paramData.put("srch_key"      ,   srch_key     );
	paramData.put("srch_type"     ,   srch_type    );

	if(pageGb.equals("01") || pageGb.equals("02")) //공지&교육 게시판
	{
		if ("m".equals(mode)){      //댓글 수정
			
			rtn=dao.updateComm(paramData);
			System.out.println ("UPDATE_updateCommWrite1  : "+rtn);
			
			ServletContext sc = getServletContext();            
			RequestDispatcher rd = sc.getRequestDispatcher("/board/detail_view.jsp?listNum="+ listNum + "&pageGb=" + pageGb+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type+"&decodeYn="+decodeYn);
			rd.forward(request, response);
			
		}else if ("d".equals(mode)){ //댓글 삭제

			rtn = dao.deleteComm(paramData);
			System.out.println ("DELETE_deleteCommWrite1  : "+rtn);
			
			out.println("<script>alert('삭제되었습니다.');</script>");
			out.println("<script>location.href='"+ root +"/board/detail_view.jsp?pageGb=" + pageGb+"&listNum="+listNum+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type+"&decodeYn="+decodeYn+"'</script>");
			
		}else{                       //댓글 등록
			
			rtn = dao.insertCommWrite(paramData);
			System.out.println ("INSERT_insertCommWrite1  : "+rtn);
			
			ServletContext sc = getServletContext();            
			RequestDispatcher rd = sc.getRequestDispatcher("/board/detail_view.jsp?listNum="+ listNum + "&pageGb=" + pageGb+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type+"&decodeYn="+decodeYn);
			rd.forward(request, response);
			
		}
		
	}else if(pageGb.equals("11") || pageGb.equals("12"))  //건의&요청 게시판
	{
		if ("m".equals(mode)){		// 댓글 수정
			
			rtn=dao.updateProposalComm(paramData);
			//int rtn2 = dao.updateProposalRequest(paramData); //요청상태코드 1답변대기
			System.out.println ("UPDATE_updateProposalCommWrite1  : "+rtn);
			
			ServletContext sc = getServletContext();            
			RequestDispatcher rd = sc.getRequestDispatcher("/board/detail_view.jsp?listNum="+ listNum + "&pageGb=" + pageGb+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type+"&decodeYn="+decodeYn);
			rd.forward(request, response);
			
		}else if ("d".equals(mode)){ //댓글 삭제
			rtn = dao.deleteProposalComm(paramData);
			int rtn2 = dao.updateProposalStatusDone(paramData); //요청상태코드 9_답변완료
			System.out.println ("DELETE_deleteProposalCommWrite1  : "+rtn);
			
			out.println("<script>alert('삭제되었습니다.');</script>");
			out.println("<script>location.href='"+ root +"/board/detail_view.jsp?pageGb=" + pageGb+"&listNum="+listNum+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type+"&decodeYn="+decodeYn+"'</script>");
			
		}else{						// 댓글 등록
			
			rtn = dao.insertProposalCommWrite(paramData);
			int rtn2 = dao.updateProposalRequest(paramData); //요청상태코드 1_답변대기
			System.out.println ("INSERT_insertProposalCommWrite1 : "+rtn);
			System.out.println ("UPDATE_updateProposalrequesst1  : "+rtn2);
			
			ServletContext sc = getServletContext();            
			RequestDispatcher rd = sc.getRequestDispatcher("/board/detail_view.jsp?listNum="+ listNum + "&pageGb=" + pageGb+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type+"&decodeYn="+decodeYn);
			rd.forward(request, response);
			
		}
		
	}
	
	
%>