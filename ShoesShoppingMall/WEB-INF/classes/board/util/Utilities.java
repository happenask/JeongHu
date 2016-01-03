package board.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Utilities {
	//글목록에서 한페이지에 보여질 게시물의 개수
	public static final int CONTENT_PER_PAGE = 7;
	//한 페이지 그룹으로 묶을 페이지의 개수
	public static final int PAGE_PER_PAGEGROUP = 2;
	private Utilities(){}
	/**
	 * 호출된 시점의 일시를 14자리 String 값으로 만들어 return
	 * 예) 20120512100524 (yyyyMMddHHmmss)
	 * @return
	 */
	public static String getNow(){
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
		return format.format(date);
	}
	/**
	 * 인수로 14자리 형태 일시를 받아 날짜만 yyyy.MM.dd 형태의 String으로 만들어 return
	 * - 목록에서 작성일시를 보여줄때 사용할 메소드
	 * 예)20120512100524 -> 2012.05.12
	 * @param dateTime
	 * @return
	 */
	public static String changeDayFormat(String dateTime){
		String year = dateTime.substring(0,4);
		String month = dateTime.substring(4,6);
		String day = dateTime.substring(6,8);
		return year+"."+month+"."+day;
	}
	/**
	 * 인수로 14자리 형태의 일시를 받아 yyyy.MM.dd HH:mm:ss 형태의 String으로 만들어 return
	 * - 글 상세보기에서 사용할 메소드
	 * 예)20120512100524 -> 2012.05.12 10:05:24
	 * @param dateTime
	 * @return
	 */
	public static String changeDayTimeFormat(String dateTime){
		String year = dateTime.substring(0,4);
		String month = dateTime.substring(4,6);
		String day = dateTime.substring(6,8);
		String hour = dateTime.substring(8,10);
		String minute =dateTime.substring(10, 12);
		String second =dateTime.substring(12, 14);
		return year+"."+month+"."+day+" "+hour+":"+minute+":"+second;
	}
	/**
	 * TextArea에서 입력 받은 글 내용을 HTML로 출력 될 때에 맞는 형식으로 변경하는 메소드
	 * 새글등록, 답변글등록, 글 수정시 사용
	 * > - &gt;
	 * < - &lt;
	 * \n - <br>
	 * 공백 - &nbsp;
	 */
	public static String changeContentForDB(String content){		
		String newContent =  content.replaceAll("<", "&lt;");
		newContent = newContent.replaceAll(">", "&gt;");
		newContent = newContent.replaceAll("\r\n", "<br>");
		newContent = newContent.replaceAll(" ", "&nbsp;");
		return newContent;
	}
	/**
	 * DB 에 저장된 content를 TextArea에 출력할 형식으로 변경
	 * 글수정 폼, 답글 폼 출력시 사용
	 * <br> - \n
	 * &gt; - >
	 * &lt; - <
	 * &nbsp; - 공백
	 */
	public static String changeContentForTextArea(String content){
		String newContent  = content.replaceAll("<br>", "\r\n");
		newContent = newContent.replaceAll("&lt;", "<");
		newContent = newContent.replaceAll("&gt;", ">");
		newContent = newContent.replaceAll("&nbsp;", " ");
		return newContent;
	}
	public static void main(String[] args) {
		String str = "abc<br>&lt;안녕&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ㅁㅁㅁ";
		System.out.println(changeContentForTextArea(str));
	}
}
























