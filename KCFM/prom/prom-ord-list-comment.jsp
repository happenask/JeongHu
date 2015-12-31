<%
/** ###############################################################**/
/** Program ID   : prom-ord-list-comment.jsp                        */
/** Program Name : 댓글 등록, 삭제, 수정                                   */
/** Program Desc : 홍보물신청 > 주문내역확인 > 팝업창(댓글)             */
/** Create Date  : 2015.05.13                                       */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%> 

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.JSPUtil" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="prom.beans.orderBean" %> 
<%@ page import="prom.dao.orderDao" %>
<%@ include file="/com/common.jsp"%>

<%

	String root = request.getContextPath();
	
	orderBean bean = null; 
	orderDao  dao  = new orderDao();
	ArrayList<orderBean> list = null;
	String   msg  = "";
	String   html = "";
	int rtn = 0;
	
	String listGroupCd      = ""; // 기업코드   ;
	String listCorpCd       = ""; // 법인코드   ;
	String listBrandCd      = ""; // 브랜드코드 ;
	String listStoreCd      = ""; // 매장코드   ;
	String listOrderCd      = ""; // 주문번호   ;
	String listCommNum      = ""; // 댓글번호   ;
	String listCommTxt      = ""; // 내용       ;
	String listInsertDate   = ""; // 등록일자   ;
	String listInsertUserId = ""; // 등록자     ;
	
	String gubun            = JSPUtil.chkNull((String)request.getParameter("gubun"        ),"" ); //CRUD 구분값
	String sseCustId        = JSPUtil.chkNull((String)session.getAttribute("sseCustId"    ),"" ); //사용자ID
	String hGroupCd         = JSPUtil.chkNull((String)request.getParameter("GroupCd"      ),"" ); //기업코드
	String hCorpCd          = JSPUtil.chkNull((String)request.getParameter("CorpCd"       ),"" ); //법인코드
	String hBrandCd         = JSPUtil.chkNull((String)request.getParameter("BrandCd"      ),"" ); //브랜드코드
	String hCustStoreCd     = JSPUtil.chkNull((String)request.getParameter("CustStoreCd"  ),"" ); //매장코드
	String hOrderNo         = JSPUtil.chkNull((String)request.getParameter("hOrderNo"     ),"" ); //주문번호
	String hCommTxt         = JSPUtil.chkNull((String)request.getParameter("hCommTxt"     ),"" ); //댓글내용
	String hCommNum         = JSPUtil.chkNull((String)request.getParameter("hCommNum"     ),"0"); //댓글번호
	
	if(!"".equals(hCommTxt)){
		hCommTxt = URLDecoder.decode(hCommTxt, "UTF-8");
	}
	
// 	System.out.println("------------------[홍보물 댓글]----------------------------");
// 	System.out.println("#### gubun        : " + gubun       );
// 	System.out.println("#### sseCustId    : " + sseCustId   );
// 	System.out.println("#### hGroupCd     : " + hGroupCd    );
// 	System.out.println("#### hCorpCd      : " + hCorpCd     );
// 	System.out.println("#### hBrandCd     : " + hBrandCd    );
// 	System.out.println("#### hCustStoreCd : " + hCustStoreCd);
// 	System.out.println("#### hOrderNo     : " + hOrderNo    );
// 	System.out.println("#### hCommTxt     : " + hCommTxt    );
// 	System.out.println("#### hCommNum     : " + hCommNum    );
	
	paramData.put("sseCustId",    sseCustId);      //사용자ID
	paramData.put("hGroupCd",     hGroupCd);       //기업코드
	paramData.put("hCorpCd",      hCorpCd);        //법인코드
	paramData.put("hBrandCd",     hBrandCd);       //브랜드코드
	paramData.put("hCustStoreCd", hCustStoreCd);   //매장코드
	paramData.put("hOrderNo",     hOrderNo);       //주문번호
	paramData.put("hCommTxt",     hCommTxt);       //내용
	
	if("select".equals(gubun)){//조회
		
		list = dao.selectPromOrderComm(paramData); 	
	
		if(list != null && list.size() > 0){
			
			html += "<p  class='count' onclick='showComment();'><span class='mark'>▶</span> 총 댓글 (<span class='num'>"+list.size()+"</span>)</p>  ";
			html += "<ul class='comm_list hidden'>     ";
			
			for(int i=0;i<list.size();i++){
				
				bean = (orderBean) list.get(i);
				
				listGroupCd      = bean.get기업코드();
				listCorpCd       = bean.get법인코드();
				listBrandCd      = bean.get브랜드코드();
				listStoreCd      = bean.get매장코드();
				listOrderCd      = bean.get주문번호();
				listCommNum      = bean.get댓글번호();
				listCommTxt      = bean.get내용();
				listInsertDate   = bean.get등록일자();
				listInsertUserId = bean.get등록자();

				
				html += "<li id='list_"+ listCommNum +"'>";
				html += "<p><span class='writer'>"+ listInsertUserId +"</span><span class='date'>"+ listInsertDate +"</span></p>";
				html += "<span id='comm_btn'>";   
				if(sseCustId.equals(listInsertUserId)){ //댓글 입력자만 수정
					html += "<button  type='button' class='modifyBtn' id='wrBtn'  name='wrBtn'  onclick='goCommWrite(\""+ listCommNum +"\")'></button>";
				}
				html += "</span>";
				html += "<div style='margin-left:20px;'>";
				html += "<div id='comm_text' class='comm'>"+ listCommTxt +"</div> ";
				html += "<textarea cols='70' id='txt"+listCommNum+"' name='txt"+listCommNum+"' class='txt' style='display: none; ' ></textarea>"; //댓글수정입력
				html += "<button  type='button' class='saveBtn'   id='saveBtn'   name='wrBtn'  style='display: none;'   onclick='goCommConfirm(\"" + listCommNum + "\")'></button>";
				html += "<button  type='button' class='closeBtn'  id='closeBtn'  name='closeBtn'  style='display: none;'  onclick='closeComm(\""+ listCommNum +"\")'></button>";
				html += "</div>";
				html += "</li>";
				
			}
			
			html += "</ul>";
			html += "</div>";
		
			out.print(html); //결과
			
		}else{
			
			
			
		}
		
				
	}else if("insert".equals(gubun)){ //등록, 수정
		
		rtn = dao.insertPromOrderComm(paramData);
	
		if(rtn ==1){
			out.print("Y");
		}else{
			out.print("N");
		}
	}
	
	
%>