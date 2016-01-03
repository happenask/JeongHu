package force.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import force.service.ForceService;
import force.to.ForceTO;

//Controller 메소드의 매개변수 테스트처리할 controller클래스.
@Controller
public class ForceController {
	
	private ForceService service;
	
	
	
	public ForceController(ForceService service) {
		this.service = service;
	}


	@RequestMapping("/order.do")
	public ModelAndView order(ForceTO fto) throws SQLException{
		
		System.out.println(fto.toString());
		ModelAndView mv=null;
		ArrayList<ForceTO> list = new ArrayList<ForceTO>();
		int foodNum = fto.getFoodNum();
		int price = fto.getPrice();
		if(service.checkOrderByname(fto)!=null){
			fto=service.checkOrderByname(fto);
			fto.setFoodNum(fto.getFoodNum()+foodNum);
			price*=fto.getFoodNum();
			fto.setPrice(price);
			service.updateFood(fto);
		}else{
			fto.setPrice(fto.getPrice()*foodNum);
			service.insertOrder(fto);
		}
		
		
		mv = new ModelAndView("jsonView","fto",fto);
		
		return mv;
		
	}
	
	@RequestMapping("/orderList.do")
	public ModelAndView orderList(String tableNum){

		ModelAndView mv = null;
		ArrayList<ForceTO> list = new ArrayList<ForceTO>();
		
		list= service.getTableOrder(tableNum);
		
		mv= new ModelAndView("jsonView","list",list);
		return mv;
		
	}
	@RequestMapping("/totalCalculate.do")
	public ModelAndView totalCalculate(String foodDate){
		ModelAndView mv=null;
		ArrayList<ForceTO> list = new ArrayList<ForceTO>();
		list=service.getAllOrder(foodDate);
		int sum =service.getTotalSum(foodDate);
		System.out.println(sum);
		System.out.println(list);
		HashMap map = new HashMap();
		map.put("list", list);
		map.put("sum", sum);
		mv= new ModelAndView("total_calculate.jsp", map);
		return mv;
		
	}
	
	
	@RequestMapping("/orderCancel.do")
	public ModelAndView orderCancel(String Command, String name) throws SQLException{
		
		ModelAndView mv=null;
		
		
		
		return null;
	}
	
	
}
