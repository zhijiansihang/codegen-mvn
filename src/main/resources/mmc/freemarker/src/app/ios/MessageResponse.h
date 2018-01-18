//
//  MessageResponse.h
//
//  Created by 代码生成器1.0
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageResponse : Message

+ (id)responseWithReponseData:(NSData*)responseData;
- (id)initWithReponseData:(NSData*)responseData;

//验签解密
-(id)validateSignAndDecWithPkey:(NSString*)pkey mkey:(NSString*)mkey;

@end
