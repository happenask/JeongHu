package force.to;

public class ForceTO {
	private String name;
	private String tableNum;
	private int foodNum;
	private int price;
	private String foodDate;
	public ForceTO() {
		super();
	}
	public ForceTO(String name, String tableNum, int foodNum, int price) {
		super();
		this.name = name;
		this.tableNum = tableNum;
		this.foodNum = foodNum;
		this.price = price;
	}
	
	public ForceTO(String name, String tableNum, int foodNum, int price,
			String foodDate) {
		super();
		this.name = name;
		this.tableNum = tableNum;
		this.foodNum = foodNum;
		this.price = price;
		this.foodDate = foodDate;
	}
	
	
	public String getFoodDate() {
		return foodDate;
	}
	public void setFoodDate(String foodDate) {
		this.foodDate = foodDate;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getTableNum() {
		return tableNum;
	}
	public void setTableNum(String tableNum) {
		this.tableNum = tableNum;
	}
	public int getFoodNum() {
		return foodNum;
	}
	public void setFoodNum(int foodNum) {
		this.foodNum = foodNum;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + foodNum;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + price;
		result = prime * result
				+ ((tableNum == null) ? 0 : tableNum.hashCode());
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
		ForceTO other = (ForceTO) obj;
		if (foodNum != other.foodNum)
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (price != other.price)
			return false;
		if (tableNum == null) {
			if (other.tableNum != null)
				return false;
		} else if (!tableNum.equals(other.tableNum))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "ForceTO [name=" + name + ", tableNum=" + tableNum
				+ ", foodNum=" + foodNum + ", price=" + price + ", foodDate="
				+ foodDate + "]";
	}
	
	
	
	
}
