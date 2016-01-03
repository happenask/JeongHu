package category.model;

import java.sql.SQLException;
import java.util.ArrayList;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import category.to.CategoryTO;

public class CategoryDAO {
	private SqlMapClientTemplate sqlmap;
	
	public CategoryDAO(SqlMapClientTemplate sqlmap){
		this.sqlmap = sqlmap;
	}
	
	// 전체 카테고리 정보 조회 
	public ArrayList<CategoryTO> selectAllCategory() throws SQLException{
		return (ArrayList<CategoryTO>) sqlmap.queryForList("selectAllCategory");
	}
	//카테고리 등록 - 필요없을듯..
	public void insertCategory(CategoryTO cto) throws SQLException{
		sqlmap.insert("insertCategory", cto);
	}
	
	// 상품별 카테고리 조회
	public ArrayList<CategoryTO> selectCategoryByProduct() throws SQLException{
		return (ArrayList<CategoryTO>) sqlmap.queryForList("selectCategoryByProduct");
	}
	
	
}
