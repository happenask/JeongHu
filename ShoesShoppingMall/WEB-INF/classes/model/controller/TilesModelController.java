package model.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import main_category.to.PagingTO;
import model.model.ModelService;
import model.to.ModelTO;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/model")
public class TilesModelController {
	
	private ModelService service;
	public TilesModelController(ModelService service){
		this.service = service;
	}
	
	@RequestMapping("/modelInsert.do")
	public ModelAndView orderInsert(ModelTO mto)throws SQLException{
		ModelAndView mav = null;
		try{
			mto.setModelNum(service.getModelNumber());
			service.insertModel(mto);
			mav = new ModelAndView();
			mav.setViewName("model_insert_success");
			mav.addObject("mto", mto);
		} catch(Exception e){
			e.printStackTrace();
			mav = new ModelAndView("error", "error_message", "모델 등록시 오류 발생하였습니다.\n 관리자에게 문의 하세요. : "+e.getMessage());
		}
		return mav;
	}
	@RequestMapping("/modelList.do")
	public ModelAndView OrderList(String modelType, String modelNum, HashMap map)throws SQLException{
		if(modelNum!=null){
			return new ModelAndView("jsonView", "list", service.getModelListByNumArr(modelNum));	
		}
		if(modelType!=null){
			return new ModelAndView("jsonView", "list", service.getModelListByType(modelType));
		}
		return new ModelAndView("model_list", "list", service.getModelList());
	}
	@RequestMapping("/getModelInfo.do")
	public String getModelInfo(String modelNum, HttpServletRequest request)throws SQLException{
		request.setAttribute("modelTO", service.getModelInfo(modelNum));
		request.setAttribute("url", "product_insert_form");
		return "getMaterialsByType";
	}
	
	@RequestMapping("/deleteModel.do")
	public ModelAndView deleteModel(String modelNum)throws SQLException{
		service.deleteModelByModelNum(modelNum);
		return OrderList(null, null, null);
	}
	
	//--------------------카테고리 이미지 paging----------------
		@RequestMapping("/cate_list.do")
		public ModelAndView list(@RequestParam(required=false, defaultValue="1")String page,String cateNumber, Map map) throws Exception{
			
			ModelAndView mv = null;
			ArrayList list = null;
			int nowPage = Integer.parseInt(page);
			if(cateNumber!=null){
				list = service.getModelListByType(cateNumber);
			}else {
				list = service.getModelListAtTt();
			}
			if(list!=null){
				
				int totalContent = list.size();
				PagingTO pto = new PagingTO(totalContent, nowPage);
				
				map.put("pto", pto);
				map.put("cateNumber", cateNumber);
				map.put("list", list);
				System.out.println("cateNumber"+cateNumber);
				System.out.println(list);

			}else{
				mv = new ModelAndView("error","error_message","등록된 상품이 없습니다.");
			}
			if(cateNumber!=null){
				mv = new ModelAndView("cate_list",map);
			}else {
				mv = new ModelAndView("main", map);
			}
			return mv;
		}
}
