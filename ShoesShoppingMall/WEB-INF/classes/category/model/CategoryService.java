package category.model;

import java.sql.SQLException;
import java.util.ArrayList;

import category.to.CategoryTO;

public class CategoryService {
	private CategoryDAO dao;
	
	public CategoryService(CategoryDAO dao){
		this.dao = dao;
	}
	//전체 카테고리 정보 조회
	public ArrayList<CategoryTO> selectAllCategory() throws SQLException{
		return dao.selectAllCategory();
	}
	//상품별로 카테고리 조회
	public ArrayList<CategoryTO> selectCategoryByProduct() throws SQLException{
		return dao.selectCategoryByProduct();
	}
}
