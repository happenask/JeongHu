package force.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import force.dao.ForceDAO;
import force.to.ForceTO;

public class ForceService {

	private ForceDAO fdao;
	private ArrayList<ForceTO> list = new ArrayList<ForceTO>();
	
	
	
	public ForceService() {
		super();
	}




	public ForceService(ForceDAO fdao) {
		this.fdao = fdao;
	}




	public void insertOrder(ForceTO fto) {
		// TODO Auto-generated method stub
		Date today = new Date();
		SimpleDateFormat df1 = new SimpleDateFormat("yyyy/MM/dd/hh/mm");
		String date = df1.format(today);
		
		fto.setFoodDate(date);
		fdao.insertOrder(fto);
	
	}




	public ForceTO checkOrderByname(ForceTO fto) {
		// TODO Auto-generated method stub
		return fdao.checkOrderByname(fto);
	}




	public void updateFood(ForceTO fto) {
		// TODO Auto-generated method stub
		fdao.updateFood(fto);
	}




	public ArrayList<ForceTO> getTableOrder(String tableNum) {
		// TODO Auto-generated method stub
		return fdao.getTableOrder(tableNum);
	}




	public ArrayList<ForceTO> getAllOrder(String foodDate) {
		// TODO Auto-generated method stub
		return fdao.getAllOrder(foodDate);
	}




	public int getTotalSum(String foodDate) {
		return fdao.getTotalSum(foodDate);
		// TODO Auto-generated method stub
	}

}
