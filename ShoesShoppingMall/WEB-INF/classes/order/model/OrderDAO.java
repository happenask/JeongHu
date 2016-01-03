package order.model;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import order.to.OrderTO;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import product.to.ProductTO;

public class OrderDAO {
	
	private SqlMapClientTemplate sqlMap;
	
	public OrderDAO(SqlMapClientTemplate sqlMap){
		this.sqlMap = sqlMap;
	}
	
	public ProductTO selectProductByType(String id)throws SQLException{
		return (ProductTO)sqlMap.queryForObject("selectProductById", id);
	}
	
	public int selectOrderId() {
		return (int)sqlMap.queryForObject("selectOrderNumber");
	}

	public void insertOrder(OrderTO oto)throws SQLException {
		sqlMap.insert("insertOrder", oto);
	}
	
	public ArrayList<OrderTO> selectOrderByDate(String sDate, String eDate)throws SQLException {
		HashMap map = new HashMap();
		map.put("sDate", sDate);
		map.put("eDate", eDate);
		return (ArrayList)sqlMap.queryForList("selectOrderByDate", map);
	}

	public ArrayList<OrderTO> selectOrderByMemberNum(int memberNum)throws SQLException {
		return (ArrayList)sqlMap.queryForList("selectOrderByMemberNum", memberNum);
	}

	public ArrayList<OrderTO> selectOrderByOrderId(String orderId) {
		return (ArrayList)sqlMap.queryForList("selectOrderByOrderId", orderId);
	}
	
	public ArrayList<OrderTO> selectOrderList()throws SQLException {
		return (ArrayList)sqlMap.queryForList("selectOrderList");
	}
	
	public ArrayList selectOrderListByIng()throws SQLException {
		return (ArrayList)sqlMap.queryForList("selectOrderListByIng");
	}

	public int updateOrderLevelDown(String orderId)throws SQLException {
		return sqlMap.update("updateOrderLevelDown", orderId);
	}

	public int updateOrderLevelUp(String orderId)throws SQLException {
		return sqlMap.update("updateOrderLevelUp", orderId);
	}
	public int updateOrderLevel(String orderId)throws SQLException {
		return sqlMap.update("updateOrderLevel", orderId);
	}

	public int selectSumPrice(String sDate, String eDate) {
		HashMap map = new HashMap();
		map.put("sDate", sDate);
		map.put("eDate", eDate);
		return (int)sqlMap.queryForObject("selectSumPrice", map);
	}
	public int selectCountPrice(String sDate, String eDate) {
		HashMap map = new HashMap();
		map.put("sDate", sDate);
		map.put("eDate", eDate);
		return (int)sqlMap.queryForObject("selectCountPrice", map);
	}

}
