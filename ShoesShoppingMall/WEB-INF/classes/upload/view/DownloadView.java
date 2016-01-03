package upload.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

/*
 * View 클래스 작성
 * 1.AbstractView를 extends해야함.
 * 2.overriding
 * 	- getContentType() : String타입 - 응답할 content의 타입을 문자열로 return하는 메소드
 * 	- renderMergedOutputModel(Map, request, response) - 응답을 처리하는 메소드
 *		- 매개변수 map : controller에서 넘긴 model객체.
 */

public class DownloadView extends AbstractView  {

	@Override
	public String getContentType() {
		
		return "application/octet-stream";//text/html, image/jpg 타입 형식을 말하는것.컨텐트타입이 binary file이다.octet=일반 바이너리 라는것.
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> map,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		//다운로드 시킬 파일의 이름을 map으로 받는다.
		String fileName = (String)map.get("fileName");
		ServletContext ctx = getServletContext();//AbstractView를 불러왔기때문에 쓸수 있다.
		String realPath = ctx.getRealPath("/upload");//webapplication의 실제 파일 경로를 return한다.
		System.out.println(realPath);//realPath밑에 fileName이 다운로드 될것이다.
		File downFile = new File(realPath, fileName);//다운로드 시켜줄 파일.
		//응답처리
		//1. 응답 헤더정보 설정 - 응답 content 타입 지정
		response.setContentType(getContentType());
		
		//2. 응답 헤더정보 설정 - 다운로드시 저장될 파일명을 지정
		response.setHeader("Content-Disposition", "attachment;filename=" + new String(fileName.getBytes("euc-kr"), "8859_1"));
		//Content-Disposition헤더명,attachment;filename파일명이다.//new String(fileName.getBytes("euc-kr"), "8859-1")한글처리 해줘야함.. 깨짐
	
		//3. 파일을 다운로드 시킴.
		FileInputStream fis = new FileInputStream(downFile);
		OutputStream os = response.getOutputStream();
		FileCopyUtils.copy(fis, os);//input 스트림에서 읽은 것을 output스트림으로 카피해주는 메소드 .//자바 IO의 reader,writer를 대신해주는것.
	}
}
