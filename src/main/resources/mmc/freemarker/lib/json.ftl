<#function buildJson fields groups jtype>
	<#local json>
{
	"messageId":"${id}",
	"versionCode":"210"<#if fields?has_content || groups?has_content>,</#if>
		<#list fields as field>
	"${field.id}":<#if field.dbType == "varchar">"${field.valueExample!}"<#elseif field.valueExample?has_content>${field.valueExample}<#else>null</#if><#if field?has_next || groups?has_content>,</#if>
		</#list>
		<#list groups as group>
	"${group.id}":[
		{
			<#list group.fields as field>
			"${field.id}":<#if field.dbType == "varchar">"${field.valueExample!}"<#elseif field.valueExample?has_content>${field.valueExample}<#else>null</#if><#if field?has_next>,</#if>
			</#list>
		}
	]<#if group?has_next>,</#if>
		</#list>
}
	</#local>
	<#return json>
</#function>
