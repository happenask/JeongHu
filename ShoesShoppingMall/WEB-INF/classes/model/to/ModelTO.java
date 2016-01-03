package model.to;

public class ModelTO {
	
	private int modelNum;
	private String modelHeel;
	private String modelLeather;
	private int modelPrice;
	private String modelName;
	private String modelType;
	
	public ModelTO(){ }

	public ModelTO(int modelNum, String modelHeel, String modelLeather,
			int modelPrice, String modelName, String modelType) {
		this.modelNum = modelNum;
		this.modelHeel = modelHeel;
		this.modelLeather = modelLeather;
		this.modelPrice = modelPrice;
		this.modelName = modelName;
		this.modelType = modelType;
	}

	public int getModelNum() {
		return modelNum;
	}

	public void setModelNum(int modelNum) {
		this.modelNum = modelNum;
	}

	public String getModelHeel() {
		return modelHeel;
	}

	public void setModelHeel(String modelHeel) {
		this.modelHeel = modelHeel;
	}

	public String getModelLeather() {
		return modelLeather;
	}

	public void setModelLeather(String modelLeather) {
		this.modelLeather = modelLeather;
	}

	public int getModelPrice() {
		return modelPrice;
	}

	public void setModelPrice(int modelPrice) {
		this.modelPrice = modelPrice;
	}

	public String getModelName() {
		return modelName;
	}

	public void setModelName(String modelName) {
		this.modelName = modelName;
	}

	public String getModelType() {
		return modelType;
	}

	public void setModelType(String modelType) {
		this.modelType = modelType;
	}

	@Override
	public String toString() {
		return "ModelTO [modelNum=" + modelNum + ", modelHeel=" + modelHeel
				+ ", modelLeather=" + modelLeather + ", modelPrice="
				+ modelPrice + ", modelName=" + modelName + ", modelType="
				+ modelType + "]";
	}

	
}
