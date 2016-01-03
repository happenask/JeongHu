package category.to;

public class CategoryTO {
	private String productCategory;
	private String heel;
	private String leather;
	private String acc;
	
	public CategoryTO(){}
	
	public CategoryTO(String productCategory, String heel, String leather,
			String acc) {
		this.productCategory = productCategory;
		this.heel = heel;
		this.leather = leather;
		this.acc = acc;
	}

	public String getProductCategory() {
		return productCategory;
	}
	public void setProductCategory(String productCategory) {
		this.productCategory = productCategory;
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
	public String getAcc() {
		return acc;
	}
	public void setAcc(String acc) {
		this.acc = acc;
	}
	@Override
	public String toString() {
		return "CategoryTO [productCategory=" + productCategory + ", heel="
				+ heel + ", leather=" + leather + ", acc=" + acc + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((acc == null) ? 0 : acc.hashCode());
		result = prime * result + ((heel == null) ? 0 : heel.hashCode());
		result = prime * result + ((leather == null) ? 0 : leather.hashCode());
		result = prime * result
				+ ((productCategory == null) ? 0 : productCategory.hashCode());
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
		CategoryTO other = (CategoryTO) obj;
		if (acc == null) {
			if (other.acc != null)
				return false;
		} else if (!acc.equals(other.acc))
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
		if (productCategory == null) {
			if (other.productCategory != null)
				return false;
		} else if (!productCategory.equals(other.productCategory))
			return false;
		return true;
	}
	
}
