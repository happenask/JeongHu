/** ############################################################### */
/** Program ID   : BoardConstant.java                               */
/** Program Name :                                                  */
/** Program Desc :                                                  */
/** Create Date  :                                                  */
/** Programmer   :                                                  */
/** Update Date  :                                                  */
/** Programmer   :                                                  */
/** ############################################################### */

package com.util; 
  
/**
 * 게시판 DAO용 Constant를 정의<b>
 * 공지사항의 Board ID 등이 정의 되어 있음.<br>
 * @version 1.0    //Doc Base 주석
 * @author  
 * 
 */ 
public final class BoardConstant 
{  
	  
	  public static final String NOTICE  = "NOTICE";  // 공지사항 ID
	  public static final String EVENT   = "EVENT";   // 이벤트 ID
	  public static final String FAQ     = "FAQ";     // 이벤트 ID
	  public static final String TYPE    = "TYPE";      // 조회 구분
	  public static final String LIST    = "LIST";      // 목록 조회
	  public static final String CONTENT = "CONTENT";   // 내용 조회
	  
	  //첨부화일 관련 정의
	  //public static final String FILEPATH = "D:/PACKAGE_WORKSPACE/workspace(pos)_2015/KCFM/filestorage";		//로컬 위치
	  public static final String FILEPATH = "D:/WEB_ROOT/KCFM/filestorage";										//TEST서버 위치
	  public static final int    FILESIZE = 5*1024*1024;			// 5M
	  
	  public static final String PROMPATH = "D:/WEB_ROOT/KCFM/filestorage/prom";									//image 파일위치(전단지) TEST서버 위치
	  public static final int    PROMSIZE = 5*1024*1024;			// 5M

	  public static final String PROMPATH2 = "filestorage/prom/";														//image 파일위치(전단지) TEST서버 위치

	  public static final int inRowPerPage   = 10;
	  public static final int inPagePerBlock = 10;
	  
}
