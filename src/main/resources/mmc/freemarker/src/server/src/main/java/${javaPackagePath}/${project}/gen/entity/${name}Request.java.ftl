<#assign validatorImportMap = {
	"Null": "javax.validation.constraints.Null",
	"NotNull": "javax.validation.constraints.NotNull",
	"AssertTrue": "javax.validation.constraints.AssertTrue",
	"AssertFalse": "javax.validation.constraints.AssertFalse",
	"Min": "javax.validation.constraints.Min",
	"Max": "javax.validation.constraints.Max",
	"DecimalMin": "javax.validation.constraints.DecimalMin",
	"DecimalMax": "javax.validation.constraints.DecimalMax",
	"Digits": "javax.validation.constraints.Digits",
	"Past": "javax.validation.constraints.Past",
	"Future": "javax.validation.constraints.Future",
	"Pattern": "javax.validation.constraints.Pattern",
	"Email": "org.hibernate.validator.constraints.Email",
	"Length": "org.hibernate.validator.constraints.Length",
	"NotEmpty": "org.hibernate.validator.constraints.NotEmpty",
	"Range": "org.hibernate.validator.constraints.Range"
} />
package ${javaPackage}.${project}.gen.entity;
<#if requestGroups?has_content>
import java.util.List;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
</#if>

<#if requestFields?has_content || requestGroups?has_content>
	<#list validators as va>
import ${validatorImportMap[va]};
	</#list>
</#if>
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import ${javaPackage}.${project}.mmc.MobileMessage;

/**
 * ${description}.客户端请求
 * 
 * @author 代码生成器v1.0
 * 
 */
 @JsonIgnoreProperties(ignoreUnknown = true)
public class ${name}Request extends MobileMessage {

<#list requestGroups as group>

	/**
	 * @see ${javaPackage}.${project}.message.entity.${name}Request#get${group.id?cap_first}
	 * 
	 */
	public static class Element${group.id?cap_first} {

	<#list group.fields as field>
		private ${field.javaType} ${field.id};
	</#list>
	<#list group.fields as field>

		/**
		 * @return ${field.description}
		 */
		<#if field.vaId1?has_content>
		${field.vaId1}<#if field.vaParams1?has_content>(${field.vaParams1})</#if>
		</#if>
		<#if field.vaId2?has_content>
		${field.vaId2}<#if field.vaParams2?has_content>(${field.vaParams2})</#if>
		</#if>
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

<#list requestFields as field>
	private ${field.javaType} ${field.id};
</#list>
<#list requestGroups as group>
	private List<Element${group.id?cap_first}> ${group.id};
</#list>

	public ${name}Request() {
		super();
	}	
<#list requestFields as field>

	/**
	 * @return ${field.description}
	 */
	<#if field.vaId1?has_content>
	${field.vaId1}<#if field.vaParams1?has_content>(${field.vaParams1})</#if>
	</#if>
	<#if field.vaId2?has_content>
	${field.vaId2}<#if field.vaParams2?has_content>(${field.vaParams2})</#if>
	</#if>
	public ${field.javaType} get${field.id?cap_first}() {
		return ${field.id};
	}

	public void set${field.id?cap_first}(${field.javaType} ${field.id}) {
		this.${field.id} = ${field.id};
	}
</#list>
<#list requestGroups as group>

	/**
	 * @return ${group.description}
	 */
	public List<Element${group.id?cap_first}> get${group.id?cap_first}() {
		return ${group.id};
	}

	public void set${group.id?cap_first}(List<Element${group.id?cap_first}> ${group.id}) {
		this.${group.id} = ${group.id};
	}
</#list>
	
}