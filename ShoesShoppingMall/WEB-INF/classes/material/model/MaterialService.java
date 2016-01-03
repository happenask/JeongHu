package material.model;

import java.sql.SQLException;
import java.util.ArrayList;

import material.to.MaterialTO;
import product.to.ProductTO;
import supplier.to.SupplierTO;

public class MaterialService {
	private MaterialDAO dao;
	
	public MaterialService(MaterialDAO dao){
		this.dao = dao;
	}
	
	//현규꺼 Ctr에 쓰는 부분
	public ArrayList<MaterialTO> getMaterialByType(String type) throws SQLException{
		return (ArrayList)dao.selectMaterialByType(type);
	}
	//현규꺼 Ctr에 쓰이는 부분
	public MaterialTO getMaterialById(String id)throws SQLException{
		return (MaterialTO)dao.selectMaterialById(id);
	}
	
	// 재료 등록 
	
	public void insertMaterial(MaterialTO mto)throws Exception{
		//1. 등록된 아이디가 있는지 체크
		
		String id = mto.getMaterialId();
		
		if (dao.selectMaterialById(id) != null) {
			throw new Exception(mto.getMaterialId()+"는 이미 사용중인 아이디 입니다.");
		}
		dao.insertMaterial(mto);
	}
	
	// 재료 삭제
	
	public void deleteMaterialById(String materialId)throws SQLException{
		dao.deleteMaterialById(materialId);
	}
	
	// 거래처로 검색
	
	public ArrayList<SupplierTO> selectMaterialSupplier() throws SQLException{
		return dao.selectMaterialSupplier();
	}
	

	
	//ID로 수정
	
	public void updateMaterial(MaterialTO mto) throws SQLException{
		dao.updateMaterial(mto);
	}
	
	//ID로 검색
	
	public MaterialTO selectMaterialById(String materialId) throws SQLException{
		return dao.selectMaterialById(materialId);
	}

	public ArrayList selectAllMaterial() throws SQLException {
		// TODO Auto-generated method stub
		return dao.selectAllMaterial();
	}
	

}
