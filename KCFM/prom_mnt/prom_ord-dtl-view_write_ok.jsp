 <%
/** ############################################################### **/
/** Program ID   : prom_ord-dtl-view_write_ok.jsp                   */
/** Program Name : 홍보물 주문상세내역 저장                                           */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@page import="com.oreilly.servlet.multipart.MultipartParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.util.BoardConstant" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>

<%@ page import="prom.beans.orderBean" %> 
<%@ page import="prom.dao.orderDao" %>

<%@ include file="/com/common.jsp"%>

<% 

	String root = request.getContextPath();
    
	orderBean bean = null; 
	orderDao  dao  = new orderDao();
	String   msg  = "";
	int rtn = 0;
	
	String param_name   = "";
	String param_value  = "";
	String name			= "";
	String filename		= "";
	String original		= "";
	String type			= "";
	
	request.setCharacterEncoding("UTF-8");
	String encType = "UTF-8";

	// 파일저장위치 경로
	BoardConstant bCont = new BoardConstant();

	String 	saveFolder 	= bCont.PROMPATH ;				//저장위치
	int 	maxSize 	= bCont.PROMSIZE;				//파일최대크기(5M)
	
	//saveFolder = "D:/PACKAGE_WORKSPACE/workspace(pos)_2015/KCFM/WebContent/filestorage/prom";
	
	try{
		
		MultipartRequest multi = new MultipartRequest(request, saveFolder, maxSize, encType, new DefaultFileRenamePolicy()) ;

		String sseCustId      = JSPUtil.chkNull((String)session.getAttribute("sseCustId"  ),""); //사용자ID
		String sseCustAuth    = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth"  ),""); //권한코드
		
		String hGroupCd       = JSPUtil.chkNull((String)multi.getParameter("hGroupCd"     ),""); //기업코드
		String hCorpCd        = JSPUtil.chkNull((String)multi.getParameter("hCorpCd"      ),""); //법인코드
		String hBrandCd       = JSPUtil.chkNull((String)multi.getParameter("hBrandCd"     ),""); //브랜드코드
		String hCustStoreCd   = JSPUtil.chkNull((String)multi.getParameter("hCustStoreCd" ),""); //매장코드
		String hOrderNo       = JSPUtil.chkNull((String)multi.getParameter("hOrderNo"     ),""); //주문번호
		String hProgression1  = JSPUtil.chkNull((String)multi.getParameter("hProgression1"),""); //진행상태
		String hPrintTxt      = JSPUtil.chkNull((String)multi.getParameter("hPrintTxt"    ),""); //인쇄문구
		String hRequestTxt    = JSPUtil.chkNull((String)multi.getParameter("hRequestTxt"  ),""); //요청사항
		String hPromFlyerNo   = JSPUtil.chkNull((String)multi.getParameter("hPromFlyerNo" ),""); //홍보물시안번호
		String hInsertUserId  = JSPUtil.chkNull((String)multi.getParameter("hInsertUserId"),""); //수정자ID
		String modYn1         = JSPUtil.chkNull((String)multi.getParameter("modYn1"), "N"); //첨부파일 수정여부
		
		
		hPrintTxt   = URLDecoder.decode(hPrintTxt,   "UTF-8");
		hRequestTxt = URLDecoder.decode(hRequestTxt, "UTF-8");
		
// 		System.out.println("------------------------------[홍보물주문내역 상세 조회 팝업 정보 저장]-----------------------------");
// 		System.out.println("#### sseCustId     : " + sseCustId    );
// 		System.out.println("#### sseCustAuth   : " + sseCustAuth  );
// 		System.out.println("#### hGroupCd      : " + hGroupCd     );
// 		System.out.println("#### hCorpCd       : " + hCorpCd      );
// 		System.out.println("#### hBrandCd      : " + hBrandCd     );
// 		System.out.println("#### hCustStoreCd  : " + hCustStoreCd );
// 		System.out.println("#### hOrderNo      : " + hOrderNo     );
// 		System.out.println("#### hProgression1 : " + hProgression1);
// 		System.out.println("#### hPrintTxt     : " + hPrintTxt    );
// 		System.out.println("#### hRequestTxt   : " + hRequestTxt  );
// 		System.out.println("#### hPromFlyerNo  : " + hPromFlyerNo );
// 		System.out.println("#### hInsertUserId : " + hInsertUserId );
// 		System.out.println("#### modYn1        : " + modYn1 );
		
		paramData.put("sseCustId"     , sseCustId      );
		paramData.put("sseCustAuth"   , sseCustAuth    );
		paramData.put("hGroupCd"      , hGroupCd       );
		paramData.put("hCorpCd"       , hCorpCd        );
		paramData.put("hBrandCd"      , hBrandCd       );
		paramData.put("hCustStoreCd"  , hCustStoreCd   );
		paramData.put("hOrderNo"      , hOrderNo       );
		paramData.put("hProgression1" , hProgression1  );
		paramData.put("hPrintTxt"     , hPrintTxt      );
		paramData.put("hRequestTxt"   , hRequestTxt    );
		paramData.put("hPromFlyerNo"  , hPromFlyerNo   );
		paramData.put("hInsertUserId" , hInsertUserId  );
		paramData.put("modYn1" ,        modYn1  );
		
		Enumeration<String> files = multi.getFileNames();
		
		while(files.hasMoreElements()){
			name = files.nextElement();
			filename = multi.getFilesystemName(name);
			original = multi.getOriginalFileName(name);
			type = multi.getContentType(name);
			
			File f = multi.getFile(name);
			
			if(f!=null){

				paramData.put("fileName"	,filename           );
				paramData.put("orgFileName"	,original           );
				paramData.put("filePath"    ,saveFolder         );
				
				paramData.put("hPromFlyerNo"  , ""   			);		// 파일이 있으면 신규 번호를 생성하게끔 ""를 넘긴다.
				
// 				System.out.println("#### fileName : "+filename);
// 				System.out.println("#### orgFileName : "+original);
// 				System.out.println("#### filePath : "+saveFolder);
// 				System.out.println("#### fileNum : "+name.substring(10));
			
			}
			
			//홍보물시안정보 저장
			
			rtn = dao.insertPromFlyerInfo(paramData);
			
			if(rtn == 1){
				rtn = dao.updatePromOrdrInfo(paramData);
			}
			
			if(rtn == 1){
				msg = "등록 성공했습니다.";
			}else{
				msg = "등록 실패했습니다.!";
			}
		}
		
		
	}catch(Exception e){
		
		msg = "등록 실패했습니다.!";
		e.printStackTrace();
	}
	
	out.print("<script type='text/javascript'>");
	out.print("  parent.fnSavePopUpResult( \""+ msg +"\")");
	out.print("</script>");
	
%>