package ${javaPackage}.${project}.gen.service;

<#if responseGroups?has_content>
import java.util.ArrayList;
import java.util.List;
</#if>

import ${javaPackage}.${project}.mmc.MessageService;
import ${javaPackage}.common.Response;
import ${javaPackage}.${project}.gen.entity.${name}Request;
import ${javaPackage}.${project}.gen.entity.${name}Response;
<#list responseGroups as group>
import ${javaPackage}.${project}.gen.entity.${name}Response.${group.id?cap_first}Element;
</#list>

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * ${description}
 * 
 */
@Component("gen${id}Service")
public class ${name}Service implements MessageService<${name}Request, Response<${name}Response>> {

	private static final Logger LOG = LoggerFactory.getLogger(${name}Service.class);
	private static final String SERVICE_DESC = "${description}";

	@Override
	public void execute(${name}Request request, Response<${name}Response> response) {
		LOG.info("[{}][request={}]", SERVICE_DESC, request);

	  <#list responseFields as field>
	    <#if field.javaType == 'String'>
		response.getBody().set${field.id?cap_first}("${field.valueExample?j_string}");
	    <#else>
		response.getBody().set${field.id?cap_first}(<#if field.valueExample?has_content>${field.valueExample}<#else>0</#if>);
	    </#if>
	  </#list>
	  <#list responseGroups as group>
		response.getBody().set${group.id?cap_first}(get${group.id?cap_first}());
	  </#list>
	  	//挡板服务标志，实现该服务时，不要给mode赋值了，把下边的代码删了
		response.getBody().setMode("test");
	}
<#list responseGroups as group>

	private List<${group.id?cap_first}Element> get${group.id?cap_first}() {
		List<${group.id?cap_first}Element> elems = new ArrayList<${group.id?cap_first}Element>();
		${group.id?cap_first}Element elem = new ${group.id?cap_first}Element();
		elems.add(elem);

	<#list group.fields as field>
		<#if field.javaType == 'String'>
		elem.set${field.id?cap_first}("${field.valueExample?j_string}");
		<#else>
		elem.set${field.id?cap_first}(<#if field.valueExample?has_content>${field.valueExample}<#else>0</#if>);
		</#if>
	</#list>

		return elems;
	}
</#list>
}
