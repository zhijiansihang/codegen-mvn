//
//  ${iosPrefix}${name}Response.h
//  ${description}.响应报文
//
//  Created by 代码生成器1.0.
//
#import "MessageResponse.h"

<#list responseGroups as group>

@interface ${iosPrefix}${name}Element${group.id?cap_first} : Message
	<#list group.fields as field>
/**
 * ${field.description}
 */
-(void)set${field.id?cap_first}:(${field.objcType})value;
-(${field.objcType})${field.id};
	</#list>
@end
</#list>

@interface ${iosPrefix}${name}Response : MessageResponse
<#list responseFields as field>
/**
 * ${field.description}
 */
-(void)set${field.id?cap_first}:(${field.objcType})value;
-(${field.objcType})${field.id};
</#list>
<#list responseGroups as group>
/**
 * ${group.description}
 */
-(void)set${group.id?cap_first}:(NSArray*)value;
-(NSArray*)${group.id};
</#list>

@end


