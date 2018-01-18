package net.zkbc.mmc.script.context;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.util.StringUtils;

public class MmcMessage {

	private String id;
	private String description;
	private boolean encrypt;
	private boolean sign;
	private boolean anon;
	private boolean authcform;
	private List<MmcField> requestFields;
	private List<MmcFieldGroup> requestGroups;
	private List<MmcField> responseFields;
	private List<MmcFieldGroup> responseGroups;
	private MmcRoot root;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return StringUtils.capitalize(id);
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean isEncrypt() {
		return encrypt;
	}

	public void setEncrypt(boolean encrypt) {
		this.encrypt = encrypt;
	}

	public boolean isSign() {
		return sign;
	}

	public void setSign(boolean sign) {
		this.sign = sign;
	}

	public boolean isAnon() {
		return anon;
	}

	public void setAnon(boolean anon) {
		this.anon = anon;
	}

	public boolean isAuthcform() {
		return authcform;
	}

	public void setAuthcform(boolean autchcform) {
		this.authcform = autchcform;
	}

	public List<MmcField> getRequestFields() {
		return requestFields;
	}

	public void setRequestFields(List<MmcField> requestFields) {
		this.requestFields = requestFields;
	}

	public List<MmcFieldGroup> getRequestGroups() {
		return requestGroups;
	}

	public void setRequestGroups(List<MmcFieldGroup> requestGroups) {
		this.requestGroups = requestGroups;
	}

	public List<MmcField> getResponseFields() {
		return responseFields;
	}

	public void setResponseFields(List<MmcField> responseFields) {
		this.responseFields = responseFields;
	}

	public List<MmcFieldGroup> getResponseGroups() {
		return responseGroups;
	}

	public void setResponseGroups(List<MmcFieldGroup> responseGroups) {
		this.responseGroups = responseGroups;
	}

	public Set<String> getValidators() {
		Set<String> validators = new HashSet<String>();
//		for (MmcField field : requestFields) {
//			if (field.getVaId1() != null) {
//				validators.add(field.getVaId1().substring(1));
//			}
//			if (field.getVaId2() != null) {
//				validators.add(field.getVaId2().substring(1));
//			}
//		}
//		for (MmcFieldGroup group : requestGroups) {
//			for (MmcField field : group.getFields()) {
//				if (field.getVaId1() != null) {
//					validators.add(field.getVaId1().substring(1));
//				}
//				if (field.getVaId2() != null) {
//					validators.add(field.getVaId2().substring(1));
//				}
//			}
//		}

		return validators;
	}

	public String getJavaPackage() {
		return root.getJavaPackage();
	}

	public String getJavaPackagePath() {
		return root.getJavaPackagePath();
	}

	public String getProject() {
		return root.getProject();
	}
	
	public String getAndroidJavaPackage() {
		return root.getAndroidJavaPackage();
	}

	public String getAndroidJavaPackagePath() {
		return root.getAndroidJavaPackagePath();
	}

	public String getAndroidProject() {
		return root.getAndroidProject();
	}

	public String getIosPrefix() {
		return root.getIosPrefix();
	}

	public MmcMessage getMessage() {
		return this;
	}

	public MmcRoot getRoot() {
		return root;
	}

	public void setRoot(MmcRoot root) {
		this.root = root;
	}

}
