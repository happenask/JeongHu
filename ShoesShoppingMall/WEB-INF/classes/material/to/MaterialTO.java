package material.to;

public class MaterialTO {
	private String materialId;
	private String type;
	private String name;
	private String spec;
	private String supplier;
	private int quantity;
	private int price;

	public MaterialTO() {}

	public String getMaterialId() {
		return materialId;
	}

	public void setMaterialId(String materialId) {
		this.materialId = materialId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSpec() {
		return spec;
	}

	public void setSpec(String spec) {
		this.spec = spec;
	}

	public String getSupplier() {
		return supplier;
	}

	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public MaterialTO(String materialId, String type, String name, String spec,
			String supplier, int quantity, int price) {
		super();
		this.materialId = materialId;
		this.type = type;
		this.name = name;
		this.spec = spec;
		this.supplier = supplier;
		this.quantity = quantity;
		this.price = price;
	}

	@Override
	public String toString() {
		return "MaterialTO [materialId=" + materialId + ", type=" + type
				+ ", name=" + name + ", spec=" + spec + ", supplier="
				+ supplier + ", quantity=" + quantity + ", price=" + price
				+ "]";
	}
	
	
}
