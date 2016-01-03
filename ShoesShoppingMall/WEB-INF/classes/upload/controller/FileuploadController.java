package upload.controller;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import upload.to.SingleUpTO;

@Controller
public class FileuploadController {

	private String uploadDir;
	public void setUploadDir(String uploadDir){
		this.uploadDir = uploadDir;
	}
	@RequestMapping("/singleUp.do")
	public ModelAndView singleUp(String comment, @RequestParam MultipartFile upfile, Map map)throws Exception{//@RequestParam 파람 변수 등록할때 씀. Map리턴할때 모델값.
		
		//실행시점 - 파일은 임시 디렉토리에 저장된 상테
		//Controller - >1. 임시 디렉토리의 파일을 최종 저장소로 이동
		//				2. 업로드된 파일정보를 조회하여 가공
		if(upfile!=null&&!upfile.isEmpty()){//upfile이름으로 넘어온 요청파라미터가 있고 upload된 파일이 잇다면
			//업로드된 파일 정보 조회
			String fileName = upfile.getOriginalFilename();//업로드된 파일명 조회
			long size = upfile.getSize();//업로드된 파일의 크기.
			map.put("fileName", fileName);
			map.put("fileSize", size);
			map.put("comment", comment);
			System.out.println(comment + "," + fileName + "," + size + "byte");
			//최종 저장소로 이동
			upfile.transferTo(new File(uploadDir, fileName));//원래 있던곳에서 uploadDir쪽으로 이동한것임.
		}
		return new ModelAndView("single_res.jsp");
	}
	//upload정보를 DTO를 통해 받기
/*	@RequestMapping("/singleUpDTO.do")
	public String singleUpDTO(SingleUpTO sto, Map map)throws Exception{
		MultipartFile upfile = sto.getUpfile();
		String comment = sto.getComment();
		if(upfile!=null&&!upfile.isEmpty()){
			String fileName = upfile.getOriginalFilename();
			long size = upfile.getSize();
			System.out.println(comment + "-" + fileName + "-" + size + "byte");
			upfile.transferTo(new File(uploadDir, fileName));
			map.put("fileName",fileName);
			map.put("fileSize", size);
			map.put("comment", comment);
		}
		return "upload";
	}*/
	//하나의 이름으로 여러파일이 upload되는 경우 처리
	
	@RequestMapping("/multiUp.do")
	public ModelAndView multiUp(String comment,@RequestParam List<MultipartFile> upfile)throws Exception{
		if(upfile!=null){//null인 경우- upfile라는 이름으로 넘어온 요청 파라미터가 없는 경우.
			for(MultipartFile file:upfile){
				if(!file.isEmpty()){//upload된 파일이 있다면
					String fileName = file.getOriginalFilename();
					long size = file.getSize();
					System.out.println(comment+"-"+fileName+"-"+size);
					file.transferTo(new File(uploadDir,fileName));//이동
				}
			}
			
		}
		return new ModelAndView("multi_res.jsp","upfile",upfile); //multi_res.jsp로 upfile을 보낸다.
	}
	@RequestMapping("download.do")
	public ModelAndView download(String fileName) throws Exception{
		return new ModelAndView("downView", "fileName",fileName);
	}
}












