<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.util.JSPUtil" %><%//JSP 공통 유틸 %>
<%@ page import="com.util.CommUtil" %><%//JSP 공통 유틸 %>
<%@ page import="prom.dao.deliveryDao" %>
<%@ page import="prom.beans.deliveryBean" %>
<%@ page import="com.util.BoardConstant" %>
<%@ include file="/com/common.jsp"%>

<%
	String root = request.getContextPath();

    //-------------------------------------------------------------------------------------------------------
	// Session 정보
	//-------------------------------------------------------------------------------------------------------
	paramData.put("기업코드"	, (String)session.getAttribute("sseGroupCd"));
	paramData.put("법인코드"	, (String)session.getAttribute("sseCorpCd"));
	paramData.put("브랜드코드"	, (String)session.getAttribute("sseBrandCd"));
	paramData.put("매장코드"	, (String)session.getAttribute("sseCustStoreCd"));
	
	System.out.println("==============================================");
	System.out.println("최근배송지 조회(delivery_select.jsp) >>>>>>>>>>>>>>>>>>>>>>>>>>>");
	System.out.println("기업코드		: "+paramData.get("기업코드"));
	System.out.println("법인코드		: "+paramData.get("법인코드"));
	System.out.println("브랜드코드		: "+paramData.get("브랜드코드"));
	System.out.println("매장코드		: "+paramData.get("매장코드"));
	System.out.println("==============================================");

	//-------------------------------------------------------------------------------------------------------
	//  조회대상 자료에 대한 처리
	//-------------------------------------------------------------------------------------------------------
	deliveryBean bean = null;
	deliveryBean deliveryBean  = new deliveryBean(); //내용보기 에서 담을 빈
	deliveryDao  deliveryDao   = new deliveryDao();
	ArrayList<deliveryBean> list = null;   
	
	list = deliveryDao.selectList(paramData);//조회조건에 맞는 배송지 정보 조회
	
%>


<!DOCTYPE html>
<html>
<head>
<!-- 공용정의파일 -->
<%@ include file="/include/common_file.inc" %>
	<title>홍보물신청- 배송지 선택</title>  
     
    <script type="text/javascript">
   
	// 호출한 부모창에서 처리!!
    /* function send(post_seq, name, zipcode1, zipcode2, address1, address2, cellPhone, phoneNum){
		// 배송지번호. 수취인이름, 우편번호1,우편번호2, 우편주소, 상세주소, 수취인휴대전화번호, 수취인전화번호
		// post_seq, name, zipcode1, zipcode2, address1, address2, cellPhone, phoneNum
		
		var frm = opener.document.formdata;

		frm.OrderAddrSeq.value 		= post_seq;
		frm.order_name.value 		= name;
		frm.order_zip_1.value 		= zipcode1;
		frm.order_zip_2.value 		= zipcode2;
		frm.order_base.value  		= address1;
		frm.order_detail.value		= address2;
		frm.order_cellPhone.value 	= cellPhone;
		frm.order_phoneNum.value 	= phoneNum;
		
		window.moveTo(1000,1000);
		self.close();
    } */
    </script>
</head>

<body>
		<form id="formdata" name="formdata" method="post">
			<input type="hidden" name="GroupCd"     value="<%=paramData.get("기업코드")%>"/>
			<input type="hidden" name="CorpCd"      value="<%=paramData.get("법인코드")%>"/>
			<input type="hidden" name="BrandCd"     value="<%=paramData.get("브랜드코드")%>"/>
			<input type="hidden" name="CustStoreCd" value="<%=paramData.get("매장코드")%>"/>

		 	<div class="delivery-div">
	        	<p class="bold">고객님께서 최근 주문하신 배송 정보입니다. <span>선택하실 배송지 목록의 이름 또는 주소를 클릭하세요!</span></p>
				<div id="delivery-data" class="table">
	        		<table id="delivery-list" width="880" bgcolor="#c6c6c6" border="0" cellpadding="1" cellspacing="1" > 
	        				<colgroup>
	        					<col width="140"></col>
	        					<col width="460"></col>
	        					<col width="140"></col>
	        					<col width="140"></col>
	        				</colgroup>
	        				<thead>
				  				<tr>
									<th><b>수취인 이름</b></th>
									<th><b>배송지 주소</b></th>
									<th><b>수취인 휴대전화</b></th>
									<th><b>수취인 전화번호</b></th>
								</tr>
							</thead>
							<tbody>
				<%
						int inSeq = 0;
							
						String title = "";
							
						if( list != null && list.size() > 0 ) 
						{
							for( int i = 0; i < list.size(); i++ ) 
							{
								bean = (deliveryBean) list.get(i);
						%>
								<tr>
				      				<td class="txt-cnt">
				      					<a href="javaScript:send('<%=bean.get배송지번호()%>','<%=bean.get수취인이름()%>','<%=bean.get우편번호().substring(0, 3)%>','<%=bean.get우편번호().substring(3)%>','<%=bean.get우편주소()%>','<%=bean.get상세주소()%>','<%=bean.get수취인휴대전화번호()%>','<%=bean.get수취인전화번호()%>')">
				      					<%=bean.get수취인이름()%>
				      					</a>
				      				</td>
				      				<td class="txt-left pd-l5">
				      					<a href="javaScript:send('<%=bean.get배송지번호()%>','<%=bean.get수취인이름()%>','<%=bean.get우편번호().substring(0, 3)%>','<%=bean.get우편번호().substring(3)%>','<%=bean.get우편주소()%>','<%=bean.get상세주소()%>','<%=bean.get수취인휴대전화번호()%>','<%=bean.get수취인전화번호()%>')">
				      					(<%=bean.get우편번호().substring(0, 3)%>-<%=bean.get우편번호().substring(3)%>) <span><%=bean.get우편주소()%></span><span> <%=bean.get상세주소()%></span>
				      					</a>
				      				</td>
				      				<td class="txt-cnt"><%=bean.get수취인휴대전화번호()%></td>
				      				<td class="txt-cnt"><%=bean.get수취인전화번호()%></td>
			      				</tr>
		      		<%
		      					inSeq--;
							}
						} 
						else 
						{
		      		%>
					      		<tr>
						      		<td colspan="4">조회된 내용이 없습니다.</td>
						      	</tr>
					<%
						}
			
					%>
						</tbody>
					</table> 
				</div>
			</div>
		</form>
</body>
<iframe name="iWorker" style="width:0;height:0;border:0;"></iframe>
</html>
