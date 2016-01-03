package product.to;

public class ProductTO {
	private String productId;
	private int price;
	private String heel;
	private String leather;
	private String acc1;
	private String acc2;
	private double size;
	private String message;
	
	public ProductTO(){	}
	public ProductTO(String productId, int price, String heel, String leather,
			String acc1, String acc2, double size, String message) {
		this.productId = productId;
		this.price = price;
		this.heel = heel;
		this.leather = leather;
		this.acc1 = acc1;
		this.acc2 = acc2;
		this.size = size;
		this.message = message;
	}
	public String getProductId() {
		return productId;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getHeel() {
		return heel;
	}
	public void setHeel(String heel) {
		this.heel = heel;
	}
	public String getLeather() {
		return leather;
	}
	public void setLeather(String leather) {
		this.leather = leather;
	}
	public String getAcc1() {
		return acc1;
	}
	public void setAcc1(String acc1) {
		this.acc1 = acc1;
	}
	public String getAcc2() {
		return acc2;
	}
	public void setAcc2(String acc2) {
		this.acc2 = acc2;
	}
	public double getSize() {
		return size;
	}
	public void setSize(double size) {
		this.size = size;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((acc1 == null) ? 0 : acc1.hashCode());
		result = prime * result + ((acc2 == null) ? 0 : acc2.hashCode());
		result = prime * result + ((heel == null) ? 0 : heel.hashCode());
		result = prime * result + ((leather == null) ? 0 : leather.hashCode());
		result = prime * result + ((message == null) ? 0 : message.hashCode());
		result = prime * result + price;
		result = prime * result
				+ ((productId == null) ? 0 : productId.hashCode());
		long temp;
		temp = Double.doubleToLongBits(size);
		result = prime * result + (int) (temp ^ (temp >>> 32));
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
		ProductTO other = (ProductTO) obj;
		if (acc1 == null) {
			if (other.acc1 != null)
				return false;
		} else if (!acc1.equals(other.acc1))
			return false;
		if (acc2 == null) {
			if (other.acc2 != null)
				return false;
		} else if (!acc2.equals(other.acc2))
			return false;
		if (heel == null) {
			if (other.heel != null)
				return false;
		} else if (!heel.equals(other.heel))
			return false;
		if (leather == null) {
			if (other.leather != null)
				return false;
		} else if (!leather.equals(other.leather))
			return false;
		if (message == null) {
			if (other.message != null)
				return false;
		} else if (!message.equals(other.message))
			return false;
		if (price != other.price)
			return false;
		if (productId == null) {
			if (other.productId != null)
				return false;
		} else if (!productId.equals(other.productId))
			return false;
		if (Double.doubleToLongBits(size) != Double
				.doubleToLongBits(other.size))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "ProductTO [productId=" + productId + ", price=" + price
				+ ", heel=" + heel + ", leather=" + leather + ", acc1=" + acc1
				+ ", acc2=" + acc2 + ", size=" + size + ", message=" + message
				+ "]";
	}
	
	
}
