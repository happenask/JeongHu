package order.controller;

import java.sql.SQLException;
import java.util.HashMap;

import order.model.OrderService;
import order.to.OrderTO;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import product.model.ProductService;
import product.to.ProductTO;

@Controller
@RequestMapping("/order")
public class TilesOrderController {
	
	private ProductService pService;
	private OrderService oService;
	public TilesOrderController(ProductService pService, OrderService oService){
		this.pService = pService;
		this.oService = oService;
	}
	
	@RequestMapping("/orderInsert.do")
	public ModelAndView orderInsert(ProductTO pto, OrderTO oto)throws SQLException{
		ModelAndView mav = null;
		try{
			mav = new ModelAndView();
			pService.insertProduct(pto);
			oto.setOrderId(oService.getOrderId());
			oto.setOrderLevel(0);
			pService.sellsProduct(pto);
			oService.insertOrder(oto);
			mav.setViewName("order_insert_success");
			mav.addObject("pto", pto);
			mav.addObject("oto", oto);
		} catch(Exception e){
			e.printStackTrace();
			mav = new ModelAndView("error", "error_message", "주문시 오류 발생하였습니다.\n 관리자에게 문의 하세요. : "+e.getMessage());
		}
		return mav;
	}
	@RequestMapping("/orderList.do")
	public ModelAndView orderList(int memberNum, HashMap map)throws SQLException{
		return new ModelAndView("order_list", "list", oService.getOrderList(memberNum));
	}
	
	@RequestMapping("/getOrderListByDate.do")
	public ModelAndView orderListByDate(String sDate, String eDate)throws SQLException{
		return new ModelAndView("jsonView", "list", oService.getOrderListByDate(sDate, eDate));
	}
	
	@RequestMapping("/getOrderListById.do")
	public ModelAndView orderListByOrderId(String orderId)throws SQLException{
		return new ModelAndView("jsonView", "list", oService.getOrderListByOrderId(orderId));
	}
	
	@RequestMapping("/getOrderListAll.do")
	public ModelAndView orderListAll()throws SQLException{
		return new ModelAndView("jsonView", "list", oService.getOrderListAdmin());
	}
	@RequestMapping("/getOrderListIng.do")
	public ModelAndView orderListByIng()throws SQLException{
		return new ModelAndView("jsonView", "list", oService.getOrderListAdminById());
	}
	
	@RequestMapping("/getOrderListAdmin.do")
	public ModelAndView orderListAdmin()throws SQLException{
		return new ModelAndView("order_list_admin");
	}
	
	@RequestMapping("/orderLevelDown.do")
	public ModelAndView orderLevelDown(OrderTO oto)throws SQLException{
		oService.orderLevelDown(oto.getOrderId(), oto.getOrderLevel());
		return orderListByOrderId(oto.getOrderId());
	}
	
	@RequestMapping("/orderLevelUp.do")
	public ModelAndView orderLevelUp(OrderTO oto)throws SQLException{
		oService.orderLevelUp(oto.getOrderId(), oto.getOrderLevel());
		return orderListByOrderId(oto.getOrderId());
	}
	
	@RequestMapping("/getChart.do")
	public String Chart()throws SQLException{
		return "chart";
	}
	
	@RequestMapping("/getChartData.do")
	public ModelAndView getChartData(String year)throws SQLException{
		return new ModelAndView("jsonView", "list", oService.getChartData(year));
	}
	

}
