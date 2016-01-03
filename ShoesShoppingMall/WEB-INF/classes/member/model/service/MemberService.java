package member.model.service;

import java.sql.SQLException;


import java.util.ArrayList;

import member.dto.AddressTO;
import member.dto.MemberDTO;
import member.model.dao.MemberDAO;

public class MemberService {
	
	private MemberDAO dao;
	
	public MemberService(){
		
	}
	
	public MemberService(MemberDAO dao){
		this.dao=dao;
	}
	
	public MemberDTO getMemberById(String id) throws SQLException{
		System.out.println(id);
		return dao.selectMemberById(id);
	}

	public ArrayList<AddressTO> getAddressByDongName(String dong) {
		// TODO Auto-generated method stub
		return dao.searchAddressByDongName(dong);
	}

	public MemberDTO getMemberByRegisterNumber(String registerNumber1, String registerNumber2) {
		// TODO Auto-generated method stub
		return dao.selectMemberByRegisterNumber(registerNumber1,registerNumber2);
	}

	public int getSeq() {
		// TODO Auto-generated method stub
		
		return dao.selectSeq();
	}

	public void joinMember(MemberDTO mto) {
		// TODO Auto-generated method stub
		dao.insertMember(mto);
	}
	
	public void updateMember(MemberDTO mto) {
		// TODO Auto-generated method stub
		dao.updateMember(mto);
	}

	public void dropMember(String id) {
		dao.deleteMember(id);
	}


	
}
