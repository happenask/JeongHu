package supplier.model;

import java.sql.SQLException;
import java.util.ArrayList;

import supplier.to.SupplierTO;

public class SupplierService {
	
	private SupplierDAO dao;
	
	public SupplierService(SupplierDAO dao){
		this.dao = dao;
	}
	
	//거래처 등록 서비스
	public void insertSupplier(SupplierTO sto) throws Exception{
		
		//이미 등록된 거래처일 경우 예외발생
		String name = sto.getName();
		
		if (dao.selectSupplierByName(name) != null) {
			throw new Exception(sto.getName()+"는 이미 거래중인 거래처입니다.");
		}
		dao.insertSupplier(sto);
	}
	
	//거래처 삭제 서비스
	public void deleteSupplierByName(String name) throws SQLException{
		dao.deleteSupplierByName(name);
	}
	//거래처 검색 서비스
	public SupplierTO selectSupplierByName(String name) throws SQLException{
		return dao.selectSupplierByName(name);
	}
	//거래처 수정 서비스
	public void updateSupplier(SupplierTO sto) throws Exception{
		dao.updateSupplier(sto);
	}
	
	//거래처 전체 검색 서비스
	
	public ArrayList<SupplierTO> selectAllSupplier() throws SQLException {
		return dao.selectAllSupplier();
	}
}


