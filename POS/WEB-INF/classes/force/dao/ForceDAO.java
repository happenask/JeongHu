package force.dao;

import java.util.ArrayList;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import force.to.ForceTO;

public class ForceDAO {
private SqlMapClientTemplate sqlMap;
	
	public ForceDAO(){
		
	}
	
	public ForceDAO(SqlMapClientTemplate sqlMap){
		this.sqlMap=sqlMap;
	}
	
	
	
	public void insertOrder(){
		
	}
	
	public void deleteOrder(){
		
		
	}
	
	public void selectAllOrderList(){
		
	}

	public void insertOrder(ForceTO fto) {
		// TODO Auto-generated method stub
		System.out.println(fto+"insertDAO");
		sqlMap.insert("insertFood",fto);
	}

	public ForceTO checkOrderByname(ForceTO fto) {
		// TODO Auto-generated method stub
		return (ForceTO) sqlMap.queryForObject("selectFoodByName",fto);
	}

	public void updateFood(ForceTO fto) {
		// TODO Auto-generated method stub
		System.out.println(fto+"updateDAO");
		sqlMap.update("updateFood",fto);
	}

	public ArrayList<ForceTO> getTableOrder(String tableNum) {
		// TODO Auto-generated method stub
		return (ArrayList<ForceTO>) sqlMap.queryForList("getTableOrder",tableNum);
	}

	public ArrayList<ForceTO> getAllOrder(String foodDate) {
		// TODO Auto-generated method stub
		return (ArrayList<ForceTO>) sqlMap.queryForList("getAllOrder",foodDate);
	}

	public int getTotalSum(String foodDate) {
		// TODO Auto-generated method stub
		return (int) sqlMap.queryForObject("getTotalSum",foodDate);
	}
}
