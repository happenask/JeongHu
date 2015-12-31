<%
/** ############################################################### */
/** Program ID   : prom-dtl-ok.jsp                					*/
/** Program Name : 홍보물정보조회                                   */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="prom_mnt.beans.promMntBean" %> 
<%@ page import="prom_mnt.dao.promMntDao" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil" %>
<%@ include file="/com/common.jsp"%>

<% 
	
	com.util.Log4u log4u = new com.util.Log4u();

	String root = request.getContextPath();
	
	
	String companyCd = JSPUtil.chkNull((String)request.getParameter("inCompanyCd"), "");
	String corpCd    = JSPUtil.chkNull((String)request.getParameter("inCorpCd"),    "");
	String brandCd   = JSPUtil.chkNull((String)request.getParameter("inBrandCd"),   "");
	String menuCd    = JSPUtil.chkNull((String)request.getParameter("inBigClass"),    "");
	String midMenuCd = JSPUtil.chkNull((String)request.getParameter("inMidClass"),    "");
	String sDate    = JSPUtil.chkNull((String)request.getParameter("insDate"),    "");
	String eDate = JSPUtil.chkNull((String)request.getParameter("ineDate"),    "");
	
	paramData.put("기업코드"			, companyCd);
	paramData.put("법인코드"			, corpCd);
	paramData.put("브랜드코드"			, brandCd);
	paramData.put("홍보물대분류"		, menuCd);
	paramData.put("홍보물코드"			, midMenuCd);
	paramData.put("조회시작일자"		, sDate);
	paramData.put("조회종료일자"		, eDate);
	
	System.out.println(">>>>>>>>>>>>");
	System.out.println("paramData : "+paramData);
	System.out.println(">>>>>>>>>>>>");

	//수정[X]
	//####################################################################################################페이징 관련 변수 시작
	int inCurPage             = Integer.parseInt(JSPUtil.chkNull(request.getParameter("inCurPage"),  "1"));  // 현재 페이지
	int inCurBlock            = Integer.parseInt(JSPUtil.chkNull(request.getParameter("inCurBlock"), "1"));  // 현재 블럭
	int inRowPerPage          = 7;                                                                            // 한페이지당 표시할 레코드 수
	int inPagePerBlock        = 7;                                                                            // 한블럭당 표시할 페이지수
	int inTotalCnt            = 0;                                                                            // 전체 레코드 수
	int inTotalPageCount      = 0;                                                                            // 전체 페이지 수
	int inTotalPageBlockCount = 0;                                                                            // 전체 블럭 수
	int inPrevBlock           = 0;                                                                            // 이전 블럭
	int inNextBlock           = 0;                                                                            // 다음 블럭
	int inPrevPage            = 0;                                                                            // 이전 페이지
	int inNextPage            = 0;                                                                            // 다음 페이지
	//####################################################################################################페이징 관련 변수 끝

	//-------------------------------------------------------------------------------------------------------
	//  홍보물 정보 리스트 조회처리
	//-------------------------------------------------------------------------------------------------------
	promMntBean promMntBean = null; 
	promMntDao  promMntDao  = new promMntDao();
	
	ArrayList<promMntBean> list = null;
	
	list       = promMntDao.selectList(paramData);        //조회조건에 맞는 이벤트 리스트
	inTotalCnt = promMntDao.selectListCount(paramData);   //전체레코드 수
	

	String msg      = "";
	String middleCd = "";
	String middleNm = "";
	
	if( list != null && list.size() > 0 ) 
	{
		for( int i = 0; i < list.size(); i++ ) 
		{
			promMntBean = (promMntBean) list.get(i);
		  
			msg += "<tr>";
			msg += "	<td width='110' class='txt-cnt'>"+promMntBean.get법인명()+"</td>";
			msg += "	<td width='110' class='txt-cnt'>"+promMntBean.get브랜드명()+"</td>";
			msg += "	<td width='130' class='txt-cnt'>"+promMntBean.get대분류명()+"</td>";
			msg += "	<td width='130' class='txt-cnt'>"+promMntBean.get중분류명()+"</td>";
			msg += "	<td width='120' class='txt-cnt'>"+promMntBean.get홍보물번호()+"</td>";
			msg += "	<td width='150' class='txt-cnt'>";
			msg += "		<a href=\"javascript:fnShowListDetail('"+promMntBean.get중분류코드()+"','"+promMntBean.get홍보물번호()+"');\" class='bold' onclick=''>"+promMntBean.get홍보물명()+"</a>";
			msg += "	</td>";
			msg += "	<td width='100' class='txt-cnt'>"+promMntBean.get홍보물타입()+"</td>"; 
			msg += "	<td width='80' class='txt-cnt'>"+promMntBean.get주문단위()+"</td>";
			msg += "	<td width='100' class='txt-prc'>"+promMntBean.get단가()+"</td>";
			if("".equals(promMntBean.get이미지앞면파일명()) || promMntBean.get이미지앞면파일명() == null)
			{ 
				msg += "<td width='60' class='txt-cnt'>없음</button></td>";
			}else{
				msg += "<td width='60' class='txt-cnt'><button class='confirmBtn' id='frn_img_bnt' name='frn_img_bnt' onclick=\"ImgPopup('"+root+"/"+promMntBean.get이미지경로()+promMntBean.get이미지앞면파일명()+"');\">확인</button></td>";
			}
			if("".equals(promMntBean.get이미지뒷면파일명()) || promMntBean.get이미지뒷면파일명() == null){
				msg += "<td width='60' class='txt-cnt'>없음</button></td>";
			}else{
				msg += "<td width='60' class='txt-cnt'><button class='confirmBtn' id='bak_img_bnt' name='bak_img_bnt' onclick=\"ImgPopup('"+root+"/"+promMntBean.get이미지경로()+promMntBean.get이미지뒷면파일명()+"');\">확인</button></td>";
			}
			msg += "	<td width='114' class='txt-cnt'>"+promMntBean.get홍보물업체명()+"</td>";
			msg += "</tr>";
		}
	}else{
			msg += "<tr class='data' align='center' bgcolor=''#ffffff'>";
			msg += "<td colspan='14'>조회된 내용이 없습니다.</td>";
			msg += "</tr>";
	}
	
	out.println(msg);
	System.out.println("홍보물조회리스트 : "+msg);
	
%>
	
