package supplier.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import supplier.model.SupplierService;
import supplier.to.SupplierTO;

@Controller
@RequestMapping("/supplier")
public class TilesSupplierController {
	
	private SupplierService service;
	public TilesSupplierController(SupplierService service){
		this.service = service;
	}
	
	//거래처 등록 폼
	
	@RequestMapping("/supplierForm.do")
	public String supplierRegisterForm(){
		return "거래처등록페이지/supplier_register_form.tiles";
	}
	
	//거래처 수정 폼
	
	@RequestMapping("supplierModifyForm.do")
	public String supplierModifyForm(){
		return "거래처수정페이지/supplier_modify_form.tiles";
	}
	
	//거래처 검색 폼
	
	@RequestMapping("/supplierSearchForm.do")
	public String supplierSearchForm(){
		return "거래처검색페이지/supplier_search_form.tiles";
	}
	
	//거래처 등록 컨트롤러
	@RequestMapping("/supplierRegisterSuccess.do")
	public ModelAndView supplierRegister(SupplierTO sto,HttpSession session){
		
		ModelAndView mv = new ModelAndView();
		
		try {
			service.insertSupplier(sto);
			mv.setViewName("supplier_register_success");
			session.setAttribute("supplier", sto);
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error","error_message",e.getMessage());
		}
		return mv;
	}
	
	//거래처 검색 컨트롤러 - 거래처이름으로
	@RequestMapping("/supplierSearchSuccess.do")
	public ModelAndView searchSupplier(String name,HttpSession session){
		ModelAndView mv = new ModelAndView();
		try {
			if (name != null) {
				SupplierTO sto = service.selectSupplierByName(name);
				mv.setViewName("supplier_search_success");
				mv.addObject("sto", sto);
				session.setAttribute("supplier", sto);
			}
			else {
				mv = new ModelAndView("supplier_search_form","error_message", "거래처 조회 도중 에러 났습니다");
			}
		}catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error","error_message", "거래처 조회 도중 에러 났습니다 : "+e.getMessage());
		}
		return mv;
	}
	
	//거래처 삭제
	@RequestMapping("/supplierDeleteSuccess.do")
	public ModelAndView DeleteSupplier(String name,HttpSession session){
		ModelAndView mv = null;
		System.out.println(name);
		try {
			if (name != null) {
				service.deleteSupplierByName(name);
				mv = new ModelAndView("거래처검색페이지/supplier_search_form.tiles");
				session.invalidate();
				mv = new ModelAndView("메인페이지/main.tiles","success",name +" : 거래처가 삭제 되었습니다.");
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			mv = new ModelAndView("error","error_message", "거래처 조회 도중 에러 났습니다 : "+e.getMessage());
		}
		return mv;
	}
	
	
	// 거래처 전체 조회
	
	@RequestMapping("/totalSupplier.do")
	public ModelAndView supplierSelectAll(SupplierTO sto,HttpSession session){
		ModelAndView mv = new ModelAndView();
		try {
			//거래처 조회 비지니스 서비스 호출
			ArrayList<SupplierTO> totalList = service.selectAllSupplier();
			mv.setViewName("jsonView");
			mv.addObject("totalList",totalList);
			System.out.println(totalList);
			session.setAttribute("supplier", sto);
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error","error_message",e.getMessage());
			
		}
		return mv;
	}
	
	
	
	
	
	
	//거래처 수정 컨트롤러
	@RequestMapping("/supplierModifySuccess.do")
	public ModelAndView modifySupplier(SupplierTO sto,HttpSession session){
		ModelAndView mv = new ModelAndView();
				try {
					//정보 수정 비지니스 로직에 요청				
					service.updateSupplier(sto);
					mv.setViewName("supplier_modify_success");
					session.setAttribute("supplier", sto);
				} catch (Exception e) {
					e.printStackTrace();
					mv = new ModelAndView("error","error_message",e.getMessage());
				}
		return mv;
	}
}

