//
//  CFPSafeUtil.m
//  cfp-ios
//
//  Created by lvshaoli on 16/10/10.
//  Copyright © 2016年 zkbc. All rights reserved.
//

#import "CFPSafeUtil.h"
#import "EncRequest.h"

@implementation CFPSafeUtil
+(NSString *)getSafeDESAndRSA:(NSString *) Msgbody DESRandom:(NSString *)random{
    NSString *str = [DES3Util encrypt:Msgbody DESRandom:random];
    EncRequest *encReq = [[EncRequest alloc]init];
    [encReq setKey:[self getRsaRandom:random]];
    [encReq setData:str];
//    NSString *json = [NSString stringWithFormat:@"{\"data\":\"%@\", \"key\":\"%@\"}", str, [self getRsaRandom:random]];
    NSString *json = [encReq toJSONString];
    RSA *rsa = [[RSA alloc] init];
    str = [rsa RSAEncrypotoTheData:json];

    return str;
}



+(NSString *)getRsaRandom:(NSString *)random{
    RSA *rsa = [[RSA alloc] init];
    //RSA加密随机数
    return [rsa RSAEncrypotoTheData:random];
}
+(NSString *)getDESdecrypt:(NSString *)resultMsg DESRandom:(NSString *)random{
    
    return [DES3Util decrypt:resultMsg DESRandom:random];
    
}
@end
