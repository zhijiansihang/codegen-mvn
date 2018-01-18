package ${javaPackage}.${project}.gen.entity;

import java.io.Serializable;
<#if requestGroups?has_content>
import java.util.List;
</#if>
import com.zhijiansihang.finger.mmc.entity.MobileMessage;

/**
 * ${description}.客户端请求
 * 
 * @author 代码生成器v1.0
 * 
 */
public class ${name}Request extends MobileMessage implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

<#list requestGroups as group>

	/**
	 * @see ${javaPackage}.${project}.gen.entity.${name}Request#get${group.id?cap_first}
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
		public ${field.javaType} get${field.id?cap_first}() {
			return ${field.id};
		}

		public void set${field.id?cap_first}(${field.javaType} ${field.id}) {
			this.${field.id} = ${field.id};
		}
	</#list>
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
		
		StringBuffer sb = new StringBuffer();
		<#list requestFields as field>
			<#if field.enc>
		sb.append("${field.id},");
			</#if>
		</#list>
		
		<#list requestGroups as group>
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
<#list requestFields as field>

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

	@Override
	public  Class getResponseClass(){
		return ${name}Response.class;
	}
	
	@Override
	public String getRequestUrl() {
		return "/${project}/app/${name?uncap_first}";
	}
	


}