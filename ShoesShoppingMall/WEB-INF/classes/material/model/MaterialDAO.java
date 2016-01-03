package material.model;

import java.sql.SQLException;
import java.util.ArrayList;

import material.to.MaterialTO;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import supplier.to.SupplierTO;

public class MaterialDAO {
	private SqlMapClientTemplate sqlMap;
	
	public MaterialDAO(SqlMapClientTemplate sqlMap){
		this.sqlMap = sqlMap;
	}
	
	public MaterialTO selectMaterialById(String id)throws SQLException{
		return (MaterialTO)sqlMap.queryForObject("selectMaterialById", id);
	}
	
	public ArrayList<MaterialTO> selectMaterialByType(String type)throws SQLException{
		return (ArrayList)sqlMap.queryForList("selectMaterialByType", type);
	}
	public ArrayList<SupplierTO> selectMaterialSupplier() {
		return (ArrayList<SupplierTO>) sqlMap.queryForList("selectSupplierName");
	}
	
	public ArrayList<MaterialTO> selectAllMaterial()throws SQLException{
		return (ArrayList<MaterialTO>) sqlMap.queryForList("selectAllMaterial");
	}
	
	public void insertMaterial(MaterialTO mto)throws SQLException{
		System.out.println(mto);
		sqlMap.insert("insertMaterial", mto);
	}
	public void deleteMaterialById(String materialId)throws SQLException{
		sqlMap.delete("deleteMaterialById",materialId);
		
	}
	public void updateMaterial(MaterialTO mto) {
		sqlMap.update("updateMaterial", mto);
	}

}
