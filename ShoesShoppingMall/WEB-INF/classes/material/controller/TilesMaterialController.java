package material.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import material.model.MaterialService;
import material.to.MaterialTO;
import member.dto.MemberDTO;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import product.to.ProductTO;

import supplier.to.SupplierTO;

@Controller
@RequestMapping("/material")
public class TilesMaterialController {
	
	private MaterialService service;
	public TilesMaterialController(MaterialService service){
		this.service = service;
	}
	
	//재료 등록 Form 
	@RequestMapping("/materialForm.do")
	public ModelAndView materialRegisterForm(){
		
		ModelAndView mv = null;
		try {
			ArrayList<SupplierTO> list = service.selectMaterialSupplier();
			mv = new ModelAndView("재료등록페이지/material_register_form.tiles","supplier",list);
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error", "error_message", e.getMessage());
		}
		return mv;
	}
	
	//재료 등록 성공 Form
	@RequestMapping("/materialRegisterSuccess.do")
	public ModelAndView materialRegister(MaterialTO mto,HttpSession session){
		
		ModelAndView mv = new ModelAndView();
		
		try {
			service.insertMaterial(mto);
			mv.setViewName("material_register_success");
			session.setAttribute("material", mto);
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error", "error_message", e.getMessage());
		}
		return mv;
	}
	
	
	//재료 검색 Form
	@RequestMapping("/materialSearchForm.do")
	public String materialSearchForm(){
		return "재료검색페이지/material_search_form.tiles";
	}
	
	//재료 검색 컨트롤러
	@RequestMapping("/materialSearchSuccess.do")
	public ModelAndView materialSearch (String materialId, HttpSession session){
		ModelAndView  mv = new ModelAndView();
		try {
			if (materialId != null) {
				MaterialTO mto = service.selectMaterialById(materialId);
				mv.setViewName("material_search_success");
				mv.addObject("mto",mto);
				session.setAttribute("material", mto);
			}else{
				mv = new ModelAndView("error","error_message","재료검색 중1 에러가 났습니다.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error","error_message","재료검색 중 에러가 났습니다."+e.getMessage());
		}
		
		return mv;
	}
	
	//재료 삭제
	@RequestMapping("/materialDeleteSuccess.do")
	public ModelAndView materialDelete (String materialId, HttpSession session){
		ModelAndView mv = null;
		System.out.println(materialId);
		try {
			if (materialId != null) {
				service.deleteMaterialById(materialId);
				mv = new ModelAndView("재료검색페이지/material_search_form.tiles");
				session.invalidate();
				mv = new ModelAndView("메인페이지/main.tiles","success",materialId+" : 재료가 삭제되었습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error","error_message","재료 삭제중 에러가 났습니다."+e.getMessage());
		}
		return mv;
	}
	
	
	
	//재료 수정 폼
	@RequestMapping("materialModifyForm.do")
	public ModelAndView materialModifyForm(){
		ModelAndView mv = null;
		try {
			ArrayList<SupplierTO> list = service.selectMaterialSupplier();
			mv = new ModelAndView("재료수정페이지/material_modify_form.tiles","supplier",list);
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error", "error_message", e.getMessage());
		}	
		
		return mv;
	}
	
	
	//재료 수정 컨트롤러
	@RequestMapping("/materialModifySuccess.do")
	public ModelAndView materialModifyForm(MaterialTO mto,HttpSession session) throws Exception{
		ModelAndView mv = new ModelAndView();
		try {
			//재료정보수정 비지니스 호출
			service.updateMaterial(mto);;
			//변경된 정보를 세션에 저장
			mv.setViewName("material_modify_success");
			session.setAttribute("material", mto);
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error","error_message",e.getMessage());
		}
	return mv;	
	}
	@RequestMapping("/totalMaterial.do")
	public ModelAndView materialSelectAll(MaterialTO mto,HttpSession session) throws Exception{
		ModelAndView mv = new ModelAndView();
		try {
			//재료정보수정 비지니스 호출
			ArrayList totalList = service.selectAllMaterial();
			//변경된 정보를 세션에 저장
			mv.setViewName("jsonView");
			mv.addObject("totalList",totalList);
			session.setAttribute("material", mto);
		} catch (Exception e) {
			e.printStackTrace();
			mv = new ModelAndView("error","error_message",e.getMessage());
		}
	return mv;		
	}
	
	//주문작성시 쓰는 Ctr - 현규
	@RequestMapping("/getMaterialsByType.do")
	public ModelAndView getMaterialsByType(HashMap map, String url, HttpServletRequest request, HttpSession session)throws SQLException{
		MemberDTO mto = (MemberDTO)session.getAttribute("login_info");
		if(mto==null){
			return new ModelAndView("login_form", "error_message", "로그인 후 사용하실 수 있습니다.");
		}
		if(!(url!=null)){
			url = (String)request.getAttribute("url");
		}
		ArrayList heels = (ArrayList)service.getMaterialByType("HEEL");
		ArrayList leathers = (ArrayList)service.getMaterialByType("LEATHER");
		ArrayList accs = (ArrayList)service.getMaterialByType("ACC");
		map.put("modelTO", request.getAttribute("modelTO"));
		map.put("heels", heels);
		map.put("leathers", leathers);
		map.put("accs", accs);
		return new ModelAndView(url);
	}
	
	//this_product 쓸때 쓰는 Ctr - 현규
	@RequestMapping("/getMaterialById.do")
	public ModelAndView getMaterialById(ProductTO pto, HashMap map, HttpServletRequest request)throws SQLException{
		if(request.getAttribute("pto")!=null){
			pto = (ProductTO)request.getAttribute("pto");
		}
		MaterialTO heel = (MaterialTO)service.getMaterialById(pto.getHeel());
		MaterialTO leather = (MaterialTO)service.getMaterialById(pto.getLeather());
		if(pto.getAcc1()!=null){
			MaterialTO acc1 = (MaterialTO)service.getMaterialById(pto.getAcc1());
			map.put("acc1", acc1);
		}
		if(pto.getAcc2()!=null){
			MaterialTO acc2 = (MaterialTO)service.getMaterialById(pto.getAcc2());
			map.put("acc2", acc2);
		}
		map.put("heel", heel);
		map.put("leather", leather);
		map.put("pto", pto);
		return new ModelAndView("this_product_info");
	}
}
