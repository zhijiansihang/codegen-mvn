package ${javaPackage}.${project}.gen.entity;
<#if responseGroups?has_content>

import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
</#if>

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import ${javaPackage}.${project}.mmc.MobileMessage;


/**
 * ${description}.服务端响应
 * 
 * @author 代码生成器v1.0
 * 
 */
@JsonInclude(Include.NON_NULL)
public class ${name}Response extends MobileMessage {

<#list responseGroups as group>

	/**
	 * @see ${javaPackage}.${project}.gen.entity.${name}Response#get${group.id?cap_first}
	 * 
	 */
	@JsonInclude(Include.NON_NULL)
	public static class ${group.id?cap_first}Element {

	<#list group.fields as field>
		private ${field.javaType} ${field.id};
	</#list>
	<#list group.fields as field>

		/**
		 * @return ${field.description}
		 */
		public ${field.javaType} get${field.id?cap_first}() {
			return ${field.id};
		}

		public void set${field.id?cap_first}(${field.javaType} ${field.id}) {
			this.${field.id} = ${field.id};
		}
	</#list>
	
		@Override
		public String toString() {
			String str = ToStringBuilder.reflectionToString(this, ToStringStyle.JSON_STYLE);
			return str;
		}
	}
</#list>

<#list responseFields as field>
	private ${field.javaType} ${field.id};
</#list>
<#list responseGroups as group>
	private List<${group.id?cap_first}Element> ${group.id};
</#list>

	public ${name}Response() {
		super();
		StringBuffer sb = new StringBuffer();
		<#list responseFields as field>
			<#if field.enc>
		sb.append("${field.id},");
			</#if>
		</#list>
		
		<#list responseGroups as group>
			<#list group.fields as field>
				<#if field.enc>
		sb.append("${group.id}>${field.id},");
				</#if>
			</#list>
		</#list>
		
		String eps = sb.toString();
		if(eps.endsWith(",")){
			eps = eps.substring(0, eps.length() - 1);
		}
		this.setMsgeps(eps);
	}

	public ${name}Response(String statusCode, String statusMessage) {
		this.setStatusCode(statusCode);
		this.setStatusMessage(statusMessage);
	}

<#list responseFields as field>

	/**
	 * @return ${field.description}
	 */
	public ${field.javaType} get${field.id?cap_first}() {
		return ${field.id};
	}

	public void set${field.id?cap_first}(${field.javaType} ${field.id}) {
		this.${field.id} = ${field.id};
	}
</#list>
<#list responseGroups as group>

	/**
	 * @return ${group.description}
	 */
	public List<${group.id?cap_first}Element> get${group.id?cap_first}() {
		return ${group.id};
	}

	public void set${group.id?cap_first}(List<${group.id?cap_first}Element> ${group.id}) {
		this.${group.id} = ${group.id};
	}
</#list>

}