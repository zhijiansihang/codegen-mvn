package net.zkbc.mmc.script.context;

import java.util.List;

public class MmcFieldGroup {

	private String id;
	private String description;
	private List<MmcField> fields;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public List<MmcField> getFields() {
		return fields;
	}

	public void setFields(List<MmcField> fields) {
		this.fields = fields;
	}
}
