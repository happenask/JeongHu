package model.model;

import java.sql.SQLException;
import java.util.ArrayList;

import model.to.ModelTO;

public class ModelService {

	private ModelDAO dao;
	
	public ModelService(ModelDAO dao){
		this.dao = dao;
	}

	public void insertModel(ModelTO mto)throws SQLException {
		dao.insertModel(mto);
	}

	public int getModelNumber()throws SQLException {
		return dao.getModelNumber();
	}
	
	public ArrayList<ModelTO> getModelListByType(String modelType)throws SQLException {
		return (ArrayList)dao.getModelListByType(modelType);
	}

	public ArrayList<ModelTO> getModelListByNumArr(String modelNum) {
		ArrayList<ModelTO> arry = new ArrayList();
		arry.add(dao.getModelListByNum(modelNum));
		return arry;
	}
	
	public ArrayList<ModelTO> getModelList()throws SQLException {
		return (ArrayList)dao.getModelList();
	}
	
	public ArrayList<ModelTO> getModelListAtTt()throws SQLException {
		return (ArrayList)dao.getModelListAtTt();
	}

	public ModelTO getModelInfo(String modelNum)throws SQLException {
		return dao.getModelListByNum(modelNum);
	}

	public int deleteModelByModelNum(String modelNum) {
		return dao.deletModelByModelNum(modelNum);
	}

}
