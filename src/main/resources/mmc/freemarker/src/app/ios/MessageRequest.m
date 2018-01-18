//
//  MessageRequest.m
//
//  Created by 代码生成器1.0
//

#import "MessageRequest.h"
#import <objc/runtime.h>
#import "MessageResponse.h"
#import "DES3Util.h"
#import "RSA.h"
#import "MD5andBASE64.h"

@interface MessageRequest()
@end

@implementation MessageRequest

+ (id)request{
    MessageRequest *request = [[[self class]alloc]init];
    return request;
}

+ (NSString*)RA_type{
    NSAssert(0, @"子类必须重载%s", __FUNCTION__);
    return @"";
}

+ (Class)responseClass{
    NSAssert(0, @"子类必须重载%s", __FUNCTION__);
    return [MessageResponse class];
}

@end

