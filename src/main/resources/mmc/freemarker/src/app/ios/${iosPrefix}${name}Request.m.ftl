//
//  ${iosPrefix}${name}Request.m
//  ${description}.请求报文
//
//  Created by 代码生成器1.0.
//

#import "${iosPrefix}${name}Request.h"
#import "${iosPrefix}${name}Response.h"

<#list requestGroups as group>
	<#list group.fields as field>
#define C_${group.id?upper_case}_${field.id?upper_case}        @"${field.id}"
	</#list>

@interface ${iosPrefix}${name}Element${group.id?cap_first} ()

@end

@implementation ${iosPrefix}${name}Element${group.id?cap_first}

-(id)init {
    self = [super init];
    if ( self ) {
    }
    return self;
}

	<#list group.fields as field>
-(void)set${field.id?cap_first}:(${field.objcType})value {
	id objcValue;
		<#if field.objcType == "int">
	objcValue = [NSNumber numberWithInt: value];
		<#elseif field.objcType == "double">
	objcValue = [NSNumber numberWithDouble: value];
		<#else>
	objcValue = value;
		</#if>
	self.context[C_${group.id?upper_case}_${field.id?upper_case}] = objcValue;
}

-(${field.objcType}) ${field.id} {
	
		<#if field.objcType == "int">
	NSNumber *value = self.context[C_${group.id?upper_case}_${field.id?upper_case}];
	return [value intValue];
		<#elseif field.objcType == "double">
	NSNumber *value = self.context[C_${group.id?upper_case}_${field.id?upper_case}];
	return [value doubleValue];
		<#else>
	${field.objcType} value = self.context[C_${group.id?upper_case}_${field.id?upper_case}];
	return value;
		</#if>
}
	</#list>

@end
</#list>

<#list requestFields as field>
#define C_${field.id?upper_case}      @"${field.id}"
</#list>
<#list requestGroups as group>
#define C_${group.id?upper_case}      @"${group.id}"
</#list>


@implementation ${iosPrefix}${name}Request

+(Class)responseClass {    
    return [${iosPrefix}${name}Response class];
}

+(NSString*)RA_type {
    return @"/${project}/app/${id}";
}

-(id)init {
    self = [super init];
    if ( self ) {
    	NSMutableString *ms = [NSMutableString string];
    	
    	<#list requestFields as field>
			<#if field.enc>
		[ms appendString:[NSString stringWithFormat:@"%@,", C_${field.id?upper_case}]];
			</#if>
		</#list>
					
		<#list requestGroups as group>
			<#list group.fields as field>
				<#if field.enc>
		[ms appendString:[NSString stringWithFormat:@"%@>%@,", C_${group.id?upper_case}, C_${group.id?upper_case}_${field.id?upper_case}]];
				</#if>
			</#list>
		</#list>
		if([ms hasSuffix:@","]){
			ms = [ms substringToIndex:ms.length - 1];
		}
		[self setMsgeps:ms];
    }
    return self;
}

<#list requestFields as field>
-(void)set${field.id?cap_first}:(${field.objcType})value {
	id objcValue;
		<#if field.objcType == "int">
	objcValue = [NSNumber numberWithInt: value];
		<#elseif field.objcType == "double">
	objcValue = [NSNumber numberWithDouble: value];
		<#else>
	objcValue = value;
		</#if>
	self.context[C_${field.id?upper_case}] = objcValue;
}

-(${field.objcType})${field.id} {
		<#if field.objcType == "int">
	NSNumber *value = self.context[C_${field.id?upper_case}];
	return [value intValue];
		<#elseif field.objcType == "double">
	NSNumber *value = self.context[C_${field.id?upper_case}];
	return [value doubleValue];
		<#else>
	${field.objcType} value = self.context[C_${field.id?upper_case}];
	return value;
		</#if>
}
</#list>

<#list requestGroups as group>
-(void)set${group.id?cap_first}:(NSArray*)subList {
	NSMutableArray *newArray = [NSMutableArray new];
	
 	for (${iosPrefix}${name}Element${group.id?cap_first} *sub in subList) {
		[newArray addObject:sub.context];
	}
	self.context[C_${group.id?upper_case}] = newArray;
}

-(NSArray*)${group.id} {
	NSMutableArray *groupList = [NSMutableArray new];
	NSArray *subList = self.context[C_${group.id?upper_case}];
	
	for (NSMutableDictionary *subContext in subList) {
		${iosPrefix}${name}Element${group.id?cap_first} *newSubValue = [${iosPrefix}${name}Element${group.id?cap_first} new];
		
		[newSubValue.context setValuesForKeysWithDictionary:subContext];
		[groupList addObject:newSubValue];
	}
	
    return groupList;
}

</#list>
@end


