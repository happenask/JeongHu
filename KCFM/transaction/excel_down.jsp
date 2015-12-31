<%
/** ############################################################### */
/** Program ID   : excel_down.jsp                                   */
/** Program Name : 거래내역 > 카드승인내역 > 엑셀다운로드 하기      */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */
%>

<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.BoardConstant" %>
<%@ page import="transaction.dao.tranDao" %>
<%@ page import="transaction.beans.tranBean" %>
<%@ include file="/com/common.jsp"%>

<%
String root = request.getContextPath();

	paramData.put("기업코드"  , (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"  , (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드", (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드",   (String)session.getAttribute("sseCustStoreCd"));
	paramData.put("매장명"    , (String)session.getAttribute("sseCustStoreNm"));
	
	String sseGroupCd     = JSPUtil.chkNull((String)session.getAttribute("sseGroupCd"    ),"");  //기업코드
	String sseCorpCd      = JSPUtil.chkNull((String)session.getAttribute("sseCorpCd"     ),"");  //법인코드
	String sseBrandCd     = JSPUtil.chkNull((String)session.getAttribute("sseBrandCd"    ),"");  //브랜드코드
	String sseCustStoreCd = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreCd"),"");  //매장코드
	String sseCustNm      = JSPUtil.chkNull((String)session.getAttribute("sseCustNm"     ),"");  //등록자명
	String sseCustStoreNm = JSPUtil.chkNull((String)session.getAttribute("sseCustStoreNm"),"");  //매장명
	
	/* paramData.put("inDate", request.getParameter("i_indate")); */
	String inDate    = JSPUtil.chkNull((String)request.getParameter("i_inDate" ),"");    //include변수
	String sDate     = JSPUtil.chkNull((String)request.getParameter("sDateExcel"    ),"");    //시작일자
	String eDate     = JSPUtil.chkNull((String)request.getParameter("eDateExcel"    ),"");    //종료일자
	
	int i_sDate      = Integer.parseInt(sDate);
	int i_eDate      = Integer.parseInt(eDate);
	
	System.out.println("transactional-info-excel_down===========================");
	System.out.println("include변수 : " + inDate);
	System.out.println("시작일자    : " + sDate);
	System.out.println("종료일자    : " + eDate);
	System.out.println("========================================================");
	
	String sYear  = inDate.substring(0, 4);
	String sMonth = inDate.substring(4);
	
	 String curTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
	 String CurDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

	tranBean bean  = new tranBean(); //내용보기 에서 담을 빈
	tranDao  dao   = new tranDao();
	
	ArrayList<tranBean> list1       = null;
	ArrayList<tranBean> list2       = null;
	ArrayList<tranBean> list3       = null;
	ArrayList<tranBean> listSum     = null;
	ArrayList<tranBean> corpNumlist = null;
	String corpNum                  = ""; 
	
	if("테스트".equals(sseCustNm)){
		
	}else{
		
		corpNumlist = dao.selectCorpNumList(paramData);   //사업자번호조회
		if( corpNumlist != null && corpNumlist.size() > 0 ) 
		{
				bean = (tranBean) corpNumlist.get(0);
				corpNum = bean.get사업자번호();
		}
		
	} 

	String sOut = "";
	sOut = sOut + "<table border='0' style='width:880'> ";
	sOut = sOut + "  <tr>";
	sOut = sOut + "  	<td colspan='8'> <header><h1 align='center'><span> 카드승인내역  </sapn></h1></header> </td>";
	sOut = sOut + "  </tr>";
	sOut = sOut + "  <tr>";
	sOut = sOut + "  	<td align='right'> 가맹점명 :     </td> <td colspan='3'> "+ sseCustStoreNm +"["+ JSPUtil.chkNull((String)corpNum,"")+"]"+" </td>";
	sOut = sOut + "  	<td align='right'> 대표자 :  </td> <td colspan='3'> "+ sseCustNm +" </td>";
	sOut = sOut + "  </tr>";
	sOut = sOut + "  <tr>";
	sOut = sOut + "  	<td align='right'> 조회기간 : </td> <td colspan='3' align='left'> "+ sDate +" ~ "+ eDate +" </td>";
	sOut = sOut + "  	<td align='right'> 출력일자 : </td> <td colspan='3' align='left'> "+ CurDate +" </td>";
	sOut = sOut + "  </tr>";
	sOut = sOut + "</table>";
	sOut = sOut + "<table id='data-t4' width='920px' height='320' bgcolor='#c6c6c6' border='1' cellpadding='1' cellspacing='1' style='width:880'>";
	sOut = sOut + "  <caption style='text-align: right;'>단위 : 건,원 </caption>";
	sOut = sOut + "  <tr bgcolor='#b2b19c' align='center'>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979; width:100' > <font color='#ffffff'><b>거래년월</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979; width:100' > <font color='#ffffff'><b>구분    </b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979; width:100' > <font color='#ffffff'><b>카드사  </b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979; width:100' > <font color='#ffffff'><b>건수    </b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979; width:120' > <font color='#ffffff'><b>공급가액</b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979; width:120' > <font color='#ffffff'><b>세액    </b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979; width:120' > <font color='#ffffff'><b>봉사료  </b></font></th>";
	sOut = sOut + "    <th style='border-bottom: 1px solid #797979; width:120' > <font color='#ffffff'><b>매출액  </b></font></th>";
	sOut = sOut + "  </tr>";
	
	for(int iLoop=i_sDate; iLoop<=i_eDate; iLoop++){
		
		inDate = Integer.toString(iLoop);
		paramData.put("inDate", inDate);
		
		
		if("테스트".equals(sseCustNm)){
			list1 = dao.selectTranMonthList1Test(paramData);     //카드 거래내역 해당월 조회 테스트용 (거래구분:01,02,04)
			//list2 = dao.selectTranMonthList2Test(paramData);   //현금 거래내역 해당월 조회 테스트용
			list3 = dao.selectTranMonthList3Test(paramData);     //현금영수증 거래내역 해당월 조회 테스트용 (거래구분:03)
			listSum = dao.selectTranMonthListSumTest(paramData); //거래내역 해당월 합계 조회 테스트용
		}else{
			corpNumlist = dao.selectTranMonthList1(paramData);   //사업자번호조회
			if( corpNumlist != null && corpNumlist.size() > 0 ) 
			{
					bean = (tranBean) corpNumlist.get(0);
					corpNum = bean.get사업자번호();
			}
			
			list1 = dao.selectTranMonthList1(paramData);     //카드 거래내역 해당월 조회 테스트용 (거래구분:01,02,04)
			//list2 = dao.selectTranMonthList2(paramData);       //현금 거래내역 해당월 조회
			list3 = dao.selectTranMonthList3(paramData);         //현금영수증 거래내역 해당월 조회 (거래구분:03)
			listSum = dao.selectTranMonthListSum(paramData);     //거래내역 해당월 합계 조회
		}
		
		//카드별 조회 (거래구분 : 01, 02, 04)
		if( list1 != null && list1.size() > 0 ) 
		{
			for( int i = 0; i < list1.size(); i++ ) 
			{
				bean = (tranBean) list1.get(i);
				
				if(i==0){
					sOut = sOut + "  <tr class='data' align='center' bgcolor='#ffffff'>";
					sOut = sOut + "    <td rowspan="+(list1.size()+2)+"><b>"+ inDate +"</b></td>";
					sOut = sOut + "    <td rowspan="+list1.size()+"><b>[카드]</b></td>";
					sOut = sOut + "    <td>"+bean.get카드발급사명()+"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get승인건수(),"")+"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get공급가액(),"")+"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get부가세(),"")  +"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get봉사료(),"")  +"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get매출액(),"")  +"</td>";
					sOut = sOut + "  </tr>";
				}else{
					sOut = sOut + "  <tr class='data' align='center' bgcolor='#ffffff'>";
					sOut = sOut + "    <td>"+bean.get카드발급사명()+"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get승인건수(),"")+"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get공급가액(),"")+"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get부가세(),"")  +"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get봉사료(),"")  +"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get매출액(),"")  +"</td>";
					sOut = sOut + "  </tr>";
				}
			}
		} else {
			sOut = sOut + "  <tr class='data' align='center' bgcolor='#ffffff'>";
			sOut = sOut + "     <td rowspan='3'><b>"+ inDate +"</b></td>";
			sOut = sOut + "  	<td><b>[카드]</b></td>";
			sOut = sOut + "  	<td colspan='6'>조회된 내용이 없습니다.</td></tr>";
			sOut = sOut + "  </tr>";
		}
		
		//현금영수증 조회 (거래구분 : 03)
		if( list3 != null && list3.size() > 0 ) 
		{
			for( int i = 0; i < list3.size(); i++ ) 
			{
				bean = (tranBean) list3.get(i);
				
					sOut = sOut + "  <tr class='data' align='center' bgcolor='#ffffff'>";
					sOut = sOut + "    <td rowspan="+list3.size()+"><b>[현금영수증]</b></td>";
					sOut = sOut + "    <td></td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get승인건수(),"")+"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get공급가액(),"")+"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get부가세(),"")  +"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get봉사료(),"")  +"</td>";
					sOut = sOut + "    <td align='right'>"+JSPUtil.chkNull((String)bean.get매출액(),"")  +"</td>";
					sOut = sOut + "  </tr>";
			}
		} else {
			sOut = sOut + "  <tr class='data' align='center' bgcolor='#ffffff'>";
			sOut = sOut + "  	<td><b>[현금영수증]</b></td>";
			sOut = sOut + "  	<td colspan='6'>조회된 내용이 없습니다.</td></tr>";
			sOut = sOut + "  </tr>";
		}
		
		if(listSum  != null && listSum.size() > 0 ) 
		{
			for( int i = 0; i < listSum.size(); i++ ) 
			{
				bean = (tranBean) listSum.get(i);
				
					sOut = sOut + "  <tr class='data' align='center' bgcolor='#ffffff'>";
					sOut = sOut + "    <td style='border-top: 1px solid #797979; background-color: #BDBDBD;'><b>[합계]</b></td>";
					sOut = sOut + "    <td style='border-top: 1px solid #797979; background-color: #BDBDBD;'></td>";
					sOut = sOut + "    <td align='right' style='border-top: 1px solid #797979; background-color: #BDBDBD;'>"+JSPUtil.chkNull((String)bean.get승인건수(),"")+"</td>";
					sOut = sOut + "    <td align='right' style='border-top: 1px solid #797979; background-color: #BDBDBD;'>"+JSPUtil.chkNull((String)bean.get공급가액(),"")+"</td>";
					sOut = sOut + "    <td align='right' style='border-top: 1px solid #797979; background-color: #BDBDBD;'>"+JSPUtil.chkNull((String)bean.get부가세(),"")  +"</td>";
					sOut = sOut + "    <td align='right' style='border-top: 1px solid #797979; background-color: #BDBDBD;'>"+JSPUtil.chkNull((String)bean.get봉사료(),"")  +"</td>";
					sOut = sOut + "    <td align='right' style='border-top: 1px solid #797979; background-color: #BDBDBD;'>"+JSPUtil.chkNull((String)bean.get매출액(),"")  +"</td>";
					sOut = sOut + "  </tr>";
			}
		} else {
			sOut = sOut + "  <tr class='data' align='center' bgcolor='#ffffff'>";
			sOut = sOut + "  	<td style='border-top: 1px solid #797979; background-color: #BDBDBD;'><b>[합계]</b></td>";
			sOut = sOut + "  	<td style='border-top: 1px solid #797979; background-color: #BDBDBD;' colspan='6'>조회된 내용이 없습니다.</td></tr>";
			sOut = sOut + "  </tr>";
		}
		
		//12월이 되면 다음해 1월로 가도록 추가함. 
		String s_loop = Integer.toString(iLoop);
		s_loop = s_loop.substring(4);
		if("12".equals(s_loop)){
			iLoop = iLoop + 100 - 12;
		}
	
	}

	sOut = sOut + "</table>";
	
	out.print("<script language=javascript>");
	out.print("  parent.fnSaveExcel(\""+sOut+"\");");
	out.print("</script>");
%>
