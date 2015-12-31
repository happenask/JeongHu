<%-- <%
/** ############################################################### **/
/** Program ID   : delete_ok.jsp                                    */
/** Program Name : 건의&요청 삭제                                   */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.swing.JOptionPane"%>
<%@ page import="board.beans.listBean" %>
<%@ page import="board.dao.listDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ include file="/com/common.jsp"%>

<% 
	String root = request.getContextPath();

    listBean bean = null; 
	listDao  dao  = new listDao();
	String   msg  = "";
	int rtn = 0;
	String hit = "no";
	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),""); //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),""); //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),""); //브랜드코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),""); //등록자명
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),""); //매장코드
	String srch_key       = JSPUtil.chkNull((String)session.getAttribute("srch_key"      ),""); //검색어
	String srch_type      = JSPUtil.chkNull((String)session.getAttribute("srch_type"     ),"0");//검색종류
	
	String listNum        = JSPUtil.chkNull((String)request.getParameter("listNum"       ),""); //게시번호
	String pageGb         = JSPUtil.chkNull((String)request.getParameter("pageGb"        ),""); //게시구분
	
	int inCurPage         = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurPage"),  "1")); // 현재 페이지
	int inCurBlock        = Integer.parseInt(JSPUtil.chkNull((String)paramData.get("inCurBlock"), "1")); // 현재 블럭
	
	paramData.put("sseGroupCd"    ,  sseGroupCd    );
	paramData.put("sseCorpCd"     ,  sseCorpCd     );
	paramData.put("sseBrandCd"    ,  sseBrandCd    );
	paramData.put("sseCustStoreCd",  sseCustStoreCd);
	paramData.put("sseCustNm"     ,  sseCustNm     );
	paramData.put("pageGb"        ,  pageGb        );
	paramData.put("listNum"       ,  listNum       );
	paramData.put("inCurPage"     ,   inCurPage    );
	paramData.put("inCurBlock"    ,   inCurBlock   );
	paramData.put("srch_key"      ,   srch_key     );
	paramData.put("srch_type"     ,   srch_type    );
	
	if(pageGb.equals("01") || pageGb.equals("02"))	//공지&교육 게시판
	{
		String cRead = dao.selectReadConFirm(paramData);
		if("N".equals(cRead)){	// 게시배포확인 처리
			rtn = dao.updateReadNortice(paramData);
			System.out.println ("UPDATE01  : "+rtn);
			
			ServletContext sc = getServletContext();            
			RequestDispatcher rd = sc.getRequestDispatcher("/board/detail_view.jsp?listNum="+ listNum + "&pageGb=" + pageGb+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type);
			rd.forward(request, response);
			
		}else{					// 게시배포확인 이미 처리완료
			System.out.println ("noWork  : "+rtn);
			
			ServletContext sc = getServletContext();            
			RequestDispatcher rd = sc.getRequestDispatcher("/board/detail_view.jsp?listNum="+ listNum + "&pageGb=" + pageGb+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type);
			rd.forward(request, response);
		}
		
	}else if(pageGb.equals("11") || pageGb.equals("12")) // 건의&요청 게시판
	{
		rtn = dao.deleteProposal(paramData);	//글 삭제
		System.out.println ("DELETE_11  : "+rtn);
		if(rtn > 0){
			rtn += dao.deleteProposalFile(paramData);	//첨부파일 삭제
			System.out.println ("DELETE_FILE  : "+rtn);
		}
		out.println("<script>alert('삭제되었습니다.');</script>");
		out.println("<script>location.href='"+ root +"/board/list.jsp?pageGb=" + pageGb+"&listNum="+listNum+"&inCurPage="+inCurPage+"&inCurBlock="+inCurBlock+"&hit="+hit+"&srch_key="+srch_key+"&srch_type="+srch_type+"'</script>");
		
		
	}

	
%>
