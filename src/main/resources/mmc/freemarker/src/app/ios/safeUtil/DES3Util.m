//
//  DES3Util.m
//  text10
//
//  Created by ssp on 13-7-10.
//  Copyright (c) 2013年 ssp. All rights reserved.
//

#import "DES3Util.h"
#import <CommonCrypto/CommonCryptor.h>  
#import <commoncrypto/CommonDigest.h>
#import "GTMBase64.h"

#define gIv             @"01234567"

@implementation DES3Util


//@synthesize pKey;
//@synthesize mKey;

//初始化pKey和mKey
//+ (void)deskeyinit{
//    NSArray *arr = [NSArray arrayWithObjects:
//                    @"a",@"b",@"c",@"d",@"e",@"f",@"g",
//                    @"h",@"i",@"j",@"k",@"l",@"m",@"n",
//                    @"o",@"p",@"q",@"r",@"s",@"t",
//                    @"u",@"v",@"w",@"x",@"y",@"z",
//                    @"A",@"B",@"C",@"D",@"E",@"F",@"G",
//                    @"H",@"I",@"J",@"K",@"L",@"M",@"N",
//                    @"O",@"P",@"Q",@"R",@"S",@"T",
//                    @"U",@"V",@"W",@"X",@"Y",@"Z",
//                    @"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
////    pKey = nil;
//    pKey = @"";
//    for (int i = 0; i<24; i++) {
//        int index = arc4random() % [arr count];
//        [arr objectAtIndex:index];
//        pKey = [pKey stringByAppendingString:[arr objectAtIndex:index]];
//    }
//    NSLog(@"pKey = %@",pKey);
//
////    mKey = nil;
//    mKey = @"";
//    for (int i = 0; i<24; i++) {
//        int index = arc4random() % [arr count];
//        [arr objectAtIndex:index];
//        mKey = [mKey stringByAppendingString:[arr objectAtIndex:index]];
//    }
//    NSLog(@"mKey = %@",mKey);
//
//}
//
//+ (NSString *)getmobKey{
//    NSString *mobKey = [NSString stringWithFormat:@"%@%@",pKey,mKey];
//    NSLog(@"%@",mobKey);
//    
//    return mobKey;
//}

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText DESRandom:(NSString *)pkey{

    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    const void *vkey = (const void *) [pkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText DESRandom:(NSString *)pkey{
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [pkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    if (!result || result.length == 0) {
        
        //解密后的字符串为空，说明解密失败，返回未解密内容
        result = encryptText;
    }
    return result;
}  

////签名，验签
//+ (NSString*)qianming:(NSString*)plainText{
//    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//    size_t plainTextBufferSize = [data length];
//    const void *vplainText = (const void *)[data bytes];
//    
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    
//    const void *vkey = (const void *) [mKey UTF8String];
//    const void *vinitVec = (const void *) [gIv UTF8String];
//    
//    ccStatus = CCCrypt(kCCEncrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding,
//                       vkey,
//                       kCCKeySize3DES,
//                       vinitVec,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    
//    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//    NSString *result = [GTMBase64 stringByEncodingData:myData];
//    return result;
//}

@end