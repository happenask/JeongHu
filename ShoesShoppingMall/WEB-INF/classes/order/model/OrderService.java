package order.model;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import order.to.OrderTO;

public class OrderService {

	private OrderDAO dao;
	
	public OrderService(OrderDAO dao){
		this.dao = dao;
	}

	public String getOrderId() {
		Date date = new Date();
		DateFormat df = new SimpleDateFormat("yyMM");
		
		int id = dao.selectOrderId();
		String temp = (100000+id+"");
		temp = temp.substring(temp.length()-5, temp.length());
		String oId = df.format(date);
		return oId+"-"+temp;
	}

	public void insertOrder(OrderTO oto)throws SQLException {
		dao.insertOrder(oto);
	}

	public ArrayList<OrderTO> getOrderList(int memberNum)throws SQLException {
		return (ArrayList)dao.selectOrderByMemberNum(memberNum);
	}

	public ArrayList<OrderTO> getOrderListAdmin()throws SQLException {
		return (ArrayList)dao.selectOrderList();
	}

	public int orderLevelDown(String orderId, int orderLevel)throws SQLException {
		return dao.updateOrderLevelDown(orderId);
	}

	public int orderLevelUp(String orderId, int orderLevel)throws SQLException {
		if(orderLevel>=5){
			return dao.updateOrderLevel(orderId);
		}
		return dao.updateOrderLevelUp(orderId);
	}

	public ArrayList<OrderTO> getOrderListByDate(String sDate, String eDate)throws SQLException {
		return (ArrayList)dao.selectOrderByDate(sDate, eDate);
	}

	public ArrayList<OrderTO> getOrderListByOrderId(String orderId)throws SQLException {
		return (ArrayList)dao.selectOrderByOrderId(orderId);
	}

	public ArrayList<OrderTO> getOrderListAdminById()throws SQLException {
		return (ArrayList)dao.selectOrderListByIng();
	}

	public ArrayList getChartData(String year){
		String str = "";
		ArrayList LArry = new ArrayList();
		ArrayList SArry = new ArrayList();
		SArry.add("Month");
		SArry.add("Price");
		SArry.add("Quantity");
		LArry.add(SArry);
		for(int i = 1; i <= 12; i++){
			SArry = new ArrayList();
			str = ""+i;
			if(str.length()==1){
				str = "0"+str;
			}
			str = year+"-"+str;
			SArry.add(str);
			SArry.add(dao.selectSumPrice(str+"-01", str+"-31"));
			SArry.add(dao.selectCountPrice(str+"-01", str+"-31"));
			LArry.add(SArry);
		}
		return LArry;
	}
}
