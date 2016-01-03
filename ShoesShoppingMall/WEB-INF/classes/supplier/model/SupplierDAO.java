package supplier.model;

import java.sql.SQLException;
import java.util.ArrayList;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import supplier.to.SupplierTO;

public class SupplierDAO {
	private SqlMapClientTemplate sqlmap;
	
	public SupplierDAO(SqlMapClientTemplate sqlmap){
		this.sqlmap = sqlmap;
	}
	
	public ArrayList<SupplierTO> selectAllSupplier() throws SQLException{
		return (ArrayList<SupplierTO>) sqlmap.queryForList("selectAllSupplier");
	}
	
	//거래처 등록
	public void insertSupplier(SupplierTO sto)throws SQLException{
		System.out.println(sto);
		sqlmap.insert("insertSupplier", sto);
	}
	
	//거래처 검색
	public SupplierTO selectSupplierByName(String name) throws SQLException{
		return (SupplierTO) sqlmap.queryForObject("selectSupplierByName",name);
	}
	
	//이름으로 거래처 삭제
	public void deleteSupplierByName(String name) {
		sqlmap.delete("deleteSupplierByName",name);
	}
	
	//거래처 수정
	public void updateSupplier(SupplierTO sto) {
		sqlmap.update("updateSupplier",sto);
	}
}
