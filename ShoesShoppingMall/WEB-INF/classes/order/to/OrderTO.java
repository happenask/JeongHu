package order.to;

public class OrderTO {
	private String orderId;
	private int orderMember;
	private String orderProduct;
	private String orderDate;
	private String orderZipcode;
	private String orderAddress;
	private int orderLevel;
	private String orderMessage;
	
	public OrderTO(){}
	
	@Override
	public String toString() {
		return "OrderTO [orderId=" + orderId + ", orderMember=" + orderMember
				+ ", orderProduct=" + orderProduct + ", orderDate=" + orderDate
				+ ", orderZipcode=" + orderZipcode + ", orderAddress="
				+ orderAddress + ", orderLevel=" + orderLevel
				+ ", orderMessage=" + orderMessage + "]";
	}

	public OrderTO(String orderId, int orderMember, String orderProduct,
			String orderDate, String orderZipcode, String orderAddress,
			int orderLevel, String orderMessage) {
		this.orderId = orderId;
		this.orderMember = orderMember;
		this.orderProduct = orderProduct;
		this.orderDate = orderDate;
		this.orderZipcode = orderZipcode;
		this.orderAddress = orderAddress;
		this.orderLevel = orderLevel;
		this.orderMessage = orderMessage;
	}

	public String getOrderId() {
		return orderId;
	}
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}
	public int getOrderMember() {
		return orderMember;
	}
	public void setOrderMember(int orderMember) {
		this.orderMember = orderMember;
	}
	public String getOrderProduct() {
		return orderProduct;
	}
	public void setOrderProduct(String orderProduct) {
		this.orderProduct = orderProduct;
	}
	public String getOrderDate() {
		return orderDate;
	}
	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}
	public String getOrderZipcode() {
		return orderZipcode;
	}
	public void setOrderZipcode(String orderZipcode) {
		this.orderZipcode = orderZipcode;
	}
	public String getOrderAddress() {
		return orderAddress;
	}
	public void setOrderAddress(String orderAddress) {
		this.orderAddress = orderAddress;
	}
	public int getOrderLevel() {
		return orderLevel;
	}
	public void setOrderLevel(int orderLevel) {
		this.orderLevel = orderLevel;
	}
	public String getOrderMessage() {
		return orderMessage;
	}
	public void setOrderMessage(String orderMessage) {
		this.orderMessage = orderMessage;
	}
	
	
	
}
