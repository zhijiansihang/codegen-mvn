//
//  RSA.m
//  tianchengtong
//
//  Created by zhoubin on 15/12/1.
//  Copyright © 2015年 zhoubin. All rights reserved.
//

#import "RSA.h"
#import "MD5andBASE64.h"

@implementation RSA

//从证书取公钥
-(SecKeyRef)getPublicKey{
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"rsacert" ofType:@"der"];
    SecCertificateRef myCertificate = nil;
    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);//这个方法是验证该证书是否可信任 需要对签名证书进行验证的
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    return SecTrustCopyPublicKey(myTrust);
}

//加密
-(NSString *)RSAEncrypotoTheData:(NSString *)plainText
{
    SecKeyRef publicKey=nil;
    publicKey=[self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = NULL;
    
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = cipherBufferSize-11;  // 这个地方比较重要是加密问组长度
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = MIN(blockSize,[plainTextBytes length]-i*blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        kSecPaddingNone,//kSecPaddingPKCS1是随机类型 选择kSecPaddingNone类型就能保证每次加密出来的都一样了 否则的话 JAVA服务器读取出来会有摘要
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[NSData alloc]
                                      initWithBytes:(const void *)cipherBuffer
                                      length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    //    NSString *str = [[NSString alloc]initWithData:encryptedData encoding:NSUTF8StringEncoding];
    //    NSLog(@"str = %@",str);//这里用RSA加密出来只能是DATA STRING获取不到数值 打印出来是NULL
    //
    //    Byte *testByte = (Byte *)[encryptedData bytes];
    //
    //    for(int i=0;i<[encryptedData length];i++){
    //
    //        printf("i = %i,testByte = %d\n",i,testByte[i]);
    //    }
    //
    //    NSLog(@"%s",testByte);
    NSString *encrypotoResult=[NSString stringWithFormat:@"%@",[MD5andBASE64 encodeBase64Data:encryptedData]];
    
    return encrypotoResult;
}
@end
