//
//  CFPSafeUtil.h
//  cfp-ios
//
//  Created by lvshaoli on 16/10/10.
//  Copyright © 2016年 zkbc. All rights reserved.
//
//DES(报文体) --->RSA（DES秘钥）--->RSA(全部)
#import <Foundation/Foundation.h>
#import "RSA.h"
#import "DES3Util.h"
@interface CFPSafeUtil : NSObject
+(NSString *)getSafeDESAndRSA:(NSString *) Msgbody DESRandom:(NSString *)random;

//DES解密
+(NSString *)getDESdecrypt:(NSString *)resultMsg DESRandom:(NSString *)random;

//加密随机数
+(NSString *)getRsaRandom:(NSString *)random;
@end
