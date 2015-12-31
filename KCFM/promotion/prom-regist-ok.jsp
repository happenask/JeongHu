
<%
/** ############################################################### */
/** Program ID   : prom-regist-ok.jsp                               */
/** Program Name : 홍보물 저장 										*/
/** Program Desc : 홍보물 신규 처리				                    */
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
		log4u.log("CALL /prom-regist-ok.jsp");		
		
		String root = request.getContextPath();
		
		//--------------------------------------------------------------------------------------------------
		// Session 정보
		//--------------------------------------------------------------------------------------------------
		
		String sGroupCode      = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"  ),""); //기업코드
		String sCorpCode       = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"   ),""); //법인코드
		String sBrandCode      = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"  ),""); //브랜드코드
		String sCustAuth       = JSPUtil.chkNull((String)session.getAttribute("sseCustAuth" ),""); //권한코드
		String sCustLoginNm    = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"   ),""); //등록자명

		//-------------------------------------------------------------------------------------------------------
		//  Bean 및 Dao 처리
		//-------------------------------------------------------------------------------------------------------
		
		promMntBean bean = null;
		promMntDao dao = new promMntDao();
		
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
		
		//--------------------------------------------------------------------------------------------------
		// 파라미터 인코딩
		//--------------------------------------------------------------------------------------------------
		
		request.setCharacterEncoding("UTF-8");
		String encType = "UTF-8";
	
		//--------------------------------------------------------------------------------------------------
		// 파일저장위치 경로
		//--------------------------------------------------------------------------------------------------
		
		BoardConstant bCont = new BoardConstant();
		String 	saveFolder 	= bCont.PROMPATH ;				//저장위치
		int 	maxSize 	= bCont.PROMSIZE;				//파일최대크기(5M)
		String 	saveFolder2 = bCont.PROMPATH2 ;				//이미지경로
	
		
		try{
				//--------------------------------------------------------------------------------------------------
				// Parameter 정보
				//--------------------------------------------------------------------------------------------------
				MultipartRequest multi = new MultipartRequest(request, saveFolder, maxSize, encType, new DefaultFileRenamePolicy()) ;
				
				String sEvent		= JSPUtil.chkNull((String)multi.getParameter("inEvent"),""); 			//이벤트구분
				String sOptGroup	= JSPUtil.chkNull((String)multi.getParameter("inCompanyCd"),""); 		//기업코드
				String sOptCorp		= JSPUtil.chkNull((String)multi.getParameter("inCorpCd"),""); 			//법인코드
				String sOptBrand	= JSPUtil.chkNull((String)multi.getParameter("inBrandCd"),""); 			//브랜드코드
				String sOptBigClass	= JSPUtil.chkNull((String)multi.getParameter("inBigClass"),""); 		//대분류코드
				String sOptMidClass	= JSPUtil.chkNull((String)multi.getParameter("inMidClass"),""); 		//중분류코드
				String sPromNo		= JSPUtil.chkNull((String)multi.getParameter("inPromNo"),""); 			//홍보물번호
				String sPromNm		= URLDecoder.decode(JSPUtil.chkNull((String)multi.getParameter("inPromNm"),""), "UTF-8"); //홍보물명
				String sPromType	= JSPUtil.chkNull((String)multi.getParameter("inPromType"),""); 		//홍보물타입
				String sPromSize    = JSPUtil.chkNull((String)multi.getParameter("inPromSize"),""); 		//홍보물사이즈
				String sOrdCoun		= JSPUtil.chkNull((String)multi.getParameter("inOrdCoun"),""); 			//주문수량
				String sOptOrdUnit	= JSPUtil.chkNull((String)multi.getParameter("inOptOrdUnit"),""); 		//주문단위
				String sOrdPrice	= JSPUtil.chkNull((String)multi.getParameter("inOrdPrice"),""); 		//단가
				String sOptPromotion = URLDecoder.decode(JSPUtil.chkNull((String)multi.getParameter("inOptPromotion"),""), "UTF-8"); //홍보물업체(홍보물업체코드, 전화번호포함.)
				String[] pOptPromotion  = sOptPromotion.split(",");  //홍보물업체(배열처리)

				String mode1           = JSPUtil.chkNull((String)multi.getParameter("mode1"       ),""); //삭제여부 파라미터(del1)
				String mode2           = JSPUtil.chkNull((String)multi.getParameter("mode2"       ),""); //삭제여부 파라미터(del2)
				String mode3           = JSPUtil.chkNull((String)multi.getParameter("mode3"       ),""); //삭제여부 파라미터(del3)
				
				String StartDate 	= JSPUtil.chkNull((String)multi.getParameter("sDate"),""); //조회시작일자
				String EndDate   	= JSPUtil.chkNull((String)multi.getParameter("eDate"),""); //조회종료일자
				int inCurPage      = Integer.parseInt(JSPUtil.chkNull((String)multi.getParameter("inCurPage"),  "1"));
				
			
				System.out.println ("prom-regist-ok========================================");
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
				System.out.println ("sPromNm          : " + sPromNm     	);
				System.out.println ("sPromType        : " + sPromType      	);
				System.out.println ("sPromSize        : " + sPromSize       );
				System.out.println ("sOrdCoun         : " + sOrdCoun        );
				System.out.println ("sOptOrdUnit      : " + sOptOrdUnit     );
				System.out.println ("sOrdPrice        : " + sOrdPrice       );
				System.out.println ("sOptPromotion    : " + sOptPromotion   );
				
				System.out.println ("mode1          : " + mode1           );
				System.out.println ("mode2          : " + mode2           );
				System.out.println ("mode3          : " + mode3           );
				
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
				paramData.put("홍보물명",     			sPromNm         );
				paramData.put("인쇄사용문구포함여부",   sPromType       );
				paramData.put("이미지경로"          ,   saveFolder2     );
				paramData.put("사이즈",     			sPromSize       );
				paramData.put("수량",     				sOrdCoun        );
				paramData.put("단위",     				sOptOrdUnit     );
				paramData.put("매출단가",     			sOrdPrice       );
				paramData.put("홍보물업체코드",    		pOptPromotion[0]);
				paramData.put("홍보물업체전화번호",    	pOptPromotion[1]);
			    paramData.put("조회시작일자"  , 		StartDate       );
			    paramData.put("조회종료일자"  , 		EndDate         );
				paramData.put("inCurPage",      	    inCurPage       );
				

				//--------------------------------------------------------------------------------------------------
				// 파일명 수정 여부
				//--------------------------------------------------------------------------------------------------
				paramData.put("mode1", mode1);
				paramData.put("mode2", mode2);
				paramData.put("mode3", mode3);
				
				//--------------------------------------------------------------------------------------------------
				// 파일명 조립
				//--------------------------------------------------------------------------------------------------		

				Enumeration<String> files = multi.getFileNames();
				
				int fNumCnt = 0;
				
				while(files.hasMoreElements()){
					fNumCnt++;
					
					name = files.nextElement();
					filename = multi.getFilesystemName(name);
					original = multi.getOriginalFileName(name);
					type = multi.getContentType(name);
					

					System.out.println("=======================");
					System.out.println("fNumCnt :"+fNumCnt);
					System.out.println("파라미터 이름 :"+name);
					System.out.println("저장된 파일 이름 :"+filename);
					System.out.println("실제파일 이름 :"+original);
					System.out.println("이미지 경로:"+saveFolder);
					System.out.println("이미지 경로(DB용):"+saveFolder2);
					System.out.println("파일타입 : "+type);
					System.out.println("f : "+multi.getFile(name));
					System.out.println("=======================");
					
					
					File f = multi.getFile(name);
					
					if(f!=null){
						

						paramData.put("fileName"	,filename     );
						paramData.put("orgFileName"	,original     );
						paramData.put("filePath"    ,saveFolder   );
						/* paramData.put("fileNum"     ,name.substring(10)); */
						String sfNumCnt = Integer.toString(fNumCnt);
						paramData.put("fileNum"     ,sfNumCnt );
						
						
						if(name.equals("attachFile1")) 		//attachFile1 : 이미지표지파일
						{
							paramData.put("이미지표지실제파일명",original);
							paramData.put("이미지표지파일명",filename);
							paramData.put("이미지표지파일타입",type);
							paramData.put("이미지표지파일크기",f.length()+"byte");
							
							System.out.println("이미지표지실제파일명:"+original+"<br/>"); 	
							System.out.println("이미지표지파일명:"+filename+"<br/>"); 	
							System.out.println("이미지표지파일타입:"+type+"<br/>"); 	
							System.out.println("이미지표지파일크기:"+f.length()+"byte<br/>"); 	
							
						}
						else if(name.equals("attachFile2"))		//attachFile2 : 이미지앞면파일명
						{
							paramData.put("이미지앞면실제파일명",original);
							paramData.put("이미지앞면파일명",filename);
							paramData.put("이미지앞면파일타입",type);
							paramData.put("이미지앞면파일크기",f.length()+"byte");
							
							System.out.println("이미지앞면실제파일명:"+original+"<br/>"); 	
							System.out.println("이미지앞면파일명:"+filename+"<br/>"); 	
							System.out.println("이미지앞면파일타입:"+type+"<br/>"); 	
							System.out.println("이미지앞면파일크기:"+f.length()+"byte<br/>"); 	
						}
						else if(name.equals("attachFile3"))		//attachFile3 : 이미지뒷면파일명
						{
							paramData.put("이미지뒷면실제파일명",original);
							paramData.put("이미지뒷면파일명",filename);
							paramData.put("이미지뒷면파일타입",type);
							paramData.put("이미지뒷면파일크기",f.length()+"byte");
							
							System.out.println("이미지뒷면실제파일명:"+original+"<br/>"); 	
							System.out.println("이미지뒷면파일명:"+filename+"<br/>"); 	
							System.out.println("이미지뒷면파일타입:"+type+"<br/>"); 	
							System.out.println("이미지뒷면파일크기:"+f.length()+"byte<br/>"); 	
						}
						
					}//end if
				} //end while
					
				//-------------------------------------------------------------------------------------------------------
				//  홍보물정보에 대한 INSERT 처리
				//-------------------------------------------------------------------------------------------------------
				if(sEvent.equals("new")){
					rtn = dao.insertWrite(paramData);
					System.out.println ("insertWrite  : "+rtn);
					event = "저장";
				}else  if(sEvent.equals("mod")){
					rtn = dao.updateWrite(paramData);
					System.out.println ("updateWrite  : "+rtn);
					event = "수정";
				}
			
				response.sendRedirect(root+"/promotion/prom-dtl.jsp?inCurPage="+inCurPage+"&sDate="+StartDate+"&eDate="+EndDate);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
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