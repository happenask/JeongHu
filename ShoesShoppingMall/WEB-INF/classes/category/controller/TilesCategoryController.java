package category.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import category.model.CategoryService;
import category.to.CategoryTO;

@Controller
@RequestMapping("/category")
public class TilesCategoryController {
	
	private CategoryService service;
	
	public TilesCategoryController(CategoryService service){
		this.service = service;
	}
	
	@RequestMapping("/categoryForm.do")
	public String registerCategoryForm(){
		return "category_register_form.tiles";
	}
	
}
