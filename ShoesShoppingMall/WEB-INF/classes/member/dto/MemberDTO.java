package member.dto;

public class MemberDTO {

	private String id;
	private String password;
	private String name;
	private String registerNumber1;
	private String registerNumber2;
	private String tel;
	private String memberLevel;
	private int	   mileage;
	private String zipcode;
	private String address;
	private int    memberNum;
	public MemberDTO(){}
	public MemberDTO(String id, String password, String name,
			String registerNumber1, String registerNumber2, String tel,
			String memberLevel, int mileage, String zipcode, int memberNum,
			String address) {
		super();
		this.id = id;
		this.password = password;
		this.name = name;
		this.registerNumber1 = registerNumber1;
		this.registerNumber2 = registerNumber2;
		this.tel = tel;
		this.memberLevel = memberLevel;
		this.mileage = mileage;
		this.zipcode = zipcode;
		this.memberNum = memberNum;
		this.address = address;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRegisterNumber1() {
		return registerNumber1;
	}
	public void setRegisterNumber1(String registerNumber1) {
		this.registerNumber1 = registerNumber1;
	}
	public String getRegisterNumber2() {
		return registerNumber2;
	}
	public void setRegisterNumber2(String registerNumber2) {
		this.registerNumber2 = registerNumber2;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getMemberLevel() {
		return memberLevel;
	}
	public void setMemberLevel(String memberLevel) {
		this.memberLevel = memberLevel;
	}
	public int getMileage() {
		return mileage;
	}
	public void setMileage(int mileage) {
		this.mileage = mileage;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public int getMemberNum() {
		return memberNum;
	}
	public void setMemberNum(int memberNum) {
		this.memberNum = memberNum;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((address == null) ? 0 : address.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result
				+ ((memberLevel == null) ? 0 : memberLevel.hashCode());
		result = prime * result + memberNum;
		result = prime * result + mileage;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result
				+ ((password == null) ? 0 : password.hashCode());
		result = prime * result
				+ ((registerNumber1 == null) ? 0 : registerNumber1.hashCode());
		result = prime * result
				+ ((registerNumber2 == null) ? 0 : registerNumber2.hashCode());
		result = prime * result + ((tel == null) ? 0 : tel.hashCode());
		result = prime * result + ((zipcode == null) ? 0 : zipcode.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		MemberDTO other = (MemberDTO) obj;
		if (address == null) {
			if (other.address != null)
				return false;
		} else if (!address.equals(other.address))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (memberLevel == null) {
			if (other.memberLevel != null)
				return false;
		} else if (!memberLevel.equals(other.memberLevel))
			return false;
		if (memberNum != other.memberNum)
			return false;
		if (mileage != other.mileage)
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (password == null) {
			if (other.password != null)
				return false;
		} else if (!password.equals(other.password))
			return false;
		if (registerNumber1 == null) {
			if (other.registerNumber1 != null)
				return false;
		} else if (!registerNumber1.equals(other.registerNumber1))
			return false;
		if (registerNumber2 == null) {
			if (other.registerNumber2 != null)
				return false;
		} else if (!registerNumber2.equals(other.registerNumber2))
			return false;
		if (tel == null) {
			if (other.tel != null)
				return false;
		} else if (!tel.equals(other.tel))
			return false;
		if (zipcode == null) {
			if (other.zipcode != null)
				return false;
		} else if (!zipcode.equals(other.zipcode))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "MemberDTO [id=" + id + ", password=" + password + ", name="
				+ name + ", registerNumber1=" + registerNumber1
				+ ", registerNumber2=" + registerNumber2 + ", tel=" + tel
				+ ", memberLevel=" + memberLevel + ", mileage=" + mileage
				+ ", zipcode=" + zipcode + ", memberNum=" + memberNum
				+ ", address=" + address + "]";
	}
	
}
