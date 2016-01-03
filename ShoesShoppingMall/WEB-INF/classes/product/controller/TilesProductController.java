package product.controller;

import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import product.model.ProductService;
import product.to.ProductTO;

@Controller
@RequestMapping("/product")
public class TilesProductController {
	
	private ProductService service;
	public TilesProductController(ProductService service){
		this.service = service;
	}
	
	@RequestMapping("/productMake.do")
	public ModelAndView mainPage(ProductTO pto){
		pto.setProductId(service.getProductId());
		return new ModelAndView("order_form", "pto", pto);
	}
	
	@RequestMapping("/getProductById.do")
	public ModelAndView materialSelectByType(String productId, HttpServletRequest request)throws SQLException{
		request.setAttribute("pto", service.getProductById(productId));
		return new ModelAndView("getMaterialById");
	}
	

}
