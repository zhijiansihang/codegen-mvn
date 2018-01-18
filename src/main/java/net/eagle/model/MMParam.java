package net.eagle.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class MMParam {
	private String paramName;
	private String paramDesc;
	private String paramGroupName;
	private String paramGroupDesc;
	private String isEnc;
	private String exampleValue;
	
	public String getParamName() {
		return paramName;
	}
	public void setParamName(String paramName) {
		this.paramName = paramName;
	}
	public String getParamDesc() {
		return paramDesc;
	}
	public void setParamDesc(String paramDesc) {
		this.paramDesc = paramDesc;
	}
	public String getParamGroupName() {
		return paramGroupName;
	}
	public void setParamGroupName(String paramGroupName) {
		this.paramGroupName = paramGroupName;
	}
	public String getParamGroupDesc() {
		return paramGroupDesc;
	}
	public void setParamGroupDesc(String paramGroupDesc) {
		this.paramGroupDesc = paramGroupDesc;
	}
	public String getExampleValue() {
		return exampleValue;
	}
	public void setExampleValue(String exampleValue) {
		this.exampleValue = exampleValue;
	}
	public String getIsEnc() {
		return isEnc;
	}
	public void setIsEnc(String isEnc) {
		this.isEnc = isEnc;
	}

}
