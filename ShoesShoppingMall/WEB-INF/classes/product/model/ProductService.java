package product.model;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import product.to.ProductTO;

public class ProductService {

	private ProductDAO dao;
	
	public ProductService(ProductDAO dao){
		this.dao = dao;
	}
	
	public String getProductId(){
		Date date = new Date();
		DateFormat df = new SimpleDateFormat("yyMMddHH");
		
		int id = dao.selectProductId();
		String temp = (10000+id+"");
		temp = temp.substring(temp.length()-4, temp.length());
		String pId = df.format(date);
		return pId+"-"+temp;
	}

	public void insertProduct(ProductTO pto)throws SQLException {
		dao.insertProduct(pto);
	}

	public ProductTO getProductById(String productId)throws SQLException {
		return dao.selectProductById(productId);
	}	
	
	// 판매
	
	public void sellsProduct(ProductTO pto) throws SQLException{
		 dao.sellsProduct(pto.getHeel());
		 dao.sellsProduct(pto.getLeather());
		 if(pto.getAcc1()!=null)
			 dao.sellsProduct(pto.getAcc1());
		 if(pto.getAcc2()!=null)
			 dao.sellsProduct(pto.getAcc2());
	}
}
