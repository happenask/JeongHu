package member.model.dao;

import org.springframework.orm.ibatis.SqlMapClientTemplate;

import member.dto.AddressTO;
import member.dto.MemberDTO;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class MemberDAO {

	private SqlMapClientTemplate sqlMap;
	
	public MemberDAO(){
		
	}
	
	public MemberDAO(SqlMapClientTemplate sqlMap){
		this.sqlMap=sqlMap;
	}
	

	public MemberDTO selectMemberById(String id) {
		// TODO Auto-generated method stub

		System.out.println("안상근");
		return (MemberDTO) sqlMap.queryForObject("selectMemberById",id);
	}

	public ArrayList<AddressTO> searchAddressByDongName(String dong) {
		// TODO Auto-generated method stub
		System.out.println("dao안상근");
		return (ArrayList<AddressTO>) sqlMap.queryForList("selectAddressBydong",dong);
	}

	public MemberDTO selectMemberByRegisterNumber(String reg1, String reg2) {
		// TODO Auto-generated method stub
		System.out.println("dao주민번호");
		HashMap<String,String> map = new HashMap<String,String>();
		
		map.put("reg1", reg1);
		map.put("reg2", reg2);
		
		return (MemberDTO)sqlMap.queryForObject("selectMemberByRegisterNumber",map);
	}

	public int selectSeq() {
		// TODO Auto-generated method stub
		return (int) sqlMap.queryForObject("selectSquence");
	}

	public void insertMember(MemberDTO mto) {
		// TODO Auto-generated method stub
		sqlMap.insert("insertMember",mto);
	}

	public void updateMember(MemberDTO mto) {
		// TODO Auto-generated method stub
		sqlMap.update("updateMember",mto);
	}

	public void deleteMember(String id) {
		sqlMap.delete("deleteMemberById",id);
	}

	
}
