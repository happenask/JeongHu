package model.model;

import java.sql.SQLException;
import java.util.ArrayList;

import model.to.ModelTO;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

public class ModelDAO {
	
	private SqlMapClientTemplate sqlMap;
	
	public ModelDAO(SqlMapClientTemplate sqlMap){
		this.sqlMap = sqlMap;
	}

	public void insertModel(ModelTO mto)throws SQLException {
		System.out.println(mto);
		sqlMap.insert("insertModel", mto);
	}

	public int getModelNumber()throws SQLException {
		return (int)sqlMap.queryForObject("selectModelNumber");
	}
	
	public ArrayList getModelListByType(String modelType)throws SQLException {
		return (ArrayList)sqlMap.queryForList("selectModelListByType", modelType);
	}

	public ModelTO getModelListByNum(String modelNum) {
		return (ModelTO)sqlMap.queryForObject("selectModelListByNum", modelNum);
	}
	
	public ArrayList getModelList()throws SQLException {
		return (ArrayList)sqlMap.queryForList("selectModelList");
	}
	
	public ArrayList getModelListAtTt()throws SQLException {
		return (ArrayList)sqlMap.queryForList("selectModelListAtTt");
	}

	public int deletModelByModelNum(String modelNum) {
		return sqlMap.delete("deleteModelByModelNum", modelNum);
	}
}
