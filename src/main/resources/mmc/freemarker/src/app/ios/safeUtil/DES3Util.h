//
//  DES3Util.h
//  zhifuxitong
//
//  Created by ssp on 13-7-10.
//  Copyright (c) 2013年 ssp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject
//{
//    NSString *pKey;
//    NSString *mKey;
//}

//@property (strong,nonatomic) NSString *pKey;
//@property (strong,nonatomic) NSString *mKey;

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText DESRandom:(NSString *)pkey;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText DESRandom:(NSString *)pkey;

//签名
//+ (NSString*)qianming:(NSString*)plainText;

//key初始化
//+ (void)deskeyinit;

//pkey,mkey合并
//+ (NSString *)getmobKey;

@end
