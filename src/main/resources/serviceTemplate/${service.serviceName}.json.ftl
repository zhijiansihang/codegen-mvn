<#function buildJson service>
	<#local json>
{
    "serviceName" : "${service.serviceName}",
    "serviceTitle" : "${service.serviceTitle?json_string}",
    "serviceDesc" : "${service.serviceDesc?json_string}",
    "needLogin" : "${service.needLogin}",
    "isLogin" : "${service.isLogin}",
    "requestParams" : [
        <#list service.requestParams as param>
            {
                "paramName" : "${param.paramName}",
                "paramDesc" : "${param.paramDesc?json_string}",
                "paramGroupName" : "${param.paramGroupName}",
                "paramGroupDesc" : "${param.paramGroupDesc?json_string}",
                "isEnc" : "${(param.isEnc)!"N"}",
                "exampleValue" : "${param.exampleValue?json_string}"
            }
        <#if param?has_next>,</#if>
        </#list>
        ],
    "responseParams" : [
        <#list service.responseParams as param>
            {
                "paramName" : "${param.paramName}",
                "paramDesc" : "${param.paramDesc?json_string}",
                "paramGroupName" : "${param.paramGroupName}",
                "paramGroupDesc" : "${param.paramGroupDesc?json_string}",
                "isEnc" : "${(param.isEnc)!"N"}",
                "exampleValue" : "${param.exampleValue?json_string}"
            }
        <#if param?has_next>,</#if>
        </#list>
        ]
}
	</#local>
	<#return json>
</#function>

${buildJson(service)}