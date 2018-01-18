package net.zkbc.mmc.script.context;

import java.util.List;

public class MmcRoot {

	private String javaPackage;
	private String project;
	private String androidJavaPackage;
	private String androidProject;
	private String iosPrefix;
	private List<MmcMessage> messages;

	public String getJavaPackage() {
		return javaPackage;
	}

	public void setJavaPackage(String javaPackage) {
		this.javaPackage = javaPackage;
	}
	
	public String getJavaPackagePath() {
		return javaPackage.replaceAll("\\.", "/");
	}

	public String getProject() {
		return project;
	}

	public void setProject(String project) {
		this.project = project;
	}

	public List<MmcMessage> getMessages() {
		return messages;
	}

	public void setMessages(List<MmcMessage> messages) {
		this.messages = messages;
	}

	
	public String getAndroidJavaPackage() {
		return androidJavaPackage;
	}

	public void setAndroidJavaPackage(String androidJavaPackage) {
		this.androidJavaPackage = androidJavaPackage;
	}

	public String getAndroidJavaPackagePath() {
		return androidJavaPackage.replaceAll("\\.", "/");
	}

	public String getAndroidProject() {
		return androidProject;
	}

	public void setAndroidProject(String androidProject) {
		this.androidProject = androidProject;
	}

	public String getIosPrefix() {
		return iosPrefix.toUpperCase();
	}

	public void setIosPrefix(String iosPrefix) {
		this.iosPrefix = iosPrefix;
	}

}
