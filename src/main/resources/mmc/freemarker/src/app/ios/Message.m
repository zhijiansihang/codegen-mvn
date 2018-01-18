//
//  Message.m
//
//  Created by 代码生成器1.0
//

#import "Message.h"

@interface Message ()

@end

@implementation Message

-(id)init {
    self = [super init];
    if ( self ) {
		self.context = [NSMutableDictionary new];
    }
    return self;
}

-(void)fromString:(NSString*)message {
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                          		 options:NSJSONReadingMutableContainers
                                      			   error:nil];
	if ([jsonObj isKindOfClass:[NSMutableDictionary class]]) {
		
		[self.context setValuesForKeysWithDictionary:jsonObj];
	} else {
		NSAssert1(NO, @"不正确的Json:%@", message);
	}
}

-(NSString*)toString {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.context
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(void)setStatusCode:(NSString*)value {
	self.context[C_STATUSCODE] = value;
}

-(NSString*)statusCode {
	return self.context[C_STATUSCODE];
}

-(void)setStatusMessage:(NSString*)value {
	self.context[C_STATUSMESSAGE] = value;
}

-(NSString*)statusMessage {
	return self.context[C_STATUSMESSAGE];
}

-(void)setSessionId:(NSString*)value {
	[self.context setValue:value forKey: C_SESSIONID];
}

-(NSString*)sessionId {
	return [self.context valueForKey: C_SESSIONID];
}

-(void)setPlatformType:(NSString *)value {
     [self.context setValue:value forKey: C_PLATFORMTYPE];
}

-(NSString*)platformType {
    return [self.context valueForKey: C_PLATFORMTYPE];
}

- (void) setChannelId:(NSString*)value{
	[self.context setValue:value forKey: C_CHANNELID];
}

- (NSString*) channelId{
	return [self.context valueForKey: C_CHANNELID];
}

-(void)setDeviceId:(NSString *)value {
     [self.context setValue:value forKey: C_DEVICEID];
}

-(NSString*)deviceId {
    return [self.context valueForKey: C_DEVICEID];
}

- (void) setVersionCode:(NSString*)value{
    [self.context setValue:value forKey: C_VERSIONCODE];
}
- (NSString*)versionCode{
    return [self.context valueForKey: C_VERSIONCODE];
}

- (void) setMsgtimestamp:(NSString*)value{
    [self.context setValue:value forKey: C_MSGTIMESTAMP];
}
- (NSString*)msgtimestamp{
    return [self.context valueForKey: C_MSGTIMESTAMP];
}

- (void) setMsgnonce:(NSString*)value{
    [self.context setValue:value forKey: C_MSGNONCE];
}
- (NSString*)msgnonce{
    return [self.context valueForKey: C_MSGNONCE];
}

- (void) setMsgsign:(NSString*)value{
    [self.context setValue:value forKey: C_MSGSIGN];
}
- (NSString*)msgsign{
    return [self.context valueForKey: C_MSGSIGN];
}

- (void) setMsgkey:(NSString*)value{
    [self.context setValue:value forKey: C_MSGKEY];
}
- (NSString*)msgkey{
    return [self.context valueForKey: C_MSGKEY];
}

- (void) setMsgeps:(NSString*)value{
    [self.context setValue:value forKey: C_MSGEPS];
}
- (NSString*)msgeps{
    return [self.context valueForKey: C_MSGEPS];
}
- (void) setOperationChannel:(NSString*)value{
    [self.context setValue:value forKey: C_OPERATIONCHANNEL];
}
- (NSString*)operationChannel{
    return [self.context valueForKey: C_OPERATIONCHANNEL];
}
- (void) setPackageName:(NSString*)value{
    [self.context setValue:value forKey: C_PACKAGENAME];
}
- (NSString*)packageName{
    return [self.context valueForKey: C_PACKAGENAME];
}
@end
