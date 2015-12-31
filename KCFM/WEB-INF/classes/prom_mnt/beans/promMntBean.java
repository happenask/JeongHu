/** ############################################################### */
/** Program ID   : promMntBean.java                                 */
/** Program Name : 홍보물관리                                       */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package prom_mnt.beans;

public class promMntBean {
	
	//홍보물상세관리
	
	private String 기업번호 			= null;
	private String 법인번호 			= null;
	private String 브랜드번호 			= null;
	
	private String 기업코드 			= null;
	private String 기업명				= null;
	private String 법인코드 			= null;
	private String 법인명 				= null;
	private String 브랜드코드 			= null;
	private String 브랜드명 			= null;
	private String 대분류코드 			= null;
	private String 대분류명 			= null;
	private String 중분류코드 			= null;
	private String 중분류명 			= null;
	private String 홍보물번호 			= null;
	private String 홍보물명 			= null;
	private String 인쇄사용문구포함여부 = null;
	private String 홍보물타입 			= null;
	private String 수량 			    = null;
	private String 단위 			    = null;
	private String 주문단위 			= null;
	private String 사이즈				= null;
	private String 매출단가 			= null;
	private String 단가 				= null;
	private String 이미지경로 			= null;
	private String 이미지표지파일명    = null;
	private String 이미지앞면파일명 	= null;
	private String 이미지뒷면파일명 	= null;
	private String 홍보물업체코드 		= null;
	private String 홍보물업체명 		= null;
	
	private String ROW_NUM				= null;
	private String 메뉴코드			= null;
	private String 메뉴코드명			= null;
	private String 메뉴URL				= null;
	private String 메뉴레벨			= null;
	private String 메뉴유형			= null;
	private String 상위메뉴코드		= null;
	private String 메뉴순서			= null;
	private String 홍보물업체전화번호  = null;
	private String 세부코드 			= null;
	private String 세부코드명			= null;
	private String 등록자				= null;
	
	
	
	public String get기업번호() {
		return 기업번호;
	}
	public void set기업번호(String 기업번호) {
		this.기업번호 = 기업번호;
	}
	public String get법인번호() {
		return 법인번호;
	}
	public void set법인번호(String 법인번호) {
		this.법인번호 = 법인번호;
	}
	public String get브랜드번호() {
		return 브랜드번호;
	}
	public void set브랜드번호(String 브랜드번호) {
		this.브랜드번호 = 브랜드번호;
	}
	public String get기업코드() {
		return 기업코드;
	}
	public void set기업코드(String 기업코드) {
		this.기업코드 = 기업코드;
	}
	public String get기업명() {
		return 기업명;
	}
	public void set기업명(String 기업명) {
		this.기업명 = 기업명;
	}
	public String get법인코드() {
		return 법인코드;
	}
	public void set법인코드(String 법인코드) {
		this.법인코드 = 법인코드;
	}
	public String get법인명() {
		return 법인명;
	}
	public void set법인명(String 법인명) {
		this.법인명 = 법인명;
	}
	public String get브랜드코드() {
		return 브랜드코드;
	}
	public void set브랜드코드(String 브랜드코드) {
		this.브랜드코드 = 브랜드코드;
	}
	public String get브랜드명() {
		return 브랜드명;
	}
	public void set브랜드명(String 브랜드명) {
		this.브랜드명 = 브랜드명;
	}
	public String get대분류코드() {
		return 대분류코드;
	}
	public void set대분류코드(String 대분류코드) {
		this.대분류코드 = 대분류코드;
	}
	public String get대분류명() {
		return 대분류명;
	}
	public void set대분류명(String 대분류명) {
		this.대분류명 = 대분류명;
	}
	public String get중분류코드() {
		return 중분류코드;
	}
	public void set중분류코드(String 중분류코드) {
		this.중분류코드 = 중분류코드;
	}
	public String get중분류명() {
		return 중분류명;
	}
	public void set중분류명(String 중분류명) {
		this.중분류명 = 중분류명;
	}
	public String get홍보물번호() {
		return 홍보물번호;
	}
	public void set홍보물번호(String 홍보물번호) {
		this.홍보물번호 = 홍보물번호;
	}
	public String get홍보물명() {
		return 홍보물명;
	}
	public void set홍보물명(String 홍보물명) {
		this.홍보물명 = 홍보물명;
	}
	
	public String get인쇄사용문구포함여부() {
		return 인쇄사용문구포함여부;
	}
	public void set인쇄사용문구포함여부(String 인쇄사용문구포함여부) {
		this.인쇄사용문구포함여부 = 인쇄사용문구포함여부;
	}
	public String get홍보물타입() {
		return 홍보물타입;
	}
	public void set홍보물타입(String 홍보물타입) {
		this.홍보물타입 = 홍보물타입;
	}
	
	public String get수량() {
		return 수량;
	}
	public void set수량(String 수량) {
		this.수량 = 수량;
	}
	public String get단위() {
		return 단위;
	}
	public void set단위(String 단위) {
		this.단위 = 단위;
	}
	public String get주문단위() {
		return 주문단위;
	}
	public void set주문단위(String 주문단위) {
		this.주문단위 = 주문단위;
	}
	public String get사이즈() {
		return 사이즈;
	}
	public void set사이즈(String 사이즈) {
		this.사이즈 = 사이즈;
	}
	
	public String get매출단가() {
		return 매출단가;
	}
	public void set매출단가(String 매출단가) {
		this.매출단가 = 매출단가;
	}
	public String get단가() {
		return 단가;
	}
	public void set단가(String 단가) {
		this.단가 = 단가;
	}
	public String get이미지경로() {
		return 이미지경로;
	}
	public void set이미지경로(String 이미지경로) {
		this.이미지경로 = 이미지경로;
	}
	public String get이미지표지파일명() {
		return 이미지표지파일명;
	}
	public void set이미지표지파일명(String 이미지표지파일명) {
		this.이미지표지파일명 = 이미지표지파일명;
	}
	public String get이미지앞면파일명() {
		return 이미지앞면파일명;
	}
	public void set이미지앞면파일명(String 이미지앞면파일명) {
		this.이미지앞면파일명 = 이미지앞면파일명;
	}
	public String get이미지뒷면파일명() {
		return 이미지뒷면파일명;
	}
	public void set이미지뒷면파일명(String 이미지뒷면파일명) {
		this.이미지뒷면파일명 = 이미지뒷면파일명;
	}
	public String get홍보물업체코드() {
		return 홍보물업체코드;
	}
	public void set홍보물업체코드(String 홍보물업체코드) {
		this.홍보물업체코드 = 홍보물업체코드;
	}
	public String get홍보물업체명() {
		return 홍보물업체명;
	}
	public void set홍보물업체명(String 홍보물업체명) {
		this.홍보물업체명 = 홍보물업체명;
	}
	public String getROW_NUM() {
		return ROW_NUM;
	}
	public void setROW_NUM(String rOW_NUM) {
		ROW_NUM = rOW_NUM;
	}

	public String get메뉴코드() {
		return 메뉴코드;
	}
	public void set메뉴코드(String 메뉴코드) {
		this.메뉴코드 = 메뉴코드;
	}
	public String get메뉴코드명() {
		return 메뉴코드명;
	}
	public void set메뉴코드명(String 메뉴코드명) {
		this.메뉴코드명 = 메뉴코드명;
	}
	public String get메뉴URL() {
		return 메뉴URL;
	}
	public void set메뉴URL(String 메뉴url) {
		메뉴URL = 메뉴url;
	}
	public String get메뉴레벨() {
		return 메뉴레벨;
	}
	public void set메뉴레벨(String 메뉴레벨) {
		this.메뉴레벨 = 메뉴레벨;
	}
	public String get메뉴유형() {
		return 메뉴유형;
	}
	public void set메뉴유형(String 메뉴유형) {
		this.메뉴유형 = 메뉴유형;
	}
	public String get상위메뉴코드() {
		return 상위메뉴코드;
	}
	public void set상위메뉴코드(String 상위메뉴코드) {
		this.상위메뉴코드 = 상위메뉴코드;
	}
	public String get메뉴순서() {
		return 메뉴순서;
	}
	public void set메뉴순서(String 메뉴순서) {
		this.메뉴순서 = 메뉴순서;
	}
	public String get홍보물업체전화번호() {
		return 홍보물업체전화번호;
	}
	public void set홍보물업체전화번호(String 홍보물업체전화번호) {
		this.홍보물업체전화번호 = 홍보물업체전화번호;
	}
	public String get세부코드() {
		return 세부코드;
	}
	public void set세부코드(String 세부코드) {
		this.세부코드 = 세부코드;
	}
	public String get세부코드명() {
		return 세부코드명;
	}
	public void set세부코드명(String 세부코드명) {
		this.세부코드명 = 세부코드명;
	}
	public String get등록자() {
		return 등록자;
	}
	public void set등록자(String 등록자) {
		this.등록자 = 등록자;
	}

	
}
