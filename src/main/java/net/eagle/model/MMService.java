package net.eagle.model;

import java.util.List;

public class MMService {

	private String serviceName;
	private String serviceTitle;
	private String serviceDesc;
	private String needLogin;
	private String isLogin;
	private List<MMParam> requestParams;
	private List<MMParam> responseParams;
	
	public String getServiceName() {
		return serviceName;
	}
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
	public String getServiceTitle() {
		return serviceTitle;
	}
	public void setServiceTitle(String serviceTitle) {
		this.serviceTitle = serviceTitle;
	}
	public String getServiceDesc() {
		return serviceDesc;
	}
	public void setServiceDesc(String serviceDesc) {
		this.serviceDesc = serviceDesc;
	}
	public String getNeedLogin() {
		return needLogin;
	}
	public void setNeedLogin(String needLogin) {
		this.needLogin = needLogin;
	}
	public String getIsLogin() {
		return isLogin;
	}
	public void setIsLogin(String isLogin) {
		this.isLogin = isLogin;
	}
	public List<MMParam> getRequestParams() {
		return requestParams;
	}
	public void setRequestParams(List<MMParam> requestParams) {
		this.requestParams = requestParams;
	}
	public List<MMParam> getResponseParams() {
		return responseParams;
	}
	public void setResponseParams(List<MMParam> responseParams) {
		this.responseParams = responseParams;
	}

}
