//
//  Message.h
//
//  Created by 代码生成器1.0
//

#import <Foundation/Foundation.h>

#define C_STATUSCODE     @"statusCode"
#define C_STATUSMESSAGE  @"statusMessage"
#define C_SESSIONID      @"sessionId"
#define C_PLATFORMTYPE   @"platformType"
#define C_CHANNELID 	 @"channelId"
#define C_DEVICEID 		 @"deviceId"
#define C_VERSIONCODE    @"versionCode"
#define C_MSGTIMESTAMP   @"msgtimestamp"
#define C_MSGNONCE       @"msgnonce"
#define C_MSGSIGN        @"msgsign"
#define C_MSGKEY         @"msgkey"
#define C_MSGEPS         @"msgeps"

#define C_OPERATIONCHANNEL  @"operationChannel"
//app包名称
#define C_PACKAGENAME @"packageName"
@interface Message : NSObject

@property(nonatomic, strong) NSMutableDictionary *context;

- (void) fromString:(NSString*)message;
- (NSString*) toString;
- (void)setStatusCode:(NSString*)value;
- (NSString*)statusCode;
- (void)setStatusMessage:(NSString*)value;
- (NSString*)statusMessage;
- (void) setSessionId:(NSString*)value;
- (NSString*) sessionId;
- (void) setPlatformType:(NSString*)value;
- (NSString*) platformType;
- (void) setChannelId:(NSString*)value;
- (NSString*) channelId;
- (void) setDeviceId:(NSString*)value;
- (NSString*) deviceId;
- (void) setVersionCode:(NSString*)value;
- (NSString*)versionCode;
- (void) setMsgtimestamp:(NSString*)value;
- (NSString*)msgtimestamp;
- (void) setMsgnonce:(NSString*)value;
- (NSString*)msgnonce;
- (void) setMsgsign:(NSString*)value;
- (NSString*)msgsign;
- (void) setMsgkey:(NSString*)value;
- (NSString*)msgkey;
- (void) setMsgeps:(NSString*)value;
- (NSString*)msgeps;
- (void) setOperationChannel:(NSString*)value;
- (NSString*)operationChannel;
- (void) setPackageName:(NSString*)value;
- (NSString*)packageName;
@end
