//
//  FuncodeUtil.m
//  tianchengtong
//
//  Created by zhoubin on 15/12/2.
//  Copyright © 2015年 zhoubin. All rights reserved.
//

#import "FuncodeUtil.h"

@interface FuncodeUtil()

@property (nonatomic, strong) NSDictionary *funcodeDict;
@end

@implementation FuncodeUtil

+(instancetype)shared{

    static FuncodeUtil *funcodeU = nil;
    static dispatch_once_t funcodeUOnceToken;
    
    dispatch_once(&funcodeUOnceToken, ^{
        if (!funcodeU) {
            
            funcodeU = [[self alloc] init];
            [funcodeU readFuncodeDictFromPlist];
        }
    });
    return funcodeU;
}

-(void)readFuncodeDictFromPlist{

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"funcode" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.funcodeDict = data;
}

-(NSArray *)getParamKeysByFuncode:(NSString *)funcode type:(NSString*)type{
    
    NSDictionary *funcodeParams = [self.funcodeDict objectForKey:funcode];
    if (!funcodeParams) {
        
        return nil;
    }
    
    NSString *paramKeysStr = [funcodeParams objectForKey:type];
    if (!paramKeysStr || paramKeysStr.length == 0) {
        
        return nil;
    }
    
    return [paramKeysStr componentsSeparatedByString:@","];
}

-(NSArray *)getRequestEncParamKeysByFuncode:(NSString *)funcode{

    return [self getParamKeysByFuncode:funcode type:@"reqEnc"];
}

-(NSArray *)getRequestSignParamKeysByFuncode:(NSString *)funcode{

    return [self getParamKeysByFuncode:funcode type:@"reqSign"];
}

-(NSArray *)getResponseDecParamKeysByFuncode:(NSString *)funcode{

    return [self getParamKeysByFuncode:funcode type:@"resDec"];
}

-(NSArray *)getResponseSignParamKeysByFuncode:(NSString *)funcode{

    return [self getParamKeysByFuncode:funcode type:@"resSign"];
}
@end
