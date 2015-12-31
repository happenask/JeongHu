<%
	/** ############################################################### */
	/** Program ID   : admin-writing_ok.jsp                             */
	/** Program Name : 글저장                                          							*/
	/** Program Desc :                                                  */
	/** Create Date  : 2015.04.10                                       */
	/** Programmer   : hojun.choi                                     */
	/** Update Date  : 2015.04.13                                     */
	/** ############################################################### */
%>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="admin.beans.adminBean"%>
<%@ page import="admin.dao.adminDao"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.util.JSPUtil"%>
<%@ include file="/com/common.jsp"%>


<%
	com.util.Log4u log4u = new com.util.Log4u();
	String root = request.getContextPath();
	adminBean bean = null;
	adminDao dao = new adminDao();
	String msg = "";
	int rtn = 0;
	ArrayList<adminBean> list2 = null;

	String listNum = JSPUtil.chkNull( (String) request.getParameter("listNum"), ""); //글 순번//
	paramData.put("listNum", listNum);

	log4u.log("    paramData  :" + paramData  );	
	list2 = dao.selectPartNoticeList(paramData);
	//System.out.println("paramData -ok : "+list2);
	//list2       = dao.selectNoticeList(paramData); //조회조건에 맞는 이벤트 리스트
	//dataBean.setList2(list2);
	System.out.println(" -ok : " + list2);	
%>

<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<!-- modal popup -->
	<div class="overlay-bg-half"></div>
	<!-- 확인점포 popup -->
	<div class="overlay-bg8">
		<div class="dtl-pop" id="store-list">
			<section class="contents admin">
				<header>
					<h3>
						◎ <span>매장별 공지확인여부</span>
					</h3>

					<div id="cont-list" class="list list-wide">
						<p>
						<table>
							
							<thead>
								<tr align="center">
									<th>매장명</th>
									<th>공지확인여부</th>
									<th>공지확인일</th>
									<th>공지확인시간</th>
									<th>대표자명</th>
									<th>전화번호</th>
								</tr>
							</thead>
							<tbody>
								<%

									String title2 = "";

									if (list2 != null && list2.size() > 0) {
										for (int i = 0; i < list2.size(); i++) {
											bean = (adminBean) list2.get(i);

								%>
								<tr align="center">
									<td ><%=bean.get매장코드()%></td>
									<td text-align:center;><%=bean.get확인여부()%></td>
									<td text-align:center;><%=bean.get확인일자()%></td>
									<td text-align:center;><%=bean.get확인시간()%></td>
									<td text-align:center;><%=bean.get확인자()%></td>
									<td text-align:center;><%=bean.get게시번호()%></td>

									<%
											}
										} else {
									%>
								
								<tr>
									<td colspan="5">조회된 내용이 없습니다.</td>
								</tr>
								<%
									}
								%>
							</tbody>
						</table>
						</p>
					</div>
				</header>
			</section>
		</div>
	</div>
	</body>
	</html>
	