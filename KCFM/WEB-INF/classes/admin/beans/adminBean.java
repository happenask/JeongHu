package admin.beans;


/** ############################################################### */
/** Program ID   : adminBean.java                                   */
/** Program Name : adminBean                              			*/
/** Program Desc : 관리자 Bean 			                 			*/
/** Create Date  : 2015.04.10                                       */
/** Programmer   : Hojun.Choi                                       */
/** Update Date  :                                                  */
/** ############################################################### */
	
public class adminBean {
	
	private String ROW_NUM            = null;
	private String 기업코드           = null;
	private String 법인코드           = null;
	private String 브랜드코드         = null;
	private String 매장코드           = null;
	private String 매장명             = null;
	private String 매장선택건수       = null;
	
	private String 게시번호           = null;
	private String 게시구분           = null;
	private String 게시시작일자       = null;
	private String 게시종료일자       = null;
	private String 건의요청구분       = null;
	private String 건의요청번호       = null;
	
	private String 제목               = null;
	private String 내용               = null;
	private String 조회수             = null;
	private String 등록자             = null;
	private String 등록일자           = null;
	
	private String 공개여부           = null;
	private String 요청구분           = null;
	private String 요청건수           = null;
	private String 요청답변건수       = null;
	private String 요청상태코드       = null;
	private String 요청상태           = null;
	private String 댓글번호       	  = null;
	private String 댓글내용		      = null;
	private String 공지구분		      = null;
	
	private String 확인자			  = null;
	private String 확인여부		      = null;
	private String 확인일자		      = null;
	private String 배포일자		      = null;
	private String 확인시간		      = null;
	
	private String 파일명             = null;
	private String 원본파일명         = null;
	private String 파일순번           = null;
	private String 상태               = null;
	private String 게시구분코드       = null;
	
	
	
	
	//--------------------------------------------------------------//
	// Generate Getters 
	//--------------------------------------------------------------//
	public String getROW_NUM() {
		return ROW_NUM;
	}
	public String get기업코드() {
		return 기업코드;
	}
	public String get법인코드() {
		return 법인코드;
	}
	public String get브랜드코드() {
		return 브랜드코드;
	}
	public String get매장코드() {
		return 매장코드;
	}
	public String get매장명() {
		return 매장명;
	}
	public String get매장선택건수() {
		return 매장선택건수;
	}
	public String get게시번호() {
		return 게시번호;
	}
	public String get게시구분() {
		return 게시구분;
	}
	public String get게시시작일자() {
		return 게시시작일자;
	}
	public String get게시종료일자() {
		return 게시종료일자;
	}
	public String get건의요청구분() {
		return 건의요청구분;
	}
	public String get건의요청번호() {
		return 건의요청번호;
	}
	public String get제목() {
		return 제목;
	}
	public String get내용() {
		return 내용;
	}
	public String get조회수() {
		return 조회수;
	}
	public String get등록자() {
		return 등록자;
	}
	public String get등록일자() {
		return 등록일자;
	}
	public String get공개여부() {
		return 공개여부;
	}
	public String get요청구분() {
		return 요청구분;
	}
	public String get요청건수() {
		return 요청건수;
	}
	public String get요청답변건수() {
		return 요청답변건수;
	}
	public String get요청상태코드() {
		return 요청상태코드;
	}
	public String get요청상태() {
		return 요청상태;
	}
	public String get댓글번호() {
		return 댓글번호;
	}
	public String get댓글내용() {
		return 댓글내용;
	}
	public String get공지구분() {
		return 공지구분;
	}
	public String get확인자() {
		return 확인자;
	}
	public String get확인여부() {
		return 확인여부;
	}
	public String get확인일자() {
		return 확인일자;
	}
	public String get배포일자() {
		return 배포일자;
	}
	public String get확인시간() {
		return 확인시간;
	}
	public String get파일명() {
		return 파일명;
	}
	public String get원본파일명() {
		return 원본파일명;
	}
	public String get파일순번() {
		return 파일순번;
	}
	public String get상태() {
		return 상태;
	}
	public String get게시구분코드() {
		return 게시구분코드;
	}
	
	//--------------------------------------------------------------//
	// Generate Setters 
	//--------------------------------------------------------------//
	public void setROW_NUM(String row_num) {
		ROW_NUM = row_num;
	}
	public void set기업코드(String 기업코드) {
		this.기업코드 = 기업코드;
	}
	public void set법인코드(String 법인코드) {
		this.법인코드 = 법인코드;
	}
	public void set브랜드코드(String 브랜드코드) {
		this.브랜드코드 = 브랜드코드;
	}
	public void set매장코드(String 매장코드) {
		this.매장코드 = 매장코드;
	}
	public void set매장명(String 매장명) {
		this.매장명 = 매장명;
	}
	public void set매장선택건수(String 매장선택건수) {
		this.매장선택건수 = 매장선택건수;
	}
	public void set게시번호(String 게시번호) {
		this.게시번호 = 게시번호;
	}
	public void set게시구분(String 게시구분) {
		this.게시구분 = 게시구분;
	}
	public void set게시시작일자(String 게시시작일자) {
		this.게시시작일자 = 게시시작일자;
	}
	public void set게시종료일자(String 게시종료일자) {
		this.게시종료일자 = 게시종료일자;
	}
	public void set건의요청구분(String 건의요청구분) {
		this.건의요청구분 = 건의요청구분;
	}
	public void set건의요청번호(String 건의요청번호) {
		this.건의요청번호 = 건의요청번호;
	}
	public void set제목(String 제목) {
		this.제목 = 제목;
	}
	public void set내용(String 내용) {
		this.내용 = 내용;
	}
	public void set조회수(String 조회수) {
		this.조회수 = 조회수;
	}
	public void set등록자(String 등록자) {
		this.등록자 = 등록자;
	}
	public void set등록일자(String 등록일자) {
		this.등록일자 = 등록일자;
	}
	public void set공개여부(String 공개여부) {
		this.공개여부 = 공개여부;
	}
	public void set요청구분(String 요청구분) {
		this.요청구분 = 요청구분;
	}
	public void set요청건수(String 요청건수) {
		this.요청건수 = 요청건수;
	}
	public void set요청답변건수(String 요청답변건수) {
		this.요청답변건수 = 요청답변건수;
	}
	public void set요청상태코드(String 요청상태코드) {
		this.요청상태코드 = 요청상태코드;
	}
	public void set요청상태(String 요청상태) {
		this.요청상태 = 요청상태;
	}
	public void set댓글번호(String 댓글번호) {
		this.댓글번호 = 댓글번호;
	}
	public void set댓글내용(String 댓글내용) {
		this.댓글내용 = 댓글내용;
	}
	public void set공지구분(String 공지구분) {
		this.공지구분 = 공지구분;
	}
	public void set확인자(String 확인자) {
		this.확인자 = 확인자;
	}
	public void set확인여부(String 확인여부) {
		this.확인여부 = 확인여부;
	}
	public void set확인일자(String 확인일자) {
		this.확인일자 = 확인일자;
	}
	public void set배포일자(String 배포일자) {
		this.배포일자 = 배포일자;
	}
	public void set확인시간(String 확인시간) {
		this.확인시간 = 확인시간;
	}
	public void set파일명(String 파일명) {
		this.파일명 = 파일명;
	}
	public void set원본파일명(String 원본파일명) {
		this.원본파일명 = 원본파일명;
	}
	public void set파일순번(String 파일순번) {
		this.파일순번 = 파일순번;
	}
	public void set상태(String 상태) {
		this.상태 = 상태;
	}
	public void set게시구분코드(String 게시구분코드) {
		this.게시구분코드 = 게시구분코드;
	}
}
