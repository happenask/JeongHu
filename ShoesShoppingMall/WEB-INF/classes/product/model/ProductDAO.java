package product.model;

import java.sql.SQLException;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import product.to.ProductTO;

public class ProductDAO {
	
	private SqlMapClientTemplate sqlMap;
	
	public ProductDAO(SqlMapClientTemplate sqlMap){
		this.sqlMap = sqlMap;
	}

	public int selectProductId(){
		return (int)sqlMap.queryForObject("selectProductNumber");
	}

	public void insertProduct(ProductTO pto)throws SQLException {
		sqlMap.insert("insertProduct", pto);
	}

	public ProductTO selectProductById(String productId) {
		return (ProductTO)sqlMap.queryForObject("selectProductById", productId);
	}
	
	//sql문은 material.xml 에 구현 해놓았음
	public void sellsProduct(String materialId) {
		sqlMap.update("updateMaterial2", materialId);
	}

}
