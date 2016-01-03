package board.controller;

import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import upload.to.SingleUpTO;

import board.model.service.BoardService;
import board.to.BoardTO;
import board.to.ListTO;
@Controller
public class BoardController {
	private BoardService service;
	private String uploadDir;
	public BoardController(BoardService service){
		this.service = service;
	}
	public void setUploadDir(String uploadDir){
		this.uploadDir = uploadDir;
	}
	
	@RequestMapping("/writeForm.do")
	public String writeForm(){
		return "writeForm";
	}
	@RequestMapping("/writeContent.do")
	public ModelAndView writeContent(BoardTO bto,SingleUpTO sto, Map map){
		ModelAndView mv = null;
			
		//2. Business Logic - Model(Business Service)로 요청
		MultipartFile upfile = sto.getUpfile();
		String comment = sto.getComment();
		try {
			if(upfile!=null&&!upfile.isEmpty()){
				String fileName = upfile.getOriginalFilename();
				long size = upfile.getSize();
				System.out.println(comment + "-" + fileName + "-" + size + "byte");
				upfile.transferTo(new File(uploadDir, fileName));
				bto.setFileName(fileName);
			}
			
			service.writeContent(bto);
			mv = new ModelAndView("redirect:getContent.do?no="+bto.getNo());
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error", "error_message", "글등록 중 오류 발생 : "+e.getMessage());
		}
		return mv;
	}

	
	//------------------------------------------
	
	@RequestMapping("/list.do")
	public String list(@RequestParam(required=false, defaultValue="1")String page, Map map) throws Exception{
		System.out.println(page);
		
		String url = null;
		//2. Business Logic 호출 ->model		
		try {
			if(page.equals("")){
				page = "1";
			}
			int pageNo = Integer.parseInt(page);
			ListTO lto = service.getBoardListByPage(pageNo);
			ArrayList imagelist = service.getImageListByViewNum();
			System.out.println(imagelist+"controlloer");
			url = "list";
			map.put("lto", lto);
			map.put("image",imagelist);
		} catch (SQLException e) {
			e.printStackTrace();
			url = "error";
			map.put("error_message", "글목록 조회도중 오류 발생 : "+e.getMessage());
		}
		return url;
	}
	/*
	 * 글조회
	 */
	@RequestMapping("/getContent.do")
	public ModelAndView getContent(int no){
		ModelAndView mv = null;
		try{
			//2. Business Logic 요청 - Model
			BoardTO bto = service.getContentByNO(no);
			mv = new ModelAndView("show_content", "bto", bto);
		}catch(Exception e){
			e.printStackTrace();
			mv = new ModelAndView("error", "error_message", "글 조회도중 오류 발생 : "+e.getMessage());
		}	
		return mv;
	}
	/**
	 * 수정폼 조회 처리
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modifyForm.do")
	public ModelAndView modifyForm(int no){
		ModelAndView mv = null;
		try{
			//2. B.L 처리
			BoardTO bto = service.getContentByNoForForm(no);
			mv = new ModelAndView("modify_form","bto", bto);
		}catch(Exception e){
			e.printStackTrace();
			mv = new ModelAndView("error","error_message", "수정할 글 조회도중 오류발생 : "+e.getMessage());
		}
		return mv;
	}
	/**
	 * 글 수정 처리 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modifyContent.do")
	public ModelAndView modifyContent(BoardTO bto,SingleUpTO sto) {
		ModelAndView mv = null;
		MultipartFile upfile = sto.getUpfile();
		String comment = sto.getComment();
		try {	
	
				if(upfile!=null&&!upfile.isEmpty()){
					String fileName = upfile.getOriginalFilename();
					long size = upfile.getSize();
					System.out.println(comment + "-" + fileName + "-" + size + "byte");
					upfile.transferTo(new File(uploadDir, fileName));
					bto.setFileName(fileName);
				}
			//2. B.L 요청
			service.modifyContent(bto);
			mv = new ModelAndView("show_content.jsp", "bto", bto);
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error","error_message", "수정처리중 오류 발생 : "+e.getMessage());
		}
		return mv;
	}
	@RequestMapping("/deleteContent.do")
	public ModelAndView deleteContent(int no){
		ModelAndView mv = null;
		try {
			//2. BL
			System.out.println("deleteContent.do:"+no);
			service.deleteContentByNO(no);
			mv = new ModelAndView("/list.do");
			//mv = list(request, response);
		}catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error","error_message", "삭제도중 오류 발생 : "+e.getMessage());
		}
		return mv;
	}
	/**
	 * 답변 폼 조회 처리
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/replyForm.do")
	public ModelAndView replyForm(int no){
		ModelAndView mv = null;
		try {
			//1. 요청 파라미터 조회 - no
			BoardTO bto = service.getContentByNoForForm(no);
			mv = new ModelAndView("reply_form", "bto", bto);
		}catch (SQLException e) {
			e.printStackTrace();
			mv = new ModelAndView("error", "error_message", "답변할 원본글 조회도중 오류 발생 : "+e.getMessage());
		}
		return mv;
	}
	/**
	 * 답변 처리
	 * @param request
	 * @param response
	 * @param bto
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/replyContent.do")
	public ModelAndView replyContent(BoardTO bto, int page) throws Exception{
		ModelAndView mv = null;
		try{
			service.replyContent(bto);
			//멱등처리
			mv = new ModelAndView("redirect:getContent.do?no="+bto.getNo()+"&page="+page);
		}catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error", "error_message", "답변 처리 중 오류 발생 : "+e.getMessage());
		}
		return mv;
	}
}
