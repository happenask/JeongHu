/** ############################################################### */
/** Program ID   : faqBean.java                                     */
/** Program Name : 자주하는질문내역                                    */
/** Program Desc : 자주하는질문내역 Bean                               */
/** Create Date  : 2015-04-10                                       */
/** Programmer   : JHYOUN                                           */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package admin.beans;

public class faqBean 
{
	//--------------------------------------------------------------//
	// 자주하는질문내역 사용 Bean
	//--------------------------------------------------------------//
	private String ROW_NUM     = null;
	private String 기업코드     = null; 
	private String 법인코드     = null;
	private String 브랜드코드   = null;
	private String 질문번호     = null;
	private String 질문내용     = null;
	private String 답변내용     = null;
	private String 조회수      = null;
	private String 등록자      = null;
	private String 등록일자     = null;
	private String 등록패스워드  = null;
	private String 삭제여부     = null;
	private String 예비문자     = null;
	private String 예비숫자     = null;
	private String 최종변경일시  = null;
	
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
	public String get질문번호() {
		return 질문번호;
	}
	public String get질문내용() {
		return 질문내용;
	}
	public String get답변내용() {
		return 답변내용;
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
	public String get등록패스워드() {
		return 등록패스워드;
	}
	public String get삭제여부() {
		return 삭제여부;
	}
	public String get예비문자() {
		return 예비문자;
	}
	public String get예비숫자() {
		return 예비숫자;
	}
	public String get최종변경일시() {
		return 최종변경일시;
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
	public void set질문번호(String 질문번호) {
		this.질문번호 = 질문번호;
	}
	public void set질문내용(String 질문내용) {
		this.질문내용 = 질문내용;
	}
	public void set답변내용(String 답변내용) {
		this.답변내용 = 답변내용;
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
	public void set등록패스워드(String 등록패스워드) {
		this.등록패스워드 = 등록패스워드;
	}
	public void set삭제여부(String 삭제여부) {
		this.삭제여부 = 삭제여부;
	}
	public void set예비문자(String 예비문자) {
		this.예비문자 = 예비문자;
	}
	public void set예비숫자(String 예비숫자) {
		this.예비숫자 = 예비숫자;
	}
	public void set최종변경일시(String 최종변경일시) {
		this.최종변경일시 = 최종변경일시;
	}
	
}