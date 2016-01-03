package member.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import main_category.to.PagingTO;
import member.dto.AddressTO;
import member.dto.MemberDTO;
import member.model.service.MemberService;
import model.to.ModelTO;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;



@Controller
public class TilesTestController {
	
	private MemberService service;
	
	public TilesTestController(){
		
	}
	public TilesTestController(MemberService service){
		this.service = service;
	}
	
	//------------------------------메인 페이지------------------------
	@RequestMapping("/mainPage.do")
	public String mainPage(){
		return "cate_list.do"; //tile 설정 - definition의 name 속성의 값을 viewName으로 return
	}
	
	
//-------------------------------------------로그인---------------------	
	@RequestMapping("/loginForm.do")
	public String loginForm(){
		return "login_form"; 
	}
	@RequestMapping(value="/loginMember.do",method=RequestMethod.POST)
	public ModelAndView loginMember(HttpSession session, String id, String password){
		ModelAndView mv = null;
		try{
			MemberDTO mto = service.getMemberById(id);
			if(mto!=null){
				//패스 워드 비교
				if(password.equals(mto.getPassword())){//ID/Password 모두 맞는 경우
					session.setAttribute("login_info", mto);
					mv = new ModelAndView("mainPage.do");
				}else{//패스워드가 틀린 경우
					mv = new ModelAndView("login_form", "error_message", "패스워드가 틀렸습니다. 확인 후 다시 로그인 하세요.");
				}
			}else{//id가 없는 경우
				mv = new ModelAndView("login_form","error_message", id+"는 없는 ID입니다. 확인 후 다시 로그인 하세요.");
			}
		} catch (SQLException e){
			e.printStackTrace();
			mv = new ModelAndView("login_form", "error_message", "로그인 도중 오류 발생 : "+e.getMessage());
		}
		return mv;
	}
	
	

	
	//---------------------------회원 가입---------------------------------
	
	@RequestMapping("/joinForm.do")
	public String joinForm(){
		
		return "join_form";
	}

	@RequestMapping(value="/joinMember.do",method=RequestMethod.POST)
	public ModelAndView registerMember(MemberDTO mto){
		ModelAndView mv = null;
		System.out.println("-----ctr : "+mto);

			System.out.println("회원가입Controller");
			int memberNum = service.getSeq();
			mto.setMemberNum(memberNum);
			
			service.joinMember(mto);
	
		
		
		mv = new ModelAndView("register_success","mto",mto);
		return mv;
	}
	
	
//-----------------------------------아이디 체크--
	
	@RequestMapping(value="/idCheck.do",method=RequestMethod.POST)
	public ModelAndView idCheck(String id) throws SQLException{
		System.out.println("아이디체크");
		MemberDTO mto = service.getMemberById(id);
		ModelAndView mv=null;
		boolean flag = false;
		
		if(mto!=null){ //중복된 경우
			flag=true;
		}
		
		mv = new ModelAndView("jsonView","flag",flag);
		return mv;
		
	}
	
	@RequestMapping(value="/postCheck.do",method=RequestMethod.POST)
	public ModelAndView postCheck(String dong) throws SQLException{
		
		ModelAndView mv = null;
		ArrayList<AddressTO> list = service.getAddressByDongName(dong);
		System.out.println(list);
		
		mv = new ModelAndView("jsonView","list",list);
		return mv;
		
	}
	//-----------------------------주민번호 확인
	@RequestMapping(value="/registerCheck.do",method=RequestMethod.POST)
	public ModelAndView registerCheck(String registerNumber1, String registerNumber2){
		System.out.println(registerNumber1);
		ModelAndView mv = null;
		boolean flag = false;
		
		
		MemberDTO mto = service.getMemberByRegisterNumber(registerNumber1,registerNumber2);
		
		if(mto!=null){
			flag=true;
		}
		
		System.out.println(flag);	
		
		mv= new ModelAndView("jsonView","flag",flag);
		return mv;
	}
	
	//-----------------------마이페이지
	@RequestMapping("/mypageForm.do")
	public String mypageForm(){
		
		return "mypage_form";
	}
	@RequestMapping("/managementForm.do")
	public String managementForm(){
		return "management_form";
	}
	
	@RequestMapping("/management.do")
	public String materialSuppriesForm(String url){
		return url;
	}
	//-----------------------회원정보 수정
	
	@RequestMapping("/updateForm.do")
	public String updateForm(){
		
		return "update_form";
	}
	
	@RequestMapping(value="/updateMember.do",method=RequestMethod.POST)
	public ModelAndView updateMember(HttpServletRequest request,HttpServletResponse response, HttpSession session, MemberDTO mto) {
		ModelAndView mv = null;
		MemberDTO loginInfo = (MemberDTO) session.getAttribute("login_info");
		System.out.println("회원정보수정 controller");
		if (loginInfo == null) {// 로그인 안된 경우
			mv = new ModelAndView("/login.jsp", "error_message","로그인 후 회원정보 수정이 가능합니다. 로그인 먼저 하세요");
		}else {

			try {
				// 정보 수정 비지니스 로직에 요청
				service.updateMember(mto);
				// 변경된 정보 session의 login_info 에 다시 설정
				loginInfo.setPassword(mto.getPassword());
				loginInfo.setTel(mto.getTel());
				loginInfo.setZipcode(mto.getZipcode());
				loginInfo.setAddress(mto.getAddress());
				loginInfo.setName(mto.getName());
				loginInfo.setRegisterNumber1(mto.getRegisterNumber1());
				loginInfo.setRegisterNumber2(mto.getRegisterNumber2());
				
				session.setAttribute("login_info", loginInfo);
				
				mv = new ModelAndView("main","success","회원정보 수정에 성공하였습니다.");
			} catch (Exception e) {
				e.printStackTrace();
				mv = new ModelAndView("update_form", "error_message",
						e.getMessage());
			}
		}
		return mv;
	}
//-------------------------회원 탈퇴--
	@RequestMapping("/memberDrop.do")
	public ModelAndView dropMember(HttpSession session){
		ModelAndView mv = null;
		try{
			MemberDTO mto = (MemberDTO) session.getAttribute("login_info");
			
			service.dropMember(mto.getId());
			
			session.invalidate();
			
			mv = new ModelAndView("main","success","회원탈퇴 되었습니다.");
			
			
		}catch(Exception e){
			e.printStackTrace();
			mv = new ModelAndView("update_form", "error_message",
				e.getMessage());
		
		}
		return mv;
	}
//---------------------로그 아웃---	
	@RequestMapping("/logOutMember.do")
	public ModelAndView logOutMember(HttpSession session){
		
		session.invalidate();
		return new ModelAndView("main","success","로그아웃 되었습니다.");
	}
	

	
	
	
}
